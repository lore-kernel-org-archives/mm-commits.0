From: akpm@linux-foundation.org
Subject: + git-libata-all-lib-iomapc-fix-for-config_pci=n.patch added to -mm tree
Date: Wed, 07 Feb 2007 17:40:40 -0800
Message-ID: <200702080141.l181fj4n002020@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49804 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161510AbXBHBl5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 20:41:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jeff@garzik.org


The patch titled
     git-libata-all: lib/iomap.c: fix for CONFIG_PCI=n
has been added to the -mm tree.  Its filename is
     git-libata-all-lib-iomapc-fix-for-config_pci=n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-libata-all: lib/iomap.c: fix for CONFIG_PCI=n
From: Andrew Morton <akpm@linux-foundation.org>

- Fix CONFIG_PCI=n build

- coding-style repairs

Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iomap.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN lib/iomap.c~git-libata-all-lib-iomapc-fix-for-config_pci=n lib/iomap.c
--- a/lib/iomap.c~git-libata-all-lib-iomapc-fix-for-config_pci=n
+++ a/lib/iomap.c
@@ -228,6 +228,7 @@ void ioport_unmap(void __iomem *addr)
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
 
+#ifdef CONFIG_PCI
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
@@ -256,6 +257,7 @@ void pci_iounmap(struct pci_dev *dev, vo
 }
 EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
+#endif		/* CONFIG_PCI */
 
 #endif /* CONFIG_GENERIC_IOMAP */
 
@@ -282,7 +284,7 @@ static int devm_ioport_map_match(struct 
  * Managed ioport_map().  Map is automatically unmapped on driver
  * detach.
  */
-void __iomem * devm_ioport_map(struct device *dev, unsigned long port,
+void __iomem *devm_ioport_map(struct device *dev, unsigned long port,
 			       unsigned int nr)
 {
 	void __iomem **ptr, *addr;
@@ -400,6 +402,7 @@ void devm_iounmap(struct device *dev, vo
 }
 EXPORT_SYMBOL(devm_iounmap);
 
+#ifdef CONFIG_PCI
 /*
  * PCI iomap devres
  */
@@ -433,7 +436,7 @@ static void pcim_iomap_release(struct de
  * be safely called without context and guaranteed to succed once
  * allocated.
  */
-void __iomem * const * pcim_iomap_table(struct pci_dev *pdev)
+void __iomem * const *pcim_iomap_table(struct pci_dev *pdev)
 {
 	struct pcim_iomap_devres *dr, *new_dr;
 
@@ -458,7 +461,7 @@ EXPORT_SYMBOL(pcim_iomap_table);
  * Managed pci_iomap().  Map is automatically unmapped on driver
  * detach.
  */
-void __iomem * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen)
+void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen)
 {
 	void __iomem **tbl;
 
@@ -551,3 +554,5 @@ int pcim_iomap_regions(struct pci_dev *p
 	return rc;
 }
 EXPORT_SYMBOL(pcim_iomap_regions);
+
+#endif		/* CONFIG_PCI */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
md-fix-various-bugs-with-aligned-reads-in-raid5-fix.patch
acpi-bay-driver-warning-fix.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
fix-utrace-utrace-ptrace-compat.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-3-fix.patch
