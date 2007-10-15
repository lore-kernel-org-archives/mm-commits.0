From: akpm@linux-foundation.org
Subject: - blackfin-on-chip-nand-flash-controller-driver.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:17:29 -0700
Message-ID: <200710150917.l9F9HT9w027279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57456 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753564AbXJOJSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:18:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     Blackfin on-chip NAND Flash Controller driver
has been removed from the -mm tree.  Its filename was
     blackfin-on-chip-nand-flash-controller-driver.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: Blackfin on-chip NAND Flash Controller driver
=46rom: Bryan Wu <bryan.wu@analog.com>

This is the driver for latest Blackfin on-chip nand flash controller

 - use nand_chip and mtd_info common nand driver interface
 - provide both PIO and dma operation
 - compiled with ezkit bf548 configuration
 - use hardware 1-bit ECC
 - tested with YAFFS2 and can mount YAFFS2 filesystem as rootfs

ChangeLog from try#1
 - use hweight32() instead of count_bits()
 - replace bf54x with bf5xx and BF54X with BF5XX
 - compare against plat->page_size in 2 cases when enable hardware ECC

ChangeLog from try#2
 - passed nand_test suites
 - use cpu_relax() instead of busy wait loop
 - some coding style issue pointed out by Andrew

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/Kconfig              |   19=20
 drivers/mtd/nand/Makefile             |    1=20
 drivers/mtd/nand/bf5xx_nand.c         |  788 ++++++++++++++++++++++++
 include/asm-blackfin/mach-bf548/dma.h |    1=20
 include/asm-blackfin/nand.h           |   47 +
 5 files changed, 856 insertions(+)

diff -puN drivers/mtd/nand/Kconfig~blackfin-on-chip-nand-flash-controll=
er-driver drivers/mtd/nand/Kconfig
--- a/drivers/mtd/nand/Kconfig~blackfin-on-chip-nand-flash-controller-d=
river
+++ a/drivers/mtd/nand/Kconfig
@@ -91,6 +91,25 @@ config MTD_NAND_AU1550
 	  This enables the driver for the NAND flash controller on the
 	  AMD/Alchemy 1550 SOC.
=20
+config MTD_NAND_BF5XX
+	tristate "Blackfin on-chip NAND Flash Controller driver"
+	depends on BF54x && MTD_NAND
+	help
+	  This enables the Blackfin on-chip NAND flash controller
+
+	  No board specific support is done by this driver, each board
+	  must advertise a platform_device for the driver to attach.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called bf5xx-nand.
+
+config MTD_NAND_BF5XX_HWECC
+	bool "BF5XX NAND Hardware ECC"
+	depends on MTD_NAND_BF5XX
+	help
+	  Enable the use of the BF5XX's internal ECC generator when
+	  using NAND.
+
 config MTD_NAND_RTC_FROM4
 	tristate "Renesas Flash ROM 4-slot interface board (FROM_BOARD4)"
 	depends on SH_SOLUTION_ENGINE
diff -puN drivers/mtd/nand/Makefile~blackfin-on-chip-nand-flash-control=
ler-driver drivers/mtd/nand/Makefile
--- a/drivers/mtd/nand/Makefile~blackfin-on-chip-nand-flash-controller-=
driver
+++ a/drivers/mtd/nand/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_MTD_NAND_TOTO)		+=3D toto.o
 obj-$(CONFIG_MTD_NAND_AUTCPU12)		+=3D autcpu12.o
 obj-$(CONFIG_MTD_NAND_EDB7312)		+=3D edb7312.o
 obj-$(CONFIG_MTD_NAND_AU1550)		+=3D au1550nd.o
+obj-$(CONFIG_MTD_NAND_BF5XX)		+=3D bf5xx_nand.o
 obj-$(CONFIG_MTD_NAND_PPCHAMELEONEVB)	+=3D ppchameleonevb.o
 obj-$(CONFIG_MTD_NAND_S3C2410)		+=3D s3c2410.o
 obj-$(CONFIG_MTD_NAND_DISKONCHIP)	+=3D diskonchip.o
