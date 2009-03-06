From: akpm@linux-foundation.org
Subject: + mflash-initial-support-v2.patch added to -mm tree
Date: Fri, 06 Mar 2009 13:45:33 -0800
Message-ID: <200903062145.n26LjXAF002357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754523AbZCFVpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 16:45:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: donari75@gmail.com, alan@lxorguk.ukuu.org.uk, jens.axboe@oracle.com


The patch titled
     mflash: Initial support v2
has been added to the -mm tree.  Its filename is
     mflash-initial-support-v2.patch

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
Subject: mflash: Initial support v2
From: unsik Kim <donari75@gmail.com>

[2009.03.05]
* refine and reduce mg_wait's timeout value
* remove pointless "?"
* use correct jiffy wrap
* replace local mg_ide_fixstring to libata_core's
* avoid divide-by-zero
* change host->dev_base type to 'void __iomem *'
* add missing GPIOLIB and ATA dependency
(All the changes above this line comments by Andrew Morton)
* reduce probing time:
mflash spends a lot of time in reset.
(the first time hard reset after power on > hard reset > soft reset)
add dev_attr field to mg_drv_data and reset-out GPIO resource
for avoid duplicate reset sequence

Signed-off-by: unsik Kim <donari75@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/mflash.txt |   13 -
 drivers/block/Kconfig             |    2 
 drivers/block/mg_disk.c           |  352 ++++++++++++++--------------
 include/linux/mg_disk.h           |   57 +++-
 4 files changed, 246 insertions(+), 178 deletions(-)

diff -puN Documentation/blockdev/mflash.txt~mflash-initial-support-v2 Documentation/blockdev/mflash.txt
--- a/Documentation/blockdev/mflash.txt~mflash-initial-support-v2
+++ a/Documentation/blockdev/mflash.txt
@@ -36,6 +36,8 @@ configuration file is all. Here is some 
 static struct mg_drv_data mflash_drv_data = {
 	/* If you want to polling driver set to 1 */
 	.use_polling = 0,
+	/* device attribution */
+	.dev_attr = MG_BOOT_DEV
 };
 
 static struct resource mg_mflash_rsc[] = {
@@ -55,9 +57,18 @@ static struct resource mg_mflash_rsc[] =
 	[2] = {
 		.start = 43,
 		.end = 43,
-		.name = "mg_rst",
+		.name = MG_RST_PIN,
 		.flags = IORESOURCE_IO
 	},
+	/* mflash reset-out pin
+	 * If you use mflash as storage device (i.e. other than MG_BOOT_DEV),
+	 * should assign this */
+	[3] = {
+		.start = 51,
+		.end = 51,
+		.name = MG_RSTOUT_PIN,
+		.flags = IORESOURCE_IO
+	}
 };
 
 static struct platform_device mflash_dev = {
diff -puN drivers/block/Kconfig~mflash-initial-support-v2 drivers/block/Kconfig
--- a/drivers/block/Kconfig~mflash-initial-support-v2
+++ a/drivers/block/Kconfig
@@ -412,7 +412,7 @@ config ATA_OVER_ETH
 
 config MG_DISK
 	tristate "mGine mflash, gflash support"
-	depends on ARM
+	depends on ARM && ATA && GPIOLIB
 	help
 	  mGine mFlash(gFlash) block device driver
 
diff -puN drivers/block/mg_disk.c~mflash-initial-support-v2 drivers/block/mg_disk.c
--- a/drivers/block/mg_disk.c~mflash-initial-support-v2
+++ a/drivers/block/mg_disk.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
+#include <linux/libata.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
@@ -30,7 +31,7 @@ static void mg_request(struct request_qu
 static void mg_dump_status(const char *msg, unsigned int stat,
 		struct mg_host *host)
 {
-	char *name = MG_DISK_NAME"?";
+	char *name = MG_DISK_NAME;
 	struct request *req;
 
 	if (host->breq) {
@@ -39,7 +40,7 @@ static void mg_dump_status(const char *m
 			name = req->rq_disk->disk_name;
 	}
 
-	printk(KERN_DEBUG "%s: %s: status=0x%02x { ", name, msg, stat & 0xff);
+	printk(KERN_ERR "%s: %s: status=0x%02x { ", name, msg, stat & 0xff);
 	if (stat & MG_REG_STATUS_BIT_BUSY)
 		printk("Busy ");
 	if (stat & MG_REG_STATUS_BIT_READY)
@@ -58,8 +59,8 @@ static void mg_dump_status(const char *m
 	if ((stat & MG_REG_STATUS_BIT_ERROR) == 0) {
 		host->error = 0;
 	} else {
-		host->error = inb(host->dev_base + MG_REG_ERROR);
-		printk(KERN_DEBUG "%s: %s: error=0x%02x { ", name, msg,
+		host->error = inb((unsigned long)host->dev_base + MG_REG_ERROR);
+		printk(KERN_ERR "%s: %s: error=0x%02x { ", name, msg,
 				host->error & 0xff);
 		if (host->error & MG_REG_ERR_BBK)
 			printk("BadSector ");
@@ -89,14 +90,16 @@ static void mg_dump_status(const char *m
 static unsigned int mg_wait(struct mg_host *host, u32 expect, u32 msec)
 {
 	u8 status;
-	u64 expire, cur_jiffies;
+	unsigned long expire, cur_jiffies;
+	struct mg_drv_data *prv_data = host->dev->platform_data;
 
 	host->error = MG_ERR_NONE;
-	expire = get_jiffies_64() + msecs_to_jiffies(msec);
+	expire = jiffies + msecs_to_jiffies(msec);
+
+	status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
 
-	status = inb(host->dev_base + MG_REG_STATUS);
 	do {
-		cur_jiffies = get_jiffies_64();
+		cur_jiffies = jiffies;
 		if (status & MG_REG_STATUS_BIT_BUSY) {
 			if (expect == MG_REG_STATUS_BIT_BUSY)
 				break;
@@ -115,18 +118,39 @@ static unsigned int mg_wait(struct mg_ho
 				if (status & MG_REG_STATUS_BIT_DATA_REQ)
 					break;
 		}
-		status = inb(host->dev_base + MG_REG_STATUS);
-	} while (cur_jiffies < expire);
+		if (!msec) {
+			mg_dump_status("not ready", status, host);
+			return MG_ERR_INV_STAT;
+		}
+		if (prv_data->use_polling)
+			msleep(1);
 
-	if (cur_jiffies >= expire)
+		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+	} while (time_before(cur_jiffies, expire));
+
+	if (time_after_eq(cur_jiffies, expire) && msec)
 		host->error = MG_ERR_TIMEOUT;
 
 	return host->error;
 }
 
+static unsigned int mg_wait_rstout(u32 rstout, u32 msec)
+{
+	unsigned long expire;
+
+	expire = jiffies + msecs_to_jiffies(msec);
+	while (time_before(jiffies, expire)) {
+		if (gpio_get_value(rstout) == 1)
+			return MG_ERR_NONE;
+		msleep(10);
+	}
+
+	return MG_ERR_RSTOUT;
+}
+
 static void mg_unexpected_intr(struct mg_host *host)
 {
-	u32 status = inb(host->dev_base + MG_REG_STATUS);
+	u32 status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
 
 	mg_dump_status("mg_unexpected_intr", status, host);
 }
@@ -144,84 +168,64 @@ static irqreturn_t mg_irq(int irq, void 
 	return IRQ_HANDLED;
 }
 
-static void mg_ide_fixstring(u8 *s, const int bytecount)
-{
-	u8 *p, *end = &s[bytecount & ~1]; /* bytecount must be even */
-
-	/* convert from big-endian to host byte order */
-	for (p = s ; p != end ; p += 2)
-		be16_to_cpus((u16 *) p);
-
-	/* strip leading blanks */
-	p = s;
-	while (s != end && *s == ' ')
-		++s;
-	/* compress internal blanks and strip trailing blanks */
-	while (s != end && *s) {
-		if (*s++ != ' ' || (s != end && *s && *s != ' '))
-			*p++ = *(s-1);
-	}
-	/* wipe out trailing garbage */
-	while (p != end)
-		*p++ = '\0';
-}
-
 static int mg_get_disk_id(struct mg_host *host)
 {
-	u32 i, res;
+	u32 i;
 	s32 err;
-	u16 *id = (u16 *)&host->id_data;
+	const u16 *id = host->id;
 	struct mg_drv_data *prv_data = host->dev->platform_data;
+	char fwrev[ATA_ID_FW_REV_LEN + 1];
+	char model[ATA_ID_PROD_LEN + 1];
+	char serial[ATA_ID_SERNO_LEN + 1];
 
 	if (!prv_data->use_polling)
 		outb(MG_REG_CTRL_INTR_DISABLE,
-				host->dev_base + MG_REG_DRV_CTRL);
+				(unsigned long)host->dev_base +
+				MG_REG_DRV_CTRL);
 
-	outb(MG_CMD_ID, host->dev_base + MG_REG_COMMAND);
-	err = mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, 3000);
+	outb(MG_CMD_ID, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	err = mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, MG_TMAX_WAIT_RD_DRQ);
 	if (err)
 		return err;
 
 	for (i = 0; i < (MG_SECTOR_SIZE >> 1); i++)
-		id[i] = le16_to_cpu(inw(host->dev_base + MG_BUFF_OFFSET +
-					i * 2));
+		host->id[i] = le16_to_cpu(inw((unsigned long)host->dev_base +
+					MG_BUFF_OFFSET + i * 2));
 
-	outb(MG_CMD_RD_CONF, host->dev_base + MG_REG_COMMAND);
-	err = mg_wait(host, MG_STAT_READY, 3000);
+	outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	err = mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD);
 	if (err)
 		return err;
 
-	if ((host->id_data.field_valid & 1) == 0)
+	if ((id[ATA_ID_FIELD_VALID] & 1) == 0)
 		return MG_ERR_TRANSLATION;
 
-#ifdef __BIG_ENDIAN
-	host->id_data.lba_capacity = (host->id_data.lba_capacity << 16)
-		| (host->id_data.lba_capacity >> 16);
-#endif /* __BIG_ENDIAN */
-	if (MG_RES_SEC) {
-		/* modify cyls, lba_capacity */
-		host->id_data.cyls = (host->id_data.lba_capacity - MG_RES_SEC) /
-			host->id_data.heads / host->id_data.sectors;
-		res = host->id_data.lba_capacity - host->id_data.cyls *
-			host->id_data.heads * host->id_data.sectors;
-		host->id_data.lba_capacity -= res;
-	}
-	host->tot_sectors = host->id_data.lba_capacity;
-	mg_ide_fixstring(host->id_data.model,
-			sizeof(host->id_data.model));
-	mg_ide_fixstring(host->id_data.serial_no,
-			sizeof(host->id_data.serial_no));
-	mg_ide_fixstring(host->id_data.fw_rev,
-			sizeof(host->id_data.fw_rev));
-	printk(KERN_INFO "mg_disk: model: %s\n", host->id_data.model);
-	printk(KERN_INFO "mg_disk: firm: %.8s\n", host->id_data.fw_rev);
-	printk(KERN_INFO "mg_disk: serial: %s\n",
-			host->id_data.serial_no);
+	host->n_sectors = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
+	host->cyls = id[ATA_ID_CYLS];
+	host->heads = id[ATA_ID_HEADS];
+	host->sectors = id[ATA_ID_SECTORS];
+
+	if (MG_RES_SEC && host->heads && host->sectors) {
+		/* modify cyls, n_sectors */
+		host->cyls = (host->n_sectors - MG_RES_SEC) /
+			host->heads / host->sectors;
+		host->nres_sectors = host->n_sectors - host->cyls *
+			host->heads * host->sectors;
+		host->n_sectors -= host->nres_sectors;
+	}
+
+	ata_id_c_string(id, fwrev, ATA_ID_FW_REV, sizeof(fwrev));
+	ata_id_c_string(id, model, ATA_ID_PROD, sizeof(model));
+	ata_id_c_string(id, serial, ATA_ID_SERNO, sizeof(serial));
+	printk(KERN_INFO "mg_disk: model: %s\n", model);
+	printk(KERN_INFO "mg_disk: firm: %.8s\n", fwrev);
+	printk(KERN_INFO "mg_disk: serial: %s\n", serial);
 	printk(KERN_INFO "mg_disk: %d + reserved %d sectors\n",
-			host->tot_sectors, res);
+			host->n_sectors, host->nres_sectors);
 
 	if (!prv_data->use_polling)
-		outb(MG_REG_CTRL_INTR_ENABLE, host->dev_base + MG_REG_DRV_CTRL);
+		outb(MG_REG_CTRL_INTR_ENABLE, (unsigned long)host->dev_base +
+				MG_REG_DRV_CTRL);
 
 	return err;
 }
@@ -235,13 +239,13 @@ static int mg_disk_init(struct mg_host *
 
 	/* hdd rst low */
 	gpio_set_value(host->rst, 0);
-	err = mg_wait(host, MG_REG_STATUS_BIT_BUSY, 300);
+	err = mg_wait(host, MG_REG_STATUS_BIT_BUSY, MG_TMAX_RST_TO_BUSY);
 	if (err)
 		return err;
 
 	/* hdd rst high */
 	gpio_set_value(host->rst, 1);
-	err = mg_wait(host, MG_STAT_READY, 3000);
+	err = mg_wait(host, MG_STAT_READY, MG_TMAX_HDRST_TO_RDY);
 	if (err)
 		return err;
 
@@ -249,20 +253,20 @@ static int mg_disk_init(struct mg_host *
 	outb(MG_REG_CTRL_RESET |
 			(prv_data->use_polling ? MG_REG_CTRL_INTR_DISABLE :
 			 MG_REG_CTRL_INTR_ENABLE),
-			host->dev_base + MG_REG_DRV_CTRL);
-	err = mg_wait(host, MG_REG_STATUS_BIT_BUSY, 3000);
+			(unsigned long)host->dev_base + MG_REG_DRV_CTRL);
+	err = mg_wait(host, MG_REG_STATUS_BIT_BUSY, MG_TMAX_RST_TO_BUSY);
 	if (err)
 		return err;
 
 	/* soft reset off */
 	outb(prv_data->use_polling ? MG_REG_CTRL_INTR_DISABLE :
 			MG_REG_CTRL_INTR_ENABLE,
-			host->dev_base + MG_REG_DRV_CTRL);
-	err = mg_wait(host, MG_STAT_READY, 3000);
+			(unsigned long)host->dev_base + MG_REG_DRV_CTRL);
+	err = mg_wait(host, MG_STAT_READY, MG_TMAX_SWRST_TO_RDY);
 	if (err)
 		return err;
 
-	init_status = inb(host->dev_base + MG_REG_STATUS) & 0xf;
+	init_status = inb((unsigned long)host->dev_base + MG_REG_STATUS) & 0xf;
 
 	if (init_status == 0xf)
 		return MG_ERR_INIT_STAT;
@@ -273,15 +277,10 @@ static int mg_disk_init(struct mg_host *
 static void mg_bad_rw_intr(struct mg_host *host)
 {
 	struct request *req = elv_next_request(host->breq);
-	if (req != NULL) {
-		if (++req->errors >= MG_MAX_ERRORS) {
+	if (req != NULL)
+		if (++req->errors >= MG_MAX_ERRORS ||
+				host->error == MG_ERR_TIMEOUT)
 			end_request(req, 0);
-		} else if (req->errors % MG_RESET_FREQ == 0 ||
-				host->error == MG_ERR_TIMEOUT) {
-			host->reset = 1;
-		}
-		/* Otherwise just retry */
-	}
 }
 
 static unsigned int mg_out(struct mg_host *host,
@@ -292,7 +291,7 @@ static unsigned int mg_out(struct mg_hos
 {
 	struct mg_drv_data *prv_data = host->dev->platform_data;
 
-	if (mg_wait(host, MG_STAT_READY, 3000))
+	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD))
 		return host->error;
 
 	if (!prv_data->use_polling) {
@@ -301,13 +300,15 @@ static unsigned int mg_out(struct mg_hos
 	}
 	if (MG_RES_SEC)
 		sect_num += MG_RES_SEC;
-	outb((u8)sect_cnt, host->dev_base + MG_REG_SECT_CNT);
-	outb((u8)sect_num, host->dev_base + MG_REG_SECT_NUM);
-	outb((u8)(sect_num >> 8), host->dev_base + MG_REG_CYL_LOW);
-	outb((u8)(sect_num >> 16), host->dev_base + MG_REG_CYL_HIGH);
+	outb((u8)sect_cnt, (unsigned long)host->dev_base + MG_REG_SECT_CNT);
+	outb((u8)sect_num, (unsigned long)host->dev_base + MG_REG_SECT_NUM);
+	outb((u8)(sect_num >> 8), (unsigned long)host->dev_base +
+			MG_REG_CYL_LOW);
+	outb((u8)(sect_num >> 16), (unsigned long)host->dev_base +
+			MG_REG_CYL_HIGH);
 	outb((u8)((sect_num >> 24) | MG_REG_HEAD_LBA_MODE),
-			host->dev_base + MG_REG_DRV_HEAD);
-	outb(cmd, host->dev_base + MG_REG_COMMAND);
+			(unsigned long)host->dev_base + MG_REG_DRV_HEAD);
+	outb(cmd, (unsigned long)host->dev_base + MG_REG_COMMAND);
 	return MG_ERR_NONE;
 }
 
@@ -318,14 +319,6 @@ static void mg_read(struct request *req)
 
 	remains = req->nr_sectors;
 
-	if (host->reset) {
-		if (mg_disk_init(host)) {
-			end_request(req, 0);
-			return;
-		}
-		host->reset = 0;
-	}
-
 	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_RD, 0) !=
 			MG_ERR_NONE)
 		mg_bad_rw_intr(host);
@@ -334,14 +327,15 @@ static void mg_read(struct request *req)
 			remains, req->sector, req->buffer);
 
 	while (remains) {
-		if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, 3000) !=
-				MG_ERR_NONE) {
+		if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
+					MG_TMAX_WAIT_RD_DRQ) != MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return;
 		}
 		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++) {
 			*(u16 *)req->buffer =
-				inw(host->dev_base + MG_BUFF_OFFSET + (j << 1));
+				inw((unsigned long)host->dev_base +
+						MG_BUFF_OFFSET + (j << 1));
 			req->buffer += 2;
 		}
 
@@ -357,7 +351,8 @@ static void mg_read(struct request *req)
 				req = elv_next_request(host->breq);
 		}
 
-		outb(MG_CMD_RD_CONF, host->dev_base + MG_REG_COMMAND);
+		outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base +
+				MG_REG_COMMAND);
 	}
 }
 
@@ -368,14 +363,6 @@ static void mg_write(struct request *req
 
 	remains = req->nr_sectors;
 
-	if (host->reset) {
-		if (mg_disk_init(host)) {
-			end_request(req, 0);
-			return;
-		}
-		host->reset = 0;
-	}
-
 	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_WR, 0) !=
 			MG_ERR_NONE) {
 		mg_bad_rw_intr(host);
@@ -386,13 +373,14 @@ static void mg_write(struct request *req
 	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
 			remains, req->sector, req->buffer);
 	while (remains) {
-		if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, 3000) !=
-				MG_ERR_NONE) {
+		if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
+					MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return;
 		}
 		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++) {
-			outw(*(u16 *)req->buffer, host->dev_base +
+			outw(*(u16 *)req->buffer,
+					(unsigned long)host->dev_base +
 					MG_BUFF_OFFSET + (j << 1));
 			req->buffer += 2;
 		}
@@ -407,7 +395,8 @@ static void mg_write(struct request *req
 				req = elv_next_request(host->breq);
 		}
 
-		outb(MG_CMD_WR_CONF, host->dev_base + MG_REG_COMMAND);
+		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
+				MG_REG_COMMAND);
 	}
 }
 
@@ -418,7 +407,7 @@ static void mg_read_intr(struct mg_host 
 
 	/* check status */
 	do {
-		i = inb(host->dev_base + MG_REG_STATUS);
+		i = inb((unsigned long)host->dev_base + MG_REG_STATUS);
 		if (i & MG_REG_STATUS_BIT_BUSY)
 			break;
 		if (!MG_READY_OK(i))
@@ -438,7 +427,8 @@ ok_to_read:
 	/* read 1 sector */
 	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++) {
 		*(u16 *)req->buffer =
-			inw(host->dev_base + MG_BUFF_OFFSET + (i << 1));
+			inw((unsigned long)host->dev_base + MG_BUFF_OFFSET +
+					(i << 1));
 		req->buffer += 2;
 	}
 
@@ -462,7 +452,7 @@ ok_to_read:
 	}
 
 	/* send read confirm */
-	outb(MG_CMD_RD_CONF, host->dev_base + MG_REG_COMMAND);
+	outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
 
 	/* goto next request */
 	if (!i)
@@ -480,7 +470,7 @@ static void mg_write_intr(struct mg_host
 
 	/* check status */
 	do {
-		i = inb(host->dev_base + MG_REG_STATUS);
+		i = inb((unsigned long)host->dev_base + MG_REG_STATUS);
 		if (i & MG_REG_STATUS_BIT_BUSY)
 			break;
 		if (!MG_READY_OK(i))
@@ -508,7 +498,8 @@ ok_to_write:
 	if (i > 0) {
 		buff = (u16 *)req->buffer;
 		for (j = 0; j < MG_STORAGE_BUFFER_SIZE >> 1; j++) {
-			outw(*buff, host->dev_base + MG_BUFF_OFFSET + (j << 1));
+			outw(*buff, (unsigned long)host->dev_base +
+					MG_BUFF_OFFSET + (j << 1));
 			buff++;
 		}
 		MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n",
@@ -518,7 +509,7 @@ ok_to_write:
 	}
 
 	/* send write confirm */
-	outb(MG_CMD_WR_CONF, host->dev_base + MG_REG_COMMAND);
+	outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
 
 	if (!i)
 		mg_request(host->breq);
@@ -589,26 +580,30 @@ static unsigned int mg_issue_req(struct 
 	case WRITE:
 		/* TODO : handler */
 		outb(MG_REG_CTRL_INTR_DISABLE,
-				host->dev_base + MG_REG_DRV_CTRL);
+				(unsigned long)host->dev_base +
+				MG_REG_DRV_CTRL);
 		if (mg_out(host, sect_num, sect_cnt, MG_CMD_WR, &mg_write_intr)
 				!= MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return host->error;
 		}
 		del_timer(&host->timer);
-		mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, 3000);
-		outb(MG_REG_CTRL_INTR_ENABLE, host->dev_base + MG_REG_DRV_CTRL);
+		mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, MG_TMAX_WAIT_WR_DRQ);
+		outb(MG_REG_CTRL_INTR_ENABLE, (unsigned long)host->dev_base +
+				MG_REG_DRV_CTRL);
 		if (host->error) {
 			mg_bad_rw_intr(host);
 			return host->error;
 		}
 		buff = (u16 *)req->buffer;
 		for (i = 0; i < MG_SECTOR_SIZE >> 1; i++) {
-			outw(*buff, host->dev_base + MG_BUFF_OFFSET + (i << 1));
+			outw(*buff, (unsigned long)host->dev_base +
+					MG_BUFF_OFFSET + (i << 1));
 			buff++;
 		}
 		mod_timer(&host->timer, jiffies + 3 * HZ);
-		outb(MG_CMD_WR_CONF, host->dev_base + MG_REG_COMMAND);
+		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
+				MG_REG_COMMAND);
 		break;
 	default:
 		printk(KERN_WARNING "%s:%d unknown command\n",
@@ -639,14 +634,6 @@ static void mg_request(struct request_qu
 
 		del_timer(&host->timer);
 
-		if (host->reset) {
-			if (mg_disk_init(host)) {
-				end_request(req, 0);
-				return;
-			}
-			host->reset = 0;
-		}
-
 		sect_num = req->sector;
 		/* deal whole segments */
 		sect_cnt = req->nr_sectors;
@@ -675,9 +662,9 @@ static int mg_getgeo(struct block_device
 {
 	struct mg_host *host = bdev->bd_disk->private_data;
 
-	geo->cylinders = host->id_data.cyls;
-	geo->heads = host->id_data.heads;
-	geo->sectors = host->id_data.sectors;
+	geo->cylinders = (unsigned short)host->cyls;
+	geo->heads = (unsigned char)host->heads;
+	geo->sectors = (unsigned char)host->sectors;
 	return 0;
 }
 
@@ -690,20 +677,23 @@ static int mg_suspend(struct platform_de
 	struct mg_drv_data *prv_data = plat_dev->dev.platform_data;
 	struct mg_host *host = prv_data->host;
 
-	if (mg_wait(host, MG_STAT_READY, 3000))
+	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD))
 		return -EIO;
 
 	if (!prv_data->use_polling)
 		outb(MG_REG_CTRL_INTR_DISABLE,
-				host->dev_base + MG_REG_DRV_CTRL);
+				(unsigned long)host->dev_base +
+				MG_REG_DRV_CTRL);
 
-	outb(MG_CMD_SLEEP, host->dev_base + MG_REG_COMMAND);
-	mdelay(1);
+	outb(MG_CMD_SLEEP, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	/* wait until mflash deep sleep */
+	msleep(1);
 
-	if (mg_wait(host, MG_STAT_READY, 3000)) {
+	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD)) {
 		if (!prv_data->use_polling)
 			outb(MG_REG_CTRL_INTR_ENABLE,
-					host->dev_base + MG_REG_DRV_CTRL);
+					(unsigned long)host->dev_base +
+					MG_REG_DRV_CTRL);
 		return -EIO;
 	}
 
@@ -715,17 +705,19 @@ static int mg_resume(struct platform_dev
 	struct mg_drv_data *prv_data = plat_dev->dev.platform_data;
 	struct mg_host *host = prv_data->host;
 
-	if (mg_wait(host, MG_STAT_READY, 3000))
+	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD))
 		return -EIO;
 
-	outb(MG_CMD_WAKEUP, host->dev_base + MG_REG_COMMAND);
-	mdelay(1);
+	outb(MG_CMD_WAKEUP, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	/* wait until mflash wakeup */
+	msleep(1);
 
-	if (mg_wait(host, MG_STAT_READY, 3000))
+	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD))
 		return -EIO;
 
 	if (!prv_data->use_polling)
-		outb(MG_REG_CTRL_INTR_ENABLE, host->dev_base + MG_REG_DRV_CTRL);
+		outb(MG_REG_CTRL_INTR_ENABLE, (unsigned long)host->dev_base +
+				MG_REG_DRV_CTRL);
 
 	return 0;
 }
@@ -745,14 +737,13 @@ static int mg_probe(struct platform_devi
 	}
 
 	/* alloc mg_host */
-	host = kmalloc(sizeof(struct mg_host), GFP_KERNEL);
+	host = kzalloc(sizeof(struct mg_host), GFP_KERNEL);
 	if (!host) {
 		printk(KERN_ERR "%s:%d fail (no memory for mg_host)\n",
 				__func__, __LINE__);
 		err = -ENOMEM;
 		goto probe_err;
 	}
-	memset(host, 0, sizeof(struct mg_host));
 	host->major = MG_DISK_MAJ;
 
 	/* link each other */
@@ -767,7 +758,7 @@ static int mg_probe(struct platform_devi
 		err = -EINVAL;
 		goto probe_err_2;
 	}
-	host->dev_base = (unsigned long)ioremap(rsc->start , rsc->end + 1);
+	host->dev_base = ioremap(rsc->start , rsc->end + 1);
 	if (!host->dev_base) {
 		printk(KERN_ERR "%s:%d ioremap fail\n",
 				__func__, __LINE__);
@@ -777,7 +768,8 @@ static int mg_probe(struct platform_devi
 	MG_DBG("dev_base = 0x%x\n", (u32)host->dev_base);
 
 	/* get reset pin */
-	rsc = platform_get_resource(plat_dev, IORESOURCE_IO, 0);
+	rsc = platform_get_resource_byname(plat_dev, IORESOURCE_IO,
+			MG_RST_PIN);
 	if (!rsc) {
 		printk(KERN_ERR "%s:%d get reset pin fail\n",
 				__func__, __LINE__);
@@ -787,18 +779,44 @@ static int mg_probe(struct platform_devi
 	host->rst = rsc->start;
 
 	/* init rst pin */
-	err = gpio_request(host->rst, "mg_rst");
+	err = gpio_request(host->rst, MG_RST_PIN);
 	if (err)
 		goto probe_err_3;
 	gpio_direction_output(host->rst, 1);
 
-	/* disk init */
-	err = mg_disk_init(host);
-	if (err) {
-		printk(KERN_ERR "%s:%d fail (err code : %d)\n",
-				__func__, __LINE__, err);
-		err = -EIO;
+	/* reset out pin */
+	if (!(prv_data->dev_attr & MG_DEV_MASK))
 		goto probe_err_3a;
+
+	if (prv_data->dev_attr != MG_BOOT_DEV) {
+		rsc = platform_get_resource_byname(plat_dev, IORESOURCE_IO,
+				MG_RSTOUT_PIN);
+		if (!rsc) {
+			printk(KERN_ERR "%s:%d get reset-out pin fail\n",
+					__func__, __LINE__);
+			err = -EIO;
+			goto probe_err_3a;
+		}
+		host->rstout = rsc->start;
+		err = gpio_request(host->rstout, MG_RSTOUT_PIN);
+		if (err)
+			goto probe_err_3a;
+		gpio_direction_input(host->rstout);
+	}
+
+	/* disk reset */
+	if (prv_data->dev_attr == MG_STORAGE_DEV) {
+		/* If POR seq. not yet finised, wait */
+		err = mg_wait_rstout(host->rstout, MG_TMAX_RSTOUT);
+		if (err)
+			goto probe_err_3b;
+		err = mg_disk_init(host);
+		if (err) {
+			printk(KERN_ERR "%s:%d fail (err code : %d)\n",
+					__func__, __LINE__, err);
+			err = -EIO;
+			goto probe_err_3b;
+		}
 	}
 
 	/* get irq resource */
@@ -806,7 +824,7 @@ static int mg_probe(struct platform_devi
 		host->irq = platform_get_irq(plat_dev, 0);
 		if (host->irq == -ENXIO) {
 			err = host->irq;
-			goto probe_err_3a;
+			goto probe_err_3b;
 		}
 		err = request_irq(host->irq, mg_irq,
 				IRQF_DISABLED | IRQF_TRIGGER_RISING,
@@ -814,7 +832,7 @@ static int mg_probe(struct platform_devi
 		if (err) {
 			printk(KERN_ERR "%s:%d fail (request_irq err=%d)\n",
 					__func__, __LINE__, err);
-			goto probe_err_3a;
+			goto probe_err_3b;
 		}
 
 	}
@@ -880,7 +898,7 @@ static int mg_probe(struct platform_devi
 	host->gd->private_data = host;
 	sprintf(host->gd->disk_name, MG_DISK_NAME"a");
 
-	set_capacity(host->gd, host->tot_sectors);
+	set_capacity(host->gd, host->n_sectors);
 
 	add_disk(host->gd);
 
@@ -895,10 +913,12 @@ probe_err_5:
 probe_err_4:
 	if (!prv_data->use_polling)
 		free_irq(host->irq, host);
+probe_err_3b:
+	gpio_free(host->rstout);
 probe_err_3a:
 	gpio_free(host->rst);
 probe_err_3:
-	iounmap((void __iomem *)host->dev_base);
+	iounmap(host->dev_base);
 probe_err_2:
 	kfree(host);
 probe_err:
@@ -930,13 +950,17 @@ static int mg_remove(struct platform_dev
 	if (!prv_data->use_polling)
 		free_irq(host->irq, host);
 
+	/* free reset-out pin */
+	if (prv_data->dev_attr != MG_BOOT_DEV)
+		gpio_free(host->rstout);
+
 	/* free rst pin */
 	if (host->rst)
 		gpio_free(host->rst);
 
 	/* unmap io */
 	if (host->dev_base)
-		iounmap((void __iomem *)host->dev_base);
+		iounmap(host->dev_base);
 
 	/* free mg_host */
 	kfree(host);
diff -puN include/linux/mg_disk.h~mflash-initial-support-v2 include/linux/mg_disk.h
--- a/include/linux/mg_disk.h~mflash-initial-support-v2
+++ a/include/linux/mg_disk.h
@@ -16,7 +16,7 @@
 #define __MG_DISK_H__
 
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
+#include <linux/ata.h>
 
 /* name for block device */
 #define MG_DISK_NAME "mgd"
@@ -91,14 +91,15 @@
 #define MG_REG_ERR_BBK		0x80
 
 /* error code for others */
-#define MG_ERR_NONE 0
-#define MG_ERR_TIMEOUT 0x100
-#define MG_ERR_INIT_STAT 0x101
-#define MG_ERR_TRANSLATION 0x102
-#define MG_ERR_CTRL_RST 0x103
+#define MG_ERR_NONE		0
+#define MG_ERR_TIMEOUT		0x100
+#define MG_ERR_INIT_STAT	0x101
+#define MG_ERR_TRANSLATION	0x102
+#define MG_ERR_CTRL_RST		0x103
+#define MG_ERR_INV_STAT		0x104
+#define MG_ERR_RSTOUT		0x105
 
-#define MG_MAX_ERRORS	16	/* Max read/write errors/sector */
-#define MG_RESET_FREQ	4	/* Reset controller every 4th retry */
+#define MG_MAX_ERRORS	6	/* Max read/write errors */
 
 /* command */
 #define MG_CMD_RD 0x20
@@ -127,11 +128,38 @@
 #define MG_BURST_LEN_32 (4 << 1)
 #define MG_BURST_LEN_CONT (0 << 1)
 
+/* timeout value (unit: ms) */
+#define MG_TMAX_CONF_TO_CMD	1
+#define MG_TMAX_WAIT_RD_DRQ	10
+#define MG_TMAX_WAIT_WR_DRQ	500
+#define MG_TMAX_RST_TO_BUSY	10
+#define MG_TMAX_HDRST_TO_RDY	500
+#define MG_TMAX_SWRST_TO_RDY	500
+#define MG_TMAX_RSTOUT		3000
+
+/* device attribution */
+/* use mflash as boot device */
+#define MG_BOOT_DEV		(1 << 0)
+/* use mflash as storage device */
+#define MG_STORAGE_DEV		(1 << 1)
+/* same as MG_STORAGE_DEV, but bootloader already done reset sequence */
+#define MG_STORAGE_DEV_SKIP_RST	(1 << 2)
+
+#define MG_DEV_MASK (MG_BOOT_DEV | MG_STORAGE_DEV | MG_STORAGE_DEV_SKIP_RST)
+
+/* names of GPIO resource */
+#define MG_RST_PIN	"mg_rst"
+/* except MG_BOOT_DEV, reset-out pin should be assigned */
+#define MG_RSTOUT_PIN	"mg_rstout"
+
 /* private driver data */
 struct mg_drv_data {
 	/* disk resource */
 	u32 use_polling;
 
+	/* device attribution */
+	u32 dev_attr;
+
 	/* internally used */
 	struct mg_host *host;
 };
@@ -147,16 +175,21 @@ struct mg_host {
 	struct timer_list timer;
 	void (*mg_do_intr) (struct mg_host *);
 
-	struct hd_driveid id_data;
-	u32 tot_sectors;
+	u16 id[ATA_ID_WORDS];
+
+	u16 cyls;
+	u16 heads;
+	u16 sectors;
+	u32 n_sectors;
+	u32 nres_sectors;
 
-	unsigned long dev_base;
+	void __iomem *dev_base;
 	unsigned int irq;
 	unsigned int rst;
+	unsigned int rstout;
 
 	u32 major;
 	u32 error;
-	u32 reset;
 };
 
 /*
_

Patches currently in -mm which might be from donari75@gmail.com are

mflash-initial-support.patch
mflash-initial-support-v2.patch

