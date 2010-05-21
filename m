From: akpm@linux-foundation.org
Subject: + drivers-gpio-it8761e_gpio-check-return-value-of-gpiochip_remove.patch added to -mm tree
Date: Fri, 21 May 2010 12:21:57 -0700
Message-ID: <201005211921.o4LJLvUF029556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934093Ab0EUTWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 15:22:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, denis@compulab.co.il


The patch titled
     drivers/gpio/it8761e_gpio: check return value of gpiochip_remove()
has been added to the -mm tree.  Its filename is
     drivers-gpio-it8761e_gpio-check-return-value-of-gpiochip_remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpio/it8761e_gpio: check return value of gpiochip_remove()
From: Daniel Mack <daniel@caiaq.de>

This eliminates the following build warning:

drivers/gpio/it8761e_gpio.c: In function `it8761e_gpio_exit':
drivers/gpio/it8761e_gpio.c:220: warning: ignoring return value of `gpiochip_remove', declared with attribute warn_unused_result

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Denis Turischev <denis@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/it8761e_gpio.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/it8761e_gpio.c~drivers-gpio-it8761e_gpio-check-return-value-of-gpiochip_remove drivers/gpio/it8761e_gpio.c
--- a/drivers/gpio/it8761e_gpio.c~drivers-gpio-it8761e_gpio-check-return-value-of-gpiochip_remove
+++ a/drivers/gpio/it8761e_gpio.c
@@ -217,7 +217,10 @@ gpiochip_add_err:
 static void __exit it8761e_gpio_exit(void)
 {
 	if (gpio_ba) {
-		gpiochip_remove(&it8761e_gpio_chip);
+		int ret = gpiochip_remove(&it8761e_gpio_chip);
+
+		WARN(ret, "%s(): gpiochip_remove() failed, ret=%d\n",
+				__func__, ret);
 
 		release_region(gpio_ba, GPIO_IOSIZE);
 		gpio_ba = 0;
_

Patches currently in -mm which might be from daniel@caiaq.de are

origin.patch
linux-next.patch
lis3-add-missing-constants-for-8bit-device.patch
lis3-separate-configuration-function-for-8-bit-device.patch
lis3-introduce-platform-data-for-second-ff-wu-unit.patch
lis3-add-skeletons-for-interrupt-handlers.patch
lis3-interrupt-handlers-for-8bit-wakeup-and-click-events.patch
lis3-setup-poll-interval-limits.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
drivers-gpio-it8761e_gpio-check-return-value-of-gpiochip_remove.patch

