From: akpm@linux-foundation.org
Subject: + mm-memory_hotplugc-improve-comments.patch added to -mm tree
Date: Mon, 17 Dec 2012 13:25:10 -0800
Message-ID: <20121217212511.4928C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40442 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2LQVZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 16:25:12 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so699262vcd.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 13:25:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, laijs@cn.fujitsu.com, wency@cn.fujitsu.com


The patch titled
     Subject: mm/memory_hotplug.c: improve comments
has been added to the -mm tree.  Its filename is
     mm-memory_hotplugc-improve-comments.patch

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
memory-hotplug-document-and-enable-config_movable_node.patch
memory-hotplug-document-and-enable-config_movable_node-fix.patch
mm-memory_hotplugc-improve-comments.patch

