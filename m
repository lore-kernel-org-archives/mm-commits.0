From: akpm@linux-foundation.org
Subject: - fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:22 -0700
Message-ID: <200705090259.l492xM8k010390@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970208AbXEIC7Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:59:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fbdev: ignore VESA modes if framebuffer is disabled
has been removed from the -mm tree.  Its filename was
     fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: ignore VESA modes if framebuffer is disabled
From: "Antonino A. Daplas" <adaplas@gmail.com>

If the option vga=<VESA graphics mode> is added to the boot parameter, it will
activate graphics mode, but without any framebuffer support, the user is left
with an unusable display.

Change the behavior such that the user is instead prompted for another mode
(ala vga=ask).

NOTE: People can always use vbetool to set a graphics mode if this is really
desired, but the number of people doing this approaches zero.

Signed-off-by: Antonino Daplas <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/boot/video.S |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/i386/boot/video.S~fbdev-ignore-vesa-modes-if-framebuffer-is-disabled arch/i386/boot/video.S
--- a/arch/i386/boot/video.S~fbdev-ignore-vesa-modes-if-framebuffer-is-disabled
+++ a/arch/i386/boot/video.S
@@ -496,9 +496,11 @@ mode_set:
 	cmpb	$VIDEO_FIRST_V7>>8, %ah
 	jz	setv7
 	
+#ifdef CONFIG_FB
 	cmpb	$VIDEO_FIRST_VESA>>8, %ah
 	jnc	check_vesa
-	
+#endif
+
 	orb	%ah, %ah
 	jz	setmenu
 	
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
