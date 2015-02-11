From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch
 removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:34 -0800
Message-ID: <54dbb9ce.IRYauTkq60THaE7n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbbBKUVf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: optimize alloc/free fastpath by removing preemption on/off
has been removed from the -mm tree.  Its filename was
     mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slub: optimize alloc/free fastpath by removing preemption on/off

We had to insert a preempt enable/disable in the fastpath a while ago in
order to guarantee that tid and kmem_cache_cpu are retrieved on the same
cpu.  It is the problem only for CONFIG_PREEMPT in which scheduler can
move the process to other cpu during retrieving data.

Now, I reach the solution to remove preempt enable/disable in the
fastpath.  If tid is matched with kmem_cache_cpu's tid after tid and
kmem_cache_cpu are retrieved by separate this_cpu operation, it means that
they are retrieved on the same cpu.  If not matched, we just have to retry
it.

With this guarantee, preemption enable/disable isn't need at all even if
CONFIG_PREEMPT, so this patch removes it.

I saw roughly 5% win in a fast-path loop over kmem_cache_alloc/free
in CONFIG_PREEMPT. (14.821 ns -> 14.049 ns)

Below is the result of Christoph's slab_test reported by
Jesper Dangaard Brouer.

* Before

 Single thread testing
 =====================
 1. Kmalloc: Repeatedly allocate then free test
 10000 times kmalloc(8) -> 49 cycles kfree -> 62 cycles
 10000 times kmalloc(16) -> 48 cycles kfree -> 64 cycles
 10000 times kmalloc(32) -> 53 cycles kfree -> 70 cycles
 10000 times kmalloc(64) -> 64 cycles kfree -> 77 cycles
 10000 times kmalloc(128) -> 74 cycles kfree -> 84 cycles
 10000 times kmalloc(256) -> 84 cycles kfree -> 114 cycles
 10000 times kmalloc(512) -> 83 cycles kfree -> 116 cycles
 10000 times kmalloc(1024) -> 81 cycles kfree -> 120 cycles
 10000 times kmalloc(2048) -> 104 cycles kfree -> 136 cycles
 10000 times kmalloc(4096) -> 142 cycles kfree -> 165 cycles
 10000 times kmalloc(8192) -> 238 cycles kfree -> 226 cycles
 10000 times kmalloc(16384) -> 403 cycles kfree -> 264 cycles
 2. Kmalloc: alloc/free test
 10000 times kmalloc(8)/kfree -> 68 cycles
 10000 times kmalloc(16)/kfree -> 68 cycles
 10000 times kmalloc(32)/kfree -> 69 cycles
 10000 times kmalloc(64)/kfree -> 68 cycles
 10000 times kmalloc(128)/kfree -> 68 cycles
 10000 times kmalloc(256)/kfree -> 68 cycles
 10000 times kmalloc(512)/kfree -> 74 cycles
 10000 times kmalloc(1024)/kfree -> 75 cycles
 10000 times kmalloc(2048)/kfree -> 74 cycles
 10000 times kmalloc(4096)/kfree -> 74 cycles
 10000 times kmalloc(8192)/kfree -> 75 cycles
 10000 times kmalloc(16384)/kfree -> 510 cycles

* After

 Single thread testing
 =====================
 1. Kmalloc: Repeatedly allocate then free test
 10000 times kmalloc(8) -> 46 cycles kfree -> 61 cycles
 10000 times kmalloc(16) -> 46 cycles kfree -> 63 cycles
 10000 times kmalloc(32) -> 49 cycles kfree -> 69 cycles
 10000 times kmalloc(64) -> 57 cycles kfree -> 76 cycles
 10000 times kmalloc(128) -> 66 cycles kfree -> 83 cycles
 10000 times kmalloc(256) -> 84 cycles kfree -> 110 cycles
 10000 times kmalloc(512) -> 77 cycles kfree -> 114 cycles
 10000 times kmalloc(1024) -> 80 cycles kfree -> 116 cycles
 10000 times kmalloc(2048) -> 102 cycles kfree -> 131 cycles
 10000 times kmalloc(4096) -> 135 cycles kfree -> 163 cycles
 10000 times kmalloc(8192) -> 238 cycles kfree -> 218 cycles
 10000 times kmalloc(16384) -> 399 cycles kfree -> 262 cycles
 2. Kmalloc: alloc/free test
 10000 times kmalloc(8)/kfree -> 65 cycles
 10000 times kmalloc(16)/kfree -> 66 cycles
 10000 times kmalloc(32)/kfree -> 65 cycles
 10000 times kmalloc(64)/kfree -> 66 cycles
 10000 times kmalloc(128)/kfree -> 66 cycles
 10000 times kmalloc(256)/kfree -> 71 cycles
 10000 times kmalloc(512)/kfree -> 72 cycles
 10000 times kmalloc(1024)/kfree -> 71 cycles
 10000 times kmalloc(2048)/kfree -> 71 cycles
 10000 times kmalloc(4096)/kfree -> 71 cycles
 10000 times kmalloc(8192)/kfree -> 65 cycles
 10000 times kmalloc(16384)/kfree -> 511 cycles

