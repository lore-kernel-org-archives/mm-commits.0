From: akpm@linux-foundation.org
Subject: - gpio-i2c-expanders-use-subsys_init.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:15:56 -0700
Message-ID: <200810182315.m9INFuuE028726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbYJRXQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:16:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     gpio: i2c expanders use subsys_init
has been removed from the -mm tree.  Its filename was
     gpio-i2c-expanders-use-subsys_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: i2c expanders use subsys_init
From: David Brownell <dbrownell@users.sourceforge.net>

Make the I2C external GPIO expander drivers register themselves at
subsys_initcall() time when they're statically linked.

SOC-integrated GPIOs are available starting very early -- early in
arch_initcall() at latest, but often even before initcalls start to run --
so this improves consistency, so more subsystems can rely on GPIOs in
their own subsys_initcall() code.

(This isn't a theoretical problem.  This is one of several patches needed
to resolve oopsing observed when statically linking kernels on a DaVinci
EVM.  Its pcf857x GPIOs needed to be available well before some other
drivers initialized.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max732x.c |    5 ++++-
 drivers/gpio/pca953x.c |    5 ++++-
 drivers/gpio/pcf857x.c |    5 ++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff -puN drivers/gpio/max732x.c~gpio-i2c-expanders-use-subsys_init drivers/gpio/max732x.c
--- a/drivers/gpio/max732x.c~gpio-i2c-expanders-use-subsys_init
+++ a/drivers/gpio/max732x.c
@@ -372,7 +372,10 @@ static int __init max732x_init(void)
 {
 	return i2c_add_driver(&max732x_driver);
 }
-module_init(max732x_init);
+/* register after i2c postcore initcall and before
+ * subsys initcalls that may rely on these GPIOs
+ */
+subsys_initcall(max732x_init);
 
 static void __exit max732x_exit(void)
 {
diff -puN drivers/gpio/pca953x.c~gpio-i2c-expanders-use-subsys_init drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-i2c-expanders-use-subsys_init
+++ a/drivers/gpio/pca953x.c
@@ -289,7 +289,10 @@ static int __init pca953x_init(void)
 {
 	return i2c_add_driver(&pca953x_driver);
 }
-module_init(pca953x_init);
+/* register after i2c postcore initcall and before
+ * subsys initcalls that may rely on these GPIOs
+ */
+subsys_initcall(pca953x_init);
 
 static void __exit pca953x_exit(void)
 {
diff -puN drivers/gpio/pcf857x.c~gpio-i2c-expanders-use-subsys_init drivers/gpio/pcf857x.c
--- a/drivers/gpio/pcf857x.c~gpio-i2c-expanders-use-subsys_init
+++ a/drivers/gpio/pcf857x.c
@@ -351,7 +351,10 @@ static int __init pcf857x_init(void)
 {
 	return i2c_add_driver(&pcf857x_driver);
 }
-module_init(pcf857x_init);
+/* register after i2c postcore initcall and before
+ * subsys initcalls that may rely on these GPIOs
+ */
+subsys_initcall(pcf857x_init);
 
 static void __exit pcf857x_exit(void)
 {
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
rtc-cmos-export-second-nvram-bank.patch
gpio-modify-sysfs-gpio-export-so-that-value-displays-as-0-or-1.patch
gpiolib-fix-oops-in-gpio_get_value_cansleep.patch

