From: akpm@linux-foundation.org
Subject: + x86_64-specify-amount-of-kernel-memory-at-boot-time.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:41:57 -0800
Message-ID: <200703022141.l22Lfv5L019803@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42096 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030473AbXCBVmB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:42:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     x86_64 - Specify amount of kernel memory at boot time
has been added to the -mm tree.  Its filename is
     x86_64-specify-amount-of-kernel-memory-at-boot-time.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 - Specify amount of kernel memory at boot time
From: Mel Gorman <mel@csn.ul.ie>

This patch adds the kernelcore= parameter for x86_64.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/e820.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/x86_64/kernel/e820.c~x86_64-specify-amount-of-kernel-memory-at-boot-time arch/x86_64/kernel/e820.c
--- a/arch/x86_64/kernel/e820.c~x86_64-specify-amount-of-kernel-memory-at-boot-time
+++ a/arch/x86_64/kernel/e820.c
@@ -617,6 +617,7 @@ static int __init parse_memopt(char *p)
 	return 0;
 } 
 early_param("mem", parse_memopt);
+early_param("kernelcore", cmdline_parse_kernelcore);
 
 static int userdef __initdata;
 
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
