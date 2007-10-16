From: akpm@linux-foundation.org
Subject: - fbdev-fb_create_modedb-non-static-int-first-=-1.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:42:57 -0700
Message-ID: <200710162042.l9GKgvnD015931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934952AbXJPVHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: fb_create_modedb() non-static `int first = 1;'
has been removed from the -mm tree.  Its filename was
     fbdev-fb_create_modedb-non-static-int-first-=-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: fb_create_modedb() non-static `int first = 1;'
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Looking at the code flow, `int first' in fb_create_modedb() should be static.

[adaplas]
Better for 'int first' to be moved outside the loop.

[akpm@linux-foundation.org: kill stray semicolon]
Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmon.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/fbmon.c~fbdev-fb_create_modedb-non-static-int-first-=-1 drivers/video/fbmon.c
--- a/drivers/video/fbmon.c~fbdev-fb_create_modedb-non-static-int-first-=-1
+++ a/drivers/video/fbmon.c
@@ -591,7 +591,7 @@ static struct fb_videomode *fb_create_mo
 {
 	struct fb_videomode *mode, *m;
 	unsigned char *block;
-	int num = 0, i;
+	int num = 0, i, first = 1;
 
 	mode = kzalloc(50 * sizeof(struct fb_videomode), GFP_KERNEL);
 	if (mode == NULL)
@@ -608,8 +608,6 @@ static struct fb_videomode *fb_create_mo
 	DPRINTK("   Detailed Timings\n");
 	block = edid + DETAILED_TIMING_DESCRIPTIONS_START;
 	for (i = 0; i < 4; i++, block+= DETAILED_TIMING_DESCRIPTION_SIZE) {
-	        int first = 1;
-
 		if (!(block[0] == 0x00 && block[1] == 0x00)) {
 			get_detailed_timing(block, &mode[num]);
 			if (first) {
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
