From: akpm@linux-foundation.org
Subject: + get_unmapped_area-handles-map_fixed-on-parisc.patch added to -mm tree
Date: Sat, 28 Apr 2007 01:34:12 -0700
Message-ID: <200704280834.l3S8YC56018102@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161600AbXD1IfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 04:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, grundler@parisc-linux.org, kyle@mcmartin.ca, willy@debian.org


The patch titled
     get_unmapped_area handles MAP_FIXED on parisc
has been added to the -mm tree.  Its filename is
     get_unmapped_area-handles-map_fixed-on-parisc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: get_unmapped_area handles MAP_FIXED on parisc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Handle MAP_FIXED in parisc arch_get_unmapped_area(), just return the address. 
We might want to also check for possible cache aliasing issues now that we get
called in that case (like ARM or MIPS), leave a comment for the maintainers to
pick up.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/sys_parisc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/parisc/kernel/sys_parisc.c~get_unmapped_area-handles-map_fixed-on-parisc arch/parisc/kernel/sys_parisc.c
--- a/arch/parisc/kernel/sys_parisc.c~get_unmapped_area-handles-map_fixed-on-parisc
+++ a/arch/parisc/kernel/sys_parisc.c
@@ -106,6 +106,11 @@ unsigned long arch_get_unmapped_area(str
 {
 	if (len > TASK_SIZE)
 		return -ENOMEM;
+	/* Might want to check for cache aliasing issues for MAP_FIXED case
+	 * like ARM or MIPS ??? --BenH.
+	 */
+	if (flags & MAP_FIXED)
+		return addr;
 	if (!addr)
 		addr = TASK_UNMAPPED_BASE;
 
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
