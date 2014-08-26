From: akpm@linux-foundation.org
Subject: + mm-slab-noinline-__ac_put_obj.patch added to -mm tree
Date: Tue, 26 Aug 2014 16:17:12 -0700
Message-ID: <53fd1578.VaPCFdLv6HSeFwI1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:50052 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaHZXRN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:17:13 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so1841788qaq.5
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:17:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: noinline __ac_put_obj()
has been added to the -mm tree.  Its filename is
     mm-slab-noinline-__ac_put_obj.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-noinline-__ac_put_obj.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-noinline-__ac_put_obj.patch

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
Subject: mm/slab: noinline __ac_put_obj()

Our intention of __ac_put_obj() is that it doesn't affect anything if
sk_memalloc_socks() is disabled.  But, because __ac_put_obj() is too
small, compiler inline it to ac_put_obj() and affect code size of free
path.  This patch add noinline keyword for __ac_put_obj() not to distrupt
normal free path at all.

<Before>
nm -S slab-orig.o |
	grep -e "t cache_alloc_refill" -e "T kfree" -e "T kmem_cache_free"

0000000000001e80 00000000000002f5 t cache_alloc_refill
0000000000001230 0000000000000258 T kfree
0000000000000690 000000000000024c T kmem_cache_free

<After>
nm -S slab-patched.o |
	grep -e "t cache_alloc_refill" -e "T kfree" -e "T kmem_cache_free"

0000000000001e00 00000000000002e5 t cache_alloc_refill
00000000000011e0 0000000000000228 T kfree
0000000000000670 0000000000000216 T kmem_cache_free

cache_alloc_refill: 0x2f5->0x2e5
kfree: 0x256->0x228
kmem_cache_free: 0x24c->0x216

code size of each function is reduced slightly.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~mm-slab-noinline-__ac_put_obj mm/slab.c
--- a/mm/slab.c~mm-slab-noinline-__ac_put_obj
+++ a/mm/slab.c
@@ -785,8 +785,8 @@ static inline void *ac_get_obj(struct km
 	return objp;
 }
 
-static void *__ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
-								void *objp)
+static noinline void *__ac_put_obj(struct kmem_cache *cachep,
+			struct array_cache *ac, void *objp)
 {
 	if (unlikely(pfmemalloc_active)) {
 		/* Some pfmemalloc slabs exist, check if this is one */
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

