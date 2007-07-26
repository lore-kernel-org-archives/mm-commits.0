From: akpm@linux-foundation.org
Subject: + fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch added to -mm tree
Date: Thu, 26 Jul 2007 14:16:56 -0700
Message-ID: <200707262116.l6QLGusx021241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54141 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754395AbXGZVRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 17:17:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nix.or.die@googlemail.com


The patch titled
     Fix drivers/scsi/fdomain.c CONFIG_PCI=n warnings
has been added to the -mm tree.  Its filename is
     fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix drivers/scsi/fdomain.c CONFIG_PCI=n warnings
From: Gabriel C <nix.or.die@googlemail.com>

I get this warnings on current git when CONFIG_PCI is not set :

drivers/scsi/fdomain.c:390: warning: 'PCI_dev' defined but not used
drivers/scsi/fdomain.c:1768: warning: 'fdomain_pci_tbl' defined but not used

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/fdomain.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/fdomain.c~fix-drivers-scsi-fdomainc-config_pci=n-warnings drivers/scsi/fdomain.c
--- a/drivers/scsi/fdomain.c~fix-drivers-scsi-fdomainc-config_pci=n-warnings
+++ a/drivers/scsi/fdomain.c
@@ -387,7 +387,9 @@ static void __iomem *    bios_mem;
 static int               bios_major;
 static int               bios_minor;
 static int               PCI_bus;
+#ifdef CONFIG_PCI
 static struct pci_dev	*PCI_dev;
+#endif
 static int               Quantum;	/* Quantum board variant */
 static int               interrupt_level;
 static volatile int      in_command;
@@ -1764,6 +1766,7 @@ struct scsi_host_template fdomain_driver
 };
 
 #ifndef PCMCIA
+#ifdef CONFIG_PCI
 
 static struct pci_device_id fdomain_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70,
@@ -1771,7 +1774,7 @@ static struct pci_device_id fdomain_pci_
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, fdomain_pci_tbl);
-
+#endif
 #define driver_template fdomain_driver_template
 #include "scsi_module.c"
 
_

Patches currently in -mm which might be from nix.or.die@googlemail.com are

origin.patch
drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch
fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch
broken-lilo-check-on-make-install.patch
typo-fixes-errror-error.patch
