From: akpm@linux-foundation.org
Subject: + backlight-lms283gf05-remove-unnecessary-oom-messages.patch
 added to -mm tree
Date: Thu, 06 Feb 2014 14:02:53 -0800
Message-ID: <52f4068d.VUOWNr6VHD6wO4hu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaBFWCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Feb 2014 17:02:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, marex@denx.de, jg1.han@samsung.com

Subject: + backlight-lms283gf05-remove-unnecessary-oom-messages.patch added to -mm tree
To: jg1.han@samsung.com,marex@denx.de
From: akpm@linux-foundation.org
Date: Thu, 06 Feb 2014 14:02:53 -0800


The patch titled
     Subject: backlight: lms283gf05: remove unnecessary OOM messages
has been added to the -mm tree.  Its filename is
     backlight-lms283gf05-remove-unnecessary-oom-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-lms283gf05-remove-unnecessary-oom-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-lms283gf05-remove-unnecessary-oom-messages.patch

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
Subject: backlight: lms283gf05: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Marek Vasut <marex@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms283gf05.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-remove-unnecessary-oom-messages drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-remove-unnecessary-oom-messages
+++ a/drivers/video/backlight/lms283gf05.c
@@ -168,10 +168,8 @@ static int lms283gf05_probe(struct spi_d
 
 	st = devm_kzalloc(&spi->dev, sizeof(struct lms283gf05_state),
 				GFP_KERNEL);
-	if (st == NULL) {
-		dev_err(&spi->dev, "No memory for device state\n");
+	if (st == NULL)
 		return -ENOMEM;
-	}
 
 	ld = devm_lcd_device_register(&spi->dev, "lms283gf05", &spi->dev, st,
 					&lms_ops);
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

