Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9B122155E
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 22:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740523203; cv=none; b=oVwIz+AUGURYPgdb4dO3QcJ404Ekjp5yxpvQrt7cwhtq0i4Fen8G3OjDmXK5Z4kc8GA+nomwsays9sLYw5AxgeSITiwuTfGwVy/yS3cZfqfkNfKUudH92o2vLi33xljzrUdI4slGiONKBhq2Wj266h1eC+EJE1kjAv1WfP4ZBXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740523203; c=relaxed/simple;
	bh=3YtqdFybG2GNelwo93H2U9uBLcZgHLiKBuKEgeKrBUA=;
	h=Date:To:From:Subject:Message-Id; b=r9zABrSFaIYUyC7Zts5zuUMRB5OQG8m/mmKgz117wmjDYeJoafVaxeLjjZSMdMgbsPTXXccY8qOrWgL3nj2O3niEcrSe+lyFp85A4NAUXk9jSqSJUkzIlBZFTFspFmdAgwp0k4tE56pJJjQ6JU5VJsSQVTyzNw87S5B9yZHt8IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LHLQ2RMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LHLQ2RMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72001C4CEDD;
	Tue, 25 Feb 2025 22:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740523202;
	bh=3YtqdFybG2GNelwo93H2U9uBLcZgHLiKBuKEgeKrBUA=;
	h=Date:To:From:Subject:From;
	b=LHLQ2RMl8/Y0w33zaTtwYoO8Q9W7Gc7c0HpCZeTMQxc5fMGnQH/aaAGoYudFJ4sKn
	 0FtEPalw+oQ1yuQq+wQLJDNs6OZDXkIfxLr3YQQ80pf8SJx4CtdgM++mysue6MPvmN
	 Yus+CimlbYZE56SYpTsyfm7Ar6Pe5Q6HzkgwOaag=
Date: Tue, 25 Feb 2025 14:40:01 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tiwai@suse.de,tiwai@suse.com,sre@kernel.org,Shyam-sundar.S-k@amd.com,shawnguo@kernel.org,s.hauer@pengutronix.de,selvin.xavier@broadcom.com,sagi@grimberg.me,perex@perex.cz,ogabbay@kernel.org,nicolas.palix@imag.fr,mkl@pengutronix.de,martin.petersen@oracle.com,leon@kernel.org,kbusch@kernel.org,kalesh-anakkur.purayil@broadcom.com,julia.lawall@inria.fr,josef@toxicpanda.com,jgg@ziepe.ca,james.smart@broadcom.com,james.bottomley@HansenPartnership.com,ilpo.jarvinen@linux.intel.com,idryomov@gmail.com,hmh@hmh.eng.br,hdegoede@redhat.com,hch@lst.de,frank.li@nxp.com,festevam@gmail.com,dsterba@suse.com,dongsheng.yang@easystack.cn,dlemoal@kernel.org,djwong@kernel.org,dick.kennedy@broadcom.com,cmaiolino@redhat.com,clm@fb.com,cem@kernel.org,cassel@kernel.org,broonie@kernel.org,axboe@kernel.dk,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scsi-lpfc-convert-timeouts-to-secs_to_jiffies.patch added to mm-nonmm-unstable branch
Message-Id: <20250225224002.72001C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scsi: lpfc: convert timeouts to secs_to_jiffies()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scsi-lpfc-convert-timeouts-to-secs_to_jiffies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scsi-lpfc-convert-timeouts-to-secs_to_jiffies.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: scsi: lpfc: convert timeouts to secs_to_jiffies()
Date: Tue, 25 Feb 2025 20:17:16 +0000

Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
secs_to_jiffies().  As the value here is a multiple of 1000, use
secs_to_jiffies() instead of msecs_to_jiffies() to avoid the
multiplication

This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
the following Coccinelle rules:

@depends on patch@
expression E;
@@

-msecs_to_jiffies(E * 1000)
+secs_to_jiffies(E)

-msecs_to_jiffies(E * MSEC_PER_SEC)
+secs_to_jiffies(E)

While here, convert some timeouts that are denominated in seconds
manually.

