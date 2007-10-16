From: akpm@linux-foundation.org
Subject: - ps3av-eliminate-unneeded-temporary-variables.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:06 -0700
Message-ID: <200710162045.l9GKj6WH016229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42413 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965471AbXJPU47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ps3av: eliminate unneeded temporary variables
has been removed from the -mm tree.  Its filename was
     ps3av-eliminate-unneeded-temporary-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3av: eliminate unneeded temporary variables
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3av: eliminate unneeded temporary variables

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av_cmd.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

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

origin.patch
