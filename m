From: akpm@linux-foundation.org
Subject: + fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:10:04 -0800
Message-ID: <200702272110.l1RLA8RN028689@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52302 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbXB0VKT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:10:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, adaplas@pol.net


The patch titled
     fbdev: ignore VESA modes if framebuffer is disabled
has been added to the -mm tree.  Its filename is
     fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/i386/boot/video.S   |    4 +++-
 arch/x86_64/boot/video.S |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

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
 	
diff -puN arch/x86_64/boot/video.S~fbdev-ignore-vesa-modes-if-framebuffer-is-disabled arch/x86_64/boot/video.S
--- a/arch/x86_64/boot/video.S~fbdev-ignore-vesa-modes-if-framebuffer-is-disabled
+++ a/arch/x86_64/boot/video.S
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

patch-maintainers-update-email-address.patch
atyfb-fix-kconfig-error.patch
fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-hecuba-framebuffer-driver.patch
