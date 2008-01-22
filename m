From: akpm@linux-foundation.org
Subject: + x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch added to -mm tree
Date: Mon, 21 Jan 2008 18:45:33 -0800
Message-ID: <200801220245.m0M2jDAs000524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbYAVCqM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 21:46:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, greg@kroah.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, yinghai.lu@Sun.COM


The patch titled
     x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is used
has been added to the -mm tree.  Its filename is
     x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is used
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: Greg KH <greg@kroah.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/fixup.c |   14 ++++++++++++++
 drivers/pci/probe.c  |   11 ++++++++++-
 include/linux/pci.h  |    1 +
 3 files changed, 25 insertions(+), 1 deletion(-)

diff -puN arch/x86/pci/fixup.c~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used arch/x86/pci/fixup.c
--- a/arch/x86/pci/fixup.c~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used
+++ a/arch/x86/pci/fixup.c
@@ -491,3 +491,17 @@ static void __devinit pci_siemens_interr
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
+	dev->cfg_size = pci_cfg_space_size_ext(dev, 0);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_ANY_ID,
+			 fam10h_pci_cfg_space_size);
diff -puN drivers/pci/probe.c~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used drivers/pci/probe.c
--- a/drivers/pci/probe.c~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used
+++ a/drivers/pci/probe.c
@@ -827,11 +827,14 @@ static void set_pcie_port_type(struct pc
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
@@ -843,6 +846,7 @@ int pci_cfg_space_size(struct pci_dev *d
 			goto fail;
 	}
 
+ skip:
 	if (pci_read_config_dword(dev, 256, &status) != PCIBIOS_SUCCESSFUL)
 		goto fail;
 	if (status == 0xffffffff)
@@ -854,6 +858,11 @@ int pci_cfg_space_size(struct pci_dev *d
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
diff -puN include/linux/pci.h~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used include/linux/pci.h
--- a/include/linux/pci.h~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used
+++ a/include/linux/pci.h
@@ -663,6 +663,7 @@ int pci_scan_bridge(struct pci_bus *bus,
 
 void pci_walk_bus(struct pci_bus *top, void (*cb)(struct pci_dev *, void *),
 		  void *userdata);
+int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix);
 int pci_cfg_space_size(struct pci_dev *dev);
 unsigned char pci_bus_max_busnr(struct pci_bus* bus);
 
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

git-cpufreq.patch
serial-keep-the-dtr-setting-for-serial-console.patch
pcie-aer-dont-check-_osc-when-acpi-is-disabled.patch
git-x86.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3-2.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
kernel-printkc-concerns-about-the-console-handover.patch
