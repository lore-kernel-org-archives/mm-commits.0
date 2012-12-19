From: akpm@linux-foundation.org
Subject: [merged] mm-memory_hotplugc-improve-comments.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:42:45 -0800
Message-ID: <20121219204246.2ACA1200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:53431 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab2LSUms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:42:48 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so134013wib.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:42:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, laijs@cn.fujitsu.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: improve comments
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplugc-improve-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mm/memory_hotplug.c: improve comments

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-improve-comments mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-improve-comments
+++ a/mm/memory_hotplug.c
@@ -590,18 +590,21 @@ static int online_pages_range(unsigned l
 }
 
 #ifdef CONFIG_MOVABLE_NODE
-/* when CONFIG_MOVABLE_NODE, we allow online node don't have normal memory */
+/*
+ * When CONFIG_MOVABLE_NODE, we permit onlining of a node which doesn't have
+ * normal memory.
+ */
 static bool can_online_high_movable(struct zone *zone)
 {
 	return true;
 }
-#else /* #ifdef CONFIG_MOVABLE_NODE */
+#else /* CONFIG_MOVABLE_NODE */
 /* ensure every online node has NORMAL memory */
 static bool can_online_high_movable(struct zone *zone)
 {
 	return node_state(zone_to_nid(zone), N_NORMAL_MEMORY);
 }
-#endif /* #ifdef CONFIG_MOVABLE_NODE */
+#endif /* CONFIG_MOVABLE_NODE */
 
 /* check which state of node_states will be changed when online memory */
 static void node_states_check_changes_online(unsigned long nr_pages,
@@ -1112,12 +1115,15 @@ check_pages_isolated(unsigned long start
 }
 
 #ifdef CONFIG_MOVABLE_NODE
-/* when CONFIG_MOVABLE_NODE, we allow online node don't have normal memory */
+/*
+ * When CONFIG_MOVABLE_NODE, we permit offlining of a node which doesn't have
+ * normal memory.
+ */
 static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
 {
 	return true;
 }
-#else /* #ifdef CONFIG_MOVABLE_NODE */
+#else /* CONFIG_MOVABLE_NODE */
 /* ensure the node has NORMAL memory if it is still online */
 static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
 {
@@ -1141,7 +1147,7 @@ static bool can_offline_normal(struct zo
 	 */
 	return present_pages == 0;
 }
-#endif /* #ifdef CONFIG_MOVABLE_NODE */
+#endif /* CONFIG_MOVABLE_NODE */
 
 /* check which state of node_states will be changed when offline memory */
 static void node_states_check_changes_offline(unsigned long nr_pages,
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch

