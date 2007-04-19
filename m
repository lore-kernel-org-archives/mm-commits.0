From: akpm@linux-foundation.org
Subject: - fix-bogon-in-dev-mem-mmaping-on-nommu.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:01:45 -0700
Message-ID: <200704192001.l3JK1j6M029315@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766993AbXDSUDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:03:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, dhowells@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fix bogon in /dev/mem mmap'ing on nommu
has been removed from the -mm tree.  Its filename was
     fix-bogon-in-dev-mem-mmaping-on-nommu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix bogon in /dev/mem mmap'ing on nommu
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

While digging through my MAP_FIXED changes, I found that rather obvious
bug in /dev/mem mmap implementation for nommu archs. get_unmapped_area()
is expected to return an address, not a pfn.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-By: David Howells <dhowells@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mem.c~fix-bogon-in-dev-mem-mmaping-on-nommu drivers/char/mem.c
--- a/drivers/char/mem.c~fix-bogon-in-dev-mem-mmaping-on-nommu
+++ a/drivers/char/mem.c
@@ -248,7 +248,7 @@ static unsigned long get_unmapped_area_m
 {
 	if (!valid_mmap_phys_addr_range(pgoff, len))
 		return (unsigned long) -EINVAL;
-	return pgoff;
+	return pgoff << PAGE_SHIFT;
 }
 
 /* can't do an in-place private mapping if there's no MMU */
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
git-powerpc.patch
git-powerpc-arch-powerpc-sysdev-timerc-build-fix.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
powerpc-rtas-msi-support.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
parport-dev-driver-model-support-powerpc-fix.patch
use-slab_panic-flag-cleanup.patch
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
