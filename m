From: akpm@linux-foundation.org
Subject: + ps3av-eliminate-unneeded-temporary-variables.patch added to -mm tree
Date: Wed, 03 Oct 2007 13:53:07 -0700
Message-ID: <200710032053.l93Kr7Bf008078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755378AbXJCUxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 16:53:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com


The patch titled
     ps3av: eliminate unneeded temporary variables
has been added to the -mm tree.  Its filename is
     ps3av-eliminate-unneeded-temporary-variables.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3av: eliminate unneeded temporary variables
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3av: eliminate unneeded temporary variables

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/ps3/ps3av_cmd.c~ps3av-eliminate-unneeded-temporary-variables drivers/ps3/ps3av_cmd.c
--- a/drivers/ps3/ps3av_cmd.c~ps3av-eliminate-unneeded-temporary-variables
+++ a/drivers/ps3/ps3av_cmd.c
@@ -512,7 +512,6 @@ static const u32 ps3av_ns_table[][5] = {
 static void ps3av_cnv_ns(u8 *ns, u32 fs, u32 video_vid)
 {
 	u32 av_vid, ns_val;
-	u8 *p = ns;
 	int d;
 
 	d = ns_val = 0;
@@ -551,24 +550,22 @@ static void ps3av_cnv_ns(u8 *ns, u32 fs,
 	else
 		ns_val = ps3av_ns_table[PS3AV_CMD_AUDIO_FS_44K-BASE][d];
 
-	*p++ = ns_val & 0x000000FF;
-	*p++ = (ns_val & 0x0000FF00) >> 8;
-	*p = (ns_val & 0x00FF0000) >> 16;
+	*ns++ = ns_val & 0x000000FF;
+	*ns++ = (ns_val & 0x0000FF00) >> 8;
+	*ns = (ns_val & 0x00FF0000) >> 16;
 }
 
 #undef BASE
 
 static u8 ps3av_cnv_enable(u32 source, const u8 *enable)
 {
-	const u8 *p;
 	u8 ret = 0;
 
 	if (source == PS3AV_CMD_AUDIO_SOURCE_SPDIF) {
 		ret = 0x03;
 	} else if (source == PS3AV_CMD_AUDIO_SOURCE_SERIAL) {
-		p = enable;
-		ret = ((p[0] << 4) + (p[1] << 5) + (p[2] << 6) + (p[3] << 7)) |
-		      0x01;
+		ret = ((enable[0] << 4) + (enable[1] << 5) + (enable[2] << 6) +
+		       (enable[3] << 7)) | 0x01;
 	} else
 		printk(KERN_ERR "%s failed, source:%x\n", __func__, source);
 	return ret;
@@ -576,11 +573,9 @@ static u8 ps3av_cnv_enable(u32 source, c
 
 static u8 ps3av_cnv_fifomap(const u8 *map)
 {
-	const u8 *p;
 	u8 ret = 0;
 
-	p = map;
-	ret = p[0] + (p[1] << 2) + (p[2] << 4) + (p[3] << 6);
+	ret = map[0] + (map[1] << 2) + (map[2] << 4) + (map[3] << 6);
 	return ret;
 }
 
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
