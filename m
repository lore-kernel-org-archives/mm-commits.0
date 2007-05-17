From: akpm@linux-foundation.org
Subject: - libata-fix-shutdown-warning-message-printing.patch removed from -mm tree
Date: Wed, 16 May 2007 20:47:05 -0700
Message-ID: <200705170347.l4H3l5FY016513@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758614AbXEQDtn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 23:49:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, James.Bottomley@SteelEye.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: fix shutdown warning message printing
has been removed from the -mm tree.  Its filename was
     libata-fix-shutdown-warning-message-printing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: fix shutdown warning message printing
From: Tejun Heo <htejun@gmail.com>

Unlocking ap->lock and ssleeping don't work because SCSI commands can be
issued from completion path without context.  Reimplement delayed
completion by allowing translation functions to override qc->scsidone(),
storing the original completion function to scmd->scsi_done() and
overriding qc->scsidone() with a function which schedules delayed
invocation of scmd->scsi_done().

This isn't pretty at all but all the ugly parts are thankfully contained in
the stop translation path where the compat feature is implemented.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Acked-by: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |   35 +++++++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff -puN drivers/ata/libata-scsi.c~libata-fix-shutdown-warning-message-printing drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata-fix-shutdown-warning-message-printing
+++ a/drivers/ata/libata-scsi.c
@@ -896,6 +896,23 @@ int ata_scsi_change_queue_depth(struct s
 	return queue_depth;
 }
 
+/* XXX: for ata_spindown_compat */
+static void ata_delayed_done_timerfn(unsigned long arg)
+{
+	struct scsi_cmnd *scmd = (void *)arg;
+
+	scmd->scsi_done(scmd);
+}
+
+/* XXX: for ata_spindown_compat */
+static void ata_delayed_done(struct scsi_cmnd *scmd)
+{
+	static struct timer_list timer;
+
+	setup_timer(&timer, ata_delayed_done_timerfn, (unsigned long)scmd);
+	mod_timer(&timer, jiffies + 5 * HZ);
+}
+
 /**
  *	ata_scsi_start_stop_xlat - Translate SCSI START STOP UNIT command
  *	@qc: Storage for translated ATA taskfile
@@ -955,19 +972,21 @@ static unsigned int ata_scsi_start_stop_
 		if (ata_spindown_compat &&
 		    (system_state == SYSTEM_HALT ||
 		     system_state == SYSTEM_POWER_OFF)) {
-			static int warned = 0;
+			static unsigned long warned = 0;
 
-			if (!warned) {
-				spin_unlock_irq(qc->ap->lock);
+			if (!test_and_set_bit(0, &warned)) {
 				ata_dev_printk(qc->dev, KERN_WARNING,
 					"DISK MIGHT NOT BE SPUN DOWN PROPERLY. "
 					"UPDATE SHUTDOWN UTILITY\n");
 				ata_dev_printk(qc->dev, KERN_WARNING,
 					"For more info, visit "
 					"http://linux-ata.org/shutdown.html\n");
-				warned = 1;
-				ssleep(5);
-				spin_lock_irq(qc->ap->lock);
+
+				/* ->scsi_done is not used, use it for
+				 * delayed completion.
+				 */
+				scmd->scsi_done = qc->scsidone;
+				qc->scsidone = ata_delayed_done;
 			}
 			scmd->result = SAM_STAT_GOOD;
 			return 1;
@@ -1491,14 +1510,14 @@ static int ata_scsi_translate(struct ata
 
 early_finish:
         ata_qc_free(qc);
-	done(cmd);
+	qc->scsidone(cmd);
 	DPRINTK("EXIT - early finish (good or error)\n");
 	return 0;
 
 err_did:
 	ata_qc_free(qc);
 	cmd->result = (DID_ERROR << 16);
-	done(cmd);
+	qc->scsidone(cmd);
 err_mem:
 	DPRINTK("EXIT - internal\n");
 	return 0;
_

Patches currently in -mm which might be from htejun@gmail.com are

fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-libata-all.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
optional-led-trigger-for-libata.patch
drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-build-failure-for-drivers-ata-pata_sccc.patch
libata-implement-ata_wait_after_reset.patch
pci-quirks-disable-msi-on-rs400-200-and-rs480.patch
