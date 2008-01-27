From: akpm@linux-foundation.org
Subject: + ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:14:20 -0800
Message-ID: <200801270514.m0R5EHSM030972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbYA0FOo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3av: ps3av_get_scanmode() and ps3av_get_refresh_rate() are unused
has been added to the -mm tree.  Its filename is
     ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused.patch

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
Subject: ps3av: ps3av_get_scanmode() and ps3av_get_refresh_rate() are unused
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3av_get_scanmode() and ps3av_get_refresh_rate() are unused, so remove them

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c         |   58 +++++++---------------------------
 include/asm-powerpc/ps3av.h |    2 -
 2 files changed, 13 insertions(+), 47 deletions(-)

diff -puN drivers/ps3/ps3av.c~ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused
+++ a/drivers/ps3/ps3av.c
@@ -78,23 +78,21 @@ static const struct avset_video_mode {
 	u32 aspect;
 	u32 x;
 	u32 y;
-	u32 interlace;
-	u32 freq;
 } video_mode_table[] = {
 	{     0, }, /* auto */
-	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_480I,       A_N,  720,  480, 1, 60},
-	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_480P,       A_N,  720,  480, 0, 60},
-	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_720P_60HZ,  A_N, 1280,  720, 0, 60},
-	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_1080I_60HZ, A_W, 1920, 1080, 1, 60},
-	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_1080P_60HZ, A_W, 1920, 1080, 0, 60},
-	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_576I,       A_N,  720,  576, 1, 50},
-	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_576P,       A_N,  720,  576, 0, 50},
-	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_720P_50HZ,  A_N, 1280,  720, 0, 50},
-	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_1080I_50HZ, A_W, 1920, 1080, 1, 50},
-	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_1080P_50HZ, A_W, 1920, 1080, 0, 50},
-	{  RGB8, XRGB, PS3AV_CMD_VIDEO_VID_WXGA,       A_W, 1280,  768, 0, 60},
-	{  RGB8, XRGB, PS3AV_CMD_VIDEO_VID_SXGA,       A_N, 1280, 1024, 0, 60},
-	{  RGB8, XRGB, PS3AV_CMD_VIDEO_VID_WUXGA,      A_W, 1920, 1200, 0, 60},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_480I,       A_N,  720,  480},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_480P,       A_N,  720,  480},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_720P_60HZ,  A_N, 1280,  720},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_1080I_60HZ, A_W, 1920, 1080},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_1080P_60HZ, A_W, 1920, 1080},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_576I,       A_N,  720,  576},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_576P,       A_N,  720,  576},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_720P_50HZ,  A_N, 1280,  720},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_1080I_50HZ, A_W, 1920, 1080},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_1080P_50HZ, A_W, 1920, 1080},
+	{  RGB8, XRGB, PS3AV_CMD_VIDEO_VID_WXGA,       A_W, 1280,  768},
+	{  RGB8, XRGB, PS3AV_CMD_VIDEO_VID_SXGA,       A_N, 1280, 1024},
+	{  RGB8, XRGB, PS3AV_CMD_VIDEO_VID_WUXGA,      A_W, 1920, 1200},
 };
 
 /* supported CIDs */
@@ -889,36 +887,6 @@ int ps3av_get_mode(void)
 
 EXPORT_SYMBOL_GPL(ps3av_get_mode);
 
-int ps3av_get_scanmode(int id)
-{
-	int size;
-
-	id = id & PS3AV_MODE_MASK;
-	size = ARRAY_SIZE(video_mode_table);
-	if (id > size - 1 || id < 0) {
-		printk(KERN_ERR "%s: invalid mode %d\n", __func__, id);
-		return -EINVAL;
-	}
-	return video_mode_table[id].interlace;
-}
-
-EXPORT_SYMBOL_GPL(ps3av_get_scanmode);
-
-int ps3av_get_refresh_rate(int id)
-{
-	int size;
-
-	id = id & PS3AV_MODE_MASK;
-	size = ARRAY_SIZE(video_mode_table);
-	if (id > size - 1 || id < 0) {
-		printk(KERN_ERR "%s: invalid mode %d\n", __func__, id);
-		return -EINVAL;
-	}
-	return video_mode_table[id].freq;
-}
-
-EXPORT_SYMBOL_GPL(ps3av_get_refresh_rate);
-
 /* get resolution by video_mode */
 int ps3av_video_mode2res(u32 id, u32 *xres, u32 *yres)
 {
diff -puN include/asm-powerpc/ps3av.h~ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused include/asm-powerpc/ps3av.h
--- a/include/asm-powerpc/ps3av.h~ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused
+++ a/include/asm-powerpc/ps3av.h
@@ -713,8 +713,6 @@ extern int ps3av_set_video_mode(u32);
 extern int ps3av_set_audio_mode(u32, u32, u32, u32, u32);
 extern int ps3av_get_auto_mode(void);
 extern int ps3av_get_mode(void);
-extern int ps3av_get_scanmode(int);
-extern int ps3av_get_refresh_rate(int);
 extern int ps3av_video_mode2res(u32, u32 *, u32 *);
 extern int ps3av_video_mute(int);
 extern int ps3av_audio_mute(int);
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
