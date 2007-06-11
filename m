From: akpm@linux-foundation.org
Subject: + i386-move-the-kernel-to-16mb-for-numa-q.patch added to -mm tree
Date: Mon, 11 Jun 2007 13:09:42 -0700
Message-ID: <200706112009.l5BK9gQl028085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217AbXFKUKW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 16:10:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     i386: move the kernel to 16MB for NUMA-Q
has been added to the -mm tree.  Its filename is
     i386-move-the-kernel-to-16mb-for-numa-q.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
update-checkpatchpl-to-version-003.patch
update-feature-removal-scheduletxt-to-include-deprecated-functions.patch
move-three-functions-that-are-only-needed-for.patch
fix-sysrq-m-oops.patch
checkpatch-produce-fewer-lines-of-output.patch
update-checkpatchpl-to-version-004.patch
group-short-lived-and-reclaimable-kernel-allocations-fix.patch
i386-move-the-kernel-to-16mb-for-numa-q.patch
gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
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
remove-alloc_zeroed_user_highpage.patch
create-the-zone_movable-zone.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
update-page-order-at-an-appropriate-time-when-tracking-page_owner.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
allow-page_owner-to-be-set-on-any-architecture.patch
