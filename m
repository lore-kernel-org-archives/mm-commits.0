From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:43:45 -0700
Message-ID: <52321971.E9FA5nSR/WK4jaPS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab3ILTnp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cody@linux.vnet.ibm.com, qiuxishi@huawei.com

Subject: [merged] mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch removed from -mm tree
To: qiuxishi@huawei.com,cody@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:45 -0700


The patch titled
     Subject: mm: use zone_end_pfn() instead of zone_start_pfn+spanned_pages
has been removed from the -mm tree.  Its filename was
     mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: use zone_end_pfn() instead of zone_start_pfn+spanned_pages

Use "zone_end_pfn()" instead of "zone->zone_start_pfn + zone->spanned_pages".
Simplify the code, no functional change.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |   12 ++++++------
 mm/memory_hotplug.c     |    7 ++++---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff -puN kernel/power/snapshot.c~mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages
+++ a/kernel/power/snapshot.c
@@ -352,7 +352,7 @@ static int create_mem_extents(struct lis
 		struct mem_extent *ext, *cur, *aux;
 
 		zone_start = zone->zone_start_pfn;
-		zone_end = zone->zone_start_pfn + zone->spanned_pages;
+		zone_end = zone_end_pfn(zone);
 
 		list_for_each_entry(ext, list, hook)
 			if (zone_start <= ext->end)
@@ -884,7 +884,7 @@ static unsigned int count_highmem_pages(
 			continue;
 
 		mark_free_pages(zone);
-		max_zone_pfn = zone->zone_start_pfn + zone->spanned_pages;
+		max_zone_pfn = zone_end_pfn(zone);
 		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
 			if (saveable_highmem_page(zone, pfn))
 				n++;
@@ -948,7 +948,7 @@ static unsigned int count_data_pages(voi
 			continue;
 
 		mark_free_pages(zone);
-		max_zone_pfn = zone->zone_start_pfn + zone->spanned_pages;
+		max_zone_pfn = zone_end_pfn(zone);
 		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
 			if (saveable_page(zone, pfn))
 				n++;
@@ -1041,7 +1041,7 @@ copy_data_pages(struct memory_bitmap *co
 		unsigned long max_zone_pfn;
 
 		mark_free_pages(zone);
-		max_zone_pfn = zone->zone_start_pfn + zone->spanned_pages;
+		max_zone_pfn = zone_end_pfn(zone);
 		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
 			if (page_is_saveable(zone, pfn))
 				memory_bm_set_bit(orig_bm, pfn);
@@ -1093,7 +1093,7 @@ void swsusp_free(void)
 	unsigned long pfn, max_zone_pfn;
 
 	for_each_populated_zone(zone) {
-		max_zone_pfn = zone->zone_start_pfn + zone->spanned_pages;
+		max_zone_pfn = zone_end_pfn(zone);
 		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
 			if (pfn_valid(pfn)) {
 				struct page *page = pfn_to_page(pfn);
@@ -1755,7 +1755,7 @@ static int mark_unsafe_pages(struct memo
 
 	/* Clear page flags */
 	for_each_populated_zone(zone) {
-		max_zone_pfn = zone->zone_start_pfn + zone->spanned_pages;
+		max_zone_pfn = zone_end_pfn(zone);
 		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
 			if (pfn_valid(pfn))
 				swsusp_unset_page_free(pfn_to_page(pfn));
diff -puN mm/memory_hotplug.c~mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages
+++ a/mm/memory_hotplug.c
@@ -229,7 +229,7 @@ static void grow_zone_span(struct zone *
 
 	zone_span_writelock(zone);
 
-	old_zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	old_zone_end_pfn = zone_end_pfn(zone);
 	if (!zone->spanned_pages || start_pfn < zone->zone_start_pfn)
 		zone->zone_start_pfn = start_pfn;
 
@@ -514,8 +514,9 @@ static int find_biggest_section_pfn(int
 static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 			     unsigned long end_pfn)
 {
-	unsigned long zone_start_pfn =  zone->zone_start_pfn;
-	unsigned long zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	unsigned long zone_start_pfn = zone->zone_start_pfn;
+	unsigned long z = zone_end_pfn(zone); /* zone_end_pfn namespace clash */
+	unsigned long zone_end_pfn = z;
 	unsigned long pfn;
 	struct mem_section *ms;
 	int nid = zone_to_nid(zone);
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

origin.patch

