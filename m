From: akpm@linux-foundation.org
Subject: - pcmcia-spot-slave-decode-flaws-for-testing.patch removed from -mm tree
Date: Wed, 04 Apr 2007 18:59:58 -0700
Message-ID: <200704050159.l351xwa3004744@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37997 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbXDECAM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, komurojun-mbn@nifty.com, mm-commits@vger.kernel.org


The patch titled
     pcmcia - spot slave decode flaws (for testing)
has been removed from the -mm tree.  Its filename was
     pcmcia-spot-slave-decode-flaws-for-testing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pcmcia - spot slave decode flaws (for testing)
From: Alan <alan@lxorguk.ukuu.org.uk>

It tries to spot when the slave is a mirror of the master and to fix up
problems that causes.

I've got two confirmations so far that this plus the "can fail set_xfer" patch
work for folks who had problems before.  Also if you are unfortunate enough to
be running something like HAL then it'll automount the same disk twice for you
and corrupt it without the fix (aint that nice...)

Tested (successfully) by Komuro <komurojun-mbn@nifty.com>.

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

origin.patch
git-libata-all.patch
libata-misc-minor-merge-fixups.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch
git-netdev-all.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
provide-dummy-devm_ioport_-if-has_ioport.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
protect-tty-drivers-list-with-tty_mutex.patch
fix-82875-pci-setup.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
