From: akpm@linux-foundation.org
Subject: [merged]
 thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:42:49 -0700
Message-ID: <55f08bb9.8cJuRovkFKBCF6ao%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbbIITmu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:42:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dhillf@gmail.com, jack@suse.cz, matthew.r.wilcox@intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: vma_adjust_trans_huge(): adjust file-backed VMA too
has been removed from the -mm tree.  Its filename was
     thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2991,7 +2991,7 @@ static void split_huge_page_address(stru
 	split_huge_page_pmd_mm(mm, address, pmd);
 }
 
-void __vma_adjust_trans_huge(struct vm_area_struct *vma,
+void vma_adjust_trans_huge(struct vm_area_struct *vma,
 			     unsigned long start,
 			     unsigned long end,
 			     long adjust_next)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
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
mm-mark-most-vm_operations_struct-const.patch
mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch
mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch

