From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix-fix.patch removed from -mm tree
Date: Wed, 06 Feb 2013 17:11:00 -0800
Message-ID: <20130207011101.068AC5A40F3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:62066 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab3BGBLC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 20:11:02 -0500
Received: by mail-ob0-f201.google.com with SMTP id un3so399674obb.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 17:11:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fix mm: use long types for page counts in mm_populate() and get_user_pages()
has been removed from the -mm tree.  Its filename was
     mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix-fix.patch

This patch was dropped because it was folded into mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: fix mm: use long types for page counts in mm_populate() and get_user_pages()

Commit 748e13582feb06228dad7f1f151b1489b0b63e68 broke the nommu build.
This is the trivial fix for this issue.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/nommu.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix-fix mm/nommu.c
--- a/mm/nommu.c~mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix-fix
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
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
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

