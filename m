From: akpm@linux-foundation.org
Subject: + cs5535_gpio-gpio_chipget-should-return-the-input-value.patch added to -mm tree
Date: Wed, 24 Feb 2010 14:58:20 -0800
Message-ID: <201002242258.o1OMwKqS025467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758450Ab0BXW66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 17:58:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gardner.ben@gmail.com, dilinger@collabora.co.uk


The patch titled
     cs5535_gpio: gpio_chip.get should return the input value
has been added to the -mm tree.  Its filename is
     cs5535_gpio-gpio_chipget-should-return-the-input-value.patch

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

cs5535_gpio-gpio_chipget-should-return-the-input-value.patch

