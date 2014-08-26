From: akpm@linux-foundation.org
Subject: + mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch added to -mm tree
Date: Tue, 26 Aug 2014 16:17:11 -0700
Message-ID: <53fd1577.6HolSuQzia4uGwxL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:40628 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaHZXRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:17:12 -0400
Received: by mail-qg0-f73.google.com with SMTP id i50so1377452qgf.4
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:17:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: move cache_flusharray() out of unlikely.text section
has been added to the -mm tree.  Its filename is
     mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch

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
Subject: mm/slab: move cache_flusharray() out of unlikely.text section

Now, due to likely keyword, compiled code of cache_flusharray() is on
unlikely.text section.  Although it is uncommon case compared to free to
cpu cache case, it is common case than free_block().  But, free_block() is
on normal text section.  This patch fix this odd situation to remove
likely keyword.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-move-cache_flusharray-out-of-unlikelytext-section mm/slab.c
--- a/mm/slab.c~mm-slab-move-cache_flusharray-out-of-unlikelytext-section
+++ a/mm/slab.c
@@ -3406,7 +3406,7 @@ static inline void __cache_free(struct k
 	if (nr_online_nodes > 1 && cache_free_alien(cachep, objp))
 		return;
 
-	if (likely(ac->avail < ac->limit)) {
+	if (ac->avail < ac->limit) {
 		STATS_INC_FREEHIT(cachep);
 	} else {
 		STATS_INC_FREEMISS(cachep);
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

