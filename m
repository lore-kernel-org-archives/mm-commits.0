From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:50:56 -0700
Message-ID: <201108161848.p7GIm3Kj015224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441Ab1HPSys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, jinyoungp@nvidia.com, rpurdie@rpsys.net, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/aat2870_bl.c: fix error checking for backlight_device_register
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/aat2870_bl.c: fix error checking for backlight_device_register
From: Axel Lin <axel.lin@gmail.com>

backlight_device_register() returns ERR_PTR() on error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Jin Park <jinyoungp@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/aat2870_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/aat2870_bl.c~drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register drivers/video/backlight/aat2870_bl.c
--- a/drivers/video/backlight/aat2870_bl.c~drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register
+++ a/drivers/video/backlight/aat2870_bl.c
@@ -158,10 +158,10 @@ static int aat2870_bl_probe(struct platf
 	props.type = BACKLIGHT_RAW;
 	bd = backlight_device_register("aat2870-backlight", &pdev->dev,
 				       aat2870_bl, &aat2870_bl_ops, &props);
-	if (!bd) {
+	if (IS_ERR(bd)) {
 		dev_err(&pdev->dev,
 			"Failed allocate memory for backlight device\n");
-		ret = -ENOMEM;
+		ret = PTR_ERR(bd);
 		goto out_kfree;
 	}
 
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

