From: akpm@linux-foundation.org
Subject: [merged] gpio-gpio_requestfree-now-required-feature-removal.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:33 -0700
Message-ID: <200904061933.n36JXXHA011140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569AbZDFTfc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:35:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpio: gpio_{request,free}() now required (feature removal)
has been removed from the -mm tree.  Its filename was
     gpio-gpio_requestfree-now-required-feature-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: gpio_{request,free}() now required (feature removal)
From: David Brownell <dbrownell@users.sourceforge.net>

We want to phase out the GPIO "autorequest" mechanism in gpiolib and
require all callers to use gpio_request().

 - Update feature-removal-schedule
 - Update the documentation now
 - Convert the relevant pr_warning() in gpiolib to a WARN()
   so folk using this mechanism get a noisy stack dump

Some drivers and board init code will probably need to change. 
Implementations not using gpiolib will still be fine; they are already
required to implement gpio_{request,free}() stubs.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   10 ++++++++
 Documentation/gpio.txt                     |   23 +++++++------------
 drivers/gpio/gpiolib.c                     |   12 ++++++---
 3 files changed, 27 insertions(+), 18 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~gpio-gpio_requestfree-now-required-feature-removal Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~gpio-gpio_requestfree-now-required-feature-removal
+++ a/Documentation/feature-removal-schedule.txt
@@ -255,6 +255,16 @@ Who:	Jan Engelhardt <jengelh@computergmb
 
 ---------------------------
 
+What:	GPIO autorequest on gpio_direction_{input,output}() in gpiolib
+When:	February 2010
+Why:	All callers should use explicit gpio_request()/gpio_free().
+	The autorequest mechanism in gpiolib was provided mostly as a
+	migration aid for legacy GPIO interfaces (for SOC based GPIOs).
+	Those users have now largely migrated.  Platforms implementing
+	the GPIO interfaces without using gpiolib will see no changes.
+Who:	David Brownell <dbrownell@users.sourceforge.net>
+---------------------------
+
 What:	b43 support for firmware revision < 410
 When:	The schedule was July 2008, but it was decided that we are going to keep the
         code as long as there are no major maintanance headaches.
diff -puN Documentation/gpio.txt~gpio-gpio_requestfree-now-required-feature-removal Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpio-gpio_requestfree-now-required-feature-removal
+++ a/Documentation/gpio.txt
@@ -123,7 +123,10 @@ platform-specific implementation issue.
 
 Using GPIOs
 -----------
-One of the first things to do with a GPIO, often in board setup code when
+The first thing a system should do with a GPIO is allocate it, using
+the gpio_request() call; see later.
+
+One of the next things to do with a GPIO, often in board setup code when
 setting up a platform_device using the GPIO, is mark its direction:
 
 	/* set as input or output, returning 0 or negative errno */
@@ -141,8 +144,8 @@ This helps avoid signal glitching during
 
 For compatibility with legacy interfaces to GPIOs, setting the direction
 of a GPIO implicitly requests that GPIO (see below) if it has not been
-requested already.  That compatibility may be removed in the future;
-explicitly requesting GPIOs is strongly preferred.
+requested already.  That compatibility is being removed from the optional
+gpiolib framework.
 
 Setting the direction can fail if the GPIO number is invalid, or when
 that particular GPIO can't be used in that mode.  It's generally a bad
@@ -195,7 +198,7 @@ This requires sleeping, which can't be d
 
 Platforms that support this type of GPIO distinguish them from other GPIOs
 by returning nonzero from this call (which requires a valid GPIO number,
-either explicitly or implicitly requested):
+which should have been previously allocated with gpio_request):
 
 	int gpio_cansleep(unsigned gpio);
 
@@ -212,10 +215,9 @@ for GPIOs that can't be accessed from IR
 same as the spinlock-safe calls.
 
 
-Claiming and Releasing GPIOs (OPTIONAL)
----------------------------------------
+Claiming and Releasing GPIOs
+----------------------------
 To help catch system configuration errors, two calls are defined.
-However, many platforms don't currently support this mechanism.
 
 	/* request GPIO, returning 0 or negative errno.
 	 * non-null labels may be useful for diagnostics.
@@ -244,13 +246,6 @@ Some platforms may also use knowledge ab
 power management, such as by powering down unused chip sectors and, more
 easily, gating off unused clocks.
 
-These two calls are optional because not not all current Linux platforms
-offer such functionality in their GPIO support; a valid implementation
-could return success for all gpio_request() calls.  Unlike the other calls,
-the state they represent doesn't normally match anything from a hardware
-register; it's just a software bitmap which clearly is not necessary for
-correct operation of hardware or (bug free) drivers.
-
 Note that requesting a GPIO does NOT cause it to be configured in any
 way; it just marks that GPIO as in use.  Separate code must handle any
 pin setup (e.g. controlling which pin the GPIO uses, pullup/pulldown).
diff -puN drivers/gpio/gpiolib.c~gpio-gpio_requestfree-now-required-feature-removal drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-gpio_requestfree-now-required-feature-removal
+++ a/drivers/gpio/gpiolib.c
@@ -69,20 +69,24 @@ static inline void desc_set_label(struct
  * those calls have no teeth) we can't avoid autorequesting.  This nag
  * message should motivate switching to explicit requests... so should
  * the weaker cleanup after faults, compared to gpio_request().
+ *
+ * NOTE: the autorequest mechanism is going away; at this point it's
+ * only "legal" in the sense that (old) code using it won't break yet,
+ * but instead only triggers a WARN() stack dump.
  */
 static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
 {
-	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
-		struct gpio_chip *chip = desc->chip;
-		int gpio = chip->base + offset;
+	const struct gpio_chip *chip = desc->chip;
+	const int gpio = chip->base + offset;
 
+	if (WARN(test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0,
+			"autorequest GPIO-%d\n", gpio)) {
 		if (!try_module_get(chip->owner)) {
 			pr_err("GPIO-%d: module can't be gotten \n", gpio);
 			clear_bit(FLAG_REQUESTED, &desc->flags);
 			/* lose */
 			return -EIO;
 		}
-		pr_warning("GPIO-%d autorequested\n", gpio);
 		desc_set_label(desc, "[auto]");
 		/* caller must chip->request() w/o spinlock */
 		if (chip->request)
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
blackfin-spi-driver-remove-useless-asm-cplbinith.patch
blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred.patch
blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level.patch
blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch
blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label.patch
blackfin-spi-driver-get-dma-working-for-spi-flashes.patch
blackfin-spi-driver-fix-bug-spi-controller-driver-does-not-assert-deassert-cs-correctly.patch
blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change.patch
spi-limit-reaches-1-tested-0.patch

