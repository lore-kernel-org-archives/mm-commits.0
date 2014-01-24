From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:02:28 -0800
Message-ID: <52e2b8c4.ORORr0uq9pRNOvLS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaAXTC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:28 -0800


The patch titled
     Subject: drivers/rtc/rtc-ds1305.c: remove unnecessary spi_set_drvdata()
has been removed from the -mm tree.  Its filename was
     rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-ds1305.c: remove unnecessary spi_set_drvdata()

The driver core clears the driver data to NULL after device_release or on
probe failure.  Thus, it is not needed to manually clear the device driver
data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1305.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1305.c~rtc-ds1305-remove-unnecessary-spi_set_drvdata drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~rtc-ds1305-remove-unnecessary-spi_set_drvdata
+++ a/drivers/rtc/rtc-ds1305.c
@@ -787,7 +787,6 @@ static int ds1305_remove(struct spi_devi
 		cancel_work_sync(&ds1305->work);
 	}
 
-	spi_set_drvdata(spi, NULL);
 	return 0;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch
backlight-lcd-call-put_device-if-device_register-fails.patch

