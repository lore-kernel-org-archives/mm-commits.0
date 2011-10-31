From: akpm@linux-foundation.org
Subject: [folded] dma-mapping-fix-sync_single_range_-dma-debugging-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:39:00 -0700
Message-ID: <201110312339.p9VNd0bX019817@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:51834 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1JaXjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:39:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clemens@ladisch.de, fujita.tomonori@lab.ntt.co.jp, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping-fix-sync_single_range_-dma-debugging-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     dma-mapping-fix-sync_single_range_-dma-debugging-checkpatch-fixes.patch

This patch was dropped because it was folded into dma-mapping-fix-sync_single_range_-dma-debugging.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dma-mapping-fix-sync_single_range_-dma-debugging-checkpatch-fixes

Cc: Clemens Ladisch <clemens@ladisch.de>

WARNING: struct dma_map_ops should normally be const
#39: FILE: include/asm-generic/dma-mapping-common.h:126:
+	struct dma_map_ops *ops = get_dma_ops(dev);

WARNING: struct dma_map_ops should normally be const
#53: FILE: include/asm-generic/dma-mapping-common.h:140:
+	struct dma_map_ops *ops = get_dma_ops(dev);

total: 0 errors, 2 warnings, 26 lines checked

./patches/dma-mapping-fix-sync_single_range_-dma-debugging.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/dma-mapping-common.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/dma-mapping-common.h~dma-mapping-fix-sync_single_range_-dma-debugging-checkpatch-fixes include/asm-generic/dma-mapping-common.h
--- a/include/asm-generic/dma-mapping-common.h~dma-mapping-fix-sync_single_range_-dma-debugging-checkpatch-fixes
+++ a/include/asm-generic/dma-mapping-common.h
@@ -123,7 +123,7 @@ static inline void dma_sync_single_range
 						 size_t size,
 						 enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_cpu)
@@ -137,7 +137,7 @@ static inline void dma_sync_single_range
 						    size_t size,
 						    enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_device)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch

