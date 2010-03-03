From: akpm@linux-foundation.org
Subject: [to-be-updated] cs5535_gpio-gpio_chipget-should-return-the-input-value.patch removed from -mm tree
Date: Tue, 02 Mar 2010 16:01:18 -0800
Message-ID: <201003030001.o2301IW7005808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884Ab0CCABX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 19:01:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gardner.ben@gmail.com, dilinger@collabora.co.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cs5535_gpio: gpio_chip.get should return the input value
has been removed from the -mm tree.  Its filename was
     cs5535_gpio-gpio_chipget-should-return-the-input-value.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cs5535_gpio: gpio_chip.get should return the input value
From: Ben Gardner <gardner.ben@gmail.com>

The gpio_chip.get() function for the CS5535 GPIO driver currently returns
the output value instead of the input value.  This patch changes it to
return the input value.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
Cc: Andres Salomon <dilinger@collabora.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/cs5535-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/cs5535-gpio.c~cs5535_gpio-gpio_chipget-should-return-the-input-value drivers/gpio/cs5535-gpio.c
--- a/drivers/gpio/cs5535-gpio.c~cs5535_gpio-gpio_chipget-should-return-the-input-value
+++ a/drivers/gpio/cs5535-gpio.c
@@ -154,7 +154,7 @@ static int chip_gpio_request(struct gpio
 
 static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	return cs5535_gpio_isset(offset, GPIO_OUTPUT_VAL);
+	return cs5535_gpio_isset(offset, GPIO_READ_BACK);
 }
 
 static void chip_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
_

Patches currently in -mm which might be from gardner.ben@gmail.com are

origin.patch
gpio-cs5535-gpio-fix-input-direction.patch
cs5535_gpio-gpio_chipget-should-return-the-input-value.patch

