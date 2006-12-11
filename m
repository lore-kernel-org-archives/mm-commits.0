From: akpm@osdl.org
Subject: - lumpy-ensure-we-respect-zone-boundaries.patch removed from -mm tree
Date: Mon, 11 Dec 2006 14:44:55 -0800
Message-ID: <200612112244.kBBMitYt011050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:45484 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937707AbWLKWpa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 17:45:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     lumpy ensure we respect zone boundaries
has been removed from the -mm tree.  Its filename was
     lumpy-ensure-we-respect-zone-boundaries.patch

This patch was dropped because it was folded into lumpy-reclaim-v2.patch

------------------------------------------------------
Subject: lumpy ensure we respect zone boundaries
From: Andy Whitcroft <apw@shadowen.org>

When scanning an aligned order N area ensure we only pull out pages in the
same zone as our tag page, else we will manipulate those pages' LRU under the
wrong zone lru_lock.  Bad.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/vmscan.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~lumpy-ensure-we-respect-zone-boundaries mm/vmscan.c
--- a/mm/vmscan.c~lumpy-ensure-we-respect-zone-boundaries
+++ a/mm/vmscan.c
@@ -659,6 +659,7 @@ static unsigned long isolate_lru_pages(u
 	struct page *page, *tmp;
 	unsigned long scan, pfn, end_pfn, page_pfn;
 	int active;
+	int zone_id;
 
 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
 		page = lru_to_page(src);
@@ -690,6 +691,7 @@ static unsigned long isolate_lru_pages(u
 		 * surrounding the tag page.  Only take those pages of
 		 * the same active state as that tag page.
 		 */
+		zone_id = page_zone_id(page);
 		page_pfn = __page_to_pfn(page);
 		pfn = page_pfn & ~((1 << order) - 1);
 		end_pfn = pfn + (1 << order);
@@ -699,8 +701,10 @@ static unsigned long isolate_lru_pages(u
 			if (unlikely(!pfn_valid(pfn)))
 				break;
 
-			scan++;
 			tmp = __pfn_to_page(pfn);
+			if (unlikely(page_zone_id(tmp) != zone_id))
+				continue;
+			scan++;
 			switch (__isolate_lru_page(tmp, active)) {
 			case 0:
 				list_move(&tmp->lru, dst);
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
git-acpi.patch
pci-device-ensure-sysdata-initialised-v2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
virtual-memmap-on-sparsemem-v3-generic-virtual.patch
virtual-memmap-on-sparsemem-v3-generic-virtual-fix.patch
virtual-memmap-on-sparsemem-v3-static-virtual.patch
virtual-memmap-on-sparsemem-v3-static-virtual-update.patch
virtual-memmap-on-sparsemem-v3-ia64-support.patch
virtual-memmap-on-sparsemem-v3-ia64-support-update.patch
lumpy-reclaim-v2.patch
lumpy-ensure-we-respect-zone-boundaries.patch
lumpy-take-the-other-active-inactive-pages-in-the-area.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
optional-zone_dma-in-the-vm.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch

