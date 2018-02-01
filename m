From: akpm@linux-foundation.org
Subject: [patch 099/119] mm/page_owner.c: clean up
 init_pages_in_zone()
Date: Wed, 31 Jan 2018 16:20:11 -0800
Message-ID: <20180201002011.X-yysJJXL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754559AbeBAAUN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:20:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@techadventures.net, torvalds@linux-foundation.org, vbabka@suse.cz

From: Oscar Salvador <osalvador@techadventures.net>
Subject: mm/page_owner.c: clean up init_pages_in_zone()

Remove two redundant assignments in init_pages_in_zone().

[osalvador@techadventures.net: v3]
  Link: http://lkml.kernel.org/r/20180117124513.GA876@techadventures.net
[akpm@linux-foundation.org: coding style tweaks]
Link: http://lkml.kernel.org/r/20180110084355.GA22822@techadventures.net
Signed-off-by: Oscar Salvador <osalvador@techadventures.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN mm/page_owner.c~mm-page_owner-clean-up-init_pages_in_zone mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-clean-up-init_pages_in_zone
+++ a/mm/page_owner.c
@@ -528,21 +528,18 @@ read_page_owner(struct file *file, char
 
 static void init_pages_in_zone(pg_data_t *pgdat, struct zone *zone)
 {
-	struct page *page;
-	struct page_ext *page_ext;
-	unsigned long pfn = zone->zone_start_pfn, block_end_pfn;
-	unsigned long end_pfn = pfn + zone->spanned_pages;
+	unsigned long pfn = zone->zone_start_pfn;
+	unsigned long end_pfn = zone_end_pfn(zone);
 	unsigned long count = 0;
 
-	/* Scan block by block. First and last block may be incomplete */
-	pfn = zone->zone_start_pfn;
-
 	/*
 	 * Walk the zone in pageblock_nr_pages steps. If a page block spans
 	 * a zone boundary, it will be double counted between zones. This does
 	 * not matter as the mixed block count will still be correct
 	 */
 	for (; pfn < end_pfn; ) {
+		unsigned long block_end_pfn;
+
 		if (!pfn_valid(pfn)) {
 			pfn = ALIGN(pfn + 1, MAX_ORDER_NR_PAGES);
 			continue;
@@ -551,9 +548,10 @@ static void init_pages_in_zone(pg_data_t
 		block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
-		page = pfn_to_page(pfn);
