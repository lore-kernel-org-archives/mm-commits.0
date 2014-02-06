From: akpm@linux-foundation.org
Subject: + backlight-lm3533_bl-remove-unnecessary-oom-messages.patch added to -mm tree
Date: Thu, 06 Feb 2014 14:02:52 -0800
Message-ID: <52f4068c.VwrDgoJr36TDnrRM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaBFWCx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Feb 2014 17:02:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jhovold@gmail.com, jg1.han@samsung.com

Subject: + backlight-lm3533_bl-remove-unnecessary-oom-messages.patch added to -mm tree
To: jg1.han@samsung.com,jhovold@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 06 Feb 2014 14:02:52 -0800


The patch titled
     Subject: backlight: lm3533_bl: remove unnecessary OOM messages
has been added to the -mm tree.  Its filename is
     backlight-lm3533_bl-remove-unnecessary-oom-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-lm3533_bl-remove-unnecessary-oom-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-lm3533_bl-remove-unnecessary-oom-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lm3533_bl: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3533_bl.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/video/backlight/lm3533_bl.c~backlight-lm3533_bl-remove-unnecessary-oom-messages drivers/video/backlight/lm3533_bl.c
--- a/drivers/video/backlight/lm3533_bl.c~backlight-lm3533_bl-remove-unnecessary-oom-messages
+++ a/drivers/video/backlight/lm3533_bl.c
@@ -296,11 +296,8 @@ static int lm3533_bl_probe(struct platfo
 	}
 
 	bl = devm_kzalloc(&pdev->dev, sizeof(*bl), GFP_KERNEL);
-	if (!bl) {
-		dev_err(&pdev->dev,
-				"failed to allocate memory for backlight\n");
+	if (!bl)
 		return -ENOMEM;
-	}
 
 	bl->lm3533 = lm3533;
 	bl->id = pdev->id;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

backlight-update-bd-state-fb_blank-properties-when-necessary.patch
backlight-update-backlight-status-when-necessary.patch
backlight-aat2870-remove-unnecessary-oom-messages.patch
backlight-adp8860-remove-unnecessary-oom-messages.patch
backlight-adp8870-remove-unnecessary-oom-messages.patch
backlight-corgi_lcd-remove-unnecessary-oom-messages.patch
backlight-hx8357-remove-unnecessary-oom-messages.patch
backlight-ili922x-remove-unnecessary-oom-messages.patch
backlight-ili9320-remove-unnecessary-oom-messages.patch
backlight-l4f00242t03-remove-unnecessary-oom-messages.patch
backlight-lm3533_bl-remove-unnecessary-oom-messages.patch
backlight-lms283gf05-remove-unnecessary-oom-messages.patch
backlight-platform_lcd-remove-unnecessary-oom-messages.patch
backlight-tps65217_bl-remove-unnecessary-oom-messages.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

