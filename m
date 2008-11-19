From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-da903xc-introduce-one-more-missing-kfree.patch added to -mm tree
Date: Wed, 19 Nov 2008 01:13:53 -0800
Message-ID: <200811190913.mAJ9Drdk002754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbYKSJOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 04:14:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike@compulab.co.il, eric.miao@marvell.com, rpurdie@rpsys.net


The patch titled
     drivers/video/backlight/da903x.c: introduce one more missing kfree
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-da903xc-introduce-one-more-missing-kfree.patch

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

drivers-video-backlight-da903xc-introduce-missing-kfree.patch
drivers-video-backlight-da903xc-introduce-one-more-missing-kfree.patch

