From: akpm@linux-foundation.org
Subject: + auxdisplay-section-cleanup-in-cfag12864bfb-driver.patch added to -mm tree
Date: Tue, 30 Mar 2010 16:23:51 -0700
Message-ID: <201003302323.o2UNNpLc011566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756956Ab0C3XY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Mar 2010 19:24:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, miguel.ojeda.sandonis@gmail.com


The patch titled
     auxdisplay: section cleanup in cfag12864bfb driver
has been added to the -mm tree.  Its filename is
     auxdisplay-section-cleanup-in-cfag12864bfb-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: auxdisplay: section cleanup in cfag12864bfb driver
From: Henrik Kretzschmar <henne@nachtwindheim.de>

This fixes a two section mismatches and makes remove() __devexit.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/auxdisplay/cfag12864bfb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/auxdisplay/cfag12864bfb.c~auxdisplay-section-cleanup-in-cfag12864bfb-driver drivers/auxdisplay/cfag12864bfb.c
--- a/drivers/auxdisplay/cfag12864bfb.c~auxdisplay-section-cleanup-in-cfag12864bfb-driver
+++ a/drivers/auxdisplay/cfag12864bfb.c
@@ -37,7 +37,7 @@
 
 #define CFAG12864BFB_NAME "cfag12864bfb"
 
-static struct fb_fix_screeninfo cfag12864bfb_fix __initdata = {
+static struct fb_fix_screeninfo cfag12864bfb_fix __devinitdata = {
 	.id = "cfag12864b",
 	.type = FB_TYPE_PACKED_PIXELS,
 	.visual = FB_VISUAL_MONO10,
@@ -48,7 +48,7 @@ static struct fb_fix_screeninfo cfag1286
 	.accel = FB_ACCEL_NONE,
 };
 
-static struct fb_var_screeninfo cfag12864bfb_var __initdata = {
+static struct fb_var_screeninfo cfag12864bfb_var __devinitdata = {
 	.xres = CFAG12864B_WIDTH,
 	.yres = CFAG12864B_HEIGHT,
 	.xres_virtual = CFAG12864B_WIDTH,
@@ -114,7 +114,7 @@ none:
 	return ret;
 }
 
-static int cfag12864bfb_remove(struct platform_device *device)
+static int __devexit cfag12864bfb_remove(struct platform_device *device)
 {
 	struct fb_info *info = platform_get_drvdata(device);
 
@@ -128,7 +128,7 @@ static int cfag12864bfb_remove(struct pl
 
 static struct platform_driver cfag12864bfb_driver = {
 	.probe	= cfag12864bfb_probe,
-	.remove = cfag12864bfb_remove,
+	.remove = __devexit_p(cfag12864bfb_remove),
 	.driver = {
 		.name	= CFAG12864BFB_NAME,
 	},
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

linux-next.patch
auxdisplay-section-cleanup-in-cfag12864bfb-driver.patch

