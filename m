From: akpm@linux-foundation.org
Subject: + gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size.patch added to -mm tree
Date: Mon, 14 Apr 2008 18:16:06 -0700
Message-ID: <200804150116.m3F1G6x4003775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755440AbYDOBQW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 21:16:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com


The patch titled
     gxfb/lxfb: use VSA definitions when fetching framebuffer size
has been added to the -mm tree.  Its filename is
     gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gxfb/lxfb: use VSA definitions when fetching framebuffer size
From: Andres Salomon <dilinger@queued.net>

..Rather than using magic constants.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/display_gx.c |    7 ++++---
 drivers/video/geode/lxfb_ops.c   |    6 +++---
 include/asm-x86/geode.h          |    1 +
 3 files changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/video/geode/display_gx.c~gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size drivers/video/geode/display_gx.c
--- a/drivers/video/geode/display_gx.c~gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size
+++ a/drivers/video/geode/display_gx.c
@@ -17,6 +17,7 @@
 #include <asm/io.h>
 #include <asm/div64.h>
 #include <asm/delay.h>
+#include <asm/geode.h>
 
 #include "gxfb.h"
 
@@ -28,10 +29,10 @@ unsigned int gx_frame_buffer_size(void)
 	/* Virtual register class = 0x02 */
 	/* VG_MEM_SIZE(512Kb units) = 0x00 */
 
-	outw(0xFC53, 0xAC1C);
-	outw(0x0200, 0xAC1C);
+	outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+	outw(VSA_VR_MEM_SIZE, VSA_VRC_INDEX);
 
-	val = (unsigned int)(inw(0xAC1E)) & 0xFFl;
+	val = (unsigned int)(inw(VSA_VRC_DATA)) & 0xFFl;
 	return (val << 19);
 }
 
diff -puN drivers/video/geode/lxfb_ops.c~gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size
+++ a/drivers/video/geode/lxfb_ops.c
@@ -333,10 +333,10 @@ unsigned int lx_framebuffer_size(void)
 	/* Virtual Register Class    = 0x02                     */
 	/* VG_MEM_SIZE (1MB units)   = 0x00                     */
 
-	outw(0xFC53, 0xAC1C);
-	outw(0x0200, 0xAC1C);
+	outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+	outw(VSA_VR_MEM_SIZE, VSA_VRC_INDEX);
 
-	val = (unsigned int)(inw(0xAC1E)) & 0xFE;
+	val = (unsigned int)(inw(VSA_VRC_DATA)) & 0xFE;
 	return (val << 20);
 }
 
diff -puN include/asm-x86/geode.h~gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size include/asm-x86/geode.h
--- a/include/asm-x86/geode.h~gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size
+++ a/include/asm-x86/geode.h
@@ -109,6 +109,7 @@ extern int geode_get_dev_base(unsigned i
 #define VSA_VRC_DATA		0xAC1E
 #define VSA_VR_UNLOCK		0xFC53	/* unlock virtual register */
 #define VSA_VR_SIGNATURE	0x0003
+#define VSA_VR_MEM_SIZE		0x0200
 #define VSA_SIG			0x4132	/* signature is ascii 'VSA2' */
 
 /* GPIO */
_

Patches currently in -mm which might be from dilinger@queued.net are

x86-geode-msr-cleanup.patch
x86-geode-add-virtual-systems-architecture-detection.patch
gxfb-use-pci_device-for-gxfbs-pci-device-table.patch
gxfb-replace-fbsize-config-option-with-a-module-parameter.patch
gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
gxfb-clean-up-register-definitions.patch
gxfb-move-msr-bit-fields-into-gxfbh.patch
gxfb-stop-sharing-code-with-gx1fb.patch
gxfb-add-power-management-functionality.patch
gxfb-add-power-management-functionality-fix.patch
gxfb-add-power-management-functionality-update.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-create-gp-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
lxfb-clean-up-register-definitions.patch
lxfb-clean-up-final-bits-of-df_regs.patch
lxfb-rearrange-rename-msr-bitfields.patch
lxfb-add-power-management-functionality.patch
lxfb-add-power-management-functionality-fix.patch
lxfb-add-power-management-functionality-update.patch
lxfb-rename-kernel-arg-fbsize-to-vram.patch
lxfb-disable-suspend-vt-switch-by-default.patch
lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt.patch
gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size.patch
gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available.patch
olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers.patch

