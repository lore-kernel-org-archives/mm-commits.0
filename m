From: akpm@linux-foundation.org
Subject: [merged] memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:29:17 -0800
Message-ID: <20121214232917.D7DBC100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:34519 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab2LNX3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:29:19 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so409316yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:29:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, greg@kroah.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, rientjes@google.com, rusty@rustcorp.com.au, wency@cn.fujitsu.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memory_hotplug: allow online/offline memory to result movable node
has been removed from the -mm tree.  Its filename was
     memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: memory_hotplug: allow online/offline memory to result movable node

Now, memory management can handle movable node or nodes which don't have
any normal memory, so we can dynamic configure and add movable node by:

	online a ZONE_MOVABLE memory from a previous offline node
	offline the last normal memory which result a non-normal-memory-node

movable-node is very important for power-saving, hardware partitioning and
high-available-system(hardware fault management).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
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

 mm/memory_hotplug.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN mm/memory_hotplug.c~memory_hotplug-allow-online-offline-memory-to-result-movable-node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory_hotplug-allow-online-offline-memory-to-result-movable-node
+++ a/mm/memory_hotplug.c
@@ -581,11 +581,19 @@ static int online_pages_range(unsigned l
 	return 0;
 }
 
+#ifdef CONFIG_MOVABLE_NODE
+/* when CONFIG_MOVABLE_NODE, we allow online node don't have normal memory */
+static bool can_online_high_movable(struct zone *zone)
+{
+	return true;
+}
+#else /* #ifdef CONFIG_MOVABLE_NODE */
 /* ensure every online node has NORMAL memory */
 static bool can_online_high_movable(struct zone *zone)
 {
 	return node_state(zone_to_nid(zone), N_NORMAL_MEMORY);
 }
+#endif /* #ifdef CONFIG_MOVABLE_NODE */
 
 /* check which state of node_states will be changed when online memory */
 static void node_states_check_changes_online(unsigned long nr_pages,
@@ -1093,6 +1101,13 @@ check_pages_isolated(unsigned long start
 	return offlined;
 }
 
+#ifdef CONFIG_MOVABLE_NODE
+/* when CONFIG_MOVABLE_NODE, we allow online node don't have normal memory */
+static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
+{
+	return true;
+}
+#else /* #ifdef CONFIG_MOVABLE_NODE */
 /* ensure the node has NORMAL memory if it is still online */
 static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
 {
@@ -1116,6 +1131,7 @@ static bool can_offline_normal(struct zo
 	 */
 	return present_pages == 0;
 }
+#endif /* #ifdef CONFIG_MOVABLE_NODE */
 
 /* check which state of node_states will be changed when offline memory */
 static void node_states_check_changes_offline(unsigned long nr_pages,
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

