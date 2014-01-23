From: akpm@linux-foundation.org
Subject: [merged]
 drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch removed from
 -mm tree
Date: Thu, 23 Jan 2014 12:42:40 -0800
Message-ID: <52e17ec0.S56u/qW5j/9Ejo6a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaAWUmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 15:42:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, jg1.han@samsung.com

Subject: [merged] drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch removed from -mm tree
To: jg1.han@samsung.com,axboe@kernel.dk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 12:42:40 -0800


The patch titled
     Subject: drivers/block/sx8.c: remove unnecessary pci_set_drvdata()
has been removed from the -mm tree.  Its filename was
     drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/block/sx8.c: remove unnecessary pci_set_drvdata()

The driver core clears the driver data to NULL after device_release or on
probe failure.  Thus, it is not needed to manually clear the device driver
data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/sx8.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/block/sx8.c~drivers-block-sx8c-remove-unnecessary-pci_set_drvdata drivers/block/sx8.c
--- a/drivers/block/sx8.c~drivers-block-sx8c-remove-unnecessary-pci_set_drvdata
+++ a/drivers/block/sx8.c
@@ -1744,7 +1744,6 @@ static void carm_remove_one (struct pci_
 	kfree(host);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 }
 
 module_pci_driver(carm_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-remove-unnecessary-exynos-dp-driver-f-pattern.patch
backlight-jornada720-use-devm_backlight_device_register.patch
backlight-hp680_bl-use-devm_backlight_device_register.patch
backlight-omap1-use-devm_backlight_device_register.patch
backlight-ot200_bl-use-devm_backlight_device_register.patch
backlight-tosa-use-devm_backlight_device_register.patch
backlight-jornada720-use-devm_lcd_device_register.patch
backlight-l4f00242t03-use-devm_lcd_device_register.patch
backlight-tosa-use-devm_lcd_device_register.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker.patch
backlight-lp855x-remove-unnecessary-parentheses.patch
backlight-lp8788-remove-unnecessary-parentheses.patch
drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch
rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch
backlight-lcd-call-put_device-if-device_register-fails.patch

