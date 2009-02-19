From: akpm@linux-foundation.org
Subject: [merged] mmc-add-extended-csd-as-a-device-attribute.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:33 -0800
Message-ID: <200902191917.n1JJHXkM016385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829AbZBSTRs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:17:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-adrian.hunter@nokia.com, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc: add Extended CSD as a device attribute
has been removed from the -mm tree.  Its filename was
     mmc-add-extended-csd-as-a-device-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: add Extended CSD as a device attribute
From: Adrian Hunter <ext-adrian.hunter@nokia.com>

Extended CSD is a MMC card register.  The Card Identification (CID)
register and the Card-Specific Data (CSD) register are already device
attributes.  As increasingly interesting fields are being added to
Extended CSD, it seems reasonable to add it too.  Note that SD cards do
not have an Extended CSD register, so it is MMC only.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/mmc.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN drivers/mmc/core/mmc.c~mmc-add-extended-csd-as-a-device-attribute drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~mmc-add-extended-csd-as-a-device-attribute
+++ a/drivers/mmc/core/mmc.c
@@ -259,6 +259,34 @@ MMC_DEV_ATTR(name, "%s\n", card->cid.pro
 MMC_DEV_ATTR(oemid, "0x%04x\n", card->cid.oemid);
 MMC_DEV_ATTR(serial, "0x%08x\n", card->cid.serial);
 
+static ssize_t mmc_ext_csd_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mmc_card *card = container_of(dev, struct mmc_card, dev);
+	ssize_t n = 0;
+	u8 *ext_csd;
+	int err, i;
+
+	ext_csd = kmalloc(512, GFP_KERNEL);
+	if (!ext_csd)
+		return 0;
+
+	mmc_claim_host(card->host);
+	err = mmc_send_ext_csd(card, ext_csd);
+	mmc_release_host(card->host);
+
+	if (!err) {
+		for (i = 511; i >= 0; i--)
+			n += sprintf(buf + n, "%02x", ext_csd[i]);
+		n += sprintf(buf + n, "\n");
+	}
+
+	kfree(ext_csd);
+
+	return n;
+}
+
+static DEVICE_ATTR(ext_csd, S_IRUGO, mmc_ext_csd_show, NULL);
+
 static struct attribute *mmc_std_attrs[] = {
 	&dev_attr_cid.attr,
 	&dev_attr_csd.attr,
@@ -269,6 +297,7 @@ static struct attribute *mmc_std_attrs[]
 	&dev_attr_name.attr,
 	&dev_attr_oemid.attr,
 	&dev_attr_serial.attr,
+	&dev_attr_ext_csd.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from ext-adrian.hunter@nokia.com are

origin.patch
linux-next.patch
mmc_core-fix-data-timeout-for-send_ext_csd.patch

