From: akpm@linux-foundation.org
Subject: + memory_accessor-implement-the-new-memory_accessor-interfaces-for-spi-eeproms.patch added to -mm tree
Date: Mon, 30 Mar 2009 13:40:06 -0700
Message-ID: <200903302040.n2UKe6BS011159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755694AbZC3Un3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 16:43:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, khali@linux-fr.org, khilman@deeprootsystems.com


The patch titled
     memory_accessor: implement the new memory_accessor interfaces for SPI EEPROMs
has been added to the -mm tree.  Its filename is
     memory_accessor-implement-the-new-memory_accessor-interfaces-for-spi-eeproms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory_accessor: implement the new memory_accessor interfaces for SPI EEPROMs
From: David Brownell <dbrownell@users.sourceforge.net>

 - Define new setup() hook to export the accessor
 - Implement accessor methods

Moves some error checking out of the sysfs interface code into the layer
below it, which is now shared by both sysfs and memory access code.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeprom/at25.c |   58 ++++++++++++++++++++++++++---------
 include/linux/spi/eeprom.h |    6 +++
 2 files changed, 50 insertions(+), 14 deletions(-)

diff -puN drivers/misc/eeprom/at25.c~memory_accessor-implement-the-new-memory_accessor-interfaces-for-spi-eeproms drivers/misc/eeprom/at25.c
--- a/drivers/misc/eeprom/at25.c~memory_accessor-implement-the-new-memory_accessor-interfaces-for-spi-eeproms
+++ a/drivers/misc/eeprom/at25.c
@@ -30,6 +30,7 @@
 
 struct at25_data {
 	struct spi_device	*spi;
+	struct memory_accessor	mem;
 	struct mutex		lock;
 	struct spi_eeprom	chip;
 	struct bin_attribute	bin;
@@ -75,6 +76,13 @@ at25_ee_read(
 	struct spi_transfer	t[2];
 	struct spi_message	m;
 
+	if (unlikely(offset >= at25->bin.size))
+		return 0;
+	if ((offset + count) > at25->bin.size)
+		count = at25->bin.size - offset;
+	if (unlikely(!count))
+		return count;
+
 	cp = command;
 	*cp++ = AT25_READ;
 
@@ -127,13 +135,6 @@ at25_bin_read(struct kobject *kobj, stru
 	dev = container_of(kobj, struct device, kobj);
 	at25 = dev_get_drvdata(dev);
 
-	if (unlikely(off >= at25->bin.size))
-		return 0;
-	if ((off + count) > at25->bin.size)
-		count = at25->bin.size - off;
-	if (unlikely(!count))
-		return count;
-
 	return at25_ee_read(at25, buf, off, count);
 }
 
@@ -146,6 +147,13 @@ at25_ee_write(struct at25_data *at25, ch
 	unsigned		buf_size;
 	u8			*bounce;
 
+	if (unlikely(off >= at25->bin.size))
+		return -EFBIG;
+	if ((off + count) > at25->bin.size)
+		count = at25->bin.size - off;
+	if (unlikely(!count))
+		return count;
+
 	/* Temp buffer starts with command and address */
 	buf_size = at25->chip.page_size;
 	if (buf_size > io_limit)
@@ -253,18 +261,31 @@ at25_bin_write(struct kobject *kobj, str
 	dev = container_of(kobj, struct device, kobj);
 	at25 = dev_get_drvdata(dev);
 
-	if (unlikely(off >= at25->bin.size))
-		return -EFBIG;
-	if ((off + count) > at25->bin.size)
-		count = at25->bin.size - off;
-	if (unlikely(!count))
-		return count;
-
 	return at25_ee_write(at25, buf, off, count);
 }
 
 /*-------------------------------------------------------------------------*/
 
+/* Let in-kernel code access the eeprom data. */
+
+static ssize_t at25_mem_read(struct memory_accessor *mem, char *buf,
+			 off_t offset, size_t count)
+{
+	struct at25_data *at25 = container_of(mem, struct at25_data, mem);
+
+	return at25_ee_read(at25, buf, offset, count);
+}
+
+static ssize_t at25_mem_write(struct memory_accessor *mem, char *buf,
+			  off_t offset, size_t count)
+{
+	struct at25_data *at25 = container_of(mem, struct at25_data, mem);
+
+	return at25_ee_write(at25, buf, offset, count);
+}
+
+/*-------------------------------------------------------------------------*/
+
 static int at25_probe(struct spi_device *spi)
 {
 	struct at25_data	*at25 = NULL;
@@ -317,6 +338,10 @@ static int at25_probe(struct spi_device 
 	at25->addrlen = addrlen;
 
 	/* Export the EEPROM bytes through sysfs, since that's convenient.
+	 * And maybe to other kernel code; it might hold a board's Ethernet
+	 * address, or board-specific calibration data generated on the
+	 * manufacturing floor.
+	 *
 	 * Default to root-only access to the data; EEPROMs often hold data
 	 * that's sensitive for read and/or write, like ethernet addresses,
 	 * security codes, board-specific manufacturing calibrations, etc.
@@ -324,17 +349,22 @@ static int at25_probe(struct spi_device 
 	at25->bin.attr.name = "eeprom";
 	at25->bin.attr.mode = S_IRUSR;
 	at25->bin.read = at25_bin_read;
+	at25->mem.read = at25_mem_read;
 
 	at25->bin.size = at25->chip.byte_len;
 	if (!(chip->flags & EE_READONLY)) {
 		at25->bin.write = at25_bin_write;
 		at25->bin.attr.mode |= S_IWUSR;
+		at25->mem.write = at25_mem_write;
 	}
 
 	err = sysfs_create_bin_file(&spi->dev.kobj, &at25->bin);
 	if (err)
 		goto fail;
 
+	if (chip->setup)
+		chip->setup(&at25->mem, chip->context);
+
 	dev_info(&spi->dev, "%Zd %s %s eeprom%s, pagesize %u\n",
 		(at25->bin.size < 1024)
 			? at25->bin.size
diff -puN include/linux/spi/eeprom.h~memory_accessor-implement-the-new-memory_accessor-interfaces-for-spi-eeproms include/linux/spi/eeprom.h
--- a/include/linux/spi/eeprom.h~memory_accessor-implement-the-new-memory_accessor-interfaces-for-spi-eeproms
+++ a/include/linux/spi/eeprom.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_SPI_EEPROM_H
 #define __LINUX_SPI_EEPROM_H
 
+#include <linux/memory.h>
+
 /*
  * Put one of these structures in platform_data for SPI EEPROMS handled
  * by the "at25" driver.  On SPI, most EEPROMS understand the same core
@@ -17,6 +19,10 @@ struct spi_eeprom {
 #define	EE_ADDR2	0x0002			/* 16 bit addrs */
 #define	EE_ADDR3	0x0004			/* 24 bit addrs */
 #define	EE_READONLY	0x0008			/* disallow writes */
+
+	/* for exporting this chip's data to other kernel code */
+	void (*setup)(struct memory_accessor *mem, void *context);
+	void *context;
 };
 
 #endif /* __LINUX_SPI_EEPROM_H */
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
memory_accessor-new-interface-for-reading-writing-persistent-memory.patch
memory_accessor-implement-the-new-memory_accessor-interface-for-i2c-eeprom.patch
memory_accessor-implement-the-new-memory_accessor-interfaces-for-spi-eeproms.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
blackfin-spi-driver-remove-useless-asm-cplbinith.patch
blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred.patch
blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level.patch
blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch
blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label.patch
blackfin-spi-driver-get-dma-working-for-spi-flashes.patch
blackfin-spi-driver-fix-bug-spi-controller-driver-does-not-assert-deassert-cs-correctly.patch
blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change.patch
spi-limit-reaches-1-tested-0.patch
rtc-ds1307-true-smbus-compatibility.patch
gpio-gpio_requestfree-now-required-feature-removal.patch

