From: akpm@linux-foundation.org
Subject: - sata_nv-wait-for-response-on-entering-leaving-adma-mode.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:52:39 -0800
Message-ID: <200702071952.l17JqdbY025257@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33658 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422752AbXBGTwq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:52:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sata_nv: wait for response on entering/leaving ADMA mode
has been removed from the -mm tree.  Its filename was
     sata_nv-wait-for-response-on-entering-leaving-adma-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_nv: wait for response on entering/leaving ADMA mode
From: Robert Hancock <hancockr@shaw.ca>

Update sata_nv to wait for the controller to indicate via the status
register that it has entered the requested state when switching between
ADMA mode and register mode.  This issue came up recently when debugging
some problems with cache flush command timeouts and while it didn't appear
to fix that problem, this is something we should likely be doing in any
case.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |   41 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff -puN drivers/ata/sata_nv.c~sata_nv-wait-for-response-on-entering-leaving-adma-mode drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-wait-for-response-on-entering-leaving-adma-mode
+++ a/drivers/ata/sata_nv.c
@@ -504,14 +504,38 @@ static void nv_adma_register_mode(struct
 {
 	struct nv_adma_port_priv *pp = ap->private_data;
 	void __iomem *mmio = pp->ctl_block;
-	u16 tmp;
+	u16 tmp, status;
+	int count = 0;
 
 	if (pp->flags & NV_ADMA_PORT_REGISTER_MODE)
 		return;
 
+	status = readw(mmio + NV_ADMA_STAT);
+	while(!(status & NV_ADMA_STAT_IDLE) && count < 20) {
+		ndelay(50);
+		status = readw(mmio + NV_ADMA_STAT);
+		count++;
+	}
+	if(count == 20)
+		ata_port_printk(ap, KERN_WARNING,
+			"timeout waiting for ADMA IDLE, stat=0x%hx\n",
+			status);
+
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp & ~NV_ADMA_CTL_GO, mmio + NV_ADMA_CTL);
 
+	count = 0;
+	status = readw(mmio + NV_ADMA_STAT);
+	while(!(status & NV_ADMA_STAT_LEGACY) && count < 20) {
+		ndelay(50);
+		status = readw(mmio + NV_ADMA_STAT);
+		count++;
+	}
+	if(count == 20)
+		ata_port_printk(ap, KERN_WARNING,
+			 "timeout waiting for ADMA LEGACY, stat=0x%hx\n",
+			 status);
+
 	pp->flags |= NV_ADMA_PORT_REGISTER_MODE;
 }
 
@@ -519,7 +543,8 @@ static void nv_adma_mode(struct ata_port
 {
 	struct nv_adma_port_priv *pp = ap->private_data;
 	void __iomem *mmio = pp->ctl_block;
-	u16 tmp;
+	u16 tmp, status;
+	int count = 0;
 
 	if (!(pp->flags & NV_ADMA_PORT_REGISTER_MODE))
 		return;
@@ -529,6 +554,18 @@ static void nv_adma_mode(struct ata_port
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp | NV_ADMA_CTL_GO, mmio + NV_ADMA_CTL);
 
+	status = readw(mmio + NV_ADMA_STAT);
+	while(((status & NV_ADMA_STAT_LEGACY) ||
+	      !(status & NV_ADMA_STAT_IDLE)) && count < 20) {
+		ndelay(50);
+		status = readw(mmio + NV_ADMA_STAT);
+		count++;
+	}
+	if(count == 20)
+		ata_port_printk(ap, KERN_WARNING,
+			"timeout waiting for ADMA LEGACY clear and IDLE, stat=0x%hx\n",
+			status);
+
 	pp->flags &= ~NV_ADMA_PORT_REGISTER_MODE;
 }
 
_

Patches currently in -mm which might be from hancockr@shaw.ca are

git-libata-all.patch
