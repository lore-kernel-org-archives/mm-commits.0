From: akpm@linux-foundation.org
Subject: +
 mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-v3.patch added to -mm tree
Date: Tue, 09 Feb 2016 12:53:07 -0800
Message-ID: <56ba51b3.6nPgEJ03wHXddn56%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641AbcBIUxI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2016 15:53:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, aaron.lu@intel.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-v3
has been added to the -mm tree.  Its filename is
     mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-v3

v3
o remove pfn_valid_within() check for all pages in the pageblock
because pageblock_pfn_to_page() is only called with pageblock aligned pfn.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Aaron Lu <aaron.lu@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  139 ++++++++++++++++++++++------------------------
 1 file changed, 69 insertions(+), 70 deletions(-)

diff -puN mm/page_alloc.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-v3 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-v3
+++ a/mm/page_alloc.c
@@ -1128,6 +1128,75 @@ void __init __free_pages_bootmem(struct
 	return __free_pages_boot_core(page, pfn, order);
 }
 
+/*
+ * Check that the whole (or subset of) a pageblock given by the interval of
+ * [start_pfn, end_pfn) is valid and within the same zone, before scanning it
+ * with the migration of free compaction scanner. The scanners then need to
+ * use only pfn_valid_within() check for arches that allow holes within
+ * pageblocks.
+ *
+ * Return struct page pointer of start_pfn, or NULL if checks were not passed.
+ *
+ * It's possible on some configurations to have a setup like node0 node1 node0
+ * i.e. it's possible that all pages within a zones range of pages do not
+ * belong to a single zone. We assume that a border between node0 and node1
+ * can occur within a single pageblock, but not a node0 node1 node0
+ * interleaving within a single pageblock. It is therefore sufficient to check
+ * the first and last page of a pageblock and avoid checking each individual
+ * page in a pageblock.
+ */
+struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
+				     unsigned long end_pfn, struct zone *zone)
+{
+	struct page *start_page;
+	struct page *end_page;
+
+	/* end_pfn is one past the range we are checking */
+	end_pfn--;
+
+	if (!pfn_valid(start_pfn) || !pfn_valid(end_pfn))
+		return NULL;
+
+	start_page = pfn_to_page(start_pfn);
+
+	if (page_zone(start_page) != zone)
+		return NULL;
+
+	end_page = pfn_to_page(end_pfn);
+
+	/* This gives a shorter code than deriving page_zone(end_page) */
+	if (page_zone_id(start_page) != page_zone_id(end_page))
+		return NULL;
+
+	return start_page;
+}
+
+void set_zone_contiguous(struct zone *zone)
+{
+	unsigned long block_start_pfn = zone->zone_start_pfn;
+	unsigned long block_end_pfn;
+
+	block_end_pfn = ALIGN(block_start_pfn + 1, pageblock_nr_pages);
+	for (; block_start_pfn < zone_end_pfn(zone);
+			block_start_pfn = block_end_pfn,
+			 block_end_pfn += pageblock_nr_pages) {
+
+		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
+
+		if (!__pageblock_pfn_to_page(block_start_pfn,
+					     block_end_pfn, zone))
+			return;
+	}
+
+	/* We confirm that there is no hole */
+	zone->contiguous = true;
+}
+
+void clear_zone_contiguous(struct zone *zone)
+{
+	zone->contiguous = false;
+}
+
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static void __init deferred_free_range(struct page *page,
 					unsigned long pfn, int nr_pages)
@@ -1304,76 +1373,6 @@ void __init page_alloc_init_late(void)
 		set_zone_contiguous(zone);
 }
 
-/*
- * Check that the whole (or subset of) a pageblock given by the interval of
- * [start_pfn, end_pfn) is valid and within the same zone, before scanning it
- * with the migration of free compaction scanner. The scanners then need to
- * use only pfn_valid_within() check for arches that allow holes within
- * pageblocks.
- *
- * Return struct page pointer of start_pfn, or NULL if checks were not passed.
- *
- * It's possible on some configurations to have a setup like node0 node1 node0
- * i.e. it's possible that all pages within a zones range of pages do not
- * belong to a single zone. We assume that a border between node0 and node1
- * can occur within a single pageblock, but not a node0 node1 node0
- * interleaving within a single pageblock. It is therefore sufficient to check
- * the first and last page of a pageblock and avoid checking each individual
- * page in a pageblock.
- */
-struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
-				unsigned long end_pfn, struct zone *zone)
-{
-	struct page *start_page;
-	struct page *end_page;
-
-	/* end_pfn is one past the range we are checking */
-	end_pfn--;
-
-	if (!pfn_valid(start_pfn) || !pfn_valid(end_pfn))
-		return NULL;
-
-	start_page = pfn_to_page(start_pfn);
-
-	if (page_zone(start_page) != zone)
-		return NULL;
-
-	end_page = pfn_to_page(end_pfn);
-
-	/* This gives a shorter code than deriving page_zone(end_page) */
-	if (page_zone_id(start_page) != page_zone_id(end_page))
-		return NULL;
-
-	return start_page;
-}
-
-void set_zone_contiguous(struct zone *zone)
-{
-	unsigned long block_start_pfn = zone->zone_start_pfn;
-	unsigned long block_end_pfn;
-	unsigned long pfn;
-
-	block_end_pfn = ALIGN(block_start_pfn + 1, pageblock_nr_pages);
-	for (; block_start_pfn < zone_end_pfn(zone);
-		block_start_pfn = block_end_pfn,
-		block_end_pfn += pageblock_nr_pages) {
-
-		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
-
-		if (!__pageblock_pfn_to_page(block_start_pfn,
-					block_end_pfn, zone))
-			return;
-	}
-
-	/* We confirm that there is no hole */
-	zone->contiguous = true;
-}
-
-void clear_zone_contiguous(struct zone *zone)
-{
-	zone->contiguous = false;
-}