diff -puN /dev/null drivers/mtd/nand/bf5xx_nand.c
--- /dev/null
+++ a/drivers/mtd/nand/bf5xx_nand.c
@@ -0,0 +1,788 @@
+/* linux/drivers/mtd/nand/bf5xx_nand.c
+ *
+ * Copyright 2006-2007 Analog Devices Inc.
+ *	http://blackfin.uclinux.org/
+ *	Bryan Wu <bryan.wu@analog.com>
+ *
+ * Blackfin BF5xx on-chip NAND flash controler driver
+ *
+ * Derived from drivers/mtd/nand/s3c2410.c
+ * Copyright (c) 2007 Ben Dooks <ben@simtec.co.uk>
+ *
+ * Derived from drivers/mtd/nand/cafe.c
+ * Copyright =C2=A9 2006 Red Hat, Inc.
+ * Copyright =C2=A9 2006 David Woodhouse <dwmw2@infradead.org>
+ *
+ * Changelog:
+ *	12-Jun-2007  Bryan Wu:  Initial version
+ *	18-Jul-2007  Bryan Wu:
+ *		- ECC_HW and ECC_SW supported
+ *		- DMA supported in ECC_HW
+ *		- YAFFS tested as rootfs in both ECC_HW and ECC_SW
+ *
+ * TODO:
+ * 	Enable JFFS2 over NAND as rootfs
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7  USA
+*/
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/bitops.h>
+
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/nand_ecc.h>
+#include <linux/mtd/partitions.h>
+
+#include <asm/blackfin.h>
+#include <asm/dma.h>
+#include <asm/cacheflush.h>
+#include <asm/nand.h>
+#include <asm/portmux.h>
+
+#define DRV_NAME	"bf5xx-nand"
+#define DRV_VERSION	"1.2"
+#define DRV_AUTHOR	"Bryan Wu <bryan.wu@analog.com>"
+#define DRV_DESC	"BF5xx on-chip NAND FLash Controller Driver"
+
+#ifdef CONFIG_MTD_NAND_BF5XX_HWECC
+static int hardware_ecc =3D 1;
+#else
+static int hardware_ecc;
+#endif
+
+static unsigned short bfin_nfc_pin_req[] =3D {P_NAND_CE, P_NAND_RB, 0}=
;
+
+/*
+ * Data structures for bf5xx nand flash controller driver
+ */
+
+/* bf5xx nand info */
+struct bf5xx_nand_info {
+	/* mtd info */
+	struct nand_hw_control		controller;
+	struct mtd_info			mtd;
+	struct nand_chip		chip;
+
+	/* platform info */
+	struct bf5xx_nand_platform	*platform;
+
+	/* device info */
+	struct device			*device;
+
+	/* DMA stuff */
+	struct completion		dma_completion;
+};
+
+/*
+ * Conversion functions
+ */
+static struct bf5xx_nand_info *mtd_to_nand_info(struct mtd_info *mtd)
+{
+	return container_of(mtd, struct bf5xx_nand_info, mtd);
+}
+
+static struct bf5xx_nand_info *to_nand_info(struct platform_device *pd=
ev)
+{
+	return platform_get_drvdata(pdev);
+}
+
+static struct bf5xx_nand_platform *to_nand_plat(struct platform_device=
 *pdev)
