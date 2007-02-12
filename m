From: akpm@linux-foundation.org
Subject: - spi-eeprom-learns-about-8-and-24-bit-addressing.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:22:56 -0800
Message-ID: <200702120722.l1C7Mu6h024710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44759 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935AbXBLHXD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:23:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walter.tuppa@siemens.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     SPI: EEPROM learns about 8 and 24 bit addressing
has been removed from the -mm tree.  Its filename was
     spi-eeprom-learns-about-8-and-24-bit-addressing.patch

This patch was dropped because it was folded into spi-eeprom-driver.patch

------------------------------------------------------
Subject: SPI: EEPROM learns about 8 and 24 bit addressing
From: "Tuppa, Walter" <walter.tuppa@siemens.com>

Since I have EEPROMs on SPI with different address sizing, I made some
changes to your at25.c to support them.  Works perfectly.  (Also includes a
small bugfix for the "what size address" test.)

Signed-off-by: Walter Tuppa <walter.tuppa@siemens.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/at25.c |   78 +++++++++++++++++++++++++++++--------------
 1 file changed, 54 insertions(+), 24 deletions(-)

diff -puN drivers/spi/at25.c~spi-eeprom-learns-about-8-and-24-bit-addressing drivers/spi/at25.c
--- a/drivers/spi/at25.c~spi-eeprom-learns-about-8-and-24-bit-addressing
+++ a/drivers/spi/at25.c
@@ -26,6 +26,7 @@ struct at25_data {
 	struct mutex		lock;
 	struct spi_eeprom	chip;
 	struct bin_attribute	bin;
+	unsigned		addrlen;
 };
 
 #define	AT25_WREN	0x06		/* latch the write enable */
@@ -42,6 +43,8 @@ struct at25_data {
 #define	AT25_SR_WPEN	0x80		/* writeprotect enable */
 
 
+#define EE_MAXADDRLEN	3		/* 24 bit addresses, up to 2 MBytes */
+
 /* Specs often allow 5 msec for a page write, sometimes 20 msec;
  * it's important to recover from write timeouts.
  */
@@ -59,21 +62,31 @@ at25_ee_read(
 	size_t			count
 )
 {
-	u8			command[3];
+	u8			command[EE_MAXADDRLEN + 1];
+	u8			*cp;
 	ssize_t			status;
 	struct spi_transfer	t[2];
 	struct spi_message	m;
 
-	/* 16-bit address is written MSB first */
-	command[0] = AT25_READ;
-	command[1] = (u8) (offset >> 8);
-	command[2] = (u8) (offset >> 0);
+	cp = command;
+	*cp++ = AT25_READ;
+
+	/* 8/16/24-bit address is written MSB first */
+	switch (at25->addrlen) {
+	default:	/* case 3 */
+		*cp++ = offset >> 16;
+	case 2:
+		*cp++ = offset >> 8;
+	case 1:
+	case 0:	/* can't happen: for better codegen */
+		*cp++ = offset >> 0;
+	}
 
 	spi_message_init(&m);
 	memset(t, 0, sizeof t);
 
 	t[0].tx_buf = command;
-	t[0].len = 3;
+	t[0].len = at25->addrlen + 1;
 	spi_message_add_tail(&t[0], &m);
 
 	t[1].rx_buf = buf;
@@ -129,7 +142,7 @@ at25_ee_write(struct at25_data *at25, ch
 	buf_size = at25->chip.page_size;
 	if (buf_size > io_limit)
 		buf_size = io_limit;
-	bounce = kmalloc(buf_size + 3, GFP_KERNEL);
+	bounce = kmalloc(buf_size + at25->addrlen + 1, GFP_KERNEL);
 	if (!bounce)
 		return -ENOMEM;
 
@@ -142,28 +155,37 @@ at25_ee_write(struct at25_data *at25, ch
 		unsigned long	timeout, retries;
 		unsigned	segment;
 		unsigned	offset = (unsigned) off;
+		u8		*cp = bounce + 1;
 
-		bounce[3] = AT25_WREN;
-		status = spi_write(at25->spi, bounce + 3, 1);
+		*cp = AT25_WREN;
+		status = spi_write(at25->spi, cp, 1);
 		if (status < 0) {
 			dev_dbg(&at25->spi->dev, "WREN --> %d\n",
 					(int) status);
 			break;
 		}
 
-		/* 16-bit address is written MSB first */
-		bounce[1] = (u8)(offset >> 8);
-		bounce[2] = (u8)(offset >> 0);
+		/* 8/16/24-bit address is written MSB first */
+		switch (at25->addrlen) {
+		default:	/* case 3 */
+			*cp++ = offset >> 16;
+		case 2:
+			*cp++ = offset >> 8;
+		case 1:
+		case 0:	/* can't happen: for better codegen */
+			*cp++ = offset >> 0;
+		}
 
 		/* Write as much of a page as we can */
 		segment = buf_size - (offset % buf_size);
 		if (segment > count)
 			segment = count;
-		memcpy(&bounce[3], buf, segment);
-		status = spi_write(at25->spi, bounce, segment + 3);
+		memcpy(cp, buf, segment);
+		status = spi_write(at25->spi, bounce,
+				segment + at25->addrlen + 1);
 		dev_dbg(&at25->spi->dev,
-			"write %u bytes at %u --> %d\n",
-			segment, offset, (int) status);
+				"write %u bytes at %u --> %d\n",
+				segment, offset, (int) status);
 		if (status < 0)
 			break;
 
@@ -240,6 +262,7 @@ static int at25_probe(struct spi_device 
 	const struct spi_eeprom *chip;
 	int			err;
 	int			sr;
+	int			addrlen;
 
 	/* Chip description */
 	chip = spi->dev.platform_data;
@@ -249,12 +272,14 @@ static int at25_probe(struct spi_device 
 		goto fail;
 	}
 
-	/* For now we only support 16 bit addressing, for
-	 * chips from 512 bytes to 64 Kbytes (4-512 Kbits).
-	 *
-	 * REVISIT some chips use 8 or 24 bit addressing
-	 */
-	if (!chip->flags & EE_ADDR2) {
+	/* For now we only support 8/16/24 bit addressing */
+	if (chip->flags & EE_ADDR1)
+		addrlen = 1;
+	else if (chip->flags & EE_ADDR2)
+		addrlen = 2;
+	else if (chip->flags & EE_ADDR3)
+		addrlen = 3;
+	else {
 		dev_dbg(&spi->dev, "unsupported address type\n");
 		err = -EINVAL;
 		goto fail;
@@ -280,6 +305,7 @@ static int at25_probe(struct spi_device 
 	at25->chip = *chip;
 	at25->spi = spi_dev_get(spi);
 	dev_set_drvdata(&spi->dev, at25);
+	at25->addrlen = addrlen;
 
 	/* Export the EEPROM bytes through sysfs, since that's convenient.
 	 * Default to root-only access to the data; EEPROMs often hold data
@@ -301,8 +327,12 @@ static int at25_probe(struct spi_device 
 	if (err)
 		goto fail;
 
-	dev_info(&spi->dev, "%Zd KByte %s eeprom%s, pagesize %u\n",
-		at25->bin.size / 1024, at25->chip.name,
+	dev_info(&spi->dev, "%Zd %s %s eeprom%s, pagesize %u\n",
+		(at25->bin.size < 1024)
+			? at25->bin.size
+			: (at25->bin.size / 1024),
+		(at25->bin.size < 1024) ? "Byte" : "KByte",
+		at25->chip.name,
 		(chip->flags & EE_READONLY) ? " (readonly)" : "",
 		at25->chip.page_size);
 	return 0;
_

Patches currently in -mm which might be from walter.tuppa@siemens.com are

spi-eeprom-driver.patch
spi-eeprom-learns-about-8-and-24-bit-addressing.patch
