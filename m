From: akpm@linux-foundation.org
Subject: - ps3-make-ps3videomode-v-0-auto-mode-work-again.patch removed from -mm tree
Date: Mon, 07 May 2007 00:00:23 -0700
Message-ID: <200705070700.l4770Ncr021013@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754118AbXEGHBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 03:01:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Masashi_Kimoto@hq.scei.sony.co.jp, Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ps3: Make `ps3videomode -v 0 (auto mode) work again
has been removed from the -mm tree.  Its filename was
     ps3-make-ps3videomode-v-0-auto-mode-work-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3: Make `ps3videomode -v 0 (auto mode) work again
From: Masashi Kimoto <Masashi_Kimoto@hq.scei.sony.co.jp>

ps3: Make `ps3videomode -v 0' (auto mode) work again

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c         |    7 +++++++
 drivers/video/ps3fb.c       |    5 +++++
 include/asm-powerpc/ps3av.h |    1 +
 3 files changed, 13 insertions(+)

diff -puN drivers/ps3/ps3av.c~ps3-make-ps3videomode-v-0-auto-mode-work-again drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3-make-ps3videomode-v-0-auto-mode-work-again
+++ a/drivers/ps3/ps3av.c
@@ -744,6 +744,13 @@ int ps3av_set_video_mode(u32 id, int boo
 
 EXPORT_SYMBOL_GPL(ps3av_set_video_mode);
 
+int ps3av_get_auto_mode(int boot)
+{
+	return ps3av_auto_videomode(&ps3av.av_hw_conf, boot);
+}
+
+EXPORT_SYMBOL_GPL(ps3av_get_auto_mode);
+
 int ps3av_set_mode(u32 id, int boot)
 {
 	int res;
diff -puN drivers/video/ps3fb.c~ps3-make-ps3videomode-v-0-auto-mode-work-again drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3-make-ps3videomode-v-0-auto-mode-work-again
+++ a/drivers/video/ps3fb.c
@@ -732,6 +732,11 @@ static int ps3fb_ioctl(struct fb_info *i
 			if (copy_from_user(&val, argp, sizeof(val)))
 				break;
 
+			if (!(val & PS3AV_MODE_MASK)) {
+				u32 id = ps3av_get_auto_mode(0);
+				if (id > 0)
+					val = (val & ~PS3AV_MODE_MASK) | id;
+			}
 			DPRINTK("PS3FB_IOCTL_SETMODE:%x\n", val);
 			retval = -EINVAL;
 			old_mode = ps3fb_mode;
diff -puN include/asm-powerpc/ps3av.h~ps3-make-ps3videomode-v-0-auto-mode-work-again include/asm-powerpc/ps3av.h
--- a/include/asm-powerpc/ps3av.h~ps3-make-ps3videomode-v-0-auto-mode-work-again
+++ a/include/asm-powerpc/ps3av.h
@@ -706,6 +706,7 @@ extern int ps3av_vuart_read(struct ps3_v
 
 extern int ps3av_set_video_mode(u32, int);
 extern int ps3av_set_audio_mode(u32, u32, u32, u32, u32);
+extern int ps3av_get_auto_mode(int);
 extern int ps3av_set_mode(u32, int);
 extern int ps3av_get_mode(void);
 extern int ps3av_get_scanmode(int);
_

Patches currently in -mm which might be from Masashi_Kimoto@hq.scei.sony.co.jp are

origin.patch
