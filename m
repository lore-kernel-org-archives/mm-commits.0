From: akpm@linux-foundation.org
Subject: - 8250_pci-fix-pci-must_checks.patch removed from -mm tree
Date: Wed, 02 May 2007 15:10:27 -0700
Message-ID: <200705022210.l42MAR5x031333@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993188AbXEBWKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 18:10:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     8250_pci: fix PCI must_checks
has been removed from the -mm tree.  Its filename was
     8250_pci-fix-pci-must_checks.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: 8250_pci: fix PCI must_checks
From: Randy Dunlap <randy.dunlap@oracle.com>

drivers/serial/8250_pci.c:1826: warning: ignoring return value of 'pci_enable_device', declared with attribute warn_unused_result

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/serial/8250_pci.c~8250_pci-fix-pci-must_checks drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~8250_pci-fix-pci-must_checks
+++ a/drivers/serial/8250_pci.c
@@ -1820,10 +1820,18 @@ static int pciserial_resume_one(struct p
 	pci_restore_state(dev);
 
 	if (priv) {
+		int err;
+
 		/*
 		 * The device may have been disabled.  Re-enable it.
 		 */
-		pci_enable_device(dev);
+		err = pci_enable_device(dev);
+		if (err) {
+			printk(KERN_ERR "8250_pci: %s: error %d "
+				"enabling device for resume\n",
+				pci_name(dev), err);
+			return err;
+		}
 
 		pciserial_resume_ports(priv);
 	}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
8250_pci-fix-pci-must_checks.patch
