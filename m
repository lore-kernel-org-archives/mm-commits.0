From: akpm@linux-foundation.org
Subject: [merged] mm-foll-flags-for-gup-flags.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:43:01 -0700
Message-ID: <200909222043.n8MKh14x010752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072AbZIVUnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: FOLL flags for GUP flags
has been removed from the -mm tree.  Its filename was
     mm-foll-flags-for-gup-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: FOLL flags for GUP flags
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

__get_user_pages() has been taking its own GUP flags, then processing
them into FOLL flags for follow_page().  Though oddly named, the FOLL
flags are more widely used, so pass them to __get_user_pages() now.
Sorry, VM flags, VM_FAULT flags and FAULT_FLAGs are still distinct.

(The patch to __get_user_pages() looks peculiar, with both gup_flags
and foll_flags: the gup_flags remain constant; but as before there's
an exceptional case, out of scope of the patch, in which foll_flags
per page have FOLL_WRITE masked off.)

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/internal.h      |    6 -----
 mm/memory.c        |   44 ++++++++++++++++++-------------------------
 mm/mlock.c         |    4 +--
 mm/nommu.c         |   16 +++++++--------
 5 files changed, 31 insertions(+), 40 deletions(-)

diff -puN include/linux/mm.h~mm-foll-flags-for-gup-flags include/linux/mm.h
--- a/include/linux/mm.h~mm-foll-flags-for-gup-flags
+++ a/include/linux/mm.h
@@ -1232,6 +1232,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_TOUCH	0x02	/* mark page accessed */
 #define FOLL_GET	0x04	/* do get_page on page */
 #define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
+#define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff -puN mm/internal.h~mm-foll-flags-for-gup-flags mm/internal.h
--- a/mm/internal.h~mm-foll-flags-for-gup-flags
+++ a/mm/internal.h
@@ -250,12 +250,8 @@ static inline void mminit_validate_memmo
 }
 #endif /* CONFIG_SPARSEMEM */
 
-#define GUP_FLAGS_WRITE		0x01
-#define GUP_FLAGS_FORCE		0x02
-#define GUP_FLAGS_DUMP		0x04
-
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		     unsigned long start, int len, int flags,
+		     unsigned long start, int len, unsigned int foll_flags,
 		     struct page **pages, struct vm_area_struct **vmas);
 
 #define ZONE_RECLAIM_NOSCAN	-2
