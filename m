From: akpm@linux-foundation.org
Subject: + sata_nv-add-back-some-verbosity-into-adma-error_handler.patch added to -mm tree
Date: Mon, 12 Feb 2007 22:46:03 -0800
Message-ID: <200702130646.l1D6k32l024238@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56604 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161026AbXBMGqT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 01:46:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org


The patch titled
     sata_nv: add back some verbosity into ADMA error_handler
has been added to the -mm tree.  Its filename is
     sata_nv-add-back-some-verbosity-into-adma-error_handler.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_nv: add back some verbosity into ADMA error_handler
From: Robert Hancock <hancockr@shaw.ca>

Some debug output in the ADMA error_handler function was removed recently,
but it may be useful in certain cases, like NCQ commands timing out.  Add
it back in, but make it a bit more intelligent so that it only prints if
command(s) are active and only prints the CPBs for those commands.  That
way it won't spew at inappropriate times like suspend/resume.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN drivers/ata/sata_nv.c~sata_nv-add-back-some-verbosity-into-adma-error_handler drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-add-back-some-verbosity-into-adma-error_handler
+++ a/drivers/ata/sata_nv.c
@@ -1443,6 +1443,26 @@ static void nv_adma_error_handler(struct
 		int i;
 		u16 tmp;
 
+		if(ata_tag_valid(ap->active_tag) || ap->sactive) {
+			u32 notifier = readl(mmio + NV_ADMA_NOTIFIER);
+			u32 notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
+			u32 gen_ctl = readl(pp->gen_block + NV_ADMA_GEN_CTL);
+			u32 status = readw(mmio + NV_ADMA_STAT);
+
+			ata_port_printk(ap, KERN_ERR, "EH in ADMA mode, notifier 0x%X "
+				"notifier_error 0x%X gen_ctl 0x%X status 0x%X\n",
+				notifier, notifier_error, gen_ctl, status);
+
+			for( i=0;i<NV_ADMA_MAX_CPBS;i++) {
+				struct nv_adma_cpb *cpb = &pp->cpb[i];
+				if( (ata_tag_valid(ap->active_tag) && i == ap->active_tag) ||
+				    ap->sactive & (1 << i) )
+					ata_port_printk(ap, KERN_ERR,
+						"CPB %d: ctl_flags 0x%x, resp_flags 0x%x\n",
+						i, cpb->ctl_flags, cpb->resp_flags);
+			}
+		}
+
 		/* Push us back into port register mode for error handling. */
 		nv_adma_register_mode(ap);
 
_

Patches currently in -mm which might be from hancockr@shaw.ca are

origin.patch
libata-warn-if-speed-limited-due-to-40-wire-cable.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
