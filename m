From: akpm@linux-foundation.org
Subject: + mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch
 added to -mm tree
Date: Tue, 26 Aug 2014 16:17:10 -0700
Message-ID: <53fd1576.AMRjXejya1AHHD3F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:49110 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaHZXRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:17:11 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so3022127oig.5
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:17:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sl[ao]b: always track caller in kmalloc_(node_)track_caller()
has been added to the -mm tree.  Its filename is
     mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch

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
Subject: mm/sl[ao]b: always track caller in kmalloc_(node_)track_caller()

Now, we track caller if tracing or slab debugging is enabled.  If they are
disabled, we could save one argument passing overhead by calling
__kmalloc(_node)().  But, I think that it would be marginal.  Furthermore,
default slab allocator, SLUB, doesn't use this technique so I think that
it's okay to change this situation.

After this change, we can turn on/off CONFIG_DEBUG_SLAB without full
kernel build and remove some complicated '#if' defintion.  It looks more
benefitial to me.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   22 ----------------------
 mm/slab.c            |   18 ------------------
 mm/slob.c            |    2 --
 3 files changed, 42 deletions(-)

diff -puN include/linux/slab.h~mm-slb-always-track-caller-in-kmalloc_node_track_caller include/linux/slab.h
--- a/include/linux/slab.h~mm-slb-always-track-caller-in-kmalloc_node_track_caller
+++ a/include/linux/slab.h
@@ -549,37 +549,15 @@ static inline void *kcalloc(size_t n, si
  * allocator where we care about the real place the memory allocation
  * request comes from.
  */
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB) || \
-	(defined(CONFIG_SLAB) && defined(CONFIG_TRACING)) || \
-	(defined(CONFIG_SLOB) && defined(CONFIG_TRACING))
 extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc_track_caller(size, flags, _RET_IP_)
-#else
-#define kmalloc_track_caller(size, flags) \
-	__kmalloc(size, flags)
-#endif /* DEBUG_SLAB */
 
 #ifdef CONFIG_NUMA
-/*
- * kmalloc_node_track_caller is a special version of kmalloc_node that
- * records the calling function of the routine calling it for slab leak
- * tracking instead of just the calling function (confusing, eh?).
- * It's useful when the call to kmalloc_node comes from a widely-used
- * standard allocator where we care about the real place the memory
- * allocation request comes from.
- */
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB) || \
-	(defined(CONFIG_SLAB) && defined(CONFIG_TRACING)) || \
-	(defined(CONFIG_SLOB) && defined(CONFIG_TRACING))
 extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
 #define kmalloc_node_track_caller(size, flags, node) \
 	__kmalloc_node_track_caller(size, flags, node, \
 			_RET_IP_)
-#else
-#define kmalloc_node_track_caller(size, flags, node) \
-	__kmalloc_node(size, flags, node)
-#endif
 
 #else /* CONFIG_NUMA */
 
diff -puN mm/slab.c~mm-slb-always-track-caller-in-kmalloc_node_track_caller mm/slab.c
--- a/mm/slab.c~mm-slb-always-track-caller-in-kmalloc_node_track_caller
+++ a/mm/slab.c
@@ -3503,7 +3503,6 @@ __do_kmalloc_node(size_t size, gfp_t fla
 	return kmem_cache_alloc_node_trace(cachep, flags, node, size);
 }
 
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_TRACING)
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	return __do_kmalloc_node(size, flags, node, _RET_IP_);
@@ -3516,13 +3515,6 @@ void *__kmalloc_node_track_caller(size_t
 	return __do_kmalloc_node(size, flags, node, caller);
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller);
-#else
-void *__kmalloc_node(size_t size, gfp_t flags, int node)
-{
-	return __do_kmalloc_node(size, flags, node, 0);
-}
-EXPORT_SYMBOL(__kmalloc_node);
-#endif /* CONFIG_DEBUG_SLAB || CONFIG_TRACING */
 #endif /* CONFIG_NUMA */
 
 /**
@@ -3548,8 +3540,6 @@ static __always_inline void *__do_kmallo
 	return ret;
 }
 
-
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_TRACING)
 void *__kmalloc(size_t size, gfp_t flags)
 {
 	return __do_kmalloc(size, flags, _RET_IP_);
@@ -3562,14 +3552,6 @@ void *__kmalloc_track_caller(size_t size
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
 
-#else
-void *__kmalloc(size_t size, gfp_t flags)
-{
-	return __do_kmalloc(size, flags, 0);
-}
-EXPORT_SYMBOL(__kmalloc);
-#endif
-
 /**
  * kmem_cache_free - Deallocate an object
  * @cachep: The cache the allocation was from.
diff -puN mm/slob.c~mm-slb-always-track-caller-in-kmalloc_node_track_caller mm/slob.c
--- a/mm/slob.c~mm-slb-always-track-caller-in-kmalloc_node_track_caller
+++ a/mm/slob.c
@@ -468,7 +468,6 @@ void *__kmalloc(size_t size, gfp_t gfp)
 }
 EXPORT_SYMBOL(__kmalloc);
 
-#ifdef CONFIG_TRACING
 void *__kmalloc_track_caller(size_t size, gfp_t gfp, unsigned long caller)
 {
 	return __do_kmalloc_node(size, gfp, NUMA_NO_NODE, caller);
@@ -481,7 +480,6 @@ void *__kmalloc_node_track_caller(size_t
 	return __do_kmalloc_node(size, gfp, node, caller);
 }
 #endif
-#endif
 
 void kfree(const void *block)
 {
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab_commonc-suppress-warning.patch
mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch
mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch
mm-slab-noinline-__ac_put_obj.patch
mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch
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
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-report-maximum-used-memory.patch
page-owners-correct-page-order-when-to-free-page.patch

