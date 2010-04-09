From: akpm@linux-foundation.org
Subject: [merged] mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch removed from -mm tree
Date: Fri, 09 Apr 2010 10:52:51 -0400
Message-ID: <201004091754.o39HsLCZ002187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755117Ab0DIRy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 13:54:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, Eric.moore@lsi.com, James.Bottomley@suse.de, kashyap.desai@lsi.com, mm-commits@vger.kernel.org


The patch titled
     mpt2sas: fix &&/|| confusion in _scsih_sas_device_status_change_event()
has been removed from the -mm tree.  Its filename was
     mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mpt2sas: fix &&/|| confusion in _scsih_sas_device_status_change_event()
From: Roel Kluin <roel.kluin@gmail.com>

Even if the ReasonCode is not INTERNAL_DEVICE_RESET nor CMP_DEVICE_RESET
this still evaluates to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Kashyap Desai <kashyap.desai@lsi.com>
Acked-by: Eric Moore <Eric.moore@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/mpt2sas/mpt2sas_scsih.c~mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c~mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event
+++ a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4520,10 +4520,10 @@ _scsih_sas_device_status_change_event(st
 		     event_data);
 #endif
 
-	if (!(event_data->ReasonCode ==
-	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
-	   event_data->ReasonCode ==
-	    MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET))
+	if (event_data->ReasonCode !=
+	      MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
+	    event_data->ReasonCode !=
+	      MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET)
 		return;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
serial-two-branches-the-same-in-timbuart_set_mctrl.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
lpfc-positive-error-return-into-negative.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr.patch
vt6655-cgi-csi-confusion-in-device_ioctl.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

