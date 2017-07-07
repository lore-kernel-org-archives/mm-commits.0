From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-fix-mmop_online_keep-behavior.patch removed from -mm tree
Date: Fri, 07 Jul 2017 12:09:21 -0700
Message-ID: <20170707190921.vG2GNCrIt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33110 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752114AbdGGTJ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:09:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, dan.j.williams@intel.com, heiko.carstens@de.ibm.com, mhocko@suse.com, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm, memory_hotplug: fix MMOP_ONLINE_KEEP behavior
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-mmop_online_keep-behavior.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: fix MMOP_ONLINE_KEEP behavior

Heiko Carstens has noticed that the MMOP_ONLINE_KEEP is broken currently
$ grep . memory3?/valid_zones
memory34/valid_zones:Normal Movable
memory35/valid_zones:Normal Movable
memory36/valid_zones:Normal Movable
memory37/valid_zones:Normal Movable

$ echo online_movable > memory34/state
$ grep . memory3?/valid_zones
memory34/valid_zones:Movable
memory35/valid_zones:Movable
memory36/valid_zones:Movable
memory37/valid_zones:Movable

$ echo online > memory36/state
$ grep . memory3?/valid_zones
memory34/valid_zones:Movable
memory36/valid_zones:Normal
memory37/valid_zones:Movable

so we have effectively punched a hole into the movable zone.  The problem
is that move_pfn_range() check for MMOP_ONLINE_KEEP is wrong.  It only
checks whether the given range is already part of the movable zone which
is not the case here as only memory34 is in the zone.  Fix this by using
allow_online_pfn_range(..., MMOP_ONLINE_KERNEL) if that is false then we
can be sure that movable onlining is the right thing to do.

Fixes: "mm, memory_hotplug: do not associate hotadded memory to zones until online"
Link: http://lkml.kernel.org/r/20170601083746.4924-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-fix-mmop_online_keep-behavior mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-mmop_online_keep-behavior
+++ a/mm/memory_hotplug.c
@@ -1115,11 +1115,12 @@ static struct zone * __meminit move_pfn_
 	if (online_type == MMOP_ONLINE_KEEP) {
 		struct zone *movable_zone = &pgdat->node_zones[ZONE_MOVABLE];
 		/*
-		 * MMOP_ONLINE_KEEP inherits the current zone which is
-		 * ZONE_NORMAL by default but we might be within ZONE_MOVABLE
-		 * already.
+		 * MMOP_ONLINE_KEEP defaults to MMOP_ONLINE_KERNEL but use
+		 * movable zone if that is not possible (e.g. we are within
+		 * or past the existing movable zone)
 		 */
-		if (zone_intersects(movable_zone, start_pfn, nr_pages))
+		if (!allow_online_pfn_range(nid, start_pfn, nr_pages,
+					MMOP_ONLINE_KERNEL))
 			zone = movable_zone;
 	} else if (online_type == MMOP_ONLINE_MOVABLE) {
 		zone = &pgdat->node_zones[ZONE_MOVABLE];
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-make-pr_set_thp_disable-immediately-active.patch
mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration.patch
mm-unify-new_node_page-and-alloc_migrate_target.patch
mm-memcg-fix-potential-undefined-behavior-in-mem_cgroup_event_ratelimit.patch
mm-hugetlb-unclutter-hugetlb-allocation-layers.patch
hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask.patch
mm-hugetlb-soft_offline-use-new_page_nodemask-for-soft-offline-migration.patch
mm-document-highmem_is_dirtyable-sysctl.patch
mm-mm-mmap-do-not-blow-on-prot_none-map_fixed-holes-in-the-stack.patch
mm-disallow-early_pfn_to_nid-on-configurations-which-do-not-implement-it.patch
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch
mips-do-not-use-__gfp_repeat-for-order-0-request.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch
xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch
mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch
drm-i915-use-__gfp_retry_mayfail.patch
mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch

