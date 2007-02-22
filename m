From: akpm@linux-foundation.org
Subject: + expose-set_mode-method-so-it-can-be-wrapped.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:31:07 -0800
Message-ID: <200702220031.l1M0V7IW031323@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59517 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965081AbXBVAb2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:31:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     pata: expose set_mode method so it can be wrapped
has been added to the -mm tree.  Its filename is
     expose-set_mode-method-so-it-can-be-wrapped.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata: expose set_mode method so it can be wrapped
From: Alan <alan@lxorguk.ukuu.org.uk>

This splits set_mode into do_set_mode and the wrapper so that a driver can
call the standard method inside its own.  This in theory also obsoletes
->post_set_mode().

Needed for ACPI driver.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   37 +++++++++++++++++++++++++++++-------
 include/linux/libata.h    |    1 
 2 files changed, 31 insertions(+), 7 deletions(-)

diff -puN drivers/ata/libata-core.c~expose-set_mode-method-so-it-can-be-wrapped drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~expose-set_mode-method-so-it-can-be-wrapped
+++ a/drivers/ata/libata-core.c
@@ -2462,12 +2462,13 @@ static int ata_dev_set_mode(struct ata_d
 }
 
 /**
- *	ata_set_mode - Program timings and issue SET FEATURES - XFER
+ *	ata_do_set_mode - Program timings and issue SET FEATURES - XFER
  *	@ap: port on which timings will be programmed
  *	@r_failed_dev: out paramter for failed device
  *
- *	Set ATA device disk transfer mode (PIO3, UDMA6, etc.).  If
- *	ata_set_mode() fails, pointer to the failing device is
+ *	Standard implementation of the function used to tune and set
+ *	ATA device disk transfer mode (PIO3, UDMA6, etc.).  If
+ *	ata_dev_set_mode() fails, pointer to the failing device is
  *	returned in @r_failed_dev.
  *
  *	LOCKING:
@@ -2476,14 +2477,12 @@ static int ata_dev_set_mode(struct ata_d
  *	RETURNS:
  *	0 on success, negative errno otherwise
  */
-int ata_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev)
+
+int ata_do_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev)
 {
 	struct ata_device *dev;
 	int i, rc = 0, used_dma = 0, found = 0;
 
-	/* has private set_mode? */
-	if (ap->ops->set_mode)
-		return ap->ops->set_mode(ap, r_failed_dev);
 
 	/* step 1: calculate xfer_mask */
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
@@ -2569,6 +2568,29 @@ int ata_set_mode(struct ata_port *ap, st
 }
 
 /**
+ *	ata_set_mode - Program timings and issue SET FEATURES - XFER
+ *	@ap: port on which timings will be programmed
+ *	@r_failed_dev: out paramter for failed device
+ *
+ *	Set ATA device disk transfer mode (PIO3, UDMA6, etc.).  If
+ *	ata_set_mode() fails, pointer to the failing device is
+ *	returned in @r_failed_dev.
+ *
+ *	LOCKING:
+ *	PCI/etc. bus probe sem.
+ *
+ *	RETURNS:
+ *	0 on success, negative errno otherwise
+ */
+int ata_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev)
+{
+	/* has private set_mode? */
+	if (ap->ops->set_mode)
+		return ap->ops->set_mode(ap, r_failed_dev);
+	return ata_do_set_mode(ap, r_failed_dev);
+}
+
+/**
  *	ata_tf_to_host - issue ATA taskfile to host controller
  *	@ap: port to which command is being issued
  *	@tf: ATA taskfile register set
@@ -6310,6 +6332,7 @@ EXPORT_SYMBOL_GPL(ata_altstatus);
 EXPORT_SYMBOL_GPL(ata_exec_command);
 EXPORT_SYMBOL_GPL(ata_port_start);
 EXPORT_SYMBOL_GPL(ata_interrupt);
+EXPORT_SYMBOL_GPL(ata_do_set_mode);
 EXPORT_SYMBOL_GPL(ata_data_xfer);
 EXPORT_SYMBOL_GPL(ata_data_xfer_noirq);
 EXPORT_SYMBOL_GPL(ata_qc_prep);
diff -puN include/linux/libata.h~expose-set_mode-method-so-it-can-be-wrapped include/linux/libata.h
--- a/include/linux/libata.h~expose-set_mode-method-so-it-can-be-wrapped
+++ a/include/linux/libata.h
@@ -823,6 +823,7 @@ extern void ata_scsi_slave_destroy(struc
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
+extern int ata_do_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev);
 extern u8 ata_irq_on(struct ata_port *ap);
 extern u8 ata_dummy_irq_on(struct ata_port *ap);
 extern u8 ata_irq_ack(struct ata_port *ap, unsigned int chk_drq);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
add-id_to_dma_mode-function-for-printing-dma-modes.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
libata-use-new-id_to_dma_mode-function-to-tidy-reporting.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
adjust-legacy-ide-resource-setting-v2.patch
resend-iphase-64bit-cleanup.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
