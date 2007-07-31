From: akpm@linux-foundation.org
Subject: - spi-kerneldoc-update.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:59:07 -0700
Message-ID: <200707312359.l6VNx7am029624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48850 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759493AbXHAAQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi kerneldoc update
has been removed from the -mm tree.  Its filename was
     spi-kerneldoc-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi kerneldoc update
From: David Brownell <david-b@pacbell.net>

This adds kerneldoc to the SPI framework.  The "spi_driver" and
"spi_board_info" structs were previously not described.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spi/spi.h |   58 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff -puN include/linux/spi/spi.h~spi-kerneldoc-update include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-kerneldoc-update
+++ a/include/linux/spi/spi.h
@@ -139,6 +139,32 @@ struct spi_message;
 
 
 
+/**
+ * struct spi_driver - Host side "protocol" driver
+ * @probe: Binds this driver to the spi device.  Drivers can verify
+ *	that the device is actually present, and may need to configure
+ *	characteristics (such as bits_per_word) which weren't needed for
+ *	the initial configuration done during system setup.
+ * @remove: Unbinds this driver from the spi device
+ * @shutdown: Standard shutdown callback used during system state
+ *	transitions such as powerdown/halt and kexec
+ * @suspend: Standard suspend callback used during system state transitions
+ * @resume: Standard resume callback used during system state transitions
+ * @driver: SPI device drivers should initialize the name and owner
+ *	field of this structure.
+ *
+ * This represents the kind of device driver that uses SPI messages to
+ * interact with the hardware at the other end of a SPI link.  It's called
+ * a "protocol" driver because it works through messages rather than talking
+ * directly to SPI hardware (which is what the underlying SPI controller
+ * driver does to pass those messages).  These protocols are defined in the
+ * specification for the device(s) supported by the driver.
+ *
+ * As a rule, those device protocols represent the lowest level interface
+ * supported by a driver, and it will support upper level interfaces too.
+ * Examples of such upper levels include frameworks like MTD, networking,
+ * MMC, RTC, filesystem character device nodes, and hardware monitoring.
+ */
 struct spi_driver {
 	int			(*probe)(struct spi_device *spi);
 	int			(*remove)(struct spi_device *spi);
@@ -668,7 +694,37 @@ static inline ssize_t spi_w8r16(struct s
  * parport adapters, or microcontrollers acting as USB-to-SPI bridges.
  */
 
-/* board-specific information about each SPI device */
+/**
+ * struct spi_board_info - board-specific template for a SPI device
+ * @modalias: Initializes spi_device.modalias; identifies the driver.
+ * @platform_data: Initializes spi_device.platform_data; the particular
+ *	data stored there is driver-specific.
+ * @controller_data: Initializes spi_device.controller_data; some
+ *	controllers need hints about hardware setup, e.g. for DMA.
+ * @irq: Initializes spi_device.irq; depends on how the board is wired.
+ * @max_speed_hz: Initializes spi_device.max_speed_hz; based on limits
+ *	from the chip datasheet and board-specific signal quality issues.
+ * @bus_num: Identifies which spi_master parents the spi_device; unused
+ *	by spi_new_device(), and otherwise depends on board wiring.
+ * @chip_select: Initializes spi_device.chip_select; depends on how
+ *	the board is wired.
+ * @mode: Initializes spi_device.mode; based on the chip datasheet, board
+ *	wiring (some devices support both 3WIRE and standard modes), and
+ *	possibly presence of an inverter in the chipselect path.
+ *
+ * When adding new SPI devices to the device tree, these structures serve
+ * as a partial device template.  They hold information which can't always
+ * be determined by drivers.  Information that probe() can establish (such
+ * as the default transfer wordsize) is not included here.
+ *
+ * These structures are used in two places.  Their primary role is to
+ * be stored in tables of board-specific device descriptors, which are
+ * declared early in board initialization and then used (much later) to
+ * populate a controller's device tree after the that controller's driver
+ * initializes.  A secondary (and atypical) role is as a parameter to
+ * spi_new_device() call, which happens after those controller drivers
+ * are active in some dynamic board configuration models.
+ */
 struct spi_board_info {
 	/* the device name and module name are coupled, like platform_bus;
 	 * "modalias" is normally the driver name.
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-mmc.patch
git-mtd.patch
dma_free_coherent-needs-irqs-enabled-sigh.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
clean-up-duplicate-includes-in-drivers-spi.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
