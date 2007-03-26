From: akpm@linux-foundation.org
Subject: + libata-identify-backwards-for-drive-side-cable-detection.patch added to -mm tree
Date: Mon, 26 Mar 2007 15:17:37 -0700
Message-ID: <200703262217.l2QMHbro031985@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55137 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489AbXCZWSD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 18:18:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, alan@redhat.com, jeff@garzik.org


The patch titled
     libata: IDENTIFY backwards for drive side cable detection
has been added to the -mm tree.  Its filename is
     libata-identify-backwards-for-drive-side-cable-detection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: IDENTIFY backwards for drive side cable detection
From: Tejun Heo <htejun@gmail.com>

For drive side cable detection to work correctly, drives need to be
identified backwards such that the slave device releases PDIAG- before the
mater drive tries to detect cable type.  ata_bus_probe() was fixed by
commit f31f0cc2f0b7527072d94d02da332d9bb8d7d94c but the new EH path wasn't
fixed.  This patch makes new EH path do IDENTIFY backwards.

ata_dev_configure() for new devices are still performed master first.
This is to keep the detection messages in forward order.

The following regression is fixed by this.

  http://thread.gmane.org/gmane.linux.ide/17433

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-eh.c |   66 ++++++++++++++++++++++++--------------
 1 files changed, 42 insertions(+), 24 deletions(-)

diff -puN drivers/ata/libata-eh.c~libata-identify-backwards-for-drive-side-cable-detection drivers/ata/libata-eh.c
--- a/drivers/ata/libata-eh.c~libata-identify-backwards-for-drive-side-cable-detection
+++ a/drivers/ata/libata-eh.c
@@ -1767,12 +1767,17 @@ static int ata_eh_revalidate_and_attach(
 {
 	struct ata_eh_context *ehc = &ap->eh_context;
 	struct ata_device *dev;
+	unsigned int new_mask = 0;
 	unsigned long flags;
 	int i, rc = 0;
 
 	DPRINTK("ENTER\n");
 
-	for (i = 0; i < ATA_MAX_DEVICES; i++) {
+	/* For PATA drive side cable detection to work, IDENTIFY must
+	 * be done backwards such that PDIAG- is released by the slave
+	 * device before the master device is identified.
+	 */
+	for (i = ATA_MAX_DEVICES - 1; i >= 0; i--) {
 		unsigned int action, readid_flags = 0;
 
 		dev = &ap->device[i];
@@ -1784,13 +1789,13 @@ static int ata_eh_revalidate_and_attach(
 		if (action & ATA_EH_REVALIDATE && ata_dev_ready(dev)) {
 			if (ata_port_offline(ap)) {
 				rc = -EIO;
-				break;
+				goto err;
 			}
 
 			ata_eh_about_to_do(ap, dev, ATA_EH_REVALIDATE);
 			rc = ata_dev_revalidate(dev, readid_flags);
 			if (rc)
-				break;
+				goto err;
 
 			ata_eh_done(ap, dev, ATA_EH_REVALIDATE);
 
@@ -1808,40 +1813,53 @@ static int ata_eh_revalidate_and_attach(
 
 			rc = ata_dev_read_id(dev, &dev->class, readid_flags,
 					     dev->id);
-			if (rc == 0) {
-				ehc->i.flags |= ATA_EHI_PRINTINFO;
-				rc = ata_dev_configure(dev);
-				ehc->i.flags &= ~ATA_EHI_PRINTINFO;
-			} else if (rc == -ENOENT) {
+			switch (rc) {
+			case 0:
+				new_mask |= 1 << i;
+				break;
+			case -ENOENT:
 				/* IDENTIFY was issued to non-existent
 				 * device.  No need to reset.  Just
 				 * thaw and kill the device.
 				 */
 				ata_eh_thaw_port(ap);
 				dev->class = ATA_DEV_UNKNOWN;
-				rc = 0;
-			}
-
-			if (rc) {
-				dev->class = ATA_DEV_UNKNOWN;
 				break;
+			default:
+				dev->class = ATA_DEV_UNKNOWN;
+				goto err;
 			}
+		}
+	}
 
-			if (ata_dev_enabled(dev)) {
-				spin_lock_irqsave(ap->lock, flags);
-				ap->pflags |= ATA_PFLAG_SCSI_HOTPLUG;
-				spin_unlock_irqrestore(ap->lock, flags);
+	/* Configure new devices forward such that user doesn't see
+	 * device detection messages backwards.
+	 */
+	for (i = 0; i < ATA_MAX_DEVICES; i++) {
+		dev = &ap->device[i];
 
-				/* new device discovered, configure xfermode */
-				ehc->i.flags |= ATA_EHI_SETMODE;
-			}
-		}
+		if (!(new_mask & (1 << i)))
+			continue;
+
+		ehc->i.flags |= ATA_EHI_PRINTINFO;
+		rc = ata_dev_configure(dev);
+		ehc->i.flags &= ~ATA_EHI_PRINTINFO;
+		if (rc)
+			goto err;
+
+		spin_lock_irqsave(ap->lock, flags);
+		ap->pflags |= ATA_PFLAG_SCSI_HOTPLUG;
+		spin_unlock_irqrestore(ap->lock, flags);
+
+		/* new device discovered, configure xfermode */
+		ehc->i.flags |= ATA_EHI_SETMODE;
 	}
 
-	if (rc)
-		*r_failed_dev = dev;
+	return 0;
 
-	DPRINTK("EXIT\n");
+ err:
+	*r_failed_dev = dev;
+	DPRINTK("EXIT rc=%d\n", rc);
 	return rc;
 }
 
_

Patches currently in -mm which might be from htejun@gmail.com are

git-libata-all.patch
git-libata-all-ipr-fix.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
ata-ncq-is-broken-on-maxtor-6l250s0.patch
optional-led-trigger-for-libata.patch
git-scsi-misc.patch
libata-identify-backwards-for-drive-side-cable-detection.patch
introduce-config_has_dma.patch
