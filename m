From: akpm@linux-foundation.org
Subject: + mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch added to -mm tree
Date: Wed, 08 Dec 2010 15:42:43 -0800
Message-ID: <201012082342.oB8NghR2016604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754208Ab0LHXnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2010 18:43:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, hpa@zytor.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.com, tglx@linutronix.de


The patch titled
     mlock: do not hold mmap_sem for extended periods of time
has been added to the -mm tree.  Its filename is
     mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock: do not hold mmap_sem for extended periods of time
From: Michel Lespinasse <walken@google.com>

__get_user_pages gets a new 'nonblocking' parameter to signal that the
caller is prepared to re-acquire mmap_sem and retry the operation if
needed.  This is used to split off long operations if they are going to
block on a disk transfer, or when we detect contention on the mmap_sem.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 ++-
 mm/memory.c   |   35 ++++++++++++++++++++++++++---------
 mm/mlock.c    |   32 +++++++++++++++++++-------------
 mm/nommu.c    |    6 ++++--
 4 files changed, 51 insertions(+), 25 deletions(-)

diff -puN mm/internal.h~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time mm/internal.h
--- a/mm/internal.h~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time
+++ a/mm/internal.h
@@ -243,7 +243,8 @@ static inline void mminit_validate_memmo
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int len, unsigned int foll_flags,
-		     struct page **pages, struct vm_area_struct **vmas);
+		     struct page **pages, struct vm_area_struct **vmas,
+		     int *nonblocking);
 
 #define ZONE_RECLAIM_NOSCAN	-2
 #define ZONE_RECLAIM_FULL	-1
diff -puN mm/memory.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time mm/memory.c
--- a/mm/memory.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time
+++ a/mm/memory.c
@@ -1363,7 +1363,8 @@ no_page_table:
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int nr_pages, unsigned int gup_flags,
-		     struct page **pages, struct vm_area_struct **vmas)
+		     struct page **pages, struct vm_area_struct **vmas,
+		     int *nonblocking)
 {
 	int i;
 	unsigned long vm_flags;
@@ -1463,13 +1464,17 @@ int __get_user_pages(struct task_struct 
 			cond_resched();
 			while (!(page = follow_page(vma, start, foll_flags))) {
 				int ret;
-				unsigned int fault_fl =
-					((foll_flags & FOLL_WRITE) ?
-					FAULT_FLAG_WRITE : 0) |
-					((foll_flags & FOLL_MINOR) ?
-					FAULT_FLAG_MINOR : 0);
+				unsigned int fault_flags = 0;
 
-				ret = handle_mm_fault(mm, vma, start, fault_fl);
+				if (foll_flags & FOLL_WRITE)
+					fault_flags |= FAULT_FLAG_WRITE;
+				if (nonblocking)
+					fault_flags |= FAULT_FLAG_ALLOW_RETRY;
+				if (foll_flags & FOLL_MINOR)
+					fault_flags |= FAULT_FLAG_MINOR;
+
+				ret = handle_mm_fault(mm, vma, start,
+							fault_flags);
 
 				if (ret & VM_FAULT_ERROR) {
 					if (ret & VM_FAULT_OOM)
@@ -1487,6 +1492,11 @@ int __get_user_pages(struct task_struct 
 				else
 					tsk->min_flt++;
 
+				if (ret & VM_FAULT_RETRY) {
+					*nonblocking = 0;
+					return i;
+				}
+
 				/*
 				 * The VM_FAULT_WRITE bit tells us that
 				 * do_wp_page has broken COW when necessary,
@@ -1518,6 +1528,11 @@ int __get_user_pages(struct task_struct 
 			i++;
 			start += PAGE_SIZE;
 			nr_pages--;
+			if (nonblocking && rwsem_is_contended(&mm->mmap_sem)) {
+				up_read(&mm->mmap_sem);
+				*nonblocking = 0;
+				return i;
+			}
 		} while (nr_pages && start < vma->vm_end);
 	} while (nr_pages);
 	return i;
@@ -1586,7 +1601,8 @@ int get_user_pages(struct task_struct *t
 	if (force)
 		flags |= FOLL_FORCE;
 
-	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas);
+	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas,
+				NULL);
 }
 EXPORT_SYMBOL(get_user_pages);
 
@@ -1628,7 +1644,8 @@ struct page *get_dump_page(unsigned long
 	struct page *page;
 
 	if (__get_user_pages(current, current->mm, addr, 1,
-			FOLL_FORCE | FOLL_DUMP | FOLL_GET, &page, &vma) < 1)
+			     FOLL_FORCE | FOLL_DUMP | FOLL_GET, &page, &vma,
+			     NULL) < 1)
 		return NULL;
 	flush_cache_page(vma, addr, page_to_pfn(page));
 	return page;
diff -puN mm/mlock.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time mm/mlock.c
--- a/mm/mlock.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time
+++ a/mm/mlock.c
@@ -155,13 +155,13 @@ static inline int stack_guard_page(struc
  * vma->vm_mm->mmap_sem must be held for at least read.
  */
 static long __mlock_vma_pages_range(struct vm_area_struct *vma,
-				    unsigned long start, unsigned long end)
+				    unsigned long start, unsigned long end,
+				    int *nonblocking)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = start;
 	int nr_pages = (end - start) / PAGE_SIZE;
 	int gup_flags;
-	int ret;
 
 	VM_BUG_ON(start & ~PAGE_MASK);
 	VM_BUG_ON(end   & ~PAGE_MASK);
@@ -187,9 +187,8 @@ static long __mlock_vma_pages_range(stru
 		nr_pages--;
 	}
 
-	ret = __get_user_pages(current, mm, addr, nr_pages, gup_flags,
-			       NULL, NULL);
-	return max(ret, 0);	/* 0 or negative error code */
+	return __get_user_pages(current, mm, addr, nr_pages, gup_flags,
+				NULL, NULL, nonblocking);
 }
 
 /*
@@ -233,7 +232,7 @@ long mlock_vma_pages_range(struct vm_are
 			is_vm_hugetlb_page(vma) ||
 			vma == get_gate_vma(current))) {
 
-		__mlock_vma_pages_range(vma, start, end);
+		__mlock_vma_pages_range(vma, start, end, NULL);
 
 		/* Hide errors from mmap() and other callers */
 		return 0;
@@ -429,21 +428,23 @@ static int do_mlock_pages(unsigned long 
 	struct mm_struct *mm = current->mm;
 	unsigned long end, nstart, nend;
 	struct vm_area_struct *vma = NULL;
+	int locked = 0;
 	int ret = 0;
 
 	VM_BUG_ON(start & ~PAGE_MASK);
 	VM_BUG_ON(len != PAGE_ALIGN(len));
 	end = start + len;
 
-	down_read(&mm->mmap_sem);
 	for (nstart = start; nstart < end; nstart = nend) {
 		/*
 		 * We want to fault in pages for [nstart; end) address range.
 		 * Find first corresponding VMA.
 		 */
-		if (!vma)
+		if (!locked) {
+			locked = 1;
+			down_read(&mm->mmap_sem);
 			vma = find_vma(mm, nstart);
-		else
+		} else if (nstart >= vma->vm_end)
 			vma = vma->vm_next;
 		if (!vma || vma->vm_start >= end)
 			break;
@@ -457,15 +458,20 @@ static int do_mlock_pages(unsigned long 
 		if (nstart < vma->vm_start)
 			nstart = vma->vm_start;
 		/*
-		 * Now fault in a range of pages within the first VMA.
+		 * Now fault in a range of pages. __mlock_vma_pages_range()
+		 * double checks the vma flags, so that it won't mlock pages
+		 * if the vma was already munlocked.
 		 */
-		ret = __mlock_vma_pages_range(vma, nstart, nend);
-		if (ret) {
+		ret = __mlock_vma_pages_range(vma, nstart, nend, &locked);
+		if (ret < 0) {
 			ret = __mlock_posix_error_return(ret);
 			break;
 		}
+		nend = nstart + ret * PAGE_SIZE;
+		ret = 0;
 	}
-	up_read(&mm->mmap_sem);
+	if (locked)
+		up_read(&mm->mmap_sem);
 	return ret;	/* 0 or negative error code */
 }
 
diff -puN mm/nommu.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time mm/nommu.c
--- a/mm/nommu.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time
+++ a/mm/nommu.c
@@ -127,7 +127,8 @@ unsigned int kobjsize(const void *objp)
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int nr_pages, unsigned int foll_flags,
-		     struct page **pages, struct vm_area_struct **vmas)
+		     struct page **pages, struct vm_area_struct **vmas,
+		     int *retry)
 {
 	struct vm_area_struct *vma;
 	unsigned long vm_flags;
@@ -185,7 +186,8 @@ int get_user_pages(struct task_struct *t
 	if (force)
 		flags |= FOLL_FORCE;
 
-	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas);
+	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas,
+				NULL);
 }
 EXPORT_SYMBOL(get_user_pages);
 
_

Patches currently in -mm which might be from walken@google.com are

do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
rwsem-implement-rwsem_is_contended.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
x86-rwsem-more-precise-rwsem_is_contended-implementation.patch

