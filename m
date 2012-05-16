From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-correct-__devexit-annotations.patch removed from -mm tree
Date: Wed, 16 May 2012 11:46:57 -0700
Message-ID: <20120516184657.51764A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:63523 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760343Ab2EPSq7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:46:59 -0400
Received: by lbbgp10 with SMTP id gp10so57552lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:46:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bryan.wu@canonical.com, mathieu.poirier@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds: correct __devexit annotations
has been removed from the -mm tree.  Its filename was
     drivers-leds-correct-__devexit-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: drivers/leds: correct __devexit annotations

__devexit functions are discarded without CONFIG_HOTPLUG, so they need to
be referenced carefully.  A __devexit function may also not be called from
a __devinit function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-netxbig.c |    4 ++--
 drivers/leds/leds-ns2.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/leds/leds-netxbig.c~drivers-leds-correct-__devexit-annotations drivers/leds/leds-netxbig.c
--- a/drivers/leds/leds-netxbig.c~drivers-leds-correct-__devexit-annotations
+++ a/drivers/leds/leds-netxbig.c
@@ -112,7 +112,7 @@ err_free_addr:
 	return err;
 }
 
-static void __devexit gpio_ext_free(struct netxbig_gpio_ext *gpio_ext)
+static void gpio_ext_free(struct netxbig_gpio_ext *gpio_ext)
 {
 	int i;
 
@@ -294,7 +294,7 @@ static ssize_t netxbig_led_sata_show(str
 
 static DEVICE_ATTR(sata, 0644, netxbig_led_sata_show, netxbig_led_sata_store);
 
-static void __devexit delete_netxbig_led(struct netxbig_led_data *led_dat)
+static void delete_netxbig_led(struct netxbig_led_data *led_dat)
 {
 	if (led_dat->mode_val[NETXBIG_LED_SATA] != NETXBIG_LED_INVALID_MODE)
 		device_remove_file(led_dat->cdev.dev, &dev_attr_sata);
diff -puN drivers/leds/leds-ns2.c~drivers-leds-correct-__devexit-annotations drivers/leds/leds-ns2.c
--- a/drivers/leds/leds-ns2.c~drivers-leds-correct-__devexit-annotations
+++ a/drivers/leds/leds-ns2.c
@@ -255,7 +255,7 @@ err_free_cmd:
 	return ret;
 }
 
-static void __devexit delete_ns2_led(struct ns2_led_data *led_dat)
+static void delete_ns2_led(struct ns2_led_data *led_dat)
 {
 	device_remove_file(led_dat->cdev.dev, &dev_attr_sata);
 	led_classdev_unregister(&led_dat->cdev);
_

Patches currently in -mm which might be from arnd@arndb.de are

linux-next.patch
backlight-add-lm3533-backlight-driver.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
leds-add-lm3533-led-driver.patch
rtc-spear-add-device-tree-probing-capability.patch
drivers-rtc-rtc-lpc32xxc-add-device-tree-support.patch
ramoops-use-pstore-interface.patch

