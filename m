From: akpm@osdl.org
Subject: + broadcom-4400-resume-small-fix-v2.patch added to -mm tree
Date: Wed, 10 Jan 2007 17:17:08 -0800
Message-ID: <200701110117.l0B1H8KJ013506@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43301 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965296AbXAKBRK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 20:17:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org


The patch titled
     Broadcom 4400 resume small fix
has been added to the -mm tree.  Its filename is
     broadcom-4400-resume-small-fix-v2.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Broadcom 4400 resume small fix
From: Dmitriy Monakhov <dmonakhov@openvz.org>

Some issues in b44_resume().

- Return value of pci_enable_device() was ignored.

- If request_irq() has failed we have to just disable device and exit.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/b44.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/net/b44.c~broadcom-4400-resume-small-fix-v2 drivers/net/b44.c
--- a/drivers/net/b44.c~broadcom-4400-resume-small-fix-v2
+++ a/drivers/net/b44.c
@@ -2315,16 +2315,27 @@ static int b44_resume(struct pci_dev *pd
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct b44 *bp = netdev_priv(dev);
+	int rc = 0;
 
 	pci_restore_state(pdev);
-	pci_enable_device(pdev);
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		printk(KERN_ERR PFX "%s: pci_enable_device failed\n",
+			dev->name);
+		return rc;
+	}
+
 	pci_set_master(pdev);
 
 	if (!netif_running(dev))
 		return 0;
 
-	if (request_irq(dev->irq, b44_interrupt, IRQF_SHARED, dev->name, dev))
+	rc = request_irq(dev->irq, b44_interrupt, IRQF_SHARED, dev->name, dev);
+	if (rc) {
 		printk(KERN_ERR PFX "%s: request_irq failed\n", dev->name);
+		pci_disable_device(pdev);
+		return rc;
+	}
 
 	spin_lock_irq(&bp->lock);
 
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

broadcom-4400-resume-small-fix-v2.patch
