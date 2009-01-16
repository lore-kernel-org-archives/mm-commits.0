From: akpm@linux-foundation.org
Subject: + mmc-add-extended-csd-as-a-device-attribute.patch added to -mm tree
Date: Thu, 15 Jan 2009 16:06:01 -0800
Message-ID: <200901160006.n0G061N2000589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037AbZAPAGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 19:06:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-adrian.hunter@nokia.com, drzeus-list@drzeus.cx


The patch titled
     mmc: add Extended CSD as a device attribute
has been added to the -mm tree.  Its filename is
     mmc-add-extended-csd-as-a-device-attribute.patch

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
Subject: mmc: add Extended CSD as a device attribute
From: Adrian Hunter <ext-adrian.hunter@nokia.com>

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
+			n += sprintf(buf + n, "%02x", (unsigned)ext_csd[i]);
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

mmc-add-extended-csd-as-a-device-attribute.patch

