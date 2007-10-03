From: akpm@linux-foundation.org
Subject: + ps3av-remove-unused-ps3av_set_mode.patch added to -mm tree
Date: Wed, 03 Oct 2007 13:53:24 -0700
Message-ID: <200710032053.l93KrOWR008107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023AbXJCUx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 16:53:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com


The patch titled
     ps3av: remove unused ps3av_set_mode()
has been added to the -mm tree.  Its filename is
     ps3av-remove-unused-ps3av_set_mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3av: remove unused ps3av_set_mode()
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

remove unused ps3av_set_mode()

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/ps3/ps3av.c~ps3av-remove-unused-ps3av_set_mode drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3av-remove-unused-ps3av_set_mode
+++ a/drivers/ps3/ps3av.c
@@ -903,27 +903,6 @@ int ps3av_get_auto_mode(int boot)
 
 EXPORT_SYMBOL_GPL(ps3av_get_auto_mode);
 
-int ps3av_set_mode(u32 id, int boot)
-{
-	int res;
-
-	res = ps3av_set_video_mode(id, boot);
-	if (res)
-		return res;
-
-	res = ps3av_set_audio_mode(PS3AV_CMD_AUDIO_NUM_OF_CH_2,
-				   PS3AV_CMD_AUDIO_FS_48K,
-				   PS3AV_CMD_AUDIO_WORD_BITS_16,
-				   PS3AV_CMD_AUDIO_FORMAT_PCM,
-				   PS3AV_CMD_AUDIO_SOURCE_SERIAL);
-	if (res)
-		return res;
-
-	return 0;
-}
-
-EXPORT_SYMBOL_GPL(ps3av_set_mode);
-
 int ps3av_get_mode(void)
 {
 	return ps3av ? ps3av->ps3av_mode : 0;
diff -puN include/asm-powerpc/ps3av.h~ps3av-remove-unused-ps3av_set_mode include/asm-powerpc/ps3av.h
--- a/include/asm-powerpc/ps3av.h~ps3av-remove-unused-ps3av_set_mode
+++ a/include/asm-powerpc/ps3av.h
@@ -712,7 +712,6 @@ extern int ps3av_cmd_video_get_monitor_i
 extern int ps3av_set_video_mode(u32, int);
 extern int ps3av_set_audio_mode(u32, u32, u32, u32, u32);
 extern int ps3av_get_auto_mode(int);
-extern int ps3av_set_mode(u32, int);
 extern int ps3av_get_mode(void);
 extern int ps3av_get_scanmode(int);
 extern int ps3av_get_refresh_rate(int);
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

git-powerpc.patch
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
