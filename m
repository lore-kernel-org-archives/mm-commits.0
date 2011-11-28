From: akpm@linux-foundation.org
Subject: + thp-improve-order-in-lru-list-for-split-huge-page.patch added to -mm tree
Date: Mon, 28 Nov 2011 13:42:05 -0800
Message-ID: <201111282142.pASLg5Ue013580@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:63990 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1K1VmL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 16:42:11 -0500
Received: by eeuu44 with SMTP id u44so48927eeu.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 13:42:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, aarcange@redhat.com, jweiner@redhat.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     Subject: thp: improve order in lru list for split huge page
has been added to the -mm tree.  Its filename is
     thp-improve-order-in-lru-list-for-split-huge-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shaohua Li <shaohua.li@intel.com>
Subject: thp: improve order in lru list for split huge page

Put the tail subpages of an isolated hugepage under splitting in the
lru reclaim head as they supposedly should be isolated too next.

Queues the subpages in physical order in the lru for non isolated
hugepages under splitting. That might provide some theoretical cache
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
@@ -1239,7 +1238,7 @@ static void __split_huge_page_refcount(s
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(page);
 
-	for (i = 1; i < HPAGE_PMD_NR; i++) {
+	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
 		struct page *page_tail = page + i;
 
 		/* tail_page->_mapcount cannot change */
@@ -1302,7 +1301,7 @@ static void __split_huge_page_refcount(s
 		BUG_ON(page_tail->mapping);
 		page_tail->mapping = page->mapping;
 
-		page_tail->index = ++head_index;
+		page_tail->index = page->index + i;
 
 		BUG_ON(!PageAnon(page_tail));
 		BUG_ON(!PageUptodate(page_tail));
diff -puN mm/swap.c~thp-improve-order-in-lru-list-for-split-huge-page mm/swap.c
--- a/mm/swap.c~thp-improve-order-in-lru-list-for-split-huge-page
+++ a/mm/swap.c
@@ -681,7 +681,7 @@ void lru_add_page_tail(struct zone* zone
 		if (likely(PageLRU(page)))
 			list_add(&page_tail->lru, page->lru.prev);
 		else
-			list_add(&page_tail->lru, &lruvec->lists[lru]);
+			list_add(&page_tail->lru, lruvec->lists[lru].prev);
 		__mod_zone_page_state(zone, NR_LRU_BASE + lru,
 				      hpage_nr_pages(page_tail));
 	} else {
_
Subject: Subject: thp: improve order in lru list for split huge page

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
x86-tlb-flush-avoid-superflous-leave_mm.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch

