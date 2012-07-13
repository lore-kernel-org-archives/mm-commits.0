From: akpm@linux-foundation.org
Subject: + rbtree-empty-nodes-have-no-color.patch added to -mm tree
Date: Fri, 13 Jul 2012 13:30:39 -0700
Message-ID: <20120713203039.D4F4A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45695 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab2GMUan (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 16:30:43 -0400
Received: by eekd4 with SMTP id d4so147638eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 13:30:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, dwmw2@infradead.org, ebiederm@xmission.com, john.stultz@linaro.org, riel@redhat.com


The patch titled
     Subject: rbtree: empty nodes have no color
has been added to the -mm tree.  Its filename is
     rbtree-empty-nodes-have-no-color.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c      |    4 +---
 include/linux/rbtree.h     |   15 +++++----------
 include/linux/timerqueue.h |    2 +-
 lib/rbtree.c               |    4 ++--
 4 files changed, 9 insertions(+), 16 deletions(-)

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
_
Subject: Subject: rbtree: empty nodes have no color

Patches currently in -mm which might be from walken@google.com are

slab-do-not-call-compound_head-in-page_get_cache.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch

