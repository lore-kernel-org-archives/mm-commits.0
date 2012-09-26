From: akpm@linux-foundation.org
Subject: + mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix-fix.patch added to -mm tree
Date: Wed, 26 Sep 2012 14:37:59 -0700
Message-ID: <20120926213759.C1291100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:49375 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2IZViB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 17:38:01 -0400
Received: by qcqs25 with SMTP id s25so131821qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 14:38:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org


The patch titled
     Subject: mm, numa: reclaim from all nodes within reclaim distance fix fix
has been added to the -mm tree.  Its filename is
     mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, numa: reclaim from all nodes within reclaim distance fix fix

It's cleaner if the iteration is explicitly done only for NUMA kernels.
No functional change.

Intended to be folded into
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch already in
-mm.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN mm/page_alloc.c~mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix-fix
+++ a/mm/page_alloc.c
@@ -1803,6 +1803,17 @@ static bool zone_allows_reclaim(struct z
 	return node_isset(local_zone->node, zone->zone_pgdat->reclaim_nodes);
 }
 
+static void __paginginit init_zone_allows_reclaim(int nid)
+{
+	int i;
+
+	for_each_online_node(i)
+		if (node_distance(nid, i) <= RECLAIM_DISTANCE) {
+			node_set(i, NODE_DATA(nid)->reclaim_nodes);
+			zone_reclaim_mode = 1;
+		}
+}
+
 #else	/* CONFIG_NUMA */
 
 static nodemask_t *zlc_setup(struct zonelist *zonelist, int alloc_flags)
@@ -1828,6 +1839,10 @@ static bool zone_allows_reclaim(struct z
 {
 	return true;
 }
+
+static inline void init_zone_allows_reclaim(int nid)
+{
+}
 #endif	/* CONFIG_NUMA */
 
 /*
@@ -4547,20 +4562,13 @@ void __paginginit free_area_init_node(in
 		unsigned long node_start_pfn, unsigned long *zholes_size)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
-	int i;
 
 	/* pg_data_t should be reset to zero when it's allocated */
 	WARN_ON(pgdat->nr_zones || pgdat->classzone_idx);
 
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
-	for_each_online_node(i)
-		if (node_distance(nid, i) <= RECLAIM_DISTANCE) {
-			node_set(i, pgdat->reclaim_nodes);
-#ifdef CONFIG_NUMA
-			zone_reclaim_mode = 1;
-#endif
-		}
+	init_zone_allows_reclaim(nid);
 	calculate_node_totalpages(pgdat, zones_size, zholes_size);
 
 	alloc_node_mem_map(pgdat);
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix.patch
oom-remove-deprecated-oom_adj.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch
thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch
mm-fix-up-zone-present-pages.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix-fix.patch
hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch
ksm-numa-awareness-sysfs-knob.patch
kpageflags-fix-wrong-kpf_thp-on-non-huge-compound-pages.patch

