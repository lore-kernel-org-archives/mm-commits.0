From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch added to -mm tree
Date: Tue, 30 May 2017 14:13:14 -0700
Message-ID: <592de06a.Z368uxVoaqXMS7In%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58032 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbdE3VNQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2017 17:13:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, daniel.kiper@oracle.com, imammedo@redhat.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, qiuxishi@huawei.com, rientjes@google.com, slaoub@gmail.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: drop artificial restriction on online/offline
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: drop artificial restriction on online/offline

Patch series "remove CONFIG_MOVABLE_NODE".

I am continuing to clean up the memory hotplug code and
CONFIG_MOVABLE_NODE seems dubious at best.  The following two patches
simply removes the flag and make it de-facto always enabled.

The current semantic of the config option is twofold 1) it automatically
binds hotplugable nodes to have memory in zone_movable by default when
movable_node is enabled 2) forbids memory hotplug to online all the memory
as movable when !CONFIG_MOVABLE_NODE.

The later restriction is quite dubious because there is no clear cut of
how much normal memory do we need for a reasonable system operation.  A
single memory block which is sufficient to allow further movable onlines
is far from sufficient (e.g a node with >2GB and memblocks 128MB will fill
up this zone with struct pages leaving nothing for other allocations). 
Removing the config option will not only reduce the configuration space it
also removes quite some code.

The semantic of the movable_node command line parameter is preserved.

The first patch removes the restriction mentioned above and the second one
simply removes all the CONFIG_MOVABLE_NODE related stuff.  The last patch
moves movable_node flag handling to memory_hotplug proper where it
belongs.

[1] http://lkml.kernel.org/r/20170524122411.25212-1-mhocko@kernel.org



This patch (of 3):

74d42d8fe146 ("memory_hotplug: ensure every online node has NORMAL
memory") has introduced a restriction that every numa node has to have at
least some memory in !movable zones before a first movable memory can be
onlined if !CONFIG_MOVABLE_NODE.  Likewise_offline_normal checks the
amount of normal memory in !movable zones and it disallows to offline
memory if there is no normal memory left with a justification that
"memory-management acts bad when we have nodes which is online but don't
have any normal memory".

While it is true that not having _any_ memory for kernel allocations on a
NUMA node is far from great and such a node would be quite subotimal
because all kernel allocations will have to fallback to another NUMA node
but there is no reason to disallow such a configuration in principle.

Besides that there is not really a big difference to have one memblock for
ZONE_NORMAL available or none.  With 128MB size memblocks the system might
trash on the kernel allocations requests anyway.  It is really hard to
draw a line on how much normal memory is really sufficient so we have to
rely on administrator to configure system sanely therefore drop the
artificial restriction and remove can_offline_normal and
can_online_high_movable altogether.

Link: http://lkml.kernel.org/r/20170529114141.536-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Kani Toshimitsu <toshi.kani@hpe.com>
Cc: Chen Yucong <slaoub@gmail.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   58 ------------------------------------------
 1 file changed, 58 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-drop-artificial-restriction-on-online-offline mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-artificial-restriction-on-online-offline
+++ a/mm/memory_hotplug.c
@@ -763,23 +763,6 @@ static int online_pages_range(unsigned l
 	return 0;
 }
 
-#ifdef CONFIG_MOVABLE_NODE
-/*
- * When CONFIG_MOVABLE_NODE, we permit onlining of a node which doesn't have
- * normal memory.
- */
-static bool can_online_high_movable(int nid)
-{
-	return true;
-}
-#else /* CONFIG_MOVABLE_NODE */
-/* ensure every online node has NORMAL memory */
-static bool can_online_high_movable(int nid)
-{
-	return node_state(nid, N_NORMAL_MEMORY);
-}
-#endif /* CONFIG_MOVABLE_NODE */
-
 /* check which state of node_states will be changed when online memory */
 static void node_states_check_changes_online(unsigned long nr_pages,
 	struct zone *zone, struct memory_notify *arg)
@@ -979,9 +962,6 @@ int __ref online_pages(unsigned long pfn
 	if (!allow_online_pfn_range(nid, pfn, nr_pages, online_type))
 		return -EINVAL;
 
-	if (online_type == MMOP_ONLINE_MOVABLE && !can_online_high_movable(nid))
-		return -EINVAL;
-
 	/* associate pfn range with the zone */
 	zone = move_pfn_range(online_type, nid, pfn, nr_pages);
 
@@ -1577,41 +1557,6 @@ check_pages_isolated(unsigned long start
 	return offlined;
 }
 
-#ifdef CONFIG_MOVABLE_NODE
-/*
- * When CONFIG_MOVABLE_NODE, we permit offlining of a node which doesn't have
- * normal memory.
- */
-static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
-{
-	return true;
-}
-#else /* CONFIG_MOVABLE_NODE */
-/* ensure the node has NORMAL memory if it is still online */
-static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
-{
-	struct pglist_data *pgdat = zone->zone_pgdat;
-	unsigned long present_pages = 0;
-	enum zone_type zt;
-
-	for (zt = 0; zt <= ZONE_NORMAL; zt++)
-		present_pages += pgdat->node_zones[zt].present_pages;
-
-	if (present_pages > nr_pages)
-		return true;
-
-	present_pages = 0;
-	for (; zt <= ZONE_MOVABLE; zt++)
-		present_pages += pgdat->node_zones[zt].present_pages;
-
-	/*
-	 * we can't offline the last normal memory until all
-	 * higher memory is offlined.
-	 */
-	return present_pages == 0;
-}
-#endif /* CONFIG_MOVABLE_NODE */
-
 static int __init cmdline_parse_movable_node(char *p)
 {
 #ifdef CONFIG_MOVABLE_NODE
@@ -1739,9 +1684,6 @@ static int __ref __offline_pages(unsigne
 	node = zone_to_nid(zone);
 	nr_pages = end_pfn - start_pfn;
 
-	if (zone_idx(zone) <= ZONE_NORMAL && !can_offline_normal(zone, nr_pages))
-		return -EINVAL;
-
 	/* set above range as isolated */
 	ret = start_isolate_page_range(start_pfn, end_pfn,
 				       MIGRATE_MOVABLE, true);
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-gfph-fix-___gfp_nolockdep-value.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch
mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
mm-memory_hotplug-get-rid-of-is_zone_device_section.patch
mm-memory_hotplug-split-up-register_one_node.patch
mm-memory_hotplug-consider-offline-memblocks-removable.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix.patch
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-adaptive-hash-table-scaling-fix.patch
mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch
mm-memory_hotplug-drop-config_movable_node.patch
mm-memory_hotplug-move-movable_node-to-the-hotplug-proper.patch

