From: akpm@linux-foundation.org
Subject: + edac-fix-resource-size-calculation.patch added to -mm tree
Date: Wed, 15 Jul 2009 12:53:13 -0700
Message-ID: <200907151953.n6FJrDWJ021276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756206AbZGOTxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 15:53:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, dougthompson@xmission.com


The patch titled
     edac: fix resource size calculation
has been added to the -mm tree.  Its filename is
     edac-fix-resource-size-calculation.patch

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
Subject: edac: fix resource size calculation
From: Julia Lawall <julia@diku.dk>

Use the function resource_size, which reduces the chance of introducing
off-by-one errors in calculating the resource size.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct resource *res;
@@

- (res->end - res->start) + 1
+ resource_size(res)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/cpc925_edac.c  |    6 +++---
 drivers/edac/mv64x60_edac.c |   22 +++++++++++-----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/edac/cpc925_edac.c~edac-fix-resource-size-calculation drivers/edac/cpc925_edac.c
--- a/drivers/edac/cpc925_edac.c~edac-fix-resource-size-calculation
+++ a/drivers/edac/cpc925_edac.c
@@ -885,14 +885,14 @@ static int __devinit cpc925_probe(struct
 
 	if (!devm_request_mem_region(&pdev->dev,
 				     r->start,
-				     r->end - r->start + 1,
+				     resource_size(r),
 				     pdev->name)) {
 		cpc925_printk(KERN_ERR, "Unable to request mem region\n");
 		res = -EBUSY;
 		goto err1;
 	}
 
-	vbase = devm_ioremap(&pdev->dev, r->start, r->end - r->start + 1);
+	vbase = devm_ioremap(&pdev->dev, r->start, resource_size(r));
 	if (!vbase) {
 		cpc925_printk(KERN_ERR, "Unable to ioremap device\n");
 		res = -ENOMEM;
@@ -953,7 +953,7 @@ err3:
 	cpc925_mc_exit(mci);
 	edac_mc_free(mci);
 err2:
-	devm_release_mem_region(&pdev->dev, r->start, r->end-r->start+1);
+	devm_release_mem_region(&pdev->dev, r->start, resource_size(r));
 err1:
 	devres_release_group(&pdev->dev, cpc925_probe);
 out:
diff -puN drivers/edac/mv64x60_edac.c~edac-fix-resource-size-calculation drivers/edac/mv64x60_edac.c
--- a/drivers/edac/mv64x60_edac.c~edac-fix-resource-size-calculation
+++ a/drivers/edac/mv64x60_edac.c
@@ -90,7 +90,7 @@ static int __init mv64x60_pci_fixup(stru
 		return -ENOENT;
 	}
 
-	pci_serr = ioremap(r->start, r->end - r->start + 1);
+	pci_serr = ioremap(r->start, resource_size(r));
 	if (!pci_serr)
 		return -ENOMEM;
 
@@ -140,7 +140,7 @@ static int __devinit mv64x60_pci_err_pro
 
 	if (!devm_request_mem_region(&pdev->dev,
 				     r->start,
-				     r->end - r->start + 1,
+				     resource_size(r),
 				     pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
@@ -150,7 +150,7 @@ static int __devinit mv64x60_pci_err_pro
 
 	pdata->pci_vbase = devm_ioremap(&pdev->dev,
 					r->start,
-					r->end - r->start + 1);
+					resource_size(r));
 	if (!pdata->pci_vbase) {
 		printk(KERN_ERR "%s: Unable to setup PCI err regs\n", __func__);
 		res = -ENOMEM;
@@ -306,7 +306,7 @@ static int __devinit mv64x60_sram_err_pr
 
 	if (!devm_request_mem_region(&pdev->dev,
 				     r->start,
-				     r->end - r->start + 1,
+				     resource_size(r),
 				     pdata->name)) {
 		printk(KERN_ERR "%s: Error while request mem region\n",
 		       __func__);
@@ -316,7 +316,7 @@ static int __devinit mv64x60_sram_err_pr
 
 	pdata->sram_vbase = devm_ioremap(&pdev->dev,
 					 r->start,
-					 r->end - r->start + 1);
+					 resource_size(r));
 	if (!pdata->sram_vbase) {
 		printk(KERN_ERR "%s: Unable to setup SRAM err regs\n",
 		       __func__);
@@ -474,7 +474,7 @@ static int __devinit mv64x60_cpu_err_pro
 
 	if (!devm_request_mem_region(&pdev->dev,
 				     r->start,
-				     r->end - r->start + 1,
+				     resource_size(r),
 				     pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
@@ -484,7 +484,7 @@ static int __devinit mv64x60_cpu_err_pro
 
 	pdata->cpu_vbase[0] = devm_ioremap(&pdev->dev,
 					   r->start,
-					   r->end - r->start + 1);
+					   resource_size(r));
 	if (!pdata->cpu_vbase[0]) {
 		printk(KERN_ERR "%s: Unable to setup CPU err regs\n", __func__);
 		res = -ENOMEM;
@@ -501,7 +501,7 @@ static int __devinit mv64x60_cpu_err_pro
 
 	if (!devm_request_mem_region(&pdev->dev,
 				     r->start,
-				     r->end - r->start + 1,
+				     resource_size(r),
 				     pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
@@ -511,7 +511,7 @@ static int __devinit mv64x60_cpu_err_pro
 
 	pdata->cpu_vbase[1] = devm_ioremap(&pdev->dev,
 					   r->start,
-					   r->end - r->start + 1);
+					   resource_size(r));
 	if (!pdata->cpu_vbase[1]) {
 		printk(KERN_ERR "%s: Unable to setup CPU err regs\n", __func__);
 		res = -ENOMEM;
@@ -726,7 +726,7 @@ static int __devinit mv64x60_mc_err_prob
 
 	if (!devm_request_mem_region(&pdev->dev,
 				     r->start,
-				     r->end - r->start + 1,
+				     resource_size(r),
 				     pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
@@ -736,7 +736,7 @@ static int __devinit mv64x60_mc_err_prob
 
 	pdata->mc_vbase = devm_ioremap(&pdev->dev,
 				       r->start,
-				       r->end - r->start + 1);
+				       resource_size(r));
 	if (!pdata->mc_vbase) {
 		printk(KERN_ERR "%s: Unable to setup MC err regs\n", __func__);
 		res = -ENOMEM;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
edac-fix-resource-size-calculation.patch

