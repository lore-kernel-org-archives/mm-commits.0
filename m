From: akpm@linux-foundation.org
Subject: + xilinx_spi-split-into-generic-of-and-platform-driver-add-support-for-ds570.patch added to -mm tree
Date: Tue, 29 Sep 2009 13:34:35 -0700
Message-ID: <200909292034.n8TKYZTS031085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbZI2UfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 16:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.rojfors@mocean-labs.com, John.Linn@xilinx.com, david-b@pacbell.net


The patch titled
     xilinx_spi: split into generic, of and platform driver, add suppor=
t for DS570
has been added to the -mm tree.  Its filename is
     xilinx_spi-split-into-generic-of-and-platform-driver-add-support-f=
or-ds570.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: xilinx_spi: split into generic, of and platform driver, add su=
pport for DS570
=46rom: Richard R=F6jfors <richard.rojfors@mocean-labs.com>

Split xilinx_spi into three parts, an OF and a platform driver and gene=
ric
part.

The generic part now also works on X86, it supports accessing the IP bo=
oth
big and little endian.  There is also support for 16 and 32 bit SPI for
the Xilinx SPI IP DS570

Signed-off-by: Richard R=F6jfors <richard.rojfors@mocean-labs.com>
Cc: John Linn <John.Linn@xilinx.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig            |   19 +
 drivers/spi/Makefile           |    2=20
 drivers/spi/xilinx_spi.c       |  387 +++++++++++++++----------------
 drivers/spi/xilinx_spi.h       |   33 ++
 drivers/spi/xilinx_spi_of.c    |  120 +++++++++
 drivers/spi/xilinx_spi_pltfm.c |  104 ++++++++
 include/linux/spi/xilinx_spi.h |   19 +
 7 files changed, 489 insertions(+), 195 deletions(-)

diff -puN drivers/spi/Kconfig~xilinx_spi-split-into-generic-of-and-plat=
form-driver-add-support-for-ds570 drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~xilinx_spi-split-into-generic-of-and-platform=
-driver-add-support-for-ds570
+++ a/drivers/spi/Kconfig
@@ -235,8 +235,8 @@ config SPI_TXX9
 	  SPI driver for Toshiba TXx9 MIPS SoCs
=20
 config SPI_XILINX
-	tristate "Xilinx SPI controller"
-	depends on (XILINX_VIRTEX || MICROBLAZE) && EXPERIMENTAL
+	tristate "Xilinx SPI controller common module"
+	depends on HAS_IOMEM && EXPERIMENTAL
 	select SPI_BITBANG
 	help
 	  This exposes the SPI controller IP from the Xilinx EDK.
@@ -244,6 +244,21 @@ config SPI_XILINX
 	  See the "OPB Serial Peripheral Interface (SPI) (v1.00e)"
 	  Product Specification document (DS464) for hardware details.
=20
+	  Or for the DS570, see "XPS Serial Peripheral Interface (SPI) (v2.00=
b)"
+
+config SPI_XILINX_OF
+	tristate "Xilinx SPI controller OF device"
+	depends on SPI_XILINX && XILINX_VIRTEX
+	help
+	  This is the OF driver for the SPI controller IP from the Xilinx EDK=
=2E
+
+config SPI_XILINX_PLTFM
+	tristate "Xilinx SPI controller platform device"
+	depends on SPI_XILINX
+	help
+	  This is the platform driver for the SPI controller IP
+	  from the Xilinx EDK.
+
 #
 # Add new SPI master controllers in alphabetical order above this line
 #
diff -puN drivers/spi/Makefile~xilinx_spi-split-into-generic-of-and-pla=
tform-driver-add-support-for-ds570 drivers/spi/Makefile
--- a/drivers/spi/Makefile~xilinx_spi-split-into-generic-of-and-platfor=
m-driver-add-support-for-ds570
+++ a/drivers/spi/Makefile
@@ -31,6 +31,8 @@ obj-$(CONFIG_SPI_S3C24XX_GPIO)		+=3D spi_s
 obj-$(CONFIG_SPI_S3C24XX)		+=3D spi_s3c24xx.o
 obj-$(CONFIG_SPI_TXX9)			+=3D spi_txx9.o
 obj-$(CONFIG_SPI_XILINX)		+=3D xilinx_spi.o
+obj-$(CONFIG_SPI_XILINX_OF)		+=3D xilinx_spi_of.o
+obj-$(CONFIG_SPI_XILINX_PLTFM)		+=3D xilinx_spi_pltfm.o
 obj-$(CONFIG_SPI_SH_SCI)		+=3D spi_sh_sci.o
 obj-$(CONFIG_SPI_STMP3XXX)		+=3D spi_stmp.o
 # 	... add above this line ...
diff -puN drivers/spi/xilinx_spi.c~xilinx_spi-split-into-generic-of-and=
-platform-driver-add-support-for-ds570 drivers/spi/xilinx_spi.c
--- a/drivers/spi/xilinx_spi.c~xilinx_spi-split-into-generic-of-and-pla=
tform-driver-add-support-for-ds570
+++ a/drivers/spi/xilinx_spi.c
@@ -14,22 +14,35 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/platform_device.h>
-
-#include <linux/of_platform.h>
-#include <linux/of_device.h>
-#include <linux/of_spi.h>
=20
 #include <linux/spi/spi.h>
 #include <linux/spi/spi_bitbang.h>
 #include <linux/io.h>
