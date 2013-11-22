From: akpm@linux-foundation.org
Subject: + drivers-w1-masters-w1-gpioc-add-strong-pullup-emulation.patch
 added to -mm tree
Date: Fri, 22 Nov 2013 14:16:57 -0800
Message-ID: <528fd7d9.dNHuqPS2xOJJeKy7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3KVWQ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 17:16:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zbr@ioremap.net, greg@kroah.com, david@fries.net, boger@contactless.ru

Subject: + drivers-w1-masters-w1-gpioc-add-strong-pullup-emulation.patch added to -mm tree
To: boger@contactless.ru,david@fries.net,greg@kroah.com,zbr@ioremap.net
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 14:16:57 -0800


The patch titled
     Subject: drivers/w1/masters/w1-gpio.c: add strong pullup emulation
has been added to the -mm tree.  Its filename is
     drivers-w1-masters-w1-gpioc-add-strong-pullup-emulation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-w1-masters-w1-gpioc-add-strong-pullup-emulation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-w1-masters-w1-gpioc-add-strong-pullup-emulation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Evgeny Boger <boger@contactless.ru>
Subject: drivers/w1/masters/w1-gpio.c: add strong pullup emulation

Strong pullup is emulated by driving pin logic high after write command
when using tri-state push-pull GPIO.

Signed-off-by: Evgeny Boger <boger@contactless.ru>
Cc: Greg KH <greg@kroah.com>
Acked-by: David Fries <david@fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/w1-gpio.c |   22 ++++++++++++++++++++++
 drivers/w1/w1_int.c          |   12 ------------
 include/linux/w1-gpio.h      |    1 +
 3 files changed, 23 insertions(+), 12 deletions(-)

diff -puN drivers/w1/masters/w1-gpio.c~drivers-w1-masters-w1-gpioc-add-strong-pullup-emulation drivers/w1/masters/w1-gpio.c
--- a/drivers/w1/masters/w1-gpio.c~drivers-w1-masters-w1-gpioc-add-strong-pullup-emulation
+++ a/drivers/w1/masters/w1-gpio.c
@@ -18,10 +18,31 @@
 #include <linux/of_gpio.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/delay.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
 
+static u8 w1_gpio_set_pullup(void *data, int delay)
+{
+	struct w1_gpio_platform_data *pdata = data;
+
+	if (delay) {
+		pdata->pullup_duration = delay;
+	} else {
+		if (pdata->pullup_duration) {
+			gpio_direction_output(pdata->pin, 1);
+
+			msleep(pdata->pullup_duration);
+
+			gpio_direction_input(pdata->pin);
+		}
+		pdata->pullup_duration = 0;
+	}
+
+	return 0;
+}
+
 static void w1_gpio_write_bit_dir(void *data, u8 bit)
 {
 	struct w1_gpio_platform_data *pdata = data;
@@ -132,6 +153,7 @@ static int w1_gpio_probe(struct platform
 	} else {
 		gpio_direction_input(pdata->pin);
 		master->write_bit = w1_gpio_write_bit_dir;
+		master->set_pullup = w1_gpio_set_pullup;
 	}
 
 	err = w1_add_master_device(master);
diff -puN drivers/w1/w1_int.c~drivers-w1-masters-w1-gpioc-add-strong-pullup-emulation drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c~drivers-w1-masters-w1-gpioc-add-strong-pullup-emulation
+++ a/drivers/w1/w1_int.c
@@ -117,18 +117,6 @@ int w1_add_master_device(struct w1_bus_m
 		printk(KERN_ERR "w1_add_master_device: invalid function set\n");
 		return(-EINVAL);
         }
-	/* While it would be electrically possible to make a device that
-	 * generated a strong pullup in bit bang mode, only hardware that
-	 * controls 1-wire time frames are even expected to support a strong
-	 * pullup.  w1_io.c would need to support calling set_pullup before
-	 * the last write_bit operation of a w1_write_8 which it currently
-	 * doesn't.
-	 */
-	if (!master->write_byte && !master->touch_bit && master->set_pullup) {
-		printk(KERN_ERR "w1_add_master_device: set_pullup requires "
-			"write_byte or touch_bit, disabling\n");
-		master->set_pullup = NULL;
-	}
 
 	/* Lock until the device is added (or not) to w1_masters. */
 	mutex_lock(&w1_mlock);
diff -puN include/linux/w1-gpio.h~drivers-w1-masters-w1-gpioc-add-strong-pullup-emulation include/linux/w1-gpio.h
--- a/include/linux/w1-gpio.h~drivers-w1-masters-w1-gpioc-add-strong-pullup-emulation
+++ a/include/linux/w1-gpio.h
@@ -20,6 +20,7 @@ struct w1_gpio_platform_data {
 	unsigned int is_open_drain:1;
 	void (*enable_external_pullup)(int enable);
 	unsigned int ext_pullup_enable_pin;
+	unsigned int pullup_duration;
 };
 
 #endif /* _LINUX_W1_GPIO_H */
_

Patches currently in -mm which might be from boger@contactless.ru are

drivers-w1-masters-w1-gpioc-add-strong-pullup-emulation.patch