Link: https://lkml.kernel.org/r/20250225-converge-secs-to-jiffies-part-two-v3-2-a43967e36c88@linux.microsoft.com
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Maol <dlemoal@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Frank Li <frank.li@nxp.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Niklas Cassel <cassel@kernel.org>
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Selvin Thyparampil Xavier <selvin.xavier@broadcom.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Shyam-sundar S-k <Shyam-sundar.S-k@amd.com>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc.h         |    3 --
 drivers/scsi/lpfc/lpfc_els.c     |   11 +++----
 drivers/scsi/lpfc/lpfc_hbadisc.c |    2 -
 drivers/scsi/lpfc/lpfc_init.c    |   10 +++----
 drivers/scsi/lpfc/lpfc_scsi.c    |   12 +++-----
 drivers/scsi/lpfc/lpfc_sli.c     |   41 +++++++++++------------------
 drivers/scsi/lpfc/lpfc_vport.c   |    2 -
 7 files changed, 34 insertions(+), 47 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_els.c~scsi-lpfc-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/scsi/lpfc/lpfc_els.c
@@ -8045,8 +8045,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 			if (test_bit(FC_DISC_TMO, &vport->fc_flag)) {
 				tmo = ((phba->fc_ratov * 3) + 3);
 				mod_timer(&vport->fc_disctmo,
-					  jiffies +
-					  msecs_to_jiffies(1000 * tmo));
+					  jiffies + secs_to_jiffies(tmo));
 			}
 			return 0;
 		}
@@ -8081,7 +8080,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 		if (test_bit(FC_DISC_TMO, &vport->fc_flag)) {
 			tmo = ((phba->fc_ratov * 3) + 3);
 			mod_timer(&vport->fc_disctmo,
-				  jiffies + msecs_to_jiffies(1000 * tmo));
+				  jiffies + secs_to_jiffies(tmo));
 		}
 		if ((rscn_cnt < FC_MAX_HOLD_RSCN) &&
 		    !test_bit(FC_RSCN_DISCOVERY, &vport->fc_flag)) {
@@ -9511,7 +9510,7 @@ lpfc_els_timeout_handler(struct lpfc_vpo
 	if (!list_empty(&pring->txcmplq))
 		if (!test_bit(FC_UNLOADING, &phba->pport->load_flag))
 			mod_timer(&vport->els_tmofunc,
-				  jiffies + msecs_to_jiffies(1000 * timeout));
+				  jiffies + secs_to_jiffies(timeout));
 }
 
 /**
@@ -10899,7 +10898,7 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
 				 "3334 Delay fc port discovery for %d secs\n",
 				 phba->fc_ratov);
 		mod_timer(&vport->delayed_disc_tmo,
-			jiffies + msecs_to_jiffies(1000 * phba->fc_ratov));
+			jiffies + secs_to_jiffies(phba->fc_ratov));
 		return;
 	}
 
@@ -11156,7 +11155,7 @@ lpfc_retry_pport_discovery(struct lpfc_h
 	if (!ndlp)
 		return;
 
-	mod_timer(&ndlp->nlp_delayfunc, jiffies + msecs_to_jiffies(1000));
+	mod_timer(&ndlp->nlp_delayfunc, jiffies + secs_to_jiffies(1));
 	set_bit(NLP_DELAY_TMO, &ndlp->nlp_flag);
 	ndlp->nlp_last_elscmd = ELS_CMD_FLOGI;
 	phba->pport->port_state = LPFC_FLOGI;
--- a/drivers/scsi/lpfc/lpfc.h~scsi-lpfc-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/scsi/lpfc/lpfc.h
@@ -74,8 +74,7 @@ struct lpfc_sli2_slim;
  * queue depths when there are driver resource error or Firmware
  * resource error.
  */
-/* 1 Second */
-#define QUEUE_RAMP_DOWN_INTERVAL	(msecs_to_jiffies(1000 * 1))
+#define QUEUE_RAMP_DOWN_INTERVAL	(secs_to_jiffies(1))
 
 /* Number of exchanges reserved for discovery to complete */
 #define LPFC_DISC_IOCB_BUFF_COUNT 20
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c~scsi-lpfc-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4973,7 +4973,7 @@ lpfc_set_disctmo(struct lpfc_vport *vpor
 			tmo, vport->port_state, vport->fc_flag);
 	}
 
-	mod_timer(&vport->fc_disctmo, jiffies + msecs_to_jiffies(1000 * tmo));
+	mod_timer(&vport->fc_disctmo, jiffies + secs_to_jiffies(tmo));
 	set_bit(FC_DISC_TMO, &vport->fc_flag);
 
 	/* Start Discovery Timer state <hba_state> */
