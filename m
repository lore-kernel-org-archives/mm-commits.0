From: akpm@linux-foundation.org
Subject: + s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:08:59 -0700
Message-ID: <201007092308.o69N8xDC030962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755527Ab0GIXJq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:09:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: p.osciak@samsung.com, ben-linux@fluff.org, inki.dae@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com


The patch titled
     s3c-fb: fix various null references on framebuffer memory alloc failure
has been added to the -mm tree.  Its filename is
     s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3c-fb: fix various null references on framebuffer memory alloc failure
From: Pawel Osciak <p.osciak@samsung.com>

The following problems were found in the above situation:

sfb->windows[win] was being assigned at the end of s3c_fb_probe_win only. 
This resulted in passing a NULL to s3c_fb_release_win if probe_win
returned early and a memory leak.

dma_free_writecombine does not allow its third argument to be NULL.

fb_dealloc_cmap does not verify whether its argument is not NULL.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/video/s3c-fb.c~s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure
+++ a/drivers/video/s3c-fb.c
@@ -804,7 +804,8 @@ static void s3c_fb_free_memory(struct s3
 {
 	struct fb_info *fbi = win->fbinfo;
 
-	dma_free_writecombine(sfb->dev, PAGE_ALIGN(fbi->fix.smem_len),
+	if (fbi->screen_base)
+		dma_free_writecombine(sfb->dev, PAGE_ALIGN(fbi->fix.smem_len),
 			      fbi->screen_base, fbi->fix.smem_start);
 }
 
@@ -819,7 +820,8 @@ static void s3c_fb_release_win(struct s3
 {
 	if (win->fbinfo) {
 		unregister_framebuffer(win->fbinfo);
-		fb_dealloc_cmap(&win->fbinfo->cmap);
+		if (win->fbinfo->cmap.len)
+			fb_dealloc_cmap(&win->fbinfo->cmap);
 		s3c_fb_free_memory(sfb, win);
 		framebuffer_release(win->fbinfo);
 	}
@@ -865,6 +867,7 @@ static int __devinit s3c_fb_probe_win(st
 	WARN_ON(windata->win_mode.yres == 0);
 
 	win = fbinfo->par;
+	*res = win;
 	var = &fbinfo->var;
 	win->variant = *variant;
 	win->fbinfo = fbinfo;
@@ -939,7 +942,6 @@ static int __devinit s3c_fb_probe_win(st
 		return ret;
 	}
 
-	*res = win;
 	dev_info(sfb->dev, "window %d: fb %s\n", win_no, fbinfo->fix.id);
 
 	return 0;
_

Patches currently in -mm which might be from p.osciak@samsung.com are

linux-next.patch
s3c-fb-change-to-depending-on-config_s3c_fb_dev.patch
s3c-fb-add-default-window-feature.patch
s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch
s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch
s3c-fb-initial-move-to-unifying-the-header-files.patch
s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch
s3c-fb-integrate-palette-setup-code-into-main-driver.patch
s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch
s3c-fb-correct-framesel1-bitfield-defines-for-vidintcon0-register.patch
s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch
s3c-fb-add-device-name-initialization.patch
s3c-fb-add-support-for-display-panning.patch
s3c-fb-add-wait-for-vsync-ioctl.patch
s3c-fb-window-3-of-64xx-does-not-have-an-osd_d-register.patch
s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch
s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch
s3c-fb-protect-window-specific-registers-during-updates.patch
s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch

