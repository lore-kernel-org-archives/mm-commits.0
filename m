From: akpm@linux-foundation.org
Subject: + sm501-gpio-dynamic-registration-for-pci-devices.patch added to -mm tree
Date: Mon, 23 Jun 2008 21:05:04 -0700
Message-ID: <200806240405.m5O454Kn031883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbYFXEFp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 00:05:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apatard@mandriva.com, ben-linux@fluff.org, david-b@pacbell.net


The patch titled
     sm501: gpio dynamic registration for PCI devices
has been added to the -mm tree.  Its filename is
     sm501-gpio-dynamic-registration-for-pci-devices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501: gpio dynamic registration for PCI devices
From: Arnaud Patard <apatard@mandriva.com>

The SM501 PCI card requires a dyanmic gpio allocation as the number of
cards is not known at compile time.  Fixup the platform data and
registration to deal with this.

Acked-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Arnaud Patard <apatard@mandriva.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c   |    6 ++++--
 include/linux/sm501.h |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-gpio-dynamic-registration-for-pci-devices drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-gpio-dynamic-registration-for-pci-devices
+++ a/drivers/mfd/sm501.c
@@ -996,12 +996,13 @@ static int __devinit sm501_gpio_register
 {
 	struct sm501_platdata *pdata = sm->platdata;
 	struct gpio_chip *gchip = &chip->gpio;
-	unsigned base = pdata->gpio_base;
+	int base = pdata->gpio_base;
 
 	memcpy(chip, &gpio_chip_template, sizeof(struct gpio_chip));
 
 	if (chip == &gpio->high) {
-		base += 32;
+		if (base > 0)
+			base += 32;
 		chip->regbase = gpio->regs + SM501_GPIO_DATA_HIGH;
 		gchip->label  = "SM501-HIGH";
 	} else {
@@ -1452,6 +1453,7 @@ static struct sm501_platdata_fb sm501_fb
 static struct sm501_platdata sm501_pci_platdata = {
 	.init		= &sm501_pci_initdata,
 	.fb		= &sm501_fb_pdata,
+	.gpio_base	= -1,
 };
 
 static int sm501_pci_probe(struct pci_dev *dev,
diff -puN include/linux/sm501.h~sm501-gpio-dynamic-registration-for-pci-devices include/linux/sm501.h
--- a/include/linux/sm501.h~sm501-gpio-dynamic-registration-for-pci-devices
+++ a/include/linux/sm501.h
@@ -154,7 +154,7 @@ struct sm501_platdata {
 	struct sm501_platdata_fb	*fb;
 
 	int				 flags;
-	unsigned			 gpio_base;
+	int				 gpio_base;
 
 	int	(*get_power)(struct device *dev);
 	int	(*set_power)(struct device *dev, unsigned int on);
_

Patches currently in -mm which might be from apatard@mandriva.com are

sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch

