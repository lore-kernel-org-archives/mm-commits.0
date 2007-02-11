From: akpm@linux-foundation.org
Subject: - git-libata-all-lib-iomapc-fix-for-config_pci=n.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:30:59 -0800
Message-ID: <200702112230.l1BMUxJW015212@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59083 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595AbXBKWbN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:31:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     lib/iomap.c: fix for CONFIG_PCI=n
has been removed from the -mm tree.  Its filename was
     git-libata-all-lib-iomapc-fix-for-config_pci=n.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: lib/iomap.c: fix for CONFIG_PCI=n
From: Andrew Morton <akpm@linux-foundation.org>

- Fix recently-broken CONFIG_PCI=n build:

  lib/iomap.c:530: warning: implicit declaration of function 'pci_request_region'
  lib/iomap.c:544: warning: implicit declaration of function 'pci_release_region'
  arch/i386/kernel/cpu/transmeta.c: In function 'init_transmeta':
  arch/i386/kernel/cpu/transmeta.c:12: warning: 'cpu_freq' may be used uninitialized in this function
  lib/built-in.o: In function `pcim_iomap_regions':
  : undefined reference to `pci_request_region'

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
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-acpi.patch
git-agpgart.patch
git-cifs-fix.patch
git-cpufreq.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-sh.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
