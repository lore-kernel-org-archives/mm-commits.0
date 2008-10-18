From: akpm@linux-foundation.org
Subject: - fbdev-ignore-vesa-modes-if-framebuffer-does-not-support-them.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:56 -0700
Message-ID: <200810182317.m9INHunZ029185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbYJRXR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, hpa@zytor.com, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     fbdev: ignore VESA modes if framebuffer does not support them
has been removed from the -mm tree.  Its filename was
     fbdev-ignore-vesa-modes-if-framebuffer-does-not-support-them.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: ignore VESA modes if framebuffer does not support them
From: Michal Januszewski <spock@gentoo.org>

Currently, it is possible to set a graphics VESA mode at boot time via the
vga= parameter even when no framebuffer driver supporting this is
configured.  This could lead to the system booting with a black screen,
without a usable console.

Fix this problem by only allowing to set graphics modes at boot time if a
supporting framebuffer driver is configured.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/video-vesa.c |    9 ++++-----
 drivers/video/Kconfig      |   11 +++++++++++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff -puN arch/x86/boot/video-vesa.c~fbdev-ignore-vesa-modes-if-framebuffer-does-not-support-them arch/x86/boot/video-vesa.c
--- a/arch/x86/boot/video-vesa.c~fbdev-ignore-vesa-modes-if-framebuffer-does-not-support-them
+++ a/arch/x86/boot/video-vesa.c
@@ -88,14 +88,11 @@ static int vesa_probe(void)
 			   (vminfo.memory_layout == 4 ||
 			    vminfo.memory_layout == 6) &&
 			   vminfo.memory_planes == 1) {
-#ifdef CONFIG_FB
+#ifdef CONFIG_FB_BOOT_VESA_SUPPORT
 			/* Graphics mode, color, linear frame buffer
 			   supported.  Only register the mode if
 			   if framebuffer is configured, however,
-			   otherwise the user will be left without a screen.
-			   We don't require CONFIG_FB_VESA, however, since
-			   some of the other framebuffer drivers can use
-			   this mode-setting, too. */
+			   otherwise the user will be left without a screen. */
 			mi = GET_HEAP(struct mode_info, 1);
 			mi->mode = mode + VIDEO_FIRST_VESA;
 			mi->depth = vminfo.bpp;
@@ -133,10 +130,12 @@ static int vesa_set_mode(struct mode_inf
 	if ((vminfo.mode_attr & 0x15) == 0x05) {
 		/* It's a supported text mode */
 		is_graphic = 0;
+#ifdef CONFIG_FB_BOOT_VESA_SUPPORT
 	} else if ((vminfo.mode_attr & 0x99) == 0x99) {
 		/* It's a graphics mode with linear frame buffer */
 		is_graphic = 1;
 		vesa_mode |= 0x4000; /* Request linear frame buffer */
+#endif
 	} else {
 		return -1;	/* Invalid mode */
 	}
diff -puN drivers/video/Kconfig~fbdev-ignore-vesa-modes-if-framebuffer-does-not-support-them drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-ignore-vesa-modes-if-framebuffer-does-not-support-them
+++ a/drivers/video/Kconfig
@@ -76,6 +76,14 @@ config FB_DDC
        select I2C
        default n
 
+config FB_BOOT_VESA_SUPPORT
+	bool
+	depends on FB
+	default n
+	---help---
+	  If true, at least one selected framebuffer driver can take advantage
+	  of VESA video modes set at an early boot stage via the vga= parameter.
+
 config FB_CFB_FILLRECT
 	tristate
 	depends on FB
@@ -681,6 +689,7 @@ config FB_VESA
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FB_BOOT_VESA_SUPPORT
 	help
 	  This is the frame buffer device driver for generic VESA 2.0
 	  compliant graphic cards. The older VESA 1.2 cards are not supported.
@@ -1117,6 +1126,7 @@ config FB_INTEL
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FB_BOOT_VESA_SUPPORT
 	help
 	  This driver supports the on-board graphics built in to the Intel
           830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets.
@@ -1469,6 +1479,7 @@ config FB_SIS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FB_BOOT_VESA_SUPPORT
 	help
 	  This is the frame buffer device driver for the SiS 300, 315, 330
 	  and 340 series as well as XGI V3XT, V5, V8, Z7 graphics chipsets.
_

Patches currently in -mm which might be from spock@gentoo.org are

origin.patch

