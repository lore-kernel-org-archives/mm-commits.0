From: akpm@linux-foundation.org
Subject: [wrecked] thp-improve-order-in-lru-list-for-split-huge-page.patch removed from -mm tree
Date: Tue, 22 Nov 2011 15:41:22 -0800
Message-ID: <201111222341.pAMNfMXF019496@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:38874 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab1KVXl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 18:41:29 -0500
Received: by ywb5 with SMTP id 5so141841ywb.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 15:41:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, aarcange@redhat.com, jweiner@redhat.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: improve order in lru list for split huge page
has been removed from the -mm tree.  Its filename was
     thp-improve-order-in-lru-list-for-split-huge-page.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shaohua Li <shaohua.li@intel.com>
Subject: thp: improve order in lru list for split huge page

Put the tail subpages of an isolated hugepage under splitting in the lru
reclaim head as they supposedly should be isolated too next.

Queues the subpages in physical order in the lru for non isolated
hugepages under splitting.  That might provide some theoretical cache
benefit to the buddy allocator later.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 ++---
 mm/swap.c        |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~thp-improve-order-in-lru-list-for-split-huge-page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-improve-order-in-lru-list-for-split-huge-page
+++ a/mm/huge_memory.c
@@ -1228,7 +1228,6 @@ static int __split_huge_page_splitting(s
 static void __split_huge_page_refcount(struct page *page)
 {
 	int i;
-	unsigned long head_index = page->index;
 	struct zone *zone = page_zone(page);
 	int zonestat;
 	int tail_count = 0;
@@ -1237,7 +1236,7 @@ static void __split_huge_page_refcount(s
 	spin_lock_irq(&zone->lru_lock);
 	compound_lock(page);
 
-	for (i = 1; i < HPAGE_PMD_NR; i++) {
+	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
 		struct page *page_tail = page + i;
 
 		/* tail_page->_mapcount cannot change */
@@ -1300,7 +1299,7 @@ static void __split_huge_page_refcount(s
 		BUG_ON(page_tail->mapping);
 		page_tail->mapping = page->mapping;
 
-		page_tail->index = ++head_index;
+		page_tail->index = page->index + i;
 
 		BUG_ON(!PageAnon(page_tail));
 		BUG_ON(!PageUptodate(page_tail));
diff -puN mm/swap.c~thp-improve-order-in-lru-list-for-split-huge-page mm/swap.c
--- a/mm/swap.c~thp-improve-order-in-lru-list-for-split-huge-page
+++ a/mm/swap.c
@@ -676,7 +676,7 @@ void lru_add_page_tail(struct zone* zone
 		if (likely(PageLRU(page)))
 			head = page->lru.prev;
 		else
-			head = &zone->lru[lru].list;
+			head = zone->lru[lru].list.prev;
 		__add_page_to_lru_list(zone, page_tail, lru, head);
 	} else {
 		SetPageUnevictable(page_tail);
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
x86-tlb-flush-avoid-superflous-leave_mm.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

