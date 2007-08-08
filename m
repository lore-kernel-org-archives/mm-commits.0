From: akpm@linux-foundation.org
Subject: + wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix.patch added to -mm tree
Date: Tue, 07 Aug 2007 19:19:06 -0700
Message-ID: <200708080219.l782J66S016338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40416 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756577AbXHHCUR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 22:20:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     synchronous lumpy: improve commentary on writeback wait
has been added to the -mm tree.  Its filename is
     wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: synchronous lumpy: improve commentary on writeback wait
From: Andy Whitcroft <apw@shadowen.org>

Improve code commentary on the initial writeback wait in synchronous
reclaim mode.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/vmscan.c~wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix mm/vmscan.c
--- a/mm/vmscan.c~wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix
+++ a/mm/vmscan.c
@@ -479,6 +479,14 @@ static unsigned long shrink_page_list(st
 			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
 
 		if (PageWriteback(page)) {
+			/*
+			 * Synchronous reclaim is performed in two passes,
+			 * first an asynchronous pass over the list to
+			 * start parallel writeback, and a second synchronous
+			 * pass to wait for the IO to complete.  Wait here
+			 * for any page for which writeback has already
+			 * started.
+			 */
 			if (sync_writeback == PAGEOUT_IO_SYNC && may_enter_fs)
 				wait_on_page_writeback(page);
 			else
_

Patches currently in -mm which might be from apw@shadowen.org are

update-checkpatchpl-to-version-009.patch
finish-i386-and-x86-64-sysdata-conversion.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch
wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch
wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix.patch
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
