From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone.patch
 added to -mm tree
Date: Thu, 01 Jun 2017 15:13:27 -0700
Message-ID: <59309187.Hf8/RH8E9xO/gxk/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdFAWN2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 18:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, arbab@linux.vnet.ibm.com, dan.j.williams@intel.com, heiko.carstens@de.ibm.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: do not assume ZONE_NORMAL is default kernel zone
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone.patch

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
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
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
@@ -1032,7 +1032,7 @@ bool allow_online_pfn_range(int nid, uns
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
 	struct zone *movable_zone = &pgdat->node_zones[ZONE_MOVABLE];
-	struct zone *normal_zone =  &pgdat->node_zones[ZONE_NORMAL];
+	struct zone *default_zone = default_zone_for_pfn(nid, pfn, nr_pages);
 
 	/*
 	 * TODO there shouldn't be any inherent reason to have ZONE_NORMAL
@@ -1046,7 +1046,7 @@ bool allow_online_pfn_range(int nid, uns
 			return true;
 		return movable_zone->zone_start_pfn >= pfn + nr_pages;
 	} else if (online_type == MMOP_ONLINE_MOVABLE) {
-		return zone_end_pfn(normal_zone) <= pfn;
+		return zone_end_pfn(default_zone) <= pfn;
 	}
 
 	/* MMOP_ONLINE_KEEP will always succeed and inherits the current zone */
@@ -1112,6 +1112,27 @@ void move_pfn_range_to_zone(struct zone
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
@@ -1119,7 +1140,7 @@ static struct zone * __meminit move_pfn_
 		unsigned long start_pfn, unsigned long nr_pages)
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
-	struct zone *zone = &pgdat->node_zones[ZONE_NORMAL];
+	struct zone *zone = default_zone_for_pfn(nid, start_pfn, nr_pages);
 
 	if (online_type == MMOP_ONLINE_KEEP) {
 		struct zone *movable_zone = &pgdat->node_zones[ZONE_MOVABLE];
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-gfph-fix-___gfp_nolockdep-value.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch
mm-consider-memblock-reservations-for-deferred-memory-initialization-sizing.patch
fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch
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
mm-memory_hotplug-fix-mmop_online_keep-behavior.patch
mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-adaptive-hash-table-scaling-fix.patch
mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch
mm-memory_hotplug-drop-config_movable_node.patch
mm-memory_hotplug-move-movable_node-to-the-hotplug-proper.patch
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch

