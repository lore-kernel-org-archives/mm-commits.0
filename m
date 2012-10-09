From: akpm@linux-foundation.org
Subject: [merged] mm-replace-vma-prio_tree-with-an-interval-tree.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:10:25 -0700
Message-ID: <20121009181025.CA2471E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:61728 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2JISK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:10:27 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so662197vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:10:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, catalin.marinas@arm.com, dhillf@gmail.com, dwmw2@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace vma prio_tree with an interval tree
has been removed from the -mm tree.  Its filename was
     mm-replace-vma-prio_tree-with-an-interval-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: replace vma prio_tree with an interval tree

Implement an interval tree as a replacement for the VMA prio_tree.  The
algorithms are similar to lib/interval_tree.c; however that code can't be
directly reused as the interval endpoints are not explicitly stored in the
VMA.  So instead, the common algorithm is moved into a template and the
details (node type, how to get interval endpoints from the node, etc) are
filled in using the C preprocessor.

Once the interval tree functions are available, using them as a
replacement to the VMA prio tree is a relatively simple, mechanical job.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault-armv.c           |    3 
 arch/arm/mm/flush.c                |    3 
 arch/parisc/kernel/cache.c         |    3 
 arch/x86/mm/hugetlbpage.c          |    3 
 fs/hugetlbfs/inode.c               |    9 -
 fs/inode.c                         |    2 
 include/linux/fs.h                 |    6 
 include/linux/interval_tree_tmpl.h |  215 +++++++++++++++++++++++++++
 include/linux/mm.h                 |   30 ++-
 include/linux/mm_types.h           |   14 -
 kernel/events/uprobes.c            |    3 
 kernel/fork.c                      |    2 
 lib/interval_tree.c                |  164 +-------------------
 lib/prio_tree.c                    |   19 --
 mm/Makefile                        |    4 
 mm/filemap_xip.c                   |    3 
 mm/fremap.c                        |    2 
 mm/hugetlb.c                       |    3 
 mm/interval_tree.c                 |   61 +++++++
 mm/memory-failure.c                |    3 
 mm/memory.c                        |    9 -
 mm/mmap.c                          |   22 +-
 mm/nommu.c                         |   12 -
 mm/prio_tree.c                     |  208 --------------------------
 mm/rmap.c                          |   18 --
 25 files changed, 356 insertions(+), 465 deletions(-)

diff -puN arch/arm/mm/fault-armv.c~mm-replace-vma-prio_tree-with-an-interval-tree arch/arm/mm/fault-armv.c
--- a/arch/arm/mm/fault-armv.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/arch/arm/mm/fault-armv.c
@@ -134,7 +134,6 @@ make_coherent(struct address_space *mapp
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *mpnt;
-	struct prio_tree_iter iter;
 	unsigned long offset;
 	pgoff_t pgoff;
 	int aliases = 0;
@@ -147,7 +146,7 @@ make_coherent(struct address_space *mapp
 	 * cache coherency.
 	 */
 	flush_dcache_mmap_lock(mapping);
-	vma_prio_tree_foreach(mpnt, &iter, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
 		/*
 		 * If this VMA is not in our MM, we can ignore it.
 		 * Note that we intentionally mask out the VMA
diff -puN arch/arm/mm/flush.c~mm-replace-vma-prio_tree-with-an-interval-tree arch/arm/mm/flush.c
--- a/arch/arm/mm/flush.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/arch/arm/mm/flush.c
@@ -196,7 +196,6 @@ static void __flush_dcache_aliases(struc
 {
 	struct mm_struct *mm = current->active_mm;
 	struct vm_area_struct *mpnt;
-	struct prio_tree_iter iter;
 	pgoff_t pgoff;
 
 	/*
@@ -208,7 +207,7 @@ static void __flush_dcache_aliases(struc
 	pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_prio_tree_foreach(mpnt, &iter, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long offset;
 
 		/*
diff -puN arch/parisc/kernel/cache.c~mm-replace-vma-prio_tree-with-an-interval-tree arch/parisc/kernel/cache.c
--- a/arch/parisc/kernel/cache.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/arch/parisc/kernel/cache.c
@@ -276,7 +276,6 @@ void flush_dcache_page(struct page *page
 {
 	struct address_space *mapping = page_mapping(page);
 	struct vm_area_struct *mpnt;
-	struct prio_tree_iter iter;
 	unsigned long offset;
 	unsigned long addr, old_addr = 0;
 	pgoff_t pgoff;
@@ -299,7 +298,7 @@ void flush_dcache_page(struct page *page
 	 * to flush one address here for them all to become coherent */
 
 	flush_dcache_mmap_lock(mapping);
-	vma_prio_tree_foreach(mpnt, &iter, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
 		offset = (pgoff - mpnt->vm_pgoff) << PAGE_SHIFT;
 		addr = mpnt->vm_start + offset;
 
diff -puN arch/x86/mm/hugetlbpage.c~mm-replace-vma-prio_tree-with-an-interval-tree arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/arch/x86/mm/hugetlbpage.c
@@ -71,7 +71,6 @@ huge_pmd_share(struct mm_struct *mm, uns
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	pgoff_t idx = ((addr - vma->vm_start) >> PAGE_SHIFT) +
 			vma->vm_pgoff;
-	struct prio_tree_iter iter;
 	struct vm_area_struct *svma;
 	unsigned long saddr;
 	pte_t *spte = NULL;
@@ -81,7 +80,7 @@ huge_pmd_share(struct mm_struct *mm, uns
 		return (pte_t *)pmd_alloc(mm, pud, addr);
 
 	mutex_lock(&mapping->i_mmap_mutex);
-	vma_prio_tree_foreach(svma, &iter, &mapping->i_mmap, idx, idx) {
+	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
 		if (svma == vma)
 			continue;
 
diff -puN fs/hugetlbfs/inode.c~mm-replace-vma-prio_tree-with-an-interval-tree fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/fs/hugetlbfs/inode.c
@@ -397,17 +397,16 @@ static void hugetlbfs_evict_inode(struct
 }
 
 static inline void
-hugetlb_vmtruncate_list(struct prio_tree_root *root, pgoff_t pgoff)
+hugetlb_vmtruncate_list(struct rb_root *root, pgoff_t pgoff)
 {
 	struct vm_area_struct *vma;
-	struct prio_tree_iter iter;
 
-	vma_prio_tree_foreach(vma, &iter, root, pgoff, ULONG_MAX) {
+	vma_interval_tree_foreach(vma, root, pgoff, ULONG_MAX) {
 		unsigned long v_offset;
 
 		/*
 		 * Can the expression below overflow on 32-bit arches?
-		 * No, because the prio_tree returns us only those vmas
+		 * No, because the interval tree returns us only those vmas
 		 * which overlap the truncated area starting at pgoff,
 		 * and no vma on a 32-bit arch can span beyond the 4GB.
 		 */
@@ -432,7 +431,7 @@ static int hugetlb_vmtruncate(struct ino
 
 	i_size_write(inode, offset);
 	mutex_lock(&mapping->i_mmap_mutex);
-	if (!prio_tree_empty(&mapping->i_mmap))
+	if (!RB_EMPTY_ROOT(&mapping->i_mmap))
 		hugetlb_vmtruncate_list(&mapping->i_mmap, pgoff);
 	mutex_unlock(&mapping->i_mmap_mutex);
 	truncate_hugepages(inode, offset);
diff -puN fs/inode.c~mm-replace-vma-prio_tree-with-an-interval-tree fs/inode.c
--- a/fs/inode.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/fs/inode.c
@@ -348,7 +348,7 @@ void address_space_init_once(struct addr
 	mutex_init(&mapping->i_mmap_mutex);
 	INIT_LIST_HEAD(&mapping->private_list);
 	spin_lock_init(&mapping->private_lock);
-	INIT_RAW_PRIO_TREE_ROOT(&mapping->i_mmap);
+	mapping->i_mmap = RB_ROOT;
 	INIT_LIST_HEAD(&mapping->i_mmap_nonlinear);
 }
 EXPORT_SYMBOL(address_space_init_once);
diff -puN include/linux/fs.h~mm-replace-vma-prio_tree-with-an-interval-tree include/linux/fs.h
--- a/include/linux/fs.h~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/include/linux/fs.h
@@ -401,7 +401,7 @@ struct inodes_stat_t {
 #include <linux/cache.h>
 #include <linux/list.h>
 #include <linux/radix-tree.h>
-#include <linux/prio_tree.h>
+#include <linux/rbtree.h>
 #include <linux/init.h>
 #include <linux/pid.h>
 #include <linux/bug.h>
@@ -669,7 +669,7 @@ struct address_space {
 	struct radix_tree_root	page_tree;	/* radix tree of all pages */
 	spinlock_t		tree_lock;	/* and lock protecting it */
 	unsigned int		i_mmap_writable;/* count VM_SHARED mappings */
-	struct prio_tree_root	i_mmap;		/* tree of private and shared mappings */
+	struct rb_root		i_mmap;		/* tree of private and shared mappings */
 	struct list_head	i_mmap_nonlinear;/*list VM_NONLINEAR mappings */
 	struct mutex		i_mmap_mutex;	/* protect tree, count, list */
 	/* Protected by tree_lock together with the radix tree */
@@ -741,7 +741,7 @@ int mapping_tagged(struct address_space 
  */
 static inline int mapping_mapped(struct address_space *mapping)
 {
-	return	!prio_tree_empty(&mapping->i_mmap) ||
+	return	!RB_EMPTY_ROOT(&mapping->i_mmap) ||
 		!list_empty(&mapping->i_mmap_nonlinear);
 }
 
diff -puN /dev/null include/linux/interval_tree_tmpl.h
--- /dev/null
+++ a/include/linux/interval_tree_tmpl.h
@@ -0,0 +1,215 @@
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
+  include/linux/interval_tree_tmpl.h
+*/
+
+/*
+ * Template for implementing interval trees
+ *
+ * ITSTRUCT:   struct type of the interval tree nodes
+ * ITRB:       name of struct rb_node field within ITSTRUCT
+ * ITTYPE:     type of the interval endpoints
+ * ITSUBTREE:  name of ITTYPE field within ITSTRUCT holding last-in-subtree
+ * ITSTART(n): start endpoint of ITSTRUCT node n
+ * ITLAST(n):  last endpoing of ITSTRUCT node n
+ * ITSTATIC:   'static' or empty
+ * ITPREFIX:   prefix to use for the inline tree definitions
+ */
+
+/* IT(name) -> ITPREFIX_name */
+#define _ITNAME(prefix, name) prefix ## _ ## name
+#define ITNAME(prefix, name) _ITNAME(prefix, name)
+#define IT(name) ITNAME(ITPREFIX, name)
+
+/* Callbacks for augmented rbtree insert and remove */
+
+static inline ITTYPE IT(compute_subtree_last)(ITSTRUCT *node)
+{
+	ITTYPE max = ITLAST(node), subtree_last;
+	if (node->ITRB.rb_left) {
+		subtree_last = rb_entry(node->ITRB.rb_left,
+					ITSTRUCT, ITRB)->ITSUBTREE;
+		if (max < subtree_last)
+			max = subtree_last;
+	}
+	if (node->ITRB.rb_right) {
+		subtree_last = rb_entry(node->ITRB.rb_right,
+					ITSTRUCT, ITRB)->ITSUBTREE;
+		if (max < subtree_last)
+			max = subtree_last;
+	}
+	return max;
+}
+
+static void IT(augment_propagate)(struct rb_node *rb, struct rb_node *stop)
+{
+	while (rb != stop) {
+		ITSTRUCT *node = rb_entry(rb, ITSTRUCT, ITRB);
+		ITTYPE subtree_last = IT(compute_subtree_last)(node);
+		if (node->ITSUBTREE == subtree_last)
+			break;
+		node->ITSUBTREE = subtree_last;
+		rb = rb_parent(&node->ITRB);
+	}
+}
+
+static void IT(augment_copy)(struct rb_node *rb_old, struct rb_node *rb_new)
+{
+	ITSTRUCT *old = rb_entry(rb_old, ITSTRUCT, ITRB);
+	ITSTRUCT *new = rb_entry(rb_new, ITSTRUCT, ITRB);
+
+	new->ITSUBTREE = old->ITSUBTREE;
+}
+
+static void IT(augment_rotate)(struct rb_node *rb_old, struct rb_node *rb_new)
+{
+	ITSTRUCT *old = rb_entry(rb_old, ITSTRUCT, ITRB);
+	ITSTRUCT *new = rb_entry(rb_new, ITSTRUCT, ITRB);
+
+	new->ITSUBTREE = old->ITSUBTREE;
+	old->ITSUBTREE = IT(compute_subtree_last)(old);
+}
+
+static const struct rb_augment_callbacks IT(augment_callbacks) = {
+	IT(augment_propagate), IT(augment_copy), IT(augment_rotate)
+};
+
+/* Insert / remove interval nodes from the tree */
+
+ITSTATIC void IT(insert)(ITSTRUCT *node, struct rb_root *root)
+{
+	struct rb_node **link = &root->rb_node, *rb_parent = NULL;
+	ITTYPE start = ITSTART(node), last = ITLAST(node);
+	ITSTRUCT *parent;
+
+	while (*link) {
+		rb_parent = *link;
+		parent = rb_entry(rb_parent, ITSTRUCT, ITRB);
+		if (parent->ITSUBTREE < last)
+			parent->ITSUBTREE = last;
+		if (start < ITSTART(parent))
+			link = &parent->ITRB.rb_left;
+		else
+			link = &parent->ITRB.rb_right;
+	}
+
+	node->ITSUBTREE = last;
+	rb_link_node(&node->ITRB, rb_parent, link);
+	rb_insert_augmented(&node->ITRB, root, &IT(augment_callbacks));
+}
+
+ITSTATIC void IT(remove)(ITSTRUCT *node, struct rb_root *root)
+{
+	rb_erase_augmented(&node->ITRB, root, &IT(augment_callbacks));
+}
+
+/*
+ * Iterate over intervals intersecting [start;last]
+ *
+ * Note that a node's interval intersects [start;last] iff:
+ *   Cond1: ITSTART(node) <= last
+ * and
+ *   Cond2: start <= ITLAST(node)
+ */
+
+static ITSTRUCT *IT(subtree_search)(ITSTRUCT *node, ITTYPE start, ITTYPE last)
+{
+	while (true) {
+		/*
+		 * Loop invariant: start <= node->ITSUBTREE
+		 * (Cond2 is satisfied by one of the subtree nodes)
+		 */
+		if (node->ITRB.rb_left) {
+			ITSTRUCT *left = rb_entry(node->ITRB.rb_left,
+						  ITSTRUCT, ITRB);
+			if (start <= left->ITSUBTREE) {
+				/*
+				 * Some nodes in left subtree satisfy Cond2.
+				 * Iterate to find the leftmost such node N.
+				 * If it also satisfies Cond1, that's the match
+				 * we are looking for. Otherwise, there is no
+				 * matching interval as nodes to the right of N
+				 * can't satisfy Cond1 either.
+				 */
+				node = left;
+				continue;
+			}
+		}
+		if (ITSTART(node) <= last) {		/* Cond1 */
+			if (start <= ITLAST(node))	/* Cond2 */
+				return node;	/* node is leftmost match */
+			if (node->ITRB.rb_right) {
+				node = rb_entry(node->ITRB.rb_right,
+						ITSTRUCT, ITRB);
+				if (start <= node->ITSUBTREE)
+					continue;
+			}
+		}
+		return NULL;	/* No match */
+	}
+}
+
+ITSTATIC ITSTRUCT *IT(iter_first)(struct rb_root *root,
+				  ITTYPE start, ITTYPE last)
+{
+	ITSTRUCT *node;
+
+	if (!root->rb_node)
+		return NULL;
+	node = rb_entry(root->rb_node, ITSTRUCT, ITRB);
+	if (node->ITSUBTREE < start)
+		return NULL;
+	return IT(subtree_search)(node, start, last);
+}
+
+ITSTATIC ITSTRUCT *IT(iter_next)(ITSTRUCT *node, ITTYPE start, ITTYPE last)
+{
+	struct rb_node *rb = node->ITRB.rb_right, *prev;
+
+	while (true) {
+		/*
+		 * Loop invariants:
+		 *   Cond1: ITSTART(node) <= last
+		 *   rb == node->ITRB.rb_right
+		 *
+		 * First, search right subtree if suitable
+		 */
+		if (rb) {
+			ITSTRUCT *right = rb_entry(rb, ITSTRUCT, ITRB);
+			if (start <= right->ITSUBTREE)
+				return IT(subtree_search)(right, start, last);
+		}
+
+		/* Move up the tree until we come from a node's left child */
+		do {
+			rb = rb_parent(&node->ITRB);
+			if (!rb)
+				return NULL;
+			prev = &node->ITRB;
+			node = rb_entry(rb, ITSTRUCT, ITRB);
+			rb = node->ITRB.rb_right;
+		} while (prev == rb);
+
+		/* Check if the node intersects [start;last] */
+		if (last < ITSTART(node))		/* !Cond1 */
+			return NULL;
+		else if (start <= ITLAST(node))		/* Cond2 */
+			return node;
+	}
+}
diff -puN include/linux/mm.h~mm-replace-vma-prio_tree-with-an-interval-tree include/linux/mm.h
--- a/include/linux/mm.h~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/include/linux/mm.h
@@ -10,7 +10,6 @@
 #include <linux/list.h>
 #include <linux/mmzone.h>
 #include <linux/rbtree.h>
-#include <linux/prio_tree.h>
 #include <linux/atomic.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
@@ -1355,22 +1354,27 @@ extern void zone_pcp_reset(struct zone *
 extern atomic_long_t mmap_pages_allocated;
 extern int nommu_shrink_inode_mappings(struct inode *, size_t, size_t);
 
-/* prio_tree.c */
-void vma_prio_tree_add(struct vm_area_struct *, struct vm_area_struct *old);
-void vma_prio_tree_insert(struct vm_area_struct *, struct prio_tree_root *);
-void vma_prio_tree_remove(struct vm_area_struct *, struct prio_tree_root *);
-struct vm_area_struct *vma_prio_tree_next(struct vm_area_struct *vma,
-	struct prio_tree_iter *iter);
-
-#define vma_prio_tree_foreach(vma, iter, root, begin, end)	\
-	for (prio_tree_iter_init(iter, root, begin, end), vma = NULL;	\
-		(vma = vma_prio_tree_next(vma, iter)); )
+/* interval_tree.c */
+void vma_interval_tree_add(struct vm_area_struct *vma,
+			   struct vm_area_struct *old,
+			   struct address_space *mapping);
+void vma_interval_tree_insert(struct vm_area_struct *node,
+			      struct rb_root *root);
+void vma_interval_tree_remove(struct vm_area_struct *node,
+			      struct rb_root *root);
+struct vm_area_struct *vma_interval_tree_iter_first(struct rb_root *root,
+				unsigned long start, unsigned long last);
+struct vm_area_struct *vma_interval_tree_iter_next(struct vm_area_struct *node,
+				unsigned long start, unsigned long last);
+
+#define vma_interval_tree_foreach(vma, root, start, last)		\
+	for (vma = vma_interval_tree_iter_first(root, start, last);	\
+	     vma; vma = vma_interval_tree_iter_next(vma, start, last))
 
 static inline void vma_nonlinear_insert(struct vm_area_struct *vma,
 					struct list_head *list)
 {
-	vma->shared.vm_set.parent = NULL;
-	list_add_tail(&vma->shared.vm_set.list, list);
+	list_add_tail(&vma->shared.nonlinear, list);
 }
 
 /* mmap.c */
diff -puN include/linux/mm_types.h~mm-replace-vma-prio_tree-with-an-interval-tree include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/include/linux/mm_types.h
@@ -6,7 +6,6 @@
 #include <linux/threads.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
-#include <linux/prio_tree.h>
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
 #include <linux/completion.h>
@@ -240,18 +239,15 @@ struct vm_area_struct {
 
 	/*
 	 * For areas with an address space and backing store,
-	 * linkage into the address_space->i_mmap prio tree, or
-	 * linkage to the list of like vmas hanging off its node, or
+	 * linkage into the address_space->i_mmap interval tree, or
 	 * linkage of vma in the address_space->i_mmap_nonlinear list.
 	 */
 	union {
 		struct {
-			struct list_head list;
-			void *parent;	/* aligns with prio_tree_node parent */
-			struct vm_area_struct *head;
-		} vm_set;
-
-		struct raw_prio_tree_node prio_tree_node;
+			struct rb_node rb;
+			unsigned long rb_subtree_last;
+		} linear;
+		struct list_head nonlinear;
 	} shared;
 
 	/*
diff -puN kernel/events/uprobes.c~mm-replace-vma-prio_tree-with-an-interval-tree kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/kernel/events/uprobes.c
@@ -735,7 +735,6 @@ static struct map_info *
 build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 {
 	unsigned long pgoff = offset >> PAGE_SHIFT;
-	struct prio_tree_iter iter;
 	struct vm_area_struct *vma;
 	struct map_info *curr = NULL;
 	struct map_info *prev = NULL;
@@ -744,7 +743,7 @@ build_map_info(struct address_space *map
 
  again:
 	mutex_lock(&mapping->i_mmap_mutex);
-	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		if (!valid_vma(vma, is_register))
 			continue;
 
diff -puN kernel/fork.c~mm-replace-vma-prio_tree-with-an-interval-tree kernel/fork.c
--- a/kernel/fork.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/kernel/fork.c
@@ -423,7 +423,7 @@ static int dup_mmap(struct mm_struct *mm
 				mapping->i_mmap_writable++;
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
-			vma_prio_tree_add(tmp, mpnt);
+			vma_interval_tree_add(tmp, mpnt, mapping);
 			flush_dcache_mmap_unlock(mapping);
 			mutex_unlock(&mapping->i_mmap_mutex);
 		}
diff -puN lib/interval_tree.c~mm-replace-vma-prio_tree-with-an-interval-tree lib/interval_tree.c
--- a/lib/interval_tree.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/lib/interval_tree.c
@@ -1,159 +1,13 @@
 #include <linux/init.h>
 #include <linux/interval_tree.h>
 
-/* Callbacks for augmented rbtree insert and remove */
+#define ITSTRUCT   struct interval_tree_node
+#define ITRB       rb
+#define ITTYPE     unsigned long
+#define ITSUBTREE  __subtree_last
+#define ITSTART(n) ((n)->start)
+#define ITLAST(n)  ((n)->last)
+#define ITSTATIC
+#define ITPREFIX   interval_tree
 
-static inline unsigned long
-compute_subtree_last(struct interval_tree_node *node)
-{
-	unsigned long max = node->last, subtree_last;
-	if (node->rb.rb_left) {
-		subtree_last = rb_entry(node->rb.rb_left,
-			struct interval_tree_node, rb)->__subtree_last;
-		if (max < subtree_last)
-			max = subtree_last;
-	}
-	if (node->rb.rb_right) {
-		subtree_last = rb_entry(node->rb.rb_right,
-			struct interval_tree_node, rb)->__subtree_last;
-		if (max < subtree_last)
-			max = subtree_last;
-	}
-	return max;
-}
-
-RB_DECLARE_CALLBACKS(static, augment_callbacks, struct interval_tree_node, rb,
-		     unsigned long, __subtree_last, compute_subtree_last)
-
-/* Insert / remove interval nodes from the tree */
-
-void interval_tree_insert(struct interval_tree_node *node,
-			  struct rb_root *root)
-{
-	struct rb_node **link = &root->rb_node, *rb_parent = NULL;
-	unsigned long start = node->start, last = node->last;
-	struct interval_tree_node *parent;
-
-	while (*link) {
-		rb_parent = *link;
-		parent = rb_entry(rb_parent, struct interval_tree_node, rb);
-		if (parent->__subtree_last < last)
-			parent->__subtree_last = last;
-		if (start < parent->start)
-			link = &parent->rb.rb_left;
-		else
-			link = &parent->rb.rb_right;
-	}
-
-	node->__subtree_last = last;
-	rb_link_node(&node->rb, rb_parent, link);
-	rb_insert_augmented(&node->rb, root, &augment_callbacks);
-}
-
-void interval_tree_remove(struct interval_tree_node *node,
-			  struct rb_root *root)
-{
-	rb_erase_augmented(&node->rb, root, &augment_callbacks);
-}
-
-/*
- * Iterate over intervals intersecting [start;last]
- *
- * Note that a node's interval intersects [start;last] iff:
- *   Cond1: node->start <= last
- * and
- *   Cond2: start <= node->last
- */
-
-static struct interval_tree_node *
-subtree_search(struct interval_tree_node *node,
-	       unsigned long start, unsigned long last)
-{
-	while (true) {
-		/*
-		 * Loop invariant: start <= node->__subtree_last
-		 * (Cond2 is satisfied by one of the subtree nodes)
-		 */
-		if (node->rb.rb_left) {
-			struct interval_tree_node *left =
-				rb_entry(node->rb.rb_left,
-					 struct interval_tree_node, rb);
-			if (start <= left->__subtree_last) {
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
-		if (node->start <= last) {		/* Cond1 */
-			if (start <= node->last)	/* Cond2 */
-				return node;	/* node is leftmost match */
-			if (node->rb.rb_right) {
-				node = rb_entry(node->rb.rb_right,
-					struct interval_tree_node, rb);
-				if (start <= node->__subtree_last)
-					continue;
-			}
-		}
-		return NULL;	/* No match */
-	}
-}
-
-struct interval_tree_node *
-interval_tree_iter_first(struct rb_root *root,
-			 unsigned long start, unsigned long last)
-{
-	struct interval_tree_node *node;
-
-	if (!root->rb_node)
-		return NULL;
-	node = rb_entry(root->rb_node, struct interval_tree_node, rb);
-	if (node->__subtree_last < start)
-		return NULL;
-	return subtree_search(node, start, last);
-}
-
-struct interval_tree_node *
-interval_tree_iter_next(struct interval_tree_node *node,
-			unsigned long start, unsigned long last)
-{
-	struct rb_node *rb = node->rb.rb_right, *prev;
-
-	while (true) {
-		/*
-		 * Loop invariants:
-		 *   Cond1: node->start <= last
-		 *   rb == node->rb.rb_right
-		 *
-		 * First, search right subtree if suitable
-		 */
-		if (rb) {
-			struct interval_tree_node *right =
-				rb_entry(rb, struct interval_tree_node, rb);
-			if (start <= right->__subtree_last)
-				return subtree_search(right, start, last);
-		}
-
-		/* Move up the tree until we come from a node's left child */
-		do {
-			rb = rb_parent(&node->rb);
-			if (!rb)
-				return NULL;
-			prev = &node->rb;
-			node = rb_entry(rb, struct interval_tree_node, rb);
-			rb = node->rb.rb_right;
-		} while (prev == rb);
-
-		/* Check if the node intersects [start;last] */
-		if (last < node->start)		/* !Cond1 */
-			return NULL;
-		else if (start <= node->last)	/* Cond2 */
-			return node;
-	}
-}
+#include <linux/interval_tree_tmpl.h>
diff -puN lib/prio_tree.c~mm-replace-vma-prio_tree-with-an-interval-tree lib/prio_tree.c
--- a/lib/prio_tree.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/lib/prio_tree.c
@@ -44,27 +44,12 @@
  * The following macros are used for implementing prio_tree for i_mmap
  */
 
-#define RADIX_INDEX(vma)  ((vma)->vm_pgoff)
-#define VMA_SIZE(vma)	  (((vma)->vm_end - (vma)->vm_start) >> PAGE_SHIFT)
-/* avoid overflow */
-#define HEAP_INDEX(vma)	  ((vma)->vm_pgoff + (VMA_SIZE(vma) - 1))
-
-
 static void get_index(const struct prio_tree_root *root,
     const struct prio_tree_node *node,
     unsigned long *radix, unsigned long *heap)
 {
-	if (root->raw) {
-		struct vm_area_struct *vma = prio_tree_entry(
-		    node, struct vm_area_struct, shared.prio_tree_node);
-
-		*radix = RADIX_INDEX(vma);
-		*heap = HEAP_INDEX(vma);
-	}
-	else {
-		*radix = node->start;
-		*heap = node->last;
-	}
+	*radix = node->start;
+	*heap = node->last;
 }
 
 static unsigned long index_bits_to_maxindex[BITS_PER_LONG];
diff -puN mm/Makefile~mm-replace-vma-prio_tree-with-an-interval-tree mm/Makefile
--- a/mm/Makefile~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/mm/Makefile
@@ -14,9 +14,9 @@ endif
 obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
-			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
+			   util.o mmzone.o vmstat.o backing-dev.o \
 			   mm_init.o mmu_context.o percpu.o slab_common.o \
-			   compaction.o $(mmu-y)
+			   compaction.o interval_tree.o $(mmu-y)
 
 obj-y += init-mm.o
 
diff -puN mm/filemap_xip.c~mm-replace-vma-prio_tree-with-an-interval-tree mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/mm/filemap_xip.c
@@ -167,7 +167,6 @@ __xip_unmap (struct address_space * mapp
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
-	struct prio_tree_iter iter;
 	unsigned long address;
 	pte_t *pte;
 	pte_t pteval;
@@ -184,7 +183,7 @@ __xip_unmap (struct address_space * mapp
 
 retry:
 	mutex_lock(&mapping->i_mmap_mutex);
-	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		mm = vma->vm_mm;
 		address = vma->vm_start +
 			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
diff -puN mm/fremap.c~mm-replace-vma-prio_tree-with-an-interval-tree mm/fremap.c
--- a/mm/fremap.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/mm/fremap.c
@@ -214,7 +214,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 		mutex_lock(&mapping->i_mmap_mutex);
 		flush_dcache_mmap_lock(mapping);
 		vma->vm_flags |= VM_NONLINEAR;
-		vma_prio_tree_remove(vma, &mapping->i_mmap);
+		vma_interval_tree_remove(vma, &mapping->i_mmap);
 		vma_nonlinear_insert(vma, &mapping->i_mmap_nonlinear);
 		flush_dcache_mmap_unlock(mapping);
 		mutex_unlock(&mapping->i_mmap_mutex);
diff -puN mm/hugetlb.c~mm-replace-vma-prio_tree-with-an-interval-tree mm/hugetlb.c
--- a/mm/hugetlb.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/mm/hugetlb.c
@@ -2474,7 +2474,6 @@ static int unmap_ref_private(struct mm_s
 	struct hstate *h = hstate_vma(vma);
 	struct vm_area_struct *iter_vma;
 	struct address_space *mapping;
-	struct prio_tree_iter iter;
 	pgoff_t pgoff;
 
 	/*
@@ -2491,7 +2490,7 @@ static int unmap_ref_private(struct mm_s
 	 * __unmap_hugepage_range() is called as the lock is already held
 	 */
 	mutex_lock(&mapping->i_mmap_mutex);
-	vma_prio_tree_foreach(iter_vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(iter_vma, &mapping->i_mmap, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
 			continue;
diff -puN /dev/null mm/interval_tree.c
--- /dev/null
+++ a/mm/interval_tree.c
@@ -0,0 +1,61 @@
+/*
+ * mm/interval_tree.c - interval tree for mapping->i_mmap
+ *
+ * Copyright (C) 2012, Michel Lespinasse <walken@google.com>
+ *
+ * This file is released under the GPL v2.
+ */
+
+#include <linux/mm.h>
+#include <linux/fs.h>
+
+#define ITSTRUCT   struct vm_area_struct
+#define ITRB       shared.linear.rb
+#define ITTYPE     unsigned long
+#define ITSUBTREE  shared.linear.rb_subtree_last
+#define ITSTART(n) ((n)->vm_pgoff)
+#define ITLAST(n)  ((n)->vm_pgoff + \
+		    (((n)->vm_end - (n)->vm_start) >> PAGE_SHIFT) - 1)
+#define ITSTATIC
+#define ITPREFIX   vma_interval_tree
+
+#include <linux/interval_tree_tmpl.h>
+
+/* Insert old immediately after vma in the interval tree */
+void vma_interval_tree_add(struct vm_area_struct *vma,
+			   struct vm_area_struct *old,
+			   struct address_space *mapping)
+{
+	struct rb_node **link;
+	struct vm_area_struct *parent;
+	unsigned long last;
+
+	if (unlikely(vma->vm_flags & VM_NONLINEAR)) {
+		list_add(&vma->shared.nonlinear, &old->shared.nonlinear);
+		return;
+	}
+
+	last = ITLAST(vma);
+
+	if (!old->shared.linear.rb.rb_right) {
+		parent = old;
+		link = &old->shared.linear.rb.rb_right;
+	} else {
+		parent = rb_entry(old->shared.linear.rb.rb_right,
+				  struct vm_area_struct, shared.linear.rb);
+		if (parent->shared.linear.rb_subtree_last < last)
+			parent->shared.linear.rb_subtree_last = last;
+		while (parent->shared.linear.rb.rb_left) {
+			parent = rb_entry(parent->shared.linear.rb.rb_left,
+				struct vm_area_struct, shared.linear.rb);
+			if (parent->shared.linear.rb_subtree_last < last)
+				parent->shared.linear.rb_subtree_last = last;
+		}
+		link = &parent->shared.linear.rb.rb_left;
+	}
+
+	vma->shared.linear.rb_subtree_last = last;
+	rb_link_node(&vma->shared.linear.rb, &parent->shared.linear.rb, link);
+	rb_insert_augmented(&vma->shared.linear.rb, &mapping->i_mmap,
+			    &vma_interval_tree_augment_callbacks);
+}
diff -puN mm/memory-failure.c~mm-replace-vma-prio_tree-with-an-interval-tree mm/memory-failure.c
--- a/mm/memory-failure.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/mm/memory-failure.c
@@ -431,7 +431,6 @@ static void collect_procs_file(struct pa
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
-	struct prio_tree_iter iter;
 	struct address_space *mapping = page->mapping;
 
 	mutex_lock(&mapping->i_mmap_mutex);
@@ -442,7 +441,7 @@ static void collect_procs_file(struct pa
 		if (!task_early_kill(tsk))
 			continue;
 
-		vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff,
+		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff,
 				      pgoff) {
 			/*
 			 * Send early kill signal to tasks where a vma covers
diff -puN mm/memory.c~mm-replace-vma-prio_tree-with-an-interval-tree mm/memory.c
--- a/mm/memory.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/mm/memory.c
@@ -2801,14 +2801,13 @@ static void unmap_mapping_range_vma(stru
 	zap_page_range_single(vma, start_addr, end_addr - start_addr, details);
 }
 
-static inline void unmap_mapping_range_tree(struct prio_tree_root *root,
+static inline void unmap_mapping_range_tree(struct rb_root *root,
 					    struct zap_details *details)
 {
 	struct vm_area_struct *vma;
-	struct prio_tree_iter iter;
 	pgoff_t vba, vea, zba, zea;
 
-	vma_prio_tree_foreach(vma, &iter, root,
+	vma_interval_tree_foreach(vma, root,
 			details->first_index, details->last_index) {
 
 		vba = vma->vm_pgoff;
@@ -2839,7 +2838,7 @@ static inline void unmap_mapping_range_l
 	 * across *all* the pages in each nonlinear VMA, not just the pages
 	 * whose virtual address lies outside the file truncation point.
 	 */
-	list_for_each_entry(vma, head, shared.vm_set.list) {
+	list_for_each_entry(vma, head, shared.nonlinear) {
 		details->nonlinear_vma = vma;
 		unmap_mapping_range_vma(vma, vma->vm_start, vma->vm_end, details);
 	}
@@ -2883,7 +2882,7 @@ void unmap_mapping_range(struct address_
 
 
 	mutex_lock(&mapping->i_mmap_mutex);
-	if (unlikely(!prio_tree_empty(&mapping->i_mmap)))
+	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
diff -puN mm/mmap.c~mm-replace-vma-prio_tree-with-an-interval-tree mm/mmap.c
--- a/mm/mmap.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/mm/mmap.c
@@ -199,14 +199,14 @@ static void __remove_shared_vm_struct(st
 
 	flush_dcache_mmap_lock(mapping);
 	if (unlikely(vma->vm_flags & VM_NONLINEAR))
-		list_del_init(&vma->shared.vm_set.list);
+		list_del_init(&vma->shared.nonlinear);
 	else
-		vma_prio_tree_remove(vma, &mapping->i_mmap);
+		vma_interval_tree_remove(vma, &mapping->i_mmap);
 	flush_dcache_mmap_unlock(mapping);
 }
 
 /*
- * Unlink a file-based vm structure from its prio_tree, to hide
+ * Unlink a file-based vm structure from its interval tree, to hide
  * vma from rmap and vmtruncate before freeing its page tables.
  */
 void unlink_file_vma(struct vm_area_struct *vma)
@@ -411,7 +411,7 @@ static void __vma_link_file(struct vm_ar
 		if (unlikely(vma->vm_flags & VM_NONLINEAR))
 			vma_nonlinear_insert(vma, &mapping->i_mmap_nonlinear);
 		else
-			vma_prio_tree_insert(vma, &mapping->i_mmap);
+			vma_interval_tree_insert(vma, &mapping->i_mmap);
 		flush_dcache_mmap_unlock(mapping);
 	}
 }
@@ -449,7 +449,7 @@ static void vma_link(struct mm_struct *m
 
 /*
  * Helper for vma_adjust() in the split_vma insert case: insert a vma into the
- * mm's list and rbtree.  It has already been inserted into the prio_tree.
+ * mm's list and rbtree.  It has already been inserted into the interval tree.
  */
 static void __insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
@@ -491,7 +491,7 @@ int vma_adjust(struct vm_area_struct *vm
 	struct vm_area_struct *next = vma->vm_next;
 	struct vm_area_struct *importer = NULL;
 	struct address_space *mapping = NULL;
-	struct prio_tree_root *root = NULL;
+	struct rb_root *root = NULL;
 	struct anon_vma *anon_vma = NULL;
 	struct file *file = vma->vm_file;
 	long adjust_next = 0;
@@ -554,7 +554,7 @@ again:			remove_next = 1 + (end > next->
 		mutex_lock(&mapping->i_mmap_mutex);
 		if (insert) {
 			/*
-			 * Put into prio_tree now, so instantiated pages
+			 * Put into interval tree now, so instantiated pages
 			 * are visible to arm/parisc __flush_dcache_page
 			 * throughout; but we cannot insert into address
 			 * space until vma start or end is updated.
@@ -582,9 +582,9 @@ again:			remove_next = 1 + (end > next->
 
 	if (root) {
 		flush_dcache_mmap_lock(mapping);
-		vma_prio_tree_remove(vma, root);
+		vma_interval_tree_remove(vma, root);
 		if (adjust_next)
-			vma_prio_tree_remove(next, root);
+			vma_interval_tree_remove(next, root);
 	}
 
 	vma->vm_start = start;
@@ -597,8 +597,8 @@ again:			remove_next = 1 + (end > next->
 
 	if (root) {
 		if (adjust_next)
-			vma_prio_tree_insert(next, root);
-		vma_prio_tree_insert(vma, root);
+			vma_interval_tree_insert(next, root);
+		vma_interval_tree_insert(vma, root);
 		flush_dcache_mmap_unlock(mapping);
 	}
 
diff -puN mm/nommu.c~mm-replace-vma-prio_tree-with-an-interval-tree mm/nommu.c
--- a/mm/nommu.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/mm/nommu.c
@@ -698,7 +698,7 @@ static void add_vma_to_mm(struct mm_stru
 
 		mutex_lock(&mapping->i_mmap_mutex);
 		flush_dcache_mmap_lock(mapping);
-		vma_prio_tree_insert(vma, &mapping->i_mmap);
+		vma_interval_tree_insert(vma, &mapping->i_mmap);
 		flush_dcache_mmap_unlock(mapping);
 		mutex_unlock(&mapping->i_mmap_mutex);
 	}
@@ -764,7 +764,7 @@ static void delete_vma_from_mm(struct vm
 
 		mutex_lock(&mapping->i_mmap_mutex);
 		flush_dcache_mmap_lock(mapping);
-		vma_prio_tree_remove(vma, &mapping->i_mmap);
+		vma_interval_tree_remove(vma, &mapping->i_mmap);
 		flush_dcache_mmap_unlock(mapping);
 		mutex_unlock(&mapping->i_mmap_mutex);
 	}
@@ -2044,7 +2044,6 @@ int nommu_shrink_inode_mappings(struct i
 				size_t newsize)
 {
 	struct vm_area_struct *vma;
-	struct prio_tree_iter iter;
 	struct vm_region *region;
 	pgoff_t low, high;
 	size_t r_size, r_top;
@@ -2056,8 +2055,7 @@ int nommu_shrink_inode_mappings(struct i
 	mutex_lock(&inode->i_mapping->i_mmap_mutex);
 
 	/* search for VMAs that fall within the dead zone */
-	vma_prio_tree_foreach(vma, &iter, &inode->i_mapping->i_mmap,
-			      low, high) {
+	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap, low, high) {
 		/* found one - only interested if it's shared out of the page
 		 * cache */
 		if (vma->vm_flags & VM_SHARED) {
@@ -2073,8 +2071,8 @@ int nommu_shrink_inode_mappings(struct i
 	 * we don't check for any regions that start beyond the EOF as there
 	 * shouldn't be any
 	 */
-	vma_prio_tree_foreach(vma, &iter, &inode->i_mapping->i_mmap,
-			      0, ULONG_MAX) {
+	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap,
+				  0, ULONG_MAX) {
 		if (!(vma->vm_flags & VM_SHARED))
 			continue;
 
diff -puN mm/prio_tree.c~mm-replace-vma-prio_tree-with-an-interval-tree /dev/null
--- a/mm/prio_tree.c
+++ /dev/null
@@ -1,208 +0,0 @@
-/*
- * mm/prio_tree.c - priority search tree for mapping->i_mmap
- *
- * Copyright (C) 2004, Rajesh Venkatasubramanian <vrajesh@umich.edu>
- *
- * This file is released under the GPL v2.
- *
- * Based on the radix priority search tree proposed by Edward M. McCreight
- * SIAM Journal of Computing, vol. 14, no.2, pages 257-276, May 1985
- *
- * 02Feb2004	Initial version
- */
-
-#include <linux/mm.h>
-#include <linux/prio_tree.h>
-#include <linux/prefetch.h>
-
-/*
- * See lib/prio_tree.c for details on the general radix priority search tree
- * code.
- */
-
-/*
- * The following #defines are mirrored from lib/prio_tree.c. They're only used
- * for debugging, and should be removed (along with the debugging code using
- * them) when switching also VMAs to the regular prio_tree code.
- */
-
-#define RADIX_INDEX(vma)  ((vma)->vm_pgoff)
-#define VMA_SIZE(vma)	  (((vma)->vm_end - (vma)->vm_start) >> PAGE_SHIFT)
-/* avoid overflow */
-#define HEAP_INDEX(vma)   ((vma)->vm_pgoff + (VMA_SIZE(vma) - 1))
-
-/*
- * Radix priority search tree for address_space->i_mmap
- *
- * For each vma that map a unique set of file pages i.e., unique [radix_index,
- * heap_index] value, we have a corresponding priority search tree node. If
- * multiple vmas have identical [radix_index, heap_index] value, then one of
- * them is used as a tree node and others are stored in a vm_set list. The tree
- * node points to the first vma (head) of the list using vm_set.head.
- *
- * prio_tree_root
- *      |
- *      A       vm_set.head
- *     / \      /
- *    L   R -> H-I-J-K-M-N-O-P-Q-S
- *    ^   ^    <-- vm_set.list -->
- *  tree nodes
- *
- * We need some way to identify whether a vma is a tree node, head of a vm_set
- * list, or just a member of a vm_set list. We cannot use vm_flags to store
- * such information. The reason is, in the above figure, it is possible that
- * vm_flags' of R and H are covered by the different mmap_sems. When R is
- * removed under R->mmap_sem, H replaces R as a tree node. Since we do not hold
- * H->mmap_sem, we cannot use H->vm_flags for marking that H is a tree node now.
- * That's why some trick involving shared.vm_set.parent is used for identifying
- * tree nodes and list head nodes.
- *
- * vma radix priority search tree node rules:
- *
- * vma->shared.vm_set.parent != NULL    ==> a tree node
- *      vma->shared.vm_set.head != NULL ==> list of others mapping same range
- *      vma->shared.vm_set.head == NULL ==> no others map the same range
- *
- * vma->shared.vm_set.parent == NULL
- * 	vma->shared.vm_set.head != NULL ==> list head of vmas mapping same range
- * 	vma->shared.vm_set.head == NULL ==> a list node
- */
-
-/*
- * Add a new vma known to map the same set of pages as the old vma:
- * useful for fork's dup_mmap as well as vma_prio_tree_insert below.
- * Note that it just happens to work correctly on i_mmap_nonlinear too.
- */
-void vma_prio_tree_add(struct vm_area_struct *vma, struct vm_area_struct *old)
-{
-	/* Leave these BUG_ONs till prio_tree patch stabilizes */
-	BUG_ON(RADIX_INDEX(vma) != RADIX_INDEX(old));
-	BUG_ON(HEAP_INDEX(vma) != HEAP_INDEX(old));
-
-	vma->shared.vm_set.head = NULL;
-	vma->shared.vm_set.parent = NULL;
-
-	if (!old->shared.vm_set.parent)
-		list_add(&vma->shared.vm_set.list,
-				&old->shared.vm_set.list);
-	else if (old->shared.vm_set.head)
-		list_add_tail(&vma->shared.vm_set.list,
-				&old->shared.vm_set.head->shared.vm_set.list);
-	else {
-		INIT_LIST_HEAD(&vma->shared.vm_set.list);
-		vma->shared.vm_set.head = old;
-		old->shared.vm_set.head = vma;
-	}
-}
-
-void vma_prio_tree_insert(struct vm_area_struct *vma,
-			  struct prio_tree_root *root)
-{
-	struct prio_tree_node *ptr;
-	struct vm_area_struct *old;
-
-	vma->shared.vm_set.head = NULL;
-
-	ptr = raw_prio_tree_insert(root, &vma->shared.prio_tree_node);
-	if (ptr != (struct prio_tree_node *) &vma->shared.prio_tree_node) {
-		old = prio_tree_entry(ptr, struct vm_area_struct,
-					shared.prio_tree_node);
-		vma_prio_tree_add(vma, old);
-	}
-}
-
-void vma_prio_tree_remove(struct vm_area_struct *vma,
-			  struct prio_tree_root *root)
-{
-	struct vm_area_struct *node, *head, *new_head;
-
-	if (!vma->shared.vm_set.head) {
-		if (!vma->shared.vm_set.parent)
-			list_del_init(&vma->shared.vm_set.list);
-		else
-			raw_prio_tree_remove(root, &vma->shared.prio_tree_node);
-	} else {
-		/* Leave this BUG_ON till prio_tree patch stabilizes */
-		BUG_ON(vma->shared.vm_set.head->shared.vm_set.head != vma);
-		if (vma->shared.vm_set.parent) {
-			head = vma->shared.vm_set.head;
-			if (!list_empty(&head->shared.vm_set.list)) {
-				new_head = list_entry(
-					head->shared.vm_set.list.next,
-					struct vm_area_struct,
-					shared.vm_set.list);
-				list_del_init(&head->shared.vm_set.list);
-			} else
-				new_head = NULL;
-
-			raw_prio_tree_replace(root, &vma->shared.prio_tree_node,
-					&head->shared.prio_tree_node);
-			head->shared.vm_set.head = new_head;
-			if (new_head)
-				new_head->shared.vm_set.head = head;
-
-		} else {
-			node = vma->shared.vm_set.head;
-			if (!list_empty(&vma->shared.vm_set.list)) {
-				new_head = list_entry(
-					vma->shared.vm_set.list.next,
-					struct vm_area_struct,
-					shared.vm_set.list);
-				list_del_init(&vma->shared.vm_set.list);
-				node->shared.vm_set.head = new_head;
-				new_head->shared.vm_set.head = node;
-			} else
-				node->shared.vm_set.head = NULL;
-		}
-	}
-}
-
-/*
- * Helper function to enumerate vmas that map a given file page or a set of
- * contiguous file pages. The function returns vmas that at least map a single
- * page in the given range of contiguous file pages.
- */
-struct vm_area_struct *vma_prio_tree_next(struct vm_area_struct *vma,
-					struct prio_tree_iter *iter)
-{
-	struct prio_tree_node *ptr;
-	struct vm_area_struct *next;
-
-	if (!vma) {
-		/*
-		 * First call is with NULL vma
-		 */
-		ptr = prio_tree_next(iter);
-		if (ptr) {
-			next = prio_tree_entry(ptr, struct vm_area_struct,
-						shared.prio_tree_node);
-			prefetch(next->shared.vm_set.head);
-			return next;
-		} else
-			return NULL;
-	}
-
-	if (vma->shared.vm_set.parent) {
-		if (vma->shared.vm_set.head) {
-			next = vma->shared.vm_set.head;
-			prefetch(next->shared.vm_set.list.next);
-			return next;
-		}
-	} else {
-		next = list_entry(vma->shared.vm_set.list.next,
-				struct vm_area_struct, shared.vm_set.list);
-		if (!next->shared.vm_set.head) {
-			prefetch(next->shared.vm_set.list.next);
-			return next;
-		}
-	}
-
-	ptr = prio_tree_next(iter);
-	if (ptr) {
-		next = prio_tree_entry(ptr, struct vm_area_struct,
-					shared.prio_tree_node);
-		prefetch(next->shared.vm_set.head);
-		return next;
-	} else
-		return NULL;
-}
diff -puN mm/rmap.c~mm-replace-vma-prio_tree-with-an-interval-tree mm/rmap.c
--- a/mm/rmap.c~mm-replace-vma-prio_tree-with-an-interval-tree
+++ a/mm/rmap.c
@@ -820,7 +820,6 @@ static int page_referenced_file(struct p
 	struct address_space *mapping = page->mapping;
 	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 	struct vm_area_struct *vma;
-	struct prio_tree_iter iter;
 	int referenced = 0;
 
 	/*
@@ -846,7 +845,7 @@ static int page_referenced_file(struct p
 	 */
 	mapcount = page_mapcount(page);
 
-	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
 			continue;
@@ -945,13 +944,12 @@ static int page_mkclean_file(struct addr
 {
 	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 	struct vm_area_struct *vma;
-	struct prio_tree_iter iter;
 	int ret = 0;
 
 	BUG_ON(PageAnon(page));
 
 	mutex_lock(&mapping->i_mmap_mutex);
-	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		if (vma->vm_flags & VM_SHARED) {
 			unsigned long address = vma_address(page, vma);
 			if (address == -EFAULT)
@@ -1547,7 +1545,6 @@ static int try_to_unmap_file(struct page
 	struct address_space *mapping = page->mapping;
 	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 	struct vm_area_struct *vma;
-	struct prio_tree_iter iter;
 	int ret = SWAP_AGAIN;
 	unsigned long cursor;
 	unsigned long max_nl_cursor = 0;
@@ -1555,7 +1552,7 @@ static int try_to_unmap_file(struct page
 	unsigned int mapcount;
 
 	mutex_lock(&mapping->i_mmap_mutex);
-	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
 			continue;
@@ -1576,7 +1573,7 @@ static int try_to_unmap_file(struct page
 		goto out;
 
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear,
-						shared.vm_set.list) {
+							shared.nonlinear) {
 		cursor = (unsigned long) vma->vm_private_data;
 		if (cursor > max_nl_cursor)
 			max_nl_cursor = cursor;
@@ -1608,7 +1605,7 @@ static int try_to_unmap_file(struct page
 
 	do {
 		list_for_each_entry(vma, &mapping->i_mmap_nonlinear,
-						shared.vm_set.list) {
+							shared.nonlinear) {
 			cursor = (unsigned long) vma->vm_private_data;
 			while ( cursor < max_nl_cursor &&
 				cursor < vma->vm_end - vma->vm_start) {
@@ -1631,7 +1628,7 @@ static int try_to_unmap_file(struct page
 	 * in locked vmas).  Reset cursor on all unreserved nonlinear
 	 * vmas, now forgetting on which ones it had fallen behind.
 	 */
-	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list)
+	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.nonlinear)
 		vma->vm_private_data = NULL;
 out:
 	mutex_unlock(&mapping->i_mmap_mutex);
@@ -1748,13 +1745,12 @@ static int rmap_walk_file(struct page *p
 	struct address_space *mapping = page->mapping;
 	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 	struct vm_area_struct *vma;
-	struct prio_tree_iter iter;
 	int ret = SWAP_AGAIN;
 
 	if (!mapping)
 		return ret;
 	mutex_lock(&mapping->i_mmap_mutex);
-	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
 			continue;
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

