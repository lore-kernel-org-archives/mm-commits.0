From: akpm@linux-foundation.org
Subject: + edac-mpc85xx-use-resource_size-instead-of-raw-math.patch added to -mm tree
Date: Thu, 04 Feb 2010 10:43:53 -0800
Message-ID: <201002041843.o14IhrqZ014789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757441Ab0BDSn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 13:43:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hsweeten@visionengravers.com, djiang@mvista.com, dougthompson@xmission.com, galak@gate.crashing.org, ptyser@xes-inc.com


The patch titled
     edac: mpc85xx use resource_size instead of raw math
has been added to the -mm tree.  Its filename is
     edac-mpc85xx-use-resource_size-instead-of-raw-math.patch

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

linux-next.patch
mtd-nand-fix-build-failure-caused-by-typo.patch
posix-timersc-dont-export-local-functions.patch
scsi-sdc-quiet-all-sparse-noise.patch
init-initramfsc-fix-symbol-shadows-an-earlier-one-noise.patch
nodemaskh-remove-macro-any_online_node.patch
init-mainc-make-setup_max_cpus-static-for-smp.patch
rtc-ep93xxc-cleanup-probe-remove-routines.patch
edac-mpc85xx-use-resource_size-instead-of-raw-math.patch

