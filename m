From: akpm@linux-foundation.org
Subject: [merged] mm-interval-tree-updates.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:10:39 -0700
Message-ID: <20121009181039.D52AD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:58672 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2JISKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:10:40 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so660722ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:10:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, daniel.santos@pobox.com, hughd@google.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: interval tree updates
has been removed from the -mm tree.  Its filename was
     mm-interval-tree-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: interval tree updates

Update the generic interval tree code that was introduced in "mm: replace
vma prio_tree with an interval tree".

Changes:

- fixed 'endpoing' typo noticed by Andrew Morton

- replaced include/linux/interval_tree_tmpl.h, which was used as a
  template (including it automatically defined the interval tree
  functions) with include/linux/interval_tree_generic.h, which only
  defines a preprocessor macro INTERVAL_TREE_DEFINE(), which itself
  defines the interval tree functions when invoked. Now that is a very
  long macro which is unfortunate, but it does make the usage sites
  (lib/interval_tree.c and mm/interval_tree.c) a bit nicer than previously.

- make use of RB_DECLARE_CALLBACKS() in the INTERVAL_TREE_DEFINE() macro,
  instead of duplicating that code in the interval tree template.

- replaced vma_interval_tree_add(), which was actually handling the
  nonlinear and interval tree cases, with vma_interval_tree_insert_after()
  which handles only the interval tree case and has an API that is more
  consistent with the other interval tree handling functions.
  The nonlinear case is now handled explicitly in kernel/fork.c dup_mmap().

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interval_tree_generic.h |  191 ++++++++++++++++++++
 include/linux/interval_tree_tmpl.h    |  219 ------------------------
 include/linux/mm.h                    |    6 
 kernel/fork.c                         |    7 
 lib/interval_tree.c                   |   15 -
 mm/interval_tree.c                    |   60 +++---
 6 files changed, 235 insertions(+), 263 deletions(-)

