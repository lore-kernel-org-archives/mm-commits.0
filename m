From: akpm@linux-foundation.org
Subject: [to-be-updated] ipc-mqueue-add-rbtree-node-caching-support.patch removed from -mm tree
Date: Wed, 16 May 2012 16:18:36 -0700
Message-ID: <20120516231836.CEF79A0397@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:44073 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab2EPXSj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 19:18:39 -0400
Received: by bkty5 with SMTP id y5so64170bkt.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 16:18:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dledford@redhat.com, fweisbec@gmail.com, kosaki.motohiro@jp.fujitsu.com, manfred@colorfullife.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: add rbtree node caching support
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-add-rbtree-node-caching-support.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Doug Ledford <dledford@redhat.com>
Subject: ipc/mqueue: add rbtree node caching support

When I wrote the first patch that added the rbtree support for message
queue insertion, it sped up the case where the queue was very full
drastically from the original code.  It, however, slowed down the case
where the queue was empty (not drastically though).

This patch caches the last freed rbtree node struct so we can quickly
reuse it when we get a new message.  This is the common path for any queue
that very frequently goes from 0 to 1 then back to 0 messages in queue.

Andrew Morton didn't like that we were doing a GFP_ATOMIC allocation in
msg_insert, so this patch attempts to speculatively allocate a new node
struct outside of the spin lock when we know we need it, but will still
fall back to a GFP_ATOMIC allocation if it has to.

Once I added the caching, the necessary various ret = ; spin_unlock
gyrations in mq_timedsend were getting pretty ugly, so this also slightly
refactors that function to streamline the flow of the code and the
function exit.

Finally, while working on getting performance back I made sure that all of
the node structs were always fully initialized when they were first used,
rendering the use of kzalloc unnecessary and a waste of CPU cycles.

The net result of all of this is:

1) We will avoid a GFP_ATOMIC allocation when possible, but fall back
   on it when necessary.

2) We will speculatively allocate a node struct using GFP_KERNEL if our
   cache is empty (and save the struct to our cache if it's still empty
   after we have obtained the spin lock).

3) The performance of the common queue empty case has significantly
   improved and is now much more in line with the older performance for
   this case.

The performance changes are:

            Old mqueue      new mqueue      new mqueue + caching
queue empty
send/recv   305/288ns       349/318ns       310/322ns

I don't think we'll ever be able to get the recv performance back, but
that's because the old recv performance was a direct result and
consequence of the old methods abysmal send performance.  The recv path
simply must do more so that the send path does not incur such a penalty
under higher queue depths.

As it turns out, the new caching code also sped up the various queue full
cases relative to my last patch.  That could be because of the difference
between the syscall path in 3.3.4-rc5 and 3.3.4-rc6, or because of the
change in code flow in the mq_timedsend routine.  Regardless, I'll take
it.  It wasn't huge, and I *would* say it was within the margin for error,
but after many repeated runs what I'm seeing is that the old numbers trend
slightly higher (about 10 to 20ns depending on which test is the one
running).

[akpm@linux-foundation.org: fix msg_insert new_leaf handling, per Stephen]
[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: simplify msg_insert()]
Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |  120 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 92 insertions(+), 28 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-add-rbtree-node-caching-support ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-add-rbtree-node-caching-support
+++ a/ipc/mqueue.c
@@ -69,6 +69,7 @@ struct mqueue_inode_info {
 	wait_queue_head_t wait_q;
 
 	struct rb_root msg_tree;
+	struct posix_msg_tree_node *node_cache;
 	struct mq_attr attr;
 
 	struct sigevent notify;
@@ -117,7 +118,8 @@ static struct ipc_namespace *get_ns_from
 }
 
 /* Auxiliary functions to manipulate messages' list */
