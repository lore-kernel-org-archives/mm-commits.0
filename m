From: akpm@linux-foundation.org
Subject: + drivers-leds-correct-__devexit-annotations.patch added to -mm tree
Date: Tue, 01 May 2012 15:33:32 -0700
Message-ID: <20120501223332.92E74A0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:53382 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2EAWde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 18:33:34 -0400
Received: by qabg24 with SMTP id g24so7366qab.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 15:33:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, mathieu.poirier@linaro.org


The patch titled
     Subject: drivers/leds: correct __devexit annotations
has been added to the -mm tree.  Its filename is
     drivers-leds-correct-__devexit-annotations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: drivers/leds: correct __devexit annotations

__devexit functions are discarded without CONFIG_HOTPLUG, so they need to
be referenced carefully.  A __devexit function may also not be called from
a __devinit function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
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
Subject: Subject: drivers/leds: correct __devexit annotations

Patches currently in -mm which might be from arnd@arndb.de are

linux-next.patch
drivers-leds-correct-__devexit-annotations.patch
rtc-spear-add-device-tree-probing-capability.patch
ramoops-use-pstore-interface.patch

