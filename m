From: akpm@linux-foundation.org
Subject: - megaraid-fix-section-mismatch.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:39:41 -0800
Message-ID: <200801160139.m0G1dfxw014024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56862 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756166AbYAPBtW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@steeleye.com, megaraidlinux@lsi.com, sam@ravnborg.org, sumant.patro@lsi.com, mm-commits@vger.kernel.org


The patch titled
     megaraid: fix section mismatch
has been removed from the -mm tree.  Its filename was
     megaraid-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: megaraid: fix section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

Change megaraid_pci_driver_g variable name so that it matches the modpost
whitelist that allows pointers to init text/data.

WARNING: vmlinux.o(.data+0x1a8e30): Section mismatch: reference to .init.text:megaraid_probe_one (between 'megaraid_pci_driver_g' and 'class_device_attr_megaraid_mbox_app_hndl')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: Sumant Patro <sumant.patro@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_mbox.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/megaraid/megaraid_mbox.c~megaraid-fix-section-mismatch drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c~megaraid-fix-section-mismatch
+++ a/drivers/scsi/megaraid/megaraid_mbox.c
@@ -300,7 +300,7 @@ static struct pci_device_id pci_id_table
 MODULE_DEVICE_TABLE(pci, pci_id_table_g);
 
 
-static struct pci_driver megaraid_pci_driver_g = {
+static struct pci_driver megaraid_pci_driver = {
 	.name		= "megaraid",
 	.id_table	= pci_id_table_g,
 	.probe		= megaraid_probe_one,
@@ -394,7 +394,7 @@ megaraid_init(void)
 
 
 	// register as a PCI hot-plug driver module
-	rval = pci_register_driver(&megaraid_pci_driver_g);
+	rval = pci_register_driver(&megaraid_pci_driver);
 	if (rval < 0) {
 		con_log(CL_ANN, (KERN_WARNING
 			"megaraid: could not register hotplug support.\n"));
@@ -415,7 +415,7 @@ megaraid_exit(void)
 	con_log(CL_DLEVEL1, (KERN_NOTICE "megaraid: unloading framework\n"));
 
 	// unregister as PCI hotplug driver
-	pci_unregister_driver(&megaraid_pci_driver_g);
+	pci_unregister_driver(&megaraid_pci_driver);
 
 	return;
 }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
git-unionfs.patch
hostap-section-mismatch-warning.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
