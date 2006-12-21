From: akpm@osdl.org
Subject: + spi-controller-driver-for-omap-microwire.patch added to -mm tree
Date: Thu, 21 Dec 2006 00:44:44 -0800
Message-ID: <200612210844.kBL8iiIN021960@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49994 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422863AbWLUIo7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 03:44:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     SPI controller driver for OMAP Microwire
has been added to the -mm tree.  Its filename is
     spi-controller-driver-for-omap-microwire.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: SPI controller driver for OMAP Microwire
=46rom: David Brownell <david-b@pacbell.net>

This adds a SPI driver for the Microwire controller on OMAP1 chips.  Th=
is
driver has been used in the Linux-OMAP tree for some time now, includin=
g
with some of those displays using standardized 9-bit commands followed =
by
data with 8-bit words.

Microwire only supports half duplex transfers, but that's all that most=
 SPI
protocols need.  When full duplex, or higher speeds, are needed there a=
re
several other controllers that can be used on OMAP.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/Kconfig      |    7=20
 drivers/spi/Makefile     |    1=20
 drivers/spi/omap_uwire.c |  572 +++++++++++++++++++++++++++++++++++++
 3 files changed, 580 insertions(+)

diff -puN drivers/spi/Kconfig~spi-controller-driver-for-omap-microwire =
drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-controller-driver-for-omap-microwire
+++ a/drivers/spi/Kconfig
@@ -87,6 +87,13 @@ config SPI_MPC83xx
 	  family of PowerPC processors.  The MPC83xx uses a simple set of shi=
ft
 	  registers for data (opposed to the CPM based descriptor model).
=20
+config SPI_OMAP_UWIRE
+	tristate "OMAP1 MicroWire"
+	depends on SPI_MASTER && ARCH_OMAP1
+	select SPI_BITBANG
+	help
+	  This hooks up to the MicroWire controller on OMAP1 chips.
+
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
 	depends on SPI_MASTER && ARCH_PXA && EXPERIMENTAL
diff -puN drivers/spi/Makefile~spi-controller-driver-for-omap-microwire=
 drivers/spi/Makefile
--- a/drivers/spi/Makefile~spi-controller-driver-for-omap-microwire
+++ a/drivers/spi/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_SPI_MASTER)		+=3D spi.o
 obj-$(CONFIG_SPI_BITBANG)		+=3D spi_bitbang.o
 obj-$(CONFIG_SPI_BUTTERFLY)		+=3D spi_butterfly.o
 obj-$(CONFIG_SPI_PXA2XX)		+=3D pxa2xx_spi.o
+obj-$(CONFIG_SPI_OMAP_UWIRE)		+=3D omap_uwire.o
 obj-$(CONFIG_SPI_MPC83xx)		+=3D spi_mpc83xx.o
 obj-$(CONFIG_SPI_S3C24XX_GPIO)		+=3D spi_s3c24xx_gpio.o
 obj-$(CONFIG_SPI_S3C24XX)		+=3D spi_s3c24xx.o
diff -puN /dev/null drivers/spi/omap_uwire.c
--- /dev/null
+++ a/drivers/spi/omap_uwire.c
@@ -0,0 +1,572 @@
+/*
+ * omap_uwire.c -- MicroWire interface driver for OMAP
+ *
+ * Copyright 2003 MontaVista Software Inc. <source@mvista.com>
+ *
+ * Ported to 2.6 OMAP uwire interface.
+ * Copyright (C) 2004 Texas Instruments.
+ *
+ * Generalization patches by Juha Yrj=C3=B6l=C3=A4 <juha.yrjola@nokia.=
com>
+ *
+ * Copyright (C) 2005 David Brownell (ported to 2.6 SPI interface)
+ * Copyright (C) 2006 Nokia
+ *
+ * Many updates by Imre Deak <imre.deak@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License as published by t=
he
+ * Free Software Foundation; either version 2 of the License, or (at y=
our
+ * option) any later version.
+ *
+ * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES O=
=46
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED=
=2E
+ * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING=
, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS O=
=46
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND=
 ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR =
TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE U=
SE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the GNU General Public License a=
long
+ * with this program; if not, write to the Free Software Foundation, I=
nc.,
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+
+#include <asm/system.h>
+#include <asm/irq.h>
+#include <asm/hardware.h>
+#include <asm/io.h>
+#include <asm/mach-types.h>
+
+#include <asm/arch/mux.h>
+#include <asm/arch/omap730.h>	/* OMAP730_IO_CONF registers */
+
+
+/* FIXME address is now a platform device resource,
+ * and irqs should show there too...
+ */
+#define UWIRE_BASE_PHYS		0xFFFB3000
+#define UWIRE_BASE		((void *__iomem)IO_ADDRESS(UWIRE_BASE_PHYS))
+
+/* uWire Registers: */
+#define UWIRE_IO_SIZE 0x20
+#define UWIRE_TDR     0x00
+#define UWIRE_RDR     0x00
+#define UWIRE_CSR     0x01
+#define UWIRE_SR1     0x02
+#define UWIRE_SR2     0x03
+#define UWIRE_SR3     0x04
+#define UWIRE_SR4     0x05
+#define UWIRE_SR5     0x06
+
+/* CSR bits */
+#define	RDRB	(1 << 15)
+#define	CSRB	(1 << 14)
+#define	START	(1 << 13)
+#define	CS_CMD	(1 << 12)
+
+/* SR1 or SR2 bits */
+#define UWIRE_READ_FALLING_EDGE		0x0001
+#define UWIRE_READ_RISING_EDGE		0x0000
+#define UWIRE_WRITE_FALLING_EDGE	0x0000
+#define UWIRE_WRITE_RISING_EDGE		0x0002
+#define UWIRE_CS_ACTIVE_LOW		0x0000
+#define UWIRE_CS_ACTIVE_HIGH		0x0004
+#define UWIRE_FREQ_DIV_2		0x0000
+#define UWIRE_FREQ_DIV_4		0x0008
+#define UWIRE_FREQ_DIV_8		0x0010
+#define UWIRE_CHK_READY			0x0020
+#define UWIRE_CLK_INVERTED		0x0040
+
+
+struct uwire_spi {
+	struct spi_bitbang	bitbang;
+	struct clk		*ck;
+};
+
+struct uwire_state {
+	unsigned	bits_per_word;
+	unsigned	div1_idx;
+};
+
+/* REVISIT compile time constant for idx_shift? */
+static unsigned int uwire_idx_shift;
+
+static inline void uwire_write_reg(int idx, u16 val)
+{
+	__raw_writew(val, UWIRE_BASE + (idx << uwire_idx_shift));
+}
+
+static inline u16 uwire_read_reg(int idx)
+{
+	return __raw_readw(UWIRE_BASE + (idx << uwire_idx_shift));
+}
+
+static inline void omap_uwire_configure_mode(u8 cs, unsigned long flag=
s)
+{
+	u16	w, val =3D 0;
+	int	shift, reg;
+
+	if (flags & UWIRE_CLK_INVERTED)
+		val ^=3D 0x03;
+	val =3D flags & 0x3f;
+	if (cs & 1)
+		shift =3D 6;
+	else
+		shift =3D 0;
+	if (cs <=3D 1)
+		reg =3D UWIRE_SR1;
+	else
+		reg =3D UWIRE_SR2;
+
+	w =3D uwire_read_reg(reg);
+	w &=3D ~(0x3f << shift);
+	w |=3D val << shift;
+	uwire_write_reg(reg, w);
+}
+
+static int wait_uwire_csr_flag(u16 mask, u16 val, int might_not_catch)
+{
+	u16 w;
+	int c =3D 0;
+	unsigned long max_jiffies =3D jiffies + HZ;
+
+	for (;;) {
+		w =3D uwire_read_reg(UWIRE_CSR);
+		if ((w & mask) =3D=3D val)
+			break;
+		if (time_after(jiffies, max_jiffies)) {
+			printk(KERN_ERR "%s: timeout. reg=3D%#06x "
+					"mask=3D%#06x val=3D%#06x\n",
+			       __FUNCTION__, w, mask, val);
+			return -1;
+		}
+		c++;
+		if (might_not_catch && c > 64)
+			break;
+	}
+	return 0;
+}
+
+static void uwire_set_clk1_div(int div1_idx)
+{
+	u16 w;
+
+	w =3D uwire_read_reg(UWIRE_SR3);
+	w &=3D ~(0x03 << 1);
+	w |=3D div1_idx << 1;
+	uwire_write_reg(UWIRE_SR3, w);
+}
+
+static void uwire_chipselect(struct spi_device *spi, int value)
+{
+	struct	uwire_state *ust =3D spi->controller_state;
+	u16	w;
+	int	old_cs;
+
+
+	BUG_ON(wait_uwire_csr_flag(CSRB, 0, 0));
+
+	w =3D uwire_read_reg(UWIRE_CSR);
+	old_cs =3D (w >> 10) & 0x03;
+	if (value =3D=3D BITBANG_CS_INACTIVE || old_cs !=3D spi->chip_select)=
 {
+		/* Deselect this CS, or the previous CS */
+		w &=3D ~CS_CMD;
+		uwire_write_reg(UWIRE_CSR, w);
+	}
+	/* activate specfied chipselect */
+	if (value =3D=3D BITBANG_CS_ACTIVE) {
+		uwire_set_clk1_div(ust->div1_idx);
+		/* invert clock? */
+		if (spi->mode & SPI_CPOL)
+			uwire_write_reg(UWIRE_SR4, 1);
+		else
+			uwire_write_reg(UWIRE_SR4, 0);
+
+		w =3D spi->chip_select << 10;
+		w |=3D CS_CMD;
+		uwire_write_reg(UWIRE_CSR, w);
+	}
+}
+
+static int uwire_txrx(struct spi_device *spi, struct spi_transfer *t)
+{
+	struct uwire_state *ust =3D spi->controller_state;
+	unsigned	len =3D t->len;
+	unsigned	bits =3D ust->bits_per_word;
+	unsigned	bytes;
+	u16		val, w;
+	int		status =3D 0;;
+
+	if (!t->tx_buf && !t->rx_buf)
+		return 0;
+
+	/* Microwire doesn't read and write concurrently */
+	if (t->tx_buf && t->rx_buf)
+		return -EPERM;
+
+	w =3D spi->chip_select << 10;
+	w |=3D CS_CMD;
+
+	if (t->tx_buf) {
+		const u8	*buf =3D t->tx_buf;
+
+		/* NOTE:  DMA could be used for TX transfers */
+
+		/* write one or two bytes at a time */
+		while (len >=3D 1) {
+			/* tx bit 15 is first sent; we byteswap multibyte words
+			 * (msb-first) on the way out from memory.
+			 */
+			val =3D *buf++;
+			if (bits > 8) {
+				bytes =3D 2;
+				val |=3D *buf++ << 8;
+			} else
+				bytes =3D 1;
+			val <<=3D 16 - bits;
+
+#ifdef	VERBOSE
+			pr_debug("%s: write-%d =3D%04x\n",
+					spi->dev.bus_id, bits, val);
+#endif
+			if (wait_uwire_csr_flag(CSRB, 0, 0))
+				goto eio;
+
+			uwire_write_reg(UWIRE_TDR, val);
+
+			/* start write */
+			val =3D START | w | (bits << 5);
+
+			uwire_write_reg(UWIRE_CSR, val);
+			len -=3D bytes;
+
+			/* Wait till write actually starts.
+			 * This is needed with MPU clock 60+ MHz.
+			 * REVISIT: we may not have time to catch it...
+			 */
+			if (wait_uwire_csr_flag(CSRB, CSRB, 1))
+				goto eio;
+
+			status +=3D bytes;
+		}
+
+		/* REVISIT:  save this for later to get more i/o overlap */
+		if (wait_uwire_csr_flag(CSRB, 0, 0))
+			goto eio;
+
+	} else if (t->rx_buf) {
+		u8		*buf =3D t->rx_buf;
+
+		/* read one or two bytes at a time */
+		while (len) {
+			if (bits > 8) {
+				bytes =3D 2;
+			} else
+				bytes =3D 1;
+
+			/* start read */
+			val =3D START | w | (bits << 0);
+			uwire_write_reg(UWIRE_CSR, val);
+			len -=3D bytes;
+
+			/* Wait till read actually starts */
+			(void) wait_uwire_csr_flag(CSRB, CSRB, 1);
+
+			if (wait_uwire_csr_flag(RDRB | CSRB,
+						RDRB, 0))
+				goto eio;
+
+			/* rx bit 0 is last received; multibyte words will
+			 * be properly byteswapped on the way to memory.
+			 */
+			val =3D uwire_read_reg(UWIRE_RDR);
+			val &=3D (1 << bits) - 1;
+			*buf++ =3D (u8) val;
+			if (bytes =3D=3D 2)
+				*buf++ =3D val >> 8;
+			status +=3D bytes;
+#ifdef	VERBOSE
+			pr_debug("%s: read-%d =3D%04x\n",
+					spi->dev.bus_id, bits, val);
+#endif
+
+		}
+	}
+	return status;
+eio:
+	return -EIO;
+}
+
+static int uwire_setup_transfer(struct spi_device *spi, struct spi_tra=
nsfer *t)
+{
+	struct uwire_state	*ust =3D spi->controller_state;
+	struct uwire_spi	*uwire;
+	unsigned		flags =3D 0;
+	unsigned		bits;
+	unsigned		hz;
+	unsigned long		rate;
+	int			div1_idx;
+	int			div1;
+	int			div2;
+	int			status;
+
+	uwire =3D spi_master_get_devdata(spi->master);
+
+	if (spi->chip_select > 3) {
+		pr_debug("%s: cs%d?\n", spi->dev.bus_id, spi->chip_select);
+		status =3D -ENODEV;
+		goto done;
+	}
+
+	bits =3D spi->bits_per_word;
+	if (t !=3D NULL && t->bits_per_word)
+		bits =3D t->bits_per_word;
+	if (!bits)
+		bits =3D 8;
+
+	if (bits > 16) {
+		pr_debug("%s: wordsize %d?\n", spi->dev.bus_id, bits);
+		status =3D -ENODEV;
+		goto done;
+	}
+	ust->bits_per_word =3D bits;
+
+	/* mode 0..3, clock inverted separately;
+	 * standard nCS signaling;
+	 * don't treat DI=3Dhigh as "not ready"
+	 */
+	if (spi->mode & SPI_CS_HIGH)
+		flags |=3D UWIRE_CS_ACTIVE_HIGH;
+
+	if (spi->mode & SPI_CPOL)
+		flags |=3D UWIRE_CLK_INVERTED;
+
+	switch (spi->mode & (SPI_CPOL | SPI_CPHA)) {
+	case SPI_MODE_0:
+	case SPI_MODE_3:
+		flags |=3D UWIRE_WRITE_RISING_EDGE | UWIRE_READ_FALLING_EDGE;
+		break;
+	case SPI_MODE_1:
+	case SPI_MODE_2:
+		flags |=3D UWIRE_WRITE_FALLING_EDGE | UWIRE_READ_RISING_EDGE;
+		break;
+	}
+
+	/* assume it's already enabled */
+	rate =3D clk_get_rate(uwire->ck);
+
+	hz =3D spi->max_speed_hz;
+	if (t !=3D NULL && t->speed_hz)
+		hz =3D t->speed_hz;
+
+	if (!hz) {
+		pr_debug("%s: zero speed?\n", spi->dev.bus_id);
+		status =3D -EINVAL;
+		goto done;
+	}
+
+	/* F_INT =3D mpu_xor_clk / DIV1 */
+	for (div1_idx =3D 0; div1_idx < 4; div1_idx++) {
+		switch (div1_idx) {
+		case 0:
+			div1 =3D 2;
+			break;
+		case 1:
+			div1 =3D 4;
+			break;
+		case 2:
+			div1 =3D 7;
+			break;
+		default:
+		case 3:
+			div1 =3D 10;
+			break;
+		}
+		div2 =3D (rate / div1 + hz - 1) / hz;
+		if (div2 <=3D 8)
+			break;
+	}
+	if (div1_idx =3D=3D 4) {
+		pr_debug("%s: lowest clock %ld, need %d\n",
+			spi->dev.bus_id, rate / 10 / 8, hz);
+			status =3D -EDOM;
+			goto done;
+	}
+
+	/* we have to cache this and reset in uwire_chipselect as this is a
+	 * global parameter and another uwire device can change it under
+	 * us */
+	ust->div1_idx =3D div1_idx;
+	uwire_set_clk1_div(div1_idx);
+
+	rate /=3D div1;
+
+	switch (div2) {
+	case 0:
+	case 1:
+	case 2:
+		flags |=3D UWIRE_FREQ_DIV_2;
+		rate /=3D 2;
+		break;
+	case 3:
+	case 4:
+		flags |=3D UWIRE_FREQ_DIV_4;
+		rate /=3D 4;
+		break;
+	case 5:
+	case 6:
+	case 7:
+	case 8:
+		flags |=3D UWIRE_FREQ_DIV_8;
+		rate /=3D 8;
+		break;
+	}
+	omap_uwire_configure_mode(spi->chip_select, flags);
+	pr_debug("%s: uwire flags %02x, armxor %lu KHz, SCK %lu KHz\n",
+			__FUNCTION__, flags,
+			clk_get_rate(uwire->ck) / 1000,
+			rate / 1000);
+	status =3D 0;
+done:
+	return status;
+}
+
+static int uwire_setup(struct spi_device *spi)
+{
+	struct uwire_state *ust =3D spi->controller_state;
+
+	if (ust =3D=3D NULL) {
+		ust =3D kzalloc(sizeof(*ust), GFP_KERNEL);
+		if (ust =3D=3D NULL)
+			return -ENOMEM;
+		spi->controller_state =3D ust;
+	}
+
+	return uwire_setup_transfer(spi, NULL);
+}
+
+static void uwire_cleanup(const struct spi_device *spi)
+{
+	kfree(spi->controller_state);
+}
+
+static void uwire_off(struct uwire_spi *uwire)
+{
+	uwire_write_reg(UWIRE_SR3, 0);
+	clk_disable(uwire->ck);
+	clk_put(uwire->ck);
+	spi_master_put(uwire->bitbang.master);
+}
+
+static int uwire_probe(struct platform_device *pdev)
+{
+	struct spi_master	*master;
+	struct uwire_spi	*uwire;
+	int			status;
+
+	master =3D spi_alloc_master(&pdev->dev, sizeof *uwire);
+	if (!master)
+		return -ENODEV;
+
+	uwire =3D spi_master_get_devdata(master);
+	dev_set_drvdata(&pdev->dev, uwire);
+
+	uwire->ck =3D clk_get(&pdev->dev, "armxor_ck");
+	if (!uwire->ck || IS_ERR(uwire->ck)) {
+		dev_dbg(&pdev->dev, "no mpu_xor_clk ?\n");
+		spi_master_put(master);
+		return -ENODEV;
+	}
+	clk_enable(uwire->ck);
+
+	if (cpu_is_omap730())
+		uwire_idx_shift =3D 1;
+	else
+		uwire_idx_shift =3D 2;
+
+	uwire_write_reg(UWIRE_SR3, 1);
+
+	master->bus_num =3D 2;	/* "official" */
+	master->num_chipselect =3D 4;
+	master->setup =3D uwire_setup;
+	master->cleanup =3D uwire_cleanup;
+
+	uwire->bitbang.master =3D master;
+	uwire->bitbang.chipselect =3D uwire_chipselect;
+	uwire->bitbang.setup_transfer =3D uwire_setup_transfer;
+	uwire->bitbang.txrx_bufs =3D uwire_txrx;
+
+	status =3D spi_bitbang_start(&uwire->bitbang);
+	if (status < 0)
+		uwire_off(uwire);
+	return status;
+}
+
+static int uwire_remove(struct platform_device *pdev)
+{
+	struct uwire_spi	*uwire =3D dev_get_drvdata(&pdev->dev);
+	int			status;
+
+	// FIXME remove all child devices, somewhere ...
+
+	status =3D spi_bitbang_stop(&uwire->bitbang);
+	uwire_off(uwire);
+	return status;
+}
+
+static struct platform_driver uwire_driver =3D {
+	.driver =3D {
+		.name		=3D "omap_uwire",
+		.bus		=3D &platform_bus_type,
+		.owner		=3D THIS_MODULE,
+	},
+	.probe		=3D uwire_probe,
+	.remove		=3D uwire_remove,
+	// suspend ... unuse ck
+	// resume ... use ck
+};
+
+static int __init omap_uwire_init(void)
+{
+	/* FIXME move these into the relevant board init code. also, include
+	 * H3 support; it uses tsc2101 like H2 (on a different chipselect).
+	 */
+
+	if (machine_is_omap_h2()) {
+		/* defaults: W21 SDO, U18 SDI, V19 SCL */
+		omap_cfg_reg(N14_1610_UWIRE_CS0);
+		omap_cfg_reg(N15_1610_UWIRE_CS1);
+	}
+	if (machine_is_omap_perseus2()) {
+		/* configure pins: MPU_UW_nSCS1, MPU_UW_SDO, MPU_UW_SCLK */
+		int val =3D omap_readl(OMAP730_IO_CONF_9) & ~0x00EEE000;
+		omap_writel(val | 0x00AAA000, OMAP730_IO_CONF_9);
+	}
+
+	return platform_driver_register(&uwire_driver);
+}
+
+static void __exit omap_uwire_exit(void)
+{
+	platform_driver_unregister(&uwire_driver);
+}
+
+subsys_initcall(omap_uwire_init);
+module_exit(omap_uwire_exit);
+
+MODULE_LICENSE("GPL");
+
_

Patches currently in -mm which might be from david-b@pacbell.net are

spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch

-
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
