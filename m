From: akpm@linux-foundation.org
Subject: - spi_lm70llp-parport-adapter-driver.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:03:00 -0700
Message-ID: <200707172303.l6HN30dq011650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932454AbXGQXQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaiwan@designergraphix.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_lm70llp parport adapter driver
has been removed from the -mm tree.  Its filename was
     spi_lm70llp-parport-adapter-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi_lm70llp parport adapter driver
From: Kaiwan N Billimoria <kaiwan@designergraphix.com>

This adds a driver for the LM70-LLP parport adapter, which is an eval board
for the LM70 temperature sensor.  For those without that board, it may be a
simpler example of a parport-to-SPI adapter then spi_butterfly.

Signed-off-by: Kaiwan N Billimoria <kaiwan@designergraphix.com>

Doc, coding style, and interface updates; build fixes.  Minor rename.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spi-lm70llp |   69 ++++++
 drivers/spi/Kconfig           |    9 
 drivers/spi/Makefile          |    1 
 drivers/spi/spi_lm70llp.c     |  361 ++++++++++++++++++++++++++++++++
 4 files changed, 440 insertions(+)

diff -puN /dev/null Documentation/spi/spi-lm70llp
--- /dev/null
+++ a/Documentation/spi/spi-lm70llp
@@ -0,0 +1,69 @@
+spi_lm70llp :  LM70-LLP parport-to-SPI adapter
+==============================================
+
+Supported board/chip:
+  * National Semiconductor LM70 LLP evaluation board
+    Datasheet: http://www.national.com/pf/LM/LM70.html
+
+Author:
+        Kaiwan N Billimoria <kaiwan@designergraphix.com>
+
+Description
+-----------
+This driver provides glue code connecting a National Semiconductor LM70 LLP
+temperature sensor evaluation board to the kernel's SPI core subsystem.
+
+In effect, this driver turns the parallel port interface on the eval board
+into a SPI bus with a single device, which will be driven by the generic
+LM70 driver (drivers/hwmon/lm70.c).
+
+The hardware interfacing on the LM70 LLP eval board is as follows:
+
+   Parallel                 LM70 LLP
+     Port      Direction   JP2 Header
+   ----------- --------- ----------------
+      D0     2      -         -
+      D1     3     -->      V+   5
+      D2     4     -->      V+   5
+      D3     5     -->      V+   5
+      D4     6     -->      V+   5
+      D5     7     -->      nCS  8
+      D6     8     -->      SCLK 3
+      D7     9     -->      SI/O 5
+     GND    25      -       GND  7
+    Select  13     <--      SI/O 1
+   ----------- --------- ----------------
+
+Note that since the LM70 uses a "3-wire" variant of SPI, the SI/SO pin
+is connected to both pin D7 (as Master Out) and Select (as Master In)
+using an arrangment that lets either the parport or the LM70 pull the
+pin low.  This can't be shared with true SPI devices, but other 3-wire
+devices might share the same SI/SO pin.
+
+The bitbanger routine in this driver (lm70_txrx) is called back from
+the bound "hwmon/lm70" protocol driver through its sysfs hook, using a
+spi_write_then_read() call.  It performs Mode 0 (SPI/Microwire) bitbanging.
+The lm70 driver then inteprets the resulting digital temperature value
+and exports it through sysfs.
+
+A "gotcha": National Semiconductor's LM70 LLP eval board circuit schematic
+shows that the SI/O line from the LM70 chip is connected to the base of a
+transistor Q1 (and also a pullup, and a zener diode to D7); while the
+collector is tied to VCC.
+
+Interpreting this circuit, when the LM70 SI/O line is High (or tristate
+and not grounded by the host via D7), the transistor conducts and switches
+the collector to zero, which is reflected on pin 13 of the DB25 parport
+connector.  When SI/O is Low (driven by the LM70 or the host) on the other
+hand, the transistor is cut off and the voltage tied to it's collector is
+reflected on pin 13 as a High level.
+
+So: the getmiso inline routine in this driver takes this fact into account,
+inverting the value read at pin 13.
+
+
+Thanks to
+---------
+o David Brownell for mentoring the SPI-side driver development.
+o Dr.Craig Hollabaugh for the (early) "manual" bitbanging driver version.
+o Nadir Billimoria for help interpreting the circuit schematic.
diff -puN drivers/spi/Kconfig~spi_lm70llp-parport-adapter-driver drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi_lm70llp-parport-adapter-driver
+++ a/drivers/spi/Kconfig
@@ -107,6 +107,15 @@ config SPI_IMX
 	  This enables using the Freescale iMX SPI controller in master
 	  mode.
 