--- a/drivers/scsi/lpfc/lpfc_init.c~scsi-lpfc-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -595,7 +595,7 @@ lpfc_config_port_post(struct lpfc_hba *p
 	/* Set up ring-0 (ELS) timer */
 	timeout = phba->fc_ratov * 2;
 	mod_timer(&vport->els_tmofunc,
-		  jiffies + msecs_to_jiffies(1000 * timeout));
+		  jiffies + secs_to_jiffies(timeout));
 	/* Set up heart beat (HB) timer */
 	mod_timer(&phba->hb_tmofunc,
 		  jiffies + secs_to_jiffies(LPFC_HB_MBOX_INTERVAL));
@@ -604,7 +604,7 @@ lpfc_config_port_post(struct lpfc_hba *p
 	phba->last_completion_time = jiffies;
 	/* Set up error attention (ERATT) polling timer */
 	mod_timer(&phba->eratt_poll,
-		  jiffies + msecs_to_jiffies(1000 * phba->eratt_poll_interval));
+		  jiffies + secs_to_jiffies(phba->eratt_poll_interval));
 
 	if (test_bit(LINK_DISABLED, &phba->hba_flag)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -3361,8 +3361,8 @@ lpfc_block_mgmt_io(struct lpfc_hba *phba
 		/* Determine how long we might wait for the active mailbox
 		 * command to be gracefully completed by firmware.
 		 */
-		timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba,
-				phba->sli.mbox_active) * 1000) + jiffies;
+		timeout = secs_to_jiffies(lpfc_mbox_tmo_val(phba,
+				phba->sli.mbox_active)) + jiffies;
 	}
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 
@@ -6909,7 +6909,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba
 			 * re-instantiate the Vlink using FDISC.
 			 */
 			mod_timer(&ndlp->nlp_delayfunc,
-				  jiffies + msecs_to_jiffies(1000));
+				  jiffies + secs_to_jiffies(1));
 			set_bit(NLP_DELAY_TMO, &ndlp->nlp_flag);
 			ndlp->nlp_last_elscmd = ELS_CMD_FDISC;
 			vport->port_state = LPFC_FDISC;
--- a/drivers/scsi/lpfc/lpfc_scsi.c~scsi-lpfc-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5645,9 +5645,8 @@ wait_for_cmpl:
 	 * cmd_flag is set to LPFC_DRIVER_ABORTED before we wait
 	 * for abort to complete.
 	 */
-	wait_event_timeout(waitq,
-			  (lpfc_cmd->pCmd != cmnd),
-			   msecs_to_jiffies(2*vport->cfg_devloss_tmo*1000));
+	wait_event_timeout(waitq, (lpfc_cmd->pCmd != cmnd),
+			   secs_to_jiffies(2*vport->cfg_devloss_tmo));
 
 	spin_lock(&lpfc_cmd->buf_lock);
 
@@ -5911,7 +5910,7 @@ lpfc_chk_tgt_mapped(struct lpfc_vport *v
 	 * If target is not in a MAPPED state, delay until
 	 * target is rediscovered or devloss timeout expires.
 	 */
-	later = msecs_to_jiffies(2 * vport->cfg_devloss_tmo * 1000) + jiffies;
+	later = secs_to_jiffies(2 * vport->cfg_devloss_tmo) + jiffies;
 	while (time_after(later, jiffies)) {
 		if (!pnode)
 			return FAILED;
@@ -5957,7 +5956,7 @@ lpfc_reset_flush_io_context(struct lpfc_
 		lpfc_sli_abort_taskmgmt(vport,
 					&phba->sli.sli3_ring[LPFC_FCP_RING],
 					tgt_id, lun_id, context);
-	later = msecs_to_jiffies(2 * vport->cfg_devloss_tmo * 1000) + jiffies;
+	later = secs_to_jiffies(2 * vport->cfg_devloss_tmo) + jiffies;
 	while (time_after(later, jiffies) && cnt) {
 		schedule_timeout_uninterruptible(msecs_to_jiffies(20));
 		cnt = lpfc_sli_sum_iocb(vport, tgt_id, lun_id, context);
@@ -6137,8 +6136,7 @@ lpfc_target_reset_handler(struct scsi_cm
 			wait_event_timeout(waitq,
 					   !test_bit(NLP_WAIT_FOR_LOGO,
 						     &pnode->save_flags),
-					   msecs_to_jiffies(dev_loss_tmo *
-							    1000));
+					   secs_to_jiffies(dev_loss_tmo));
 
 			if (test_and_clear_bit(NLP_WAIT_FOR_LOGO,
 					       &pnode->save_flags))
--- a/drivers/scsi/lpfc/lpfc_sli.c~scsi-lpfc-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/scsi/lpfc/lpfc_sli.c
@@ -1025,7 +1025,7 @@ lpfc_handle_rrq_active(struct lpfc_hba *
 	LIST_HEAD(send_rrq);
 
 	clear_bit(HBA_RRQ_ACTIVE, &phba->hba_flag);
-	next_time = jiffies + msecs_to_jiffies(1000 * (phba->fc_ratov + 1));
+	next_time = jiffies + secs_to_jiffies(phba->fc_ratov + 1);
 	spin_lock_irqsave(&phba->rrq_list_lock, iflags);
 	list_for_each_entry_safe(rrq, nextrrq,
 				 &phba->active_rrq_list, list) {
@@ -1208,8 +1208,7 @@ lpfc_set_rrq_active(struct lpfc_hba *phb
 	else
 		rrq->send_rrq = 0;
 	rrq->xritag = xritag;
-	rrq->rrq_stop_time = jiffies +
-				msecs_to_jiffies(1000 * (phba->fc_ratov + 1));
+	rrq->rrq_stop_time = jiffies + secs_to_jiffies(phba->fc_ratov + 1);
 	rrq->nlp_DID = ndlp->nlp_DID;
 	rrq->vport = ndlp->vport;
 	rrq->rxid = rxid;
@@ -1736,8 +1735,7 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba
 		BUG_ON(!piocb->vport);
 		if (!test_bit(FC_UNLOADING, &piocb->vport->load_flag))
 			mod_timer(&piocb->vport->els_tmofunc,
-				  jiffies +
-				  msecs_to_jiffies(1000 * (phba->fc_ratov << 1)));
+				  jiffies + secs_to_jiffies(phba->fc_ratov << 1));
 	}
 
 	return 0;
@@ -3956,8 +3954,7 @@ void lpfc_poll_eratt(struct timer_list *
 	else
 		/* Restart the timer for next eratt poll */
 		mod_timer(&phba->eratt_poll,
-			  jiffies +
-			  msecs_to_jiffies(1000 * phba->eratt_poll_interval));
+			  jiffies + secs_to_jiffies(phba->eratt_poll_interval);
 	return;
 }
 
@@ -9008,7 +9005,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 
 	/* Start the ELS watchdog timer */
 	mod_timer(&vport->els_tmofunc,
-		  jiffies + msecs_to_jiffies(1000 * (phba->fc_ratov * 2)));
+			jiffies + secs_to_jiffies(phba->fc_ratov * 2));
 
 	/* Start heart beat timer */
 	mod_timer(&phba->hb_tmofunc,
@@ -9027,7 +9024,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 
 	/* Start error attention (ERATT) polling timer */
 	mod_timer(&phba->eratt_poll,
-		  jiffies + msecs_to_jiffies(1000 * phba->eratt_poll_interval));
+		  jiffies + secs_to_jiffies(phba->eratt_poll_interval));
 
 	/*
 	 * The port is ready, set the host's link state to LINK_DOWN
@@ -9504,8 +9501,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 			goto out_not_finished;
 		}
 		/* timeout active mbox command */
-		timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, pmbox) *
-					   1000);
+		timeout = secs_to_jiffies(lpfc_mbox_tmo_val(phba, pmbox));
 		mod_timer(&psli->mbox_tmo, jiffies + timeout);
 	}
 
@@ -9629,8 +9625,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 						       drvr_flag);
 			goto out_not_finished;
 		}
-		timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, pmbox) *
-							1000) + jiffies;
+		timeout = secs_to_jiffies(lpfc_mbox_tmo_val(phba, pmbox)) + jiffies;
 		i = 0;
 		/* Wait for command to complete */
 		while (((word0 & OWN_CHIP) == OWN_CHIP) ||
@@ -9756,9 +9751,8 @@ lpfc_sli4_async_mbox_block(struct lpfc_h
 	 * command to be gracefully completed by firmware.
 	 */
 	if (phba->sli.mbox_active)
-		timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba,
-						phba->sli.mbox_active) *
-						1000) + jiffies;
+		timeout = secs_to_jiffies(lpfc_mbox_tmo_val(phba,
+						phba->sli.mbox_active)) + jiffies;
 	spin_unlock_irq(&phba->hbalock);
 
 	/* Make sure the mailbox is really active */
@@ -9881,8 +9875,7 @@ lpfc_sli4_wait_bmbx_ready(struct lpfc_hb
 		}
 	}
 
