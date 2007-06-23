From: akpm@linux-foundation.org
Subject: - spi-doc-updates.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:27:22 -0700
Message-ID: <200706231927.l5NJRM4V022057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53389 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754011AbXFWT1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi doc updates
has been removed from the -mm tree.  Its filename was
     spi-doc-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi doc updates
From: David Brownell <david-b@pacbell.net>

Update two points in the SPI interface documentation:

- Update description of the "chip stays selected after message ends"
  mode.  In some cases it's required for correctness; it isn't just a
  performance tweak.  (Yes: to use this mode on mult-device busses, another
  programming interface will be needed.  One draft has been circulated
  already.)

- Clarify spi_setup(), highlighting that callers must ensure that no
  requests are queued (can't change configuration except between I/Os), and
  that the device must be deselected when this returns (which is a key part
  of why it's called during device init).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spi/spi.h |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN include/linux/spi/spi.h~spi-doc-updates include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-doc-updates
+++ a/include/linux/spi/spi.h
@@ -341,9 +341,14 @@ extern struct spi_master *spi_busnum_to_
  * chip transactions together.
  *
  * (ii) When the transfer is the last one in the message, the chip may
- * stay selected until the next transfer.  This is purely a performance
- * hint; the controller driver may need to select a different device
- * for the next message.
+ * stay selected until the next transfer.  On multi-device SPI busses
+ * with nothing blocking messages going to other devices, this is just
+ * a performance hint; starting a message to another device deselects
+ * this one.  But in other cases, this can be used to ensure correctness.
+ * Some devices need protocol transactions to be built from a series of
+ * spi_message submissions, where the content of one message is determined
+ * by the results of previous messages and where the whole transaction
+ * ends when the chipselect goes intactive.
  *
  * The code that submits an spi_message (and its spi_transfers)
  * to the lower layers is responsible for managing its memory.
@@ -480,14 +485,15 @@ static inline void spi_message_free(stru
 /**
  * spi_setup - setup SPI mode and clock rate
  * @spi: the device whose settings are being modified
- * Context: can sleep
+ * Context: can sleep, and no requests are queued to the device
  *
  * SPI protocol drivers may need to update the transfer mode if the
- * device doesn't work with the mode 0 default.  They may likewise need
+ * device doesn't work with its default.  They may likewise need
  * to update clock rates or word sizes from initial values.  This function
  * changes those settings, and must be called from a context that can sleep.
- * The changes take effect the next time the device is selected and data
- * is transferred to or from it.
+ * Except for SPI_CS_HIGH, which takes effect immediately, the changes take
+ * effect the next time the device is selected and data is transferred to
+ * or from it.  When this function returns, the spi device is deselected.
  *
  * Note that this call will fail if the protocol driver specifies an option
  * that the underlying controller or its driver does not support.  For
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-avr32.patch
git-leds.patch
git-mmc.patch
git-netdev-all.patch
git-backlight.patch
char-genrtc-use-wait_event_interruptible.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-controller-drivers-check-for-unsupported-modes-update.patch
spi-add-3wire-mode-flag.patch
spi-add-3wire-mode-flag-fix.patch
spidev-compiler-warning-gone.patch
spi_lm70llp-parport-adapter-driver-correction.patch
spi_mpc83xxc-underclocking-hotfix.patch
atmel_spi-minor-updates.patch
s3c24xx-spi-controllers-both-select-bitbang.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
rtc-kconfig-tweax.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
