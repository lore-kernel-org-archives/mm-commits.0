From: akpm@osdl.org
Subject: + spi-doc-clarifications.patch added to -mm tree
Date: Thu, 01 Feb 2007 14:48:04 -0800
Message-ID: <200702012248.l11MmmwN025246@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45774 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422646AbXBAWs4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:48:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     SPI doc clarifications
has been added to the -mm tree.  Its filename is
     spi-doc-clarifications.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI doc clarifications
From: David Brownell <david-b@pacbell.net>

This clarifies some aspects of the SPI programming interface, based on
feedback from Hans-Peter Nilsson.  The in-memory representation of words is
right-aligned, so for example a twelve bit word is stored using sixteen bits
with four undefined bits in the MSB.  And controller drivers must reject
protocol tweaking modes they do not support.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/spi/spi.h |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletion(-)

diff -puN include/linux/spi/spi.h~spi-doc-clarifications include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-doc-clarifications
+++ a/include/linux/spi/spi.h
@@ -163,7 +163,8 @@ static inline void spi_unregister_driver
  *	each slave has a chipselect signal, but it's common that not
  *	every chipselect is connected to a slave.
  * @setup: updates the device mode and clocking records used by a
- *	device's SPI controller; protocol code may call this.
+ *	device's SPI controller; protocol code may call this.  This
+ *	must fail if an unrecognized or unsupported mode is requested.
  * @transfer: adds a message to the controller's transfer queue.
  * @cleanup: frees controller-specific state
  *
@@ -305,6 +306,16 @@ extern struct spi_master *spi_busnum_to_
  * shifting out three bytes with word size of sixteen or twenty bits;
  * the former uses two bytes per word, the latter uses four bytes.)
  *
+ * In-memory data values are always in native CPU byte order, translated
+ * from the wire byte order (big-endian except with SPI_LSB_FIRST).  So
+ * for example when bits_per_word is sixteen, buffers are 2N bytes long
+ * and hold N sixteen bit words in CPU byte order.
+ *
+ * When the word size of the SPI transfer is not a power-of-two multiple
+ * of eight bits, those in-memory words include extra bits.  In-memory
+ * words are always seen by protocol drivers as right-justified, so the
+ * undefined (rx) or unused (tx) bits are always the most significant bits.
+ *
  * All SPI transfers start with the relevant chipselect active.  Normally
  * it stays selected until after the last transfer in a message.  Drivers
  * can affect the chipselect signal using cs_change:
@@ -462,6 +473,11 @@ static inline void spi_message_free(stru
  * changes those settings, and must be called from a context that can sleep.
  * The changes take effect the next time the device is selected and data
  * is transferred to or from it.
+ *
+ * Note that this call wil fail if the protocol driver specifies an option
+ * that the underlying controller or its driver does not support.  For
+ * example, not all hardware supports wire transfers using nine bit words,
+ * LSB-first wire encoding, or active-high chipselects.
  */
 static inline int
 spi_setup(struct spi_device *spi)
_

Patches currently in -mm which might be from david-b@pacbell.net are

acpi-updates-rtc-cmos-device-platform_data.patch
git-mmc.patch
8250-make-probing-for-txen-bug-a-config-option.patch
pnp-export-pnp_bus_type.patch
rtc-framework-driver-for-cmos-rtcs.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
spi-controller-driver-for-omap-microwire-update.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
spi-freescale-imx-spi-controller-driver-v5.patch
spi-doc-clarifications.patch
rtc-gets-sysfs-wakealarm-attribute.patch
spi-eeprom-driver.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
