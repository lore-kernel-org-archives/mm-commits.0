From: akpm@linux-foundation.org
Subject: + gpio-add-driver-for-basic-memory-mapped-gpio-controllers-fix.patch added to -mm tree
Date: Tue, 28 Sep 2010 14:29:20 -0700
Message-ID: <201009282129.o8SLTKSF018908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106Ab0I1VaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Sep 2010 17:30:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cbouatmailru@gmail.com, alan@lxorguk.ukuu.org.uk, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, sameo@linux.intel.com


The patch titled
     gpio-add-driver-for-basic-memory-mapped-gpio-controllers-fix
has been added to the -mm tree.  Its filename is
     gpio-add-driver-for-basic-memory-mapped-gpio-controllers-fix.patch

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
Subject: gpio-add-driver-for-basic-memory-mapped-gpio-controllers-fix
From: Anton Vorontsov <cbouatmailru@gmail.com>

On Fri, Sep 24, 2010 at 02:45:35PM -0700, Andrew Morton wrote:
> It would be good to document `bits' and `big_endian_bits', and to
> describe what `lock' locks.

Done.

> > +static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
> > +{
> > +	return 0;
> > +}
>
> hm, what does this mean.  The hardware cannot set pin directions to
> "in"?

Nope, 0 is the success. The hardware cannot set pin directions
at all (well, some hw can, but we don't support these yet).

> > +	return gpiochip_add(&bgc->gc);
> > +}
>
> If this function returns -EINVAL then much head-scratching will ensue.
> It might make your life easier to emit a diagnostic just before the
> failure so you can work out why it failed.

OK.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/basic_mmio_gpio.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff -puN drivers/gpio/basic_mmio_gpio.c~gpio-add-driver-for-basic-memory-mapped-gpio-controllers-fix drivers/gpio/basic_mmio_gpio.c
--- a/drivers/gpio/basic_mmio_gpio.c~gpio-add-driver-for-basic-memory-mapped-gpio-controllers-fix
+++ a/drivers/gpio/basic_mmio_gpio.c
@@ -66,12 +66,23 @@ struct bgpio_chip {
 	void __iomem *reg_dat;
 	void __iomem *reg_set;
 	void __iomem *reg_clr;
-	spinlock_t lock;
 
+	/* Number of bits (GPIOs): <register width> * 8. */
 	int bits;
+
+	/*
+	 * Some GPIO controllers work with the big-endian bits notation,
+	 * e.g. in a 8-bits register, GPIO7 is the least significant bit.
+	 */
 	int big_endian_bits;
 
-	/* shadowed data register to clear/set bits safely */
+	/*
+	 * Used to lock bgpio_chip->data. Also, this is needed to keep
+	 * shadowed and real data registers writes together.
+	 */
+	spinlock_t lock;
+
+	/* Shadowed data register to clear/set bits safely. */
 	unsigned long data;
 };
 
@@ -181,6 +192,7 @@ static int __devinit bgpio_probe(struct 
 	struct resource *res_clr;
 	resource_size_t dat_sz;
 	int bits;
+	int ret;
 
 	res_dat = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
 	if (!res_dat)
@@ -238,7 +250,11 @@ static int __devinit bgpio_probe(struct 
 
 	dev_set_drvdata(dev, bgc);
 
-	return gpiochip_add(&bgc->gc);
+	ret = gpiochip_add(&bgc->gc);
+	if (ret)
+		dev_err(dev, "gpiochip_add() failed: %d\n", ret);
+
+	return ret;
 }
 
 static int __devexit bgpio_remove(struct platform_device *pdev)
_

Patches currently in -mm which might be from cbouatmailru@gmail.com are

linux-next.patch
mtdpart-memory-accessor-interface-for-mtd-layer.patch
drivers-power-ds2782_batteryc-fix-ds2782-battery-driver-units.patch
gpio-add-driver-for-basic-memory-mapped-gpio-controllers.patch
gpio-add-driver-for-basic-memory-mapped-gpio-controllers-fix.patch
gpiolib-fix-have_gpio_lib-leftovers-in-asm-generic-gpioh.patch

