From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-status-code-move_pages-returns-for-zero-page.patch removed from -mm
 tree
Date: Tue, 08 Sep 2015 11:11:48 -0700
Message-ID: <55ef24e4.NgJg9KZwoEV+Ldoh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbbIHSLt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:11:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, cl@linux.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix status code which move_pages() returns for zero page
has been removed from the -mm tree.  Its filename was
     mm-fix-status-code-move_pages-returns-for-zero-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix status code which move_pages() returns for zero page

The manpage for move_pages(2) specifies that status code for zero page is
supposed to be -EFAULT.  Currently kernel return -ENOENT in this case.

follow_page() can do it for us, if we would ask for FOLL_DUMP.  The use of
FOLL_DUMP also means that the upper layer page tables pages are no longer
allocated.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN mm/migrate.c~mm-fix-status-code-move_pages-returns-for-zero-page mm/migrate.c
--- a/mm/migrate.c~mm-fix-status-code-move_pages-returns-for-zero-page
+++ a/mm/migrate.c
@@ -1226,7 +1226,9 @@ static int do_move_page_to_node_array(st
 		if (!vma || pp->addr < vma->vm_start || !vma_migratable(vma))
 			goto set_status;
 
-		page = follow_page(vma, pp->addr, FOLL_GET|FOLL_SPLIT);
+		/* FOLL_DUMP to ignore special (like zero) pages */
+		page = follow_page(vma, pp->addr,
+				FOLL_GET | FOLL_SPLIT | FOLL_DUMP);
 
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
@@ -1236,10 +1238,6 @@ static int do_move_page_to_node_array(st
 		if (!page)
 			goto set_status;
 
-		/* Use PageReserved to check for zero page */
-		if (PageReserved(page))
-			goto put_and_set;
-
 		pp->page = page;
 		err = page_to_nid(page);
 
@@ -1396,18 +1394,14 @@ static void do_pages_stat_array(struct m
 		if (!vma || addr < vma->vm_start)
 			goto set_status;
 
-		page = follow_page(vma, addr, 0);
+		/* FOLL_DUMP to ignore special (like zero) pages */
+		page = follow_page(vma, addr, FOLL_DUMP);
 
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
 			goto set_status;
 
-		err = -ENOENT;
-		/* Use PageReserved to check for zero page */
-		if (!page || PageReserved(page))
-			goto set_status;
-
-		err = page_to_nid(page);
+		err = page ? page_to_nid(page) : -ENOENT;
 set_status:
 		*status = err;
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch
thp-decrement-refcount-on-huge-zero-page-if-it-is-split.patch
thp-fix-zap_huge_pmd-for-dax.patch
dax-dont-use-set_huge_zero_page.patch
mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax.patch
mm-dax-use-i_mmap_unlock_write-in-do_cow_fault.patch
vm_flags-vm_flags_t-and-__nocast.patch
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

