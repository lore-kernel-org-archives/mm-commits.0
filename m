From: akpm@linux-foundation.org
Subject: - sata_nv-dont-use-legacy-dma-in-adma-mode-v3.patch removed from -mm tree
Date: Tue, 04 Dec 2007 14:11:44 -0800
Message-ID: <200712042211.lB4MBig0008018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948AbXLDWM1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 17:12:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sata_nv: don't use legacy DMA in ADMA mode
has been removed from the -mm tree.  Its filename was
     sata_nv-dont-use-legacy-dma-in-adma-mode-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_nv: don't use legacy DMA in ADMA mode
From: Robert Hancock <hancockr@shaw.ca>

We need to run any DMA command with result taskfile requested in ADMA mode
when the port is in ADMA mode, otherwise it may try to use the legacy DMA
engine in ADMA mode which is not allowed.  Enforce this with BUG_ON() since
data corruption could potentially result if this happened.  Also, fail any
attempt to try and issue NCQ commands with result taskfile requested, since
the hardware doesn't allow this.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff -puN drivers/ata/sata_nv.c~sata_nv-dont-use-legacy-dma-in-adma-mode-v3 drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-dont-use-legacy-dma-in-adma-mode-v3
+++ a/drivers/ata/sata_nv.c
@@ -791,11 +791,13 @@ static int nv_adma_check_atapi_dma(struc
 
 static void nv_adma_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
-	/* Since commands where a result TF is requested are not
-	   executed in ADMA mode, the only time this function will be called
-	   in ADMA mode will be if a command fails. In this case we
-	   don't care about going into register mode with ADMA commands
-	   pending, as the commands will all shortly be aborted anyway. */
+	/* Other than when internal or pass-through commands are executed,
+	   the only time this function will be called in ADMA mode will be
+	   if a command fails. In the failure case we don't care about going
+	   into register mode with ADMA commands pending, as the commands will
+	   all shortly be aborted anyway. We assume that NCQ commands are not
+	   issued via passthrough, which is the only way that switching into
+	   ADMA mode could abort outstanding commands. */
 	nv_adma_register_mode(ap);
 
 	ata_tf_read(ap, tf);
@@ -1359,11 +1361,9 @@ static int nv_adma_use_reg_mode(struct a
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 
 	/* ADMA engine can only be used for non-ATAPI DMA commands,
-	   or interrupt-driven no-data commands, where a result taskfile
-	   is not required. */
+	   or interrupt-driven no-data commands. */
 	if ((pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
-	   (qc->tf.flags & ATA_TFLAG_POLLING) ||
-	   (qc->flags & ATA_QCFLAG_RESULT_TF))
+	   (qc->tf.flags & ATA_TFLAG_POLLING))
 		return 1;
 
 	if ((qc->flags & ATA_QCFLAG_DMAMAP) ||
@@ -1381,6 +1381,8 @@ static void nv_adma_qc_prep(struct ata_q
 		       NV_CPB_CTL_IEN;
 
 	if (nv_adma_use_reg_mode(qc)) {
+		BUG_ON(!(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) &&
+			(qc->flags & ATA_QCFLAG_DMAMAP));
 		nv_adma_register_mode(qc->ap);
 		ata_qc_prep(qc);
 		return;
@@ -1425,9 +1427,21 @@ static unsigned int nv_adma_qc_issue(str
 
 	VPRINTK("ENTER\n");
 
+	/* We can't handle result taskfile with NCQ commands, since
+	   retrieving the taskfile switches us out of ADMA mode and would abort
+	   existing commands. */
+	if (unlikely(qc->tf.protocol == ATA_PROT_NCQ &&
+		     (qc->flags & ATA_QCFLAG_RESULT_TF))) {
+		ata_dev_printk(qc->dev, KERN_ERR,
+			"NCQ w/ RESULT_TF not allowed\n");
+		return AC_ERR_SYSTEM;
+	}
+
 	if (nv_adma_use_reg_mode(qc)) {
 		/* use ATA register mode */
 		VPRINTK("using ATA register mode: 0x%lx\n", qc->flags);
+		BUG_ON(!(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) &&
+			(qc->flags & ATA_QCFLAG_DMAMAP));
 		nv_adma_register_mode(qc->ap);
 		return ata_qc_issue_prot(qc);
 	} else
_

Patches currently in -mm which might be from hancockr@shaw.ca are

git-libata-all.patch
git-x86.patch
