From: akpm@linux-foundation.org
Subject: [alternative-merged]
 memory-hotplug-remove-reset_node_managed_pages-and-reset_node_managed_pages-in-hotadd_new_pgdat.patch removed from -mm tree
Date: Mon, 24 Aug 2015 12:33:05 -0700
Message-ID: <55db7171.UeAf/pgwEDQQyNHh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbbHXTdF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Aug 2015 15:33:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, guz.fnst@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, tangchen@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: remove reset_node_managed_pages() and reset_node_managed_pages() in hotadd_new_pgdat()
has been removed from the -mm tree.  Its filename was
     memory-hotplug-remove-reset_node_managed_pages-and-reset_node_managed_pages-in-hotadd_new_pgdat.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: memory-hotplug: remove reset_node_managed_pages() and reset_node_managed_pages() in hotadd_new_pgdat()

After hotadd_new_pgdat()->free_area_init_node(), the pgdat and zone's
spanned/present are both 0, so remove reset_node_managed_pages() and
reset_node_managed_pages().

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-remove-reset_node_managed_pages-and-reset_node_managed_pages-in-hotadd_new_pgdat mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-remove-reset_node_managed_pages-and-reset_node_managed_pages-in-hotadd_new_pgdat
+++ a/mm/memory_hotplug.c
@@ -1073,16 +1073,6 @@ int __ref online_pages(unsigned long pfn
 }
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
-static void reset_node_present_pages(pg_data_t *pgdat)
-{
-	struct zone *z;
-
-	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
-		z->present_pages = 0;
-
-	pgdat->node_present_pages = 0;
-}
-
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
 {
@@ -1117,21 +1107,6 @@ static pg_data_t __ref *hotadd_new_pgdat
 	build_all_zonelists(pgdat, NULL);
 	mutex_unlock(&zonelists_mutex);
 
-	/*
-	 * zone->managed_pages is set to an approximate value in
-	 * free_area_init_core(), which will cause
-	 * /sys/device/system/node/nodeX/meminfo has wrong data.
-	 * So reset it to 0 before any memory is onlined.
-	 */
-	reset_node_managed_pages(pgdat);
-
-	/*
-	 * When memory is hot-added, all the memory is in offline state. So
-	 * clear all zones' present_pages because they will be updated in
-	 * online_pages() and offline_pages().
-	 */
-	reset_node_present_pages(pgdat);
