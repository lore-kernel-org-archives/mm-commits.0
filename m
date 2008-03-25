From: akpm@linux-foundation.org
Subject: - hw_random-doc-updates.patch removed from -mm tree
Date: Tue, 25 Mar 2008 15:29:43 -0700
Message-ID: <200803252229.m2PMThwo016829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759813AbYCYWaY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:30:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     hw_random doc updates
has been removed from the -mm tree.  Its filename was
     hw_random-doc-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hw_random doc updates
From: David Brownell <dbrownell@users.sourceforge.net>

Update documentation for the hw_random support to be current:

 - Documentation/hw_random.txt has been updated to reflect the
   current code:  it's a framework now, a "core" with a small
   sysfs interface, that hardware-specific drivers plug in to.
   Text specific to Intel hardware is now at the end.

 - Kconfig now references the Documentation/hw_random.txt file
   and better explains what this really does.

Both chunks of documentation now higlight the fact that the kernel entropy
pool is maintained by "rngd", and this driver has nothing directly to do with
that important task.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hw_random.txt    |   59 +++++++++++++++++++++----------
 drivers/char/hw_random/Kconfig |    9 ++++
 2 files changed, 48 insertions(+), 20 deletions(-)

diff -puN Documentation/hw_random.txt~hw_random-doc-updates Documentation/hw_random.txt
--- a/Documentation/hw_random.txt~hw_random-doc-updates
+++ a/Documentation/hw_random.txt
@@ -1,33 +1,26 @@
-	Hardware driver for Intel/AMD/VIA Random Number Generators (RNG)
-	Copyright 2000,2001 Jeff Garzik <jgarzik@pobox.com>
-	Copyright 2000,2001 Philipp Rumpf <prumpf@mandrakesoft.com>
-
 Introduction:
 
-	The hw_random device driver is software that makes use of a
+	The hw_random framework is software that makes use of a
 	special hardware feature on your CPU or motherboard,
-	a Random Number Generator (RNG).
+	a Random Number Generator (RNG).  The software has two parts:
+	a core providing the /dev/hw_random character device and its
+	sysfs support, plus a hardware-specific driver that plugs
+	into that core.
 
-	In order to make effective use of this device driver, you
+	To make the most effective use of these mechanisms, you
 	should download the support software as well.  Download the
 	latest version of the "rng-tools" package from the
 	hw_random driver's official Web site:
 
 		http://sourceforge.net/projects/gkernel/
 
-About the Intel RNG hardware, from the firmware hub datasheet:
-
-	The Firmware Hub integrates a Random Number Generator (RNG)
-	using thermal noise generated from inherently random quantum
-	mechanical properties of silicon. When not generating new random
-	bits the RNG circuitry will enter a low power state. Intel will
-	provide a binary software driver to give third party software
-	access to our RNG for use as a security feature. At this time,
-	the RNG is only to be used with a system in an OS-present state.
+	Those tools use /dev/hw_random to fill the kernel entropy pool,
+	which is used internally and exported by the /dev/urandom and
+	/dev/random special files.
 
 Theory of operation:
 
-	Character driver.  Using the standard open()
+	CHARACTER DEVICE.  Using the standard open()
 	and read() system calls, you can read random data from
 	the hardware RNG device.  This data is NOT CHECKED by any
 	fitness tests, and could potentially be bogus (if the
@@ -36,9 +29,37 @@ Theory of operation:
 	a security-conscious person would run fitness tests on the
 	data before assuming it is truly random.
 
-	/dev/hwrandom is char device major 10, minor 183.
+	The rng-tools package uses such tests in "rngd", and lets you
+	run them by hand with a "rngtest" utility.
+
+	/dev/hw_random is char device major 10, minor 183.
+
+	CLASS DEVICE.  There is a /sys/class/misc/hw_random node with
+	two unique attributes, "rng_available" and "rng_current".  The
+	"rng_available" attribute lists the hardware-specific drivers
+	available, while "rng_current" lists the one which is currently
+	connected to /dev/hw_random.  If your system has more than one
+	RNG available, you may change the one used by writing a name from
+	the list in "rng_available" into "rng_current".
+
+==========================================================================
+
+	Hardware driver for Intel/AMD/VIA Random Number Generators (RNG)
+	Copyright 2000,2001 Jeff Garzik <jgarzik@pobox.com>
+	Copyright 2000,2001 Philipp Rumpf <prumpf@mandrakesoft.com>
+
+
+About the Intel RNG hardware, from the firmware hub datasheet:
+
+	The Firmware Hub integrates a Random Number Generator (RNG)
+	using thermal noise generated from inherently random quantum
+	mechanical properties of silicon. When not generating new random
+	bits the RNG circuitry will enter a low power state. Intel will
+	provide a binary software driver to give third party software
+	access to our RNG for use as a security feature. At this time,
+	the RNG is only to be used with a system in an OS-present state.
 
-Driver notes:
+Intel RNG Driver notes:
 
 	* FIXME: support poll(2)
 
diff -puN drivers/char/hw_random/Kconfig~hw_random-doc-updates drivers/char/hw_random/Kconfig
--- a/drivers/char/hw_random/Kconfig~hw_random-doc-updates
+++ a/drivers/char/hw_random/Kconfig
@@ -9,7 +9,14 @@ config HW_RANDOM
 	  Hardware Random Number Generator Core infrastructure.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called rng-core.
+	  module will be called rng-core.  This provides a device
+	  that's usually called /dev/hw_random, and which exposes one
+	  of possibly several hardware random number generators.
+
+	  These hardware random number generators do not feed directly
+	  into the kernel's random number generator.  That is usually
+	  handled by the "rngd" daemon.  Documentation/hw_random.txt
+	  has more information.
 
 	  If unsure, say Y.
 
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
git-acpi.patch
git-avr32.patch
git-leds.patch
drivers-net-usb-pegasusc-remove-in_atomic-check.patch
usb-mem-leak-fixes-for-amd-5536-udc-high-full-speed-usb-device-controller-driver.patch
spi-use-menuconfig-for-config_spi.patch
spi-pxa2xx_spi-sparse-fixes.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
spi-replace-remaining-__function__-occurrences.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-avoid-legacy-drivers-with-generic-framework-update.patch
kerneldoc-for-linux-clkh.patch
kerneldoc-for-linux-clkh-fix.patch
gpiolib-better-rmmod-infrastructure.patch
gpiolib-i2c-spi-drivers-handle-rmmod-better.patch
gpio-define-gpio_is_valid.patch
gpiolib-dynamic-gpio-number-allocation.patch
gpiochip_reserve.patch
gpiochip_reserve-fix.patch
atmel_lcdfb-suspend-resume-support.patch
atmel_lcdfb-wiring-bgr-to-rgb-color-mode.patch

