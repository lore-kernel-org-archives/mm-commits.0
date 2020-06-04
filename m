From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscanc-change-prototype-for-shrink_page_list.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:19:45 -0700
Message-ID: <20200604171945.ynEeRF8KA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730043AbgFDRTq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:19:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.sahrawat@samsung.com, maninder1.s@samsung.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, v.narang@samsung.com, vbabka@suse.cz


The patch titled
     Subject: mm/vmscan.c: change prototype for shrink_page_list
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-change-prototype-for-shrink_page_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: mm/vmscan.c: change prototype for shrink_page_list

commit 3c710c1ad11b ("mm, vmscan extract shrink_page_list reclaim counters
into a struct") changed data type for the function, so changing return
type for funciton and its caller.

Link: http://lkml.kernel.org/r/1588168259-25604-1-git-send-email-maninder1.s@samsung.com
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    2 +-
 mm/page_alloc.c |    2 +-
 mm/vmscan.c     |   24 ++++++++++++------------
 3 files changed, 14 insertions(+), 14 deletions(-)

--- a/mm/internal.h~mm-vmscanc-change-prototype-for-shrink_page_list
+++ a/mm/internal.h
@@ -538,7 +538,7 @@ extern unsigned long  __must_check vm_mm
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
-unsigned long reclaim_clean_pages_from_list(struct zone *zone,
+unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *page_list);
 /* The ALLOC_WMARK bits are used as an index to zone->watermark */
 #define ALLOC_WMARK_MIN		WMARK_MIN
--- a/mm/page_alloc.c~mm-vmscanc-change-prototype-for-shrink_page_list
+++ a/mm/page_alloc.c
@@ -8355,7 +8355,7 @@ static int __alloc_contig_migrate_range(
 					unsigned long start, unsigned long end)
 {
 	/* This function is based on compact_zone() from compaction.c. */
-	unsigned long nr_reclaimed;
+	unsigned int nr_reclaimed;
 	unsigned long pfn = start;
 	unsigned int tries = 0;
 	int ret = 0;
--- a/mm/vmscan.c~mm-vmscanc-change-prototype-for-shrink_page_list
+++ a/mm/vmscan.c
@@ -1066,17 +1066,17 @@ static void page_check_dirty_writeback(s
 /*
  * shrink_page_list() returns the number of reclaimed pages
  */
-static unsigned long shrink_page_list(struct list_head *page_list,
-				      struct pglist_data *pgdat,
-				      struct scan_control *sc,
-				      enum ttu_flags ttu_flags,
-				      struct reclaim_stat *stat,
-				      bool ignore_references)
+static unsigned int shrink_page_list(struct list_head *page_list,
+				     struct pglist_data *pgdat,
+				     struct scan_control *sc,
+				     enum ttu_flags ttu_flags,
+				     struct reclaim_stat *stat,
+				     bool ignore_references)
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
-	unsigned nr_reclaimed = 0;
-	unsigned pgactivate = 0;
+	unsigned int nr_reclaimed = 0;
+	unsigned int pgactivate = 0;
 
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
@@ -1487,7 +1487,7 @@ keep:
 	return nr_reclaimed;
 }
 
-unsigned long reclaim_clean_pages_from_list(struct zone *zone,
+unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *page_list)
 {
 	struct scan_control sc = {
@@ -1496,7 +1496,7 @@ unsigned long reclaim_clean_pages_from_l
 		.may_unmap = 1,
 	};
 	struct reclaim_stat stat;
-	unsigned long nr_reclaimed;
+	unsigned int nr_reclaimed;
 	struct page *page, *next;
 	LIST_HEAD(clean_pages);
 
@@ -1910,7 +1910,7 @@ shrink_inactive_list(unsigned long nr_to
 {
 	LIST_HEAD(page_list);
 	unsigned long nr_scanned;
-	unsigned long nr_reclaimed = 0;
+	unsigned int nr_reclaimed = 0;
 	unsigned long nr_taken;
 	struct reclaim_stat stat;
 	int file = is_file_lru(lru);
@@ -2106,7 +2106,7 @@ static void shrink_active_list(unsigned
 unsigned long reclaim_pages(struct list_head *page_list)
 {
 	int nid = NUMA_NO_NODE;
-	unsigned long nr_reclaimed = 0;
+	unsigned int nr_reclaimed = 0;
 	LIST_HEAD(node_page_list);
 	struct reclaim_stat dummy_stat;
 	struct page *page;
_

Patches currently in -mm which might be from maninder1.s@samsung.com are
