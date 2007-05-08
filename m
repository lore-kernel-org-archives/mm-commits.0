From: akpm@linux-foundation.org
Subject: - get_unmapped_area-handles-map_fixed-on-parisc.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:06 -0700
Message-ID: <200705080004.l48046DK008988@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967367AbXEHAF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:05:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, grundler@parisc-linux.org, kyle@mcmartin.ca, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     get_unmapped_area handles MAP_FIXED on parisc
has been removed from the -mm tree.  Its filename was
     get_unmapped_area-handles-map_fixed-on-parisc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
