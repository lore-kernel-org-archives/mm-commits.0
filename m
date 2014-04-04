From: akpm@linux-foundation.org
Subject: [merged]
 backlight-lms283gf05-remove-unnecessary-oom-messages.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:33:36 -0700
Message-ID: <533f0910.RnniwiGmPwa0RP+W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaDDTdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, marex@denx.de, jg1.han@samsung.com

Subject: [merged] backlight-lms283gf05-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,marex@denx.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:36 -0700


The patch titled
     Subject: backlight: lms283gf05: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     backlight-lms283gf05-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

