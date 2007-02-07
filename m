From: akpm@linux-foundation.org
Subject: - sata_nv-use-adma-for-nodata-commands.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:52:36 -0800
Message-ID: <200702071952.l17Jqa3K025254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33650 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422751AbXBGTwp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:52:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sata_nv: use ADMA for NODATA commands
has been removed from the -mm tree.  Its filename was
     sata_nv-use-adma-for-nodata-commands.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_nv: use ADMA for NODATA commands
From: Robert Hancock <hancockr@shaw.ca>

Some problems showed up recently with cache flush commands timing out on
sata_nv.  Previously these commands were always handled by transitioning to
legacy mode from ADMA mode first.  The timeout problem was worked around
already by a change to the interrupt handling code for legacy mode, but for
non-data commands like these it appears we can handle them in ADMA mode, so
the switch to legacy mode is not needed.

This patch changes the behavior so that we use ADMA mode to submit
interrupt-driven commands with ATA_PROT_NODATA protocol.  In addition to
avoiding the problem mentioned above entirely, this avoids the overhead of
switching to legacy mode and back to ADMA mode for handling cache flushes. 
When handling non-DMA-mapped commands, we leave the APRD blank and clear
the NV_CPB_CTL_APRD_VALID field in the CPB so the controller does not
attempt to read it.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff -puN drivers/ata/sata_nv.c~sata_nv-use-adma-for-nodata-commands drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-use-adma-for-nodata-commands
+++ a/drivers/ata/sata_nv.c
@@ -1151,16 +1151,31 @@ static void nv_adma_fill_sg(struct ata_q
 		cpb->next_aprd = cpu_to_le64(((u64)(pp->aprd_dma + NV_ADMA_SGTBL_SZ * qc->tag)));
 }
 
+static int nv_adma_use_reg_mode(struct ata_queued_cmd *qc)
+{
+	struct nv_adma_port_priv *pp = qc->ap->private_data;
+
+	/* ADMA engine can only be used for non-ATAPI DMA commands,
+	   or interrupt-driven no-data commands. */
+	if((pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
+	   (qc->tf.flags & ATA_TFLAG_POLLING))
+		return 1;
+
+	if((qc->flags & ATA_QCFLAG_DMAMAP) ||
+	   (qc->tf.protocol == ATA_PROT_NODATA))
+		return 0;
+
+	return 1;
+}
+
 static void nv_adma_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 	struct nv_adma_cpb *cpb = &pp->cpb[qc->tag];
 	u8 ctl_flags = NV_CPB_CTL_CPB_VALID |
-		       NV_CPB_CTL_APRD_VALID |
 		       NV_CPB_CTL_IEN;
 
-	if (!(qc->flags & ATA_QCFLAG_DMAMAP) ||
-	     (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)) {
+	if (nv_adma_use_reg_mode(qc)) {
 		nv_adma_register_mode(qc->ap);
 		ata_qc_prep(qc);
 		return;
@@ -1180,7 +1195,11 @@ static void nv_adma_qc_prep(struct ata_q
 
 	nv_adma_tf_to_cpb(&qc->tf, cpb->tf);
 
-	nv_adma_fill_sg(qc, cpb);
+	if(qc->flags & ATA_QCFLAG_DMAMAP) {
+		nv_adma_fill_sg(qc, cpb);
+		ctl_flags |= NV_CPB_CTL_APRD_VALID;
+	} else
+		memset(&cpb->aprd[0], 0, sizeof(struct nv_adma_prd) * 5);
 
 	/* Be paranoid and don't let the device see NV_CPB_CTL_CPB_VALID until we are
 	   finished filling in all of the contents */
@@ -1195,10 +1214,9 @@ static unsigned int nv_adma_qc_issue(str
 
 	VPRINTK("ENTER\n");
 
-	if (!(qc->flags & ATA_QCFLAG_DMAMAP) ||
-	     (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)) {
+	if (nv_adma_use_reg_mode(qc)) {
 		/* use ATA register mode */
-		VPRINTK("no dmamap or ATAPI, using ATA register mode: 0x%lx\n", qc->flags);
+		VPRINTK("using ATA register mode: 0x%lx\n", qc->flags);
 		nv_adma_register_mode(qc->ap);
 		return ata_qc_issue_prot(qc);
 	} else
_

Patches currently in -mm which might be from hancockr@shaw.ca are

git-libata-all.patch
