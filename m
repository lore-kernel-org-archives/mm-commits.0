From: akpm@linux-foundation.org
Subject: + mm-slab-support-slab-merge.patch added to -mm tree
Date: Fri, 19 Sep 2014 15:37:46 -0700
Message-ID: <541cb03a.Ck/uUYQNQhphQRAt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848AbaISWhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 18:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: support slab merge
has been added to the -mm tree.  Its filename is
     mm-slab-support-slab-merge.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-support-slab-merge.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-support-slab-merge.patch

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
Subject: mm/slab: support slab merge

Slab merge is good feature to reduce fragmentation.  If new creating slab
have similar size and property with exsitent slab, this feature reuse it
rather than creating new one.  As a result, objects are packed into fewer
slabs so that fragmentation is reduced.

Below is result of my testing.

* After boot, sleep 20; cat /proc/meminfo | grep Slab

<Before>
Slab: 25136 kB

<After>
Slab: 24364 kB

We can save 3% memory used by slab.

For supporting this feature in SLAB, we need to implement SLAB specific
kmem_cache_flag() and __kmem_cache_alias(), because SLUB implements some
SLUB specific processing related to debug flag and object size change on
these functions.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   20 ++++++++++++++++++++
 mm/slab.h |    2 +-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-support-slab-merge mm/slab.c
--- a/mm/slab.c~mm-slab-support-slab-merge
+++ a/mm/slab.c
@@ -2104,6 +2104,26 @@ static int __init_refok setup_cpu_cache(
 	return 0;
 }
 
+unsigned long kmem_cache_flags(unsigned long object_size,
+	unsigned long flags, const char *name,
+	void (*ctor)(void *))
+{
+	return flags;
+}
+
+struct kmem_cache *
+__kmem_cache_alias(const char *name, size_t size, size_t align,
+		   unsigned long flags, void (*ctor)(void *))
+{
+	struct kmem_cache *cachep;
+
+	cachep = find_mergeable(size, align, flags, name, ctor);
+	if (cachep)
+		cachep->refcount++;
+
+	return cachep;
+}
+
 /**
  * __kmem_cache_create - Create a cache.
  * @cachep: cache management descriptor
diff -puN mm/slab.h~mm-slab-support-slab-merge mm/slab.h
--- a/mm/slab.h~mm-slab-support-slab-merge
+++ a/mm/slab.h
@@ -92,7 +92,7 @@ struct mem_cgroup;
 int slab_unmergeable(struct kmem_cache *s);
 struct kmem_cache *find_mergeable(size_t size, size_t align,
 		unsigned long flags, const char *name, void (*ctor)(void *));
-#ifdef CONFIG_SLUB
+#ifndef CONFIG_SLOB
 struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
 		   unsigned long flags, void (*ctor)(void *));
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix.patch
mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch
mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch
mm-slab-noinline-__ac_put_obj.patch
mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch
slub-disable-tracing-and-failslab-for-merged-slabs.patch
topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node.patch
slub-fallback-to-node_to_mem_node-node-if-allocating-on-memoryless-node.patch
partial-revert-of-81c98869faa5-kthread-ensure-locality-of-task_struct-allocations.patch
slab-fix-for_each_kmem_cache_node.patch
mm-slab_common-commonize-slab-merge-logic.patch
mm-slab-support-slab-merge.patch
mm-slab-use-percpu-allocator-for-cpu-cache.patch
mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mm-use-__seq_open_private-instead-of-seq_open.patch
memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-report-maximum-used-memory.patch
page-owners-correct-page-order-when-to-free-page.patch

