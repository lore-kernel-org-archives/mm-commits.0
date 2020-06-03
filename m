From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix.patch
 removed from -mm tree
Date: Wed, 03 Jun 2020 15:13:37 -0700
Message-ID: <20200603221337.aJK6buZp3%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgFCWNi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:13:38 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix
has been removed from the -mm tree.  Its filename was
     khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix.patch

This patch was dropped because it was folded into khugepaged-allow-to-collapse-a-page-shared-across-fork.patch

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix

fix set-but-not-used warning

Link: http://lkml.kernel.org/r/20200521145644.GA6367@ovpn-112-192.phx2.redhat.com
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/khugepaged.c~khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix
+++ a/mm/khugepaged.c
@@ -528,9 +528,8 @@ static void release_pte_pages(pte_t *pte
 
 static bool is_refcount_suitable(struct page *page)
 {
-	int expected_refcount, refcount;
+	int expected_refcount;
 
-	refcount = page_count(page);
 	expected_refcount = total_mapcount(page);
 	if (PageSwapCache(page))
 		expected_refcount += compound_nr(page);
_

Patches currently in -mm which might be from cai@lca.pw are

khugepaged-allow-to-collapse-a-page-shared-across-fork.patch
mm-deactivations-shouldnt-bias-the-lru-balance-fix.patch
mm-kmemleak-silence-kcsan-splats-in-checksum.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-annotate-a-data-race-in-page_zonenum.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch
