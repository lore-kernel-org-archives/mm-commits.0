From: akpm@linux-foundation.org
Subject: + mempolicy-fix-is_valid_nodemask.patch added to -mm tree
Date: Tue, 22 Jan 2013 13:53:21 -0800
Message-ID: <20130122215321.CD6C85A41E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:64937 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3AVVxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 16:53:23 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so690581vcd.3
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 13:53:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: mempolicy: fix is_valid_nodemask()
has been added to the -mm tree.  Its filename is
     mempolicy-fix-is_valid_nodemask.patch

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
Subject: mempolicy: fix is_valid_nodemask()

is_valid_nodemask() was introduced by 19770b32 ("mm: filter based on a
nodemask as well as a gfp_mask").  but it does not match its comments,
because it does not check the zone which > policy_zone.

Also in b377fd ("Apply memory policies to top two highest zones when
highest zone is ZONE_MOVABLE"), this commits told us, if highest zone is
ZONE_MOVABLE, we should also apply memory policies to it.  so ZONE_MOVABLE
should be valid zone for policies.  is_valid_nodemask() need to be changed
to match it.

Fix: check all zones, even its zoneid > policy_zone.  Use
nodes_intersects() instead open code to check it.

Reported-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-fix-is_valid_nodemask mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-fix-is_valid_nodemask
+++ a/mm/mempolicy.c
@@ -161,19 +161,7 @@ static const struct mempolicy_operations
 /* Check that the nodemask contains at least one populated zone */
 static int is_valid_nodemask(const nodemask_t *nodemask)
 {
-	int nd, k;
-
-	for_each_node_mask(nd, *nodemask) {
-		struct zone *z;
-
-		for (k = 0; k <= policy_zone; k++) {
-			z = &NODE_DATA(nd)->node_zones[k];
-			if (z->present_pages > 0)
-				return 1;
-		}
-	}
-
-	return 0;
+	return nodes_intersects(*nodemask, node_states[N_MEMORY]);
 }
 
 static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
@@ -1644,6 +1632,26 @@ struct mempolicy *get_vma_policy(struct 
 	return pol;
 }
 
+static int apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
+{
+	enum zone_type dynamic_policy_zone = policy_zone;
+
+	BUG_ON(dynamic_policy_zone == ZONE_MOVABLE);
+
+	/*
+	 * if policy->v.nodes has movable memory only,
+	 * we apply policy when gfp_zone(gfp) = ZONE_MOVABLE only.
+	 *
+	 * policy->v.nodes is intersect with node_states[N_MEMORY].
+	 * so if the following test faile, it implies
+	 * policy->v.nodes has movable memory only.
+	 */
+	if (!nodes_intersects(policy->v.nodes, node_states[N_HIGH_MEMORY]))
+		dynamic_policy_zone = ZONE_MOVABLE;
+
+	return zone >= dynamic_policy_zone;
+}
+
 /*
  * Return a nodemask representing a mempolicy for filtering nodes for
  * page allocation
@@ -1652,7 +1660,7 @@ static nodemask_t *policy_nodemask(gfp_t
 {
 	/* Lower zones don't get a nodemask applied for MPOL_BIND */
 	if (unlikely(policy->mode == MPOL_BIND) &&
-			gfp_zone(gfp) >= policy_zone &&
+			apply_policy_zone(policy, gfp_zone(gfp)) &&
 			cpuset_nodemask_valid_mems_allowed(&policy->v.nodes))
 		return &policy->v.nodes;
 
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix-fix.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
memory-hotplug-consider-compound-pages-when-free-memmap.patch
mempolicy-fix-is_valid_nodemask.patch
x86-get-pg_data_ts-memory-from-other-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch

