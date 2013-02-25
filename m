From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:50:31 -0800
Message-ID: <20130225205031.E76685A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:36280 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab3BYUud (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:50:33 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so347461ggn.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:50:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: do not allocate pgdat if it was not freed when offline.
has been removed from the -mm tree.  Its filename was
     memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memory-hotplug: do not allocate pgdat if it was not freed when offline.

Since there is no way to guarentee the address of pgdat/zone is not on
stack of any kernel threads or used by other kernel objects without
reference counting or other symchronizing method, we cannot reset
node_data and free pgdat when offlining a node.  Just reset pgdat to 0 and
reuse the memory when the node is online again.

The problem is suggested by Kamezawa Hiroyuki.  The idea is from Wen
Congyang.

NOTE: If we don't reset pgdat to 0, the WARN_ON in free_area_init_node()
      will be triggered.

[akpm@linux-foundation.org: fix warning when CONFIG_NEED_MULTIPLE_NODES=n]
[akpm@linux-foundation.org: fix the warning again again]
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

 mm/memory_hotplug.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline
+++ a/mm/memory_hotplug.c
@@ -1017,11 +1017,14 @@ static pg_data_t __ref *hotadd_new_pgdat
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
 
@@ -1074,7 +1077,8 @@ out:
 int __ref add_memory(int nid, u64 start, u64 size)
 {
 	pg_data_t *pgdat = NULL;
-	int new_pgdat = 0;
+	bool new_pgdat;
+	bool new_node;
 	struct resource *res;
 	int ret;
 
@@ -1085,12 +1089,16 @@ int __ref add_memory(int nid, u64 start,
 	if (!res)
 		goto out;
 
-	if (!node_online(nid)) {
+	{	/* Stupid hack to suppress address-never-null warning */
+		void *p = NODE_DATA(nid);
+		new_pgdat = !p;
+	}
+	new_node = !node_online(nid);
+	if (new_node) {
 		pgdat = hotadd_new_pgdat(nid, start);
 		ret = -ENOMEM;
 		if (!pgdat)
 			goto error;
-		new_pgdat = 1;
 	}
 
 	/* call arch's memory hotadd */
@@ -1102,7 +1110,7 @@ int __ref add_memory(int nid, u64 start,
 	/* we online node here. we can't roll back from here. */
 	node_set_online(nid);
 
-	if (new_pgdat) {
+	if (new_node) {
 		ret = register_one_node(nid);
 		/*
 		 * If sysfs file of new node can't create, cpu on the node
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

