From: akpm@linux-foundation.org
Subject: - spi-core-and-gpio-expanders-use-subsys_init.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:46 -0700
Message-ID: <200810182314.m9INEkNF028467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbYJRXOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: core and gpio expanders use subsys_init
has been removed from the -mm tree.  Its filename was
     spi-core-and-gpio-expanders-use-subsys_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
rtc-cmos-export-second-nvram-bank.patch
gpio-modify-sysfs-gpio-export-so-that-value-displays-as-0-or-1.patch
gpiolib-fix-oops-in-gpio_get_value_cansleep.patch

