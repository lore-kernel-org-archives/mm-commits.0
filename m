From: akpm@linux-foundation.org
Subject: - x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used-vs-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch removed from -mm tree
Date: Fri, 01 Feb 2008 15:52:38 -0800
Message-ID: <200802020001.m1201LLl006098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53185 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759927AbYBBABy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 19:01:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, greg@kroah.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86_64: AMD Family 10h enable ext config in quirk
has been removed from the -mm tree.  Its filename was
     x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used-vs-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_64: AMD Family 10h enable ext config in quirk
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Because of changes of
gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch

need to call pci_enable_ext_config to enable mmconfig before set right cfg_size
even MCFG is there

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: Greg KH <greg@kroah.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/fixup.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/x86/pci/fixup.c~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used-vs-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in arch/x86/pci/fixup.c
--- a/arch/x86/pci/fixup.c~x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used-vs-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in
+++ a/arch/x86/pci/fixup.c
@@ -498,10 +498,12 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_S
  * access it.  Maybe we don't have a way to generate extended config space
  * accesses.   So check it
  */
-static void fam10h_pci_cfg_space_size(struct pci_dev *dev)
+static void fam10h_enable_pci_ext_cfg(struct pci_dev *dev)
 {
+	pci_enable_ext_config(dev);
+	/* recheck cfg_size without pcie_pcix checking */
 	dev->cfg_size = pci_cfg_space_size_ext(dev, 0);
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_ANY_ID,
-			 fam10h_pci_cfg_space_size);
+			 fam10h_enable_pci_ext_cfg);
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
git-cpufreq.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used-vs-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch
kernel-printkc-concerns-about-the-console-handover.patch
convert-loglevel-related-kernel-boot-parameters-to-early_param.patch
