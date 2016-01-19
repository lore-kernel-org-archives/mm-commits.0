From: akpm@linux-foundation.org
Subject: [merged]
 mm-make-sure-isolate_lru_page-is-never-called-for-tail-page.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 11:59:57 -0800
Message-ID: <569e95bd.2bsG2F8juV6/P5lF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbcAST75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 14:59:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make sure isolate_lru_page() is never called for tail page
has been removed from the -mm tree.  Its filename was
     mm-make-sure-isolate_lru_page-is-never-called-for-tail-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: make sure isolate_lru_page() is never called for tail page

The VM_BUG_ON_PAGE() would catch such cases if any still exists.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmscan.c~mm-make-sure-isolate_lru_page-is-never-called-for-tail-page mm/vmscan.c
--- a/mm/vmscan.c~mm-make-sure-isolate_lru_page-is-never-called-for-tail-page
+++ a/mm/vmscan.c
@@ -1426,6 +1426,7 @@ int isolate_lru_page(struct page *page)
 	int ret = -EBUSY;
 
 	VM_BUG_ON_PAGE(!page_count(page), page);
+	VM_BUG_ON_PAGE(PageTail(page), page);
 
 	if (PageLRU(page)) {
 		struct zone *zone = page_zone(page);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