=20
-#define XILINX_SPI_NAME "xilinx_spi"
+#include "xilinx_spi.h"
+
+struct xilinx_spi {
+	/* bitbang has to be first */
+	struct spi_bitbang bitbang;
+	struct completion done;
+	struct resource mem; /* phys mem */
+	void __iomem	*regs;	/* virt. address of the control registers */
+	u32 irq;
+	u8 *rx_ptr;		/* pointer in the Tx buffer */
+	const u8 *tx_ptr;	/* pointer in the Rx buffer */
+	int remaining_bytes;	/* the number of bytes left to transfer */
+	/* offset to the XSPI regs, these might vary... */
+	u8 bits_per_word;
+	bool big_endian;	/* The device could be accessed big or little
+				 * endian
+				 */
+};
+
=20
 /* Register definitions as per "OPB Serial Peripheral Interface (SPI) =
(v1.00e)
  * Product Specification", DS464
  */
-#define XSPI_CR_OFFSET		0x62	/* 16-bit Control Register */
+#define XSPI_CR_OFFSET		0x60	/* Control Register */
=20
 #define XSPI_CR_ENABLE		0x02
 #define XSPI_CR_MASTER_MODE	0x04
@@ -40,8 +53,9 @@
 #define XSPI_CR_RXFIFO_RESET	0x40
 #define XSPI_CR_MANUAL_SSELECT	0x80
 #define XSPI_CR_TRANS_INHIBIT	0x100
+#define XSPI_CR_LSB_FIRST	0x200
=20
-#define XSPI_SR_OFFSET		0x67	/* 8-bit Status Register */
+#define XSPI_SR_OFFSET		0x64	/* Status Register */
=20
 #define XSPI_SR_RX_EMPTY_MASK	0x01	/* Receive FIFO is empty */
 #define XSPI_SR_RX_FULL_MASK	0x02	/* Receive FIFO is full */
@@ -49,8 +63,8 @@
 #define XSPI_SR_TX_FULL_MASK	0x08	/* Transmit FIFO is full */
 #define XSPI_SR_MODE_FAULT_MASK	0x10	/* Mode fault error */
=20
-#define XSPI_TXD_OFFSET		0x6b	/* 8-bit Data Transmit Register */
-#define XSPI_RXD_OFFSET		0x6f	/* 8-bit Data Receive Register */
+#define XSPI_TXD_OFFSET		0x68	/* Data Transmit Register */
+#define XSPI_RXD_OFFSET		0x6C	/* Data Receive Register */
=20
 #define XSPI_SSR_OFFSET		0x70	/* 32-bit Slave Select Register */
=20
@@ -70,43 +84,72 @@
 #define XSPI_INTR_TX_UNDERRUN		0x08	/* TxFIFO was underrun */
 #define XSPI_INTR_RX_FULL		0x10	/* RxFIFO is full */
 #define XSPI_INTR_RX_OVERRUN		0x20	/* RxFIFO was overrun */
+#define XSPI_INTR_TX_HALF_EMPTY		0x40	/* TxFIFO is half empty */
=20
 #define XIPIF_V123B_RESETR_OFFSET	0x40	/* IPIF reset register */
 #define XIPIF_V123B_RESET_MASK		0x0a	/* the value to write */
