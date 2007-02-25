From: akpm@linux-foundation.org
Subject: + pcmcia-spot-slave-decode-flaws-for-testing.patch added to -mm tree
Date: Sun, 25 Feb 2007 04:54:48 -0800
Message-ID: <200702251254.l1PCsoL7029645@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35464 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964886AbXBYMzH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 07:55:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pcmcia - spot slave decode flaws (for testing)
has been added to the -mm tree.  Its filename is
     pcmcia-spot-slave-decode-flaws-for-testing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pcmcia - spot slave decode flaws (for testing)
From: Alan <alan@lxorguk.ukuu.org.uk>

If you've got a CF adapter or PCMCIA disc which shows up twice in libata
pata_pcmcia can you try this patch on top of the updates posted.  It tries
to spot when the slave is a mirror of the master and to fix up problems
that causes.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_pcmcia.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff -puN drivers/ata/pata_pcmcia.c~pcmcia-spot-slave-decode-flaws-for-testing drivers/ata/pata_pcmcia.c
--- a/drivers/ata/pata_pcmcia.c~pcmcia-spot-slave-decode-flaws-for-testing
+++ a/drivers/ata/pata_pcmcia.c
@@ -54,6 +54,39 @@ struct ata_pcmcia_info {
 	dev_node_t	node;
 };
 
+/**
+ *	pcmcia_set_mode	-	PCMCIA specific mode setup
+ *	@ap: Port
+ *	@r_failed_dev: Return pointer for failed device
+ *
+ *	Perform the tuning and setup of the devices and timings, which
+ *	for PCMCIA is the same as any other controller. We wrap it however
+ *	as we need to spot hardware with incorrect or missing master/slave
+ *	decode, which alas is embarrassingly common in the PC world
+ */
+
+static int pcmcia_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev)
+{
+	struct ata_device *master = &ap->device[0];
+	struct ata_device *slave = &ap->device[1];
+
+	if (!ata_dev_enabled(master) || !ata_dev_enabled(slave))
+		return ata_do_set_mode(ap, r_failed_dev);
+
+	if (memcmp(master->id + ATA_ID_FW_REV,  slave->id + ATA_ID_FW_REV,
+			   ATA_ID_FW_REV_LEN + ATA_ID_PROD_LEN) == 0)
+	{
+		/* Suspicious match, but could be two cards from
+		   the same vendor - check serial */
+		if (memcmp(master->id + ATA_ID_SERNO, slave->id + ATA_ID_SERNO,
+			   ATA_ID_SERNO_LEN) == 0 && master->id[ATA_ID_SERNO] >> 8) {
+			ata_dev_printk(slave, KERN_WARNING, "is a ghost device, ignoring.\n");
+			ata_dev_disable(slave);
+		}
+	}
+	return ata_do_set_mode(ap, r_failed_dev);
+}
+
 static struct scsi_host_template pcmcia_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -73,6 +106,7 @@ static struct scsi_host_template pcmcia_
 };
 
 static struct ata_port_operations pcmcia_port_ops = {
+	.set_mode	= pcmcia_set_mode,
 	.port_disable	= ata_port_disable,
 	.tf_load	= ata_tf_load,
 	.tf_read	= ata_tf_read,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
add-id_to_dma_mode-function-for-printing-dma-modes.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
libata-use-new-id_to_dma_mode-function-to-tidy-reporting.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
adjust-legacy-ide-resource-setting-v2.patch
ide-remove-a-ton-of-pointless-undef-really_slow_io.patch
net-remove-a-collection-of-unneeded-undef-really_slow_io.patch
resend-iphase-64bit-cleanup.patch
serial-serial_txx9-driver-update.patch
serial-serial_txx9-driver-update-fix.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
