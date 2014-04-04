From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1390-remove-unnecessary-oom-messages.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:48 -0700
Message-ID: <533f0958.7A4QbZpbDREtiEQ4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbaDDTes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-ds1390-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:48 -0700


The patch titled
     Subject: rtc: rtc-ds1390: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1390-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1390: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1390.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-ds1390.c~rtc-rtc-ds1390-remove-unnecessary-oom-messages drivers/rtc/rtc-ds1390.c
--- a/drivers/rtc/rtc-ds1390.c~rtc-rtc-ds1390-remove-unnecessary-oom-messages
+++ a/drivers/rtc/rtc-ds1390.c
@@ -132,10 +132,9 @@ static int ds1390_probe(struct spi_devic
 	spi_setup(spi);
 
 	chip = devm_kzalloc(&spi->dev, sizeof(*chip), GFP_KERNEL);
-	if (!chip) {
-		dev_err(&spi->dev, "unable to allocate device memory\n");
+	if (!chip)
 		return -ENOMEM;
-	}
+
 	spi_set_drvdata(spi, chip);
 
 	res = ds1390_get_reg(&spi->dev, DS1390_REG_SECONDS, &tmp);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

