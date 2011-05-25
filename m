From: akpm@linux-foundation.org
Subject: [merged] mm-nommu-sort-mm-mmap-list-properly.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:19 -0700
Message-ID: <201105252025.p4PKPgkf014418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755914Ab1EYUtt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     mm: nommu: sort mm->mmap list properly
has been removed from the -mm tree.  Its filename was
     mm-nommu-sort-mm-mmap-list-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: nommu: sort mm->mmap list properly
From: Namhyung Kim <namhyung@gmail.com>

When I was reading nommu code, I found that it handles the vma list/tree
in an unusual way.  IIUC, because there can be more than one
identical/overrapped vmas in the list/tree, it sorts the tree more
strictly and does a linear search on the tree.  But it doesn't applied to
the list (i.e.  the list could be constructed in a different order than
the tree so that we can't use the list when finding the first vma in that
order).

Since inserting/sorting a vma in the tree and link is done at the same
time, we can easily construct both of them in the same order.  And linear
searching on the tree could be more costly than doing it on the list, it
can be converted to use the list.

Also, after the commit 297c5eee3724 ("mm: make the vma list be doubly
linked") made the list be doubly linked, there were a couple of code need
to be fixed to construct the list properly.

Patch 1/6 is a preparation.  It maintains the list sorted same as the tree
and construct doubly-linked list properly.  Patch 2/6 is a simple
optimization for the vma deletion.  Patch 3/6 and 4/6 convert tree
traversal to list traversal and the rest are simple fixes and cleanups.



This patch:

@vma added into @mm should be sorted by start addr, end addr and VMA
struct addr in that order because we may get identical VMAs in the @mm. 
However this was true only for the rbtree, not for the list.

This patch fixes this by remembering 'rb_prev' during the tree traversal
like find_vma_prepare() does and linking the @vma via __vma_link_list(). 
After this patch, we can iterate the whole VMAs in correct order simply by
using @mm->mmap list.

[akpm@linux-foundation.org: avoid duplicating __vma_link_list()]
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 ++++
 mm/mmap.c     |   23 -----------------------
 mm/nommu.c    |   38 ++++++++++++++++----------------------
 mm/util.c     |   24 ++++++++++++++++++++++++
 4 files changed, 44 insertions(+), 45 deletions(-)

diff -puN mm/internal.h~mm-nommu-sort-mm-mmap-list-properly mm/internal.h
--- a/mm/internal.h~mm-nommu-sort-mm-mmap-list-properly
+++ a/mm/internal.h
@@ -66,6 +66,10 @@ static inline unsigned long page_order(s
 	return page_private(page);
 }
 
+/* mm/util.c */
+void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
+		struct vm_area_struct *prev, struct rb_node *rb_parent);
+
 #ifdef CONFIG_MMU
 extern long mlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
diff -puN mm/mmap.c~mm-nommu-sort-mm-mmap-list-properly mm/mmap.c
--- a/mm/mmap.c~mm-nommu-sort-mm-mmap-list-properly
+++ a/mm/mmap.c
@@ -398,29 +398,6 @@ find_vma_prepare(struct mm_struct *mm, u
 	return vma;
 }
 
-static inline void
-__vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
-		struct vm_area_struct *prev, struct rb_node *rb_parent)
-{
-	struct vm_area_struct *next;
-
-	vma->vm_prev = prev;
-	if (prev) {
-		next = prev->vm_next;
-		prev->vm_next = vma;
-	} else {
-		mm->mmap = vma;
-		if (rb_parent)
-			next = rb_entry(rb_parent,
-					struct vm_area_struct, vm_rb);
-		else
-			next = NULL;
-	}
-	vma->vm_next = next;
-	if (next)
-		next->vm_prev = vma;
-}
-
 void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct rb_node **rb_link, struct rb_node *rb_parent)
 {
diff -puN mm/nommu.c~mm-nommu-sort-mm-mmap-list-properly mm/nommu.c
--- a/mm/nommu.c~mm-nommu-sort-mm-mmap-list-properly
+++ a/mm/nommu.c
@@ -680,9 +680,9 @@ static void protect_vma(struct vm_area_s
  */
 static void add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	struct vm_area_struct *pvma, **pp, *next;
+	struct vm_area_struct *pvma, *prev;
 	struct address_space *mapping;
-	struct rb_node **p, *parent;
+	struct rb_node **p, *parent, *rb_prev;
 
 	kenter(",%p", vma);
 
@@ -703,7 +703,7 @@ static void add_vma_to_mm(struct mm_stru
 	}
 
 	/* add the VMA to the tree */
-	parent = NULL;
+	parent = rb_prev = NULL;
 	p = &mm->mm_rb.rb_node;
 	while (*p) {
 		parent = *p;
@@ -713,17 +713,20 @@ static void add_vma_to_mm(struct mm_stru
 		 * (the latter is necessary as we may get identical VMAs) */
 		if (vma->vm_start < pvma->vm_start)
 			p = &(*p)->rb_left;
-		else if (vma->vm_start > pvma->vm_start)
+		else if (vma->vm_start > pvma->vm_start) {
+			rb_prev = parent;
 			p = &(*p)->rb_right;
-		else if (vma->vm_end < pvma->vm_end)
+		} else if (vma->vm_end < pvma->vm_end)
 			p = &(*p)->rb_left;
-		else if (vma->vm_end > pvma->vm_end)
+		else if (vma->vm_end > pvma->vm_end) {
+			rb_prev = parent;
 			p = &(*p)->rb_right;
-		else if (vma < pvma)
+		} else if (vma < pvma)
 			p = &(*p)->rb_left;
-		else if (vma > pvma)
+		else if (vma > pvma) {
+			rb_prev = parent;
 			p = &(*p)->rb_right;
-		else
+		} else
 			BUG();
 	}
 
@@ -731,20 +734,11 @@ static void add_vma_to_mm(struct mm_stru
 	rb_insert_color(&vma->vm_rb, &mm->mm_rb);
 
 	/* add VMA to the VMA list also */
-	for (pp = &mm->mmap; (pvma = *pp); pp = &(*pp)->vm_next) {
-		if (pvma->vm_start > vma->vm_start)
-			break;
-		if (pvma->vm_start < vma->vm_start)
-			continue;
-		if (pvma->vm_end < vma->vm_end)
-			break;
-	}
+	prev = NULL;
+	if (rb_prev)
+		prev = rb_entry(rb_prev, struct vm_area_struct, vm_rb);
 
-	next = *pp;
-	*pp = vma;
-	vma->vm_next = next;
-	if (next)
-		next->vm_prev = vma;
+	__vma_link_list(mm, vma, prev, parent);
 }
 
 /*
diff -puN mm/util.c~mm-nommu-sort-mm-mmap-list-properly mm/util.c
--- a/mm/util.c~mm-nommu-sort-mm-mmap-list-properly
+++ a/mm/util.c
@@ -6,6 +6,8 @@
 #include <linux/sched.h>
 #include <asm/uaccess.h>
 
+#include "internal.h"
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/kmem.h>
 
@@ -215,6 +217,28 @@ char *strndup_user(const char __user *s,
 }
 EXPORT_SYMBOL(strndup_user);
 
+void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
+		struct vm_area_struct *prev, struct rb_node *rb_parent)
+{
+	struct vm_area_struct *next;
+
+	vma->vm_prev = prev;
+	if (prev) {
+		next = prev->vm_next;
+		prev->vm_next = vma;
+	} else {
+		mm->mmap = vma;
+		if (rb_parent)
+			next = rb_entry(rb_parent,
+					struct vm_area_struct, vm_rb);
+		else
+			next = NULL;
+	}
+	vma->vm_next = next;
+	if (next)
+		next->vm_prev = vma;
+}
+
 #if defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch

