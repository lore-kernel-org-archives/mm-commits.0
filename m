From: akpm@linux-foundation.org
Subject: - i386-move-the-kernel-to-16mb-for-numa-q.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:58 -0700
Message-ID: <200707192009.l6JK9wn4020623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761051AbXGSUPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     i386: move the kernel to 16MB for NUMA-Q
has been removed from the -mm tree.  Its filename was
     i386-move-the-kernel-to-16mb-for-numa-q.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: move the kernel to 16MB for NUMA-Q
From: Andy Whitcroft <apw@shadowen.org>

We are seeing corruption of the decompressed kernel.  It is suspected that
this is platform specific as it has yet to be seen on any other x86.  Move
the kernel to the 16MB boundary.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/i386/Kconfig~i386-move-the-kernel-to-16mb-for-numa-q arch/i386/Kconfig
--- a/arch/i386/Kconfig~i386-move-the-kernel-to-16mb-for-numa-q
+++ a/arch/i386/Kconfig
@@ -823,6 +823,7 @@ config CRASH_DUMP
 
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
+	default "0x1000000" if X86_NUMAQ
 	default "0x100000"
 	help
 	  This gives the physical address where the kernel is loaded.
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
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
