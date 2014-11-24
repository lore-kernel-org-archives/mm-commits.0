From: akpm@linux-foundation.org
Subject: +
 mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
 added to -mm tree
Date: Mon, 24 Nov 2014 14:58:33 -0800
Message-ID: <5473b819.RPa775nUN+StqMi6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaKXW6L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Nov 2014 17:58:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dave@sr71.net, hannes@cmpxchg.org, jungsoo.son@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu: use alloc_pages_exact() rather than it's own implementation
has been added to the -mm tree.  Its filename is
     mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch

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
Subject: mm/nommu: use alloc_pages_exact() rather than it's own implementation

do_mmap_private() in nommu.c try to allocate physically contiguous pages
with arbitrary size in some cases and we now have good abstract function
to do exactly same thing, alloc_pages_exact().  So, change to use it.

There is no functional change.  This is the preparation step for support
page owner feature accurately.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Jungsoo Son <jungsoo.son@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff -puN mm/nommu.c~mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation mm/nommu.c
--- a/mm/nommu.c~mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation
+++ a/mm/nommu.c
@@ -1149,8 +1149,7 @@ static int do_mmap_private(struct vm_are
 			   unsigned long len,
 			   unsigned long capabilities)
 {
-	struct page *pages;
-	unsigned long total, point, n;
+	unsigned long total, point;
 	void *base;
 	int ret, order;
 
@@ -1182,33 +1181,23 @@ static int do_mmap_private(struct vm_are
 	order = get_order(len);
 	kdebug("alloc order %d for %lx", order, len);
 
-	pages = alloc_pages(GFP_KERNEL, order);
-	if (!pages)
-		goto enomem;
-
 	total = 1 << order;
-	atomic_long_add(total, &mmap_pages_allocated);
-
 	point = len >> PAGE_SHIFT;
 
-	/* we allocated a power-of-2 sized page set, so we may want to trim off
-	 * the excess */
+	/* we don't want to allocate a power-of-2 sized page set */
 	if (sysctl_nr_trim_pages && total - point >= sysctl_nr_trim_pages) {
-		while (total > point) {
-			order = ilog2(total - point);
-			n = 1 << order;
-			kdebug("shave %lu/%lu @%lu", n, total - point, total);
-			atomic_long_sub(n, &mmap_pages_allocated);
-			total -= n;
-			set_page_refcounted(pages + total);
-			__free_pages(pages + total, order);
-		}
+		total = point;
+		kdebug("try to alloc exact %lu pages", total);
+		base = alloc_pages_exact(len, GFP_KERNEL);
+	} else {
+		base = __get_free_pages(GFP_KERNEL, order);
 	}
 
-	for (point = 1; point < total; point++)
-		set_page_refcounted(&pages[point]);
+	if (!base)
+		goto enomem;
+
+	atomic_long_add(total, &mmap_pages_allocated);
 
-	base = page_address(pages);
 	region->vm_flags = vma->vm_flags |= VM_MAPPED_COPY;
 	region->vm_start = (unsigned long) base;
 	region->vm_end   = region->vm_start + len;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-slab-reverse-iteration-on-find_mergeable.patch
mm-slub-fix-format-mismatches-in-slab_err-callers.patch
slab-improve-checking-for-invalid-gfp_flags.patch
slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
mm-cma-align-to-physical-address-not-cma-region-position.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value-fix.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
page-owners-correct-page-order-when-to-free-page.patch

