From: akpm@linux-foundation.org
Subject: + basic-pwm-driver-for-avr32-and-at91-fix.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:28:51 -0800
Message-ID: <200801280529.m0S5Tk4n013999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56096 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbYA1Faa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:30:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, david-b@pacbell.net, linux@maxim.org.za, nicolas.ferre@atmel.com


The patch titled
     Basic PWM driver for AVR32 and AT91 (fix)
has been added to the -mm tree.  Its filename is
     basic-pwm-driver-for-avr32-and-at91-fix.patch

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
Subject: Basic PWM driver for AVR32 and AT91 (fix)
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

> There's a bug there ... it should have used ARCH_AT91 instead
> of just AT91.  Or even ARCH_AT91SAM9263 || ARCH_AT91SAM9RL.

I've turned it into ARCH_AT91. I think listing the specific chips that
have it is a bit too much; it won't break if you enable it on a chip
that doesn't have it, it will just be useless. That's what defconfigs
are for, and we still want people that test allmodconfigs on e.g.
AT91RM9200 to report any breakage.

Cc: David Brownell <david-b@pacbell.net>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/Kconfig~basic-pwm-driver-for-avr32-and-at91-fix drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~basic-pwm-driver-for-avr32-and-at91-fix
+++ a/drivers/misc/Kconfig
@@ -15,7 +15,7 @@ if MISC_DEVICES
 
 config ATMEL_PWM
 	tristate "Atmel AT32/AT91 PWM support"
-	depends on (AVR32 || AT91) && EXPERIMENTAL
+	depends on AVR32 || ARCH_AT91
 	help
 	  This option enables device driver support for the PWM channels
 	  on certain Atmel prcoessors.  Pulse Width Modulation is used for
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

git-avr32.patch
fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one.patch
git-mtd.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
config_highpte-vs-sub-page-page-tables-avr32-fix.patch
read_current_time-cleanups.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-chain-dma-transfers-update.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
add-have_oprofile.patch
atmel_lcdfb-validate-display-timings.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
tty-let-architectures-override-the-user-kernel-macros.patch
maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver.patch
atmel_serial-clean-up-the-code.patch
atmel_serial-use-cpu_relax-when-busy-waiting.patch
atmel_serial-use-existing-console-options-only-if-brg-is-running.patch
atmel_serial-fix-bugs-in-probe-error-path-and-remove.patch
atmel_serial-split-the-interrupt-handler.patch
atmel_serial-add-dma-support.patch
atmel_serial-use-container_of-instead-of-direct-cast.patch
atmel_serial-show-tty-name-in-proc-interrupts.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
