From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 11:37:41 -0800
Message-ID: <54dd0105.5N4/Tq90471FfUPP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbBLThm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dan.carpenter@oracle.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: enhance tracepoint output for compaction begin/end
has been removed from the -mm tree.  Its filename was
     mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: enhance tracepoint output for compaction begin/end

We now have tracepoint for begin event of compaction and it prints start
position of both scanners, but, tracepoint for end event of compaction
doesn't print finish position of both scanners.  It'd be also useful to
know finish position of both scanners so this patch add it.  It will help
to find odd behavior or problem on compaction internal logic.

And mode is added to both begin/end tracepoint output, since according to
mode, compaction behavior is quite different.

And lastly, status format is changed to string rather than status number
for readability.

[akpm@linux-foundation.org: fix sparse warning]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h        |    1 
 include/trace/events/compaction.h |   49 ++++++++++++++++++++--------
 mm/compaction.c                   |   15 +++++++-
 3 files changed, 49 insertions(+), 16 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end
+++ a/include/linux/compaction.h
@@ -12,6 +12,7 @@
 #define COMPACT_PARTIAL		3
 /* The full zone was compacted */
 #define COMPACT_COMPLETE	4
+/* When adding new state, please change compaction_status_string, too */
 
 /* Used to signal whether compaction detected need_sched() or lock contention */
 /* No contention detected */
diff -puN include/trace/events/compaction.h~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end
+++ a/include/trace/events/compaction.h
@@ -85,46 +85,67 @@ TRACE_EVENT(mm_compaction_migratepages,
 );
 
 TRACE_EVENT(mm_compaction_begin,
-	TP_PROTO(unsigned long zone_start, unsigned long migrate_start,
-		unsigned long free_start, unsigned long zone_end),
+	TP_PROTO(unsigned long zone_start, unsigned long migrate_pfn,
+		unsigned long free_pfn, unsigned long zone_end, bool sync),
 
-	TP_ARGS(zone_start, migrate_start, free_start, zone_end),
+	TP_ARGS(zone_start, migrate_pfn, free_pfn, zone_end, sync),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, zone_start)
-		__field(unsigned long, migrate_start)
-		__field(unsigned long, free_start)
+		__field(unsigned long, migrate_pfn)
+		__field(unsigned long, free_pfn)
 		__field(unsigned long, zone_end)
+		__field(bool, sync)
 	),
 
 	TP_fast_assign(
 		__entry->zone_start = zone_start;
-		__entry->migrate_start = migrate_start;
-		__entry->free_start = free_start;
+		__entry->migrate_pfn = migrate_pfn;
+		__entry->free_pfn = free_pfn;
 		__entry->zone_end = zone_end;
+		__entry->sync = sync;
 	),
 
-	TP_printk("zone_start=0x%lx migrate_start=0x%lx free_start=0x%lx zone_end=0x%lx",
+	TP_printk("zone_start=0x%lx migrate_pfn=0x%lx free_pfn=0x%lx zone_end=0x%lx, mode=%s",
 		__entry->zone_start,
-		__entry->migrate_start,
-		__entry->free_start,
-		__entry->zone_end)
+		__entry->migrate_pfn,
+		__entry->free_pfn,
+		__entry->zone_end,
+		__entry->sync ? "sync" : "async")
 );
 
 TRACE_EVENT(mm_compaction_end,
-	TP_PROTO(int status),
+	TP_PROTO(unsigned long zone_start, unsigned long migrate_pfn,
+		unsigned long free_pfn, unsigned long zone_end, bool sync,
+		int status),
 
-	TP_ARGS(status),
+	TP_ARGS(zone_start, migrate_pfn, free_pfn, zone_end, sync, status),
 
 	TP_STRUCT__entry(
+		__field(unsigned long, zone_start)
+		__field(unsigned long, migrate_pfn)
+		__field(unsigned long, free_pfn)
+		__field(unsigned long, zone_end)
+		__field(bool, sync)
 		__field(int, status)
 	),
 
 	TP_fast_assign(
+		__entry->zone_start = zone_start;
+		__entry->migrate_pfn = migrate_pfn;
+		__entry->free_pfn = free_pfn;
+		__entry->zone_end = zone_end;
+		__entry->sync = sync;
 		__entry->status = status;
 	),
 
-	TP_printk("status=%d", __entry->status)
+	TP_printk("zone_start=0x%lx migrate_pfn=0x%lx free_pfn=0x%lx zone_end=0x%lx, mode=%s status=%s",
+		__entry->zone_start,
+		__entry->migrate_pfn,
+		__entry->free_pfn,
+		__entry->zone_end,
+		__entry->sync ? "sync" : "async",
+		compaction_status_string[__entry->status])
 );
 
 #endif /* _TRACE_COMPACTION_H */
diff -puN mm/compaction.c~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end mm/compaction.c
--- a/mm/compaction.c~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end
+++ a/mm/compaction.c
@@ -34,6 +34,15 @@ static inline void count_compact_events(
 #endif
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
+#ifdef CONFIG_TRACEPOINTS
+static const char *const compaction_status_string[] = {
+	"deferred",
+	"skipped",
+	"continue",
+	"partial",
+	"complete",
+};
+#endif
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/compaction.h>
@@ -1197,7 +1206,8 @@ static int compact_zone(struct zone *zon
 		zone->compact_cached_migrate_pfn[1] = cc->migrate_pfn;
 	}
 
-	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn, cc->free_pfn, end_pfn);
+	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn,
+				cc->free_pfn, end_pfn, sync);
 
 	migrate_prep_local();
 
@@ -1299,7 +1309,8 @@ out:
 			zone->compact_cached_free_pfn = free_pfn;
 	}
 
-	trace_mm_compaction_end(ret);
+	trace_mm_compaction_end(start_pfn, cc->migrate_pfn,
+				cc->free_pfn, end_pfn, sync, ret);
 
 	return ret;
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
slub-never-fail-to-shrink-cache.patch
slub-never-fail-to-shrink-cache-init-discard-list-after-freeing-slabs.patch
slub-fix-kmem_cache_shrink-return-value.patch
slub-make-dead-caches-discard-free-slabs-immediately.patch
mm-compaction-fix-wrong-order-check-in-compact_finished.patch
mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage.patch
mm-internalh-dont-split-printk-call-in-two.patch
mm-page_allocc-pull-out-init-code-from-build_all_zonelists.patch
mm-mm_initc-mark-mminit_verify_zonelist-as-__init.patch
mm-mm_initc-mark-mminit_loglevel-__meminitdata.patch
kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init.patch
mm-fix-negative-nr_isolated-counts.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch
compiler-introduce-__aliassymbol-shortcut.patch
add-kernel-address-sanitizer-infrastructure.patch
kasan-disable-memory-hotplug.patch
x86_64-add-kasan-support.patch
mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch
mm-slub-introduce-virt_to_obj-function.patch
mm-slub-share-object_err-function.patch
mm-slub-introduce-metadata_access_enable-metadata_access_disable.patch
mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator.patch
fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch
kmemleak-disable-kasan-instrumentation-for-kmemleak.patch
lib-add-kasan-test-module.patch
x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions.patch
kasan-enable-stack-instrumentation.patch
mm-vmalloc-add-flag-preventing-guard-hole-allocation.patch
mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch
kernel-add-support-for-init_array-constructors.patch
module-fix-types-of-device-tables-aliases.patch
kasan-enable-instrumentation-of-global-variables.patch

