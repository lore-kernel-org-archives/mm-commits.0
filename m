From: akpm@linux-foundation.org
Subject: - get_unmapped_area-handles-map_fixed-on-arm.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:58 -0700
Message-ID: <200705080003.l4803wRq008976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967351AbXEHAE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:04:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     get_unmapped_area handles MAP_FIXED on arm
has been removed from the -mm tree.  Its filename was
     get_unmapped_area-handles-map_fixed-on-arm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-powerpc.patch
gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch
use-slab_panic-flag-cleanup.patch
the-scheduled-removal-of-obsolete_oss-options.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
parport-dev-driver-model-support.patch
introduce-freezer-flags-rev-2.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-powerpc-optimization.patch
aty128fb-fix-blanking.patch
radeonfb-add-support-for-radeon-xpress-200m.patch
