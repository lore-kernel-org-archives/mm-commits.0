From: akpm@linux-foundation.org
Subject: [merged] mm-downgrade-vm_bug-in-isolate_lru_page-to-warning.patch removed from -mm tree
Date: Wed, 10 Feb 2016 11:35:44 -0800
Message-ID: <56bb9110.lFRD40k+acfPPvze%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbcBJTfp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:35:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dvyukov@google.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: downgrade VM_BUG in isolate_lru_page() to warning
has been removed from the -mm tree.  Its filename was
     mm-downgrade-vm_bug-in-isolate_lru_page-to-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: downgrade VM_BUG in isolate_lru_page() to warning

Calling isolate_lru_page() is wrong and shouldn't happen, but it not
nessesary fatal: the page just will not be isolated if it's not on LRU.

Let's downgrade the VM_BUG_ON_PAGE() to WARN_RATELIMIT().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-downgrade-vm_bug-in-isolate_lru_page-to-warning mm/vmscan.c
--- a/mm/vmscan.c~mm-downgrade-vm_bug-in-isolate_lru_page-to-warning
+++ a/mm/vmscan.c
@@ -1443,7 +1443,7 @@ int isolate_lru_page(struct page *page)
 	int ret = -EBUSY;
 
 	VM_BUG_ON_PAGE(!page_count(page), page);
-	VM_BUG_ON_PAGE(PageTail(page), page);
+	WARN_RATELIMIT(PageTail(page), "trying to isolate tail page");
 
 	if (PageLRU(page)) {
 		struct zone *zone = page_zone(page);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-dax-check-for-pmd_none-after-split_huge_pmd.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
thp-cleanup-split_huge_page.patch
thp-vmstats-count-deferred-split-events.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

