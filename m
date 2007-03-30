From: akpm@linux-foundation.org
Subject: + fix-82875-pci-setup.patch added to -mm tree
Date: Fri, 30 Mar 2007 13:30:15 -0700
Message-ID: <200703302030.l2UKUFa7004273@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51085 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbXC3Uab (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Mar 2007 16:30:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jfeeney@redhat.com, ajackson@redhat.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, greg@kroah.com, hmh@hmh.eng.br, norsk5@xmission.com


The patch titled
     Fix 82875 PCI setup
has been added to the -mm tree.  Its filename is
     fix-82875-pci-setup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix 82875 PCI setup
From: John Feeney <jfeeney@redhat.com>

The 82875 EDAC driver enables an otherwise-hidden PCI device, but doesn't
register it as a PCI device properly.  Therefore, the device list in
/proc/bus/pci/devices is different than the tree in /sys/bus/pci.  This
usually manifests as the X server failing to start, since it expects the
two lists to be consistent.

Signed-off-by: Adam Jackson <ajackson@redhat.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Doug Thompson <norsk5@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82875p_edac.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff -puN drivers/edac/i82875p_edac.c~fix-82875-pci-setup drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~fix-82875-pci-setup
+++ a/drivers/edac/i82875p_edac.c
@@ -261,10 +261,6 @@ static void i82875p_check(struct mem_ctl
 	i82875p_process_error_info(mci, &info, 1);
 }
 
-#ifdef CONFIG_PROC_FS
-extern int pci_proc_attach_device(struct pci_dev *);
-#endif
-
 /* Return 0 on success or 1 on failure. */
 static int i82875p_setup_overfl_dev(struct pci_dev *pdev,
 		struct pci_dev **ovrfl_pdev, void __iomem **ovrfl_window)
@@ -287,17 +283,12 @@ static int i82875p_setup_overfl_dev(stru
 
 		if (dev == NULL)
 			return 1;
+
+        	pci_bus_add_device(dev);
 	}
 
 	*ovrfl_pdev = dev;
 
-#ifdef CONFIG_PROC_FS
-	if ((dev->procent == NULL) && pci_proc_attach_device(dev)) {
-		i82875p_printk(KERN_ERR, "%s(): Failed to attach overflow "
-			       "device\n", __func__);
-		return 1;
-	}
-#endif  /* CONFIG_PROC_FS */
 	if (pci_enable_device(dev)) {
 		i82875p_printk(KERN_ERR, "%s(): Failed to enable overflow "
 			       "device\n", __func__);
_

Patches currently in -mm which might be from jfeeney@redhat.com are

fix-82875-pci-setup.patch
