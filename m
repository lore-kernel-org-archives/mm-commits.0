From: akpm@linux-foundation.org
Subject: - fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:56 -0700
Message-ID: <200710102110.l9ALAuum025974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439AbXJJVVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nix.or.die@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Fix drivers/scsi/fdomain.c CONFIG_PCI=n warnings
has been removed from the -mm tree.  Its filename was
     fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-powerpc.patch
git-kbuild.patch
git-kvm.patch
git-scsi-misc.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
