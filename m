From: akpm@linux-foundation.org
Subject: - radeon-misc-corrections.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:50 -0700
Message-ID: <200808062056.m76KuoAn014712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758026AbYHFU5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeon: misc corrections
has been removed from the -mm tree.  Its filename was
     radeon-misc-corrections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeon: misc corrections
From: David Miller <davem@davemloft.net>

I have a new PCI-E radeon RV380 series card (PCI device ID 5b64) that
hangs in my sparc64 boxes when the init scripts set the font.  The problem
goes away if I disable acceleration.

I haven't figured out that bug yet, but along the way I found some
corrections to make based upon some auditing.

1) The RB2D_DC_FLUSH_ALL value used by the kernel fb driver
   and the XORG video driver differ.  I've made the kernel
   match what XORG is using.

2) In radeonfb_engine_reset() we have top-level code structure
   that roughly looks like:

	if (family is 300, 350, or V350)
		do this;
	else
		do that;
	...
	if (family is NOT 300, OR
	    family is NOT 350, OR
	    family is NOT V350)
		do another thing;

   this last conditional makes no sense, is always true,
   and obviously was likely meant to be "family is NOT
   300, 350, or V350".  So I've made the code match the
   intent.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_accel.c |    4 ++--
 include/video/radeon.h           |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/video/aty/radeon_accel.c~radeon-misc-corrections drivers/video/aty/radeon_accel.c
--- a/drivers/video/aty/radeon_accel.c~radeon-misc-corrections
+++ a/drivers/video/aty/radeon_accel.c
@@ -241,8 +241,8 @@ void radeonfb_engine_reset(struct radeon
 	INREG(HOST_PATH_CNTL);
 	OUTREG(HOST_PATH_CNTL, host_path_cntl);
 
-	if (rinfo->family != CHIP_FAMILY_R300 ||
-	    rinfo->family != CHIP_FAMILY_R350 ||
+	if (rinfo->family != CHIP_FAMILY_R300 &&
+	    rinfo->family != CHIP_FAMILY_R350 &&
 	    rinfo->family != CHIP_FAMILY_RV350)
 		OUTREG(RBBM_SOFT_RESET, rbbm_soft_reset);
 
diff -puN include/video/radeon.h~radeon-misc-corrections include/video/radeon.h
--- a/include/video/radeon.h~radeon-misc-corrections
+++ a/include/video/radeon.h
@@ -527,8 +527,9 @@
 
 
 /* DSTCACHE_CTLSTAT bit constants */
-#define RB2D_DC_FLUSH				   (3 << 0)
-#define RB2D_DC_FLUSH_ALL			   0xf
+#define RB2D_DC_FLUSH_2D			   (1 << 0)
+#define RB2D_DC_FREE_2D				   (1 << 2)
+#define RB2D_DC_FLUSH_ALL			   (RB2D_DC_FLUSH_2D | RB2D_DC_FREE_2D)
 #define RB2D_DC_BUSY				   (1 << 31)
 
 
_

Patches currently in -mm which might be from davem@davemloft.net are

radeonfb-fix-copyarea-for-r300-and-later.patch
linux-next.patch
configure-out-igmp-support.patch
sunrpc-do-not-pin-sunrpc-module-in-the-memory.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal-fix.patch
lockdep-lock_set_subclass-reset-a-held-locks-subclass.patch
lockdep-re-annotate-scheduler-runqueues.patch
git-sparc64.patch
docsrc-fix-ifenslave-type.patch
ali-m7101-pmu-also-available-on-sun-netras-too.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
sparc64-use-iommu_num_pages-function-in-iommu-code.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