diff -puN mm/memory.c~mm-foll-flags-for-gup-flags mm/memory.c
--- a/mm/memory.c~mm-foll-flags-for-gup-flags
+++ a/mm/memory.c
@@ -1209,27 +1209,29 @@ no_page_table:
 }
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		     unsigned long start, int nr_pages, int flags,
+		     unsigned long start, int nr_pages, unsigned int gup_flags,
 		     struct page **pages, struct vm_area_struct **vmas)
 {
 	int i;
-	unsigned int vm_flags = 0;
-	int write = !!(flags & GUP_FLAGS_WRITE);
-	int force = !!(flags & GUP_FLAGS_FORCE);
+	unsigned long vm_flags;
 
 	if (nr_pages <= 0)
 		return 0;
+
+	VM_BUG_ON(!!pages != !!(gup_flags & FOLL_GET));
+
 	/* 
 	 * Require read or write permissions.
-	 * If 'force' is set, we only require the "MAY" flags.
+	 * If FOLL_FORCE is set, we only require the "MAY" flags.
 	 */
-	vm_flags  = write ? (VM_WRITE | VM_MAYWRITE) : (VM_READ | VM_MAYREAD);
-	vm_flags &= force ? (VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
+	vm_flags  = (gup_flags & FOLL_WRITE) ?
+			(VM_WRITE | VM_MAYWRITE) : (VM_READ | VM_MAYREAD);
+	vm_flags &= (gup_flags & FOLL_FORCE) ?
+			(VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
 	i = 0;
 
 	do {
 		struct vm_area_struct *vma;
-		unsigned int foll_flags;
 
 		vma = find_extend_vma(mm, start);
 		if (!vma && in_gate_area(tsk, start)) {
@@ -1241,7 +1243,7 @@ int __get_user_pages(struct task_struct 
 			pte_t *pte;
 
 			/* user gate pages are read-only */
-			if (write)
+			if (gup_flags & FOLL_WRITE)
 				return i ? : -EFAULT;
 			if (pg > TASK_SIZE)
 				pgd = pgd_offset_k(pg);
@@ -1278,22 +1280,15 @@ int __get_user_pages(struct task_struct 
 		    !(vm_flags & vma->vm_flags))
 			return i ? : -EFAULT;
 
-		foll_flags = FOLL_TOUCH;
-		if (pages)
-			foll_flags |= FOLL_GET;
-		if (flags & GUP_FLAGS_DUMP)
-			foll_flags |= FOLL_DUMP;
-		if (write)
-			foll_flags |= FOLL_WRITE;
-
 		if (is_vm_hugetlb_page(vma)) {
 			i = follow_hugetlb_page(mm, vma, pages, vmas,
-					&start, &nr_pages, i, foll_flags);
+					&start, &nr_pages, i, gup_flags);
 			continue;
 		}
 
 		do {
 			struct page *page;
+			unsigned int foll_flags = gup_flags;
 
 			/*
 			 * If we have a pending SIGKILL, don't keep faulting
@@ -1302,9 +1297,6 @@ int __get_user_pages(struct task_struct 
 			if (unlikely(fatal_signal_pending(current)))
 				return i ? i : -ERESTARTSYS;
 
-			if (write)
-				foll_flags |= FOLL_WRITE;
-
 			cond_resched();
 			while (!(page = follow_page(vma, start, foll_flags))) {
 				int ret;
@@ -1415,12 +1407,14 @@ int get_user_pages(struct task_struct *t
 		unsigned long start, int nr_pages, int write, int force,
 		struct page **pages, struct vm_area_struct **vmas)
 {
-	int flags = 0;
+	int flags = FOLL_TOUCH;
 
+	if (pages)
+		flags |= FOLL_GET;
 	if (write)
-		flags |= GUP_FLAGS_WRITE;
+		flags |= FOLL_WRITE;
 	if (force)
-		flags |= GUP_FLAGS_FORCE;
+		flags |= FOLL_FORCE;
 
 	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas);
 }
@@ -1447,7 +1441,7 @@ struct page *get_dump_page(unsigned long
 	struct page *page;
 
 	if (__get_user_pages(current, current->mm, addr, 1,
-			GUP_FLAGS_FORCE | GUP_FLAGS_DUMP, &page, &vma) < 1)
+			FOLL_FORCE | FOLL_DUMP | FOLL_GET, &page, &vma) < 1)
 		return NULL;
 	if (page == ZERO_PAGE(0)) {
 		page_cache_release(page);
diff -puN mm/mlock.c~mm-foll-flags-for-gup-flags mm/mlock.c
--- a/mm/mlock.c~mm-foll-flags-for-gup-flags
+++ a/mm/mlock.c
@@ -166,9 +166,9 @@ static long __mlock_vma_pages_range(stru
 	VM_BUG_ON(end   > vma->vm_end);
 	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
-	gup_flags = 0;
+	gup_flags = FOLL_TOUCH | FOLL_GET;
 	if (vma->vm_flags & VM_WRITE)
-		gup_flags = GUP_FLAGS_WRITE;
+		gup_flags |= FOLL_WRITE;
 
 	while (nr_pages > 0) {
 		int i;
diff -puN mm/nommu.c~mm-foll-flags-for-gup-flags mm/nommu.c
--- a/mm/nommu.c~mm-foll-flags-for-gup-flags
+++ a/mm/nommu.c
@@ -168,20 +168,20 @@ unsigned int kobjsize(const void *objp)
 }
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		     unsigned long start, int nr_pages, int flags,
+		     unsigned long start, int nr_pages, int foll_flags,
 		     struct page **pages, struct vm_area_struct **vmas)
 {
 	struct vm_area_struct *vma;
 	unsigned long vm_flags;
 	int i;
-	int write = !!(flags & GUP_FLAGS_WRITE);
-	int force = !!(flags & GUP_FLAGS_FORCE);
 
 	/* calculate required read or write permissions.
-	 * - if 'force' is set, we only require the "MAY" flags.
+	 * If FOLL_FORCE is set, we only require the "MAY" flags.
 	 */
-	vm_flags  = write ? (VM_WRITE | VM_MAYWRITE) : (VM_READ | VM_MAYREAD);
-	vm_flags &= force ? (VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
+	vm_flags  = (foll_flags & FOLL_WRITE) ?
+			(VM_WRITE | VM_MAYWRITE) : (VM_READ | VM_MAYREAD);
+	vm_flags &= (foll_flags & FOLL_FORCE) ?
+			(VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
 
 	for (i = 0; i < nr_pages; i++) {
 		vma = find_vma(mm, start);
@@ -223,9 +223,9 @@ int get_user_pages(struct task_struct *t
 	int flags = 0;
 
 	if (write)
-		flags |= GUP_FLAGS_WRITE;
+		flags |= FOLL_WRITE;
 	if (force)
-		flags |= GUP_FLAGS_FORCE;
+		flags |= FOLL_FORCE;
 
 	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas);
 }
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

