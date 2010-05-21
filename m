From: akpm@linux-foundation.org
Subject: + gpio-add-penwell-gpio-support-update.patch added to -mm tree
Date: Thu, 20 May 2010 20:58:49 -0400
Message-ID: <201005210400.o4L40FNt021641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739Ab0EUEAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 00:00:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alek.du@intel.com, david-b@pacbell.net


The patch titled
     gpio-add-penwell-gpio-support-update
has been added to the -mm tree.  Its filename is
     gpio-add-penwell-gpio-support-update.patch

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
Subject: gpio-add-penwell-gpio-support-update
From: "Du, Alek" <alek.du@intel.com>

* remove gpio_reg inline, due to the fact the func is too big to inline
* use standard DEFINE_PCI_DEVICE_TABLE

Signed-off-by: Alek Du <alek.du@intel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/langwell_gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpio/langwell_gpio.c~gpio-add-penwell-gpio-support-update drivers/gpio/langwell_gpio.c
--- a/drivers/gpio/langwell_gpio.c~gpio-add-penwell-gpio-support-update
+++ a/drivers/gpio/langwell_gpio.c
@@ -63,7 +63,7 @@ struct lnw_gpio {
 	unsigned			irq_base;
 };
 
-static inline void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
+static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
 			enum GPIO_REG reg_type)
 {
 	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
@@ -175,7 +175,7 @@ static struct irq_chip lnw_irqchip = {
 	.set_type	= lnw_irq_type,
 };
 
-static struct pci_device_id lnw_gpio_ids[] = {      /* pin number */
+static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f), .driver_data = 64 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081f), .driver_data = 96 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081a), .driver_data = 96 },
_

Patches currently in -mm which might be from alek.du@intel.com are

linux-next.patch
gpio-add-penwell-gpio-support.patch
gpio-add-penwell-gpio-support-update.patch

