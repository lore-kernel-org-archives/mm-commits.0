From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:07:58 -0800
Message-ID: <548d0d1e.OY6V9tnhaScffoe2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaLNEHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dave@sr71.net, hannes@cmpxchg.org, jungsoo.son@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: correct owner information for early allocated pages
has been removed from the -mm tree.  Its filename was
     mm-page_owner-correct-owner-information-for-early-allocated-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_owner: correct owner information for early allocated pages

Extended memory to store page owner information is initialized some time
later than that page allocator starts.  Until initialization, many pages
can be allocated and they have no owner information.  This make debugging
using page owner harder, so some fixup will be helpful.

This patch fixes up this situation by setting fake owner information
immediately after page extension is initialized.  Information doesn't tell
the right owner, but, at least, it can tell whether page is allocated or
not, more correctly.

On my testing, this patch catches 13343 early allocated pages, although
they are mostly allocated from page extension feature.  Anyway, after
then, there is no page left that it is allocated and has no page owner
flag.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Jungsoo Son <jungsoo.son@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   93 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 2 deletions(-)

diff -puN mm/page_owner.c~mm-page_owner-correct-owner-information-for-early-allocated-pages mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-correct-owner-information-for-early-allocated-pages
+++ a/mm/page_owner.c
@@ -10,6 +10,8 @@
 static bool page_owner_disabled = true;
 bool page_owner_inited __read_mostly;
 
+static void init_early_allocated_pages(void);
+
 static int early_page_owner_param(char *buf)
 {
 	if (!buf)
@@ -36,6 +38,7 @@ static void init_page_owner(void)
 		return;
 
 	page_owner_inited = true;
+	init_early_allocated_pages();
 }
 
 struct page_ext_operations page_owner_ops = {
@@ -184,8 +187,8 @@ read_page_owner(struct file *file, char
 		page_ext = lookup_page_ext(page);
 
 		/*
-		 * Pages allocated before initialization of page_owner are
-		 * non-buddy and have no page_owner info.
+		 * Some pages could be missed by concurrent allocation or free,
+		 * because we don't hold the zone lock.
 		 */
 		if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags))
 			continue;
@@ -199,6 +202,92 @@ read_page_owner(struct file *file, char
 	return 0;
 }
 
+static void init_pages_in_zone(pg_data_t *pgdat, struct zone *zone)
+{
+	struct page *page;
+	struct page_ext *page_ext;
+	unsigned long pfn = zone->zone_start_pfn, block_end_pfn;
+	unsigned long end_pfn = pfn + zone->spanned_pages;
+	unsigned long count = 0;
+
+	/* Scan block by block. First and last block may be incomplete */
+	pfn = zone->zone_start_pfn;
+
+	/*
+	 * Walk the zone in pageblock_nr_pages steps. If a page block spans
+	 * a zone boundary, it will be double counted between zones. This does
+	 * not matter as the mixed block count will still be correct
+	 */
+	for (; pfn < end_pfn; ) {
+		if (!pfn_valid(pfn)) {
+			pfn = ALIGN(pfn + 1, MAX_ORDER_NR_PAGES);
+			continue;
+		}
+
+		block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+		block_end_pfn = min(block_end_pfn, end_pfn);
+
+		page = pfn_to_page(pfn);
+
+		for (; pfn < block_end_pfn; pfn++) {
+			if (!pfn_valid_within(pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
+
+			/*
+			 * We are safe to check buddy flag and order, because
+			 * this is init stage and only single thread runs.
+			 */
+			if (PageBuddy(page)) {
+				pfn += (1UL << page_order(page)) - 1;
+				continue;
+			}
+
+			if (PageReserved(page))
+				continue;
+
+			page_ext = lookup_page_ext(page);
+
+			/* Maybe overraping zone */
+			if (test_bit(PAGE_EXT_OWNER, &page_ext->flags))
+				continue;
+
+			/* Found early allocated page */
+			set_page_owner(page, 0, 0);
+			count++;
+		}
+	}
+
+	pr_info("Node %d, zone %8s: page owner found early allocated %lu pages\n",
+		pgdat->node_id, zone->name, count);
+}
+
+static void init_zones_in_node(pg_data_t *pgdat)
+{
+	struct zone *zone;
+	struct zone *node_zones = pgdat->node_zones;
+	unsigned long flags;
+
+	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
+		if (!populated_zone(zone))
+			continue;
+
+		spin_lock_irqsave(&zone->lock, flags);
+		init_pages_in_zone(pgdat, zone);
+		spin_unlock_irqrestore(&zone->lock, flags);
+	}
+}
+
+static void init_early_allocated_pages(void)
+{
+	pg_data_t *pgdat;
+
+	drain_all_pages(NULL);
+	for_each_online_pgdat(pgdat)
+		init_zones_in_node(pgdat);
+}
+
 static const struct file_operations proc_page_owner_operations = {
 	.read		= read_page_owner,
 };
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch

