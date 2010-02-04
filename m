From: akpm@linux-foundation.org
Subject: [withdrawn] mm-add-lowmem-detection-logic.patch removed from -mm tree
Date: Wed, 03 Feb 2010 16:17:15 -0800
Message-ID: <201002040017.o140HFC7028485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757990Ab0BDARY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 19:17:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org, lee.schermerhorn@hp.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: add lowmem detection logic
has been removed from the -mm tree.  Its filename was
     mm-add-lowmem-detection-logic.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add lowmem detection logic
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

The final purpose of this patch is to improve oom/memoy shortage
detection.  In general there are OOM cases that lowmem is exhausted.  What
this lowmem means is determined by the situation, but in general, limited
amount of memory for some special use is lowmem.

This patch adds an integer lowmem_zone, which is initialized to -1.  If
zone_idx(zone) <= lowmem_zone, the zone is lowmem.

This patch uses simple definition that the zone for special use is the
lowmem.  Not taking the amount of memory into account.

For example,
  - if HIGHMEM is used, NORMAL is lowmem.
  - If the system has both of NORMAL and DMA32, DMA32 is lowmem.
  - When the system consists of only one zone, there are no lowmem.

This will be used for lowmem accounting per mm_struct and its information
will be used for oom-killer.

 Q: Why you don't use policy_zone ?
 A: It's for NUMA only. I want to use unified approach for detecting lowmem.
    And policy_zone sounds like "for mempolicy"..

Concerns or TODO:
 - Now, we have polizy_zone if CONFIG_NUMA=y. Maybe we can make it as
   #define policy_zone  (lowmem_zone + 1)
   or remove it. But this itself should be done in other patch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 ++++++
 mm/page_alloc.c    |   62 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff -puN include/linux/mm.h~mm-add-lowmem-detection-logic include/linux/mm.h
--- a/include/linux/mm.h~mm-add-lowmem-detection-logic
+++ a/include/linux/mm.h
@@ -583,6 +583,15 @@ static inline void set_page_links(struct
 }
 
 /*
+ * Check a page is in lower zone
+ */
+extern int lowmem_zone;
+static inline bool is_lowmem_page(struct page *page)
+{
+	return page_zonenum(page) <= lowmem_zone;
+}
+
+/*
  * Some inline functions in vmstat.h depend on page_zone()
  */
 #include <linux/vmstat.h>
diff -puN mm/page_alloc.c~mm-add-lowmem-detection-logic mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-lowmem-detection-logic
+++ a/mm/page_alloc.c
@@ -2302,6 +2302,59 @@ static void zoneref_set_zone(struct zone
 	zoneref->zone_idx = zone_idx(zone);
 }
 
+/* the zone is lowmem if zone_idx(zone) <= lowmem_zone */
+int lowmem_zone __read_mostly;
+/*
+ * Find out LOWMEM zone on this host. LOWMEM means a zone for special use
+ * and its size seems small and precious than other zones. For example,
+ * NORMAL zone is considered to be LOWMEM on a host which has HIGHMEM.
+ *
+ * This lowmem zone is determined by zone ordering and equipped memory layout.
+ * The amount of memory is not taken into account now.
+ */
+static void find_lowmem_zone(void)
+{
+	unsigned long pages[MAX_NR_ZONES];
+	struct zone *zone;
+	int idx;
+
+	for (idx = 0; idx < MAX_NR_ZONES; idx++)
+		pages[idx] = 0;
+	/* count the number of pages */
+	for_each_populated_zone(zone) {
+		idx = zone_idx(zone);
+		pages[idx] += zone->present_pages;
+	}
+	/* If We have HIGHMEM...we ignore ZONE_MOVABLE in this case. */
+#ifdef CONFIG_HIGHMEM
+	if (pages[ZONE_HIGHMEM]) {
+		lowmem_zone = ZONE_NORMAL;
+		return;
+	}
+#endif
+	/* If We have MOVABLE zone...which works like HIGHMEM. */
+	if (pages[ZONE_MOVABLE]) {
+		lowmem_zone = ZONE_NORMAL;
+		return;
+	}
+#ifdef CONFIG_ZONE_DMA32
+	/* If we have DMA32 and there is ZONE_NORMAL...*/
+	if (pages[ZONE_DMA32] && pages[ZONE_NORMAL]) {
+		lowmem_zone = ZONE_DMA32;
+		return;
+	}
+#endif
+#ifdef CONFIG_ZONE_DMA
+	/* If we have DMA and there is ZONE_NORMAL...*/
+	if (pages[ZONE_DMA] && pages[ZONE_NORMAL]) {
+		lowmem_zone = ZONE_DMA;
+		return;
+	}
+#endif
+	lowmem_zone = -1;
+	return;
+}
+
 /*
  * Builds allocation fallback zone lists.
  *
@@ -2820,12 +2873,21 @@ void build_all_zonelists(void)
 	else
 		page_group_by_mobility_disabled = 0;
 
+	find_lowmem_zone();
+
 	printk("Built %i zonelists in %s order, mobility grouping %s.  "
 		"Total pages: %ld\n",
 			nr_online_nodes,
 			zonelist_order_name[current_zonelist_order],
 			page_group_by_mobility_disabled ? "off" : "on",
 			vm_total_pages);
+
+	if (lowmem_zone >= 0)
+		printk("LOWMEM zone is detected as %s\n",
+			zone_names[lowmem_zone]);
+	else
+		printk("There are no special LOWMEM. The system seems flat\n");
+
 #ifdef CONFIG_NUMA
 	printk("Policy zone: %s\n", zone_names[policy_zone]);
 #endif
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-clean-up-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic.patch
mm-add-lowmem-detection-logic-fix.patch
vmscan-get_scan_ratio-cleanup.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
nodemaskh-remove-macro-any_online_node.patch
resources-introduce-generic-page_is_ram.patch
x86-remove-bios-data-range-from-e820.patch
x86-use-the-generic-page_is_ram.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
sysctl-clean-up-vm-related-variable-declarations.patch

