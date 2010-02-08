From: akpm@linux-foundation.org
Subject: + gpiolib-introduce-chip-addition-removal-notifier.patch added to -mm tree
Date: Mon, 08 Feb 2010 13:02:56 -0800
Message-ID: <201002082102.o18L2v53002791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283Ab0BHVDn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 16:03:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, bgat@billgatliff.com, dbaryshkov@gmail.com, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, khali@linux-fr.org


The patch titled
     gpiolib: introduce chip addition/removal notifier
has been added to the -mm tree.  Its filename is
     gpiolib-introduce-chip-addition-removal-notifier.patch

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
Subject: gpiolib: introduce chip addition/removal notifier
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Some platforms (e.g.  OpenFirmware) want to know when a particular chip
added or removed, so that the platforms could add their specifics for
non-platform devices, like I2C or SPI GPIO chips.

This patch implements the notifier for chip addition and removal events.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Bill Gatliff <bgat@billgatliff.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c     |   14 ++++++++++++++
 include/asm-generic/gpio.h |    8 ++++++++
 2 files changed, 22 insertions(+)

diff -puN drivers/gpio/gpiolib.c~gpiolib-introduce-chip-addition-removal-notifier drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-introduce-chip-addition-removal-notifier
+++ a/drivers/gpio/gpiolib.c
@@ -9,6 +9,7 @@
 #include <linux/seq_file.h>
 #include <linux/gpio.h>
 #include <linux/idr.h>
+#include <linux/notifier.h>
 
 
 /* Optional implementation infrastructure for GPIO interfaces.
@@ -1033,6 +1034,9 @@ static inline void gpiochip_unexport(str
 
 #endif /* CONFIG_GPIO_SYSFS */
 
+BLOCKING_NOTIFIER_HEAD(gpio_notifier);
+EXPORT_SYMBOL_GPL(gpio_notifier);
+
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
@@ -1107,6 +1111,9 @@ fail:
 		pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
 			chip->base, chip->base + chip->ngpio - 1,
 			chip->label ? : "generic");
+	else
+		blocking_notifier_call_chain(&gpio_notifier,
+					     GPIO_NOTIFY_CHIP_ADDED, chip);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpiochip_add);
@@ -1123,6 +1130,13 @@ int gpiochip_remove(struct gpio_chip *ch
 	int		status = 0;
 	unsigned	id;
 
+	/* Ask external subsystems to release the chip. */
+	status = blocking_notifier_call_chain(&gpio_notifier,
+					      GPIO_NOTIFY_CHIP_REMOVE, chip);
+	status = notifier_to_errno(status);
+	if (status)
+		return status;
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
diff -puN include/asm-generic/gpio.h~gpiolib-introduce-chip-addition-removal-notifier include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-introduce-chip-addition-removal-notifier
+++ a/include/asm-generic/gpio.h
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/notifier.h>
 
 #ifdef CONFIG_GPIOLIB
 
@@ -234,4 +235,11 @@ static inline void gpio_unexport(unsigne
 }
 #endif	/* CONFIG_GPIO_SYSFS */
 
+enum gpio_notify_msg {
+	GPIO_NOTIFY_CHIP_ADDED = 0,
+	GPIO_NOTIFY_CHIP_REMOVE = 1,
+};
+
+extern struct blocking_notifier_head gpio_notifier;
+
 #endif /* _ASM_GENERIC_GPIO_H */
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
gpiolib-introduce-chip-addition-removal-notifier.patch
of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff.patch

