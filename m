From: akpm@linux-foundation.org
Subject: + procfs-use-faster-rb_first_cached.patch added to -mm tree
Date: Wed, 26 Jul 2017 14:14:58 -0700
Message-ID: <59790652.iOwALtx0T1Efm+D0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdGZVO7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 17:14:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: use faster rb_first_cached()
has been added to the -mm tree.  Its filename is
     procfs-use-faster-rb_first_cached.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-use-faster-rb_first_cached.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-use-faster-rb_first_cached.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: procfs: use faster rb_first_cached()

...  such that we can avoid the tree walks to get the node with the
smallest key.  Semantically the same, as the previously used rb_first(),
but O(1).  The main overhead is the extra footprint for the cached rb_node
pointer, which should not matter for procfs.

Link: http://lkml.kernel.org/r/20170719014603.19029-14-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c  |   26 ++++++++++++++------------
 fs/proc/internal.h |    2 +-
 fs/proc/proc_net.c |    2 +-
 fs/proc/root.c     |    2 +-
 4 files changed, 17 insertions(+), 15 deletions(-)

diff -puN fs/proc/generic.c~procfs-use-faster-rb_first_cached fs/proc/generic.c
--- a/fs/proc/generic.c~procfs-use-faster-rb_first_cached
+++ a/fs/proc/generic.c
@@ -40,8 +40,8 @@ static int proc_match(unsigned int len,
 
 static struct proc_dir_entry *pde_subdir_first(struct proc_dir_entry *dir)
 {
-	return rb_entry_safe(rb_first(&dir->subdir), struct proc_dir_entry,
-			     subdir_node);
+	return rb_entry_safe(rb_first_cached(&dir->subdir),
+			     struct proc_dir_entry, subdir_node);
 }
 
 static struct proc_dir_entry *pde_subdir_next(struct proc_dir_entry *dir)
@@ -54,7 +54,7 @@ static struct proc_dir_entry *pde_subdir
 					      const char *name,
 					      unsigned int len)
 {
-	struct rb_node *node = dir->subdir.rb_node;
+	struct rb_node *node = dir->subdir.rb_root.rb_node;
 
 	while (node) {
 		struct proc_dir_entry *de = rb_entry(node,
@@ -75,8 +75,9 @@ static struct proc_dir_entry *pde_subdir
 static bool pde_subdir_insert(struct proc_dir_entry *dir,
 			      struct proc_dir_entry *de)
 {
-	struct rb_root *root = &dir->subdir;
-	struct rb_node **new = &root->rb_node, *parent = NULL;
+	struct rb_root_cached *root = &dir->subdir;
+	struct rb_node **new = &root->rb_root.rb_node, *parent = NULL;
+	bool leftmost = true;
 
 	/* Figure out where to put new node */
 	while (*new) {
@@ -88,15 +89,16 @@ static bool pde_subdir_insert(struct pro
 		parent = *new;
 		if (result < 0)
 			new = &(*new)->rb_left;
-		else if (result > 0)
+		else if (result > 0) {
 			new = &(*new)->rb_right;
-		else
+			leftmost = false;
+		} else
 			return false;
 	}
 
 	/* Add new node and rebalance tree. */
 	rb_link_node(&de->subdir_node, parent, new);
-	rb_insert_color(&de->subdir_node, root);
+	rb_insert_color_cached(&de->subdir_node, root, leftmost);
 	return true;
 }
 
@@ -369,7 +371,7 @@ static struct proc_dir_entry *__proc_cre
 	ent->namelen = qstr.len;
 	ent->mode = mode;
 	ent->nlink = nlink;
-	ent->subdir = RB_ROOT;
+	ent->subdir = RB_ROOT_CACHED;
 	atomic_set(&ent->count, 1);
 	spin_lock_init(&ent->pde_unload_lock);
 	INIT_LIST_HEAD(&ent->pde_openers);
@@ -545,7 +547,7 @@ void remove_proc_entry(const char *name,
 
 	de = pde_subdir_find(parent, fn, len);
 	if (de)
-		rb_erase(&de->subdir_node, &parent->subdir);
+		rb_erase_cached(&de->subdir_node, &parent->subdir);
 	write_unlock(&proc_subdir_lock);
 	if (!de) {
 		WARN(1, "name '%s'\n", name);
@@ -582,13 +584,13 @@ int remove_proc_subtree(const char *name
 		write_unlock(&proc_subdir_lock);
 		return -ENOENT;
 	}
-	rb_erase(&root->subdir_node, &parent->subdir);
+	rb_erase_cached(&root->subdir_node, &parent->subdir);
 
 	de = root;
 	while (1) {
 		next = pde_subdir_first(de);
 		if (next) {
-			rb_erase(&next->subdir_node, &de->subdir);
+			rb_erase_cached(&next->subdir_node, &de->subdir);
 			de = next;
 			continue;
 		}
diff -puN fs/proc/internal.h~procfs-use-faster-rb_first_cached fs/proc/internal.h
--- a/fs/proc/internal.h~procfs-use-faster-rb_first_cached
+++ a/fs/proc/internal.h
@@ -40,7 +40,7 @@ struct proc_dir_entry {
 	const struct inode_operations *proc_iops;
 	const struct file_operations *proc_fops;
 	struct proc_dir_entry *parent;
-	struct rb_root subdir;
+	struct rb_root_cached subdir;
 	struct rb_node subdir_node;
 	void *data;
 	atomic_t count;		/* use count */
diff -puN fs/proc/proc_net.c~procfs-use-faster-rb_first_cached fs/proc/proc_net.c
--- a/fs/proc/proc_net.c~procfs-use-faster-rb_first_cached
+++ a/fs/proc/proc_net.c
@@ -196,7 +196,7 @@ static __net_init int proc_net_ns_init(s
 	if (!netd)
 		goto out;
 
-	netd->subdir = RB_ROOT;
+	netd->subdir = RB_ROOT_CACHED;
 	netd->data = net;
 	netd->nlink = 2;
 	netd->namelen = 3;
diff -puN fs/proc/root.c~procfs-use-faster-rb_first_cached fs/proc/root.c
--- a/fs/proc/root.c~procfs-use-faster-rb_first_cached
+++ a/fs/proc/root.c
@@ -210,7 +210,7 @@ struct proc_dir_entry proc_root = {
 	.proc_iops	= &proc_root_inode_operations, 
 	.proc_fops	= &proc_root_operations,
 	.parent		= &proc_root,
-	.subdir		= RB_ROOT,
+	.subdir		= RB_ROOT_CACHED,
 	.name		= "/proc",
 };
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

rbtree-cache-leftmost-node-internally.patch
rbtree-optimize-root-check-during-rebalancing-loop.patch
rbtree-add-some-additional-comments-for-rebalancing-cases.patch
lib-rbtree_testc-make-input-module-parameters.patch
lib-rbtree_testc-add-inorder-traversal-test.patch
lib-rbtree_testc-support-rb_root_cached.patch
sched-fair-replace-cfs_rq-rb_leftmost.patch
sched-deadline-replace-earliest-dl-and-rq-leftmost-caching.patch
locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching.patch
block-cfq-replace-cfq_rb_root-leftmost-caching.patch
lib-interval_tree-fast-overlap-detection.patch
lib-interval-tree-correct-comment-wrt-generic-flavor.patch
procfs-use-faster-rb_first_cached.patch
fs-epoll-use-faster-rb_first_cached.patch
mem-memcg-cache-rightmost-node.patch
block-cfq-cache-rightmost-rb_node.patch

