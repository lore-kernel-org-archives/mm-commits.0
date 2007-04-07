From: akpm@linux-foundation.org
Subject: + irq-devres-fix-failure-path-of-devm_request_irq.patch added to -mm tree
Date: Sat, 07 Apr 2007 00:44:24 -0700
Message-ID: <200704070744.l377iOvO030171@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46949 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965472AbXDGHo1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 03:44:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, greg@kroah.com


The patch titled
     irq-devres: fix failure path of devm_request_irq()
has been added to the -mm tree.  Its filename is
     irq-devres-fix-failure-path-of-devm_request_irq.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: irq-devres: fix failure path of devm_request_irq()
From: Tejun Heo <htejun@gmail.com>

devres should be deallocated with devres_free() not kfree().  This bug
corrupts slab on IRQ request failure.  Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/devres.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/irq/devres.c~irq-devres-fix-failure-path-of-devm_request_irq kernel/irq/devres.c
--- a/kernel/irq/devres.c~irq-devres-fix-failure-path-of-devm_request_irq
+++ a/kernel/irq/devres.c
@@ -54,7 +54,7 @@ int devm_request_irq(struct device *dev,
 
 	rc = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (rc) {
-		kfree(dr);
+		devres_free(dr);
 		return rc;
 	}
 
_

Patches currently in -mm which might be from htejun@gmail.com are

irq-devres-fix-failure-path-of-devm_request_irq.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
