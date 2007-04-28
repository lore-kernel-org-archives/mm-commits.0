From: akpm@linux-foundation.org
Subject: - sata_nv-add-back-some-verbosity-into-adma-error_handler.patch removed from -mm tree
Date: Sat, 28 Apr 2007 14:18:36 -0700
Message-ID: <200704282118.l3SLIbrm029766@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170AbXD1VSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 17:18:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sata_nv: add back some verbosity into ADMA error_handler
has been removed from the -mm tree.  Its filename was
     sata_nv-add-back-some-verbosity-into-adma-error_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_nv: add back some verbosity into ADMA error_handler
From: Robert Hancock <hancockr@shaw.ca>

Some debug output in the ADMA error_handler function was removed recently,
but it may be useful in certain cases, like NCQ commands timing out.  Add
it back in, but make it a bit more intelligent so that it only prints if
command(s) are active and only prints the CPBs for those commands.  That
way it won't spew at inappropriate times like suspend/resume.

[akpm@osdl.org: cleanup]
Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff -puN drivers/ata/sata_nv.c~sata_nv-add-back-some-verbosity-into-adma-error_handler drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-add-back-some-verbosity-into-adma-error_handler
+++ a/drivers/ata/sata_nv.c
@@ -1455,11 +1455,38 @@ static void nv_adma_error_handler(struct
 			}
 		}
 
+		if (ata_tag_valid(ap->active_tag) || ap->sactive) {
+			u32 notifier = readl(mmio + NV_ADMA_NOTIFIER);
+			u32 notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
+			u32 gen_ctl = readl(pp->gen_block + NV_ADMA_GEN_CTL);
+			u32 status = readw(mmio + NV_ADMA_STAT);
+
+			ata_port_printk(ap, KERN_ERR, "EH in ADMA mode, "
+				"notifier 0x%X notifier_error 0x%X gen_ctl "
+				"0x%X status 0x%X\n",
+				notifier, notifier_error, gen_ctl, status);
+
+			for (i = 0; i < NV_ADMA_MAX_CPBS; i++) {
+				struct nv_adma_cpb *cpb = &pp->cpb[i];
+				if ((ata_tag_valid(ap->active_tag) &&
+						i == ap->active_tag) ||
+						ap->sactive & (1 << i))
+					ata_port_printk(ap, KERN_ERR, "CPB %d: "
+						"ctl_flags 0x%x, resp_flags "
+						"0x%x\n",
+						i, cpb->ctl_flags,
+						cpb->resp_flags);
+			}
+		}
+
 		/* Push us back into port register mode for error handling. */
 		nv_adma_register_mode(ap);
 
-		/* Mark all of the CPBs as invalid to prevent them from being executed */
-		for( i=0;i<NV_ADMA_MAX_CPBS;i++)
+		/*
+		 * Mark all of the CPBs as invalid to prevent them from being
+		 * executed
+		*/
+		for (i = 0; i< NV_ADMA_MAX_CPBS; i++)
 			pp->cpb[i].ctl_flags &= ~NV_CPB_CTL_CPB_VALID;
 
 		/* clear CPB fetch count */
_

Patches currently in -mm which might be from hancockr@shaw.ca are

git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
