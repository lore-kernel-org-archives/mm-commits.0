From: akpm@linux-foundation.org
Subject: [merged]
 backlight-corgi_lcd-remove-unnecessary-oom-messages.patch removed from -mm
 tree
Date: Fri, 04 Apr 2014 12:33:24 -0700
Message-ID: <533f0904.09epedBpiyTcHMZa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaDDTdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-corgi_lcd-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:24 -0700


The patch titled
     Subject: backlight: corgi_lcd: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     backlight-corgi_lcd-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: corgi_lcd: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/corgi_lcd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-remove-unnecessary-oom-messages drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-remove-unnecessary-oom-messages
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -543,10 +543,8 @@ static int corgi_lcd_probe(struct spi_de
 	}
 
 	lcd = devm_kzalloc(&spi->dev, sizeof(struct corgi_lcd), GFP_KERNEL);
-	if (!lcd) {
-		dev_err(&spi->dev, "failed to allocate memory\n");
+	if (!lcd)
 		return -ENOMEM;
-	}
 
 	lcd->spi_dev = spi;
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

