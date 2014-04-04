From: akpm@linux-foundation.org
Subject: [merged] backlight-ili9320-remove-unnecessary-oom-messages.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:33:30 -0700
Message-ID: <533f090a.EhfwPIw8i8/hWNGk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaDDTda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-ili9320-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:30 -0700


The patch titled
     Subject: backlight: ili9320: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     backlight-ili9320-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ili9320: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili9320.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/backlight/ili9320.c~backlight-ili9320-remove-unnecessary-oom-messages drivers/video/backlight/ili9320.c
--- a/drivers/video/backlight/ili9320.c~backlight-ili9320-remove-unnecessary-oom-messages
+++ a/drivers/video/backlight/ili9320.c
@@ -219,10 +219,8 @@ int ili9320_probe_spi(struct spi_device
 	/* allocate and initialse our state */
 
 	ili = devm_kzalloc(&spi->dev, sizeof(struct ili9320), GFP_KERNEL);
-	if (ili == NULL) {
-		dev_err(dev, "no memory for device\n");
+	if (ili == NULL)
 		return -ENOMEM;
-	}
 
 	ili->access.spi.id = ILI9320_SPI_IDCODE | ILI9320_SPI_ID(1);
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

