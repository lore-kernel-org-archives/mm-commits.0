From: akpm@linux-foundation.org
Subject: - fb-s3c2410-check-default_display-parameter-passed-in-platform-data.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:29 -0800
Message-ID: <200802070029.m170TAhZ007254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45243 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935070AbYBGAos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, adaplas@pol.net, vince@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     FB/S3C2410: check default_display parameter passed in platform data
has been removed from the -mm tree.  Its filename was
     fb-s3c2410-check-default_display-parameter-passed-in-platform-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-mtd.patch
