From: akpm@linux-foundation.org
Subject: - irq-devres-fix-failure-path-of-devm_request_irq.patch removed from -mm tree
Date: Sun, 08 Apr 2007 02:13:03 -0700
Message-ID: <200704080913.l389D3Bw019803@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44945 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbXDHJNG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 8 Apr 2007 05:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     irq-devres: fix failure path of devm_request_irq()
has been removed from the -mm tree.  Its filename was
     irq-devres-fix-failure-path-of-devm_request_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
