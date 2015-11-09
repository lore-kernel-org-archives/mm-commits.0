From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:59 -0800
Message-ID: <5640fe87.6a6oFQj+awCF34Fk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbbKIUN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, catalin.marinas@arm.com, robin.murphy@arm.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: fixup for mm renames
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arm64: fixup for mm renames

__GFP_WAIT was renamed for __GFP_RECLAIM and the gfpflags_allow_blocking()
helper was added.

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/dma-mapping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm64/mm/dma-mapping.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix arch/arm64/mm/dma-mapping.c
--- a/arch/arm64/mm/dma-mapping.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix
+++ a/arch/arm64/mm/dma-mapping.c
@@ -562,7 +562,7 @@ static void *__iommu_alloc_attrs(struct 
 	 */
 	gfp |= __GFP_ZERO;
 
-	if (gfp & __GFP_WAIT) {
+	if (gfpflags_allow_blocking(gfp)) {
 		struct page **pages;
 		pgprot_t prot = __get_dma_pgprot(attrs, PAGE_KERNEL, coherent);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

