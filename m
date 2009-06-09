From: akpm@linux-foundation.org
Subject: - mm-zone_reclaim-is-always-0-by-default.patch removed from -mm tree
Date: Tue, 09 Jun 2009 12:47:27 -0700
Message-ID: <200906091947.n59JlSvo031409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594AbZFITru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 15:47:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, benh@kernel.crashing.org, cl@linux-foundation.org, fengguang.wu@intel.com, holt@sgi.com, riel@redhat.com, tony.luck@intel.com, yanmin.zhang@intel.com


The patch titled
     mm: zone_reclaim is always 0 by default
has been removed from the -mm tree.  Its filename was
     mm-zone_reclaim-is-always-0-by-default.patch

This patch was dropped because it needs more thought

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: zone_reclaim is always 0 by default
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Current linux policy is, zone_reclaim_mode is enabled by default if the
machine has large remote node distance.  it's because we could assume that
large distance mean large server until recently.

Unfortunately, recent modern x86 CPU (e.g.  Core i7, Opeteron) have P2P
transport memory controller.  IOW it's seen as NUMA from software view. 
Some Core i7 machine has large remote node distance.

Yanmin reported zone_reclaim_mode=1 cause large apache regression.

    One Nehalem machine has 12GB memory,
    but there is always 2GB free although applications accesses lots of files.
    Eventually we located the root cause as zone_reclaim_mode=1.

Actually, zone_reclaim_mode=1 mean "I dislike remote node allocation
rather than disk access", it makes performance improvement to HPC
workload.  but it makes performance degression to desktop, file server and
web server.

In general, workload depended configration shouldn't put into default settings.

However, current code is long standing about two year.  Highest POWER and
IA64 HPC machine (only) use this setting.

Thus, x86 and almost rest architecture change default setting, but Only power and ia64
remain current configuration for backward-compatibility.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Robin Holt <holt@sgi.com>
Cc: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/topology.h |    6 ++++++
 include/linux/topology.h            |    7 +------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/include/asm/topology.h~mm-zone_reclaim-is-always-0-by-default arch/powerpc/include/asm/topology.h
--- a/arch/powerpc/include/asm/topology.h~mm-zone_reclaim-is-always-0-by-default
+++ a/arch/powerpc/include/asm/topology.h
@@ -10,6 +10,12 @@ struct device_node;
 
 #include <asm/mmzone.h>
 
+/*
+ * Distance above which we begin to use zone reclaim
+ */
+#define RECLAIM_DISTANCE 20
+
+
 static inline int cpu_to_node(int cpu)
 {
 	return numa_cpu_lookup_table[cpu];
diff -puN include/linux/topology.h~mm-zone_reclaim-is-always-0-by-default include/linux/topology.h
--- a/include/linux/topology.h~mm-zone_reclaim-is-always-0-by-default
+++ a/include/linux/topology.h
@@ -54,12 +54,7 @@ int arch_update_cpu_topology(void);
 #define node_distance(from,to)	((from) == (to) ? LOCAL_DISTANCE : REMOTE_DISTANCE)
 #endif
 #ifndef RECLAIM_DISTANCE
-/*
- * If the distance between nodes in a system is larger than RECLAIM_DISTANCE
- * (in whatever arch specific measurement units returned by node_distance())
- * then switch on zone reclaim on boot.
- */
-#define RECLAIM_DISTANCE 20
+#define RECLAIM_DISTANCE INT_MAX
 #endif
 #ifndef PENALTY_FOR_NODE_WITH_CPUS
 #define PENALTY_FOR_NODE_WITH_CPUS	(1)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
pagemap-document-clarifications.patch
pagemap-document-9-more-exported-page-flags.patch
pagemap-add-page-types-tool.patch
pagemap-add-page-types-tool-fix.patch
pagemap-export-pg_hwpoison.patch
pagemap-export-pg_hwpoison-fix.patch
vmscan-evict-use-once-pages-first-v3.patch
vmscan-cleanup-the-scan-batching-code.patch
vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
vmscan-drop-pf_swapwrite-from-zone_reclaim.patch
vmscan-zone_reclaim-use-may_swap.patch
migration-only-migrate_prep-once-per-move_pages.patch
vmscan-prevent-shrinking-of-active-anon-lru-list-in-case-of-no-swap-space-v3.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch
page-allocator-reset-wmark_min-and-inactive-ratio-of-zone-when-hotplug-happens.patch
mm-remove-config_unevictable_lru-config-option.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-zone_reclaim-is-always-0-by-default.patch
use-printk_once-in-several-places.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

