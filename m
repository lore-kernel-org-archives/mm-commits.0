From: akpm@linux-foundation.org
Subject: + mips-irix_getcontext-will-always-fail-efault.patch added to -mm tree
Date: Fri, 17 Aug 2007 13:23:26 -0700
Message-ID: <200708172023.l7HKNQmk027850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35047 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880AbXHQUYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 16:24:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, ralf@linux-mips.org


The patch titled
     mips: irix_getcontext will always fail EFAULT
has been added to the -mm tree.  Its filename is
     mips-irix_getcontext-will-always-fail-efault.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mips: irix_getcontext will always fail EFAULT
From: Andy Whitcroft <apw@shadowen.org>

Seems that a trailing ';' has slipped onto the end of the access_ok check
here, such that we will always return -EFAULT.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/irixsig.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/kernel/irixsig.c~mips-irix_getcontext-will-always-fail-efault arch/mips/kernel/irixsig.c
--- a/arch/mips/kernel/irixsig.c~mips-irix_getcontext-will-always-fail-efault
+++ a/arch/mips/kernel/irixsig.c
@@ -725,7 +725,7 @@ asmlinkage int irix_getcontext(struct pt
 	       current->comm, current->pid, ctx);
 #endif
 
-	if (!access_ok(VERIFY_WRITE, ctx, sizeof(*ctx)));
+	if (!access_ok(VERIFY_WRITE, ctx, sizeof(*ctx)))
 		return -EFAULT;
 
 	error = __put_user(current->thread.irix_oldctx, &ctx->link);
_

Patches currently in -mm which might be from apw@shadowen.org are

sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch
wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch
wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix.patch
mips-irix_getcontext-will-always-fail-efault.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-get-mp_bus_to_node-as-early-v3-update.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
powerpc-hash_preload-fails-to-preload-under-config_ppc_mm_slices.patch
irda_nl_get_mode-always-results-in-failure.patch
