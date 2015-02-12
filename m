From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 11:37:39 -0800
Message-ID: <54dd0103.t0Nz3GkDz6ouiZuw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbBLThk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: change tracepoint format from decimal to hexadecimal
has been removed from the -mm tree.  Its filename was
     mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: change tracepoint format from decimal to hexadecimal

To check the range that compaction is working, tracepoint print start/end
pfn of zone and start pfn of both scanner with decimal format.  Since we
manage all pages in order of 2 and it is well represented by hexadecimal,
this patch change the tracepoint format from decimal to hexadecimal.  This
would improve readability.  For example, it makes us easily notice whether
current scanner try to compact previously attempted pageblock or not.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/trace/events/compaction.h~mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal
+++ a/include/trace/events/compaction.h
@@ -104,7 +104,7 @@ TRACE_EVENT(mm_compaction_begin,
 		__entry->zone_end = zone_end;
 	),
 
-	TP_printk("zone_start=%lu migrate_start=%lu free_start=%lu zone_end=%lu",
+	TP_printk("zone_start=0x%lx migrate_start=0x%lx free_start=0x%lx zone_end=0x%lx",
 		__entry->zone_start,
 		__entry->migrate_start,
 		__entry->free_start,
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