-static int msg_insert(struct msg_msg *msg, struct mqueue_inode_info *info)
+static int msg_insert(struct msg_msg *msg, struct mqueue_inode_info *info,
+		      struct posix_msg_tree_node **new_leaf)
 {
 	struct rb_node **p, *parent = NULL;
 	struct posix_msg_tree_node *leaf;
@@ -134,15 +136,25 @@ static int msg_insert(struct msg_msg *ms
 		else
 			p = &(*p)->rb_right;
 	}
-	leaf = kzalloc(sizeof(*leaf), GFP_ATOMIC);
-	if (!leaf)
-		return -ENOMEM;
-	rb_init_node(&leaf->rb_node);
-	INIT_LIST_HEAD(&leaf->msg_list);
+	if (info->node_cache) {
+		leaf = info->node_cache;
+		info->node_cache = NULL;
+	} else {
+		if (*new_leaf) {
+			leaf = *new_leaf;
+			*new_leaf = NULL;
+		} else {
+			leaf = kmalloc(sizeof(*leaf), GFP_ATOMIC);
+			if (!leaf)
+				return -ENOMEM;
+		}
+		rb_init_node(&leaf->rb_node);
+		INIT_LIST_HEAD(&leaf->msg_list);
+		info->qsize += sizeof(*leaf);
+	}
 	leaf->priority = msg->m_type;
 	rb_link_node(&leaf->rb_node, parent, p);
 	rb_insert_color(&leaf->rb_node, &info->msg_tree);
-	info->qsize += sizeof(struct posix_msg_tree_node);
 insert_msg:
 	info->attr.mq_curmsgs++;
 	info->qsize += msg->m_ts;
@@ -182,8 +194,12 @@ try_again:
 			     "empty leaf node but we haven't implemented "
 			     "lazy leaf delete!\n");
 		rb_erase(&leaf->rb_node, &info->msg_tree);
-		info->qsize -= sizeof(struct posix_msg_tree_node);
-		kfree(leaf);
+		if (info->node_cache) {
+			info->qsize -= sizeof(*leaf);
+			kfree(leaf);
+		} else {
+			info->node_cache = leaf;
+		}
 		goto try_again;
 	} else {
 		msg = list_first_entry(&leaf->msg_list,
@@ -191,8 +207,12 @@ try_again:
 		list_del(&msg->m_list);
 		if (list_empty(&leaf->msg_list)) {
 			rb_erase(&leaf->rb_node, &info->msg_tree);
-			info->qsize -= sizeof(struct posix_msg_tree_node);
-			kfree(leaf);
+			if (info->node_cache) {
+				info->qsize -= sizeof(*leaf);
+				kfree(leaf);
+			} else {
+				info->node_cache = leaf;
+			}
 		}
 	}
 	info->attr.mq_curmsgs--;
@@ -235,6 +255,7 @@ static struct inode *mqueue_get_inode(st
 		info->qsize = 0;
 		info->user = NULL;	/* set when all is ok */
 		info->msg_tree = RB_ROOT;
+		info->node_cache = NULL;
 		memset(&info->attr, 0, sizeof(info->attr));
 		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max,
 					   ipc_ns->mq_msg_default);
@@ -367,6 +388,7 @@ static void mqueue_evict_inode(struct in
 	spin_lock(&info->lock);
 	while ((msg = msg_get(info)) != NULL)
 		free_msg(msg);
+	kfree(info->node_cache);
 	spin_unlock(&info->lock);
 
 	/* Total amount of bytes accounted for the mqueue */
@@ -934,7 +956,8 @@ static inline void pipelined_send(struct
 
 /* pipelined_receive() - if there is task waiting in sys_mq_timedsend()
  * gets its message and put to the queue (we have one free place for sure). */
-static inline void pipelined_receive(struct mqueue_inode_info *info)
+static inline void pipelined_receive(struct mqueue_inode_info *info,
+				     struct posix_msg_tree_node **new_leaf)
 {
 	struct ext_wait_queue *sender = wq_get_first_waiter(info, SEND);
 
@@ -943,7 +966,7 @@ static inline void pipelined_receive(str
 		wake_up_interruptible(&info->wait_q);
 		return;
 	}
-	if (msg_insert(sender->msg, info))
+	if (msg_insert(sender->msg, info, new_leaf))
 		return;
 	list_del(&sender->list);
 	sender->state = STATE_PENDING;
@@ -964,7 +987,8 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 	struct mqueue_inode_info *info;
 	ktime_t expires, *timeout = NULL;
 	struct timespec ts;
-	int ret;
+	struct posix_msg_tree_node *new_leaf = NULL;
+	int ret = 0;
 
 	if (u_abs_timeout) {
 		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
@@ -1012,39 +1036,59 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 	msg_ptr->m_ts = msg_len;
 	msg_ptr->m_type = msg_prio;
 
+	/*
+	 * msg_insert really wants us to have a valid, spare node struct so it
+	 * doesn't have to kmalloc a GFP_ATOMIC allocation, but it will fall
+	 * back to that if necessary.
+	 */
+	if (!info->node_cache)
+		new_leaf = kmalloc(sizeof(*new_leaf), GFP_KERNEL);
+
 	spin_lock(&info->lock);
 
+	if (!info->node_cache && new_leaf) {
+		/* Save our speculative allocation into the cache */
+		rb_init_node(&new_leaf->rb_node);
+		INIT_LIST_HEAD(&new_leaf->msg_list);
+		info->node_cache = new_leaf;
+		info->qsize += sizeof(*new_leaf);
+		new_leaf = NULL;
+	}
+
 	if (info->attr.mq_curmsgs == info->attr.mq_maxmsg) {
-		if (filp->f_flags & O_NONBLOCK) {
-			spin_unlock(&info->lock);
+		if (filp->f_flags & O_NONBLOCK)
 			ret = -EAGAIN;
-		} else {
+		else {
 			wait.task = current;
 			wait.msg = (void *) msg_ptr;
 			wait.state = STATE_NONE;
 			ret = wq_sleep(info, SEND, timeout, &wait);
+			/*
+			 * wq_sleep must be called with info->lock held, and
+			 * returns with the lock released
+			 */
+			goto out_free;
 		}
-		if (ret < 0)
-			free_msg(msg_ptr);
 	} else {
 		receiver = wq_get_first_waiter(info, RECV);
 		if (receiver) {
 			pipelined_send(info, msg_ptr, receiver);
 		} else {
 			/* adds message to the queue */
-			if (msg_insert(msg_ptr, info)) {
-				free_msg(msg_ptr);
-				ret = -ENOMEM;
-				spin_unlock(&info->lock);
-				goto out_fput;
-			}
+			ret = msg_insert(msg_ptr, info, &new_leaf);
+			if (ret)
+				goto out_unlock;
 			__do_notify(info);
 		}
 		inode->i_atime = inode->i_mtime = inode->i_ctime =
 				CURRENT_TIME;
-		spin_unlock(&info->lock);
-		ret = 0;
 	}
+out_unlock:
+	spin_unlock(&info->lock);
+out_free:
+	kfree(new_leaf);
+	if (ret)
+		free_msg(msg_ptr);
 out_fput:
 	fput(filp);
 out:
@@ -1063,6 +1107,7 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
 	struct ext_wait_queue wait;
 	ktime_t expires, *timeout = NULL;
 	struct timespec ts;
+	struct posix_msg_tree_node *new_leaf = NULL;
 
 	if (u_abs_timeout) {
 		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
@@ -1098,7 +1143,25 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
 		goto out_fput;
 	}
 
+	/*
+	 * msg_insert really wants us to have a valid, spare node struct so it
+	 * doesn't have to kmalloc a GFP_ATOMIC allocation, but it will fall
+	 * back to that if necessary.
+	 */
+	if (!info->node_cache)
+		new_leaf = kmalloc(sizeof(*new_leaf), GFP_KERNEL);
+
 	spin_lock(&info->lock);
+
+	if (!info->node_cache && new_leaf) {
+		/* Save our speculative allocation into the cache */
+		rb_init_node(&new_leaf->rb_node);
+		INIT_LIST_HEAD(&new_leaf->msg_list);
+		info->node_cache = new_leaf;
+		info->qsize += sizeof(*new_leaf);
+		new_leaf = NULL;
+	}
+
 	if (info->attr.mq_curmsgs == 0) {
 		if (filp->f_flags & O_NONBLOCK) {
 			spin_unlock(&info->lock);
@@ -1116,7 +1179,7 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
 				CURRENT_TIME;
 
 		/* There is now free space in queue. */
-		pipelined_receive(info);
+		pipelined_receive(info, &new_leaf);
 		spin_unlock(&info->lock);
 		ret = 0;
 	}
@@ -1129,6 +1192,7 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
 		}
 		free_msg(msg_ptr);
 	}
+	kfree(new_leaf);
 out_fput:
 	fput(filp);
 out:
_

Patches currently in -mm which might be from dledford@redhat.com are

ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch
mqueue-revert-bump-up-dflt_max.patch
mqueue-dont-use-kmalloc-with-kmalloc_max_size.patch
mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch
selftests-add-mq_open_tests.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-improve-performance-of-send-recv-use-correct-gfp-flags-in-msg_insert.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch

