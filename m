From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-memory=5Fhotplug-drop-valid=5Fstart-valid=5Fend-from-te?=
 =?US-ASCII?Q?st=5Fpages=5Fin=5Fa=5Fzone.patch?= added to -mm tree
Date: Fri, 10 Jan 2020 12:47:50 -0800
Message-ID: <20200110204750.ACeWHYIFJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbgAJUrw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jan 2020 15:47:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, gregkh@linuxfoundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, rafael@kernel.org


The patch titled
     Subject: mm/memory_hotplug: drop valid_start/valid_end from test_pages_in_a_zone()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-drop-valid_start-valid_end-from-test_pages_in_a_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-drop-valid_start-valid_end-from-test_pages_in_a_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-drop-valid_start-valid_end-from-test_pages_in_a_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: drop valid_start/valid_end from test_pages_in_a_zone()

The callers are only interested in the actual zone, they don't care
about boundaries. Return the zone instead to simplify.

Link: http://lkml.kernel.org/r/20200110183308.11849-1-david@redhat.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |    9 ++++-----
 include/linux/memory_hotplug.h |    4 ++--
 mm/memory_hotplug.c            |   31 +++++++++----------------------
 3 files changed, 15 insertions(+), 29 deletions(-)

--- a/drivers/base/memory.c~mm-memory_hotplug-drop-valid_start-valid_end-from-test_pages_in_a_zone
+++ a/drivers/base/memory.c
@@ -406,7 +406,6 @@ static ssize_t valid_zones_show(struct d
 	struct memory_block *mem = to_memory_block(dev);
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
-	unsigned long valid_start_pfn, valid_end_pfn;
 	struct zone *default_zone;
 	int nid;
 
@@ -419,11 +418,11 @@ static ssize_t valid_zones_show(struct d
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
@@ -95,8 +95,8 @@ extern int zone_grow_waitqueues(struct z
 extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
 /* VM interface that may be used by firmware interface */
 extern int online_pages(unsigned long, unsigned long, int);
-extern int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn,
-	unsigned long *valid_start, unsigned long *valid_end);
+extern struct zone *test_pages_in_a_zone(unsigned long start_pfn,
+					 unsigned long end_pfn);
 extern unsigned long __offline_isolated_pages(unsigned long start_pfn,
 						unsigned long end_pfn);
 
--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-valid_start-valid_end-from-test_pages_in_a_zone
+++ a/mm/memory_hotplug.c
@@ -1181,14 +1181,13 @@ bool is_mem_section_removable(unsigned l
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
@@ -1209,24 +1208,15 @@ int test_pages_in_a_zone(unsigned long s
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
@@ -1471,7 +1461,6 @@ static int __ref __offline_pages(unsigne
 	unsigned long offlined_pages = 0;
 	int ret, node, nr_isolate_pageblock;
 	unsigned long flags;
-	unsigned long valid_start, valid_end;
 	struct zone *zone;
 	struct memory_notify arg;
 	char *reason;
@@ -1496,14 +1485,12 @@ static int __ref __offline_pages(unsigne
 
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
