From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:37:19 -0700
Message-ID: <20170907183719.Sw4akoXdJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55206 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755805AbdIGShU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:37:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, arbab@linux.vnet.ibm.com, daniel.kiper@oracle.com, iamjoonsoo.kim@lge.com, imammedo@redhat.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, richard.weiyang@gmail.com, slaoub@gmail.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com


The patch titled
     Subject: mm, memory_hotplug: display allowed zones in the preferred ordering
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: display allowed zones in the preferred ordering

Prior to "mm, memory_hotplug: do not associate hotadded memory to zones
until online" we used to allow to change the valid zone types of a memory
block if it is adjacent to a different zone type.  This fact was reflected
in memoryNN/valid_zones by the ordering of printed zones.  The first one
was default (echo online > memoryNN/state) and the other one could be
onlined explicitly by online_{movable,kernel}.  This behavior was removed
by the said patch and as such the ordering was not all that important.  In
most cases a kernel zone would be default anyway.  The only exception is
movable_node handled by "mm, memory_hotplug: support movable_node for
hotpluggable nodes".

Let's reintroduce this behavior again because later patch will remove the
zone overlap restriction and so user will be allowed to online kernel
resp.  movable block regardless of its placement.  Original behavior will
then become significant again because it would be non-trivial for users to
see what is the default zone to online into.

Implementation is really simple.  Pull out zone selection out of
move_pfn_range into zone_for_pfn_range helper and use it in
show_valid_zones to display the zone for default onlining and then both
kernel and movable if they are allowed.  Default online zone is not
duplicated.

Link: http://lkml.kernel.org/r/20170714121233.16861-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Kani Toshimitsu <toshi.kani@hpe.com>
Cc: <slaoub@gmail.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   33 +++++++++-----
 include/linux/memory_hotplug.h |    2 
 mm/memory_hotplug.c            |   73 +++++++++++++++++--------------
 3 files changed, 65 insertions(+), 43 deletions(-)

