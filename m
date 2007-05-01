From: akpm@linux-foundation.org
Subject: - ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch removed from -mm tree
Date: Tue, 01 May 2007 11:52:00 -0700
Message-ID: <200705011852.l41Iq0wi003730@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161721AbXEASwF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 14:52:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     ppc and powerpc - Specify amount of kernel memory at boot time
has been removed from the -mm tree.  Its filename was
     ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch

This patch was dropped because it was folded into handle-kernelcore=-generic.patch

------------------------------------------------------
Subject: ppc and powerpc - Specify amount of kernel memory at boot time
From: Mel Gorman <mel@csn.ul.ie>

This patch adds the kernelcore= parameter for ppc and powerpc.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/prom.c |    1 +
 arch/ppc/mm/init.c         |    2 ++
 2 files changed, 3 insertions(+)

diff -puN arch/powerpc/kernel/prom.c~ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time arch/powerpc/kernel/prom.c
--- a/arch/powerpc/kernel/prom.c~ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time
+++ a/arch/powerpc/kernel/prom.c
@@ -432,6 +432,7 @@ static int __init early_parse_mem(char *
 	return 0;
 }
 early_param("mem", early_parse_mem);
+early_param("kernelcore", cmdline_parse_kernelcore);
 
 /*
  * The device tree may be allocated below our memory limit, or inside the
diff -puN arch/ppc/mm/init.c~ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time arch/ppc/mm/init.c
--- a/arch/ppc/mm/init.c~ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time
+++ a/arch/ppc/mm/init.c
@@ -214,6 +214,8 @@ void MMU_setup(void)
 	}
 }
 
+early_param("kernelcore", cmdline_parse_kernelcore);
+
 /*
  * MMU_init sets up the basic memory mappings for the kernel,
  * including both RAM and possibly some I/O regions,
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
handle-kernelcore=-generic.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
do-not-disable-interrupts-when-reading-min_free_kbytes.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