=20
-struct xilinx_spi {
-	/* bitbang has to be first */
-	struct spi_bitbang bitbang;
-	struct completion done;
+/* to follow are some functions that does little of big endian read an=
d
+ * write depending on the config of the device.
+ */
+static inline void xspi_write8(struct xilinx_spi *xspi, u32 offs, u8 v=
al)
+{
+	iowrite8(val, xspi->regs + offs + ((xspi->big_endian) ? 3 : 0));
+}
=20
-	void __iomem	*regs;	/* virt. address of the control registers */
+static inline void xspi_write16(struct xilinx_spi *xspi, u32 offs, u16=
 val)
+{
+	if (xspi->big_endian)
+		iowrite16be(val, xspi->regs + offs + 2);
+	else
+		iowrite16(val, xspi->regs + offs);
+}
=20
-	u32		irq;
+static inline void xspi_write32(struct xilinx_spi *xspi, u32 offs, u32=
 val)
+{
+	if (xspi->big_endian)
+		iowrite32be(val, xspi->regs + offs);
+	else
+		iowrite32(val, xspi->regs + offs);
+}
=20
-	u32		speed_hz; /* SCK has a fixed frequency of speed_hz Hz */
+static inline u8 xspi_read8(struct xilinx_spi *xspi, u32 offs)
+{
+	return ioread8(xspi->regs + offs + ((xspi->big_endian) ? 3 : 0));
+}
=20
-	u8 *rx_ptr;		/* pointer in the Tx buffer */
-	const u8 *tx_ptr;	/* pointer in the Rx buffer */
-	int remaining_bytes;	/* the number of bytes left to transfer */
-};
+static inline u16 xspi_read16(struct xilinx_spi *xspi, u32 offs)
+{
+	if (xspi->big_endian)
+		return ioread16be(xspi->regs + offs + 2);
+	else
+		return ioread16(xspi->regs + offs);
+}
+
+static inline u32 xspi_read32(struct xilinx_spi *xspi, u32 offs)
+{
+	if (xspi->big_endian)
+		return ioread32be(xspi->regs + offs);
+	else
+		return ioread32(xspi->regs + offs);
+}
=20
-static void xspi_init_hw(void __iomem *regs_base)
+static void xspi_init_hw(struct xilinx_spi *xspi)
 {
 	/* Reset the SPI device */
-	out_be32(regs_base + XIPIF_V123B_RESETR_OFFSET,
-		 XIPIF_V123B_RESET_MASK);
+	xspi_write32(xspi, XIPIF_V123B_RESETR_OFFSET, XIPIF_V123B_RESET_MASK)=
;
 	/* Disable all the interrupts just in case */
-	out_be32(regs_base + XIPIF_V123B_IIER_OFFSET, 0);
+	xspi_write32(xspi, XIPIF_V123B_IIER_OFFSET, 0);
 	/* Enable the global IPIF interrupt */
-	out_be32(regs_base + XIPIF_V123B_DGIER_OFFSET,
-		 XIPIF_V123B_GINTR_ENABLE);
+	xspi_write32(xspi, XIPIF_V123B_DGIER_OFFSET, XIPIF_V123B_GINTR_ENABLE=
);
 	/* Deselect the slave on the SPI bus */
-	out_be32(regs_base + XSPI_SSR_OFFSET, 0xffff);
+	xspi_write32(xspi, XSPI_SSR_OFFSET, 0xffff);
 	/* Disable the transmitter, enable Manual Slave Select Assertion,
 	 * put SPI controller into master mode, and enable it */
-	out_be16(regs_base + XSPI_CR_OFFSET,
-		 XSPI_CR_TRANS_INHIBIT | XSPI_CR_MANUAL_SSELECT
-		 | XSPI_CR_MASTER_MODE | XSPI_CR_ENABLE);
+	xspi_write16(xspi, XSPI_CR_OFFSET,
+		 XSPI_CR_TRANS_INHIBIT | XSPI_CR_MANUAL_SSELECT |
+		 XSPI_CR_MASTER_MODE | XSPI_CR_ENABLE | XSPI_CR_TXFIFO_RESET |
+		 XSPI_CR_RXFIFO_RESET);
 }
=20
 static void xilinx_spi_chipselect(struct spi_device *spi, int is_on)
@@ -115,16 +158,16 @@ static void xilinx_spi_chipselect(struct
=20
 	if (is_on =3D=3D BITBANG_CS_INACTIVE) {
 		/* Deselect the slave on the SPI bus */
-		out_be32(xspi->regs + XSPI_SSR_OFFSET, 0xffff);
+		xspi_write32(xspi, XSPI_SSR_OFFSET, 0xffff);
 	} else if (is_on =3D=3D BITBANG_CS_ACTIVE) {
 		/* Set the SPI clock phase and polarity */
-		u16 cr =3D in_be16(xspi->regs + XSPI_CR_OFFSET)
+		u16 cr =3D xspi_read16(xspi, XSPI_CR_OFFSET)
 			 & ~XSPI_CR_MODE_MASK;
 		if (spi->mode & SPI_CPHA)
 			cr |=3D XSPI_CR_CPHA;
 		if (spi->mode & SPI_CPOL)
 			cr |=3D XSPI_CR_CPOL;
-		out_be16(xspi->regs + XSPI_CR_OFFSET, cr);
+		xspi_write16(xspi, XSPI_CR_OFFSET, cr);
=20
 		/* We do not check spi->max_speed_hz here as the SPI clock
 		 * frequency is not software programmable (the IP block design
@@ -132,24 +175,27 @@ static void xilinx_spi_chipselect(struct
 		 */
=20
 		/* Activate the chip select */
-		out_be32(xspi->regs + XSPI_SSR_OFFSET,
+		xspi_write32(xspi, XSPI_SSR_OFFSET,
 			 ~(0x0001 << spi->chip_select));
 	}
 }
=20
 /* spi_bitbang requires custom setup_transfer() to be defined if there=
 is a
  * custom txrx_bufs(). We have nothing to setup here as the SPI IP blo=
ck
- * supports just 8 bits per word, and SPI clock can't be changed in so=
ftware.
- * Check for 8 bits per word. Chip select delay calculations could be
+ * supports 8 or 16 bits per word, which can not be changed in softwar=
e.
+ * SPI clock can't be changed in software.
+ * Check for correct bits per word. Chip select delay calculations cou=
ld be
  * added here as soon as bitbang_work() can be made aware of the delay=
 value.
  */
 static int xilinx_spi_setup_transfer(struct spi_device *spi,
-		struct spi_transfer *t)
+	struct spi_transfer *t)
 {
 	u8 bits_per_word;
+	struct xilinx_spi *xspi =3D spi_master_get_devdata(spi->master);
=20
-	bits_per_word =3D (t) ? t->bits_per_word : spi->bits_per_word;
-	if (bits_per_word !=3D 8) {
+	bits_per_word =3D (t->bits_per_word) ? t->bits_per_word :
+		spi->bits_per_word;
+	if (bits_per_word !=3D xspi->bits_per_word) {
 		dev_err(&spi->dev, "%s, unsupported bits_per_word=3D%d\n",
 			__func__, bits_per_word);
 		return -EINVAL;
@@ -160,34 +206,50 @@ static int xilinx_spi_setup_transfer(str
=20
 static int xilinx_spi_setup(struct spi_device *spi)
 {
-	struct spi_bitbang *bitbang;
-	struct xilinx_spi *xspi;
-	int retval;
-
-	xspi =3D spi_master_get_devdata(spi->master);
-	bitbang =3D &xspi->bitbang;
-
-	retval =3D xilinx_spi_setup_transfer(spi, NULL);
-	if (retval < 0)
-		return retval;
-
+	/* always return 0, we can not check the number of bits.
+	 * There are cases when SPI setup is called before any driver is
+	 * there, in that case the SPI core defaults to 8 bits, which we
+	 * do not support in some cases. But if we return an error, the
+	 * SPI device would not be registered and no driver can get hold of i=
t
+	 * When the driver is there, it will call SPI setup again with the
+	 * correct number of bits per transfer.
+	 * If a driver setups with the wrong bit number, it will fail when
+	 * it tries to do a transfer
+	 */
 	return 0;
 }
=20
 static void xilinx_spi_fill_tx_fifo(struct xilinx_spi *xspi)
 {
 	u8 sr;
+	u8 wsize;
+	if (xspi->bits_per_word =3D=3D 8)
+		wsize =3D 1;
+	else if (xspi->bits_per_word =3D=3D 16)
+		wsize =3D 2;
+	else
+		wsize =3D 4;
=20
 	/* Fill the Tx FIFO with as many bytes as possible */
-	sr =3D in_8(xspi->regs + XSPI_SR_OFFSET);
-	while ((sr & XSPI_SR_TX_FULL_MASK) =3D=3D 0 && xspi->remaining_bytes =
> 0) {
+	sr =3D xspi_read8(xspi, XSPI_SR_OFFSET);
+	while ((sr & XSPI_SR_TX_FULL_MASK) =3D=3D 0 &&
+		xspi->remaining_bytes > 0) {
 		if (xspi->tx_ptr) {
-			out_8(xspi->regs + XSPI_TXD_OFFSET, *xspi->tx_ptr++);
-		} else {
-			out_8(xspi->regs + XSPI_TXD_OFFSET, 0);
-		}
-		xspi->remaining_bytes--;
-		sr =3D in_8(xspi->regs + XSPI_SR_OFFSET);
+			if (wsize =3D=3D 1)
+				xspi_write8(xspi, XSPI_TXD_OFFSET,
+					*xspi->tx_ptr);
+			else if (wsize =3D=3D 2)
+				xspi_write16(xspi, XSPI_TXD_OFFSET,
+					*(u16 *)(xspi->tx_ptr));
+			else if (wsize =3D=3D 4)
+				xspi_write32(xspi, XSPI_TXD_OFFSET,
+					*(u32 *)(xspi->tx_ptr));
+
+			xspi->tx_ptr +=3D wsize;
+		} else
+			xspi_write8(xspi, XSPI_TXD_OFFSET, 0);
+		xspi->remaining_bytes -=3D wsize;
+		sr =3D xspi_read8(xspi, XSPI_SR_OFFSET);
 	}
 }
=20
@@ -209,23 +271,22 @@ static int xilinx_spi_txrx_bufs(struct s
 	/* Enable the transmit empty interrupt, which we use to determine
 	 * progress on the transmission.
 	 */
-	ipif_ier =3D in_be32(xspi->regs + XIPIF_V123B_IIER_OFFSET);
-	out_be32(xspi->regs + XIPIF_V123B_IIER_OFFSET,
+	ipif_ier =3D xspi_read32(xspi, XIPIF_V123B_IIER_OFFSET);
+	xspi_write32(xspi, XIPIF_V123B_IIER_OFFSET,
 		 ipif_ier | XSPI_INTR_TX_EMPTY);
=20
 	/* Start the transfer by not inhibiting the transmitter any longer */
-	cr =3D in_be16(xspi->regs + XSPI_CR_OFFSET) & ~XSPI_CR_TRANS_INHIBIT;
-	out_be16(xspi->regs + XSPI_CR_OFFSET, cr);
+	cr =3D xspi_read16(xspi, XSPI_CR_OFFSET) & ~XSPI_CR_TRANS_INHIBIT;
+	xspi_write16(xspi, XSPI_CR_OFFSET, cr);
=20
 	wait_for_completion(&xspi->done);
=20
 	/* Disable the transmit empty interrupt */
-	out_be32(xspi->regs + XIPIF_V123B_IIER_OFFSET, ipif_ier);
+	xspi_write32(xspi, XIPIF_V123B_IIER_OFFSET, ipif_ier);
=20
 	return t->len - xspi->remaining_bytes;
 }
=20
-
 /* This driver supports single master mode only. Hence Tx FIFO Empty
  * is the only interrupt we care about.
  * Receive FIFO Overrun, Transmit FIFO Underrun, Mode Fault, and Slave=
 Mode
@@ -237,32 +298,50 @@ static irqreturn_t xilinx_spi_irq(int ir
 	u32 ipif_isr;
=20
 	/* Get the IPIF interrupts, and clear them immediately */
-	ipif_isr =3D in_be32(xspi->regs + XIPIF_V123B_IISR_OFFSET);
-	out_be32(xspi->regs + XIPIF_V123B_IISR_OFFSET, ipif_isr);
+	ipif_isr =3D xspi_read32(xspi, XIPIF_V123B_IISR_OFFSET);
+	xspi_write32(xspi, XIPIF_V123B_IISR_OFFSET, ipif_isr);
=20
 	if (ipif_isr & XSPI_INTR_TX_EMPTY) {	/* Transmission completed */
 		u16 cr;
 		u8 sr;
+		u8 rsize;
+		if (xspi->bits_per_word =3D=3D 8)
+			rsize =3D 1;
+		else if (xspi->bits_per_word =3D=3D 16)
+			rsize =3D 2;
+		else
+			rsize =3D 4;
=20
 		/* A transmit has just completed. Process received data and
 		 * check for more data to transmit. Always inhibit the
 		 * transmitter while the Isr refills the transmit register/FIFO,
 		 * or make sure it is stopped if we're done.
 		 */
-		cr =3D in_be16(xspi->regs + XSPI_CR_OFFSET);
-		out_be16(xspi->regs + XSPI_CR_OFFSET,
-			 cr | XSPI_CR_TRANS_INHIBIT);
+		cr =3D xspi_read16(xspi, XSPI_CR_OFFSET);
+		xspi_write16(xspi, XSPI_CR_OFFSET, cr | XSPI_CR_TRANS_INHIBIT);
=20
 		/* Read out all the data from the Rx FIFO */
-		sr =3D in_8(xspi->regs + XSPI_SR_OFFSET);
+		sr =3D xspi_read8(xspi, XSPI_SR_OFFSET);
 		while ((sr & XSPI_SR_RX_EMPTY_MASK) =3D=3D 0) {
-			u8 data;
+			u32 data;
+			if (rsize =3D=3D 1)
+				data =3D xspi_read8(xspi, XSPI_RXD_OFFSET);
+			else if (rsize =3D=3D 2)
+				data =3D xspi_read16(xspi, XSPI_RXD_OFFSET);
+			else
+				data =3D xspi_read32(xspi, XSPI_RXD_OFFSET);
=20
-			data =3D in_8(xspi->regs + XSPI_RXD_OFFSET);
 			if (xspi->rx_ptr) {
-				*xspi->rx_ptr++ =3D data;
+				if (rsize =3D=3D 1)
+					*xspi->rx_ptr =3D data & 0xff;
+				else if (rsize =3D=3D 2)
+					*(u16 *)(xspi->rx_ptr) =3D data & 0xffff;
+				else
+					*((u32 *)(xspi->rx_ptr)) =3D data;
+				xspi->rx_ptr +=3D rsize;
 			}
-			sr =3D in_8(xspi->regs + XSPI_SR_OFFSET);
+
+			sr =3D xspi_read8(xspi, XSPI_SR_OFFSET);
 		}
=20
 		/* See if there is more data to send */
@@ -271,7 +350,7 @@ static irqreturn_t xilinx_spi_irq(int ir
 			/* Start the transfer by not inhibiting the
 			 * transmitter any longer
 			 */
-			out_be16(xspi->regs + XSPI_CR_OFFSET, cr);
+			xspi_write16(xspi, XSPI_CR_OFFSET, cr);
 		} else {
 			/* No more data to send.
 			 * Indicate the transfer is completed.
@@ -279,44 +358,21 @@ static irqreturn_t xilinx_spi_irq(int ir
 			complete(&xspi->done);
 		}
 	}
-
 	return IRQ_HANDLED;
 }
=20
-static int __init xilinx_spi_of_probe(struct of_device *ofdev,
-					const struct of_device_id *match)
+struct spi_master *xilinx_spi_init(struct device *dev, struct resource=
 *mem,
+	u32 irq, s16 bus_num, u16 num_chipselect, u8 bits_per_word,
+	bool big_endian)
 {
 	struct spi_master *master;
 	struct xilinx_spi *xspi;
-	struct resource r_irq_struct;
-	struct resource r_mem_struct;
+	int ret =3D 0;
=20
-	struct resource *r_irq =3D &r_irq_struct;
-	struct resource *r_mem =3D &r_mem_struct;
-	int rc =3D 0;
-	const u32 *prop;
-	int len;
+	master =3D spi_alloc_master(dev, sizeof(struct xilinx_spi));
=20
-	/* Get resources(memory, IRQ) associated with the device */
-	master =3D spi_alloc_master(&ofdev->dev, sizeof(struct xilinx_spi));
-
-	if (master =3D=3D NULL) {
-		return -ENOMEM;
-	}
-
-	dev_set_drvdata(&ofdev->dev, master);
-
-	rc =3D of_address_to_resource(ofdev->node, 0, r_mem);
-	if (rc) {
-		dev_warn(&ofdev->dev, "invalid address\n");
-		goto put_master;
-	}
-
-	rc =3D of_irq_to_resource(ofdev->node, 0, r_irq);
-	if (rc =3D=3D NO_IRQ) {
-		dev_warn(&ofdev->dev, "no IRQ found\n");
-		goto put_master;
-	}
+	if (master =3D=3D NULL)
+		return ERR_PTR(-ENOMEM);
=20
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits =3D SPI_CPOL | SPI_CPHA;
@@ -329,128 +385,73 @@ static int __init xilinx_spi_of_probe(st
 	xspi->bitbang.master->setup =3D xilinx_spi_setup;
 	init_completion(&xspi->done);
=20
-	xspi->irq =3D r_irq->start;
-
-	if (!request_mem_region(r_mem->start,
-			r_mem->end - r_mem->start + 1, XILINX_SPI_NAME)) {
-		rc =3D -ENXIO;
-		dev_warn(&ofdev->dev, "memory request failure\n");
+	if (!request_mem_region(mem->start, resource_size(mem),
+		XILINX_SPI_NAME)) {
+		ret =3D -ENXIO;
 		goto put_master;
 	}
=20
-	xspi->regs =3D ioremap(r_mem->start, r_mem->end - r_mem->start + 1);
+	xspi->regs =3D ioremap(mem->start, resource_size(mem));
 	if (xspi->regs =3D=3D NULL) {
-		rc =3D -ENOMEM;
-		dev_warn(&ofdev->dev, "ioremap failure\n");
-		goto release_mem;
+		ret =3D -ENOMEM;
+		dev_warn(dev, "ioremap failure\n");
+		goto map_failed;
 	}
-	xspi->irq =3D r_irq->start;
=20
-	/* dynamic bus assignment */
-	master->bus_num =3D -1;
-
-	/* number of slave select bits is required */
-	prop =3D of_get_property(ofdev->node, "xlnx,num-ss-bits", &len);
-	if (!prop || len < sizeof(*prop)) {
-		dev_warn(&ofdev->dev, "no 'xlnx,num-ss-bits' property\n");
-		goto unmap_io;
-	}
-	master->num_chipselect =3D *prop;
+	master->bus_num =3D bus_num;
+	master->num_chipselect =3D num_chipselect;
+
+	xspi->mem =3D *mem;
+	xspi->irq =3D irq;
+	xspi->bits_per_word =3D bits_per_word;
+	xspi->big_endian =3D big_endian;
=20
 	/* SPI controller initializations */
-	xspi_init_hw(xspi->regs);
+	xspi_init_hw(xspi);
=20
 	/* Register for SPI Interrupt */
-	rc =3D request_irq(xspi->irq, xilinx_spi_irq, 0, XILINX_SPI_NAME, xsp=
i);
-	if (rc !=3D 0) {
-		dev_warn(&ofdev->dev, "irq request failure: %d\n", xspi->irq);
+	ret =3D request_irq(xspi->irq, xilinx_spi_irq, 0, XILINX_SPI_NAME, xs=
pi);
+	if (ret !=3D 0)
 		goto unmap_io;
-	}
=20
-	rc =3D spi_bitbang_start(&xspi->bitbang);
-	if (rc !=3D 0) {
-		dev_err(&ofdev->dev, "spi_bitbang_start FAILED\n");
+	ret =3D spi_bitbang_start(&xspi->bitbang);
+	if (ret !=3D 0) {
+		dev_err(dev, "spi_bitbang_start FAILED\n");
 		goto free_irq;
 	}
=20
-	dev_info(&ofdev->dev, "at 0x%08X mapped to 0x%08X, irq=3D%d\n",
-			(unsigned int)r_mem->start, (u32)xspi->regs, xspi->irq);
-
-	/* Add any subnodes on the SPI bus */
-	of_register_spi_devices(master, ofdev->node);
-
-	return rc;
+	dev_info(dev, "at 0x%08X mapped to 0x%08X, irq=3D%d\n",
+		(u32)mem->start, (u32)xspi->regs, xspi->irq);
+	return master;
=20
 free_irq:
 	free_irq(xspi->irq, xspi);
 unmap_io:
 	iounmap(xspi->regs);
-release_mem:
-	release_mem_region(r_mem->start, resource_size(r_mem));
+map_failed:
+	release_mem_region(mem->start, resource_size(mem));
 put_master:
 	spi_master_put(master);
-	return rc;
+	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL(xilinx_spi_init);
=20
-static int __devexit xilinx_spi_remove(struct of_device *ofdev)
+void xilinx_spi_deinit(struct spi_master *master)
 {
 	struct xilinx_spi *xspi;
-	struct spi_master *master;
-	struct resource r_mem;
=20
-	master =3D platform_get_drvdata(ofdev);
 	xspi =3D spi_master_get_devdata(master);
=20
 	spi_bitbang_stop(&xspi->bitbang);
 	free_irq(xspi->irq, xspi);
 	iounmap(xspi->regs);
-	if (!of_address_to_resource(ofdev->node, 0, &r_mem))
-		release_mem_region(r_mem.start, resource_size(&r_mem));
-	dev_set_drvdata(&ofdev->dev, 0);
-	spi_master_put(xspi->bitbang.master);
-
-	return 0;
-}
-
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:" XILINX_SPI_NAME);
-
-static int __exit xilinx_spi_of_remove(struct of_device *op)
-{
-	return xilinx_spi_remove(op);
-}
=20
-static struct of_device_id xilinx_spi_of_match[] =3D {
-	{ .compatible =3D "xlnx,xps-spi-2.00.a", },
-	{ .compatible =3D "xlnx,xps-spi-2.00.b", },
-	{}
-};
-
-MODULE_DEVICE_TABLE(of, xilinx_spi_of_match);
-
-static struct of_platform_driver xilinx_spi_of_driver =3D {
-	.owner =3D THIS_MODULE,
-	.name =3D "xilinx-xps-spi",
-	.match_table =3D xilinx_spi_of_match,
-	.probe =3D xilinx_spi_of_probe,
-	.remove =3D __exit_p(xilinx_spi_of_remove),
-	.driver =3D {
-		.name =3D "xilinx-xps-spi",
-		.owner =3D THIS_MODULE,
-	},
-};
-
-static int __init xilinx_spi_init(void)
-{
-	return of_register_platform_driver(&xilinx_spi_of_driver);
+	release_mem_region(xspi->mem.start, resource_size(&xspi->mem));
+	spi_master_put(xspi->bitbang.master);
 }
-module_init(xilinx_spi_init);
+EXPORT_SYMBOL(xilinx_spi_deinit);
=20
-static void __exit xilinx_spi_exit(void)
-{
-	of_unregister_platform_driver(&xilinx_spi_of_driver);
-}
-module_exit(xilinx_spi_exit);
 MODULE_AUTHOR("MontaVista Software, Inc. <source@mvista.com>");
 MODULE_DESCRIPTION("Xilinx SPI driver");
 MODULE_LICENSE("GPL");
+
diff -puN /dev/null drivers/spi/xilinx_spi.h
--- /dev/null
+++ a/drivers/spi/xilinx_spi.h
@@ -0,0 +1,33 @@
+/*
+ * xilinx_spi.h
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+#ifndef _XILINX_SPI_H_
+#define _XILINX_SPI_H_ 1
+
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+#include <linux/spi/xilinx_spi.h>
+
+#define XILINX_SPI_NAME "xilinx_spi"
+
+struct spi_master *xilinx_spi_init(struct device *dev, struct resource=
 *mem,
+	u32 irq, s16 bus_num, u16 num_chipselect, u8 bits_per_word,
+	bool big_endian);
+
+void xilinx_spi_deinit(struct spi_master *master);
+#endif
diff -puN /dev/null drivers/spi/xilinx_spi_of.c
--- /dev/null
+++ a/drivers/spi/xilinx_spi_of.c
@@ -0,0 +1,120 @@
+/*
+ * xilinx_spi_of.c
+ *
+ * Xilinx SPI controller driver (master mode only)
+ *
+ * Author: MontaVista Software, Inc.
+ *	source@mvista.com
+ *
+ * 2002-2007 (c) MontaVista Software, Inc.  This file is licensed unde=
r the
+ * terms of the GNU General Public License version 2.  This program is=
 licensed
+ * "as is" without any warranty of any kind, whether express or implie=
d.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+
+#include <linux/of_platform.h>
+#include <linux/of_device.h>
+#include <linux/of_spi.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+
+#include "xilinx_spi.h"
+
+
+static int __init xilinx_spi_of_probe(struct of_device *ofdev,
+					const struct of_device_id *match)
+{
+	struct resource r_irq_struct;
+	struct resource r_mem_struct;
+	struct spi_master *master;
+
+	struct resource *r_irq =3D &r_irq_struct;
+	struct resource *r_mem =3D &r_mem_struct;
+	int rc =3D 0;
+	const u32 *prop;
+	int len;
+
+	rc =3D of_address_to_resource(ofdev->node, 0, r_mem);
+	if (rc) {
+		dev_warn(&ofdev->dev, "invalid address\n");
+		return rc;
+	}
+
+	rc =3D of_irq_to_resource(ofdev->node, 0, r_irq);
+	if (rc =3D=3D NO_IRQ) {
+		dev_warn(&ofdev->dev, "no IRQ found\n");
+		return -ENODEV;
+	}
+
+	/* number of slave select bits is required */
+	prop =3D of_get_property(ofdev->node, "xlnx,num-ss-bits", &len);
+	if (!prop || len < sizeof(*prop)) {
+		dev_warn(&ofdev->dev, "no 'xlnx,num-ss-bits' property\n");
+		return -EINVAL;
+	}
+	master =3D xilinx_spi_init(&ofdev->dev, r_mem, r_irq->start, -1, *pro=
p, 8,
+		true);
+	if (IS_ERR(master))
+		return PTR_ERR(master);
+
+	dev_set_drvdata(&ofdev->dev, master);
+
+	/* Add any subnodes on the SPI bus */
+	of_register_spi_devices(master, ofdev->node);
+
+	return 0;
+}
+
+static int __devexit xilinx_spi_remove(struct of_device *ofdev)
+{
+	xilinx_spi_deinit(dev_get_drvdata(&ofdev->dev));
+	dev_set_drvdata(&ofdev->dev, 0);
+	return 0;
+}
+
+static int __exit xilinx_spi_of_remove(struct of_device *op)
+{
+	return xilinx_spi_remove(op);
+}
+
+static struct of_device_id xilinx_spi_of_match[] =3D {
+	{ .compatible =3D "xlnx,xps-spi-2.00.a", },
+	{ .compatible =3D "xlnx,xps-spi-2.00.b", },
+	{}
+};
+
+MODULE_DEVICE_TABLE(of, xilinx_spi_of_match);
+
+static struct of_platform_driver xilinx_spi_of_driver =3D {
+	.owner =3D THIS_MODULE,
+	.name =3D "xilinx-xps-spi",
+	.match_table =3D xilinx_spi_of_match,
+	.probe =3D xilinx_spi_of_probe,
+	.remove =3D __exit_p(xilinx_spi_of_remove),
+	.driver =3D {
+		.name =3D "xilinx-xps-spi",
+		.owner =3D THIS_MODULE,
+	},
+};
+
+static int __init xilinx_spi_of_init(void)
+{
+	return of_register_platform_driver(&xilinx_spi_of_driver);
+}
+module_init(xilinx_spi_of_init);
+
+static void __exit xilinx_spi_of_exit(void)
+{
+	of_unregister_platform_driver(&xilinx_spi_of_driver);
+}
+module_exit(xilinx_spi_of_exit);
+MODULE_AUTHOR("MontaVista Software, Inc. <source@mvista.com>");
+MODULE_DESCRIPTION("Xilinx SPI driver");
+MODULE_LICENSE("GPL");
+
diff -puN /dev/null drivers/spi/xilinx_spi_pltfm.c
--- /dev/null
+++ a/drivers/spi/xilinx_spi_pltfm.c
@@ -0,0 +1,104 @@
+/*
+ * xilinx_spi_pltfm.c Support for Xilinx SPI platform devices
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+/* Supports:
+ * Xilinx SPI devices as platform devices
+ *
+ * Inspired by xilinx_spi.c, 2002-2007 (c) MontaVista Software, Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+#include <linux/spi/xilinx_spi.h>
+
+#include "xilinx_spi.h"
+
+static int __devinit xilinx_spi_probe(struct platform_device *dev)
+{
+	struct xspi_platform_data *pdata;
+	struct resource *r;
+	int irq;
+	struct spi_master *master;
+	u8 i;
+
+	pdata =3D dev->dev.platform_data;
+	if (pdata =3D=3D NULL)
+		return -ENODEV;
+
+	r =3D platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (r =3D=3D NULL)
+		return -ENODEV;
+
+	irq =3D platform_get_irq(dev, 0);
+	if (irq < 0)
+		return -ENXIO;
+
+	master =3D xilinx_spi_init(&dev->dev, r, irq, dev->id,
+		pdata->num_chipselect, pdata->bits_per_word, false);
+	if (IS_ERR(master))
+		return PTR_ERR(master);
+
+	for (i =3D 0; i < pdata->num_devices; i++)
+		spi_new_device(master, pdata->devices + i);
+
+	platform_set_drvdata(dev, master);
+	return 0;
+}
+
+static int __devexit xilinx_spi_remove(struct platform_device *dev)
+{
+	xilinx_spi_deinit(platform_get_drvdata(dev));
+	platform_set_drvdata(dev, 0);
+
+	return 0;
+}
+
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:" XILINX_SPI_NAME);
+
+static struct platform_driver xilinx_spi_driver =3D {
+	.probe	=3D xilinx_spi_probe,
+	.remove	=3D __devexit_p(xilinx_spi_remove),
+	.driver =3D {
+		.name =3D XILINX_SPI_NAME,
+		.owner =3D THIS_MODULE,
+	},
+};
+
+static int __init xilinx_spi_pltfm_init(void)
+{
+	return platform_driver_register(&xilinx_spi_driver);
+}
+module_init(xilinx_spi_pltfm_init);
+
+static void __exit xilinx_spi_pltfm_exit(void)
+{
+	platform_driver_unregister(&xilinx_spi_driver);
+}
+module_exit(xilinx_spi_pltfm_exit);
+
+MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
+MODULE_DESCRIPTION("Xilinx SPI platform driver");
+MODULE_LICENSE("GPL v2");
+
diff -puN /dev/null include/linux/spi/xilinx_spi.h
--- /dev/null
+++ a/include/linux/spi/xilinx_spi.h
@@ -0,0 +1,19 @@
+#ifndef __LINUX_SPI_XILINX_SPI_H
+#define __LINUX_SPI_XILINX_SPI_H
+
+/**
+ * struct xspi_platform_data - Platform data of the Xilinx SPI driver
+ * @num_chipselect:	Number of chip select by the IP
+ * @bits_per_word:	Number of bits per word. 8/16/32, Note that the DS4=
64
+ *			only support 8bit SPI.
+ * @devices:		Devices to add when the driver is probed.
+ * @num_devices:	Number of devices in the devices array.
+ */
+struct xspi_platform_data {
+	u16 num_chipselect;
+	u8 bits_per_word;
+	struct spi_board_info *devices;
+	u8 num_devices;
+};
+
+#endif /* __LINUX_SPI_XILINX_SPI_H */
_

Patches currently in -mm which might be from richard.rojfors@mocean-lab=
s.com are

xilinx_spi-split-into-generic-of-and-platform-driver-add-support-for-ds=
570.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
