From: akpm@linux-foundation.org
Subject: + memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch added to -mm tree
Date: Wed, 14 Nov 2012 11:42:02 -0800
Message-ID: <20121114194203.A05FB5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:37354 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2KNTmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 14:42:08 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so61466lag.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 11:42:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, greg@kroah.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, rientjes@google.com, rusty@rustcorp.com.au, wency@cn.fujitsu.com, yinghai@kernel.org


The patch titled
     Subject: memory_hotplug: handle empty zone when online_movable/online_kernel
has been added to the -mm tree.  Its filename is
     memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: memory_hotplug: handle empty zone when online_movable/online_kernel

Make online_movable/online_kernel can empty a zone or can move memory to a
empty zone.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   51 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 6 deletions(-)

diff -puN mm/memory_hotplug.c~memory_hotplug-handle-empty-zone-when-online_movable-online_kernel mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory_hotplug-handle-empty-zone-when-online_movable-online_kernel
+++ a/mm/memory_hotplug.c
@@ -226,8 +226,17 @@ static void resize_zone(struct zone *zon
 {
 	zone_span_writelock(zone);
 
-	zone->zone_start_pfn = start_pfn;
-	zone->spanned_pages = end_pfn - start_pfn;
+	if (end_pfn - start_pfn) {
+		zone->zone_start_pfn = start_pfn;
+		zone->spanned_pages = end_pfn - start_pfn;
+	} else {
+		/*
+		 * make it consist as free_area_init_core(),
+		 * if spanned_pages = 0, then keep start_pfn = 0
+		 */
+		zone->zone_start_pfn = 0;
+		zone->spanned_pages = 0;
+	}
 
 	zone_span_writeunlock(zone);
 }
@@ -243,10 +252,19 @@ static void fix_zone_id(struct zone *zon
 		set_page_links(pfn_to_page(pfn), zid, nid, pfn);
 }
 
-static int move_pfn_range_left(struct zone *z1, struct zone *z2,
+static int __meminit move_pfn_range_left(struct zone *z1, struct zone *z2,
 		unsigned long start_pfn, unsigned long end_pfn)
 {
+	int ret;
 	unsigned long flags;
+	unsigned long z1_start_pfn;
+
+	if (!z1->wait_table) {
+		ret = init_currently_empty_zone(z1, start_pfn,
+			end_pfn - start_pfn, MEMMAP_HOTPLUG);
+		if (ret)
+			return ret;
+	}
 
 	pgdat_resize_lock(z1->zone_pgdat, &flags);
 
@@ -260,7 +278,13 @@ static int move_pfn_range_left(struct zo
 	if (end_pfn <= z2->zone_start_pfn)
 		goto out_fail;
 
-	resize_zone(z1, z1->zone_start_pfn, end_pfn);
+	/* use start_pfn for z1's start_pfn if z1 is empty */
+	if (z1->spanned_pages)
+		z1_start_pfn = z1->zone_start_pfn;
+	else
+		z1_start_pfn = start_pfn;
+
+	resize_zone(z1, z1_start_pfn, end_pfn);
 	resize_zone(z2, end_pfn, z2->zone_start_pfn + z2->spanned_pages);
 
 	pgdat_resize_unlock(z1->zone_pgdat, &flags);
@@ -273,10 +297,19 @@ out_fail:
 	return -1;
 }
 
-static int move_pfn_range_right(struct zone *z1, struct zone *z2,
+static int __meminit move_pfn_range_right(struct zone *z1, struct zone *z2,
 		unsigned long start_pfn, unsigned long end_pfn)
 {
+	int ret;
 	unsigned long flags;
+	unsigned long z2_end_pfn;
+
+	if (!z2->wait_table) {
+		ret = init_currently_empty_zone(z2, start_pfn,
+			end_pfn - start_pfn, MEMMAP_HOTPLUG);
+		if (ret)
+			return ret;
+	}
 
 	pgdat_resize_lock(z1->zone_pgdat, &flags);
 
@@ -290,8 +323,14 @@ static int move_pfn_range_right(struct z
 	if (start_pfn >= z1->zone_start_pfn + z1->spanned_pages)
 		goto out_fail;
 
+	/* use end_pfn for z2's end_pfn if z2 is empty */
+	if (z2->spanned_pages)
+		z2_end_pfn = z2->zone_start_pfn + z2->spanned_pages;
+	else
+		z2_end_pfn = end_pfn;
+
 	resize_zone(z1, z1->zone_start_pfn, start_pfn);
-	resize_zone(z2, start_pfn, z2->zone_start_pfn + z2->spanned_pages);
+	resize_zone(z2, start_pfn, z2_end_pfn);
 
 	pgdat_resize_unlock(z1->zone_pgdat, &flags);
 
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
drivers-base-nodec-cleanup-node_state_attr.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch

