From: akpm@linux-foundation.org
Subject: + mtd-dataflash-otp-support.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:22:23 -0700
Message-ID: <200807292222.m6TMMN4D024803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbYG2WWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:22:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, cooloney@kernel.org, dwmw2@infradead.org, michael.hennerich@analog.com


The patch titled
     mtd: dataflash OTP support
has been added to the -mm tree.  Its filename is
     mtd-dataflash-otp-support.patch

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
Subject: mtd: dataflash OTP support
From: David Brownell <dbrownell@users.sourceforge.net>

Now that we can tell when we have one of the newer DataFlash chips,
optionally expose the 128 bytes of OTP memory they provide.  Tested
on at45db642 revision B and D chips.

Switch mtdchar over to a generic HAVE_MTD_OTP flag instead of adding
another #ifdef for each type of chip whose driver has OTP support.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/Kconfig                 |    5 
 drivers/mtd/chips/Kconfig           |    1 
 drivers/mtd/devices/Kconfig         |   11 +
 drivers/mtd/devices/mtd_dataflash.c |  206 +++++++++++++++++++++++++-
 drivers/mtd/mtdchar.c               |    4 
 drivers/mtd/onenand/Kconfig         |    1 
 6 files changed, 219 insertions(+), 9 deletions(-)

diff -puN drivers/mtd/Kconfig~mtd-dataflash-otp-support drivers/mtd/Kconfig
--- a/drivers/mtd/Kconfig~mtd-dataflash-otp-support
+++ a/drivers/mtd/Kconfig
@@ -172,6 +172,11 @@ config MTD_CHAR
 	  memory chips, and also use ioctl() to obtain information about
 	  the device, or to erase parts of it.
 
+config HAVE_MTD_OTP
+	bool
+	help
+	  Enable access to OTP regions using MTD_CHAR.
+
 config MTD_BLKDEVS
 	tristate "Common interface to block layer for MTD 'translation layers'"
 	depends on BLOCK
diff -puN drivers/mtd/chips/Kconfig~mtd-dataflash-otp-support drivers/mtd/chips/Kconfig
--- a/drivers/mtd/chips/Kconfig~mtd-dataflash-otp-support
+++ a/drivers/mtd/chips/Kconfig
@@ -154,6 +154,7 @@ config MTD_CFI_I8
 config MTD_OTP
 	bool "Protection Registers aka one-time programmable (OTP) bits"
 	depends on MTD_CFI_ADV_OPTIONS
+	select HAVE_MTD_OTP
 	default n
 	help
 	  This enables support for reading, writing and locking so called
diff -puN drivers/mtd/devices/Kconfig~mtd-dataflash-otp-support drivers/mtd/devices/Kconfig
--- a/drivers/mtd/devices/Kconfig~mtd-dataflash-otp-support
+++ a/drivers/mtd/devices/Kconfig
@@ -59,6 +59,17 @@ config MTD_DATAFLASH
 	  Sometimes DataFlash chips are packaged inside MMC-format
 	  cards; at this writing, the MMC stack won't handle those.
 
+config MTD_DATAFLASH_OTP
+	bool "DataFlash OTP support (Security Register)"
+	depends on MTD_DATAFLASH
+	select HAVE_MTD_OTP
+	help
+	  Newer DataFlash chips (revisions C and D) support 128 bytes of
+	  one-time-programmable (OTP) data.  The first half may be written
+	  (once) with up to 64 bytes of data, such as a serial number or
+	  other key product data.  The second half is programmed with a
+	  unique-to-each-chip bit pattern at the factory.
+
 config MTD_M25P80
 	tristate "Support most SPI Flash chips (AT26DF, M25P, W25X, ...)"
 	depends on SPI_MASTER && EXPERIMENTAL
diff -puN drivers/mtd/devices/mtd_dataflash.c~mtd-dataflash-otp-support drivers/mtd/devices/mtd_dataflash.c
--- a/drivers/mtd/devices/mtd_dataflash.c~mtd-dataflash-otp-support
+++ a/drivers/mtd/devices/mtd_dataflash.c
@@ -80,7 +80,8 @@
  */
 #define OP_READ_ID		0x9F
 #define OP_READ_SECURITY	0x77
-#define OP_WRITE_SECURITY	0x9A	/* OTP bits */
+#define OP_WRITE_SECURITY_REVC	0x9A
+#define OP_WRITE_SECURITY	0x9B	/* revision D */
 
 
 struct dataflash {
@@ -451,16 +452,192 @@ static int dataflash_write(struct mtd_in
 
 /* ......................................................................... */
 
+#ifdef CONFIG_MTD_DATAFLASH_OTP
+
+static int dataflash_get_otp_info(struct mtd_info *mtd,
+		struct otp_info *info, size_t len)
+{
+	/* Report both blocks as identical:  bytes 0..64, locked.
+	 * Unless the user block changed from all-ones, we can't
+	 * tell whether it's still writable; so we assume it isn't.
+	 */
+	info->start = 0;
+	info->length = 64;
+	info->locked = 1;
+	return sizeof(*info);
+}
+
+static ssize_t otp_read(struct spi_device *spi, unsigned base,
+		uint8_t *buf, loff_t off, size_t len)
+{
+	struct spi_message	m;
+	size_t			l;
+	uint8_t			*scratch;
+	struct spi_transfer	t;
+	int			status;
+
+	if (off > 64)
+		return -EINVAL;
+
+	if ((off + len) > 64)
+		len = 64 - off;
+	if (len == 0)
+		return len;
+
+	spi_message_init(&m);
+
+	l = 4 + base + off + len;
+	scratch = kzalloc(l, GFP_KERNEL);
+	if (!scratch)
+		return -ENOMEM;
+
+	/* OUT: OP_READ_SECURITY, 3 don't-care bytes, zeroes
+	 * IN:  ignore 4 bytes, data bytes 0..N (max 127)
+	 */
+	scratch[0] = OP_READ_SECURITY;
+
+	memset(&t, 0, sizeof t);
+	t.tx_buf = scratch;
+	t.rx_buf = scratch;
+	t.len = l;
+	spi_message_add_tail(&t, &m);
+
+	dataflash_waitready(spi);
+
+	status = spi_sync(spi, &m);
+	if (status >= 0) {
+		memcpy(buf, scratch + 4 + base + off, len);
+		status = len;
+	}
+
+	kfree(scratch);
+	return status;
+}
+
+static int dataflash_read_fact_otp(struct mtd_info *mtd,
+		loff_t from, size_t len, size_t *retlen, u_char *buf)
+{
+	struct dataflash	*priv = (struct dataflash *)mtd->priv;
+	int			status;
+
+	/* 64 bytes, from 0..63 ... start at 64 on-chip */
+	mutex_lock(&priv->lock);
+	status = otp_read(priv->spi, 64, buf, from, len);
+	mutex_unlock(&priv->lock);
+
+	if (status < 0)
+		return status;
+	*retlen = status;
+	return 0;
+}
+
+static int dataflash_read_user_otp(struct mtd_info *mtd,
+		loff_t from, size_t len, size_t *retlen, u_char *buf)
+{
+	struct dataflash	*priv = (struct dataflash *)mtd->priv;
+	int			status;
+
+	/* 64 bytes, from 0..63 ... start at 0 on-chip */
+	mutex_lock(&priv->lock);
+	status = otp_read(priv->spi, 0, buf, from, len);
+	mutex_unlock(&priv->lock);
+
+	if (status < 0)
+		return status;
+	*retlen = status;
+	return 0;
+}
+
+static int dataflash_write_user_otp(struct mtd_info *mtd,
+		loff_t from, size_t len, size_t *retlen, u_char *buf)
+{
+	struct spi_message	m;
+	const size_t		l = 4 + 64;
+	uint8_t			*scratch;
+	struct spi_transfer	t;
+	struct dataflash	*priv = (struct dataflash *)mtd->priv;
+	int			status;
+
+	if (len > 64)
+		return -EINVAL;
+
+	/* Strictly speaking, we *could* truncate the write ... but
+	 * let's not do that for the only write that's ever possible.
+	 */
+	if ((from + len) > 64)
+		return -EINVAL;
+
+	/* OUT: OP_WRITE_SECURITY, 3 zeroes, 64 data-or-zero bytes
+	 * IN:  ignore all
+	 */
+	scratch = kzalloc(l, GFP_KERNEL);
+	if (!scratch)
+		return -ENOMEM;
+	scratch[0] = OP_WRITE_SECURITY;
+	memcpy(scratch + 4 + from, buf, len);
+
+	spi_message_init(&m);
+
+	memset(&t, 0, sizeof t);
+	t.tx_buf = scratch;
+	t.len = l;
+	spi_message_add_tail(&t, &m);
+
+	/* Write the OTP bits, if they've not yet been written.
+	 * This modifies SRAM buffer1.
+	 */
+	mutex_lock(&priv->lock);
+	dataflash_waitready(priv->spi);
+	status = spi_sync(priv->spi, &m);
+	mutex_unlock(&priv->lock);
+
+	kfree(scratch);
+
+	if (status >= 0) {
+		status = 0;
+		*retlen = len;
+	}
+	return status;
+}
+
+static char *otp_setup(struct mtd_info *device, char revision)
+{
+	device->get_fact_prot_info = dataflash_get_otp_info;
+	device->read_fact_prot_reg = dataflash_read_fact_otp;
+	device->get_user_prot_info = dataflash_get_otp_info;
+	device->read_user_prot_reg = dataflash_read_user_otp;
+
+	/* rev c parts (at45db321c and at45db1281 only!) use a
+	 * different write procedure; not (yet?) implemented.
+	 */
+	if (revision > 'c')
+		device->write_user_prot_reg = dataflash_write_user_otp;
+
+	return ", OTP";
+}
+
+#else
+
+static char *otp_setup(struct mtd_info *device)
+{
+	return " (OTP)";
+}
+
+#endif
+
+/* ......................................................................... */
+
 /*
  * Register DataFlash device with MTD subsystem.
  */
 static int __devinit
-add_dataflash(struct spi_device *spi, char *name,
-		int nr_pages, int pagesize, int pageoffset)
+add_dataflash_otp(struct spi_device *spi, char *name,
+		int nr_pages, int pagesize, int pageoffset, char revision)
 {
 	struct dataflash		*priv;
 	struct mtd_info			*device;
 	struct flash_platform_data	*pdata = spi->dev.platform_data;
+	char				*otp_tag = "";
 
 	priv = kzalloc(sizeof *priv, GFP_KERNEL);
 	if (!priv)
@@ -489,8 +666,12 @@ add_dataflash(struct spi_device *spi, ch
 	device->write = dataflash_write;
 	device->priv = priv;
 
-	dev_info(&spi->dev, "%s (%d KBytes) pagesize %d bytes\n",
-			name, DIV_ROUND_UP(device->size, 1024), pagesize);
+	if (revision >= 'c')
+		otp_tag = otp_setup(device, revision);
+
+	dev_info(&spi->dev, "%s (%d KBytes) pagesize %d bytes%s\n",
+			name, DIV_ROUND_UP(device->size, 1024),
+			pagesize, otp_tag);
 	dev_set_drvdata(&spi->dev, priv);
 
 	if (mtd_has_partitions()) {
@@ -519,6 +700,14 @@ add_dataflash(struct spi_device *spi, ch
 	return add_mtd_device(device) == 1 ? -ENODEV : 0;
 }
 
+static inline int __devinit
+add_dataflash(struct spi_device *spi, char *name,
+		int nr_pages, int pagesize, int pageoffset)
+{
+	return add_dataflash_otp(spi, name, nr_pages, pagesize,
+			pageoffset, 0);
+}
+
 struct flash_info {
 	char		*name;
 
@@ -664,13 +853,16 @@ static int __devinit dataflash_probe(str
 	 * Try to detect dataflash by JEDEC ID.
 	 * If it succeeds we know we have either a C or D part.
 	 * D will support power of 2 pagesize option.
+	 * Both support the security register, though with different
+	 * write procedures.
 	 */
 	info = jedec_probe(spi);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 	if (info != NULL)
-		return add_dataflash(spi, info->name, info->nr_pages,
-				 info->pagesize, info->pageoffset);
+		return add_dataflash_otp(spi, info->name, info->nr_pages,
+				info->pagesize, info->pageoffset,
+				(info->flags & SUP_POW2PS) ? 'd' : 'c');
 
 	/*
 	 * Older chips support only legacy commands, identifing
diff -puN drivers/mtd/mtdchar.c~mtd-dataflash-otp-support drivers/mtd/mtdchar.c
--- a/drivers/mtd/mtdchar.c~mtd-dataflash-otp-support
+++ a/drivers/mtd/mtdchar.c
@@ -348,7 +348,7 @@ static void mtdchar_erase_callback (stru
 	wake_up((wait_queue_head_t *)instr->priv);
 }
 
-#if defined(CONFIG_MTD_OTP) || defined(CONFIG_MTD_ONENAND_OTP)
+#ifdef CONFIG_HAVE_MTD_OTP
 static int otp_select_filemode(struct mtd_file_info *mfi, int mode)
 {
 	struct mtd_info *mtd = mfi->mtd;
@@ -661,7 +661,7 @@ static int mtd_ioctl(struct inode *inode
 		break;
 	}
 
-#if defined(CONFIG_MTD_OTP) || defined(CONFIG_MTD_ONENAND_OTP)
+#ifdef CONFIG_HAVE_MTD_OTP
 	case OTPSELECT:
 	{
 		int mode;
diff -puN drivers/mtd/onenand/Kconfig~mtd-dataflash-otp-support drivers/mtd/onenand/Kconfig
--- a/drivers/mtd/onenand/Kconfig~mtd-dataflash-otp-support
+++ a/drivers/mtd/onenand/Kconfig
@@ -29,6 +29,7 @@ config MTD_ONENAND_GENERIC
 
 config MTD_ONENAND_OTP
 	bool "OneNAND OTP Support"
+	select HAVE_MTD_OTP
 	help
 	  One Block of the NAND Flash Array memory is reserved as
 	  a One-Time Programmable Block memory area.
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

rtc-dont-return-ebusy-when-mutex_lock_interruptible-fails.patch
linux-next.patch
mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3.patch
mtd-dataflash-otp-support.patch
spi-new-orion_spi-driver.patch
genirq-better-warning-on-irqchip-set_type-failure.patch

