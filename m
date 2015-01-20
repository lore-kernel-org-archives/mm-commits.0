From: akpm@linux-foundation.org
Subject: +
 mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch added to -mm tree
Date: Tue, 20 Jan 2015 14:16:50 -0800
Message-ID: <54bed3d2.C+2y31gT1QxbYkjJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbbATWQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jan 2015 17:16:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: optimize alloc/free fastpath by removing preemption on/off
has been added to the -mm tree.  Its filename is
     mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch

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

Change from v2:
- use raw_cpu_ptr() rather than this_cpu_ptr() to avoid warning from
 preemption debug check since this is intended behaviour
- fix typo alogorithm -> algorithm

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3 mm/slub.c
--- a/mm/slub.c~mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3
+++ a/mm/slub.c
@@ -2404,11 +2404,11 @@ redo:
 	 */
 	do {
 		tid = this_cpu_read(s->cpu_slab->tid);
-		c = this_cpu_ptr(s->cpu_slab);
+		c = raw_cpu_ptr(s->cpu_slab);
 	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
 
 	/*
-	 * Irqless object alloc/free alogorithm used here depends on sequence
+	 * Irqless object alloc/free algorithm used here depends on sequence
 	 * of fetching cpu_slab's data. tid should be fetched before anything
 	 * on c to guarantee that object and page associated with previous tid
 	 * won't be used with current tid. If we fetch tid first, object and
@@ -2670,7 +2670,7 @@ redo:
 	 */
 	do {
 		tid = this_cpu_read(s->cpu_slab->tid);
-		c = this_cpu_ptr(s->cpu_slab);
+		c = raw_cpu_ptr(s->cpu_slab);
 	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
 
 	/* Same with comment on barrier() in slab_alloc_node() */
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch
mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch
mm-dont-use-compound_head-in-virt_to_head_page.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-vmstatc-fix-cleanup-ifdefs-fix.patch
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
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch

