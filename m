From: akpm@linux-foundation.org
Subject: [merged] edac-mpc85xx-use-resource_size-instead-of-raw-math.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:53 -0400
Message-ID: <201003150702.o2F72QSI016873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935855Ab0COHCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hsweeten@visionengravers.com, djiang@mvista.com, dougthompson@xmission.com, galak@gate.crashing.org, ptyser@xes-inc.com, mm-commits@vger.kernel.org


The patch titled
     edac: mpc85xx use resource_size instead of raw math
has been removed from the -mm tree.  Its filename was
     edac-mpc85xx-use-resource_size-instead-of-raw-math.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: mpc85xx use resource_size instead of raw math
From: H Hartley Sweeten <hsweeten@visionengravers.com>

Use resource_size() instead of arithmetic.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Acked-by: Dave Jiang <djiang@mvista.com>
Cc: Peter Tyser <ptyser@xes-inc.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-use-resource_size-instead-of-raw-math drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-use-resource_size-instead-of-raw-math
+++ a/drivers/edac/mpc85xx_edac.c
@@ -239,16 +239,15 @@ static int __devinit mpc85xx_pci_err_pro
 	/* we only need the error registers */
 	r.start += 0xe00;
 
-	if (!devm_request_mem_region(&op->dev, r.start,
-					r.end - r.start + 1, pdata->name)) {
+	if (!devm_request_mem_region(&op->dev, r.start, resource_size(&r),
+					pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
 		res = -EBUSY;
 		goto err;
 	}
 
-	pdata->pci_vbase = devm_ioremap(&op->dev, r.start,
-					r.end - r.start + 1);
+	pdata->pci_vbase = devm_ioremap(&op->dev, r.start, resource_size(&r));
 	if (!pdata->pci_vbase) {
 		printk(KERN_ERR "%s: Unable to setup PCI err regs\n", __func__);
 		res = -ENOMEM;
_

Patches currently in -mm which might be from hsweeten@visionengravers.com are

origin.patch
linux-next.patch
scsi-sdc-quiet-all-sparse-noise.patch

