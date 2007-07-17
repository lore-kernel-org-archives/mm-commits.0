From: akpm@linux-foundation.org
Subject: - handle-kernelcore=-generic.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:00:42 -0700
Message-ID: <200707172300.l6HN0gJw011316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760737AbXGQXBu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:01:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     handle kernelcore=: generic
has been removed from the -mm tree.  Its filename was
     handle-kernelcore=-generic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: handle kernelcore=: generic
From: Mel Gorman <mel@csn.ul.ie>

This patch adds the kernelcore= parameter for x86.

Once all patches are applied, a new command-line parameter exist and a new
sysctl.  This patch adds the necessary documentation.


  When "kernelcore" boot option is specified, kernel can't boot up on ia64
  because of an infinite loop.  In addition, the parsing code can be handled
  in an architecture-independent manner.

  This patch uses common code to handle the kernelcore= parameter.  It is
  only available to architectures that support arch-independent zone-sizing
  (i.e.  define CONFIG_ARCH_POPULATES_NODE_MAP).  Other architectures will
  ignore the boot parameter.

[bunk@stusta.de: make cmdline_parse_kernelcore() static]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt  |   15 +++++++++++++++
 Documentation/kernel-parameters.txt |   16 ++++++++++++++++
 Documentation/sysctl/vm.txt         |    3 ++-
 arch/ia64/kernel/efi.c              |    1 +
 include/linux/mm.h                  |    1 -
 mm/page_alloc.c                     |    5 ++++-
 6 files changed, 38 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/proc.txt~handle-kernelcore=-generic Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~handle-kernelcore=-generic
+++ a/Documentation/filesystems/proc.txt
@@ -1348,6 +1348,21 @@ nr_hugepages configures number of hugetl
 hugetlb_shm_group contains group id that is allowed to create SysV shared
 memory segment using hugetlb page.
 
+hugepages_treat_as_movable
+--------------------------
+
+This parameter is only useful when kernelcore= is specified at boot time to
+create ZONE_MOVABLE for pages that may be reclaimed or migrated. Huge pages
+are not movable so are not normally allocated from ZONE_MOVABLE. A non-zero
+value written to hugepages_treat_as_movable allows huge pages to be allocated
+from ZONE_MOVABLE.
+
+Once enabled, the ZONE_MOVABLE is treated as an area of memory the huge
+pages pool can easily grow or shrink within. Assuming that applications are
+not running that mlock() a lot of memory, it is likely the huge pages pool
+can grow to the size of ZONE_MOVABLE by repeatedly entering the desired value
+into nr_hugepages and triggering page reclaim.
+
 laptop_mode
 -----------
 
diff -puN Documentation/kernel-parameters.txt~handle-kernelcore=-generic Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~handle-kernelcore=-generic
+++ a/Documentation/kernel-parameters.txt
@@ -817,6 +817,22 @@ and is between 256 and 4096 characters. 
 	js=		[HW,JOY] Analog joystick
 			See Documentation/input/joystick.txt.
 
+	kernelcore=nn[KMG]	[KNL,IA-32,IA-64,PPC,X86-64] This parameter
+			specifies the amount of memory usable by the kernel
+			for non-movable allocations.  The requested amount is
+			spread evenly throughout all nodes in the system. The
+			remaining memory in each node is used for Movable
+			pages. In the event, a node is too small to have both
+			kernelcore and Movable pages, kernelcore pages will
+			take priority and other nodes will have a larger number
+			of kernelcore pages.  The Movable zone is used for the
+			allocation of pages that may be reclaimed or moved
+			by the page migration subsystem.  This means that
+			HugeTLB pages may not be allocated from this zone.
+			Note that allocations like PTEs-from-HighMem still
+			use the HighMem zone if it exists, and the Normal
+			zone if it does not.
+
 	keepinitrd	[HW,ARM]
 
 	kstack=N	[IA-32,X86-64] Print N words from the kernel stack
diff -puN Documentation/sysctl/vm.txt~handle-kernelcore=-generic Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~handle-kernelcore=-generic
+++ a/Documentation/sysctl/vm.txt
@@ -38,7 +38,8 @@ Currently, these files are in /proc/sys/
 
 dirty_ratio, dirty_background_ratio, dirty_expire_centisecs,
 dirty_writeback_centisecs, vfs_cache_pressure, laptop_mode,
-block_dump, swap_token_timeout, drop-caches:
+block_dump, swap_token_timeout, drop-caches,
+hugepages_treat_as_movable:
 
 See Documentation/filesystems/proc.txt
 
diff -puN arch/ia64/kernel/efi.c~handle-kernelcore=-generic arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~handle-kernelcore=-generic
+++ a/arch/ia64/kernel/efi.c
@@ -28,6 +28,7 @@
 #include <linux/time.h>
 #include <linux/efi.h>
 #include <linux/kexec.h>
+#include <linux/mm.h>
 
 #include <asm/io.h>
 #include <asm/kregs.h>
diff -puN include/linux/mm.h~handle-kernelcore=-generic include/linux/mm.h
--- a/include/linux/mm.h~handle-kernelcore=-generic
+++ a/include/linux/mm.h
@@ -1005,7 +1005,6 @@ extern unsigned long find_max_pfn_with_a
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
 extern void sparse_memory_present_with_active_regions(int nid);
-extern int cmdline_parse_kernelcore(char *p);
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 extern int early_pfn_to_nid(unsigned long pfn);
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
diff -puN mm/page_alloc.c~handle-kernelcore=-generic mm/page_alloc.c
--- a/mm/page_alloc.c~handle-kernelcore=-generic
+++ a/mm/page_alloc.c
@@ -3416,7 +3416,7 @@ void __init free_area_init_nodes(unsigne
  * kernelcore=size sets the amount of memory for use for allocations that
  * cannot be reclaimed or migrated.
  */
-int __init cmdline_parse_kernelcore(char *p)
+static int __init cmdline_parse_kernelcore(char *p)
 {
 	unsigned long long coremem;
 	if (!p)
@@ -3430,6 +3430,9 @@ int __init cmdline_parse_kernelcore(char
 
 	return 0;
 }
+
+early_param("kernelcore", cmdline_parse_kernelcore);
+
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
 /**
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
remove-alloc_zeroed_user_highpage.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
