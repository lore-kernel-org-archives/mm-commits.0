From: akpm@linux-foundation.org
Subject: + memory-hotplug-free-node_data-when-a-node-is-offlined.patch added to -mm tree
Date: Wed, 09 Jan 2013 15:34:24 -0800
Message-ID: <20130109233425.2D977200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:37341 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab3AIXe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:34:29 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so146059bkc.5
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:34:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wujianguo@huawei.com


The patch titled
     Subject: memory-hotplug: free node_data when a node is offlined
has been added to the -mm tree.  Its filename is
     memory-hotplug-free-node_data-when-a-node-is-offlined.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1698,9 +1698,12 @@ static int check_cpu_on_node(void *data)
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
@@ -1718,7 +1721,7 @@ static void try_offline_node(int nid)
 		return;
 	}
 
-	if (stop_machine(check_cpu_on_node, NODE_DATA(nid), NULL))
+	if (stop_machine(check_cpu_on_node, pgdat, NULL))
 		return;
 
 	/*
@@ -1727,6 +1730,27 @@ static void try_offline_node(int nid)
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

x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch

