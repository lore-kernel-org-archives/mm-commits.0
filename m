From: akpm@linux-foundation.org
Subject: + page-allocator-clean-up-functions-related-to-pages_min.patch added to -mm tree
Date: Tue, 26 May 2009 22:30:25 -0700
Message-ID: <200905270530.n4R5UPd1030520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbZE0Fbo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 01:31:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     page-allocator: clean up functions related to pages_min
has been added to the -mm tree.  Its filename is
     page-allocator-clean-up-functions-related-to-pages_min.patch

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
Subject: page-allocator: clean up functions related to pages_min
From: Minchan Kim <minchan.kim@gmail.com>

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    2 +-
 mm/memory_hotplug.c |    2 +-
 mm/page_alloc.c     |   15 ++++++++-------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff -puN include/linux/mm.h~page-allocator-clean-up-functions-related-to-pages_min include/linux/mm.h
--- a/include/linux/mm.h~page-allocator-clean-up-functions-related-to-pages_min
+++ a/include/linux/mm.h
@@ -1057,7 +1057,7 @@ extern int __meminit __early_pfn_to_nid(
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
-extern void setup_per_zone_pages_min(void);
+extern void setup_per_zone_wmarks(void);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(void);
diff -puN mm/memory_hotplug.c~page-allocator-clean-up-functions-related-to-pages_min mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~page-allocator-clean-up-functions-related-to-pages_min
+++ a/mm/memory_hotplug.c
@@ -422,7 +422,7 @@ int online_pages(unsigned long pfn, unsi
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 
-	setup_per_zone_pages_min();
+	setup_per_zone_wmarks();
 	if (onlined_pages) {
 		kswapd_run(zone_to_nid(zone));
 		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
diff -puN mm/page_alloc.c~page-allocator-clean-up-functions-related-to-pages_min mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-clean-up-functions-related-to-pages_min
+++ a/mm/page_alloc.c
@@ -4465,12 +4465,13 @@ static void setup_per_zone_lowmem_reserv
 }
 
 /**
- * setup_per_zone_pages_min - called when min_free_kbytes changes.
+ * setup_per_zone_wmarks - called when min_free_kbytes changes 
+ * or when memory is hot-added
  *
- * Ensures that the pages_{min,low,high} values for each zone are set correctly
+ * Ensures that the watermark[min,low,high] values for each zone are set correctly
  * with respect to min_free_kbytes.
  */
-void setup_per_zone_pages_min(void)
+void setup_per_zone_wmarks(void)
 {
 	unsigned long pages_min = min_free_kbytes >> (PAGE_SHIFT - 10);
 	unsigned long lowmem_pages = 0;
@@ -4588,7 +4589,7 @@ static void __init setup_per_zone_inacti
  * 8192MB:	11584k
  * 16384MB:	16384k
  */
-static int __init init_per_zone_pages_min(void)
+static int __init init_per_zone_wmark_min(void)
 {
 	unsigned long lowmem_kbytes;
 
@@ -4599,12 +4600,12 @@ static int __init init_per_zone_pages_mi
 		min_free_kbytes = 128;
 	if (min_free_kbytes > 65536)
 		min_free_kbytes = 65536;
-	setup_per_zone_pages_min();
+	setup_per_zone_wmarks();
 	setup_per_zone_lowmem_reserve();
 	setup_per_zone_inactive_ratio();
 	return 0;
 }
-module_init(init_per_zone_pages_min)
+module_init(init_per_zone_wmark_min)
 
 /*
  * min_free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so 
@@ -4616,7 +4617,7 @@ int min_free_kbytes_sysctl_handler(ctl_t
 {
 	proc_dointvec(table, write, file, buffer, length, ppos);
 	if (write)
-		setup_per_zone_pages_min();
+		setup_per_zone_wmarks();
 	return 0;
 }
 
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

