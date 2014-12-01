From: akpm@linux-foundation.org
Subject: +
 mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix.patch added to -mm tree
Date: Mon, 01 Dec 2014 15:09:07 -0800
Message-ID: <547cf513.3fbsAKbKwPtlT8Aq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684AbaLAXJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2014 18:09:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix
has been added to the -mm tree.  Its filename is
     mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix.patch

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
Subject: mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix

Fix following warning from 0-day kernel test infrastructure.

  make.cross ARCH=m32r

All warnings:

   mm/nommu.c: In function 'do_mmap_private':
>> mm/nommu.c:1193:8: warning: assignment makes pointer (snip)...
      base = __get_free_pages(GFP_KERNEL, order);
           ^

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/nommu.c~mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix mm/nommu.c
--- a/mm/nommu.c~mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix
+++ a/mm/nommu.c
@@ -1190,7 +1190,7 @@ static int do_mmap_private(struct vm_are
 		kdebug("try to alloc exact %lu pages", total);
 		base = alloc_pages_exact(len, GFP_KERNEL);
 	} else {
-		base = __get_free_pages(GFP_KERNEL, order);
+		base = (void *)__get_free_pages(GFP_KERNEL, order);
 	}
 
 	if (!base)
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
include-linux-kmemleakh-needs-slabh.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix.patch
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

