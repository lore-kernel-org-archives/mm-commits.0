From: akpm@linux-foundation.org
Subject: +
 mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix.patch added to -mm tree
Date: Fri, 05 Sep 2014 13:02:19 -0700
Message-ID: <540a16cb.F5whPfmiVFTGf6EQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaIEUCU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 16:02:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix
has been added to the -mm tree.  Its filename is
     mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix.patch

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
Subject: mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix

move up memcontrol.h header to fix build failure if CONFIG_MEMCG_KMEM=y too.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/kmemcheck.c~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix mm/kmemcheck.c
diff -puN mm/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix mm/slab.h
--- a/mm/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix
+++ a/mm/slab.h
@@ -37,6 +37,8 @@ struct kmem_cache {
 #include <linux/slub_def.h>
 #endif
 
+#include <linux/memcontrol.h>
+
 /*
  * State of the slab allocator.
  *
@@ -268,8 +270,6 @@ static inline void memcg_uncharge_slab(s
 }
 #endif
 
-#include <linux/memcontrol.h>
-
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 {
 	struct kmem_cache *cachep;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab_commonc-suppress-warning.patch
mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix.patch
mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch
mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch
mm-slab-noinline-__ac_put_obj.patch
mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch
slub-disable-tracing-and-failslab-for-merged-slabs.patch
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
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-report-maximum-used-memory.patch
page-owners-correct-page-order-when-to-free-page.patch

