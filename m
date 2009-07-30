From: akpm@linux-foundation.org
Subject: + mtd-m25p80-convert-to-device-table-matching.patch added to -mm tree
Date: Thu, 30 Jul 2009 16:09:14 -0700
Message-ID: <200907302309.n6UN9FsY031369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037AbZG3XMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 19:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, ben-linux@fluff.org, benh@kernel.crashing.org, dbrownell@users.sourceforge.net, dwmw2@infradead.org, grant.likely@secretlab.ca, khali@linux-fr.org


The patch titled
     mtd: m25p80: convert to device table matching
has been added to the -mm tree.  Its filename is
     mtd-m25p80-convert-to-device-table-matching.patch

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
Subject: mtd: m25p80: convert to device table matching
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Convert the m25p80 driver so that now it uses .id_table for device
matching, making it properly detect devices on OpenFirmware platforms
(prior to this patch the driver misdetected non-JEDEC chips, seeing all
chips as "m25p80").

Also, now jedec_probe() only does jedec probing, nothing else.  If it is
not able to detect a chip, NULL is returned and the driver fall backs to
the information specified by the platform (platform_data, or exact ID).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |  150 ++++++++++++++++++---------------
 1 file changed, 83 insertions(+), 67 deletions(-)

diff -puN drivers/mtd/devices/m25p80.c~mtd-m25p80-convert-to-device-table-matching drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~mtd-m25p80-convert-to-device-table-matching
+++ a/drivers/mtd/devices/m25p80.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
 #include <linux/math64.h>
