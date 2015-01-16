From: akpm@linux-foundation.org
Subject: +
 mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch
 added to -mm tree
Date: Thu, 15 Jan 2015 16:24:41 -0800
Message-ID: <54b85a49.b6852aPc3Ij5taKD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbbAPAYy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 19:24:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: optimize alloc/free fastpath by removing preemption on/off
has been added to the -mm tree.  Its filename is
     mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Change from v1: add comment about barrier() usage

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
+		c = this_cpu_ptr(s->cpu_slab);
+	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
+
+	/*
+	 * Irqless object alloc/free alogorithm used here depends on sequence
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
+		c = this_cpu_ptr(s->cpu_slab);
+	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
 
-	tid = c->tid;
-	preempt_enable();
+	/* Same with comment on barrier() in slab_alloc_node() */
+	barrier();
 
 	if (likely(page == c->page)) {
 		set_freepointer(s, object, c->freelist);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch
mm-dont-use-compound_head-in-virt_to_head_page.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
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
mm-compaction-print-current-range-where-compaction-work.patch
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch

