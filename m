From: akpm@linux-foundation.org
Subject: [merged] rbtree-empty-nodes-have-no-color.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:08:59 -0700
Message-ID: <20121009180859.C9E811E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:56152 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2JISJB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:09:01 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so661947vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:09:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, David.Woodhouse@intel.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, ebiederm@xmission.com, john.stultz@linaro.org, riel@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: empty nodes have no color
has been removed from the -mm tree.  Its filename was
     rbtree-empty-nodes-have-no-color.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree: empty nodes have no color

Empty nodes have no color.  We can make use of this property to simplify
the code emitted by the RB_EMPTY_NODE and RB_CLEAR_NODE macros.  Also, we
can get rid of the rb_init_node function which had been introduced by
88d19cf37952 ("timers: Add rb_init_node() to allow for stack allocated rb
nodes") to avoid some issue with the empty node's color not being
initialized.

I'm not sure what the RB_EMPTY_NODE checks in rb_prev() / rb_next() are
doing there, though.  axboe introduced them in 10fd48f2376d ("rbtree:
fixed reversed RB_EMPTY_NODE and rb_next/prev").  The way I see it, the
'empty node' abstraction is only used by rbtree users to flag nodes that
they haven't inserted in any rbtree, so asking the predecessor or
successor of such nodes doesn't make any sense.

One final rb_init_node() caller was recently added in sysctl code to
implement faster sysctl name lookups.  This code doesn't make use of
RB_EMPTY_NODE at all, and from what I could see it only called
rb_init_node() under the mistaken assumption that such initialization was
required before node insertion.

[sfr@canb.auug.org.au: fix net/ceph/osd_client.c build]
Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c      |    4 +---
 include/linux/rbtree.h     |   15 +++++----------
 include/linux/timerqueue.h |    2 +-
 lib/rbtree.c               |    4 ++--
 net/ceph/osd_client.c      |    1 -
 5 files changed, 9 insertions(+), 17 deletions(-)

diff -puN fs/proc/proc_sysctl.c~rbtree-empty-nodes-have-no-color fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~rbtree-empty-nodes-have-no-color
+++ a/fs/proc/proc_sysctl.c
@@ -168,10 +168,8 @@ static void init_header(struct ctl_table
 	head->node = node;
 	if (node) {
 		struct ctl_table *entry;
-		for (entry = table; entry->procname; entry++, node++) {
-			rb_init_node(&node->node);
+		for (entry = table; entry->procname; entry++, node++)
 			node->header = head;
-		}
 	}
 }
 
diff -puN include/linux/rbtree.h~rbtree-empty-nodes-have-no-color include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-empty-nodes-have-no-color
+++ a/include/linux/rbtree.h
@@ -67,17 +67,12 @@ static inline void rb_set_color(struct r
 #define RB_ROOT	(struct rb_root) { NULL, }
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
 
-#define RB_EMPTY_ROOT(root)	((root)->rb_node == NULL)
-#define RB_EMPTY_NODE(node)	(rb_parent(node) == node)
-#define RB_CLEAR_NODE(node)	(rb_set_parent(node, node))
+#define RB_EMPTY_ROOT(root)  ((root)->rb_node == NULL)
+
+/* 'empty' nodes are nodes that are known not to be inserted in an rbree */
+#define RB_EMPTY_NODE(node)  ((node)->rb_parent_color == (unsigned long)(node))
+#define RB_CLEAR_NODE(node)  ((node)->rb_parent_color = (unsigned long)(node))
 
-static inline void rb_init_node(struct rb_node *rb)
-{
-	rb->rb_parent_color = 0;
-	rb->rb_right = NULL;
-	rb->rb_left = NULL;
-	RB_CLEAR_NODE(rb);
-}
 
 extern void rb_insert_color(struct rb_node *, struct rb_root *);
 extern void rb_erase(struct rb_node *, struct rb_root *);
diff -puN include/linux/timerqueue.h~rbtree-empty-nodes-have-no-color include/linux/timerqueue.h
--- a/include/linux/timerqueue.h~rbtree-empty-nodes-have-no-color
+++ a/include/linux/timerqueue.h
@@ -39,7 +39,7 @@ struct timerqueue_node *timerqueue_getne
 
 static inline void timerqueue_init(struct timerqueue_node *node)
 {
-	rb_init_node(&node->node);
+	RB_CLEAR_NODE(&node->node);
 }
 
 static inline void timerqueue_init_head(struct timerqueue_head *head)
diff -puN lib/rbtree.c~rbtree-empty-nodes-have-no-color lib/rbtree.c
--- a/lib/rbtree.c~rbtree-empty-nodes-have-no-color
+++ a/lib/rbtree.c
@@ -387,7 +387,7 @@ struct rb_node *rb_next(const struct rb_
 {
 	struct rb_node *parent;
 
-	if (rb_parent(node) == node)
+	if (RB_EMPTY_NODE(node))
 		return NULL;
 
 	/* If we have a right-hand child, go down and then left as far
@@ -416,7 +416,7 @@ struct rb_node *rb_prev(const struct rb_
 {
 	struct rb_node *parent;
 
-	if (rb_parent(node) == node)
+	if (RB_EMPTY_NODE(node))
 		return NULL;
 
 	/* If we have a left-hand child, go down and then right as far
diff -puN net/ceph/osd_client.c~rbtree-empty-nodes-have-no-color net/ceph/osd_client.c
--- a/net/ceph/osd_client.c~rbtree-empty-nodes-have-no-color
+++ a/net/ceph/osd_client.c
@@ -221,7 +221,6 @@ struct ceph_osd_request *ceph_osdc_alloc
 	kref_init(&req->r_kref);
 	init_completion(&req->r_completion);
 	init_completion(&req->r_safe_completion);
-	rb_init_node(&req->r_node);
 	INIT_LIST_HEAD(&req->r_unsafe_item);
 	INIT_LIST_HEAD(&req->r_linger_item);
 	INIT_LIST_HEAD(&req->r_linger_osd);
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

