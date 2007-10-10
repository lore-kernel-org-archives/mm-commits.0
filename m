From: akpm@linux-foundation.org
Subject: - pci-implement-pci=noaer.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:48 -0700
Message-ID: <200710102110.l9ALAmGw025959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729AbXJJVVR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:21:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     pci: implement "pci=noaer"
has been removed from the -mm tree.  Its filename was
     pci-implement-pci=noaer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci: implement "pci=noaer"
From: Randy Dunlap <randy.dunlap@oracle.com>

For cases in which CONFIG_PCIEAER=y (such as distro kernels), allow users
to disable PCIE Advanced Error Reporting by using "pci=noaer" on the kernel
command line.

This can be used to work around hardware or (kernel) software problems.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/kernel-parameters.txt~pci-implement-pci=noaer Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~pci-implement-pci=noaer
+++ a/Documentation/kernel-parameters.txt
@@ -67,6 +67,7 @@ parameter is applicable:
 	PARIDE	The ParIDE (parallel port IDE) subsystem is enabled.
 	PARISC	The PA-RISC architecture is enabled.
 	PCI	PCI bus support is enabled.
+	PCIE	PCI Express support is enabled.
 	PCMCIA	The PCMCIA subsystem is enabled.
 	PNP	Plug & Play support is enabled.
 	PPC	PowerPC architecture is enabled.
@@ -1274,6 +1275,9 @@ and is between 256 and 4096 characters. 
 				Mechanism 1.
 		conf2		[X86-32] Force use of PCI Configuration
 				Mechanism 2.
+		noaer		[PCIE] If the PCIEAER kernel config parameter is
+				enabled, this kernel boot option can be used to
+				disable the use of PCIE advanced error reporting.
 		nommconf	[X86-32,X86_64] Disable use of MMCONFIG for PCI
 				Configuration
 		nomsi		[MSI] If the PCI_MSI kernel config parameter is
diff -puN drivers/pci/pci.c~pci-implement-pci=noaer drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-implement-pci=noaer
+++ a/drivers/pci/pci.c
@@ -1586,6 +1586,8 @@ static int __devinit pci_setup(char *str
 		if (*str && (str = pcibios_setup(str)) && *str) {
 			if (!strcmp(str, "nomsi")) {
 				pci_no_msi();
+			} else if (!strcmp(str, "noaer")) {
+				pci_no_aer();
 			} else if (!strncmp(str, "cbiosize=", 9)) {
 				pci_cardbus_io_size = memparse(str + 9, &str);
 			} else if (!strncmp(str, "cbmemsize=", 10)) {
diff -puN drivers/pci/pci.h~pci-implement-pci=noaer drivers/pci/pci.h
--- a/drivers/pci/pci.h~pci-implement-pci=noaer
+++ a/drivers/pci/pci.h
@@ -51,6 +51,12 @@ void pci_restore_msi_state(struct pci_de
 static inline void pci_restore_msi_state(struct pci_dev *dev) {}
 #endif
 
+#ifdef CONFIG_PCIEAER
+void pci_no_aer(void);
+#else
+static inline void pci_no_aer(void) { }
+#endif
+
 static inline int pci_no_d1d2(struct pci_dev *dev)
 {
 	unsigned int parent_dstates = 0;
diff -puN drivers/pci/pcie/aer/aerdrv.c~pci-implement-pci=noaer drivers/pci/pcie/aer/aerdrv.c
--- a/drivers/pci/pcie/aer/aerdrv.c~pci-implement-pci=noaer
+++ a/drivers/pci/pcie/aer/aerdrv.c
@@ -81,6 +81,13 @@ static struct pcie_port_service_driver a
 	.reset_link	= aer_root_reset,
 };
 
+static int pcie_aer_disable;
+
+void pci_no_aer(void)
+{
+	pcie_aer_disable = 1;	/* has priority over 'forceload' */
+}
+
 /**
  * aer_irq - Root Port's ISR
  * @irq: IRQ assigned to Root Port
@@ -327,6 +334,8 @@ static void aer_error_resume(struct pci_
  **/
 static int __init aer_service_init(void)
 {
+	if (pcie_aer_disable)
+		return -ENXIO;
 	return pcie_port_service_register(&aerdriver);
 }
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-alsa.patch
fix-auditscc-kernel-doc.patch
git-kbuild.patch
git-mtd.patch
git-net.patch
git-nfsd.patch
git-scsi-misc.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch
dont-truncate-proc-pid-environ-at-4096-characters.patch
dontdiff-update-based-on-gitignore-updates.patch
ecryptfs-remove-header_extent_size-fix.patch
video-gfx-fix-menu-ordering.patch
video-gfx-merge-kconfig-menus.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch
