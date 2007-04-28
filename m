From: akpm@linux-foundation.org
Subject: + get_unmapped_area-handles-map_fixed-on-arm.patch added to -mm tree
Date: Sat, 28 Apr 2007 01:34:06 -0700
Message-ID: <200704280834.l3S8Y6ur018087@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965573AbXD1IeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 04:34:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, rmk+kernel@arm.linux.org.uk


The patch titled
     get_unmapped_area handles MAP_FIXED on arm
has been added to the -mm tree.  Its filename is
     get_unmapped_area-handles-map_fixed-on-arm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: get_unmapped_area handles MAP_FIXED on arm
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

ARM already had a case for MAP_FIXED in arch_get_unmapped_area() though it was
not called before.  Fix the comment to reflect that it will now be called.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/mmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/arm/mm/mmap.c~get_unmapped_area-handles-map_fixed-on-arm arch/arm/mm/mmap.c
--- a/arch/arm/mm/mmap.c~get_unmapped_area-handles-map_fixed-on-arm
+++ a/arch/arm/mm/mmap.c
@@ -49,8 +49,7 @@ arch_get_unmapped_area(struct file *filp
 #endif
 
 	/*
-	 * We should enforce the MAP_FIXED case.  However, currently
-	 * the generic kernel code doesn't allow us to handle this.
+	 * We enforce the MAP_FIXED case.
 	 */
 	if (flags & MAP_FIXED) {
 		if (aliasing && flags & MAP_SHARED && addr & (SHMLBA - 1))
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

git-powerpc.patch
git-powerpc-arch-powerpc-sysdev-timerc-build-fix.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
powerpc-rtas-msi-support.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
macintosh-mediabay-convert-to-kthread-api.patch
macintosh-adb-convert-to-the-kthread-api.patch
macintosh-therm_pm72c-partially-convert-to-kthread-api.patch
s2ram-add-arch-irq-disable-enable-hooks.patch
fix-jdelvare-i2c-i2c-del-driver-returns-void-on-powerpc.patch
slub-core.patch
use-slab_panic-flag-cleanup.patch
get_unmapped_area-handles-map_fixed-on-powerpc.patch
get_unmapped_area-handles-map_fixed-on-alpha.patch
get_unmapped_area-handles-map_fixed-on-arm.patch
get_unmapped_area-handles-map_fixed-on-frv.patch
get_unmapped_area-handles-map_fixed-on-i386.patch
get_unmapped_area-handles-map_fixed-on-ia64.patch
get_unmapped_area-handles-map_fixed-on-parisc.patch
get_unmapped_area-handles-map_fixed-on-sparc64.patch
get_unmapped_area-handles-map_fixed-on-x86_64.patch
get_unmapped_area-handles-map_fixed-in-hugetlbfs.patch
get_unmapped_area-handles-map_fixed-in-generic-code.patch
get_unmapped_area-doesnt-need-hugetlbfs-hacks-anymore.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
parport-dev-driver-model-support-powerpc-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch
local_t-powerpc-extension.patch
linux-kernel-markers-powerpc-optimization.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
aty128fb-fix-blanking.patch
radeonfb-add-support-for-radeon-xpress-200m.patch
