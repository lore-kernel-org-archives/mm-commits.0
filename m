From: akpm@linux-foundation.org
Subject: + ps3fb-make-ps3fb_wait_for_vsync-and-ps3fb_flip_ctl-static.patch added to -mm tree
Date: Mon, 15 Oct 2007 14:36:13 -0700
Message-ID: <200710152136.l9FLaDhM026137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755685AbXJOVgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 17:36:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3fb: make ps3fb_wait_for_vsync() and ps3fb_flip_ctl() static
has been added to the -mm tree.  Its filename is
     ps3fb-make-ps3fb_wait_for_vsync-and-ps3fb_flip_ctl-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3fb: make ps3fb_wait_for_vsync() and ps3fb_flip_ctl() static
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Make ps3fb_wait_for_vsync() and ps3fb_flip_ctl() static, as they're no
(longer) used outside ps3fb.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-make-ps3fb_wait_for_vsync-and-ps3fb_flip_ctl-static drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-make-ps3fb_wait_for_vsync-and-ps3fb_flip_ctl-static
+++ a/drivers/video/ps3fb.c
@@ -652,7 +652,7 @@ static int ps3fb_get_vblank(struct fb_vb
 	return 0;
 }
 
-int ps3fb_wait_for_vsync(u32 crtc)
+static int ps3fb_wait_for_vsync(u32 crtc)
 {
 	int ret;
 	u64 count;
@@ -667,9 +667,7 @@ int ps3fb_wait_for_vsync(u32 crtc)
 	return 0;
 }
 
-EXPORT_SYMBOL_GPL(ps3fb_wait_for_vsync);
-
-void ps3fb_flip_ctl(int on, void *data)
+static void ps3fb_flip_ctl(int on, void *data)
 {
 	struct ps3fb_priv *priv = data;
 	if (on)
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
git-scsi-misc.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
ps3-fix-black-and-white-stripes.patch
ps3fb-fix-spurious-mode-change-failures.patch
ps3av-eliminate-unneeded-temporary-variables.patch
ps3av-eliminate-ps3av_debug.patch
ps3av-use-ps3-video-mode-ids-in-autodetect-code.patch
ps3av-treat-dvi-d-like-hdmi-in-autodetect.patch
ps3av-add-autodetection-for-vesa-modes.patch
ps3av-add-quirk-database-for-broken-monitors.patch
ps3av-remove-unused-ps3av_set_mode.patch
ps3av-dont-distinguish-between-boot-and-non-boot-autodetection.patch
ps3fb-convert-from-printk-dprintk-to-dev_-pr_.patch
ps3fb-do-not-print-warnings-on-invalid-frame-numbers.patch
ps3fb-clean-up-includes.patch
ps3fb-make-ps3fb_wait_for_vsync-and-ps3fb_flip_ctl-static.patch
ps3fb-fix-possible-overlap-of-gpu-command-buffer-and-frame-buffer.patch
ps3fb-use-fb_infopar-properly.patch
ps3fb-dont-keep-the-borders-for-non-fullscreen-modes-in-xdr-memory.patch
ps3fb-add-virtual-screen-and-panning-support.patch
ps3fb-enhance-horizontal-panning-on-firmware-190-and-up.patch
fb-move-and-rename-extern-declaration-for-global_mode_option.patch
ps3fb-default-to-480p-on-dvi-d-hdmi-if-video=safe.patch
