From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch removed from -mm tree
Date: Wed, 06 Feb 2013 17:11:27 -0800
Message-ID: <20130207011128.43CDD31C15E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:59894 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab3BGBLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 20:11:30 -0500
Received: by mail-ia0-f202.google.com with SMTP id p22so398899iad.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 17:11:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, aarcange@redhat.com, fengguang.wu@intel.com, hughd@google.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use long types for page counts in mm_populate() and get_user_pages()
has been removed from the -mm tree.  Its filename was
     mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: use long types for page counts in mm_populate() and get_user_pages()

Use long and unsigned long types for page counts in mm_populate() so as to
avoid integer overflow when running the following test code:

int main(void) {
  void *p = mmap(NULL, 0x100000000000, PROT_READ,
                 MAP_PRIVATE | MAP_ANON, -1, 0);
  printf("p: %p\n", p);
  mlockall(MCL_CURRENT);
  printf("done\n");
  return 0;
}

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
From: Michel Lespinasse <walken@google.com>
Subject: fix mm: use long type for page counts in mm_populate() and get_user_pages()

Andrew suggested I make the nr_pages argument an unsigned long rather
than just a long. I was initially worried that nr_pages would be compared
with signed longs, but this isn't the case, so his suggestion is perfectly
valid.

Sending as a 'fix' change, to be collapsed with the original in -mm.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
From: Michel Lespinasse <walken@google.com>
Subject: fix mm: use long types for page counts in mm_populate() and get_user_pages()

Commit 748e13582feb06228dad7f1f151b1489b0b63e68 broke the nommu build.
This is the trivial fix for this issue.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +++---
 include/linux/mm.h      |   15 ++++++++-------
 mm/hugetlb.c            |   12 ++++++------
 mm/memory.c             |   18 +++++++++---------
 mm/mlock.c              |    5 +++--
 mm/nommu.c              |   15 ++++++++-------
 6 files changed, 37 insertions(+), 34 deletions(-)

diff -puN include/linux/hugetlb.h~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages
+++ a/include/linux/hugetlb.h
@@ -43,9 +43,9 @@ int hugetlb_mempolicy_sysctl_handler(str
 #endif
 
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
-int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
-			struct page **, struct vm_area_struct **,
-			unsigned long *, int *, int, unsigned int flags);
+long follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
+			 struct page **, struct vm_area_struct **,
+			 unsigned long *, unsigned long *, long, unsigned int);
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *);
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
diff -puN include/linux/mm.h~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages include/linux/mm.h
--- a/include/linux/mm.h~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages
+++ a/include/linux/mm.h
@@ -1011,13 +1011,14 @@ extern int access_process_vm(struct task
 extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, int write);
 
-int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		     unsigned long start, int len, unsigned int foll_flags,
-		     struct page **pages, struct vm_area_struct **vmas,
-		     int *nonblocking);
-int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-			unsigned long start, int nr_pages, int write, int force,
-			struct page **pages, struct vm_area_struct **vmas);
+long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		      unsigned long start, unsigned long nr_pages,
+		      unsigned int foll_flags, struct page **pages,
+		      struct vm_area_struct **vmas, int *nonblocking);
+long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		    unsigned long start, unsigned long nr_pages,
+		    int write, int force, struct page **pages,
+		    struct vm_area_struct **vmas);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 struct kvec;
diff -puN mm/hugetlb.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages
+++ a/mm/hugetlb.c
@@ -2920,14 +2920,14 @@ follow_huge_pud(struct mm_struct *mm, un
 	return NULL;
 }
 
-int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
-			struct page **pages, struct vm_area_struct **vmas,
-			unsigned long *position, int *length, int i,
-			unsigned int flags)
+long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
+			 struct page **pages, struct vm_area_struct **vmas,
+			 unsigned long *position, unsigned long *nr_pages,
+			 long i, unsigned int flags)
 {
 	unsigned long pfn_offset;
 	unsigned long vaddr = *position;
-	int remainder = *length;
+	unsigned long remainder = *nr_pages;
 	struct hstate *h = hstate_vma(vma);
 
 	spin_lock(&mm->page_table_lock);
@@ -2997,7 +2997,7 @@ same_page:
 		}
 	}
 	spin_unlock(&mm->page_table_lock);
