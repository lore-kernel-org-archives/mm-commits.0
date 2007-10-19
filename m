From: akpm@linux-foundation.org
Subject: - x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:47:56 -0700
Message-ID: <200710190347.l9J3lu1P013422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51992 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965840AbXJSDzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is used
has been removed from the -mm tree.  Its filename was
     x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is used
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/fixup.c |   13 +++++++++++++
 drivers/pci/probe.c  |   11 ++++++++++-
 include/linux/pci.h  |    1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

diff -puN arch/x86/pci/fixup.c~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is arch/x86/pci/fixup.c
--- a/arch/x86/pci/fixup.c~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is
+++ a/arch/x86/pci/fixup.c
@@ -491,3 +491,16 @@ static void __devinit pci_siemens_interr
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
 			  pci_siemens_interrupt_controller);
+
+/*
+ * Regular PCI devices have 256 bytes, but AMD Family 10h Opteron ext config
+ * have 4096 bytes.  Even if the device is capable, that doesn't mean we can
+ * access it.  Maybe we don't have a way to generate extended config space
+ * accesses.   So check it
+ */
+static void fam10h_pci_cfg_space_size(struct pci_dev *dev)
+{
+        dev->cfg_size = pci_cfg_space_size_ext(dev, 0);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_ANY_ID, fam10h_pci_cfg_space_size);
diff -puN drivers/pci/probe.c~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is drivers/pci/probe.c
--- a/drivers/pci/probe.c~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is
+++ a/drivers/pci/probe.c
@@ -839,11 +839,14 @@ static void pci_release_dev(struct devic
  * reading the dword at 0x100 which must either be 0 or a valid extended
  * capability header.
  */
-int pci_cfg_space_size(struct pci_dev *dev)
+int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix)
 {
 	int pos;
 	u32 status;
 
+	if (!check_exp_pcix)
+		goto skip;
+
 	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
 	if (!pos) {
 		pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
@@ -855,6 +858,7 @@ int pci_cfg_space_size(struct pci_dev *d
 			goto fail;
 	}
 
+ skip:
 	if (pci_read_config_dword(dev, 256, &status) != PCIBIOS_SUCCESSFUL)
 		goto fail;
 	if (status == 0xffffffff)
@@ -866,6 +870,11 @@ int pci_cfg_space_size(struct pci_dev *d
 	return PCI_CFG_SPACE_SIZE;
 }
 
+int pci_cfg_space_size(struct pci_dev *dev)
+{
+	return pci_cfg_space_size_ext(dev, 1);
+}
+
 static void pci_release_bus_bridge_dev(struct device *dev)
 {
 	kfree(dev);
diff -puN include/linux/pci.h~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is include/linux/pci.h
--- a/include/linux/pci.h~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is
+++ a/include/linux/pci.h
@@ -626,6 +626,7 @@ int pci_scan_bridge(struct pci_bus *bus,
 
 void pci_walk_bus(struct pci_bus *top, void (*cb)(struct pci_dev *, void *),
 		  void *userdata);
+int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix);
 int pci_cfg_space_size(struct pci_dev *dev);
 unsigned char pci_bus_max_busnr(struct pci_bus* bus);
 
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
git-kbuild.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
kernel-printkc-concerns-about-the-console-handover.patch
