From: akpm@linux-foundation.org
Subject: [merged] drivers-block-sx8c-use-module_pci_driver.patch removed
 from -mm tree
Date: Thu, 23 Jan 2014 12:42:38 -0800
Message-ID: <52e17ebe.NofYPY42q7u4QAX6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaAWUmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 15:42:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, jg1.han@samsung.com

Subject: [merged] drivers-block-sx8c-use-module_pci_driver.patch removed from -mm tree
To: jg1.han@samsung.com,axboe@kernel.dk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 12:42:38 -0800


The patch titled
     Subject: drivers/block/sx8.c: use module_pci_driver()
has been removed from the -mm tree.  Its filename was
     drivers-block-sx8c-use-module_pci_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/block/sx8.c: use module_pci_driver()

Use module_pci_driver() macro which makes the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/sx8.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff -puN drivers/block/sx8.c~drivers-block-sx8c-use-module_pci_driver drivers/block/sx8.c
--- a/drivers/block/sx8.c~drivers-block-sx8c-use-module_pci_driver
+++ a/drivers/block/sx8.c
@@ -1747,17 +1747,4 @@ static void carm_remove_one (struct pci_
 	pci_set_drvdata(pdev, NULL);
 }
 
-static int __init carm_init(void)
-{
-	return pci_register_driver(&carm_driver);
-}
-
-static void __exit carm_exit(void)
-{
-	pci_unregister_driver(&carm_driver);
-}
-
-module_init(carm_init);
-module_exit(carm_exit);
-
-
+module_pci_driver(carm_driver);
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

