From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 13/67] mm/memory_hotplug: drop
 valid_start/valid_end from test_pages_in_a_zone()
Date: Mon, 03 Feb 2020 17:34:26 -0800
Message-ID: <20200204013426.9cm9hHu12%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBe2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:34:28 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, gregkh@linuxfoundation.org, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, rafael@kernel.org, torvalds@linux-foundation.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: drop valid_start/valid_end from test_pages_in_a_zone()

The callers are only interested in the actual zone, they don't care about
boundaries.  Return the zone instead to simplify.

Link: http://lkml.kernel.org/r/20200110183308.11849-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |    9 ++++-----
 include/linux/memory_hotplug.h |    4 ++--
 mm/memory_hotplug.c            |   31 +++++++++----------------------
 3 files changed, 15 insertions(+), 29 deletions(-)

--- a/drivers/base/memory.c~mm-memory_hotplug-drop-valid_start-valid_end-from-test_pages_in_a_zone
+++ a/drivers/base/memory.c
@@ -376,7 +376,6 @@ static ssize_t valid_zones_show(struct d
 	struct memory_block *mem = to_memory_block(dev);
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
-	unsigned long valid_start_pfn, valid_end_pfn;
 	struct zone *default_zone;
 	int nid;
 
@@ -389,11 +388,11 @@ static ssize_t valid_zones_show(struct d
 		 * The block contains more than one zone can not be offlined.
 		 * This can happen e.g. for ZONE_DMA and ZONE_DMA32
 		 */
-		if (!test_pages_in_a_zone(start_pfn, start_pfn + nr_pages,
-					  &valid_start_pfn, &valid_end_pfn))
+		default_zone = test_pages_in_a_zone(start_pfn,
+						    start_pfn + nr_pages);
+		if (!default_zone)
 			return sprintf(buf, "none\n");
-		start_pfn = valid_start_pfn;
-		strcat(buf, page_zone(pfn_to_page(start_pfn))->name);
+		strcat(buf, default_zone->name);
 		goto out;
 	}
 
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-drop-valid_start-valid_end-from-test_pages_in_a_zone
+++ a/include/linux/memory_hotplug.h
@@ -96,8 +96,8 @@ extern int add_one_highpage(struct page
 /* VM interface that may be used by firmware interface */
 extern int online_pages(unsigned long pfn, unsigned long nr_pages,
 			int online_type, int nid);
-extern int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn,
-	unsigned long *valid_start, unsigned long *valid_end);
+extern struct zone *test_pages_in_a_zone(unsigned long start_pfn,
+					 unsigned long end_pfn);
 extern unsigned long __offline_isolated_pages(unsigned long start_pfn,
 						unsigned long end_pfn);
 
--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-valid_start-valid_end-from-test_pages_in_a_zone
+++ a/mm/memory_hotplug.c
@@ -1172,14 +1172,13 @@ bool is_mem_section_removable(unsigned l
 }
 
 /*
- * Confirm all pages in a range [start, end) belong to the same zone.
- * When true, return its valid [start, end).
+ * Confirm all pages in a range [start, end) belong to the same zone (skipping
+ * memory holes). When true, return the zone.
  */
-int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn,
-			 unsigned long *valid_start, unsigned long *valid_end)
+struct zone *test_pages_in_a_zone(unsigned long start_pfn,
+				  unsigned long end_pfn)
 {
 	unsigned long pfn, sec_end_pfn;
-	unsigned long start, end;
 	struct zone *zone = NULL;
 	struct page *page;
 	int i;
@@ -1200,24 +1199,15 @@ int test_pages_in_a_zone(unsigned long s
 				continue;
 			/* Check if we got outside of the zone */
 			if (zone && !zone_spans_pfn(zone, pfn + i))
-				return 0;
+				return NULL;
 			page = pfn_to_page(pfn + i);
 			if (zone && page_zone(page) != zone)
-				return 0;
-			if (!zone)
-				start = pfn + i;
+				return NULL;
 			zone = page_zone(page);
-			end = pfn + MAX_ORDER_NR_PAGES;
 		}
 	}
 
-	if (zone) {
-		*valid_start = start;
-		*valid_end = min(end, end_pfn);
-		return 1;
-	} else {
-		return 0;
-	}
+	return zone;
 }
 
 /*
@@ -1462,7 +1452,6 @@ static int __ref __offline_pages(unsigne
 	unsigned long offlined_pages = 0;
 	int ret, node, nr_isolate_pageblock;
 	unsigned long flags;
-	unsigned long valid_start, valid_end;
 	struct zone *zone;
 	struct memory_notify arg;
 	char *reason;
@@ -1487,14 +1476,12 @@ static int __ref __offline_pages(unsigne
 
 	/* This makes hotplug much easier...and readable.
 	   we assume this for now. .*/
-	if (!test_pages_in_a_zone(start_pfn, end_pfn, &valid_start,
-				  &valid_end)) {
+	zone = test_pages_in_a_zone(start_pfn, end_pfn);
+	if (!zone) {
 		ret = -EINVAL;
 		reason = "multizone range";
 		goto failed_removal;
 	}
