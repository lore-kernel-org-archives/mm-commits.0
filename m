From: akpm@linux-foundation.org
Subject: - ps3fb-kill-superfluous-zero-initializations.patch removed from -mm tree
Date: Mon, 07 May 2007 00:00:12 -0700
Message-ID: <200705070700.l4770C0e020997@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089AbXEGHAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 03:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, hch@lst.de, jsimmons@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3fb: kill superfluous zero initializations
has been removed from the -mm tree.  Its filename was
     ps3fb-kill-superfluous-zero-initializations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: kill superfluous zero initializations
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3fb: kill superfluous zero initializations

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Hellwig <hch@lst.de>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-kill-superfluous-zero-initializations drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-kill-superfluous-zero-initializations
+++ a/drivers/video/ps3fb.c
@@ -297,10 +297,10 @@ static const struct fb_videomode ps3fb_m
 #define VP_OFF(i)	(WIDTH(i) * Y_OFF(i) * BPP + X_OFF(i) * BPP)
 #define FB_OFF(i)	(GPU_OFFSET - VP_OFF(i) % GPU_OFFSET)
 
-static int ps3fb_mode = 0;
+static int ps3fb_mode;
 module_param(ps3fb_mode, bool, 0);
 
-static char *mode_option __initdata = NULL;
+static char *mode_option __initdata;
 
 
 static int ps3fb_get_res_table(u32 xres, u32 yres)
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
fbdev-fb_do_show_logo-updates.patch
fbdev-correct-image-offsets-when-rotating-logo.patch