+{
+	return pdev->dev.platform_data;
+}
+
+/*
+ * struct nand_chip interface function pointers
+ */
+
+/*
+ * bf5xx_nand_hwcontrol
+ *
+ * Issue command and address cycles to the chip
+ */
+static void bf5xx_nand_hwcontrol(struct mtd_info *mtd, int cmd,
+				   unsigned int ctrl)
+{
+	if (cmd =3D=3D NAND_CMD_NONE)
+		return;
+
+	while (bfin_read_NFC_STAT() & WB_FULL)
+		cpu_relax();
+
+	if (ctrl & NAND_CLE)
+		bfin_write_NFC_CMD(cmd);
+	else
+		bfin_write_NFC_ADDR(cmd);
+	SSYNC();
+}
+
+/*
+ * bf5xx_nand_devready()
+ *
+ * returns 0 if the nand is busy, 1 if it is ready
+ */
+static int bf5xx_nand_devready(struct mtd_info *mtd)
+{
+	unsigned short val =3D bfin_read_NFC_IRQSTAT();
+
+	if ((val & NBUSYIRQ) =3D=3D NBUSYIRQ)
+		return 1;
+	else
+		return 0;
+}
+
+/*
+ * ECC functions
+ * These allow the bf5xx to use the controller's ECC
+ * generator block to ECC the data as it passes through
+ */
+
+/*
+ * ECC error correction function
+ */
+static int bf5xx_nand_correct_data_256(struct mtd_info *mtd, u_char *d=
at,
+					u_char *read_ecc, u_char *calc_ecc)
+{
+	struct bf5xx_nand_info *info =3D mtd_to_nand_info(mtd);
+	u32 syndrome[5];
+	u32 calced, stored;
+	int i;
+	unsigned short failing_bit, failing_byte;
+	u_char data;
+
+	calced =3D calc_ecc[0] | (calc_ecc[1] << 8) | (calc_ecc[2] << 16);
+	stored =3D read_ecc[0] | (read_ecc[1] << 8) | (read_ecc[2] << 16);
+
+	syndrome[0] =3D (calced ^ stored);
+
+	/*
+	 * syndrome 0: all zero
+	 * No error in data
+	 * No action
+	 */
+	if (!syndrome[0] || !calced || !stored)
+		return 0;
+
+	/*
+	 * sysdrome 0: only one bit is one
+	 * ECC data was incorrect
+	 * No action
+	 */
+	if (hweight32(syndrome[0]) =3D=3D 1) {
+		dev_err(info->device, "ECC data was incorrect!\n");
+		return 1;
+	}
+
+	syndrome[1] =3D (calced & 0x7FF) ^ (stored & 0x7FF);
+	syndrome[2] =3D (calced & 0x7FF) ^ ((calced >> 11) & 0x7FF);
+	syndrome[3] =3D (stored & 0x7FF) ^ ((stored >> 11) & 0x7FF);
+	syndrome[4] =3D syndrome[2] ^ syndrome[3];
+
+	for (i =3D 0; i < 5; i++)
+		dev_info(info->device, "syndrome[%d] 0x%08x\n", i, syndrome[i]);
+
+	dev_info(info->device,
+		"calced[0x%08x], stored[0x%08x]\n",
+		calced, stored);
+
+	/*
+	 * sysdrome 0: exactly 11 bits are one, each parity
+	 * and parity' pair is 1 & 0 or 0 & 1.
+	 * 1-bit correctable error
+	 * Correct the error
+	 */
+	if (hweight32(syndrome[0]) =3D=3D 11 && syndrome[4] =3D=3D 0x7FF) {
+		dev_info(info->device,
+			"1-bit correctable error, correct it.\n");
+		dev_info(info->device,
+			"syndrome[1] 0x%08x\n", syndrome[1]);
+
+		failing_bit =3D syndrome[1] & 0x7;
+		failing_byte =3D syndrome[1] >> 0x3;
+		data =3D *(dat + failing_byte);
+		data =3D data ^ (0x1 << failing_bit);
+		*(dat + failing_byte) =3D data;
+
+		return 0;
+	}
+
+	/*
+	 * sysdrome 0: random data
+	 * More than 1-bit error, non-correctable error
+	 * Discard data, mark bad block
+	 */
+	dev_err(info->device,
+		"More than 1-bit error, non-correctable error.\n");
+	dev_err(info->device,
+		"Please discard data, mark bad block\n");
+
+	return 1;
+}
+
+static int bf5xx_nand_correct_data(struct mtd_info *mtd, u_char *dat,
+					u_char *read_ecc, u_char *calc_ecc)
+{
+	struct bf5xx_nand_info *info =3D mtd_to_nand_info(mtd);
+	struct bf5xx_nand_platform *plat =3D info->platform;
+	unsigned short page_size =3D (plat->page_size ? 512 : 256);
+	int ret;
+
+	ret =3D bf5xx_nand_correct_data_256(mtd, dat, read_ecc, calc_ecc);
+
+	/* If page size is 512, correct second 256 bytes */
+	if (page_size =3D=3D 512) {
+		dat +=3D 256;
+		read_ecc +=3D 8;
+		calc_ecc +=3D 8;
+		ret =3D bf5xx_nand_correct_data_256(mtd, dat, read_ecc, calc_ecc);
+	}
+
+	return ret;
+}
+
+static void bf5xx_nand_enable_hwecc(struct mtd_info *mtd, int mode)
+{
+	return;
+}
+
+static int bf5xx_nand_calculate_ecc(struct mtd_info *mtd,
+		const u_char *dat, u_char *ecc_code)
+{
+	struct bf5xx_nand_info *info =3D mtd_to_nand_info(mtd);
+	struct bf5xx_nand_platform *plat =3D info->platform;
+	u16 page_size =3D (plat->page_size ? 512 : 256);
+	u16 ecc0, ecc1;
+	u32 code[2];
+	u8 *p;
+	int bytes =3D 3, i;
+
+	/* first 4 bytes ECC code for 256 page size */
+	ecc0 =3D bfin_read_NFC_ECC0();
+	ecc1 =3D bfin_read_NFC_ECC1();
+
+	code[0] =3D (ecc0 & 0x3FF) | ((ecc1 & 0x3FF) << 11);
+
+	dev_dbg(info->device, "returning ecc 0x%08x\n", code[0]);
+
+	/* second 4 bytes ECC code for 512 page size */
+	if (page_size =3D=3D 512) {
+		ecc0 =3D bfin_read_NFC_ECC2();
+		ecc1 =3D bfin_read_NFC_ECC3();
+		code[1] =3D (ecc0 & 0x3FF) | ((ecc1 & 0x3FF) << 11);
+		bytes =3D 6;
+		dev_dbg(info->device, "returning ecc 0x%08x\n", code[1]);
+	}
+
+	p =3D (u8 *)code;
+	for (i =3D 0; i < bytes; i++)
+		ecc_code[i] =3D p[i];
+
+	return 0;
+}
+
+/*
+ * PIO mode for buffer writing and reading
+ */
+static void bf5xx_nand_read_buf(struct mtd_info *mtd, uint8_t *buf, in=
t len)
+{
+	int i;
+	unsigned short val;
+
+	/*
+	 * Data reads are requested by first writing to NFC_DATA_RD
+	 * and then reading back from NFC_READ.
+	 */
+	for (i =3D 0; i < len; i++) {
+		while (bfin_read_NFC_STAT() & WB_FULL)
+			cpu_relax();
+
+		/* Contents do not matter */
+		bfin_write_NFC_DATA_RD(0x0000);
+		SSYNC();
+
+		while ((bfin_read_NFC_IRQSTAT() & RD_RDY) !=3D RD_RDY)
+			cpu_relax();
+
+		buf[i] =3D bfin_read_NFC_READ();
+
+		val =3D bfin_read_NFC_IRQSTAT();
+		val |=3D RD_RDY;
+		bfin_write_NFC_IRQSTAT(val);
+		SSYNC();
+	}
+}
+
+static uint8_t bf5xx_nand_read_byte(struct mtd_info *mtd)
+{
+	uint8_t val;
+
+	bf5xx_nand_read_buf(mtd, &val, 1);
+
+	return val;
+}
+
+static void bf5xx_nand_write_buf(struct mtd_info *mtd,
+				const uint8_t *buf, int len)
+{
+	int i;
+
+	for (i =3D 0; i < len; i++) {
+		while (bfin_read_NFC_STAT() & WB_FULL)
+			cpu_relax();
+
+		bfin_write_NFC_DATA_WR(buf[i]);
+		SSYNC();
+	}
+}
+
+static void bf5xx_nand_read_buf16(struct mtd_info *mtd, uint8_t *buf, =
int len)
+{
+	int i;
+	u16 *p =3D (u16 *) buf;
+	len >>=3D 1;
+
+	/*
+	 * Data reads are requested by first writing to NFC_DATA_RD
+	 * and then reading back from NFC_READ.
+	 */
+	bfin_write_NFC_DATA_RD(0x5555);
+
+	SSYNC();
+
+	for (i =3D 0; i < len; i++)
+		p[i] =3D bfin_read_NFC_READ();
+}
+
+static void bf5xx_nand_write_buf16(struct mtd_info *mtd,
+				const uint8_t *buf, int len)
+{
+	int i;
+	u16 *p =3D (u16 *) buf;
+	len >>=3D 1;
+
+	for (i =3D 0; i < len; i++)
+		bfin_write_NFC_DATA_WR(p[i]);
+
+	SSYNC();
+}
+
+/*
+ * DMA functions for buffer writing and reading
+ */
+static irqreturn_t bf5xx_nand_dma_irq(int irq, void *dev_id)
+{
+	struct bf5xx_nand_info *info =3D dev_id;
+
+	clear_dma_irqstat(CH_NFC);
+	disable_dma(CH_NFC);
+	complete(&info->dma_completion);
+
+	return IRQ_HANDLED;
+}
+
+static int bf5xx_nand_dma_rw(struct mtd_info *mtd,
+				uint8_t *buf, int is_read)
+{
+	struct bf5xx_nand_info *info =3D mtd_to_nand_info(mtd);
+	struct bf5xx_nand_platform *plat =3D info->platform;
+	unsigned short page_size =3D (plat->page_size ? 512 : 256);
+	unsigned short val;
+
+	dev_dbg(info->device, " mtd->%p, buf->%p, is_read %d\n",
+			mtd, buf, is_read);
+
+	/*
+	 * Before starting a dma transfer, be sure to invalidate/flush
+	 * the cache over the address range of your DMA buffer to
+	 * prevent cache coherency problems. Otherwise very subtle bugs
+	 * can be introduced to your driver.
+	 */
+	if (is_read)
+		invalidate_dcache_range((unsigned int)buf,
+				(unsigned int)(buf + page_size));
+	else
+		flush_dcache_range((unsigned int)buf,
+				(unsigned int)(buf + page_size));
+
+	/*
+	 * This register must be written before each page is
+	 * transferred to generate the correct ECC register
+	 * values.
+	 */
+	bfin_write_NFC_RST(0x1);
+	SSYNC();
+
+	disable_dma(CH_NFC);
+	clear_dma_irqstat(CH_NFC);
+
+	/* setup DMA register with Blackfin DMA API */
+	set_dma_config(CH_NFC, 0x0);
+	set_dma_start_addr(CH_NFC, (unsigned long) buf);
+	set_dma_x_count(CH_NFC, (page_size >> 2));
+	set_dma_x_modify(CH_NFC, 4);
+
+	/* setup write or read operation */
+	val =3D DI_EN | WDSIZE_32;
+	if (is_read)
+		val |=3D WNR;
+	set_dma_config(CH_NFC, val);
+	enable_dma(CH_NFC);
+
+	/* Start PAGE read/write operation */
+	if (is_read)
+		bfin_write_NFC_PGCTL(0x1);
+	else
+		bfin_write_NFC_PGCTL(0x2);
+	wait_for_completion(&info->dma_completion);
+
+	return 0;
+}
+
+static void bf5xx_nand_dma_read_buf(struct mtd_info *mtd,
+					uint8_t *buf, int len)
+{
+	struct bf5xx_nand_info *info =3D mtd_to_nand_info(mtd);
+	struct bf5xx_nand_platform *plat =3D info->platform;
+	unsigned short page_size =3D (plat->page_size ? 512 : 256);
+
+	dev_dbg(info->device, "mtd->%p, buf->%p, int %d\n", mtd, buf, len);
+
+	if (len =3D=3D page_size)
+		bf5xx_nand_dma_rw(mtd, buf, 1);
+	else
+		bf5xx_nand_read_buf(mtd, buf, len);
+}
+
+static void bf5xx_nand_dma_write_buf(struct mtd_info *mtd,
+				const uint8_t *buf, int len)
+{
+	struct bf5xx_nand_info *info =3D mtd_to_nand_info(mtd);
+	struct bf5xx_nand_platform *plat =3D info->platform;
+	unsigned short page_size =3D (plat->page_size ? 512 : 256);
+
+	dev_dbg(info->device, "mtd->%p, buf->%p, len %d\n", mtd, buf, len);
+
+	if (len =3D=3D page_size)
+		bf5xx_nand_dma_rw(mtd, (uint8_t *)buf, 0);
+	else
+		bf5xx_nand_write_buf(mtd, buf, len);
+}
+
+/*
+ * System initialization functions
+ */
+
+static int bf5xx_nand_dma_init(struct bf5xx_nand_info *info)
+{
+	int ret;
+	unsigned short val;
+
+	/* Do not use dma */
+	if (!hardware_ecc)
+		return 0;
+
+	init_completion(&info->dma_completion);
+
+	/* Setup DMAC1 channel mux for NFC which shared with SDH */
+	val =3D bfin_read_DMAC1_PERIMUX();
+	val &=3D 0xFFFE;
+	bfin_write_DMAC1_PERIMUX(val);
+	SSYNC();
+
+	/* Request NFC DMA channel */
+	ret =3D request_dma(CH_NFC, "BF5XX NFC driver");
+	if (ret < 0) {
+		dev_err(info->device, " unable to get DMA channel\n");
+		return ret;
+	}
+
+	set_dma_callback(CH_NFC, (void *) bf5xx_nand_dma_irq, (void *) info);
+
+	/* Turn off the DMA channel first */
+	disable_dma(CH_NFC);
+	return 0;
+}
+
+/*
+ * BF5XX NFC hardware initialization
+ *  - pin mux setup
+ *  - clear interrupt status
+ */
+static int bf5xx_nand_hw_init(struct bf5xx_nand_info *info)
+{
+	int err =3D 0;
+	unsigned short val;
+	struct bf5xx_nand_platform *plat =3D info->platform;
+
+	/* setup NFC_CTL register */
+	dev_info(info->device,
+		"page_size=3D%d, data_width=3D%d, wr_dly=3D%d, rd_dly=3D%d\n",
+		(plat->page_size ? 512 : 256),
+		(plat->data_width ? 16 : 8),
+		plat->wr_dly, plat->rd_dly);
+
+	val =3D (plat->page_size << NFC_PG_SIZE_OFFSET) |
+		(plat->data_width << NFC_NWIDTH_OFFSET) |
+		(plat->rd_dly << NFC_RDDLY_OFFSET) |
+		(plat->rd_dly << NFC_WRDLY_OFFSET);
+	dev_dbg(info->device, "NFC_CTL is 0x%04x\n", val);
+
+	bfin_write_NFC_CTL(val);
+	SSYNC();
+
+	/* clear interrupt status */
+	bfin_write_NFC_IRQMASK(0x0);
+	SSYNC();
+	val =3D bfin_read_NFC_IRQSTAT();
+	bfin_write_NFC_IRQSTAT(val);
+	SSYNC();
+
+	if (peripheral_request_list(bfin_nfc_pin_req, DRV_NAME)) {
+		printk(KERN_ERR DRV_NAME
+		": Requesting Peripherals failed\n");
+		return -EFAULT;
+	}
+
+	/* DMA initialization  */
+	if (bf5xx_nand_dma_init(info))
+		err =3D -ENXIO;
+
+	return err;
+}
+
+/*
+ * Device management interface
+ */
+static int bf5xx_nand_add_partition(struct bf5xx_nand_info *info)
+{
+	struct mtd_info *mtd =3D &info->mtd;
+
+#ifdef CONFIG_MTD_PARTITIONS
+	struct mtd_partition *parts =3D info->platform->partitions;
+	int nr =3D info->platform->nr_partitions;
+
+	return add_mtd_partitions(mtd, parts, nr);
+#else
+	return add_mtd_device(mtd);
+#endif
+}
+
+static int bf5xx_nand_remove(struct platform_device *pdev)
+{
+	struct bf5xx_nand_info *info =3D to_nand_info(pdev);
+	struct mtd_info *mtd =3D NULL;
+
+	platform_set_drvdata(pdev, NULL);
+
+	/* first thing we need to do is release all our mtds
+	 * and their partitions, then go through freeing the
+	 * resources used
+	 */
+	mtd =3D &info->mtd;
+	if (mtd) {
+		nand_release(mtd);
+		kfree(mtd);
+	}
+
+	peripheral_free_list(bfin_nfc_pin_req);
+
+	/* free the common resources */
+	kfree(info);
+
+	return 0;
+}
+
+/*
+ * bf5xx_nand_probe
+ *
+ * called by device layer when it finds a device matching
+ * one our driver can handled. This code checks to see if
+ * it can allocate all necessary resources then calls the
+ * nand layer to look for devices
+ */
+static int bf5xx_nand_probe(struct platform_device *pdev)
+{
+	struct bf5xx_nand_platform *plat =3D to_nand_plat(pdev);
+	struct bf5xx_nand_info *info =3D NULL;
+	struct nand_chip *chip =3D NULL;
+	struct mtd_info *mtd =3D NULL;
+	int err =3D 0;
+
+	dev_dbg(&pdev->dev, "(%p)\n", pdev);
+
+	if (!plat) {
+		dev_err(&pdev->dev, "no platform specific information\n");
+		goto exit_error;
+	}
+
+	info =3D kzalloc(sizeof(*info), GFP_KERNEL);
+	if (info =3D=3D NULL) {
+		dev_err(&pdev->dev, "no memory for flash info\n");
+		err =3D -ENOMEM;
+		goto exit_error;
+	}
+
+	platform_set_drvdata(pdev, info);
+
+	spin_lock_init(&info->controller.lock);
+	init_waitqueue_head(&info->controller.wq);
+
+	info->device     =3D &pdev->dev;
+	info->platform   =3D plat;
+
+	/* initialise chip data struct */
+	chip =3D &info->chip;
+
+	if (plat->data_width)
+		chip->options |=3D NAND_BUSWIDTH_16;
+
+	chip->options |=3D NAND_CACHEPRG | NAND_SKIP_BBTSCAN;
+
+	chip->read_buf =3D (plat->data_width) ?
+		bf5xx_nand_read_buf16 : bf5xx_nand_read_buf;
+	chip->write_buf =3D (plat->data_width) ?
+		bf5xx_nand_write_buf16 : bf5xx_nand_write_buf;
+
+	chip->read_byte    =3D bf5xx_nand_read_byte;
+
+	chip->cmd_ctrl     =3D bf5xx_nand_hwcontrol;
+	chip->dev_ready    =3D bf5xx_nand_devready;
+
+	chip->priv	   =3D &info->mtd;
+	chip->controller   =3D &info->controller;
+
+	chip->IO_ADDR_R    =3D (void __iomem *) NFC_READ;
+	chip->IO_ADDR_W    =3D (void __iomem *) NFC_DATA_WR;
+
+	chip->chip_delay   =3D 0;
+
+	/* initialise mtd info data struct */
+	mtd 		=3D &info->mtd;
+	mtd->priv	=3D chip;
+	mtd->owner	=3D THIS_MODULE;
+
+	/* initialise the hardware */
+	err =3D bf5xx_nand_hw_init(info);
+	if (err !=3D 0)
+		goto exit_error;
+
+	/* setup hardware ECC data struct */
+	if (hardware_ecc) {
+		if (plat->page_size =3D=3D NFC_PG_SIZE_256) {
+			chip->ecc.bytes =3D 3;
+			chip->ecc.size =3D 256;
+		} else if (plat->page_size =3D=3D NFC_PG_SIZE_512) {
+			chip->ecc.bytes =3D 6;
+			chip->ecc.size =3D 512;
+		}
+
+		chip->read_buf      =3D bf5xx_nand_dma_read_buf;
+		chip->write_buf     =3D bf5xx_nand_dma_write_buf;
+		chip->ecc.calculate =3D bf5xx_nand_calculate_ecc;
+		chip->ecc.correct   =3D bf5xx_nand_correct_data;
+		chip->ecc.mode	    =3D NAND_ECC_HW;
+		chip->ecc.hwctl	    =3D bf5xx_nand_enable_hwecc;
+	} else {
+		chip->ecc.mode	    =3D NAND_ECC_SOFT;
+	}
+
+	/* scan hardware nand chip and setup mtd info data struct */
+	if (nand_scan(mtd, 1)) {
+		err =3D -ENXIO;
+		goto exit_error;
+	}
+
+	/* add NAND partition */
+	bf5xx_nand_add_partition(info);
+
+	dev_dbg(&pdev->dev, "initialised ok\n");
+	return 0;
+
+exit_error:
+	bf5xx_nand_remove(pdev);
+
+	if (err =3D=3D 0)
+		err =3D -EINVAL;
+	return err;
+}
+
+/* PM Support */
+#ifdef CONFIG_PM
+
+static int bf5xx_nand_suspend(struct platform_device *dev, pm_message_=
t pm)
+{
+	struct bf5xx_nand_info *info =3D platform_get_drvdata(dev);
+
+	return 0;
+}
+
+static int bf5xx_nand_resume(struct platform_device *dev)
+{
+	struct bf5xx_nand_info *info =3D platform_get_drvdata(dev);
+
+	if (info)
+		bf5xx_nand_hw_init(info);
+
+	return 0;
+}
+
+#else
+#define bf5xx_nand_suspend NULL
+#define bf5xx_nand_resume NULL
+#endif
+
+/* driver device registration */
+static struct platform_driver bf5xx_nand_driver =3D {
+	.probe		=3D bf5xx_nand_probe,
+	.remove		=3D bf5xx_nand_remove,
+	.suspend	=3D bf5xx_nand_suspend,
+	.resume		=3D bf5xx_nand_resume,
+	.driver		=3D {
+		.name	=3D DRV_NAME,
+		.owner	=3D THIS_MODULE,
+	},
+};
+
+static int __init bf5xx_nand_init(void)
+{
+	printk(KERN_INFO "%s, Version %s (c) 2007 Analog Devices, Inc.\n",
+		DRV_DESC, DRV_VERSION);
+
+	return platform_driver_register(&bf5xx_nand_driver);
+}
+
+static void __exit bf5xx_nand_exit(void)
+{
+	platform_driver_unregister(&bf5xx_nand_driver);
+}
+
+module_init(bf5xx_nand_init);
+module_exit(bf5xx_nand_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR(DRV_AUTHOR);
+MODULE_DESCRIPTION(DRV_DESC);
diff -puN include/asm-blackfin/mach-bf548/dma.h~blackfin-on-chip-nand-f=
lash-controller-driver include/asm-blackfin/mach-bf548/dma.h
--- a/include/asm-blackfin/mach-bf548/dma.h~blackfin-on-chip-nand-flash=
-controller-driver
+++ a/include/asm-blackfin/mach-bf548/dma.h
@@ -55,6 +55,7 @@
 #define CH_SPORT3_RX		20
 #define CH_SPORT3_TX		21
 #define CH_SDH			22
+#define CH_NFC			22
 #define CH_SPI2			23
=20
 #define CH_MEM_STREAM0_DEST	24
diff -puN /dev/null include/asm-blackfin/nand.h
--- /dev/null
+++ a/include/asm-blackfin/nand.h
@@ -0,0 +1,47 @@
+/* linux/include/asm-blackfin/nand.h
+ *
+ * Copyright (c) 2007 Analog Devices, Inc.
+ *	Bryan Wu <bryan.wu@analog.com>
+ *
+ * BF5XX - NAND flash controller platfrom_device info
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/* struct bf5xx_nand_platform
+ *
+ * define a interface between platfrom board specific code and
+ * bf54x NFC driver.
+ *
+ * nr_partitions =3D number of partitions pointed to be partitoons (or=
 zero)
+ * partitions	 =3D mtd partition list
+ */
+
+#define NFC_PG_SIZE_256		0
+#define NFC_PG_SIZE_512		1
+#define NFC_PG_SIZE_OFFSET	9
+
+#define NFC_NWIDTH_8		0
+#define NFC_NWIDTH_16		1
+#define NFC_NWIDTH_OFFSET	8
+
+#define NFC_RDDLY_OFFSET	4
+#define NFC_WRDLY_OFFSET	0
+
+#define NFC_STAT_NBUSY		1
+
+struct bf5xx_nand_platform {
+	/* NAND chip information */
+	unsigned short		page_size;
+	unsigned short		data_width;
+
+	/* RD/WR strobe delay timing information, all times in SCLK cycles */
+	unsigned short		rd_dly;
+	unsigned short		wr_dly;
+
+	/* NAND MTD partition information */
+	int                     nr_partitions;
+	struct mtd_partition    *partitions;
+};
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
git-input.patch
git-kbuild.patch
add-stack-checking-for-blackfin.patch
kernel-printkc-concerns-about-the-console-handover.patch
bf54x-lq043fb-framebuffer-driver-for-blackfin-bf54x-framebuffer-device-=
driver.patch
bitops-introduce-lock-ops.patch
replace-__attribute_pure__-with-__pure.patch
