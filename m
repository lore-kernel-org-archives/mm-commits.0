From: akpm@linux-foundation.org
Subject: + handle-kernelcore=-generic.patch added to -mm tree
Date: Tue, 01 May 2007 11:54:57 -0700
Message-ID: <200705011855.l41IsvUu003788@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161757AbXEASzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 14:55:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org, y-goto@jp.fujitsu.com


The patch titled
     handle kernelcore=: generic
has been added to the -mm tree.  Its filename is
     handle-kernelcore=-generic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 mm/page_alloc.c                     |    3 +++
 6 files changed, 37 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~handle-kernelcore=-generic mm/page_alloc.c
--- a/mm/page_alloc.c~handle-kernelcore=-generic
+++ a/mm/page_alloc.c
@@ -3561,6 +3561,9 @@ int __init cmdline_parse_kernelcore(char
 
 	return 0;
 }
+
+early_param("kernelcore", cmdline_parse_kernelcore);
+
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
 /**
diff -puN arch/i386/kernel/setup.c~handle-kernelcore=-generic arch/i386/kernel/setup.c
diff -puN arch/powerpc/kernel/prom.c~handle-kernelcore=-generic arch/powerpc/kernel/prom.c
diff -puN arch/ppc/mm/init.c~handle-kernelcore=-generic arch/ppc/mm/init.c
diff -puN arch/x86_64/kernel/e820.c~handle-kernelcore=-generic arch/x86_64/kernel/e820.c
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
diff -puN Documentation/filesystems/proc.txt~handle-kernelcore=-generic Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~handle-kernelcore=-generic
+++ a/Documentation/filesystems/proc.txt
@@ -1289,6 +1289,21 @@ nr_hugepages configures number of hugetl
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
@@ -800,6 +800,22 @@ and is between 256 and 4096 characters. 
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
@@ -36,7 +36,8 @@ Currently, these files are in /proc/sys/
 
 dirty_ratio, dirty_background_ratio, dirty_expire_centisecs,
 dirty_writeback_centisecs, vfs_cache_pressure, laptop_mode,
-block_dump, swap_token_timeout, drop-caches:
+block_dump, swap_token_timeout, drop-caches,
+hugepages_treat_as_movable:
 
 See Documentation/filesystems/proc.txt
 
diff -puN include/linux/mm.h~handle-kernelcore=-generic include/linux/mm.h
--- a/include/linux/mm.h~handle-kernelcore=-generic
+++ a/include/linux/mm.h
@@ -988,7 +988,6 @@ extern unsigned long find_max_pfn_with_a
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
 extern void sparse_memory_present_with_active_regions(int nid);
-extern int cmdline_parse_kernelcore(char *p);
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 extern int early_pfn_to_nid(unsigned long pfn);
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
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
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
do-not-disable-interrupts-when-reading-min_free_kbytes.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