diff -puN drivers/base/memory.c~mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering drivers/base/memory.c
--- a/drivers/base/memory.c~mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering
+++ a/drivers/base/memory.c
@@ -388,6 +388,22 @@ static ssize_t show_phys_device(struct d
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+static void print_allowed_zone(char *buf, int nid, unsigned long start_pfn,
+		unsigned long nr_pages, int online_type,
+		struct zone *default_zone)
+{
+	struct zone *zone;
+
+	if (!allow_online_pfn_range(nid, start_pfn, nr_pages, online_type))
+		return;
+
+	zone = zone_for_pfn_range(online_type, nid, start_pfn, nr_pages);
+	if (zone != default_zone) {
+		strcat(buf, " ");
+		strcat(buf, zone->name);
+	}
+}
+
 static ssize_t show_valid_zones(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -395,7 +411,7 @@ static ssize_t show_valid_zones(struct d
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	unsigned long valid_start_pfn, valid_end_pfn;
-	bool append = false;
+	struct zone *default_zone;
 	int nid;
 
 	/*
@@ -418,16 +434,13 @@ static ssize_t show_valid_zones(struct d
 	}
 
 	nid = pfn_to_nid(start_pfn);
-	if (allow_online_pfn_range(nid, start_pfn, nr_pages, MMOP_ONLINE_KERNEL)) {
-		strcat(buf, default_zone_for_pfn(nid, start_pfn, nr_pages)->name);
-		append = true;
-	}
+	default_zone = zone_for_pfn_range(MMOP_ONLINE_KEEP, nid, start_pfn, nr_pages);
+	strcat(buf, default_zone->name);
 
-	if (allow_online_pfn_range(nid, start_pfn, nr_pages, MMOP_ONLINE_MOVABLE)) {
-		if (append)
-			strcat(buf, " ");
-		strcat(buf, NODE_DATA(nid)->node_zones[ZONE_MOVABLE].name);
-	}
+	print_allowed_zone(buf, nid, start_pfn, nr_pages, MMOP_ONLINE_KERNEL,
+			default_zone);
+	print_allowed_zone(buf, nid, start_pfn, nr_pages, MMOP_ONLINE_MOVABLE,
+			default_zone);
 out:
 	strcat(buf, "\n");
 
diff -puN include/linux/memory_hotplug.h~mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering
+++ a/include/linux/memory_hotplug.h
@@ -319,6 +319,6 @@ extern struct page *sparse_decode_mem_ma
 					  unsigned long pnum);
 extern bool allow_online_pfn_range(int nid, unsigned long pfn, unsigned long nr_pages,
 		int online_type);
-extern struct zone *default_zone_for_pfn(int nid, unsigned long pfn,
+extern struct zone *zone_for_pfn_range(int online_type, int nid, unsigned start_pfn,
 		unsigned long nr_pages);
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering
+++ a/mm/memory_hotplug.c
@@ -773,31 +773,6 @@ static void node_states_set_node(int nod
 	node_set_state(node, N_MEMORY);
 }
 
-bool allow_online_pfn_range(int nid, unsigned long pfn, unsigned long nr_pages, int online_type)
-{
-	struct pglist_data *pgdat = NODE_DATA(nid);
-	struct zone *movable_zone = &pgdat->node_zones[ZONE_MOVABLE];
-	struct zone *default_zone = default_zone_for_pfn(nid, pfn, nr_pages);
-
-	/*
-	 * TODO there shouldn't be any inherent reason to have ZONE_NORMAL
-	 * physically before ZONE_MOVABLE. All we need is they do not
-	 * overlap. Historically we didn't allow ZONE_NORMAL after ZONE_MOVABLE
-	 * though so let's stick with it for simplicity for now.
-	 * TODO make sure we do not overlap with ZONE_DEVICE
-	 */
-	if (online_type == MMOP_ONLINE_KERNEL) {
-		if (zone_is_empty(movable_zone))
-			return true;
-		return movable_zone->zone_start_pfn >= pfn + nr_pages;
-	} else if (online_type == MMOP_ONLINE_MOVABLE) {
-		return zone_end_pfn(default_zone) <= pfn;
-	}
-
-	/* MMOP_ONLINE_KEEP will always succeed and inherits the current zone */
-	return online_type == MMOP_ONLINE_KEEP;
-}
-
 static void __meminit resize_zone_range(struct zone *zone, unsigned long start_pfn,
 		unsigned long nr_pages)
 {
@@ -856,7 +831,7 @@ void __ref move_pfn_range_to_zone(struct
  * If no kernel zone covers this pfn range it will automatically go
  * to the ZONE_NORMAL.
  */
-struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn,
+static struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn,
 		unsigned long nr_pages)
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
@@ -872,6 +847,31 @@ struct zone *default_zone_for_pfn(int ni
 	return &pgdat->node_zones[ZONE_NORMAL];
 }
 
+bool allow_online_pfn_range(int nid, unsigned long pfn, unsigned long nr_pages, int online_type)
+{
+	struct pglist_data *pgdat = NODE_DATA(nid);
+	struct zone *movable_zone = &pgdat->node_zones[ZONE_MOVABLE];
+	struct zone *default_zone = default_zone_for_pfn(nid, pfn, nr_pages);
+
+	/*
+	 * TODO there shouldn't be any inherent reason to have ZONE_NORMAL
+	 * physically before ZONE_MOVABLE. All we need is they do not
+	 * overlap. Historically we didn't allow ZONE_NORMAL after ZONE_MOVABLE
+	 * though so let's stick with it for simplicity for now.
+	 * TODO make sure we do not overlap with ZONE_DEVICE
+	 */
+	if (online_type == MMOP_ONLINE_KERNEL) {
+		if (zone_is_empty(movable_zone))
+			return true;
+		return movable_zone->zone_start_pfn >= pfn + nr_pages;
+	} else if (online_type == MMOP_ONLINE_MOVABLE) {
+		return zone_end_pfn(default_zone) <= pfn;
+	}
+
+	/* MMOP_ONLINE_KEEP will always succeed and inherits the current zone */
+	return online_type == MMOP_ONLINE_KEEP;
+}
+
 static inline bool movable_pfn_range(int nid, struct zone *default_zone,
 		unsigned long start_pfn, unsigned long nr_pages)
 {
@@ -885,12 +885,8 @@ static inline bool movable_pfn_range(int
 	return !zone_intersects(default_zone, start_pfn, nr_pages);
 }
 
-/*
- * Associates the given pfn range with the given node and the zone appropriate
- * for the given online type.
- */
-static struct zone * __meminit move_pfn_range(int online_type, int nid,
-		unsigned long start_pfn, unsigned long nr_pages)
+struct zone * zone_for_pfn_range(int online_type, int nid, unsigned start_pfn,
+		unsigned long nr_pages)
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
 	struct zone *zone = default_zone_for_pfn(nid, start_pfn, nr_pages);
@@ -909,6 +905,19 @@ static struct zone * __meminit move_pfn_
 		zone = &pgdat->node_zones[ZONE_MOVABLE];
 	}
 
+	return zone;
+}
+
+/*
+ * Associates the given pfn range with the given node and the zone appropriate
+ * for the given online type.
+ */
+static struct zone * __meminit move_pfn_range(int online_type, int nid,
+		unsigned long start_pfn, unsigned long nr_pages)
+{
+	struct zone *zone;
+
+	zone = zone_for_pfn_range(online_type, nid, start_pfn, nr_pages);
 	move_pfn_range_to_zone(zone, start_pfn, nr_pages);
 	return zone;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-memory_hotplug-introduce-add_pages.patch
mm-sparse-fix-typo-in-online_mem_sections.patch
fs-proc-remove-priv-argument-from-is_stack.patch
treewide-remove-gfp_temporary-allocation-flag.patch

