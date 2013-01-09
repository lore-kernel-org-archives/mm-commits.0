From: akpm@linux-foundation.org
Subject: + memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch added to -mm tree
Date: Wed, 09 Jan 2013 15:34:30 -0800
Message-ID: <20130109233430.77A77100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:37021 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab3AIXec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:34:32 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so320545qch.4
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:34:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: memory-hotplug: do not allocate pdgat if it was not freed when offline.
has been added to the -mm tree.  Its filename is
     memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memory-hotplug: do not allocate pdgat if it was not freed when offline.

Since there is no way to guarentee the address of pgdat/zone is not on
stack of any kernel threads or used by other kernel objects without
reference counting or other symchronizing method, we cannot reset
node_data and free pgdat when offlining a node.  Just reset pgdat to 0 and
reuse the memory when the node is online again.

The problem is suggested by Kamezawa Hiroyuki.  The idea is from Wen
Congyang.

NOTE: If we don't reset pgdat to 0, the WARN_ON in free_area_init_node()
      will be triggered.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline
+++ a/mm/memory_hotplug.c
@@ -1015,11 +1015,14 @@ static pg_data_t __ref *hotadd_new_pgdat
 	unsigned long zholes_size[MAX_NR_ZONES] = {0};
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 
-	pgdat = arch_alloc_nodedata(nid);
-	if (!pgdat)
-		return NULL;
+	pgdat = NODE_DATA(nid);
+	if (!pgdat) {
+		pgdat = arch_alloc_nodedata(nid);
+		if (!pgdat)
+			return NULL;
 
-	arch_refresh_nodedata(nid, pgdat);
+		arch_refresh_nodedata(nid, pgdat);
+	}
 
 	/* we can use NODE_DATA(nid) from here */
 
@@ -1072,7 +1075,7 @@ out:
 int __ref add_memory(int nid, u64 start, u64 size)
 {
 	pg_data_t *pgdat = NULL;
-	int new_pgdat = 0;
+	int new_pgdat = 0, new_node = 0;
 	struct resource *res;
 	int ret;
 
@@ -1083,12 +1086,13 @@ int __ref add_memory(int nid, u64 start,
 	if (!res)
 		goto out;
 
-	if (!node_online(nid)) {
+	new_pgdat = NODE_DATA(nid) ? 0 : 1;
+	new_node = node_online(nid) ? 0 : 1;
+	if (new_node) {
 		pgdat = hotadd_new_pgdat(nid, start);
 		ret = -ENOMEM;
 		if (!pgdat)
 			goto error;
-		new_pgdat = 1;
 	}
 
 	/* call arch's memory hotadd */
@@ -1100,7 +1104,7 @@ int __ref add_memory(int nid, u64 start,
 	/* we online node here. we can't roll back from here. */
 	node_set_online(nid);
 
-	if (new_pgdat) {
+	if (new_node) {
 		ret = register_one_node(nid);
 		/*
 		 * If sysfs file of new node can't create, cpu on the node
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch

