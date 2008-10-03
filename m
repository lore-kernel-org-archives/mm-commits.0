From: akpm@linux-foundation.org
Subject: + spi-core-and-gpio-expanders-use-subsys_init.patch added to -mm tree
Date: Thu, 02 Oct 2008 17:02:53 -0700
Message-ID: <200810030002.m9302raa001268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753820AbYJCADC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 20:03:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net


The patch titled
     spi: core and gpio expanders use subsys_init
has been added to the -mm tree.  Its filename is
     spi-core-and-gpio-expanders-use-subsys_init.patch

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
Subject: spi: core and gpio expanders use subsys_init
From: David Brownell <dbrownell@users.sourceforge.net>

Make the SPI external GPIO expander drivers register themselves at
subsys_initcall() time when they're statically linked, and make the SPI
core do its driver model initialization earlier so that's safe.

SOC-integrated GPIOs are available starting very early -- often before
initcalls start to run, or earily in arch_initcall() at latest -- so this
improves consistency, letting more subsystems rely on GPIOs being usable
by their own subsys_initcall() code.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max7301.c  |    6 ++++--
 drivers/gpio/mcp23s08.c |    5 ++++-
 drivers/spi/spi.c       |    2 +-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/gpio/max7301.c~spi-core-and-gpio-expanders-use-subsys_init drivers/gpio/max7301.c
--- a/drivers/gpio/max7301.c~spi-core-and-gpio-expanders-use-subsys_init
+++ a/drivers/gpio/max7301.c
@@ -325,13 +325,15 @@ static int __init max7301_init(void)
 {
 	return spi_register_driver(&max7301_driver);
 }
+/* register after spi postcore initcall and before
+ * subsys initcalls that may rely on these GPIOs
+ */
+subsys_initcall(max7301_init);
 
 static void __exit max7301_exit(void)
 {
 	spi_unregister_driver(&max7301_driver);
 }
-
-module_init(max7301_init);
 module_exit(max7301_exit);
 
 MODULE_AUTHOR("Juergen Beisert");
diff -puN drivers/gpio/mcp23s08.c~spi-core-and-gpio-expanders-use-subsys_init drivers/gpio/mcp23s08.c
--- a/drivers/gpio/mcp23s08.c~spi-core-and-gpio-expanders-use-subsys_init
+++ a/drivers/gpio/mcp23s08.c
@@ -419,7 +419,10 @@ static int __init mcp23s08_init(void)
 {
 	return spi_register_driver(&mcp23s08_driver);
 }
-module_init(mcp23s08_init);
+/* register after spi postcore initcall and before
+ * subsys initcalls that may rely on these GPIOs
+ */
+subsys_initcall(mcp23s08_init);
 
 static void __exit mcp23s08_exit(void)
 {
diff -puN drivers/spi/spi.c~spi-core-and-gpio-expanders-use-subsys_init drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-core-and-gpio-expanders-use-subsys_init
+++ a/drivers/spi/spi.c
@@ -738,5 +738,5 @@ err0:
  * driver registration) _could_ be dynamically linked (modular) ... costs
  * include needing to have boardinfo data structures be much more public.
  */
-subsys_initcall(spi_init);
+postcore_initcall(spi_init);
 
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

rtc-fix-kernel-panic-on-second-use-of-sigio-nofitication.patch
orion_spi-fix-handling-of-default-transfer-speed.patch
git-arm.patch
git-avr32.patch
git-x86.patch
git-mtd.patch
acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry.patch
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
rtc-cmos-strongly-avoid-hpet-emulation.patch
rtc-cmos-export-second-nvram-bank.patch
make-gpiochip-label-const.patch
gpio-i2c-expanders-use-subsys_init.patch

