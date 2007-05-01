From: akpm@linux-foundation.org
Subject: - ia64-specify-amount-of-kernel-memory-at-boot-time.patch removed from -mm tree
Date: Tue, 01 May 2007 11:52:05 -0700
Message-ID: <200705011852.l41Iq5N9003736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161730AbXEASwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 14:52:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     ia64 - Specify amount of kernel memory at boot time
has been removed from the -mm tree.  Its filename was
     ia64-specify-amount-of-kernel-memory-at-boot-time.patch

This patch was dropped because it was folded into handle-kernelcore=-generic.patch

------------------------------------------------------
Subject: ia64 - Specify amount of kernel memory at boot time
From: Mel Gorman <mel@csn.ul.ie>

This patch adds the kernelcore= parameter for ia64.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN arch/ia64/kernel/efi.c~ia64-specify-amount-of-kernel-memory-at-boot-time arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~ia64-specify-amount-of-kernel-memory-at-boot-time
+++ a/arch/ia64/kernel/efi.c
@@ -28,6 +28,7 @@
 #include <linux/time.h>
 #include <linux/efi.h>
 #include <linux/kexec.h>
+#include <linux/mm.h>
 
 #include <asm/io.h>
 #include <asm/kregs.h>
@@ -422,6 +423,8 @@ efi_init (void)
 			mem_limit = memparse(cp + 4, &cp);
 		} else if (memcmp(cp, "max_addr=", 9) == 0) {
 			max_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
+		} else if (memcmp(cp, "kernelcore=",11) == 0) {
+			cmdline_parse_kernelcore(cp+11);
 		} else if (memcmp(cp, "min_addr=", 9) == 0) {
 			min_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
 		} else {
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
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
do-not-disable-interrupts-when-reading-min_free_kbytes.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
