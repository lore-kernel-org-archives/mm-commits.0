From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone.patch
 removed from -mm tree
Date: Fri, 07 Jul 2017 12:09:24 -0700
Message-ID: <20170707190924.lc6B63uN0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33120 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752509AbdGGTJa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:09:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, dan.j.williams@intel.com, heiko.carstens@de.ibm.com, mhocko@suse.com, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm, memory_hotplug: do not assume ZONE_NORMAL is default kernel zone
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: do not assume ZONE_NORMAL is default kernel zone

Heiko Carstens has noticed that he can generate overlapping zones for
ZONE_DMA and ZONE_NORMAL:

DMA      [mem 0x0000000000000000-0x000000007fffffff]
Normal   [mem 0x0000000080000000-0x000000017fffffff]

$ cat /sys/devices/system/memory/block_size_bytes
10000000
$ cat /sys/devices/system/memory/memory5/valid_zones
DMA
$ echo 0 > /sys/devices/system/memory/memory5/online
$ cat /sys/devices/system/memory/memory5/valid_zones
Normal
$ echo 1 > /sys/devices/system/memory/memory5/online
Normal

$ cat /proc/zoneinfo
Node 0, zone      DMA
spanned  524288        <-----
present  458752
managed  455078
start_pfn:           0 <-----

Node 0, zone   Normal
spanned  720896
present  589824
managed  571648
start_pfn:           327680 <-----

The reason is that we assume that the default zone for kernel onlining is
ZONE_NORMAL.  This was a simplification introduced by the memory hotplug
rework and it is easily fixable by checking the range overlap in the zone
order and considering the first matching zone as the default one.  If
there is no such zone then assume ZONE_NORMAL as we have been doing so
far.

Fixes: "mm, memory_hotplug: do not associate hotadded memory to zones until online"
Link: http://lkml.kernel.org/r/20170601083746.4924-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |    2 +-
 include/linux/memory_hotplug.h |    2 ++
 mm/memory_hotplug.c            |   27 ++++++++++++++++++++++++---
 3 files changed, 27 insertions(+), 4 deletions(-)

diff -puN drivers/base/memory.c~mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone drivers/base/memory.c
--- a/drivers/base/memory.c~mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone
+++ a/drivers/base/memory.c
@@ -419,7 +419,7 @@ static ssize_t show_valid_zones(struct d
 
 	nid = pfn_to_nid(start_pfn);
 	if (allow_online_pfn_range(nid, start_pfn, nr_pages, MMOP_ONLINE_KERNEL)) {
-		strcat(buf, NODE_DATA(nid)->node_zones[ZONE_NORMAL].name);
+		strcat(buf, default_zone_for_pfn(nid, start_pfn, nr_pages)->name);
 		append = true;
 	}
 
diff -puN include/linux/memory_hotplug.h~mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone
+++ a/include/linux/memory_hotplug.h
@@ -311,4 +311,6 @@ extern struct page *sparse_decode_mem_ma
 					  unsigned long pnum);
 extern bool allow_online_pfn_range(int nid, unsigned long pfn, unsigned long nr_pages,
 		int online_type);
+extern struct zone *default_zone_for_pfn(int nid, unsigned long pfn,
+		unsigned long nr_pages);
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone
+++ a/mm/memory_hotplug.c
@@ -1028,7 +1028,7 @@ bool allow_online_pfn_range(int nid, uns
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
 	struct zone *movable_zone = &pgdat->node_zones[ZONE_MOVABLE];
-	struct zone *normal_zone =  &pgdat->node_zones[ZONE_NORMAL];
+	struct zone *default_zone = default_zone_for_pfn(nid, pfn, nr_pages);
 
 	/*
 	 * TODO there shouldn't be any inherent reason to have ZONE_NORMAL
@@ -1042,7 +1042,7 @@ bool allow_online_pfn_range(int nid, uns
 			return true;
 		return movable_zone->zone_start_pfn >= pfn + nr_pages;
 	} else if (online_type == MMOP_ONLINE_MOVABLE) {
-		return zone_end_pfn(normal_zone) <= pfn;
+		return zone_end_pfn(default_zone) <= pfn;
 	}
 
 	/* MMOP_ONLINE_KEEP will always succeed and inherits the current zone */
@@ -1103,6 +1103,27 @@ void move_pfn_range_to_zone(struct zone
 }
 
 /*
+ * Returns a default kernel memory zone for the given pfn range.
+ * If no kernel zone covers this pfn range it will automatically go
+ * to the ZONE_NORMAL.
+ */
+struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn,
+		unsigned long nr_pages)
+{
+	struct pglist_data *pgdat = NODE_DATA(nid);
+	int zid;
+
+	for (zid = 0; zid <= ZONE_NORMAL; zid++) {
+		struct zone *zone = &pgdat->node_zones[zid];
+
+		if (zone_intersects(zone, start_pfn, nr_pages))
+			return zone;
+	}
+
+	return &pgdat->node_zones[ZONE_NORMAL];
+}
+
+/*
  * Associates the given pfn range with the given node and the zone appropriate
  * for the given online type.
  */
@@ -1110,7 +1131,7 @@ static struct zone * __meminit move_pfn_
 		unsigned long start_pfn, unsigned long nr_pages)
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
-	struct zone *zone = &pgdat->node_zones[ZONE_NORMAL];
+	struct zone *zone = default_zone_for_pfn(nid, start_pfn, nr_pages);
 
 	if (online_type == MMOP_ONLINE_KEEP) {
 		struct zone *movable_zone = &pgdat->node_zones[ZONE_MOVABLE];
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

