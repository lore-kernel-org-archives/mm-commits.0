From: akpm@linux-foundation.org
Subject: + gpio-pl061-fix-irq-handling-for-gpios-=-pl061_gpio_nr.patch added to -mm tree
Date: Fri, 26 Jun 2009 14:27:51 -0700
Message-ID: <200906262127.n5QLRpop018227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219AbZFZV2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 17:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: baruch@tkos.co.il, david-b@pacbell.net


The patch titled
     gpio: pl061: fix IRQ handling for GPIOs >= PL061_GPIO_NR
has been added to the -mm tree.  Its filename is
     gpio-pl061-fix-irq-handling-for-gpios-=-pl061_gpio_nr.patch

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
Subject: gpio: pl061: fix IRQ handling for GPIOs >= PL061_GPIO_NR
From: Baruch Siach <baruch@tkos.co.il>

IRQ handling is wrong for any GPIO >= PL061_GPIO_NR.

Fix this by implementing and using a proper .to_irq method.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pl061.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN drivers/gpio/pl061.c~gpio-pl061-fix-irq-handling-for-gpios-=-pl061_gpio_nr drivers/gpio/pl061.c
--- a/drivers/gpio/pl061.c~gpio-pl061-fix-irq-handling-for-gpios-=-pl061_gpio_nr
+++ a/drivers/gpio/pl061.c
@@ -109,6 +109,16 @@ static void pl061_set_value(struct gpio_
 	writeb(!!value << offset, chip->base + (1 << (offset + 2)));
 }
 
+static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+
+	if (chip->irq_base == (unsigned) -1)
+		return -EINVAL;
+
+	return chip->irq_base + offset;
+}
+
 /*
  * PL061 GPIO IRQ
  */
@@ -200,7 +210,7 @@ static void pl061_irq_handler(unsigned i
 	desc->chip->ack(irq);
 	list_for_each(ptr, chip_list) {
 		unsigned long pending;
-		int gpio;
+		int offset;
 
 		chip = list_entry(ptr, struct pl061_gpio, list);
 		pending = readb(chip->base + GPIOMIS);
@@ -209,8 +219,8 @@ static void pl061_irq_handler(unsigned i
 		if (pending == 0)
 			continue;
 
-		for_each_bit(gpio, &pending, PL061_GPIO_NR)
-			generic_handle_irq(gpio_to_irq(gpio));
+		for_each_bit(offset, &pending, PL061_GPIO_NR)
+			generic_handle_irq(pl061_to_irq(&chip->gc, offset));
 	}
 	desc->chip->unmask(irq);
 }
@@ -251,6 +261,7 @@ static int __init pl061_probe(struct amb
 	chip->gc.direction_output = pl061_direction_output;
 	chip->gc.get = pl061_get_value;
 	chip->gc.set = pl061_set_value;
+	chip->gc.to_irq = pl061_to_irq;
 	chip->gc.base = pdata->gpio_base;
 	chip->gc.ngpio = PL061_GPIO_NR;
 	chip->gc.label = dev_name(&dev->dev);
_

Patches currently in -mm which might be from baruch@tkos.co.il are

origin.patch
linux-next.patch
gpio-pl061-fix-probe-error-handling-code.patch
gpio-pl061-fix-irq-handling-for-gpios-=-pl061_gpio_nr.patch

