From: akpm@linux-foundation.org
Subject: - ps3av-remove-unused-ps3av_set_mode.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:18 -0700
Message-ID: <200710162045.l9GKjIaq016252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965121AbXJPU44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ps3av: remove unused ps3av_set_mode()
has been removed from the -mm tree.  Its filename was
     ps3av-remove-unused-ps3av_set_mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3av: remove unused ps3av_set_mode()
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

remove unused ps3av_set_mode()

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c         |   21 ---------------------
 include/asm-powerpc/ps3av.h |    1 -
 2 files changed, 22 deletions(-)

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

origin.patch
