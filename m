From: akpm@linux-foundation.org
Subject: + mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch added to -mm tree
Date: Wed, 30 Jan 2013 16:44:46 -0800
Message-ID: <20130131004446.B158E31C1D5@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:44104 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3AaAos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jan 2013 19:44:48 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so231095vch.0
        for <mm-commits@vger.kernel.org>; Wed, 30 Jan 2013 16:44:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, aarcange@redhat.com, hughd@google.com, mgorman@suse.de, riel@redhat.com


The patch titled
     Subject: mm: use long type for page counts in mm_populate() and get_user_pages()
has been added to the -mm tree.  Its filename is
     mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch

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
Subject: mm: use long type for page counts in mm_populate() and get_user_pages()

Use long type for page counts in mm_populate() so as to avoid integer
overflow when running the following test code:

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +++---
 include/linux/mm.h      |   14 +++++++-------
 mm/hugetlb.c            |   10 +++++-----
 mm/memory.c             |   14 +++++++-------
 mm/mlock.c              |    5 +++--
 5 files changed, 25 insertions(+), 24 deletions(-)

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
+			 unsigned long *, long *, long, unsigned int flags);
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *);
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
diff -puN include/linux/mm.h~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages include/linux/mm.h
--- a/include/linux/mm.h~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages
+++ a/include/linux/mm.h
@@ -1009,13 +1009,13 @@ extern int access_process_vm(struct task
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
+		      unsigned long start, long len, unsigned int foll_flags,
+		      struct page **pages, struct vm_area_struct **vmas,
+		      int *nonblocking);
+long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		    unsigned long start, long nr_pages, int write, int force,
+		    struct page **pages, struct vm_area_struct **vmas);
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
+			 unsigned long *position, long *length, long i,
+			 unsigned int flags)
 {
 	unsigned long pfn_offset;
 	unsigned long vaddr = *position;
-	int remainder = *length;
+	long remainder = *length;
 	struct hstate *h = hstate_vma(vma);
 
 	spin_lock(&mm->page_table_lock);
diff -puN mm/memory.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages mm/memory.c
--- a/mm/memory.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages
+++ a/mm/memory.c
@@ -1677,12 +1677,12 @@ static inline int stack_guard_page(struc
  * instead of __get_user_pages. __get_user_pages should be used only if
  * you need some special @gup_flags.
  */
-int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		     unsigned long start, int nr_pages, unsigned int gup_flags,
-		     struct page **pages, struct vm_area_struct **vmas,
-		     int *nonblocking)
+long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		unsigned long start, long nr_pages, unsigned int gup_flags,
+		struct page **pages, struct vm_area_struct **vmas,
+		int *nonblocking)
 {
-	int i;
+	long i;
 	unsigned long vm_flags;
 
 	if (nr_pages <= 0)
@@ -1981,8 +1981,8 @@ int fixup_user_fault(struct task_struct 
  *
  * See also get_user_pages_fast, for performance critical applications.
  */
-int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		unsigned long start, int nr_pages, int write, int force,
+long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		unsigned long start, long nr_pages, int write, int force,
 		struct page **pages, struct vm_area_struct **vmas)
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
+	long nr_pages = (end - start) / PAGE_SIZE;
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
_

Patches currently in -mm which might be from walken@google.com are

thp-avoid-dumping-huge-zero-page.patch
linux-next.patch
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
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

