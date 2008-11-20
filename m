From: akpm@linux-foundation.org
Subject: - drivers-video-backlight-da903xc-introduce-one-more-missing-kfree.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:43:30 -0800
Message-ID: <200811202043.mAKKhUTg007550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430AbYKTUoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:44:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@compulab.co.il, eric.miao@marvell.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/da903x.c: introduce one more missing kfree
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-da903xc-introduce-one-more-missing-kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/da903x.c: introduce one more missing kfree
From: Mike Rapoport [mailto:mike@compulab.co.il]

One more error handling code should have kfree as well

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Acked-by: Eric Miao <eric.miao@marvell.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/da903x.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/backlight/da903x.c~drivers-video-backlight-da903xc-introduce-one-more-missing-kfree drivers/video/backlight/da903x.c
--- a/drivers/video/backlight/da903x.c~drivers-video-backlight-da903xc-introduce-one-more-missing-kfree
+++ a/drivers/video/backlight/da903x.c
@@ -131,6 +131,7 @@ static int da903x_backlight_probe(struct
 			data, &da903x_backlight_ops);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
+		kfree(data);
 		return PTR_ERR(bl);
 	}
 
_

Patches currently in -mm which might be from mike@compulab.co.il are

origin.patch

