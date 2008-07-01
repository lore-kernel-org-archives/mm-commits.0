From: akpm@linux-foundation.org
Subject: + gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch added to -mm tree
Date: Tue, 01 Jul 2008 01:32:26 -0700
Message-ID: <200807010832.m618WQLK017563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754432AbYGAIcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 04:32:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     gpio: mcp23s08 handles multiple chips per chipselect
has been added to the -mm tree.  Its filename is
     gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch

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
Subject: gpio: mcp23s08 handles multiple chips per chipselect
From: David Brownell <david-b@pacbell.net>

Teach the mcp23s08 driver about a curious feature of these chips: up to
four of them can share the same chipselect, with the SPI signals wired in
parallel, by matching two bits in the first protocol byte against two
address lines on the chip.

This is handled by three software changes:

  * Platform data now holds an array of per-chip structs, not
    just one chip's address and pullup configuration.

  * Probe() and remove() now use another level of structure,
    wrapping an instance of the original structure for each
    mcp23s08 chip sharing that chipselect.

  * The HAEN bit is set, so that the hardware address bits can no
    longer be ignored (boot firmware may not have enabled them).

The "one struct per chip" preserves the guts of the current code,
but platform_data will need minor changes.

    OLD:
	/* incorrect "slave" ID may not have mattered */
	.slave = 3,
	.pullups = BIT(3) | BIT(1) | BIT(0),

    NEW:
	/* slave address _must_ match chip's wiring */
	.chip[3] = {
		.is_present = true,
		.pullups = BIT(3) | BIT(1) | BIT(0),
	},

There's no change in how things _behave_ for spi_device nodes with a
single mcp23s08 chip.  New multi-chip configurations assign GPIOs in
sequence, without holes.  The spi_device just resembles a bigger
controller, but internally it has multiple gpio_chip instances.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/mcp23s08.c      |  133 +++++++++++++++++++++++++--------
 include/linux/spi/mcp23s08.h |   27 ++++--
 2 files changed, 119 insertions(+), 41 deletions(-)

diff -puN drivers/gpio/mcp23s08.c~gpio-mcp23s08-handles-multiple-chips-per-chipselect drivers/gpio/mcp23s08.c
--- a/drivers/gpio/mcp23s08.c~gpio-mcp23s08-handles-multiple-chips-per-chipselect
+++ a/drivers/gpio/mcp23s08.c
@@ -40,15 +40,26 @@ struct mcp23s08 {
 	struct spi_device	*spi;
 	u8			addr;
 
+	u8			cache[11];
 	/* lock protects the cached values */
 	struct mutex		lock;
-	u8			cache[11];
 
 	struct gpio_chip	chip;
 
 	struct work_struct	work;
 };
 
