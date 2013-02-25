From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-free-node_data-when-a-node-is-offlined.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:50:27 -0800
Message-ID: <20130225205027.D72C55A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:55831 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560Ab3BYUu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:50:29 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so347564yhz.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:50:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: free node_data when a node is offlined
has been removed from the -mm tree.  Its filename was
     memory-hotplug-free-node_data-when-a-node-is-offlined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: free node_data when a node is offlined

We call hotadd_new_pgdat() to allocate memory to store node_data.  So we
should free it when removing a node.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-free-node_data-when-a-node-is-offlined mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-free-node_data-when-a-node-is-offlined
+++ a/mm/memory_hotplug.c
@@ -1700,9 +1700,12 @@ static int check_cpu_on_node(void *data)
 /* offline the node if all memory sections of this node are removed */
 static void try_offline_node(int nid)
 {
-	unsigned long start_pfn = NODE_DATA(nid)->node_start_pfn;
-	unsigned long end_pfn = start_pfn + NODE_DATA(nid)->node_spanned_pages;
+	pg_data_t *pgdat = NODE_DATA(nid);
+	unsigned long start_pfn = pgdat->node_start_pfn;
+	unsigned long end_pfn = start_pfn + pgdat->node_spanned_pages;
 	unsigned long pfn;
+	struct page *pgdat_page = virt_to_page(pgdat);
+	int i;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
@@ -1720,7 +1723,7 @@ static void try_offline_node(int nid)
 		return;
 	}
 
-	if (stop_machine(check_cpu_on_node, NODE_DATA(nid), NULL))
+	if (stop_machine(check_cpu_on_node, pgdat, NULL))
 		return;
 
 	/*
@@ -1729,6 +1732,27 @@ static void try_offline_node(int nid)
 	 */
 	node_set_offline(nid);
 	unregister_one_node(nid);
+
+	if (!PageSlab(pgdat_page) && !PageCompound(pgdat_page))
+		/* node data is allocated from boot memory */
+		return;
+
+	/* free waittable in each zone */
+	for (i = 0; i < MAX_NR_ZONES; i++) {
+		struct zone *zone = pgdat->node_zones + i;
+
+		if (zone->wait_table)
+			vfree(zone->wait_table);
+	}
+
+	/*
+	 * Since there is no way to guarentee the address of pgdat/zone is not
+	 * on stack of any kernel threads or used by other kernel objects
+	 * without reference counting or other symchronizing method, do not
+	 * reset node_data and free pgdat here. Just reset it to 0 and reuse
+	 * the memory when the node is online again.
+	 */
+	memset(pgdat, 0, sizeof(*pgdat));
 }
 
 int __ref remove_memory(int nid, u64 start, u64 size)
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-make-mem=-option-to-work-for-efi-platform.patch

