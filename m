From: akpm@linux-foundation.org
Subject: [merged] mm-cmac-suppress-warning.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:17:01 -0800
Message-ID: <563d0abd.hpMcNnKVviE31Irq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161884AbbKFURC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mina86@mina86.com, stefan.strogin@gmail.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma.c: suppress warning
has been removed from the -mm tree.  Its filename was
     mm-cmac-suppress-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/cma.c: suppress warning

mm/cma.c: In function 'cma_alloc':
mm/cma.c:366: warning: 'pfn' may be used uninitialized in this function

The patch actually improves the tracing a bit: if alloc_contig_range()
fails, tracing will display the offending pfn rather than -1.

Cc: Stefan Strogin <stefan.strogin@gmail.com>
Cc: Michal Nazarewicz <mpn@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/cma.c~mm-cmac-suppress-warning mm/cma.c
--- a/mm/cma.c~mm-cmac-suppress-warning
+++ a/mm/cma.c
@@ -363,7 +363,9 @@ err:
  */
 struct page *cma_alloc(struct cma *cma, size_t count, unsigned int align)
 {
-	unsigned long mask, offset, pfn, start = 0;
+	unsigned long mask, offset;
+	unsigned long pfn = -1;
+	unsigned long start = 0;
 	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
 	struct page *page = NULL;
 	int ret;
@@ -418,7 +420,7 @@ struct page *cma_alloc(struct cma *cma,
 		start = bitmap_no + mask + 1;
 	}
 
-	trace_cma_alloc(page ? pfn : -1UL, page, count, align);
+	trace_cma_alloc(pfn, page, count, align);
 
 	pr_debug("%s(): returned %p\n", __func__, page);
 	return page;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix-99.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-hack.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

