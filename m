From: akpm@linux-foundation.org
Subject: [merged] backlight-ili922x-remove-unnecessary-oom-messages.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:33:28 -0700
Message-ID: <533f0908.VAAGFOEQ/QqJ4aYL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaDDTd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sbabic@denx.de, jg1.han@samsung.com

Subject: [merged] backlight-ili922x-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,sbabic@denx.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:28 -0700


The patch titled
     Subject: backlight: ili922x: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     backlight-ili922x-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ili922x: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Stefano Babic <sbabic@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili922x.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/backlight/ili922x.c~backlight-ili922x-remove-unnecessary-oom-messages drivers/video/backlight/ili922x.c
--- a/drivers/video/backlight/ili922x.c~backlight-ili922x-remove-unnecessary-oom-messages
+++ a/drivers/video/backlight/ili922x.c
@@ -482,10 +482,8 @@ static int ili922x_probe(struct spi_devi
 	u16 reg = 0;
 
 	ili = devm_kzalloc(&spi->dev, sizeof(*ili), GFP_KERNEL);
-	if (!ili) {
-		dev_err(&spi->dev, "cannot alloc priv data\n");
+	if (!ili)
 		return -ENOMEM;
-	}
 
 	ili->spi = spi;
 	spi_set_drvdata(spi, ili);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