diff -puN /dev/null include/linux/interval_tree_generic.h
--- /dev/null
+++ a/include/linux/interval_tree_generic.h
@@ -0,0 +1,191 @@
+/*
+  Interval Trees
+  (C) 2012  Michel Lespinasse <walken@google.com>
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+  include/linux/interval_tree_generic.h
+*/
+
+#include <linux/rbtree_augmented.h>
+
+/*
+ * Template for implementing interval trees
+ *
+ * ITSTRUCT:   struct type of the interval tree nodes
+ * ITRB:       name of struct rb_node field within ITSTRUCT
+ * ITTYPE:     type of the interval endpoints
+ * ITSUBTREE:  name of ITTYPE field within ITSTRUCT holding last-in-subtree
+ * ITSTART(n): start endpoint of ITSTRUCT node n
+ * ITLAST(n):  last endpoint of ITSTRUCT node n
+ * ITSTATIC:   'static' or empty
+ * ITPREFIX:   prefix to use for the inline tree definitions
+ *
+ * Note - before using this, please consider if non-generic version
+ * (interval_tree.h) would work for you...
+ */
+
+#define INTERVAL_TREE_DEFINE(ITSTRUCT, ITRB, ITTYPE, ITSUBTREE,		      \
+			     ITSTART, ITLAST, ITSTATIC, ITPREFIX)	      \
+									      \
+/* Callbacks for augmented rbtree insert and remove */			      \
+									      \
+static inline ITTYPE ITPREFIX ## _compute_subtree_last(ITSTRUCT *node)	      \
+{									      \
+	ITTYPE max = ITLAST(node), subtree_last;			      \
+	if (node->ITRB.rb_left) {					      \
+		subtree_last = rb_entry(node->ITRB.rb_left,		      \
+					ITSTRUCT, ITRB)->ITSUBTREE;	      \
+		if (max < subtree_last)					      \
+			max = subtree_last;				      \
+	}								      \
+	if (node->ITRB.rb_right) {					      \
+		subtree_last = rb_entry(node->ITRB.rb_right,		      \
+					ITSTRUCT, ITRB)->ITSUBTREE;	      \
+		if (max < subtree_last)					      \
+			max = subtree_last;				      \
+	}								      \
+	return max;							      \
+}									      \
+									      \
+RB_DECLARE_CALLBACKS(static, ITPREFIX ## _augment, ITSTRUCT, ITRB,	      \
+		     ITTYPE, ITSUBTREE, ITPREFIX ## _compute_subtree_last)    \
+									      \
+/* Insert / remove interval nodes from the tree */			      \
+									      \
+ITSTATIC void ITPREFIX ## _insert(ITSTRUCT *node, struct rb_root *root)	      \
+{									      \
+	struct rb_node **link = &root->rb_node, *rb_parent = NULL;	      \
+	ITTYPE start = ITSTART(node), last = ITLAST(node);		      \
+	ITSTRUCT *parent;						      \
+									      \
+	while (*link) {							      \
+		rb_parent = *link;					      \
+		parent = rb_entry(rb_parent, ITSTRUCT, ITRB);		      \
+		if (parent->ITSUBTREE < last)				      \
+			parent->ITSUBTREE = last;			      \
+		if (start < ITSTART(parent))				      \
+			link = &parent->ITRB.rb_left;			      \
+		else							      \
+			link = &parent->ITRB.rb_right;			      \
+	}								      \
+									      \
+	node->ITSUBTREE = last;						      \
+	rb_link_node(&node->ITRB, rb_parent, link);			      \
+	rb_insert_augmented(&node->ITRB, root, &ITPREFIX ## _augment);	      \
+}									      \
+									      \
+ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node, struct rb_root *root)	      \
+{									      \
+	rb_erase_augmented(&node->ITRB, root, &ITPREFIX ## _augment);	      \
+}									      \
+									      \
+/*									      \
+ * Iterate over intervals intersecting [start;last]			      \
+ *									      \
+ * Note that a node's interval intersects [start;last] iff:		      \
+ *   Cond1: ITSTART(node) <= last					      \
+ * and									      \
+ *   Cond2: start <= ITLAST(node)					      \
+ */									      \
+									      \
+static ITSTRUCT *							      \
+ITPREFIX ## _subtree_search(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
+{									      \
+	while (true) {							      \
+		/*							      \
+		 * Loop invariant: start <= node->ITSUBTREE		      \
+		 * (Cond2 is satisfied by one of the subtree nodes)	      \
+		 */							      \
+		if (node->ITRB.rb_left) {				      \
+			ITSTRUCT *left = rb_entry(node->ITRB.rb_left,	      \
+						  ITSTRUCT, ITRB);	      \
+			if (start <= left->ITSUBTREE) {			      \
+				/*					      \
+				 * Some nodes in left subtree satisfy Cond2.  \
+				 * Iterate to find the leftmost such node N.  \
+				 * If it also satisfies Cond1, that's the     \
+				 * match we are looking for. Otherwise, there \
+				 * is no matching interval as nodes to the    \
+				 * right of N can't satisfy Cond1 either.     \
+				 */					      \
+				node = left;				      \
+				continue;				      \
+			}						      \
+		}							      \
+		if (ITSTART(node) <= last) {		/* Cond1 */	      \
+			if (start <= ITLAST(node))	/* Cond2 */	      \
+				return node;	/* node is leftmost match */  \
+			if (node->ITRB.rb_right) {			      \
+				node = rb_entry(node->ITRB.rb_right,	      \
+						ITSTRUCT, ITRB);	      \
+				if (start <= node->ITSUBTREE)		      \
+					continue;			      \
+			}						      \
+		}							      \
+		return NULL;	/* No match */				      \
+	}								      \
+}									      \
+									      \
+ITSTATIC ITSTRUCT *							      \
+ITPREFIX ## _iter_first(struct rb_root *root, ITTYPE start, ITTYPE last)      \
+{									      \
+	ITSTRUCT *node;							      \
+									      \
+	if (!root->rb_node)						      \
+		return NULL;						      \
+	node = rb_entry(root->rb_node, ITSTRUCT, ITRB);			      \
+	if (node->ITSUBTREE < start)					      \
+		return NULL;						      \
+	return ITPREFIX ## _subtree_search(node, start, last);		      \
+}									      \
+									      \
+ITSTATIC ITSTRUCT *							      \
+ITPREFIX ## _iter_next(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
+{									      \
+	struct rb_node *rb = node->ITRB.rb_right, *prev;		      \
+									      \
+	while (true) {							      \
+		/*							      \
+		 * Loop invariants:					      \
+		 *   Cond1: ITSTART(node) <= last			      \
+		 *   rb == node->ITRB.rb_right				      \
+		 *							      \
+		 * First, search right subtree if suitable		      \
+		 */							      \
+		if (rb) {						      \
+			ITSTRUCT *right = rb_entry(rb, ITSTRUCT, ITRB);	      \
+			if (start <= right->ITSUBTREE)			      \
+				return ITPREFIX ## _subtree_search(right,     \
+								start, last); \
+		}							      \
+									      \
+		/* Move up the tree until we come from a node's left child */ \
+		do {							      \
+			rb = rb_parent(&node->ITRB);			      \
+			if (!rb)					      \
+				return NULL;				      \
+			prev = &node->ITRB;				      \
+			node = rb_entry(rb, ITSTRUCT, ITRB);		      \
+			rb = node->ITRB.rb_right;			      \
+		} while (prev == rb);					      \
+									      \
+		/* Check if the node intersects [start;last] */		      \
+		if (last < ITSTART(node))		/* !Cond1 */	      \
+			return NULL;					      \
+		else if (start <= ITLAST(node))		/* Cond2 */	      \
+			return node;					      \
+	}								      \
+}
diff -puN include/linux/interval_tree_tmpl.h~mm-interval-tree-updates /dev/null
--- a/include/linux/interval_tree_tmpl.h
+++ /dev/null
@@ -1,219 +0,0 @@
-/*
-  Interval Trees
-  (C) 2012  Michel Lespinasse <walken@google.com>
-
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of the GNU General Public License as published by
-  the Free Software Foundation; either version 2 of the License, or
-  (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-
-  include/linux/interval_tree_tmpl.h
-*/
-
-#include <linux/rbtree_augmented.h>
-
-/*
- * Template for implementing interval trees
- *
- * ITSTRUCT:   struct type of the interval tree nodes
- * ITRB:       name of struct rb_node field within ITSTRUCT
- * ITTYPE:     type of the interval endpoints
- * ITSUBTREE:  name of ITTYPE field within ITSTRUCT holding last-in-subtree
- * ITSTART(n): start endpoint of ITSTRUCT node n
- * ITLAST(n):  last endpoing of ITSTRUCT node n
- * ITSTATIC:   'static' or empty
- * ITPREFIX:   prefix to use for the inline tree definitions
- */
-
-/* IT(name) -> ITPREFIX_name */
-#define _ITNAME(prefix, name) prefix ## _ ## name
-#define ITNAME(prefix, name) _ITNAME(prefix, name)
-#define IT(name) ITNAME(ITPREFIX, name)
-
-/* Callbacks for augmented rbtree insert and remove */
-
-static inline ITTYPE IT(compute_subtree_last)(ITSTRUCT *node)
-{
-	ITTYPE max = ITLAST(node), subtree_last;
-	if (node->ITRB.rb_left) {
-		subtree_last = rb_entry(node->ITRB.rb_left,
-					ITSTRUCT, ITRB)->ITSUBTREE;
-		if (max < subtree_last)
-			max = subtree_last;
-	}
-	if (node->ITRB.rb_right) {
-		subtree_last = rb_entry(node->ITRB.rb_right,
-					ITSTRUCT, ITRB)->ITSUBTREE;
-		if (max < subtree_last)
-			max = subtree_last;
-	}
-	return max;
-}
-
-static inline void
-IT(augment_propagate)(struct rb_node *rb, struct rb_node *stop)
-{
-	while (rb != stop) {
-		ITSTRUCT *node = rb_entry(rb, ITSTRUCT, ITRB);
-		ITTYPE subtree_last = IT(compute_subtree_last)(node);
-		if (node->ITSUBTREE == subtree_last)
-			break;
-		node->ITSUBTREE = subtree_last;
-		rb = rb_parent(&node->ITRB);
-	}
-}
-
-static inline void
-IT(augment_copy)(struct rb_node *rb_old, struct rb_node *rb_new)
-{
-	ITSTRUCT *old = rb_entry(rb_old, ITSTRUCT, ITRB);
-	ITSTRUCT *new = rb_entry(rb_new, ITSTRUCT, ITRB);
-
-	new->ITSUBTREE = old->ITSUBTREE;
-}
-
-static void IT(augment_rotate)(struct rb_node *rb_old, struct rb_node *rb_new)
-{
-	ITSTRUCT *old = rb_entry(rb_old, ITSTRUCT, ITRB);
-	ITSTRUCT *new = rb_entry(rb_new, ITSTRUCT, ITRB);
-
-	new->ITSUBTREE = old->ITSUBTREE;
-	old->ITSUBTREE = IT(compute_subtree_last)(old);
-}
-
-static const struct rb_augment_callbacks IT(augment_callbacks) = {
-	IT(augment_propagate), IT(augment_copy), IT(augment_rotate)
-};
-
-/* Insert / remove interval nodes from the tree */
-
-ITSTATIC void IT(insert)(ITSTRUCT *node, struct rb_root *root)
-{
-	struct rb_node **link = &root->rb_node, *rb_parent = NULL;
-	ITTYPE start = ITSTART(node), last = ITLAST(node);
-	ITSTRUCT *parent;
-
-	while (*link) {
-		rb_parent = *link;
-		parent = rb_entry(rb_parent, ITSTRUCT, ITRB);
-		if (parent->ITSUBTREE < last)
-			parent->ITSUBTREE = last;
-		if (start < ITSTART(parent))
-			link = &parent->ITRB.rb_left;
-		else
-			link = &parent->ITRB.rb_right;
-	}
-
-	node->ITSUBTREE = last;
-	rb_link_node(&node->ITRB, rb_parent, link);
-	rb_insert_augmented(&node->ITRB, root, &IT(augment_callbacks));
-}
-
-ITSTATIC void IT(remove)(ITSTRUCT *node, struct rb_root *root)
-{
-	rb_erase_augmented(&node->ITRB, root, &IT(augment_callbacks));
-}
-
-/*
- * Iterate over intervals intersecting [start;last]
- *
- * Note that a node's interval intersects [start;last] iff:
- *   Cond1: ITSTART(node) <= last
- * and
- *   Cond2: start <= ITLAST(node)
- */
-
-static ITSTRUCT *IT(subtree_search)(ITSTRUCT *node, ITTYPE start, ITTYPE last)
-{
-	while (true) {
-		/*
-		 * Loop invariant: start <= node->ITSUBTREE
-		 * (Cond2 is satisfied by one of the subtree nodes)
-		 */
-		if (node->ITRB.rb_left) {
-			ITSTRUCT *left = rb_entry(node->ITRB.rb_left,
-						  ITSTRUCT, ITRB);
-			if (start <= left->ITSUBTREE) {
-				/*
-				 * Some nodes in left subtree satisfy Cond2.
-				 * Iterate to find the leftmost such node N.
-				 * If it also satisfies Cond1, that's the match
-				 * we are looking for. Otherwise, there is no
-				 * matching interval as nodes to the right of N
-				 * can't satisfy Cond1 either.
-				 */
-				node = left;
-				continue;
-			}
-		}
-		if (ITSTART(node) <= last) {		/* Cond1 */
-			if (start <= ITLAST(node))	/* Cond2 */
-				return node;	/* node is leftmost match */
-			if (node->ITRB.rb_right) {
-				node = rb_entry(node->ITRB.rb_right,
-						ITSTRUCT, ITRB);
-				if (start <= node->ITSUBTREE)
-					continue;
-			}
-		}
-		return NULL;	/* No match */
-	}
-}
-
-ITSTATIC ITSTRUCT *IT(iter_first)(struct rb_root *root,
-				  ITTYPE start, ITTYPE last)
-{
-	ITSTRUCT *node;
-
-	if (!root->rb_node)
-		return NULL;
-	node = rb_entry(root->rb_node, ITSTRUCT, ITRB);
-	if (node->ITSUBTREE < start)
-		return NULL;
-	return IT(subtree_search)(node, start, last);
-}
-
-ITSTATIC ITSTRUCT *IT(iter_next)(ITSTRUCT *node, ITTYPE start, ITTYPE last)
-{
-	struct rb_node *rb = node->ITRB.rb_right, *prev;
-
-	while (true) {
-		/*
-		 * Loop invariants:
-		 *   Cond1: ITSTART(node) <= last
-		 *   rb == node->ITRB.rb_right
-		 *
-		 * First, search right subtree if suitable
-		 */
-		if (rb) {
-			ITSTRUCT *right = rb_entry(rb, ITSTRUCT, ITRB);
-			if (start <= right->ITSUBTREE)
-				return IT(subtree_search)(right, start, last);
-		}
-
-		/* Move up the tree until we come from a node's left child */
-		do {
-			rb = rb_parent(&node->ITRB);
-			if (!rb)
-				return NULL;
-			prev = &node->ITRB;
-			node = rb_entry(rb, ITSTRUCT, ITRB);
-			rb = node->ITRB.rb_right;
-		} while (prev == rb);
-
-		/* Check if the node intersects [start;last] */
-		if (last < ITSTART(node))		/* !Cond1 */
-			return NULL;
-		else if (start <= ITLAST(node))		/* Cond2 */
-			return node;
-	}
-}
diff -puN include/linux/mm.h~mm-interval-tree-updates include/linux/mm.h
--- a/include/linux/mm.h~mm-interval-tree-updates
+++ a/include/linux/mm.h
@@ -1355,11 +1355,11 @@ extern atomic_long_t mmap_pages_allocate
 extern int nommu_shrink_inode_mappings(struct inode *, size_t, size_t);
 
 /* interval_tree.c */
-void vma_interval_tree_add(struct vm_area_struct *vma,
-			   struct vm_area_struct *old,
-			   struct address_space *mapping);
 void vma_interval_tree_insert(struct vm_area_struct *node,
 			      struct rb_root *root);
+void vma_interval_tree_insert_after(struct vm_area_struct *node,
+				    struct vm_area_struct *prev,
+				    struct rb_root *root);
 void vma_interval_tree_remove(struct vm_area_struct *node,
 			      struct rb_root *root);
 struct vm_area_struct *vma_interval_tree_iter_first(struct rb_root *root,
diff -puN kernel/fork.c~mm-interval-tree-updates kernel/fork.c
--- a/kernel/fork.c~mm-interval-tree-updates
+++ a/kernel/fork.c
@@ -423,7 +423,12 @@ static int dup_mmap(struct mm_struct *mm
 				mapping->i_mmap_writable++;
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
-			vma_interval_tree_add(tmp, mpnt, mapping);
+			if (unlikely(tmp->vm_flags & VM_NONLINEAR))
+				vma_nonlinear_insert(tmp,
+						&mapping->i_mmap_nonlinear);
+			else
+				vma_interval_tree_insert_after(tmp, mpnt,
+							&mapping->i_mmap);
 			flush_dcache_mmap_unlock(mapping);
 			mutex_unlock(&mapping->i_mmap_mutex);
 		}
diff -puN lib/interval_tree.c~mm-interval-tree-updates lib/interval_tree.c
--- a/lib/interval_tree.c~mm-interval-tree-updates
+++ a/lib/interval_tree.c
@@ -1,13 +1,10 @@
 #include <linux/init.h>
 #include <linux/interval_tree.h>
+#include <linux/interval_tree_generic.h>
 
-#define ITSTRUCT   struct interval_tree_node
-#define ITRB       rb
-#define ITTYPE     unsigned long
-#define ITSUBTREE  __subtree_last
-#define ITSTART(n) ((n)->start)
-#define ITLAST(n)  ((n)->last)
-#define ITSTATIC
-#define ITPREFIX   interval_tree
+#define START(node) ((node)->start)
+#define LAST(node)  ((node)->last)
 
-#include <linux/interval_tree_tmpl.h>
+INTERVAL_TREE_DEFINE(struct interval_tree_node, rb,
+		     unsigned long, __subtree_last,
+		     START, LAST,, interval_tree)
diff -puN mm/interval_tree.c~mm-interval-tree-updates mm/interval_tree.c
--- a/mm/interval_tree.c~mm-interval-tree-updates
+++ a/mm/interval_tree.c
@@ -8,40 +8,38 @@
 
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/interval_tree_generic.h>
 
-#define ITSTRUCT   struct vm_area_struct
-#define ITRB       shared.linear.rb
-#define ITTYPE     unsigned long
-#define ITSUBTREE  shared.linear.rb_subtree_last
-#define ITSTART(n) ((n)->vm_pgoff)
-#define ITLAST(n)  ((n)->vm_pgoff + \
-		    (((n)->vm_end - (n)->vm_start) >> PAGE_SHIFT) - 1)
-#define ITSTATIC
-#define ITPREFIX   vma_interval_tree
-
-#include <linux/interval_tree_tmpl.h>
-
-/* Insert old immediately after vma in the interval tree */
-void vma_interval_tree_add(struct vm_area_struct *vma,
-			   struct vm_area_struct *old,
-			   struct address_space *mapping)
+static inline unsigned long vma_start_pgoff(struct vm_area_struct *v)
+{
+	return v->vm_pgoff;
+}
+
+static inline unsigned long vma_last_pgoff(struct vm_area_struct *v)
+{
+	return v->vm_pgoff + ((v->vm_end - v->vm_start) >> PAGE_SHIFT) - 1;
+}
+
+INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.linear.rb,
+		     unsigned long, shared.linear.rb_subtree_last,
+		     vma_start_pgoff, vma_last_pgoff,, vma_interval_tree)
+
+/* Insert node immediately after prev in the interval tree */
+void vma_interval_tree_insert_after(struct vm_area_struct *node,
+				    struct vm_area_struct *prev,
+				    struct rb_root *root)
 {
 	struct rb_node **link;
 	struct vm_area_struct *parent;
-	unsigned long last;
-
-	if (unlikely(vma->vm_flags & VM_NONLINEAR)) {
-		list_add(&vma->shared.nonlinear, &old->shared.nonlinear);
-		return;
-	}
+	unsigned long last = vma_last_pgoff(node);
 
-	last = ITLAST(vma);
+	VM_BUG_ON(vma_start_pgoff(node) != vma_start_pgoff(prev));
 
-	if (!old->shared.linear.rb.rb_right) {
-		parent = old;
-		link = &old->shared.linear.rb.rb_right;
+	if (!prev->shared.linear.rb.rb_right) {
+		parent = prev;
+		link = &prev->shared.linear.rb.rb_right;
 	} else {
-		parent = rb_entry(old->shared.linear.rb.rb_right,
+		parent = rb_entry(prev->shared.linear.rb.rb_right,
 				  struct vm_area_struct, shared.linear.rb);
 		if (parent->shared.linear.rb_subtree_last < last)
 			parent->shared.linear.rb_subtree_last = last;
@@ -54,8 +52,8 @@ void vma_interval_tree_add(struct vm_are
 		link = &parent->shared.linear.rb.rb_left;
 	}
 
-	vma->shared.linear.rb_subtree_last = last;
-	rb_link_node(&vma->shared.linear.rb, &parent->shared.linear.rb, link);
-	rb_insert_augmented(&vma->shared.linear.rb, &mapping->i_mmap,
-			    &vma_interval_tree_augment_callbacks);
+	node->shared.linear.rb_subtree_last = last;
+	rb_link_node(&node->shared.linear.rb, &parent->shared.linear.rb, link);
+	rb_insert_augmented(&node->shared.linear.rb, root,
+			    &vma_interval_tree_augment);
 }
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

