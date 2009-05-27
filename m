From: akpm@linux-foundation.org
Subject: + page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch added to -mm tree
Date: Tue, 26 May 2009 22:30:33 -0700
Message-ID: <200905270530.n4R5UXDo030635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754119AbZE0Faw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 01:30:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     page-allocator: add inactive ratio calculation function of each zone
has been added to the -mm tree.  Its filename is
     page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch

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
Subject: page-allocator: add inactive ratio calculation function of each zone
From: Minchan Kim <minchan.kim@gmail.com>

Factor the per-zone arithemetic inside setup_per_zone_inactive_ratio()'s
loop into a a separate function, calculate_zone_inactive_ratio().  This
function will be used in a later patch

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/page_alloc.c    |   28 ++++++++++++++++------------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff -puN include/linux/mm.h~page-allocator-add-inactive-ratio-calculation-function-of-each-zone include/linux/mm.h
--- a/include/linux/mm.h~page-allocator-add-inactive-ratio-calculation-function-of-each-zone
+++ a/include/linux/mm.h
@@ -1058,6 +1058,7 @@ extern void set_dma_reserve(unsigned lon
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
 extern void setup_per_zone_wmarks(void);
+extern void calculate_zone_inactive_ratio(struct zone *zone);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(void);
diff -puN mm/page_alloc.c~page-allocator-add-inactive-ratio-calculation-function-of-each-zone mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-add-inactive-ratio-calculation-function-of-each-zone
+++ a/mm/page_alloc.c
@@ -4547,22 +4547,26 @@ void setup_per_zone_wmarks(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-static void __init setup_per_zone_inactive_ratio(void)
+void calculate_zone_inactive_ratio(struct zone *zone)
 {
-	struct zone *zone;
+	unsigned int gb, ratio;
 
-	for_each_zone(zone) {
-		unsigned int gb, ratio;
+	/* Zone size in gigabytes */
+	gb = zone->present_pages >> (30 - PAGE_SHIFT);
+	if (gb)
+		ratio = int_sqrt(10 * gb);
+	else
+		ratio = 1;
 
-		/* Zone size in gigabytes */
-		gb = zone->present_pages >> (30 - PAGE_SHIFT);
-		if (gb)
-			ratio = int_sqrt(10 * gb);
-		else
-			ratio = 1;
+	zone->inactive_ratio = ratio;
+}
 
-		zone->inactive_ratio = ratio;
-	}
+static void __init setup_per_zone_inactive_ratio(void)
+{
+	struct zone *zone;
+
+	for_each_zone(zone)
+		calculate_zone_inactive_ratio(zone);	
 }
 
 /*
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

linux-next.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
vmscan-prevent-shrinking-of-active-anon-lru-list-in-case-of-no-swap-space-v3.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch
page-allocator-reset-wmark_min-and-inactive-ratio-of-zone-when-hotplug-happens.patch
use-printk_once-in-several-places.patch
use-printk_once-in-several-places-clean-up-printk_once-of-get_cpu_vendor.patch

