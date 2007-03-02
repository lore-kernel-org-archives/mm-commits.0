From: akpm@linux-foundation.org
Subject: + add-documentation-for-additional-boot-parameter-and-sysctl.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:42:01 -0800
Message-ID: <200703022142.l22Lg1HG019810@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42101 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030473AbXCBVmG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:42:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Add documentation for additional boot parameter and sysctl
has been added to the -mm tree.  Its filename is
     add-documentation-for-additional-boot-parameter-and-sysctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add documentation for additional boot parameter and sysctl
From: Mel Gorman <mel@csn.ul.ie>

Once all patches are applied, a new command-line parameter exist and a new
sysctl.  This patch adds the necessary documentation.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt  |   15 +++++++++++++++
 Documentation/kernel-parameters.txt |   16 ++++++++++++++++
 Documentation/sysctl/vm.txt         |    3 ++-
 3 files changed, 33 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~add-documentation-for-additional-boot-parameter-and-sysctl Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~add-documentation-for-additional-boot-parameter-and-sysctl
+++ a/Documentation/filesystems/proc.txt
@@ -1288,6 +1288,21 @@ nr_hugepages configures number of hugetl
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
 
diff -puN Documentation/kernel-parameters.txt~add-documentation-for-additional-boot-parameter-and-sysctl Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~add-documentation-for-additional-boot-parameter-and-sysctl
+++ a/Documentation/kernel-parameters.txt
@@ -763,6 +763,22 @@ and is between 256 and 4096 characters. 
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
diff -puN Documentation/sysctl/vm.txt~add-documentation-for-additional-boot-parameter-and-sysctl Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~add-documentation-for-additional-boot-parameter-and-sysctl
+++ a/Documentation/sysctl/vm.txt
@@ -36,7 +36,8 @@ Currently, these files are in /proc/sys/
 
 dirty_ratio, dirty_background_ratio, dirty_expire_centisecs,
 dirty_writeback_centisecs, vfs_cache_pressure, laptop_mode,
-block_dump, swap_token_timeout, drop-caches:
+block_dump, swap_token_timeout, drop-caches,
+hugepages_treat_as_movable:
 
 See Documentation/filesystems/proc.txt
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
x86-specify-amount-of-kernel-memory-at-boot-time.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
