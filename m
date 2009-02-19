From: akpm@linux-foundation.org
Subject: + mmc-add-extended-csd-register-to-debugfs.patch added to -mm tree
Date: Thu, 19 Feb 2009 11:46:33 -0800
Message-ID: <200902191946.n1JJkX4m018140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbZBSTrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:47:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-adrian.hunter@nokia.com, drzeus-mmc@drzeus.cx


The patch titled
     mmc: add Extended CSD register to debugfs
has been added to the -mm tree.  Its filename is
     mmc-add-extended-csd-register-to-debugfs.patch

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
Subject: mmc: add Extended CSD register to debugfs
From: Adrian Hunter <ext-adrian.hunter@nokia.com>

Extended CSD is a MMC card register.  As increasingly interesting fields
are being added to Extended CSD, it is helpful to see its value.  Note
that SD cards do not have an Extended CSD register, so it is MMC only.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/debugfs.c |   67 +++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff -puN drivers/mmc/core/debugfs.c~mmc-add-extended-csd-register-to-debugfs drivers/mmc/core/debugfs.c
--- a/drivers/mmc/core/debugfs.c~mmc-add-extended-csd-register-to-debugfs
+++ a/drivers/mmc/core/debugfs.c
@@ -184,6 +184,68 @@ static int mmc_dbg_card_status_get(void 
 DEFINE_SIMPLE_ATTRIBUTE(mmc_dbg_card_status_fops, mmc_dbg_card_status_get,
 		NULL, "%08llx\n");
 
+#define EXT_CSD_STR_LEN 1025
+
+static int mmc_ext_csd_open(struct inode *inode, struct file *filp)
+{
+	struct mmc_card *card = inode->i_private;
+	char *buf;
+	ssize_t n = 0;
+	u8 *ext_csd;
+	int err, i;
+
+	buf = kmalloc(EXT_CSD_STR_LEN + 1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ext_csd = kmalloc(512, GFP_KERNEL);
+	if (!ext_csd) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+
+	mmc_claim_host(card->host);
+	err = mmc_send_ext_csd(card, ext_csd);
+	mmc_release_host(card->host);
+	if (err)
+		goto out_free;
+
+	for (i = 511; i >= 0; i--)
+		n += sprintf(buf + n, "%02x", ext_csd[i]);
+	n += sprintf(buf + n, "\n");
+	BUG_ON(n != EXT_CSD_STR_LEN);
+
+	filp->private_data = buf;
+	kfree(ext_csd);
+	return 0;
+
+out_free:
+	kfree(buf);
+	kfree(ext_csd);
+	return err;
+}
+
+static ssize_t mmc_ext_csd_read(struct file *filp, char __user *ubuf,
+				size_t cnt, loff_t *ppos)
+{
+	char *buf = filp->private_data;
+
+	return simple_read_from_buffer(ubuf, cnt, ppos,
+				       buf, EXT_CSD_STR_LEN);
+}
+
+static int mmc_ext_csd_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+static struct file_operations mmc_dbg_ext_csd_fops = {
+	.open		= mmc_ext_csd_open,
+	.read		= mmc_ext_csd_read,
+	.release	= mmc_ext_csd_release,
+};
+
 void mmc_add_card_debugfs(struct mmc_card *card)
 {
 	struct mmc_host	*host = card->host;
@@ -211,6 +273,11 @@ void mmc_add_card_debugfs(struct mmc_car
 					&mmc_dbg_card_status_fops))
 			goto err;
 
+	if (mmc_card_mmc(card))
+		if (!debugfs_create_file("ext_csd", S_IRUSR, root, card,
+					&mmc_dbg_ext_csd_fops))
+			goto err;
+
 	return;
 
 err:
_

Patches currently in -mm which might be from ext-adrian.hunter@nokia.com are

origin.patch
linux-next.patch
mmc-add-extended-csd-register-to-debugfs.patch
mmc_core-fix-data-timeout-for-send_ext_csd.patch

