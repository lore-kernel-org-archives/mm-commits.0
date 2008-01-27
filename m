From: akpm@linux-foundation.org
Subject: + ps3fb-kill-ps3fb_full_mode_bit.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:14:26 -0800
Message-ID: <200801270514.m0R5ENBp030978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbYA0FOr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3fb: kill PS3FB_FULL_MODE_BIT
has been added to the -mm tree.  Its filename is
     ps3fb-kill-ps3fb_full_mode_bit.patch

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
Subject: ps3fb: kill PS3FB_FULL_MODE_BIT
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Kill PS3FB_FULL_MODE_BIT, use PS3AV_MODE_FULL instead

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-kill-ps3fb_full_mode_bit drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-kill-ps3fb_full_mode_bit
+++ a/drivers/video/ps3fb.c
@@ -57,8 +57,6 @@
 #define GPU_ALIGN_UP(x)				_ALIGN_UP((x), 64)
 #define GPU_MAX_LINE_LENGTH			(65536 - 64)
 
-#define PS3FB_FULL_MODE_BIT			0x80
-
 #define GPU_INTR_STATUS_VSYNC_0			0	/* vsync on head A */
 #define GPU_INTR_STATUS_VSYNC_1			1	/* vsync on head B */
 #define GPU_INTR_STATUS_FLIP_0			3	/* flip head A */
@@ -310,7 +308,7 @@ static int ps3fb_get_res_table(u32 xres,
 	unsigned int i;
 	u32 x, y, f;
 
-	full_mode = (mode & PS3FB_FULL_MODE_BIT) ? PS3FB_RES_FULL : 0;
+	full_mode = (mode & PS3AV_MODE_FULL) ? PS3FB_RES_FULL : 0;
 	for (i = 0;; i++) {
 		x = ps3fb_res[i].xres;
 		y = ps3fb_res[i].yres;
@@ -373,7 +371,7 @@ found:
 	/* Full broadcast modes have the full mode bit set */
 	mode = i+1;
 	if (mode > PS3AV_MODE_WUXGA)
-		mode = (mode - PS3AV_MODE_WUXGA) | PS3FB_FULL_MODE_BIT;
+		mode = (mode - PS3AV_MODE_WUXGA) | PS3AV_MODE_FULL;
 
 	pr_debug("ps3fb_find_mode: mode %u\n", mode);
 
@@ -390,7 +388,7 @@ static const struct fb_videomode *ps3fb_
 
 	flags = id & ~PS3AV_MODE_MASK;
 
-	if (mode <= PS3AV_MODE_1080P50 && flags & PS3FB_FULL_MODE_BIT) {
+	if (mode <= PS3AV_MODE_1080P50 && flags & PS3AV_MODE_FULL) {
 		/* Full broadcast mode */
 		return &ps3fb_modedb[mode + PS3AV_MODE_WUXGA - 1];
 	}
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

git-powerpc.patch
git-kbuild.patch
git-x86.patch
ps3-checkpatch-drivers-ps3-ps3-sys-managerc.patch
ps3-checkpatch-drivers-ps3-ps3-vuartc.patch
ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused.patch
ps3-use-symbolic-names-for-video-modes.patch
ps3fb-kill-ps3fb_full_mode_bit.patch
ps3fb-inline-macros-that-are-used-only-once.patch
ps3fb-kill-ps3fb_res.patch
ps3fb-make-frame-buffer-offsets-unsigned-int.patch
ps3fb-add-support-for-configurable-black-borders.patch
ps3fb-reorganize-modedb-handling.patch
ps3fb-round-up-video-modes.patch
ps3fb-cleanup-sweep.patch
ps3fb-fix-modedb-typos.patch
