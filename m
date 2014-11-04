From: akpm@linux-foundation.org
Subject: + mm-slab-reverse-iteration-on-find_mergeable.patch added to -mm
 tree
Date: Tue, 04 Nov 2014 12:24:22 -0800
Message-ID: <545935f6.z43mCGmlJEtRtvxQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaKDUYV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 15:24:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: reverse iteration on find_mergeable()
has been added to the -mm tree.  Its filename is
     mm-slab-reverse-iteration-on-find_mergeable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-reverse-iteration-on-find_mergeable.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-reverse-iteration-on-find_mergeable.patch

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
Subject: mm/slab: reverse iteration on find_mergeable()

Unlike SLUB, sometimes, object isn't started at the beginning of the slab
in the SLAB.  This causes the unalignment problem when after slab merging
is supported by commit 12220dea07f1 ("mm/slab: support slab merge"). 
Alignment mismatch check is introduced ("mm/slab: fix unalignment problem
on Malta with EVA due to slab merge") to prevent merge in this case.

This causes undesirable result that merging happens between infrequently
used kmem_caches if there are kmem_caches with same size and is 256 bytes,
are merged into pool_workqueue rather than kmalloc-256, because
kmem_caches for kmalloc are at the tail of the list.

To prevent this situation, this patch reverses iteration order in
find_mergeable() to find frequently used kmem_caches.  This change helps
to merge kmem_cache to frequently used kmem_caches, such as kmalloc
kmem_caches.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab_common.c~mm-slab-reverse-iteration-on-find_mergeable mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-reverse-iteration-on-find_mergeable
+++ a/mm/slab_common.c
@@ -240,7 +240,7 @@ struct kmem_cache *find_mergeable(size_t
 	size = ALIGN(size, align);
 	flags = kmem_cache_flags(size, flags, name, NULL);
 
-	list_for_each_entry(s, &slab_caches, list) {
+	list_for_each_entry_reverse(s, &slab_caches, list) {
 		if (slab_unmergeable(s))
 			continue;
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-compaction-skip-the-range-until-proper-target-pageblock-is-met.patch
mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
mm-slab-fix-unalignment-problem-on-malta-with-eva-due-to-slab-merge.patch
mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-slab-reverse-iteration-on-find_mergeable.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
page-owners-correct-page-order-when-to-free-page.patch

