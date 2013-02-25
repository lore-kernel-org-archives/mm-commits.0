From: akpm@linux-foundation.org
Subject: [merged] mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:43 -0800
Message-ID: <20130225205543.B3A7731C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60774 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759370Ab3BYUzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:45 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so347894vcd.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, aarcange@redhat.com, hughd@google.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use long type for page counts in mm_populate() and get_user_pages()
has been removed from the -mm tree.  Its filename was
     mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 include/linux/mm.h      |   15 ++++++++-------
 mm/hugetlb.c            |   12 ++++++------
 mm/memory.c             |   18 +++++++++---------
 mm/mlock.c              |    4 ++--
 mm/nommu.c              |   15 ++++++++-------
 6 files changed, 36 insertions(+), 34 deletions(-)

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
@@ -1013,13 +1013,14 @@ extern int access_process_vm(struct task
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
@@ -382,7 +382,7 @@ int __mm_populate(unsigned long start, u
 	unsigned long end, nstart, nend;
 	struct vm_area_struct *vma = NULL;
 	int locked = 0;
-	int ret = 0;
+	long ret = 0;
 
 	VM_BUG_ON(start & ~PAGE_MASK);
 	VM_BUG_ON(len != PAGE_ALIGN(len));
diff -puN mm/nommu.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages mm/nommu.c
--- a/mm/nommu.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages
+++ a/mm/nommu.c
@@ -140,10 +140,10 @@ unsigned int kobjsize(const void *objp)
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
@@ -190,9 +190,10 @@ finish_or_fault:
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