-	*length = remainder;
+	*nr_pages = remainder;
 	*position = vaddr;
 
 	return i ? i : -EFAULT;
diff -puN mm/memory.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages mm/memory.c
--- a/mm/memory.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages
+++ a/mm/memory.c
@@ -1677,15 +1677,15 @@ static inline int stack_guard_page(struc
  * instead of __get_user_pages. __get_user_pages should be used only if
  * you need some special @gup_flags.
  */
-int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		     unsigned long start, int nr_pages, unsigned int gup_flags,
-		     struct page **pages, struct vm_area_struct **vmas,
-		     int *nonblocking)
+long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		unsigned long start, unsigned long nr_pages,
+		unsigned int gup_flags, struct page **pages,
+		struct vm_area_struct **vmas, int *nonblocking)
 {
-	int i;
+	long i;
 	unsigned long vm_flags;
 
-	if (nr_pages <= 0)
+	if (!nr_pages)
 		return 0;
 
 	VM_BUG_ON(!!pages != !!(gup_flags & FOLL_GET));
@@ -1981,9 +1981,9 @@ int fixup_user_fault(struct task_struct 
  *
  * See also get_user_pages_fast, for performance critical applications.
  */
-int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		unsigned long start, int nr_pages, int write, int force,
-		struct page **pages, struct vm_area_struct **vmas)
+long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		unsigned long start, unsigned long nr_pages, int write,
+		int force, struct page **pages, struct vm_area_struct **vmas)
 {
 	int flags = FOLL_TOUCH;
 
diff -puN mm/mlock.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages mm/mlock.c
--- a/mm/mlock.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages
+++ a/mm/mlock.c
@@ -160,7 +160,7 @@ long __mlock_vma_pages_range(struct vm_a
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = start;
-	int nr_pages = (end - start) / PAGE_SIZE;
+	unsigned long nr_pages = (end - start) / PAGE_SIZE;
 	int gup_flags;
 
 	VM_BUG_ON(start & ~PAGE_MASK);
@@ -378,7 +378,7 @@ int __mm_populate(unsigned long start, u
 	unsigned long end, nstart, nend;
 	struct vm_area_struct *vma = NULL;
 	int locked = 0;
-	int ret = 0;
+	long ret = 0;
 
 	VM_BUG_ON(start & ~PAGE_MASK);
 	VM_BUG_ON(len != PAGE_ALIGN(len));
@@ -421,6 +421,7 @@ int __mm_populate(unsigned long start, u
 			ret = __mlock_posix_error_return(ret);
 			break;
 		}
+		VM_BUG_ON(!ret);
 		nend = nstart + ret * PAGE_SIZE;
 		ret = 0;
 	}
diff -puN mm/nommu.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages mm/nommu.c
--- a/mm/nommu.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages
+++ a/mm/nommu.c
@@ -139,10 +139,10 @@ unsigned int kobjsize(const void *objp)
 	return PAGE_SIZE << compound_order(page);
 }
 
-int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		     unsigned long start, int nr_pages, unsigned int foll_flags,
-		     struct page **pages, struct vm_area_struct **vmas,
-		     int *retry)
+long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		      unsigned long start, unsigned long nr_pages,
+		      unsigned int foll_flags, struct page **pages,
+		      struct vm_area_struct **vmas, int *nonblocking)
 {
 	struct vm_area_struct *vma;
 	unsigned long vm_flags;
@@ -189,9 +189,10 @@ finish_or_fault:
  *   slab page or a secondary page from a compound page
  * - don't permit access to VMAs that don't support it, such as I/O mappings
  */
-int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-	unsigned long start, int nr_pages, int write, int force,
-	struct page **pages, struct vm_area_struct **vmas)
+long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		    unsigned long start, unsigned long nr_pages,
+		    int write, int force, struct page **pages,
+		    struct vm_area_struct **vmas)
 {
 	int flags = 0;
 
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-ia64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-remap_file_pages-fixes.patch
mm-introduce-mm_populate-for-populating-new-vmas.patch
mm-use-mm_populate-for-blocking-remap_file_pages.patch
mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch
mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch
mm-remove-flags-argument-to-mmap_region.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch
mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch
mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch
mm-accelerate-mm_populate-treatment-of-thp-pages.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
mm-remove-free_area_cache.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mm-use-vm_unmapped_area-on-alpha-architecture.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

