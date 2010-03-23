From: akpm@linux-foundation.org
Subject: + bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr.patch added to -mm tree
Date: Mon, 22 Mar 2010 23:48:04 -0400
Message-ID: <201003230648.o2N6mt2X019062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088Ab0CWGtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 02:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, huangj@Brocade.COM


The patch titled
     bfa: wrong fcport H2I message tested in bfa_fcport_isr()
has been added to the -mm tree.  Its filename is
     bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr.patch

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
Subject: bfa: wrong fcport H2I message tested in bfa_fcport_isr()
From: Roel Kluin <roel.kluin@gmail.com>

It appears that the wrong fcport H2I message was tested

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Jing Huang <huangj@Brocade.COM>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bfa/bfa_fcport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/bfa/bfa_fcport.c~bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr drivers/scsi/bfa/bfa_fcport.c
--- a/drivers/scsi/bfa/bfa_fcport.c~bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr
+++ a/drivers/scsi/bfa/bfa_fcport.c
@@ -1281,7 +1281,7 @@ bfa_fcport_isr(struct bfa_s *bfa, struct
 		break;
 
 	case BFI_FCPORT_I2H_DISABLE_RSP:
-		if (fcport->msgtag == i2hmsg.penable_rsp->msgtag)
+		if (fcport->msgtag == i2hmsg.pdisable_rsp->msgtag)
 			bfa_sm_send_event(fcport, BFA_FCPORT_SM_FWRSP);
 		break;
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
serial-two-branches-the-same-in-timbuart_set_mctrl.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
lpfc-positive-error-return-into-negative.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

