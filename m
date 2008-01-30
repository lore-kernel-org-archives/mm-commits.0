From: akpm@linux-foundation.org
Subject: + fb-s3c2410-check-default_display-parameter-passed-in-platform-data.patch added to -mm tree
Date: Tue, 29 Jan 2008 17:46:11 -0800
Message-ID: <200801300145.m0U1jqsG014966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57496 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbYA3Bqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 20:46:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, adaplas@pol.net, vince@simtec.co.uk


The patch titled
     FB/S3C2410: check default_display parameter passed in platform data
has been added to the -mm tree.  Its filename is
     fb-s3c2410-check-default_display-parameter-passed-in-platform-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: FB/S3C2410: check default_display parameter passed in platform data
From: Ben Dooks <ben-linux@fluff.org>

Ensure that the default display parameter passed in via the
device's platform data is valid. It turns out when mach-bast.c
was updated, the default_display was set outside of the display
array bounds, causing a panic on startup.

If the default_display is bigger than num_displays, then generate
an error and refuse to initialise the driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Vincent Sanders <vince@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/video/s3c2410fb.c~fb-s3c2410-check-default_display-parameter-passed-in-platform-data drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~fb-s3c2410-check-default_display-parameter-passed-in-platform-data
+++ a/drivers/video/s3c2410fb.c
@@ -817,6 +817,12 @@ static int __init s3c24xxfb_probe(struct
 		return -EINVAL;
 	}
 
+	if (mach_info->default_display >= mach_info->num_displays) {
+		dev_err(&pdev->dev, "default is %d but only %d displays\n",
+			mach_info->default_display, mach_info->num_displays);
+		return -EINVAL;
+	}
+
 	display = mach_info->displays + mach_info->default_display;
 
 	irq = platform_get_irq(pdev, 0);
_

Patches currently in -mm which might be from ben-linux@fluff.org are

git-alsa.patch
git-arm.patch
git-mtd.patch
spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
fb-sm501-ensure-console-suspended-before-saving-state.patch
fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver.patch
fb-s3c2410-update-debugging-in-s3c2410-framebuffer-driver.patch
fb-s3c2410-ensure-s3c2410-framebuffer-clears-initial-memory-to-black.patch
fb-s3c2410-check-default_display-parameter-passed-in-platform-data.patch
