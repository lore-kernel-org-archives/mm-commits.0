From: akpm@linux-foundation.org
Subject: + drivers-scsi-fnic-fnic_scsic-clean-up.patch added to -mm tree
Date: Thu, 16 Jul 2009 15:40:52 -0700
Message-ID: <200907162240.n6GMeqCK025475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933030AbZGPWlq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Jul 2009 18:41:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, abjoglek@cisco.com


The patch titled
     drivers/scsi/fnic/fnic_scsi.c: clean up
has been added to the -mm tree.  Its filename is
     drivers-scsi-fnic-fnic_scsic-clean-up.patch

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
Subject: drivers/scsi/fnic/fnic_scsi.c: clean up
From: Roel Kluin <roel.kluin@gmail.com>

In fnic_abort_cmd() and fnic_device_reset() assign `rport' earlier to make
FNIC_SCSI_DBG() calls cleaner.

In fnic_clean_pending_aborts() `rport' is not used.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/fnic/fnic_scsi.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/fnic/fnic_scsi.c~drivers-scsi-fnic-fnic_scsic-clean-up drivers/scsi/fnic/fnic_scsi.c
--- a/drivers/scsi/fnic/fnic_scsi.c~drivers-scsi-fnic-fnic_scsic-clean-up
+++ a/drivers/scsi/fnic/fnic_scsi.c
@@ -1265,11 +1265,10 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	lp = shost_priv(sc->device->host);
 
 	fnic = lport_priv(lp);
-	FNIC_SCSI_DBG(KERN_DEBUG,
-		      fnic->lport->host,
-		      "Abort Cmd called FCID 0x%x, LUN 0x%x TAG %d\n",
-		      (starget_to_rport(scsi_target(sc->device)))->port_id,
-		      sc->device->lun, sc->request->tag);
+	rport = starget_to_rport(scsi_target(sc->device));
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			"Abort Cmd called FCID 0x%x, LUN 0x%x TAG %d\n",
+			rport->port_id, sc->device->lun, sc->request->tag);
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up)) {
 		ret = FAILED;
@@ -1318,7 +1317,6 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	 * port is up, then send abts to the remote port to terminate
 	 * the IO. Else, just locally terminate the IO in the firmware
 	 */
-	rport = starget_to_rport(scsi_target(sc->device));
 	if (fc_remote_port_chkready(rport) == 0)
 		task_req = FCPIO_ITMF_ABT_TASK;
 	else
@@ -1437,7 +1435,6 @@ static int fnic_clean_pending_aborts(str
 	unsigned long flags;
 	int ret = 0;
 	struct scsi_cmnd *sc;
-	struct fc_rport *rport;
 	struct scsi_lun fc_lun;
 	struct scsi_device *lun_dev = lr_sc->device;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
@@ -1477,7 +1474,6 @@ static int fnic_clean_pending_aborts(str
 
 		/* Now queue the abort command to firmware */
 		int_to_scsilun(sc->device->lun, &fc_lun);
-		rport = starget_to_rport(scsi_target(sc->device));
 
 		if (fnic_queue_abort_io_req(fnic, tag,
 					    FCPIO_ITMF_ABT_TASK_TERM,
@@ -1547,18 +1543,16 @@ int fnic_device_reset(struct scsi_cmnd *
 	lp = shost_priv(sc->device->host);
 
 	fnic = lport_priv(lp);
-	FNIC_SCSI_DBG(KERN_DEBUG,
-		      fnic->lport->host,
-		      "Device reset called FCID 0x%x, LUN 0x%x\n",
-		      (starget_to_rport(scsi_target(sc->device)))->port_id,
-		      sc->device->lun);
 
+	rport = starget_to_rport(scsi_target(sc->device));
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			"Device reset called FCID 0x%x, LUN 0x%x\n",
+			rport->port_id, sc->device->lun);
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
 		goto fnic_device_reset_end;
 
 	/* Check if remote port up */
-	rport = starget_to_rport(scsi_target(sc->device));
 	if (fc_remote_port_chkready(rport))
 		goto fnic_device_reset_end;
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-usb-gadget-s3c-hsotgc-missing-parentheses.patch
dynamic-debug-fix-typo.patch
drivers-gpu-drm-ttm-ttm_bo_vmc-fix-misplaced-parentheses.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
adfs-remove-redundant-test-on-unsigned.patch