-	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, mboxq)
-				   * 1000) + jiffies;
+	timeout = secs_to_jiffies(lpfc_mbox_tmo_val(phba, mboxq)) + jiffies;
 
 	do {
 		bmbx_reg.word0 = readl(phba->sli4_hba.BMBXregaddr);
@@ -10230,7 +10223,7 @@ lpfc_sli4_post_async_mbox(struct lpfc_hb
 
 	/* Start timer for the mbox_tmo and log some mailbox post messages */
 	mod_timer(&psli->mbox_tmo, (jiffies +
-		  msecs_to_jiffies(1000 * lpfc_mbox_tmo_val(phba, mboxq))));
+		  secs_to_jiffies(lpfc_mbox_tmo_val(phba, mboxq))));
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
 			"(%d):0355 Mailbox cmd x%x (x%x/x%x) issue Data: "
@@ -13159,7 +13152,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 	retval = lpfc_sli_issue_iocb(phba, ring_number, piocb,
 				     SLI_IOCB_RET_IOCB);
 	if (retval == IOCB_SUCCESS) {
-		timeout_req = msecs_to_jiffies(timeout * 1000);
+		timeout_req = secs_to_jiffies(timeout);
 		timeleft = wait_event_timeout(done_q,
 				lpfc_chk_iocb_flg(phba, piocb, LPFC_IO_WAKE),
 				timeout_req);
@@ -13275,8 +13268,7 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 	/* now issue the command */
 	retval = lpfc_sli_issue_mbox(phba, pmboxq, MBX_NOWAIT);
 	if (retval == MBX_BUSY || retval == MBX_SUCCESS) {
-		wait_for_completion_timeout(&mbox_done,
-					    msecs_to_jiffies(timeout * 1000));
+		wait_for_completion_timeout(&mbox_done, secs_to_jiffies(timeout));
 
 		spin_lock_irqsave(&phba->hbalock, flag);
 		pmboxq->ctx_u.mbox_wait = NULL;
@@ -13336,9 +13328,8 @@ lpfc_sli_mbox_sys_shutdown(struct lpfc_h
 		 * command to be gracefully completed by firmware.
 		 */
 		if (phba->sli.mbox_active)
-			timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba,
-						phba->sli.mbox_active) *
-						1000) + jiffies;
+			timeout = secs_to_jiffies(lpfc_mbox_tmo_val(phba,
+						phba->sli.mbox_active)) + jiffies;
 		spin_unlock_irq(&phba->hbalock);
 
 		/* Enable softirqs again, done with phba->hbalock */
--- a/drivers/scsi/lpfc/lpfc_vport.c~scsi-lpfc-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/scsi/lpfc/lpfc_vport.c
@@ -246,7 +246,7 @@ static void lpfc_discovery_wait(struct l
 	 * fabric RA_TOV value and dev_loss tmo.  The driver's
 	 * devloss_tmo is 10 giving this loop a 3x multiplier minimally.
 	 */
-	wait_time_max = msecs_to_jiffies(((phba->fc_ratov * 3) + 3) * 1000);
+	wait_time_max = secs_to_jiffies((phba->fc_ratov * 3) + 3);
 	wait_time_max += jiffies;
 	start_time = jiffies;
 	while (time_before(jiffies, wait_time_max)) {
_

Patches currently in -mm which might be from eahariha@linux.microsoft.com are

coccinelle-misc-secs_to_jiffies-patch-expressions-too.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies.patch
accel-habanalabs-convert-timeouts-to-secs_to_jiffies.patch
alsa-ac97-convert-timeouts-to-secs_to_jiffies.patch
btrfs-convert-timeouts-to-secs_to_jiffies.patch
libceph-convert-timeouts-to-secs_to_jiffies.patch
ata-libata-zpodd-convert-timeouts-to-secs_to_jiffies.patch
xfs-convert-timeouts-to-secs_to_jiffies.patch
power-supply-da9030-convert-timeouts-to-secs_to_jiffies.patch
nvme-convert-timeouts-to-secs_to_jiffies.patch
spi-spi-fsl-lpspi-convert-timeouts-to-secs_to_jiffies.patch
spi-spi-imx-convert-timeouts-to-secs_to_jiffies.patch
platform-x86-amd-pmf-convert-timeouts-to-secs_to_jiffies.patch
platform-x86-thinkpad_acpi-convert-timeouts-to-secs_to_jiffies.patch
rdma-bnxt_re-convert-timeouts-to-secs_to_jiffies.patch

