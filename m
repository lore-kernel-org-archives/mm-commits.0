From: akpm@linux-foundation.org
Subject: + memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch added to -mm tree
Date: Tue, 20 Nov 2012 14:52:59 -0800
Message-ID: <20121120225300.4827382004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44039 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2KTWxB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 17:53:01 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so485593ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 14:53:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, greg@kroah.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, rientjes@google.com, rusty@rustcorp.com.au, wency@cn.fujitsu.com, yinghai@kernel.org


The patch titled
     Subject: memory_hotplug: allow online/offline memory to result movable node
has been added to the -mm tree.  Its filename is
     memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch

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
@@ -1066,6 +1074,13 @@ check_pages_isolated(unsigned long start
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
@@ -1089,6 +1104,7 @@ static bool can_offline_normal(struct zo
 	 */
 	return present_pages == 0;
 }
+#endif /* #ifdef CONFIG_MOVABLE_NODE */
 
 /* check which state of node_states will be changed when offline memory */
 static void node_states_check_changes_offline(unsigned long nr_pages,
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
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch

