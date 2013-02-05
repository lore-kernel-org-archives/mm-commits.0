From: akpm@linux-foundation.org
Subject: + mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix.patch added to -mm tree
Date: Mon, 04 Feb 2013 16:12:09 -0800
Message-ID: <20130205001209.BA10E31C00F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:63974 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab3BEAML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2013 19:12:11 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so100210yhr.4
        for <mm-commits@vger.kernel.org>; Mon, 04 Feb 2013 16:12:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, aarcange@redhat.com, hughd@google.com, mgorman@suse.de, riel@redhat.com


The patch titled
     Subject: fix mm: use long type for page counts in mm_populate() and get_user_pages()
has been added to the -mm tree.  Its filename is
     mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 include/linux/mm.h      |   11 ++++++-----
 mm/hugetlb.c            |    8 ++++----
 mm/memory.c             |   12 ++++++------
 mm/mlock.c              |    2 +-
 5 files changed, 18 insertions(+), 17 deletions(-)

diff -puN include/linux/hugetlb.h~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix
+++ a/include/linux/hugetlb.h
@@ -45,7 +45,7 @@ int hugetlb_mempolicy_sysctl_handler(str
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
 long follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
 			 struct page **, struct vm_area_struct **,
-			 unsigned long *, long *, long, unsigned int flags);
+			 unsigned long *, unsigned long *, long, unsigned int);
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *);
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
diff -puN include/linux/mm.h~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix
+++ a/include/linux/mm.h
@@ -1012,12 +1012,13 @@ extern int access_remote_vm(struct mm_st
 		void *buf, int len, int write);
 
 long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		      unsigned long start, long len, unsigned int foll_flags,
-		      struct page **pages, struct vm_area_struct **vmas,
-		      int *nonblocking);
+		      unsigned long start, unsigned long nr_pages,
+		      unsigned int foll_flags, struct page **pages,
+		      struct vm_area_struct **vmas, int *nonblocking);
 long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		    unsigned long start, long nr_pages, int write, int force,
-		    struct page **pages, struct vm_area_struct **vmas);
+		    unsigned long start, unsigned long nr_pages,
+		    int write, int force, struct page **pages,
+		    struct vm_area_struct **vmas);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 struct kvec;
diff -puN mm/hugetlb.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix
+++ a/mm/hugetlb.c
@@ -2922,12 +2922,12 @@ follow_huge_pud(struct mm_struct *mm, un
 
 long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			 struct page **pages, struct vm_area_struct **vmas,
-			 unsigned long *position, long *length, long i,
-			 unsigned int flags)
+			 unsigned long *position, unsigned long *nr_pages,
+			 long i, unsigned int flags)
 {
 	unsigned long pfn_offset;
 	unsigned long vaddr = *position;
-	long remainder = *length;
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
diff -puN mm/memory.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix mm/memory.c
--- a/mm/memory.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix
+++ a/mm/memory.c
@@ -1678,14 +1678,14 @@ static inline int stack_guard_page(struc
  * you need some special @gup_flags.
  */
 long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		unsigned long start, long nr_pages, unsigned int gup_flags,
-		struct page **pages, struct vm_area_struct **vmas,
-		int *nonblocking)
+		unsigned long start, unsigned long nr_pages,
+		unsigned int gup_flags, struct page **pages,
+		struct vm_area_struct **vmas, int *nonblocking)
 {
 	long i;
 	unsigned long vm_flags;
 
-	if (nr_pages <= 0)
+	if (!nr_pages)
 		return 0;
 
 	VM_BUG_ON(!!pages != !!(gup_flags & FOLL_GET));
@@ -1982,8 +1982,8 @@ int fixup_user_fault(struct task_struct 
  * See also get_user_pages_fast, for performance critical applications.
  */
 long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		unsigned long start, long nr_pages, int write, int force,
-		struct page **pages, struct vm_area_struct **vmas)
+		unsigned long start, unsigned long nr_pages, int write,
+		int force, struct page **pages, struct vm_area_struct **vmas)
 {
 	int flags = FOLL_TOUCH;
 
diff -puN mm/mlock.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix mm/mlock.c
--- a/mm/mlock.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix
+++ a/mm/mlock.c
@@ -160,7 +160,7 @@ long __mlock_vma_pages_range(struct vm_a
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = start;
-	long nr_pages = (end - start) / PAGE_SIZE;
+	unsigned long nr_pages = (end - start) / PAGE_SIZE;
 	int gup_flags;
 
 	VM_BUG_ON(start & ~PAGE_MASK);
_

Patches currently in -mm which might be from walken@google.com are

thp-avoid-dumping-huge-zero-page.patch
linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-ia64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags.patch
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
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix.patch
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

