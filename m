From: akpm@linux-foundation.org
Subject: - s3c2410fb-make-use-of-default_display-settings.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:45 -0700
Message-ID: <200710162043.l9GKhjUD016080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763337AbXJPVHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3c2410fb: make use of default_display settings
has been removed from the -mm tree.  Its filename was
     s3c2410fb-make-use-of-default_display-settings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3c2410fb: make use of default_display settings
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch changes mode selection to always prefer default mode if possible
and always honor type of display set by default mode settings.

This patch is required in case the same display modes were defined for
different panels (e.g.  STN and TFT).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-make-use-of-default_display-settings drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-make-use-of-default_display-settings
+++ a/drivers/video/s3c2410fb.c
@@ -172,19 +172,28 @@ static int s3c2410fb_check_var(struct fb
 	struct s3c2410fb_info *fbi = info->par;
 	struct s3c2410fb_mach_info *mach_info = fbi->dev->platform_data;
 	struct s3c2410fb_display *display = NULL;
+	struct s3c2410fb_display *default_display = mach_info->displays +
+						    mach_info->default_display;
+	int type = default_display->type;
 	unsigned i;
 
 	dprintk("check_var(var=%p, info=%p)\n", var, info);
 
 	/* validate x/y resolution */
-
-	for (i = 0; i < mach_info->num_displays; i++)
-		if (var->yres == mach_info->displays[i].yres &&
-		    var->xres == mach_info->displays[i].xres &&
-		    var->bits_per_pixel == mach_info->displays[i].bpp) {
-			display = mach_info->displays + i;
-			break;
-		}
+	/* choose default mode if possible */
+	if (var->yres == default_display->yres &&
+	    var->xres == default_display->xres &&
+	    var->bits_per_pixel == default_display->bpp)
+		display = default_display;
+	else
+		for (i = 0; i < mach_info->num_displays; i++)
+			if (type == mach_info->displays[i].type &&
+			    var->yres == mach_info->displays[i].yres &&
+			    var->xres == mach_info->displays[i].xres &&
+			    var->bits_per_pixel == mach_info->displays[i].bpp) {
+				display = mach_info->displays + i;
+				break;
+			}
 
 	if (!display) {
 		dprintk("wrong resolution or depth %dx%d at %d bpp\n",
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