+config SPI_LM70_LLP
+	tristate "Parallel port adapter for LM70 eval board (DEVELOPMENT)"
+	depends on SPI_MASTER && PARPORT && EXPERIMENTAL
+	select SPI_BITBANG
+	help
+	  This driver supports the NS LM70 LLP Evaluation Board,
+	  which interfaces to an LM70 temperature sensor using
+	  a parallel port.
+
 config SPI_MPC52xx_PSC
 	tristate "Freescale MPC52xx PSC SPI controller"
 	depends on SPI_MASTER && PPC_MPC52xx && EXPERIMENTAL
diff -puN drivers/spi/Makefile~spi_lm70llp-parport-adapter-driver drivers/spi/Makefile
--- a/drivers/spi/Makefile~spi_lm70llp-parport-adapter-driver
+++ a/drivers/spi/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_SPI_BITBANG)		+= spi_bitban
 obj-$(CONFIG_SPI_AU1550)		+= au1550_spi.o
 obj-$(CONFIG_SPI_BUTTERFLY)		+= spi_butterfly.o
 obj-$(CONFIG_SPI_IMX)			+= spi_imx.o
+obj-$(CONFIG_SPI_LM70_LLP)		+= spi_lm70llp.o
 obj-$(CONFIG_SPI_PXA2XX)		+= pxa2xx_spi.o
 obj-$(CONFIG_SPI_OMAP_UWIRE)		+= omap_uwire.o
 obj-$(CONFIG_SPI_MPC52xx_PSC)		+= mpc52xx_psc_spi.o
diff -puN /dev/null drivers/spi/spi_lm70llp.c
--- /dev/null
+++ a/drivers/spi/spi_lm70llp.c
@@ -0,0 +1,361 @@
+/*
+ * spi_lm70llp.c - driver for lm70llp eval board for the LM70 sensor
+ *
+ * Copyright (C) 2006 Kaiwan N Billimoria <kaiwan@designergraphix.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/parport.h>
+#include <linux/sysfs.h>
+#include <linux/workqueue.h>
+
+
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+
+
+/*
+ * The LM70 communicates with a host processor using a 3-wire variant of
+ * the SPI/Microwire bus interface. This driver specifically supports an
+ * NS LM70 LLP Evaluation Board, interfacing to a PC using its parallel
+ * port to bitbang an SPI-parport bridge.  Accordingly, this is an SPI
+ * master controller driver.  The hwmon/lm70 driver is a "SPI protocol
+ * driver", layered on top of this one and usable without the lm70llp.
+ *
+ * The LM70 is a temperature sensor chip from National Semiconductor; its
+ * datasheet is available at http://www.national.com/pf/LM/LM70.html
+ *
+ * Also see Documentation/spi/spi-lm70llp.  The SPI<->parport code here is
+ * (heavily) based on spi-butterfly by David Brownell.
+ *
+ * The LM70 LLP connects to the PC parallel port in the following manner:
+ *
+ *   Parallel                 LM70 LLP
+ *     Port      Direction   JP2 Header
+ *  -----------  ---------  ------------
+ *      D0    2      -         -
+ *      D1    3     -->      V+   5
+ *      D2    4     -->      V+   5
+ *      D3    5     -->      V+   5
+ *      D4    6     -->      V+   5
+ *      D5    7     -->      nCS  8
+ *      D6    8     -->      SCLK 3
+ *      D7    9     -->      SI/O 5
+ *     GND   25      -       GND  7
+ *    Select 13     <--      SI/O 1
+ *
+ * Note that parport pin 13 actually gets inverted by the transistor
+ * arrangement which lets either the parport or the LM70 drive the
+ * SI/SO signal.
+ */
+
+#define DRVNAME		"spi-lm70llp"
+
+#define lm70_INIT	0xBE
+#define SIO		0x10
+#define nCS		0x20
+#define SCLK		0x40
+
+/*-------------------------------------------------------------------------*/
+
+struct spi_lm70llp {
+	struct spi_bitbang	bitbang;
+	struct parport		*port;
+	struct pardevice	*pd;
+	struct spi_device	*spidev_lm70;
+	struct spi_board_info	info;
+	struct class_device	*cdev;
+};
+
+/* REVISIT : ugly global ; provides "exclusive open" facility */
+static struct spi_lm70llp *lm70llp;
+
+
+/*-------------------------------------------------------------------*/
+
+static inline struct spi_lm70llp *spidev_to_pp(struct spi_device *spi)
+{
+	return spi->controller_data;
+}
+
+/*---------------------- LM70 LLP eval board-specific inlines follow */
+
+/* NOTE:  we don't actually need to reread the output values, since they'll
+ * still be what we wrote before.  Plus, going through parport builds in
+ * a ~1ms/operation delay; these SPI transfers could easily be faster.
+ */
+
+static inline void deassertCS(struct spi_lm70llp *pp)
+{
+	u8 data = parport_read_data(pp->port);
+	parport_write_data(pp->port, data | nCS);
+}
+
+static inline void assertCS(struct spi_lm70llp *pp)
+{
+	u8 data = parport_read_data(pp->port);
+	parport_write_data(pp->port, data & ~nCS);
+}
+
+static inline void clkHigh(struct spi_lm70llp *pp)
+{
+	u8 data = parport_read_data(pp->port);
+	parport_write_data(pp->port, data | SCLK);
+}
+
+static inline void clkLow(struct spi_lm70llp *pp)
+{
+	u8 data = parport_read_data(pp->port);
+	parport_write_data(pp->port, data & ~SCLK);
+}
+
+/*------------------------- SPI-LM70-specific inlines ----------------------*/
+
+static inline void spidelay(unsigned d)
+{
+	udelay(d);
+}
+
+static inline void setsck(struct spi_device *s, int is_on)
+{
+	struct spi_lm70llp *pp = spidev_to_pp(s);
+
+	if (is_on)
+		clkHigh(pp);
+	else
+		clkLow(pp);
+}
+
+static inline void setmosi(struct spi_device *s, int is_on)
+{
+	/* FIXME update D7 ... this way we can put the chip
+	 * into shutdown mode and read the manufacturer ID,
+	 * but we can't put it back into operational mode.
+	 */
+}
+
+/*
+ * getmiso:
+ * Why do we return 0 when the SIO line is high and vice-versa?
+ * The fact is, the lm70 eval board from NS (which this driver drives),
+ * is wired in just such a way : when the lm70's SIO goes high, a transistor
+ * switches it to low reflecting this on the parport (pin 13), and vice-versa.
+ */
+static inline int getmiso(struct spi_device *s)
+{
+	struct spi_lm70llp *pp = spidev_to_pp(s);
+	return ((SIO == (parport_read_status(pp->port) & SIO)) ? 0 : 1 );
+}
+/*--------------------------------------------------------------------*/
+
+#define EXPAND_BITBANG_TXRX 1
+#include <linux/spi/spi_bitbang.h>
+
+static void lm70_chipselect(struct spi_device *spi, int value)
+{
+	struct spi_lm70llp *pp = spidev_to_pp(spi);
+
+	if (value)
+		assertCS(pp);
+	else
+		deassertCS(pp);
+}
+
+/*
+ * Our actual bitbanger routine.
+ */
+static u32 lm70_txrx(struct spi_device *spi, unsigned nsecs, u32 word, u8 bits)
+{
+	static u32 sio=0;
+	static int first_time=1;
+
+	/* First time: perform SPI bitbang and return the LSB of
+	 * the result of the SPI call.
+	 */
+	if (first_time) {
+		sio = bitbang_txrx_be_cpha0(spi, nsecs, 0, word, bits);
+		first_time=0;
+		return (sio & 0x00ff);
+	}
+	/* Return the MSB of the result of the SPI call */
+	else {
+		first_time=1;
+		return (sio >> 8);
+	}
+}
+
+static void spi_lm70llp_attach(struct parport *p)
+{
+	struct pardevice	*pd;
+	struct spi_lm70llp	*pp;
+	struct spi_master	*master;
+	int			status;
+
+	if (lm70llp) {
+		printk(KERN_WARNING
+			"%s: spi_lm70llp instance already loaded. Aborting.\n",
+			DRVNAME);
+		return;
+	}
+
+	/* TODO:  this just _assumes_ a lm70 is there ... no probe;
+	 * the lm70 driver could verify it, reading the manf ID.
+	 */
+
+	master = spi_alloc_master(p->physport->dev, sizeof *pp);
+	if (!master) {
+		status = -ENOMEM;
+		goto out_fail;
+	}
+	pp = spi_master_get_devdata(master);
+
+	master->bus_num = -1;	/* dynamic alloc of a bus number */
+	master->num_chipselect = 1;
+
+	/*
+	 * SPI and bitbang hookup.
+	 */
+	pp->bitbang.master = spi_master_get(master);
+	pp->bitbang.chipselect = lm70_chipselect;
+	pp->bitbang.txrx_word[SPI_MODE_0] = lm70_txrx;
+	pp->bitbang.flags = SPI_3WIRE;
+
+	/*
+	 * Parport hookup
+	 */
+	pp->port = p;
+	pd = parport_register_device(p, DRVNAME,
+			NULL, NULL, NULL,
+			PARPORT_FLAG_EXCL, pp);
+	if (!pd) {
+		status = -ENOMEM;
+		goto out_free_master;
+	}
+	pp->pd = pd;
+
+	status = parport_claim(pd);
+	if (status < 0)
+		goto out_parport_unreg;
+
+	/*
+	 * Start SPI ...
+	 */
+	status = spi_bitbang_start(&pp->bitbang);
+	if (status < 0) {
+		printk(KERN_WARNING
+			"%s: spi_bitbang_start failed with status %d\n",
+			DRVNAME, status);
+		goto out_off_and_release;
+	}
+
+	/*
+	 * The modalias name MUST match the device_driver name
+	 * for the bus glue code to match and subsequently bind them.
+	 * We are binding to the generic drivers/hwmon/lm70.c device
+	 * driver.
+	 */
+	strcpy(pp->info.modalias, "lm70");
+	pp->info.max_speed_hz = 6 * 1000 * 1000;
+	pp->info.chip_select = 0;
+	pp->info.mode = SPI_3WIRE | SPI_MODE_0;
+
+	/* power up the chip, and let the LM70 control SI/SO */
+	parport_write_data(pp->port, lm70_INIT);
+
+	/* Enable access to our primary data structure via
+	 * the board info's (void *)controller_data.
+	 */
+	pp->info.controller_data = pp;
+	pp->spidev_lm70 = spi_new_device(pp->bitbang.master, &pp->info);
+	if (pp->spidev_lm70)
+		dev_dbg(&pp->spidev_lm70->dev, "spidev_lm70 at %s\n",
+				pp->spidev_lm70->dev.bus_id);
+	else {
+		printk(KERN_WARNING "%s: spi_new_device failed\n", DRVNAME);
+		status = -ENODEV;
+		goto out_bitbang_stop;
+	}
+	pp->spidev_lm70->bits_per_word = 16;
+
+	lm70llp = pp;
+
+	return;
+
+out_bitbang_stop:
+	spi_bitbang_stop(&pp->bitbang);
+out_off_and_release:
+	/* power down */
+	parport_write_data(pp->port, 0);
+	mdelay(10);
+	parport_release(pp->pd);
+out_parport_unreg:
+	parport_unregister_device(pd);
+out_free_master:
+	(void) spi_master_put(master);
+out_fail:
+	pr_info("%s: spi_lm70llp probe fail, status %d\n", DRVNAME, status);
+}
+
+static void spi_lm70llp_detach(struct parport *p)
+{
+	struct spi_lm70llp		*pp;
+
+	if (!lm70llp || lm70llp->port != p)
+		return;
+
+	pp = lm70llp;
+	spi_bitbang_stop(&pp->bitbang);
+
+	/* power down */
+	parport_write_data(pp->port, 0);
+	msleep(10);
+
+	parport_release(pp->pd);
+	parport_unregister_device(pp->pd);
+
+	(void) spi_master_put(pp->bitbang.master);
+
+	lm70llp = NULL;
+}
+
+
+static struct parport_driver spi_lm70llp_drv = {
+	.name =		DRVNAME,
+	.attach =	spi_lm70llp_attach,
+	.detach =	spi_lm70llp_detach,
+};
+
+static int __init init_spi_lm70llp(void)
+{
+	return parport_register_driver(&spi_lm70llp_drv);
+}
+module_init(init_spi_lm70llp);
+
+static void __exit cleanup_spi_lm70llp(void)
+{
+	parport_unregister_driver(&spi_lm70llp_drv);
+}
+module_exit(cleanup_spi_lm70llp);
+
+MODULE_AUTHOR("Kaiwan N Billimoria <kaiwan@designergraphix.com>");
+MODULE_DESCRIPTION(
+	"Parport adapter for the National Semiconductor LM70 LLP eval board");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from kaiwan@designergraphix.com are

origin.patch
