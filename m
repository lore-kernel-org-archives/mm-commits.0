From: akpm@linux-foundation.org
Subject: + ipc-mqueue-improve-performance-of-send-recv.patch added to -mm tree
Date: Tue, 01 May 2012 12:36:44 -0700
Message-ID: <20120501193644.95657A0444@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61161 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2EATgp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 15:36:45 -0400
Received: by yenq2 with SMTP id q2so502598yen.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 12:36:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dledford@redhat.com, manfred@colorfullife.com, sfr@canb.auug.org.au


The patch titled
     Subject: ipc/mqueue: improve performance of send/recv
has been added to the -mm tree.  Its filename is
     ipc-mqueue-improve-performance-of-send-recv.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Doug Ledford <dledford@redhat.com>
Subject: ipc/mqueue: improve performance of send/recv

The existing implementation of the POSIX message queue send and recv
functions is, well, abysmal.  Even worse than abysmal.  I submitted a
patch to increase the maximum POSIX message queue limit to 65536 due to
customer needs, however, upon looking over the send/recv implementation, I
realized that my customer needs help with that too even if they don't know
it.  The basic problem is that, given the fairly typical use case scenario
for a large queue of queueing lots of messages all at the same priority (I
verified with my customer that this is indeed what their app does), the
msg_insert routine is basically a frikkin' bubble sort.  I mean, whoa,
that's *so* middle school.

OK, OK, to not slam the original author too much, I'm sure they didn't
envision a queue depth of 50,000+ messages.  No one would think that
moving elements in an array, one at a time, and dereferencing each pointer
in that array to check priority of the message being pointed too, again
one at a time, for 50,000+ times would be good.  So let's assume that, as
is typical, the users have found a way to break our code simply by using
it in a way we didn't envision.  Fair enough.

"So, just how broken is it?", you ask.  I wondered the same thing, so I
wrote an app to let me know.  It's my next patch.  It gave me some
interesting results.  Here's what it tested:

Interference with other apps - In continuous mode, the app just sits there
and hits a message queue forever, while you go do something productive on
another terminal using other CPUs.  You then measure how long it takes you
to do that something productive.  Then you restart the app in fake
continuous mode, and it sits in a tight loop on a CPU while you repeat
your tests.  The whole point of this is to keep one CPU tied up (so it
can't be used in your other work) but in one case tied up hitting the
mqueue code so we can see the effect of walking that 65,528 element array
one pointer at a time on the global CPU cache.  If it's bad, then it will
slow down your app on the other CPUs just by polluting cache mercilessly. 
In the fake case, it will be in a tight loop, but not polluting cache. 
Testing the mqueue subsystem directly - Here we just run a number of tests
to see how the mqueue subsystem performs under different conditions.  A
couple conditions are known to be worst case for the old system, and some
routines, so this tests all of them.

So, on to the results already:

Subsystem/Test                  Old                         New

Time to compile linux
kernel (make -j12 on a
6 core CPU)
  Running mqueue test     user 49m10.744s             user 45m26.294s
			   sys  5m51.924s              sys  4m59.894s
			 total 55m02.668s            total 50m26.188s

  Running fake test       user 45m32.686s             user 45m18.552s
                           sys  5m12.465s              sys  4m56.468s
                         total 50m45.151s            total 50m15.020s

  % slowdown from mqueue
    cache thrashing            ~8%                         ~.5%

Avg time to send/recv (in nanoseconds per message)
  when queue empty            305/288                    349/318
  when queue full (65528 messages)
    constant priority      526589/823                    362/314
    increasing priority    403105/916                    495/445
    decreasing priority     73420/594                    482/409
    random priority        280147/920                    546/436

Time to fill/drain queue (65528 messages, in seconds)
  constant priority         17.37/.12                    .13/.12
  increasing priority        4.14/.14                    .21/.18
  decreasing priority       12.93/.13                    .21/.18
  random priority            8.88/.16                    .22/.17

So, I think the results speak for themselves.  It's possible this
implementation could be improved by cacheing at least one priority level
in the node tree (that would bring the queue empty performance more in
line with the old implementation), but this works and is *so* much better
than what we had, especially for the common case of a single priority in
use, that further refinements can be in follow on patches.

Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |  173 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 130 insertions(+), 43 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-improve-performance-of-send-recv ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-improve-performance-of-send-recv
+++ a/ipc/mqueue.c
@@ -50,6 +50,12 @@
 #define STATE_PENDING	1
 #define STATE_READY	2
 
+struct posix_msg_tree_node {
+	struct rb_node		rb_node;
+	struct list_head	msg_list;
+	int			priority;
+};
+
 struct ext_wait_queue {		/* queue of sleeping tasks */
 	struct task_struct *task;
 	struct list_head list;
@@ -62,7 +68,7 @@ struct mqueue_inode_info {
 	struct inode vfs_inode;
 	wait_queue_head_t wait_q;
 
-	struct msg_msg **messages;
+	struct rb_root msg_tree;
 	struct mq_attr attr;
 
 	struct sigevent notify;
@@ -109,6 +115,90 @@ static struct ipc_namespace *get_ns_from
 	return ns;
 }
 
+/* Auxiliary functions to manipulate messages' list */
+static int msg_insert(struct msg_msg *msg, struct mqueue_inode_info *info)
+{
+	struct rb_node **p, *parent = NULL;
+	struct posix_msg_tree_node *leaf;
+
+	p = &info->msg_tree.rb_node;
+	while (*p) {
+		parent = *p;
+		leaf = rb_entry(parent, struct posix_msg_tree_node, rb_node);
+
+		if (likely(leaf->priority == msg->m_type))
+			goto insert_msg;
+		else if (msg->m_type < leaf->priority)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	};
+	leaf = kzalloc(sizeof(struct posix_msg_tree_node), GFP_KERNEL);
+	if (!leaf)
+		return -ENOMEM;
+	rb_init_node(&leaf->rb_node);
+	INIT_LIST_HEAD(&leaf->msg_list);
+	leaf->priority = msg->m_type;
+	rb_link_node(&leaf->rb_node, parent, p);
+	rb_insert_color(&leaf->rb_node, &info->msg_tree);
+	info->qsize += sizeof(struct posix_msg_tree_node);
+insert_msg:
+	info->attr.mq_curmsgs++;
+	info->qsize += msg->m_ts;
+	list_add_tail(&msg->m_list, &leaf->msg_list);
+	return 0;
+}
+
+static inline struct msg_msg *msg_get(struct mqueue_inode_info *info)
+{
+	struct rb_node **p, *parent = NULL;
+	struct posix_msg_tree_node *leaf;
+	struct msg_msg *msg;
+
+try_again:
+	p = &info->msg_tree.rb_node;
+	while (*p) {
+		parent = *p;
+		/*
+		 * During insert, low priorities fo to the left and high to
+		 * the right.  On receive, we want the highest priorities
+		 * first, so walk all the way to the right.
+		 */
+		p = &(*p)->rb_right;
+	}
+	if (!parent) {
+		if (info->attr.mq_curmsgs) {
+			pr_warn_once("Inconsistency in POSIX message queue, "
+				     "no tree element, but supposedly messages "
+				     "should exist!\n");
+			info->attr.mq_curmsgs = 0;
+		}
+		return NULL;
+	}
+	leaf = rb_entry(parent, struct posix_msg_tree_node, rb_node);
+	if (list_empty(&leaf->msg_list)) {
+		pr_warn_once("Inconsistency in POSIX message queue, "
+			     "empty leaf node but we haven't implemented "
+			     "lazy leaf delete!\n");
+		rb_erase(&leaf->rb_node, &info->msg_tree);
+		info->qsize -= sizeof(struct posix_msg_tree_node);
+		kfree(leaf);
+		goto try_again;
+	} else {
+		msg = list_first_entry(&leaf->msg_list,
+				       struct msg_msg, m_list);
+		list_del(&msg->m_list);
+		if (list_empty(&leaf->msg_list)) {
+			rb_erase(&leaf->rb_node, &info->msg_tree);
+			info->qsize -= sizeof(struct posix_msg_tree_node);
+			kfree(leaf);
+		}
+	}
+	info->attr.mq_curmsgs--;
+	info->qsize -= msg->m_ts;
+	return msg;
+}
+
 static struct inode *mqueue_get_inode(struct super_block *sb,
 		struct ipc_namespace *ipc_ns, umode_t mode,
 		struct mq_attr *attr)
@@ -129,7 +219,7 @@ static struct inode *mqueue_get_inode(st
 
 	if (S_ISREG(mode)) {
 		struct mqueue_inode_info *info;
-		unsigned long mq_bytes, mq_msg_tblsz;
+		unsigned long mq_bytes, mq_treesize;
 
 		inode->i_fop = &mqueue_file_operations;
 		inode->i_size = FILENT_SIZE;
@@ -142,6 +232,7 @@ static struct inode *mqueue_get_inode(st
 		info->notify_owner = NULL;
 		info->qsize = 0;
 		info->user = NULL;	/* set when all is ok */
+		info->msg_tree = RB_ROOT;
 		memset(&info->attr, 0, sizeof(info->attr));
 		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max,
 					   ipc_ns->mq_msg_default);
@@ -151,16 +242,25 @@ static struct inode *mqueue_get_inode(st
 			info->attr.mq_maxmsg = attr->mq_maxmsg;
 			info->attr.mq_msgsize = attr->mq_msgsize;
 		}
-		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
-		if (mq_msg_tblsz > PAGE_SIZE)
-			info->messages = vmalloc(mq_msg_tblsz);
-		else
-			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
-		if (!info->messages)
-			goto out_inode;
+		/*
+		 * We used to allocate a static array of pointers and account
+		 * the size of that array as well as one msg_msg struct per
+		 * possible message into the queue size. That's no longer
+		 * accurate as the queue is now an rbtree and will grow and
+		 * shrink depending on usage patterns.  We can, however, still
+		 * account one msg_msg struct per message, but the nodes are
+		 * allocated depending on priority usage, and most programs
+		 * only use one, or a handful, of priorities.  However, since
+		 * this is pinned memory, we need to assume worst case, so
+		 * that means the min(mq_maxmsg, max_priorities) * struct
+		 * posix_msg_tree_node.
+		 */
+		mq_treesize = info->attr.mq_maxmsg * sizeof(struct msg_msg) +
+			min_t(unsigned int, info->attr.mq_maxmsg, MQ_PRIO_MAX) *
+			sizeof(struct posix_msg_tree_node);
 
-		mq_bytes = (mq_msg_tblsz +
-			(info->attr.mq_maxmsg * info->attr.mq_msgsize));
+		mq_bytes = mq_treesize + (info->attr.mq_maxmsg *
+					  info->attr.mq_msgsize);
 
 		spin_lock(&mq_lock);
 		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
@@ -251,9 +351,9 @@ static void mqueue_evict_inode(struct in
 {
 	struct mqueue_inode_info *info;
 	struct user_struct *user;
-	unsigned long mq_bytes;
-	int i;
+	unsigned long mq_bytes, mq_treesize;
 	struct ipc_namespace *ipc_ns;
+	struct msg_msg *msg;
 
 	end_writeback(inode);
 
@@ -263,17 +363,18 @@ static void mqueue_evict_inode(struct in
 	ipc_ns = get_ns_from_inode(inode);
 	info = MQUEUE_I(inode);
 	spin_lock(&info->lock);
-	for (i = 0; i < info->attr.mq_curmsgs; i++)
-		free_msg(info->messages[i]);
-	if (is_vmalloc_addr(info->messages))
-		vfree(info->messages);
-	else
-		kfree(info->messages);
+	while ((msg = msg_get(info)) != NULL)
+		free_msg(msg);
 	spin_unlock(&info->lock);
 
 	/* Total amount of bytes accounted for the mqueue */
-	mq_bytes = info->attr.mq_maxmsg * (sizeof(struct msg_msg *)
-	    + info->attr.mq_msgsize);
+	mq_treesize = info->attr.mq_maxmsg * sizeof(struct msg_msg) +
+		min_t(unsigned int, info->attr.mq_maxmsg, MQ_PRIO_MAX) *
+		sizeof(struct posix_msg_tree_node);
+
+	mq_bytes = mq_treesize + (info->attr.mq_maxmsg *
+				  info->attr.mq_msgsize);
+
 	user = info->user;
 	if (user) {
 		spin_lock(&mq_lock);
@@ -493,26 +594,6 @@ static struct ext_wait_queue *wq_get_fir
 	return list_entry(ptr, struct ext_wait_queue, list);
 }
 
-/* Auxiliary functions to manipulate messages' list */
-static void msg_insert(struct msg_msg *ptr, struct mqueue_inode_info *info)
-{
-	int k;
-
-	k = info->attr.mq_curmsgs - 1;
-	while (k >= 0 && info->messages[k]->m_type >= ptr->m_type) {
-		info->messages[k + 1] = info->messages[k];
-		k--;
-	}
-	info->attr.mq_curmsgs++;
-	info->qsize += ptr->m_ts;
-	info->messages[k + 1] = ptr;
-}
-
-static inline struct msg_msg *msg_get(struct mqueue_inode_info *info)
-{
-	info->qsize -= info->messages[--info->attr.mq_curmsgs]->m_ts;
-	return info->messages[info->attr.mq_curmsgs];
-}
 
 static inline void set_cookie(struct sk_buff *skb, char code)
 {
@@ -843,7 +924,8 @@ static inline void pipelined_receive(str
 		wake_up_interruptible(&info->wait_q);
 		return;
 	}
-	msg_insert(sender->msg, info);
+	if (msg_insert(sender->msg, info))
+		return;
 	list_del(&sender->list);
 	sender->state = STATE_PENDING;
 	wake_up_process(sender->task);
@@ -931,7 +1013,12 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 			pipelined_send(info, msg_ptr, receiver);
 		} else {
 			/* adds message to the queue */
-			msg_insert(msg_ptr, info);
+			if (msg_insert(msg_ptr, info)) {
+				free_msg(msg_ptr);
+				ret = -ENOMEM;
+				spin_unlock(&info->lock);
+				goto out_fput;
+			}
 			__do_notify(info);
 		}
 		inode->i_atime = inode->i_mtime = inode->i_ctime =
_
Subject: Subject: ipc/mqueue: improve performance of send/recv

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
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch

