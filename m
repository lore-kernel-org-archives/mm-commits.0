From: akpm@linux-foundation.org
Subject: [wrecked] mtd-m25p80-rework-probing-jedec-code.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:51:31 -0700
Message-ID: <200909231951.n8NJpVP6027239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbZIWTwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:52:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, ben-linux@fluff.org, benh@kernel.crashing.org, dbrownell@users.sourceforge.net, dwmw2@infradead.org, grant.likely@secretlab.ca, khali@linux-fr.org, mm-commit


The patch titled
     mtd: m25p80: Rework probing/JEDEC code
has been removed from the -mm tree.  Its filename was
     mtd-m25p80-rework-probing-jedec-code.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: m25p80: Rework probing/JEDEC code
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Previously the driver always tried JEDEC probing, assuming that non-JEDEC
chips will return '0'.  But truly non-JEDEC chips (like CAT25) won't do
that, their behaviour on RDID command is undefined, so the driver should
not call jedec_probe() for these chips.

Also, be less strict on error conditions, don't fail to probe if JEDEC
found a chip that is different from what platform code told, instead just
print some warnings and use an information obtained via JEDEC.  In that
case we should not trust partitions any longer, but they might be still
useful (i.e.  they could protect some parts of the chip).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |   69 +++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 29 deletions(-)

diff -puN drivers/mtd/devices/m25p80.c~mtd-m25p80-rework-probing-jedec-code drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~mtd-m25p80-rework-probing-jedec-code
+++ a/drivers/mtd/devices/m25p80.c
@@ -584,6 +584,14 @@ static const struct spi_device_id *__dev
 	jedec = jedec << 8;
 	jedec |= id[2];
 
+	/*
+	 * Some chips (like Numonyx M25P80) have JEDEC and non-JEDEC variants,
+	 * which depend on technology process. Officially RDID command doesn't
+	 * exist for non-JEDEC chips, but for compatibility they return ID 0.
+	 */
+	if (jedec == 0)
+		return NULL;
+
 	ext_jedec = id[3] << 8 | id[4];
 
 	for (tmp = 0; tmp < ARRAY_SIZE(m25p_ids) - 1; tmp++) {
@@ -605,7 +613,7 @@ static const struct spi_device_id *__dev
  */
 static int __devinit m25p_probe(struct spi_device *spi)
 {
-	const struct spi_device_id	*id;
+	const struct spi_device_id	*id = spi_get_device_id(spi);
 	struct flash_platform_data	*data;
 	struct m25p			*flash;
 	struct flash_info		*info;
@@ -618,41 +626,44 @@ static int __devinit m25p_probe(struct s
 	 */
 	data = spi->dev.platform_data;
 	if (data && data->type) {
+		const struct spi_device_id *plat_id;
+
 		for (i = 0; i < ARRAY_SIZE(m25p_ids) - 1; i++) {
-			id = &m25p_ids[i];
-			info = (void *)m25p_ids[i].driver_data;
-			if (strcmp(data->type, id->name))
+			plat_id = &m25p_ids[i];
+			if (strcmp(data->type, plat_id->name))
 				continue;
 			break;
 		}
 
-		/* unrecognized chip? */
-		if (i == ARRAY_SIZE(m25p_ids) - 1) {
-			DEBUG(MTD_DEBUG_LEVEL0, "%s: unrecognized id %s\n",
-					dev_name(&spi->dev), data->type);
-			info = NULL;
-
-		/* recognized; is that chip really what's there? */
-		} else if (info->jedec_id) {
-			id = jedec_probe(spi);
-
-			if (id != &m25p_ids[i]) {
-				dev_warn(&spi->dev, "found %s, expected %s\n",
-						id ? id->name : "UNKNOWN",
-						m25p_ids[i].name);
-				info = NULL;
-			}
-		}
-	} else {
-		id = jedec_probe(spi);
-		if (!id)
-			id = spi_get_device_id(spi);
-
-		info = (void *)id->driver_data;
+		if (plat_id)
+			id = plat_id;
+		else
+			dev_warn(&spi->dev, "unrecognized id %s\n", data->type);
 	}
 
-	if (!info)
-		return -ENODEV;
+	info = (void *)id->driver_data;
+
+	if (info->jedec_id) {
+		const struct spi_device_id *jid;
+
+		jid = jedec_probe(spi);
+		if (!jid) {
+			dev_info(&spi->dev, "non-JEDEC variant of %s\n",
+				 id->name);
+		} else if (jid != id) {
+			/*
+			 * JEDEC knows better, so overwrite platform ID. We
+			 * can't trust partitions any longer, but we'll let
+			 * mtd apply them anyway, since some partitions may be
+			 * marked read-only, and we don't want to lose that
+			 * information, even if it's not 100% accurate.
+			 */
+			dev_warn(&spi->dev, "found %s, expected %s\n",
+				 jid->name, id->name);
+			id = jid;
+			info = (void *)jid->driver_data;
+		}
+	}
 
 	flash = kzalloc(sizeof *flash, GFP_KERNEL);
 	if (!flash)
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
mtd-m25p80-rework-probing-jedec-code.patch
mtd-m25p80-add-support-for-cat25xxx-serial-eeproms.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

