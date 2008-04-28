From: akpm@linux-foundation.org
Subject: - gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:07 -0700
Message-ID: <200804282159.m3SLx7oq018553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965448AbYD1V7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     gxfb/lxfb: detect framebuffer size using an MSR if VSA2 isn't available
has been removed from the -mm tree.  Its filename was
     gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gxfb/lxfb: detect framebuffer size using an MSR if VSA2 isn't available
From: Andres Salomon <dilinger@queued.net>

If there's no VSA2 (ie, if we're using tinybios or OpenFirmware), use the
GLIU's P2D Range Offset Descriptor to determine how much memory we have
available for the framebuffer.

Originally based on a patch by Jordan Crouse.  Tested with OpenFirmware;
Pascal informs me that tinybios has a stub that fills in P2D_RO0.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/display_gx.c |   18 +++++++++++++++++-
 drivers/video/geode/lxfb_ops.c   |   16 ++++++++++++++++
 include/asm-x86/geode.h          |    2 ++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff -puN drivers/video/geode/display_gx.c~gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available drivers/video/geode/display_gx.c
--- a/drivers/video/geode/display_gx.c~gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available
+++ a/drivers/video/geode/display_gx.c
@@ -25,7 +25,23 @@ unsigned int gx_frame_buffer_size(void)
 {
 	unsigned int val;
 
-	/* FB size is reported by a virtual register */
+	if (!geode_has_vsa2()) {
+		uint32_t hi, lo;
+
+		/* The number of pages is (PMAX - PMIN)+1 */
+		rdmsr(MSR_GLIU_P2D_RO0, lo, hi);
+
+		/* PMAX */
+		val = ((hi & 0xff) << 12) | ((lo & 0xfff00000) >> 20);
+		/* PMIN */
+		val -= (lo & 0x000fffff);
+		val += 1;
+
+		/* The page size is 4k */
+		return (val << 12);
+	}
+
+	/* FB size can be obtained from the VSA II */
 	/* Virtual register class = 0x02 */
 	/* VG_MEM_SIZE(512Kb units) = 0x00 */
 
diff -puN drivers/video/geode/lxfb_ops.c~gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available
+++ a/drivers/video/geode/lxfb_ops.c
@@ -329,6 +329,22 @@ unsigned int lx_framebuffer_size(void)
 {
 	unsigned int val;
 
+	if (!geode_has_vsa2()) {
+		uint32_t hi, lo;
+
+		/* The number of pages is (PMAX - PMIN)+1 */
+		rdmsr(MSR_GLIU_P2D_RO0, lo, hi);
+
+		/* PMAX */
+		val = ((hi & 0xff) << 12) | ((lo & 0xfff00000) >> 20);
+		/* PMIN */
+		val -= (lo & 0x000fffff);
+		val += 1;
+
+		/* The page size is 4k */
+		return (val << 12);
+	}
+
 	/* The frame buffer size is reported by a VSM in VSA II */
 	/* Virtual Register Class    = 0x02                     */
 	/* VG_MEM_SIZE (1MB units)   = 0x00                     */
diff -puN include/asm-x86/geode.h~gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available include/asm-x86/geode.h
--- a/include/asm-x86/geode.h~gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available
+++ a/include/asm-x86/geode.h
@@ -30,6 +30,8 @@ extern int geode_get_dev_base(unsigned i
 
 /* MSRS */
 
+#define MSR_GLIU_P2D_RO0	0x10000029
+
 #define MSR_LX_GLD_MSR_CONFIG	0x48002001
 #define MSR_LX_MSR_PADSEL	0x48002011	/* NOT 0x48000011; the data
 						 * sheet has the wrong value */
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
git-kbuild.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

