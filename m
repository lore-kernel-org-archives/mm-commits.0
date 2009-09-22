From: akpm@linux-foundation.org
Subject: + mtd-m25p80-rework-probing-jedec-code.patch added to -mm tree
Date: Tue, 22 Sep 2009 16:26:51 -0700
Message-ID: <200909222326.n8MNQqUt009778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535AbZIVX3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 19:29:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, ben-linux@fluff.org, benh@kernel.crashing.org, dbrownell@users.sourceforge.net, dwmw2@infradead.org, grant.likely@secretlab.ca, khali@linux-fr.org


The patch titled
     mtd: m25p80: Rework probing/JEDEC code
has been added to the -mm tree.  Its filename is
     mtd-m25p80-rework-probing-jedec-code.patch

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
sdhci-be-more-strict-with-get_min_clock-usage.patch
sdhci-of-fix-sd-clock-calculation.patch
sdhci-of-avoid-writing-reserved-bits-into-host-control-register.patch
sdhci-of-fix-high-speed-cards-recognition.patch
powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc.patch
sdhci-of-dont-hard-code-inverted-write-protect-quirk.patch
sdhci-of-cleanup-esdhcs-set_clock-a-little-bit.patch
powerpc-85xx-add-esdhc-support-for-mpc8536ds-boards.patch
spi-add-support-for-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch
linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-m25p80-convert-to-device-table-matching.patch
mtd-m25p80-rework-probing-jedec-code.patch
mtd-m25p80-add-support-for-cat25xxx-serial-eeproms.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

