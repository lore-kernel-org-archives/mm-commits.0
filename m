From: akpm@linux-foundation.org
Subject: + rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch added to -mm tree
Date: Fri, 13 Jul 2012 13:30:46 -0700
Message-ID: <20120713203047.56A371E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:49845 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab2GMUas (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 16:30:48 -0400
Received: by ghbz15 with SMTP id z15so380560ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 13:30:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, dwmw2@infradead.org, ebiederm@xmission.com, riel@redhat.com


The patch titled
     Subject: rbtree: move some implementation details from rbtree.h to rbtree.c
has been added to the -mm tree.  Its filename is
     rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch

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
Subject: rbtree: move some implementation details from rbtree.h to rbtree.c

rbtree users must use the documented APIs to manipulate the tree
structure.  Low-level helpers to manipulate node colors and parenthood are
not part of that API, so move them to lib/rbtree.c

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |   34 +++++++++-------------------------
 lib/rbtree.c           |   20 +++++++++++++++++++-
 2 files changed, 28 insertions(+), 26 deletions(-)

diff -puN include/linux/rbtree.h~rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec
+++ a/include/linux/rbtree.h
@@ -32,37 +32,19 @@
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 
-struct rb_node
-{
-	unsigned long  rb_parent_color;
-#define	RB_RED		0
-#define	RB_BLACK	1
+struct rb_node {
+	unsigned long  __rb_parent_color;
 	struct rb_node *rb_right;
 	struct rb_node *rb_left;
 } __attribute__((aligned(sizeof(long))));
     /* The alignment might seem pointless, but allegedly CRIS needs it */
 
-struct rb_root
-{
+struct rb_root {
 	struct rb_node *rb_node;
 };
 
 
-#define rb_parent(r)   ((struct rb_node *)((r)->rb_parent_color & ~3))
-#define rb_color(r)   ((r)->rb_parent_color & 1)
-#define rb_is_red(r)   (!rb_color(r))
-#define rb_is_black(r) rb_color(r)
-#define rb_set_red(r)  do { (r)->rb_parent_color &= ~1; } while (0)
-#define rb_set_black(r)  do { (r)->rb_parent_color |= 1; } while (0)
-
-static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
-{
-	rb->rb_parent_color = (rb->rb_parent_color & 3) | (unsigned long)p;
-}
-static inline void rb_set_color(struct rb_node *rb, int color)
-{
-	rb->rb_parent_color = (rb->rb_parent_color & ~1) | color;
-}
+#define rb_parent(r)   ((struct rb_node *)((r)->__rb_parent_color & ~3))
 
 #define RB_ROOT	(struct rb_root) { NULL, }
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
@@ -70,8 +52,10 @@ static inline void rb_set_color(struct r
 #define RB_EMPTY_ROOT(root)  ((root)->rb_node == NULL)
 
 /* 'empty' nodes are nodes that are known not to be inserted in an rbree */
-#define RB_EMPTY_NODE(node)  ((node)->rb_parent_color == (unsigned long)(node))
-#define RB_CLEAR_NODE(node)  ((node)->rb_parent_color = (unsigned long)(node))
+#define RB_EMPTY_NODE(node)  \
+	((node)->__rb_parent_color == (unsigned long)(node))
+#define RB_CLEAR_NODE(node)  \
+	((node)->__rb_parent_color = (unsigned long)(node))
 
 
 extern void rb_insert_color(struct rb_node *, struct rb_root *);
@@ -98,7 +82,7 @@ extern void rb_replace_node(struct rb_no
 static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 				struct rb_node ** rb_link)
 {
-	node->rb_parent_color = (unsigned long )parent;
+	node->__rb_parent_color = (unsigned long)parent;
 	node->rb_left = node->rb_right = NULL;
 
 	*rb_link = node;
diff -puN lib/rbtree.c~rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec lib/rbtree.c
--- a/lib/rbtree.c~rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec
+++ a/lib/rbtree.c
@@ -23,6 +23,24 @@
 #include <linux/rbtree.h>
 #include <linux/export.h>
 
+#define	RB_RED		0
+#define	RB_BLACK	1
+
+#define rb_color(r)   ((r)->__rb_parent_color & 1)
+#define rb_is_red(r)   (!rb_color(r))
+#define rb_is_black(r) rb_color(r)
+#define rb_set_red(r)  do { (r)->__rb_parent_color &= ~1; } while (0)
+#define rb_set_black(r)  do { (r)->__rb_parent_color |= 1; } while (0)
+
+static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
+{
+	rb->__rb_parent_color = rb_color(rb) | (unsigned long)p;
+}
+static inline void rb_set_color(struct rb_node *rb, int color)
+{
+	rb->__rb_parent_color = (rb->__rb_parent_color & ~1) | color;
+}
+
 static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
 {
 	struct rb_node *right = node->rb_right;
@@ -255,7 +273,7 @@ void rb_erase(struct rb_node *node, stru
 			rb_set_parent(old->rb_right, node);
 		}
 
-		node->rb_parent_color = old->rb_parent_color;
+		node->__rb_parent_color = old->__rb_parent_color;
 		node->rb_left = old->rb_left;
 		rb_set_parent(old->rb_left, node);
 
_
Subject: Subject: rbtree: move some implementation details from rbtree.h to rbtree.c

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