+#include <linux/mod_devicetable.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
@@ -462,8 +463,6 @@ static int m25p80_write(struct mtd_info 
  */
 
 struct flash_info {
-	char		*name;
-
 	/* JEDEC id zero means "no ID" (most older chips); otherwise it has
 	 * a high byte of zero plus three data bytes: the manufacturer id,
 	 * then a two byte device id.
@@ -481,74 +480,83 @@ struct flash_info {
 #define	SECT_4K		0x01		/* OPCODE_BE_4K works uniformly */
 };
 
+#define INFO(_jedec_id, _ext_id, _sector_size, _n_sectors, _flags)	\
+	(&(struct flash_info) {						\
+		.jedec_id = (_jedec_id),				\
+		.ext_id = (_ext_id),					\
+		.sector_size = (_sector_size),				\
+		.n_sectors = (_n_sectors),				\
+		.flags = (_flags),					\
+	})
 
 /* NOTE: double check command sets and memory organization when you add
  * more flash chips.  This current list focusses on newer chips, which
  * have been converging on command sets which including JEDEC ID.
  */
-static struct flash_info __devinitdata m25p_data [] = {
-
+static const struct spi_device_id m25p_ids[] = {
 	/* Atmel -- some are (confusingly) marketed as "DataFlash" */
-	{ "at25fs010",  0x1f6601, 0, 32 * 1024, 4, SECT_4K, },
-	{ "at25fs040",  0x1f6604, 0, 64 * 1024, 8, SECT_4K, },
+	{ "at25fs010",  INFO(0x1f6601, 0, 32 * 1024, 4, SECT_4K) },
+	{ "at25fs040",  INFO(0x1f6604, 0, 64 * 1024, 8, SECT_4K) },
 
-	{ "at25df041a", 0x1f4401, 0, 64 * 1024, 8, SECT_4K, },
-	{ "at25df641",  0x1f4800, 0, 64 * 1024, 128, SECT_4K, },
+	{ "at25df041a", INFO(0x1f4401, 0, 64 * 1024, 8, SECT_4K) },
+	{ "at25df641",  INFO(0x1f4800, 0, 64 * 1024, 128, SECT_4K) },
 
-	{ "at26f004",   0x1f0400, 0, 64 * 1024, 8, SECT_4K, },
-	{ "at26df081a", 0x1f4501, 0, 64 * 1024, 16, SECT_4K, },
-	{ "at26df161a", 0x1f4601, 0, 64 * 1024, 32, SECT_4K, },
-	{ "at26df321",  0x1f4701, 0, 64 * 1024, 64, SECT_4K, },
+	{ "at26f004",   INFO(0x1f0400, 0, 64 * 1024, 8, SECT_4K) },
+	{ "at26df081a", INFO(0x1f4501, 0, 64 * 1024, 16, SECT_4K) },
+	{ "at26df161a", INFO(0x1f4601, 0, 64 * 1024, 32, SECT_4K) },
+	{ "at26df321",  INFO(0x1f4701, 0, 64 * 1024, 64, SECT_4K) },
 
 	/* Macronix */
-	{ "mx25l12805d", 0xc22018, 0, 64 * 1024, 256, },
+	{ "mx25l12805d", INFO(0xc22018, 0, 64 * 1024, 256, 0) },
 
 	/* Spansion -- single (large) sector size only, at least
 	 * for the chips listed here (without boot sectors).
 	 */
-	{ "s25sl004a", 0x010212, 0, 64 * 1024, 8, },
-	{ "s25sl008a", 0x010213, 0, 64 * 1024, 16, },
-	{ "s25sl016a", 0x010214, 0, 64 * 1024, 32, },
-	{ "s25sl032a", 0x010215, 0, 64 * 1024, 64, },
-	{ "s25sl064a", 0x010216, 0, 64 * 1024, 128, },
-        { "s25sl12800", 0x012018, 0x0300, 256 * 1024, 64, },
-	{ "s25sl12801", 0x012018, 0x0301, 64 * 1024, 256, },
+	{ "s25sl004a",  INFO(0x010212, 0, 64 * 1024, 8, 0) },
+	{ "s25sl008a",  INFO(0x010213, 0, 64 * 1024, 16, 0) },
+	{ "s25sl016a",  INFO(0x010214, 0, 64 * 1024, 32, 0) },
+	{ "s25sl032a",  INFO(0x010215, 0, 64 * 1024, 64, 0) },
+	{ "s25sl064a",  INFO(0x010216, 0, 64 * 1024, 128, 0) },
+	{ "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024, 64, 0) },
+	{ "s25sl12801", INFO(0x012018, 0x0301, 64 * 1024, 256, 0) },
 
 	/* SST -- large erase sizes are "overlays", "sectors" are 4K */
-	{ "sst25vf040b", 0xbf258d, 0, 64 * 1024, 8, SECT_4K, },
-	{ "sst25vf080b", 0xbf258e, 0, 64 * 1024, 16, SECT_4K, },
-	{ "sst25vf016b", 0xbf2541, 0, 64 * 1024, 32, SECT_4K, },
-	{ "sst25vf032b", 0xbf254a, 0, 64 * 1024, 64, SECT_4K, },
+	{ "sst25vf040b", INFO(0xbf258d, 0, 64 * 1024, 8, SECT_4K) },
+	{ "sst25vf080b", INFO(0xbf258e, 0, 64 * 1024, 16, SECT_4K) },
+	{ "sst25vf016b", INFO(0xbf2541, 0, 64 * 1024, 32, SECT_4K) },
+	{ "sst25vf032b", INFO(0xbf254a, 0, 64 * 1024, 64, SECT_4K) },
 
 	/* ST Microelectronics -- newer production may have feature updates */
-	{ "m25p05",  0x202010,  0, 32 * 1024, 2, },
-	{ "m25p10",  0x202011,  0, 32 * 1024, 4, },
-	{ "m25p20",  0x202012,  0, 64 * 1024, 4, },
-	{ "m25p40",  0x202013,  0, 64 * 1024, 8, },
-	{ "m25p80",         0,  0, 64 * 1024, 16, },
-	{ "m25p16",  0x202015,  0, 64 * 1024, 32, },
-	{ "m25p32",  0x202016,  0, 64 * 1024, 64, },
-	{ "m25p64",  0x202017,  0, 64 * 1024, 128, },
-	{ "m25p128", 0x202018, 0, 256 * 1024, 64, },
-
-	{ "m45pe10", 0x204011,  0, 64 * 1024, 2, },
-	{ "m45pe80", 0x204014,  0, 64 * 1024, 16, },
-	{ "m45pe16", 0x204015,  0, 64 * 1024, 32, },
+	{ "m25p05",  INFO(0x202010,  0, 32 * 1024, 2, 0) },
+	{ "m25p10",  INFO(0x202011,  0, 32 * 1024, 4, 0) },
+	{ "m25p20",  INFO(0x202012,  0, 64 * 1024, 4, 0) },
+	{ "m25p40",  INFO(0x202013,  0, 64 * 1024, 8, 0) },
+	{ "m25p80",  INFO(0x202014,  0, 64 * 1024, 16, 0) },
+	{ "m25p16",  INFO(0x202015,  0, 64 * 1024, 32, 0) },
+	{ "m25p32",  INFO(0x202016,  0, 64 * 1024, 64, 0) },
+	{ "m25p64",  INFO(0x202017,  0, 64 * 1024, 128, 0) },
+	{ "m25p128", INFO(0x202018, 0, 256 * 1024, 64, 0) },
+
+	{ "m45pe10", INFO(0x204011,  0, 64 * 1024, 2, 0) },
+	{ "m45pe80", INFO(0x204014,  0, 64 * 1024, 16, 0) },
+	{ "m45pe16", INFO(0x204015,  0, 64 * 1024, 32, 0) },
 
-	{ "m25pe80", 0x208014,  0, 64 * 1024, 16, },
-	{ "m25pe16", 0x208015,  0, 64 * 1024, 32, SECT_4K, },
+	{ "m25pe80", INFO(0x208014,  0, 64 * 1024, 16, 0) },
+	{ "m25pe16", INFO(0x208015,  0, 64 * 1024, 32, SECT_4K) },
 
 	/* Winbond -- w25x "blocks" are 64K, "sectors" are 4KiB */
-	{ "w25x10", 0xef3011, 0, 64 * 1024, 2, SECT_4K, },
-	{ "w25x20", 0xef3012, 0, 64 * 1024, 4, SECT_4K, },
-	{ "w25x40", 0xef3013, 0, 64 * 1024, 8, SECT_4K, },
-	{ "w25x80", 0xef3014, 0, 64 * 1024, 16, SECT_4K, },
-	{ "w25x16", 0xef3015, 0, 64 * 1024, 32, SECT_4K, },
-	{ "w25x32", 0xef3016, 0, 64 * 1024, 64, SECT_4K, },
-	{ "w25x64", 0xef3017, 0, 64 * 1024, 128, SECT_4K, },
+	{ "w25x10", INFO(0xef3011, 0, 64 * 1024, 2, SECT_4K) },
+	{ "w25x20", INFO(0xef3012, 0, 64 * 1024, 4, SECT_4K) },
+	{ "w25x40", INFO(0xef3013, 0, 64 * 1024, 8, SECT_4K) },
+	{ "w25x80", INFO(0xef3014, 0, 64 * 1024, 16, SECT_4K) },
+	{ "w25x16", INFO(0xef3015, 0, 64 * 1024, 32, SECT_4K) },
+	{ "w25x32", INFO(0xef3016, 0, 64 * 1024, 64, SECT_4K) },
+	{ "w25x64", INFO(0xef3017, 0, 64 * 1024, 128, SECT_4K) },
+	{ },
 };
+MODULE_DEVICE_TABLE(spi, m25p_ids);
 
-static struct flash_info *__devinit jedec_probe(struct spi_device *spi)
+static const struct spi_device_id *__devinit jedec_probe(struct spi_device *spi)
 {
 	int			tmp;
 	u8			code = OPCODE_RDID;
@@ -575,16 +583,14 @@ static struct flash_info *__devinit jede
 
 	ext_jedec = id[3] << 8 | id[4];
 
-	for (tmp = 0, info = m25p_data;
-			tmp < ARRAY_SIZE(m25p_data);
-			tmp++, info++) {
+	for (tmp = 0; tmp < ARRAY_SIZE(m25p_ids) - 1; tmp++) {
+		info = m25p_ids[tmp].data;
 		if (info->jedec_id == jedec) {
 			if (info->ext_id != 0 && info->ext_id != ext_jedec)
 				continue;
-			return info;
+			return &m25p_ids[tmp];
 		}
 	}
-	dev_err(&spi->dev, "unrecognized JEDEC id %06x\n", jedec);
 	return NULL;
 }
 
@@ -594,7 +600,8 @@ static struct flash_info *__devinit jede
  * matches what the READ command supports, at least until this driver
  * understands FAST_READ (for clocks over 25 MHz).
  */
-static int __devinit m25p_probe(struct spi_device *spi)
+static int __devinit m25p_probe(struct spi_device *spi,
+				const struct spi_device_id *id)
 {
 	struct flash_platform_data	*data;
 	struct m25p			*flash;
@@ -608,32 +615,40 @@ static int __devinit m25p_probe(struct s
 	 */
 	data = spi->dev.platform_data;
 	if (data && data->type) {
-		for (i = 0, info = m25p_data;
-				i < ARRAY_SIZE(m25p_data);
-				i++, info++) {
-			if (strcmp(data->type, info->name) == 0)
-				break;
+		for (i = 0; i < ARRAY_SIZE(m25p_ids) - 1; i++) {
+			id = &m25p_ids[i];
+			info = m25p_ids[i].data;
+			if (strcmp(data->type, id->name))
+				continue;
+			break;
 		}
 
 		/* unrecognized chip? */
-		if (i == ARRAY_SIZE(m25p_data)) {
+		if (i == ARRAY_SIZE(m25p_ids) - 1) {
 			DEBUG(MTD_DEBUG_LEVEL0, "%s: unrecognized id %s\n",
 					dev_name(&spi->dev), data->type);
 			info = NULL;
 
 		/* recognized; is that chip really what's there? */
 		} else if (info->jedec_id) {
-			struct flash_info	*chip = jedec_probe(spi);
+			id = jedec_probe(spi);
 
-			if (!chip || chip != info) {
+			if (id != &m25p_ids[i]) {
 				dev_warn(&spi->dev, "found %s, expected %s\n",
-						chip ? chip->name : "UNKNOWN",
-						info->name);
+						id ? id->name : "UNKNOWN",
+						m25p_ids[i].name);
 				info = NULL;
 			}
 		}
-	} else
-		info = jedec_probe(spi);
+	} else {
+		const struct spi_device_id *jid;
+
+		jid = jedec_probe(spi);
+		if (jid)
+			id = jid;
+
+		info = id ? id->data : NULL;
+	}
 
 	if (!info)
 		return -ENODEV;
@@ -680,7 +695,7 @@ static int __devinit m25p_probe(struct s
 
 	flash->mtd.dev.parent = &spi->dev;
 
-	dev_info(&spi->dev, "%s (%lld Kbytes)\n", info->name,
+	dev_info(&spi->dev, "%s (%lld Kbytes)\n", id->name,
 			(long long)flash->mtd.size >> 10);
 
 	DEBUG(MTD_DEBUG_LEVEL2,
@@ -766,7 +781,8 @@ static struct spi_driver m25p80_driver =
 		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
-	.probe	= m25p_probe,
+	.id_table	= m25p_ids,
+	.probe_id	= m25p_probe,
 	.remove	= __devexit_p(m25p_remove),
 
 	/* REVISIT: many of these chips have deep power-down modes, which
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-sst25l-non-jedec-spi-flash-driver-update.patch
mtd-sst25l-non-jedec-spi-flash-driver-fix.patch
mtd-m25p80-fix-null-pointer-dereference-bug.patch
spi-add-support-for-device-table-matching.patch
mtd-m25p80-convert-to-device-table-matching.patch
of-remove-stmm25p40-alias.patch
spi-prefix-modalias-with-spi.patch
spi-merge-probe-and-probe_id-callbacks.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch

