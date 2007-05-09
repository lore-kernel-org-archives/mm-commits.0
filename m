From: akpm@linux-foundation.org
Subject: - 64-bit-resources-arch-powerpc-changes-update.patch removed from -mm tree
Date: Wed, 09 May 2007 15:25:02 -0700
Message-ID: <200705092225.l49MP2Ah004197@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755991AbXEIWZR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:25:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, greg@kroah.com, segher@kernel.crashing.org, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     64-bit-resources-arch-powerpc-changes update
has been removed from the -mm tree.  Its filename was
     64-bit-resources-arch-powerpc-changes-update.patch

This patch was dropped because I'm cleaning old stuff out of my patches directory

------------------------------------------------------
Subject: 64-bit-resources-arch-powerpc-changes update
From: Mel Gorman <mel@csn.ul.ie>


The 64-bit resource change ended up causing us to do a 64-bit divide and
ppc32 won't link (missing __udivdi3).

The following patch has been successfully boot tested on the same
machine with 64 bit resource_size_t.  Because the mask is assumed to be a
power-of-two - 1, I added a comment and a BUG_ON() to be sure.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/powerpc/kernel/pci_32.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/kernel/pci_32.c~64-bit-resources-arch-powerpc-changes-update arch/powerpc/kernel/pci_32.c
--- devel/arch/powerpc/kernel/pci_32.c~64-bit-resources-arch-powerpc-changes-update	2006-05-29 15:52:59.000000000 -0700
+++ devel-akpm/arch/powerpc/kernel/pci_32.c	2006-05-29 15:54:45.000000000 -0700
@@ -1114,8 +1114,16 @@ check_for_io_childs(struct pci_bus *bus,
 	int	i;
 	int	rc = 0;
 
-#define push_end(res, size) do { unsigned long __sz = (size) ; \
-	res->end = ((res->end + __sz) / (__sz + 1)) * (__sz + 1) + __sz; \
+	/*
+	 * Assuming mask is a power of two - 1, push_end
+	 * moves res->end to the end of the next
+	 * mask-aligned boundary.
+	 * e.g. res->end of 0x1fff moves to 0x2fff
+	 */
+#define push_end(res, mask) do {				\
+	BUG_ON(((mask+1) & mask) != 0);			\
+	res->end = -(-res->end & ~(unsigned long)mask);		\
+	res->end += mask;					\
     } while (0)
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
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
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
