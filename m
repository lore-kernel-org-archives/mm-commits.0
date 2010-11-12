From: akpm@linux-foundation.org
Subject: + drivers-gpio-cs5535-gpioc-add-some-additional-cs5535-specific-gpio-functionality.patch added to -mm tree
Date: Fri, 12 Nov 2010 13:27:22 -0800
Message-ID: <201011122127.oACLRMEC032519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757325Ab0KLV11 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 16:27:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, greg@kroah.com


The patch titled
     drivers/gpio/cs5535-gpio.c: add some additional cs5535-specific GPIO functionality
has been added to the -mm tree.  Its filename is
     drivers-gpio-cs5535-gpioc-add-some-additional-cs5535-specific-gpio-functionality.patch

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
Subject: drivers/gpio/cs5535-gpio.c: add some additional cs5535-specific GPIO functionality
From: Andres Salomon <dilinger@queued.net>

This adds (well, re-adds actually) handling for events/IRQs through cs5535
GPIOs.  In the wild and wooly world of CS5535, setup_event() is for
assigning an IRQ to a GPIO filter/event pair, and set_irq() sets up the
pair to trigger IRQs.

These should really only be used in highly platform-specific drivers (such
as OLPC's DCON driver).  Sadly, because set_irq() uses MSRs, this causes
the driver to become X86-specific.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig       |    2 -
 drivers/gpio/cs5535-gpio.c |   52 +++++++++++++++++++++++++++++++++++
 include/linux/cs5535.h     |    2 +
 3 files changed, 55 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/Kconfig~drivers-gpio-cs5535-gpioc-add-some-additional-cs5535-specific-gpio-functionality drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~drivers-gpio-cs5535-gpioc-add-some-additional-cs5535-specific-gpio-functionality
+++ a/drivers/gpio/Kconfig
@@ -295,7 +295,7 @@ comment "PCI GPIO expanders:"
 
 config GPIO_CS5535
 	tristate "AMD CS5535/CS5536 GPIO support"
-	depends on PCI && !CS5535_GPIO
+	depends on PCI && X86 && !CS5535_GPIO
 	help
 	  The AMD CS5535 and CS5536 southbridges support 28 GPIO pins that
 	  can be used for quite a number of things.  The CS5535/6 is found on
diff -puN drivers/gpio/cs5535-gpio.c~drivers-gpio-cs5535-gpioc-add-some-additional-cs5535-specific-gpio-functionality drivers/gpio/cs5535-gpio.c
--- a/drivers/gpio/cs5535-gpio.c~drivers-gpio-cs5535-gpioc-add-some-additional-cs5535-specific-gpio-functionality
+++ a/drivers/gpio/cs5535-gpio.c
@@ -15,6 +15,7 @@
 #include <linux/gpio.h>
 #include <linux/io.h>
 #include <linux/cs5535.h>
+#include <asm/msr.h>
 
 #define DRV_NAME "cs5535-gpio"
 #define GPIO_BAR 1
@@ -121,6 +122,57 @@ int cs5535_gpio_isset(unsigned offset, u
 }
 EXPORT_SYMBOL_GPL(cs5535_gpio_isset);
 
+int cs5535_gpio_set_irq(unsigned group, unsigned irq)
+{
+	uint32_t lo, hi;
+
+	if (group > 7 || irq > 15)
+		return -EINVAL;
+
+	rdmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
+
+	lo &= ~(0xF << (group * 4));
+	lo |= (irq & 0xF) << (group * 4);
+
+	wrmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cs5535_gpio_set_irq);
+
+void cs5535_gpio_setup_event(unsigned offset, int pair, int pme)
+{
+	struct cs5535_gpio_chip *chip = &cs5535_gpio_chip;
+	uint32_t shift = (offset % 8) * 4;
+	unsigned long flags;
+	uint32_t val;
+
+	if (offset >= 24)
+		offset = GPIO_MAP_W;
+	else if (offset >= 16)
+		offset = GPIO_MAP_Z;
+	else if (offset >= 8)
+		offset = GPIO_MAP_Y;
+	else
+		offset = GPIO_MAP_X;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	val = inl(chip->base + offset);
+
+	/* Clear whatever was there before */
+	val &= ~(0xF << shift);
+
+	/* Set the new value */
+	val |= ((pair & 7) << shift);
+
+	/* Set the PME bit if this is a PME event */
+	if (pme)
+		val |= (1 << (shift + 3));
+
+	outl(val, chip->base + offset);
+	spin_unlock_irqrestore(&chip->lock, flags);
+}
+EXPORT_SYMBOL_GPL(cs5535_gpio_setup_event);
+
 /*
  * Generic gpio_chip API support.
  */
diff -puN include/linux/cs5535.h~drivers-gpio-cs5535-gpioc-add-some-additional-cs5535-specific-gpio-functionality include/linux/cs5535.h
--- a/include/linux/cs5535.h~drivers-gpio-cs5535-gpioc-add-some-additional-cs5535-specific-gpio-functionality
+++ a/include/linux/cs5535.h
@@ -111,6 +111,8 @@ static inline int cs5535_has_vsa2(void)
 void cs5535_gpio_set(unsigned offset, unsigned int reg);
 void cs5535_gpio_clear(unsigned offset, unsigned int reg);
 int cs5535_gpio_isset(unsigned offset, unsigned int reg);
+int cs5535_gpio_set_irq(unsigned group, unsigned irq);
+void cs5535_gpio_setup_event(unsigned offset, int pair, int pme);
 
 /* MFGPTs */
 
_

Patches currently in -mm which might be from dilinger@queued.net are

linux-next.patch
drivers-gpio-cs5535-gpioc-add-some-additional-cs5535-specific-gpio-functionality.patch
drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api.patch

