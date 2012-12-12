From: akpm@linux-foundation.org
Subject: [folded-merged] hotplug-update-nodemasks-management-fix.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:38:34 -0800
Message-ID: <20121212213835.57E0A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:32816 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2LLVii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:38:38 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so67179eaa.0
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:38:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, cl@linux.com, dhillf@gmail.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hotplug-update-nodemasks-management-fix
has been removed from the -mm tree.  Its filename was
     hotplug-update-nodemasks-management-fix.patch

This patch was dropped because it was folded into hotplug-update-nodemasks-management.patch

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: hotplug-update-nodemasks-management-fix

fix build

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/memory_hotplug.c~hotplug-update-nodemasks-management-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~hotplug-update-nodemasks-management-fix
+++ a/mm/memory_hotplug.c
@@ -620,14 +620,14 @@ static void node_states_check_changes_on
 #ifdef CONFIG_HIGHMEM
 	/*
 	 * If we have movable node, node_states[N_HIGH_MEMORY]
-	 * contains nodes which have zones of 0...ZONE_HIGH,
-	 * set zone_last to ZONE_HIGH.
+	 * contains nodes which have zones of 0...ZONE_HIGHMEM,
+	 * set zone_last to ZONE_HIGHMEM.
 	 *
 	 * If we don't have movable node, node_states[N_NORMAL_MEMORY]
 	 * contains nodes which have zones of 0...ZONE_MOVABLE,
 	 * set zone_last to ZONE_MOVABLE.
 	 */
-	zone_last = ZONE_HIGH;
+	zone_last = ZONE_HIGHMEM;
 	if (N_MEMORY == N_HIGH_MEMORY)
 		zone_last = ZONE_MOVABLE;
 
@@ -1151,17 +1151,17 @@ static void node_states_check_changes_of
 	else
 		arg->status_change_nid_normal = -1;
 
-#ifdef CONIG_HIGHMEM
+#ifdef CONFIG_HIGHMEM
 	/*
 	 * If we have movable node, node_states[N_HIGH_MEMORY]
-	 * contains nodes which have zones of 0...ZONE_HIGH,
-	 * set zone_last to ZONE_HIGH.
+	 * contains nodes which have zones of 0...ZONE_HIGHMEM,
+	 * set zone_last to ZONE_HIGHMEM.
 	 *
 	 * If we don't have movable node, node_states[N_NORMAL_MEMORY]
 	 * contains nodes which have zones of 0...ZONE_MOVABLE,
 	 * set zone_last to ZONE_MOVABLE.
 	 */
-	zone_last = ZONE_HIGH;
+	zone_last = ZONE_HIGHMEM;
 	if (N_MEMORY == N_HIGH_MEMORY)
 		zone_last = ZONE_MOVABLE;
 
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
hotplug-update-nodemasks-management.patch

