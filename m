From: akpm@linux-foundation.org
Subject: + gpiolib-fix-oops-in-gpio_get_value_cansleep.patch added to -mm tree
Date: Thu, 16 Oct 2008 16:17:23 -0700
Message-ID: <200810162317.m9GNHNZv004639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757176AbYJPXXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 19:23:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, avorontsov@ru.mvista.com


The patch titled
     gpiolib: fix oops in gpio_get_value_cansleep()
has been added to the -mm tree.  Its filename is
     gpiolib-fix-oops-in-gpio_get_value_cansleep.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiolib: fix oops in gpio_get_value_cansleep()
From: David Brownell <dbrownell@users.sourceforge.net>

We can get the following oops from gpio_get_value_cansleep() when a GPIO
controller doesn't provide a get() callback:

 Unable to handle kernel paging request for instruction fetch
 Faulting instruction address: 0x00000000
 Oops: Kernel access of bad area, sig: 11 [#1]
 [...]
 NIP [00000000] 0x0
 LR [c0182fb0] gpio_get_value_cansleep+0x40/0x50
 Call Trace:
 [c7b79e80] [c0183f28] gpio_value_show+0x5c/0x94
 [c7b79ea0] [c01a584c] dev_attr_show+0x30/0x7c
 [c7b79eb0] [c00d6b48] fill_read_buffer+0x68/0xe0
 [c7b79ed0] [c00d6c54] sysfs_read_file+0x94/0xbc
 [c7b79ef0] [c008f24c] vfs_read+0xb4/0x16c
 [c7b79f10] [c008f580] sys_read+0x4c/0x90
 [c7b79f40] [c0013a14] ret_from_syscall+0x0/0x38

It's OK to request the value of *any* GPIO; most GPIOs are bidirectional,
so configuring them as outputs just enables an output driver and doesn't
disable the input logic.

So the problem is that gpio_get_value_cansleep() isn't making the same
sanity check that gpio_get_value() does: making sure this GPIO isn't one
of the atypical "no input logic" cases.

Reported-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-fix-oops-in-gpio_get_value_cansleep drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-fix-oops-in-gpio_get_value_cansleep
+++ a/drivers/gpio/gpiolib.c
@@ -1105,7 +1105,7 @@ int gpio_get_value_cansleep(unsigned gpi
 
 	might_sleep_if(extra_checks);
 	chip = gpio_to_chip(gpio);
-	return chip->get(chip, gpio - chip->base);
+	return chip->get ? chip->get(chip, gpio - chip->base) : 0;
 }
 EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
 
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
spi-simplify-spi_write_then_read.patch
spi_s3c24xx-pin-configuration-updates.patch
pxa2xx_spi-minor-cleanup.patch
pxa2xx_spi-fix-chip_info-defaults-and-documentation.patch
orion_spi-handle-88f6183-erratum.patch
spi-core-and-gpio-expanders-use-subsys_init.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch
rtc-file-close-consistently-disables-repeating-irqs.patch
make-gpiochip-label-const.patch
gpio-i2c-expanders-use-subsys_init.patch
gpiolib-gpio_to_irq-hooks.patch
omap-drivers-switch-to-standard-gpio-calls.patch
gpiolib-request-free-hooks.patch
rtc-cmos-export-second-nvram-bank.patch
gpio-modify-sysfs-gpio-export-so-that-value-displays-as-0-or-1.patch
gpiolib-fix-oops-in-gpio_get_value_cansleep.patch

