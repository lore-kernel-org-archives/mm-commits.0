From: akpm@linux-foundation.org
Subject: [merged] gpio-cs5535-gpio-fix-input-direction.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:25 -0800
Message-ID: <201003091911.o29JBP0b031738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756048Ab0CITW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gardner.ben@gmail.com, akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com, dbrownell@users.sourceforge.net, dilinger@collabora.co.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     gpio: cs5535-gpio: fix input direction
has been removed from the -mm tree.  Its filename was
     gpio-cs5535-gpio-fix-input-direction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: cs5535-gpio: fix input direction
From: Ben Gardner <gardner.ben@gmail.com>

The cs5535-gpio driver's get() function was returning the output value. 
This means that the GPIO pins would never work as an input, even if
configured as an input.

The driver should return the READ_BACK value, which is the sensed line
value.  To make that work when the direction is 'output', INPUT_ENABLE
needs to be set.

In addition, the driver was not disabling OUTPUT_ENABLE when the direction
is set to 'input'.  That would cause the GPIO to continue to drive the pin
if the direction was ever set to output.

This issue was noticed when attempting to use the gpiolib driver to read
an external input.  I had previously been using the char/cs5535-gpio
driver.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
Acked-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <stable@kernel.org>		[2.6.33.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/cs5535-gpio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/cs5535-gpio.c~gpio-cs5535-gpio-fix-input-direction drivers/gpio/cs5535-gpio.c
--- a/drivers/gpio/cs5535-gpio.c~gpio-cs5535-gpio-fix-input-direction
+++ a/drivers/gpio/cs5535-gpio.c
@@ -154,7 +154,7 @@ static int chip_gpio_request(struct gpio
 
 static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	return cs5535_gpio_isset(offset, GPIO_OUTPUT_VAL);
+	return cs5535_gpio_isset(offset, GPIO_READ_BACK);
 }
 
 static void chip_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
@@ -172,6 +172,7 @@ static int chip_direction_input(struct g
 
 	spin_lock_irqsave(&chip->lock, flags);
 	__cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
+	__cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_ENABLE);
 	spin_unlock_irqrestore(&chip->lock, flags);
 
 	return 0;
@@ -184,6 +185,7 @@ static int chip_direction_output(struct 
 
 	spin_lock_irqsave(&chip->lock, flags);
 
+	__cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
 	__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_ENABLE);
 	if (val)
 		__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_VAL);
_

Patches currently in -mm which might be from gardner.ben@gmail.com are


