From: akpm@linux-foundation.org
Subject: + ps3fb-kill-superfluous-zero-initializations.patch added to -mm tree
Date: Thu, 15 Feb 2007 16:59:55 -0800
Message-ID: <200702160059.l1G0xt3Y014852@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41541 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422991AbXBPBAb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 20:00:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, hch@lst.de, jsimmons@infradead.org, paulus@samba.org


The patch titled
     ps3fb: kill superfluous zero initializations
has been added to the -mm tree.  Its filename is
     ps3fb-kill-superfluous-zero-initializations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
