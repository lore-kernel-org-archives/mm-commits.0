From: akpm@linux-foundation.org
Subject: - libata-dont-whine-if-prereset-returns-enoent.patch removed from -mm tree
Date: Mon, 19 Mar 2007 14:04:15 -0800
Message-ID: <200703192204.l2JM4FPW018938@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58762 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030699AbXCSWER (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 18:04:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     libata: don't whine if ->prereset() returns -ENOENT
has been removed from the -mm tree.  Its filename was
     libata-dont-whine-if-prereset-returns-enoent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: don't whine if ->prereset() returns -ENOENT
From: Tejun Heo <htejun@gmail.com>

->prereset() returns -ENOENT to tell libata that the port is empty and
reset sequencing should be stopped.  This is not an error condition.
Update ata_eh_reset() such that it sets device classes to ATA_DEV_NONE
and return success in on -ENOENT.  This makes spurious error message
go away.

1.  I think these ports should be made dummy instead of returning
   -ENOENT on prereset().  -ENOENT from prereset() was a hack to keep
   ata_piix's behavior unchanged while converting it to new EH.  If no one
   objcts, I'll convert similar usages to use dummy ports after new init
   model and drop -ENOENT hack in #upstream.

2.  -ENODEV sounds more appropriate.  Why have I used -ENOENT.  :-)

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-eh.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/ata/libata-eh.c~libata-dont-whine-if-prereset-returns-enoent drivers/ata/libata-eh.c
--- a/drivers/ata/libata-eh.c~libata-dont-whine-if-prereset-returns-enoent
+++ a/drivers/ata/libata-eh.c
@@ -1648,8 +1648,14 @@ static int ata_eh_reset(struct ata_port 
 		rc = prereset(ap, jiffies + ATA_EH_PRERESET_TIMEOUT);
 		if (rc) {
 			if (rc == -ENOENT) {
-				ata_port_printk(ap, KERN_DEBUG, "port disabled. ignoring.\n");
+				ata_port_printk(ap, KERN_DEBUG,
+						"port disabled. ignoring.\n");
 				ap->eh_context.i.action &= ~ATA_EH_RESET_MASK;
+
+				for (i = 0; i < ATA_MAX_DEVICES; i++)
+					classes[i] = ATA_DEV_NONE;
+
+				rc = 0;
 			} else
 				ata_port_printk(ap, KERN_ERR,
 					"prereset failed (errno=%d)\n", rc);
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
ata-ncq-is-broken-on-maxtor-6l250s0.patch
introduce-config_has_dma.patch