+/* A given spi_device can represent up to four mcp23s08 chips
+ * sharing the same chipselect but using different addresses
+ * (e.g. chips #0 and #3 might be populated, but not #1 or $2).
+ * Driver data holds all the per-chip data.
+ */
+struct mcp23s08_driver_data {
+	unsigned		ngpio;
+	struct mcp23s08		*mcp[4];
+	struct mcp23s08		chip[];
+};
+
 static int mcp23s08_read(struct mcp23s08 *mcp, unsigned reg)
 {
 	u8	tx[2], rx[1];
@@ -208,25 +219,18 @@ done:
 
 /*----------------------------------------------------------------------*/
 
-static int mcp23s08_probe(struct spi_device *spi)
+static int mcp23s08_probe_one(struct spi_device *spi, unsigned addr,
+		unsigned base, unsigned pullups)
 {
-	struct mcp23s08			*mcp;
-	struct mcp23s08_platform_data	*pdata;
+	struct mcp23s08_driver_data	*data = spi_get_drvdata(spi);
+	struct mcp23s08			*mcp = data->mcp[addr];
 	int				status;
 	int				do_update = 0;
 
-	pdata = spi->dev.platform_data;
-	if (!pdata || pdata->slave > 3 || !pdata->base)
-		return -ENODEV;
-
-	mcp = kzalloc(sizeof *mcp, GFP_KERNEL);
-	if (!mcp)
-		return -ENOMEM;
-
 	mutex_init(&mcp->lock);
 
 	mcp->spi = spi;
-	mcp->addr = 0x40 | (pdata->slave << 1);
+	mcp->addr = 0x40 | (addr << 1);
 
 	mcp->chip.label = "mcp23s08",
 
@@ -236,27 +240,28 @@ static int mcp23s08_probe(struct spi_dev
 	mcp->chip.set = mcp23s08_set;
 	mcp->chip.dbg_show = mcp23s08_dbg_show;
 
-	mcp->chip.base = pdata->base;
+	mcp->chip.base = base;
 	mcp->chip.ngpio = 8;
 	mcp->chip.can_sleep = 1;
 	mcp->chip.dev = &spi->dev;
 	mcp->chip.owner = THIS_MODULE;
 
-	spi_set_drvdata(spi, mcp);
-
-	/* verify MCP_IOCON.SEQOP = 0, so sequential reads work */
+	/* verify MCP_IOCON.SEQOP = 0, so sequential reads work,
+	 * and MCP_IOCON.HAEN = 1, so we work with all chips.
+	 */
 	status = mcp23s08_read(mcp, MCP_IOCON);
 	if (status < 0)
 		goto fail;
-	if (status & IOCON_SEQOP) {
+	if ((status & IOCON_SEQOP) || !(status & IOCON_HAEN)) {
 		status &= ~IOCON_SEQOP;
+		status |= IOCON_HAEN;
 		status = mcp23s08_write(mcp, MCP_IOCON, (u8) status);
 		if (status < 0)
 			goto fail;
 	}
 
 	/* configure ~100K pullups */
-	status = mcp23s08_write(mcp, MCP_GPPU, pdata->pullups);
+	status = mcp23s08_write(mcp, MCP_GPPU, pullups);
 	if (status < 0)
 		goto fail;
 
@@ -283,11 +288,58 @@ static int mcp23s08_probe(struct spi_dev
 		tx[1] = MCP_IPOL;
 		memcpy(&tx[2], &mcp->cache[MCP_IPOL], sizeof(tx) - 2);
 		status = spi_write_then_read(mcp->spi, tx, sizeof tx, NULL, 0);
-
-		/* FIXME check status... */
+		if (status < 0)
+			goto fail;
 	}
 
 	status = gpiochip_add(&mcp->chip);
+fail:
+	if (status < 0)
+		dev_dbg(&spi->dev, "can't setup chip %d, --> %d\n",
+				addr, status);
+	return status;
+}
+
+static int mcp23s08_probe(struct spi_device *spi)
+{
+	struct mcp23s08_platform_data	*pdata;
+	unsigned			addr;
+	unsigned			chips = 0;
+	struct mcp23s08_driver_data	*data;
+	int				status;
+	unsigned			base;
+
+	pdata = spi->dev.platform_data;
+	if (!pdata || !gpio_is_valid(pdata->base))
+		return -ENODEV;
+
+	for (addr = 0; addr < 4; addr++) {
+		if (!pdata->chip[addr].is_present)
+			continue;
+		chips++;
+	}
+	if (!chips)
+		return -ENODEV;
+
+	data = kzalloc(sizeof *data + chips * sizeof(struct mcp23s08),
+			GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	spi_set_drvdata(spi, data);
+
+	base = pdata->base;
+	for (addr = 0; addr < 4; addr++) {
+		if (!pdata->chip[addr].is_present)
+			continue;
+		chips--;
+		data->mcp[addr] = &data->chip[chips];
+		status = mcp23s08_probe_one(spi, addr, base,
+				pdata->chip[addr].pullups);
+		if (status < 0)
+			goto fail;
+		base += 8;
+	}
+	data->ngpio = base - pdata->base;
 
 	/* NOTE:  these chips have a relatively sane IRQ framework, with
 	 * per-signal masking and level/edge triggering.  It's not yet
@@ -295,8 +347,9 @@ static int mcp23s08_probe(struct spi_dev
 	 */
 
 	if (pdata->setup) {
-		status = pdata->setup(spi, mcp->chip.base,
-				mcp->chip.ngpio, pdata->context);
+		status = pdata->setup(spi,
+				pdata->base, data->ngpio,
+				pdata->context);
 		if (status < 0)
 			dev_dbg(&spi->dev, "setup --> %d\n", status);
 	}
@@ -304,19 +357,29 @@ static int mcp23s08_probe(struct spi_dev
 	return 0;
 
 fail:
-	kfree(mcp);
+	for (addr = 0; addr < 4; addr++) {
+		int tmp;
+
+		if (!data->mcp[addr])
+			continue;
+		tmp = gpiochip_remove(&data->mcp[addr]->chip);
+		if (tmp < 0)
+			dev_err(&spi->dev, "%s --> %d\n", "remove", tmp);
+	}
+	kfree(data);
 	return status;
 }
 
 static int mcp23s08_remove(struct spi_device *spi)
 {
-	struct mcp23s08			*mcp = spi_get_drvdata(spi);
+	struct mcp23s08_driver_data	*data = spi_get_drvdata(spi);
 	struct mcp23s08_platform_data	*pdata = spi->dev.platform_data;
+	unsigned			addr;
 	int				status = 0;
 
 	if (pdata->teardown) {
 		status = pdata->teardown(spi,
-				mcp->chip.base, mcp->chip.ngpio,
+				pdata->base, data->ngpio,
 				pdata->context);
 		if (status < 0) {
 			dev_err(&spi->dev, "%s --> %d\n", "teardown", status);
@@ -324,11 +387,20 @@ static int mcp23s08_remove(struct spi_de
 		}
 	}
 
-	status = gpiochip_remove(&mcp->chip);
+	for (addr = 0; addr < 4; addr++) {
+		int tmp;
+
+		if (!data->mcp[addr])
+			continue;
+
+		tmp = gpiochip_remove(&data->mcp[addr]->chip);
+		if (tmp < 0) {
+			dev_err(&spi->dev, "%s --> %d\n", "remove", tmp);
+			status = tmp;
+		}
+	}
 	if (status == 0)
-		kfree(mcp);
-	else
-		dev_err(&spi->dev, "%s --> %d\n", "remove", status);
+		kfree(data);
 	return status;
 }
 
@@ -356,4 +428,3 @@ static void __exit mcp23s08_exit(void)
 module_exit(mcp23s08_exit);
 
 MODULE_LICENSE("GPL");
-
diff -puN include/linux/spi/mcp23s08.h~gpio-mcp23s08-handles-multiple-chips-per-chipselect include/linux/spi/mcp23s08.h
--- a/include/linux/spi/mcp23s08.h~gpio-mcp23s08-handles-multiple-chips-per-chipselect
+++ a/include/linux/spi/mcp23s08.h
@@ -1,18 +1,25 @@
 
-/* FIXME driver should be able to handle all four slaves that
- * can be hooked up to each chipselect, as well as IRQs...
- */
+/* FIXME driver should be able to handle IRQs...  */
 
-struct mcp23s08_platform_data {
-	/* four slaves can share one SPI chipselect */
-	u8		slave;
+struct mcp23s08_chip_info {
+	bool	is_present;		/* true iff populated */
+	u8	pullups;		/* BIT(x) means enable pullup x */
+};
 
-	/* number assigned to the first GPIO */
+struct mcp23s08_platform_data {
+	/* Four slaves (numbered 0..3) can share one SPI chipselect, and
+	 * will provide 8..32 GPIOs using 1..4 gpio_chip instances.
+	 */
+	struct mcp23s08_chip_info	chip[4];
+
+	/* "base" is the number of the first GPIO.  Dynamic assignment is
+	 * not currently supported, and even if there are gaps in chip
+	 * addressing the GPIO numbers are sequential .. so for example
+	 * if only slaves 0 and 3 are present, their GPIOs range from
+	 * base to base+15.
+	 */
 	unsigned	base;
 
-	/* pins with pullups */
-	u8		pullups;
-
 	void		*context;	/* param to setup/teardown */
 
 	int		(*setup)(struct spi_device *spi,
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc_read_alarm-handles-wraparound.patch
gpio-pca953x-i2c-handles-max7310-too.patch
ntp-let-update_persistent_clock-sleep.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
asic3-gpiolib-support.patch
asic3-remove-children-platform-data.patch
asic3-new-gpio-configuration-code.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch
rtc-remove-bkl-for-ioctl.patch
rtc-add-support-for-st-m41t94-spi-rtc.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-sysfs-interface-updated-update.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch

