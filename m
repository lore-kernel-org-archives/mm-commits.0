From: akpm@linux-foundation.org
Subject: + gpio-include-linux-gpioh-not-asm-gpioh.patch added to -mm tree
Date: Mon, 03 Aug 2009 14:51:10 -0700
Message-ID: <200908032151.n73LpAFQ025844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932242AbZHCVvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 17:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, david-b@pacbell.net, hsweeten@visionengravers.com


The patch titled
     gpio: include <linux/gpio.h> not <asm/gpio.h>
has been added to the -mm tree.  Its filename is
     gpio-include-linux-gpioh-not-asm-gpioh.patch

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
Subject: gpio: include <linux/gpio.h> not <asm/gpio.h>
From: H Hartley Sweeten <hartleys@visionengravers.com>

Drivers should be including <linux/gpio.h> not <asm/gpio.h>.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/bt8xxgpio.c |    3 +--
 drivers/gpio/mcp23s08.c  |    4 +---
 drivers/gpio/pca953x.c   |    3 +--
 drivers/gpio/pcf857x.c   |    3 +--
 4 files changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/gpio/bt8xxgpio.c~gpio-include-linux-gpioh-not-asm-gpioh drivers/gpio/bt8xxgpio.c
--- a/drivers/gpio/bt8xxgpio.c~gpio-include-linux-gpioh-not-asm-gpioh
+++ a/drivers/gpio/bt8xxgpio.c
@@ -46,8 +46,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
-
-#include <asm/gpio.h>
+#include <linux/gpio.h>
 
 /* Steal the hardware definitions from the bttv driver. */
 #include "../media/video/bt8xx/bt848.h"
diff -puN drivers/gpio/mcp23s08.c~gpio-include-linux-gpioh-not-asm-gpioh drivers/gpio/mcp23s08.c
--- a/drivers/gpio/mcp23s08.c~gpio-include-linux-gpioh-not-asm-gpioh
+++ a/drivers/gpio/mcp23s08.c
@@ -6,12 +6,10 @@
 #include <linux/device.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
-
+#include <linux/gpio.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/mcp23s08.h>
 
-#include <asm/gpio.h>
-
 
 /* Registers are all 8 bits wide.
  *
diff -puN drivers/gpio/pca953x.c~gpio-include-linux-gpioh-not-asm-gpioh drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-include-linux-gpioh-not-asm-gpioh
+++ a/drivers/gpio/pca953x.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pca953x.h>
 #ifdef CONFIG_OF_GPIO
@@ -20,8 +21,6 @@
 #include <linux/of_gpio.h>
 #endif
 
-#include <asm/gpio.h>
-
 #define PCA953X_INPUT          0
 #define PCA953X_OUTPUT         1
 #define PCA953X_INVERT         2
diff -puN drivers/gpio/pcf857x.c~gpio-include-linux-gpioh-not-asm-gpioh drivers/gpio/pcf857x.c
--- a/drivers/gpio/pcf857x.c~gpio-include-linux-gpioh-not-asm-gpioh
+++ a/drivers/gpio/pcf857x.c
@@ -20,11 +20,10 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pcf857x.h>
 
-#include <asm/gpio.h>
