From: akpm@linux-foundation.org
Subject: + ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:41:55 -0800
Message-ID: <200703022141.l22LftUX019800@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42090 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030359AbXCBVl7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     ppc and powerpc - Specify amount of kernel memory at boot time
has been added to the -mm tree.  Its filename is
     ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -431,6 +431,7 @@ static int __init early_parse_mem(char *
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