Most of the results are better than before.

Note that this change slightly worses performance in !CONFIG_PREEMPT,
roughly 0.3%.  Implementing each case separately would help performance,
but, since it's so marginal, I didn't do that.  This would help
maintanance since we have same code for all cases.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff -puN mm/slub.c~mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off mm/slub.c
--- a/mm/slub.c~mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off
+++ a/mm/slub.c
@@ -2398,13 +2398,24 @@ redo:
 	 * reading from one cpu area. That does not matter as long
 	 * as we end up on the original cpu again when doing the cmpxchg.
 	 *
-	 * Preemption is disabled for the retrieval of the tid because that
-	 * must occur from the current processor. We cannot allow rescheduling
-	 * on a different processor between the determination of the pointer
-	 * and the retrieval of the tid.
+	 * We should guarantee that tid and kmem_cache are retrieved on
+	 * the same cpu. It could be different if CONFIG_PREEMPT so we need
+	 * to check if it is matched or not.
 	 */
-	preempt_disable();
-	c = this_cpu_ptr(s->cpu_slab);
+	do {
+		tid = this_cpu_read(s->cpu_slab->tid);
+		c = raw_cpu_ptr(s->cpu_slab);
+	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
+
+	/*
+	 * Irqless object alloc/free algorithm used here depends on sequence
+	 * of fetching cpu_slab's data. tid should be fetched before anything
+	 * on c to guarantee that object and page associated with previous tid
+	 * won't be used with current tid. If we fetch tid first, object and
+	 * page could be one associated with next tid and our alloc/free
+	 * request will be failed. In this case, we will retry. So, no problem.
+	 */
+	barrier();
 
 	/*
 	 * The transaction ids are globally unique per cpu and per operation on
@@ -2412,8 +2423,6 @@ redo:
 	 * occurs on the right processor and that there was no operation on the
 	 * linked list in between.
 	 */
-	tid = c->tid;
-	preempt_enable();
 
 	object = c->freelist;
 	page = c->page;
@@ -2659,11 +2668,13 @@ redo:
 	 * data is retrieved via this pointer. If we are on the same cpu
 	 * during the cmpxchg then the free will succedd.
 	 */
-	preempt_disable();
-	c = this_cpu_ptr(s->cpu_slab);
+	do {
+		tid = this_cpu_read(s->cpu_slab->tid);
+		c = raw_cpu_ptr(s->cpu_slab);
+	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
 
-	tid = c->tid;
-	preempt_enable();
+	/* Same with comment on barrier() in slab_alloc_node() */
+	barrier();
 
 	if (likely(page == c->page)) {
 		set_freepointer(s, object, c->freelist);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
sparc32-fix-broken-set_pte.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions.patch
mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-compaction-print-current-range-where-compaction-work.patch
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
slub-never-fail-to-shrink-cache.patch
slub-fix-kmem_cache_shrink-return-value.patch
slub-make-dead-caches-discard-free-slabs-immediately.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
mm-page_ext-remove-unnecessary-stack_trace-field.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
mm-compaction-fix-wrong-order-check-in-compact_finished.patch
mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage.patch
mm-internalh-dont-split-printk-call-in-two.patch
mm-page_allocc-pull-out-init-code-from-build_all_zonelists.patch
mm-mm_initc-mark-mminit_verify_zonelist-as-__init.patch
mm-mm_initc-mark-mminit_loglevel-__meminitdata.patch
kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init.patch
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

