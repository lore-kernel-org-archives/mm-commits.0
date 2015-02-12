From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch removed from -mm tree
Date: Thu, 12 Feb 2015 11:37:45 -0800
Message-ID: <54dd0109.luPUHAm3q0WbxD5U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbbBLThq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: more trace to understand when/why compaction start/finish
has been removed from the -mm tree.  Its filename was
     mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: more trace to understand when/why compaction start/finish

It is not well analyzed that when/why compaction start/finish or not. 
With these new tracepoints, we can know much more about start/finish
reason of compaction.  I can find following bug with these tracepoint.

http://www.spinics.net/lists/linux-mm/msg81582.html

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h        |    3 +
 include/trace/events/compaction.h |   74 ++++++++++++++++++++++++++++
 mm/compaction.c                   |   38 ++++++++++++--
 3 files changed, 111 insertions(+), 4 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-more-trace-to-understand-when-why-compaction-start-finish include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-more-trace-to-understand-when-why-compaction-start-finish
+++ a/include/linux/compaction.h
@@ -12,6 +12,9 @@
 #define COMPACT_PARTIAL		3
 /* The full zone was compacted */
 #define COMPACT_COMPLETE	4
+/* For more detailed tracepoint output */
+#define COMPACT_NO_SUITABLE_PAGE	5
+#define COMPACT_NOT_SUITABLE_ZONE	6
 /* When adding new state, please change compaction_status_string, too */
 
 /* Used to signal whether compaction detected need_sched() or lock contention */
diff -puN include/trace/events/compaction.h~mm-compaction-more-trace-to-understand-when-why-compaction-start-finish include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-more-trace-to-understand-when-why-compaction-start-finish
+++ a/include/trace/events/compaction.h
@@ -164,6 +164,80 @@ TRACE_EVENT(mm_compaction_end,
 		compaction_status_string[__entry->status])
 );
 
+TRACE_EVENT(mm_compaction_try_to_compact_pages,
+
+	TP_PROTO(
+		int order,
+		gfp_t gfp_mask,
+		enum migrate_mode mode),
+
+	TP_ARGS(order, gfp_mask, mode),
+
+	TP_STRUCT__entry(
+		__field(int, order)
+		__field(gfp_t, gfp_mask)
+		__field(enum migrate_mode, mode)
+	),
+
+	TP_fast_assign(
+		__entry->order = order;
+		__entry->gfp_mask = gfp_mask;
+		__entry->mode = mode;
+	),
+
+	TP_printk("order=%d gfp_mask=0x%x mode=%d",
+		__entry->order,
+		__entry->gfp_mask,
+		(int)__entry->mode)
+);
+
+DECLARE_EVENT_CLASS(mm_compaction_suitable_template,
+
+	TP_PROTO(struct zone *zone,
+		int order,
+		int ret),
+
+	TP_ARGS(zone, order, ret),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(char *, name)
+		__field(int, order)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		__entry->nid = zone_to_nid(zone);
+		__entry->name = (char *)zone->name;
+		__entry->order = order;
+		__entry->ret = ret;
+	),
+
+	TP_printk("node=%d zone=%-8s order=%d ret=%s",
+		__entry->nid,
+		__entry->name,
+		__entry->order,
+		compaction_status_string[__entry->ret])
+);
+
+DEFINE_EVENT(mm_compaction_suitable_template, mm_compaction_finished,
+
+	TP_PROTO(struct zone *zone,
+		int order,
+		int ret),
+
+	TP_ARGS(zone, order, ret)
+);
+
+DEFINE_EVENT(mm_compaction_suitable_template, mm_compaction_suitable,
+
+	TP_PROTO(struct zone *zone,
+		int order,
+		int ret),
+
+	TP_ARGS(zone, order, ret)
+);
+
 #endif /* _TRACE_COMPACTION_H */
 
 /* This part must be outside protection */
diff -puN mm/compaction.c~mm-compaction-more-trace-to-understand-when-why-compaction-start-finish mm/compaction.c
--- a/mm/compaction.c~mm-compaction-more-trace-to-understand-when-why-compaction-start-finish
+++ a/mm/compaction.c
@@ -41,6 +41,8 @@ static const char *const compaction_stat
 	"continue",
 	"partial",
 	"complete",
+	"no_suitable_page",
+	"not_suitable_zone",
 };
 #endif
 
@@ -1049,7 +1051,7 @@ static isolate_migrate_t isolate_migrate
 	return cc->nr_migratepages ? ISOLATE_SUCCESS : ISOLATE_NONE;
 }
 
-static int compact_finished(struct zone *zone, struct compact_control *cc,
+static int __compact_finished(struct zone *zone, struct compact_control *cc,
 			    const int migratetype)
 {
 	unsigned int order;
@@ -1104,7 +1106,20 @@ static int compact_finished(struct zone
 			return COMPACT_PARTIAL;
 	}
 
-	return COMPACT_CONTINUE;
+	return COMPACT_NO_SUITABLE_PAGE;
+}
+
+static int compact_finished(struct zone *zone, struct compact_control *cc,
+			    const int migratetype)
+{
+	int ret;
+
+	ret = __compact_finished(zone, cc, migratetype);
+	trace_mm_compaction_finished(zone, cc->order, ret);
+	if (ret == COMPACT_NO_SUITABLE_PAGE)
+		ret = COMPACT_CONTINUE;
+
+	return ret;
 }
 
 /*
@@ -1114,7 +1129,7 @@ static int compact_finished(struct zone
  *   COMPACT_PARTIAL  - If the allocation would succeed without compaction
  *   COMPACT_CONTINUE - If compaction should run now
  */
-unsigned long compaction_suitable(struct zone *zone, int order,
+static unsigned long __compaction_suitable(struct zone *zone, int order,
 					int alloc_flags, int classzone_idx)
 {
 	int fragindex;
@@ -1158,11 +1173,24 @@ unsigned long compaction_suitable(struct
 	 */
 	fragindex = fragmentation_index(zone, order);
 	if (fragindex >= 0 && fragindex <= sysctl_extfrag_threshold)
-		return COMPACT_SKIPPED;
+		return COMPACT_NOT_SUITABLE_ZONE;
 
 	return COMPACT_CONTINUE;
 }
 
+unsigned long compaction_suitable(struct zone *zone, int order,
+					int alloc_flags, int classzone_idx)
+{
+	unsigned long ret;
+
+	ret = __compaction_suitable(zone, order, alloc_flags, classzone_idx);
+	trace_mm_compaction_suitable(zone, order, ret);
+	if (ret == COMPACT_NOT_SUITABLE_ZONE)
+		ret = COMPACT_SKIPPED;
+
+	return ret;
+}
+
 static int compact_zone(struct zone *zone, struct compact_control *cc)
 {
 	int ret;
@@ -1376,6 +1404,8 @@ unsigned long try_to_compact_pages(gfp_t
 	if (!order || !may_enter_fs || !may_perform_io)
 		return COMPACT_SKIPPED;
 
+	trace_mm_compaction_try_to_compact_pages(order, gfp_mask, mode);
+
 	/* Compact each zone in the list */
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
 								ac->nodemask) {
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

