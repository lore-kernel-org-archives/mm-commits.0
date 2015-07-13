From: akpm@linux-foundation.org
Subject: + thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch
 added to -mm tree
Date: Mon, 13 Jul 2015 14:31:55 -0700
Message-ID: <55a42e4b.g2+FsA6sNUMcjbSP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbbGMVb4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:31:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dhillf@gmail.com, jack@suse.cz, matthew.r.wilcox@intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: vma_adjust_trans_huge(): adjust file-backed VMA too
has been added to the -mm tree.  Its filename is
     thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: vma_adjust_trans_huge(): adjust file-backed VMA too

This series of patches adds support for using PMD page table entries to
map DAX files.  We expect NV-DIMMs to start showing up that are many
gigabytes in size and the memory consumption of 4kB PTEs will be
astronomical.

The patch series leverages much of the Transparant Huge Pages
infrastructure, going so far as to borrow one of Kirill's patches from his
THP page cache series.



This patch (of 10):

Since we're going to have huge pages in page cache, we need to call adjust
file-backed VMA, which potentially can contain huge pages.

For now we call it for all VMAs.

Probably later we will need to introduce a flag to indicate that the VMA
has huge pages.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   11 +----------
 mm/huge_memory.c        |    2 +-
 2 files changed, 2 insertions(+), 11 deletions(-)

diff -puN include/linux/huge_mm.h~thp-vma_adjust_trans_huge-adjust-file-backed-vma-too include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-vma_adjust_trans_huge-adjust-file-backed-vma-too
+++ a/include/linux/huge_mm.h
@@ -122,7 +122,7 @@ extern void split_huge_page_pmd_mm(struc
 #endif
 extern int hugepage_madvise(struct vm_area_struct *vma,
 			    unsigned long *vm_flags, int advice);
-extern void __vma_adjust_trans_huge(struct vm_area_struct *vma,
+extern void vma_adjust_trans_huge(struct vm_area_struct *vma,
 				    unsigned long start,
 				    unsigned long end,
 				    long adjust_next);
@@ -138,15 +138,6 @@ static inline int pmd_trans_huge_lock(pm
 	else
 		return 0;
 }
-static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
-					 unsigned long start,
-					 unsigned long end,
-					 long adjust_next)
-{
-	if (!vma->anon_vma || vma->vm_ops)
-		return;
-	__vma_adjust_trans_huge(vma, start, end, adjust_next);
-}
 static inline int hpage_nr_pages(struct page *page)
 {
 	if (unlikely(PageTransHuge(page)))
diff -puN mm/huge_memory.c~thp-vma_adjust_trans_huge-adjust-file-backed-vma-too mm/huge_memory.c
--- a/mm/huge_memory.c~thp-vma_adjust_trans_huge-adjust-file-backed-vma-too
+++ a/mm/huge_memory.c
@@ -2996,7 +2996,7 @@ static void split_huge_page_address(stru
 	split_huge_page_pmd_mm(mm, address, pmd);
 }
 
-void __vma_adjust_trans_huge(struct vm_area_struct *vma,
+void vma_adjust_trans_huge(struct vm_area_struct *vma,
 			     unsigned long start,
 			     unsigned long end,
 			     long adjust_next)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-fix-status-code-move_pages-returns-for-zero-page.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch
dax-move-dax-related-functions-to-a-new-header.patch
thp-prepare-for-dax-huge-pages.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch

