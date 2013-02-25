From: akpm@linux-foundation.org
Subject: [merged] mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:49:23 -0800
Message-ID: <20130225204923.BF9A031C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:37419 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401Ab3BYUtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:49:25 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so345871ghb.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:49:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: directly use __mlock_vma_pages_range() in find_extend_vma()
has been removed from the -mm tree.  Its filename was
     mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: directly use __mlock_vma_pages_range() in find_extend_vma()

In find_extend_vma(), we don't need mlock_vma_pages_range() to verify the
vma type - we know we're working with a stack. So, we can call directly
into __mlock_vma_pages_range(), and remove the last make_pages_present()
call site.

Note that we don't use mm_populate() here, so we can't release the mmap_sem
while allocating new stack pages. This is deemed acceptable, because the
stack vmas grow by a bounded number of pages at a time, and these are
anon pages so we don't have to read from disk to populate them.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Tested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Ungerer <gregungerer@westnet.com.au>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/internal.h      |    4 +--
 mm/memory.c        |   24 ------------------
 mm/mlock.c         |   57 ++-----------------------------------------
 mm/mmap.c          |   10 +++----
 5 files changed, 9 insertions(+), 87 deletions(-)

diff -puN include/linux/mm.h~mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma include/linux/mm.h
--- a/include/linux/mm.h~mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma
+++ a/include/linux/mm.h
@@ -1035,7 +1035,6 @@ static inline int fixup_user_fault(struc
 }
 #endif
 
-extern int make_pages_present(unsigned long addr, unsigned long end);
 extern int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write);
 extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, int write);
diff -puN mm/internal.h~mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma mm/internal.h
--- a/mm/internal.h~mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma
+++ a/mm/internal.h
@@ -162,8 +162,8 @@ void __vma_link_list(struct mm_struct *m
 		struct vm_area_struct *prev, struct rb_node *rb_parent);
 
 #ifdef CONFIG_MMU
-extern long mlock_vma_pages_range(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end);
+extern long __mlock_vma_pages_range(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, int *nonblocking);
 extern void munlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
 static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
diff -puN mm/memory.c~mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma mm/memory.c
--- a/mm/memory.c~mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma
+++ a/mm/memory.c
@@ -3824,30 +3824,6 @@ int __pmd_alloc(struct mm_struct *mm, pu
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-int make_pages_present(unsigned long addr, unsigned long end)
-{
-	int ret, len, write;
-	struct vm_area_struct * vma;
-
-	vma = find_vma(current->mm, addr);
-	if (!vma)
-		return -ENOMEM;
-	/*
-	 * We want to touch writable mappings with a write fault in order
-	 * to break COW, except for shared mappings because these don't COW
-	 * and we would not want to dirty them for nothing.
-	 */
-	write = (vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE;
-	BUG_ON(addr >= end);
-	BUG_ON(end > vma->vm_end);
-	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
-	ret = get_user_pages(current, current->mm, addr,
-			len, write, 0, NULL, NULL);
-	if (ret < 0)
-		return ret;
-	return ret == len ? 0 : -EFAULT;
-}
-
 #if !defined(__HAVE_ARCH_GATE_AREA)
 
 #if defined(AT_SYSINFO_EHDR)
diff -puN mm/mlock.c~mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma mm/mlock.c
--- a/mm/mlock.c~mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma
+++ a/mm/mlock.c
@@ -155,9 +155,8 @@ void munlock_vma_page(struct page *page)
  *
  * vma->vm_mm->mmap_sem must be held for at least read.
  */
-static long __mlock_vma_pages_range(struct vm_area_struct *vma,
-				    unsigned long start, unsigned long end,
-				    int *nonblocking)
+long __mlock_vma_pages_range(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, int *nonblocking)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = start;
@@ -202,56 +201,6 @@ static int __mlock_posix_error_return(lo
 	return retval;
 }
 
-/**
- * mlock_vma_pages_range() - mlock pages in specified vma range.
- * @vma - the vma containing the specfied address range
- * @start - starting address in @vma to mlock
- * @end   - end address [+1] in @vma to mlock
- *
- * For mmap()/mremap()/expansion of mlocked vma.
- *
- * return 0 on success for "normal" vmas.
- *
- * return number of pages [> 0] to be removed from locked_vm on success
- * of "special" vmas.
- */
-long mlock_vma_pages_range(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end)
-{
-	int nr_pages = (end - start) / PAGE_SIZE;
-	BUG_ON(!(vma->vm_flags & VM_LOCKED));
-
-	/*
-	 * filter unlockable vmas
-	 */
-	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
-		goto no_mlock;
-
-	if (!((vma->vm_flags & VM_DONTEXPAND) ||
-			is_vm_hugetlb_page(vma) ||
-			vma == get_gate_vma(current->mm))) {
-
-		__mlock_vma_pages_range(vma, start, end, NULL);
-
-		/* Hide errors from mmap() and other callers */
-		return 0;
-	}
-
-	/*
-	 * User mapped kernel pages or huge pages:
-	 * make these pages present to populate the ptes, but
-	 * fall thru' to reset VM_LOCKED--no need to unlock, and
-	 * return nr_pages so these don't get counted against task's
-	 * locked limit.  huge pages are already counted against
-	 * locked vm limit.
-	 */
-	make_pages_present(start, end);
-
-no_mlock:
-	vma->vm_flags &= ~VM_LOCKED;	/* and don't come back! */
-	return nr_pages;		/* error or pages NOT mlocked */
-}
-
 /*
  * munlock_vma_pages_range() - munlock all pages in the vma range.'
  * @vma - vma containing range to be munlock()ed.
@@ -303,7 +252,7 @@ void munlock_vma_pages_range(struct vm_a
  *
  * Filters out "special" vmas -- VM_LOCKED never gets set for these, and
  * munlock is a no-op.  However, for some special vmas, we go ahead and
- * populate the ptes via make_pages_present().
+ * populate the ptes.
  *
  * For vmas that pass the filters, merge/split as appropriate.
  */
diff -puN mm/mmap.c~mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma mm/mmap.c
--- a/mm/mmap.c~mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma
+++ a/mm/mmap.c
@@ -2204,9 +2204,8 @@ find_extend_vma(struct mm_struct *mm, un
 		return vma;
 	if (!prev || expand_stack(prev, addr))
 		return NULL;
-	if (prev->vm_flags & VM_LOCKED) {
-		mlock_vma_pages_range(prev, addr, prev->vm_end);
-	}
+	if (prev->vm_flags & VM_LOCKED)
+		__mlock_vma_pages_range(prev, addr, prev->vm_end, NULL);
 	return prev;
 }
 #else
@@ -2232,9 +2231,8 @@ find_extend_vma(struct mm_struct * mm, u
 	start = vma->vm_start;
 	if (expand_stack(vma, addr))
 		return NULL;
-	if (vma->vm_flags & VM_LOCKED) {
-		mlock_vma_pages_range(vma, addr, start);
-	}
+	if (vma->vm_flags & VM_LOCKED)
+		__mlock_vma_pages_range(vma, addr, start, NULL);
 	return vma;
 }
 #endif
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-ia64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-remove-free_area_cache.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

