From: akpm@linux-foundation.org
Subject: - x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch removed from -mm tree
Date: Mon, 11 Feb 2008 14:10:20 -0800
Message-ID: <200802112210.m1BMALPv002884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40490 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758160AbYBKWL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 17:11:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86: clear pci_mmcfg_virt when mmcfg get rejected
has been removed from the -mm tree.  Its filename was
     x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: clear pci_mmcfg_virt when mmcfg get rejected
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

For x86_64, need to free pci_mmcfg_virt, and iounmap some pointers
when MMCONF is not reserved in E820 or acpi _CRS and get rejected

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/mmconfig-shared.c |    1 +
 arch/x86/pci/mmconfig_32.c     |    4 ++++
 arch/x86/pci/mmconfig_64.c     |   22 +++++++++++++++++++++-
 arch/x86/pci/pci.h             |    1 +
 4 files changed, 27 insertions(+), 1 deletion(-)

diff -puN arch/x86/pci/mmconfig-shared.c~x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected arch/x86/pci/mmconfig-shared.c
--- a/arch/x86/pci/mmconfig-shared.c~x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected
+++ a/arch/x86/pci/mmconfig-shared.c
@@ -333,6 +333,7 @@ static void __init pci_mmcfg_reject_brok
 
 reject:
 	printk(KERN_ERR "PCI: Not using MMCONFIG.\n");
+	pci_mmcfg_arch_free();
 	kfree(pci_mmcfg_config);
 	pci_mmcfg_config = NULL;
 	pci_mmcfg_config_num = 0;
diff -puN arch/x86/pci/mmconfig_32.c~x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected arch/x86/pci/mmconfig_32.c
--- a/arch/x86/pci/mmconfig_32.c~x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected
+++ a/arch/x86/pci/mmconfig_32.c
@@ -146,3 +146,7 @@ int __init pci_mmcfg_arch_init(void)
 	raw_pci_ops = &pci_mmcfg;
 	return 1;
 }
+
+void __init pci_mmcfg_arch_free(void)
+{
+}
diff -puN arch/x86/pci/mmconfig_64.c~x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected arch/x86/pci/mmconfig_64.c
--- a/arch/x86/pci/mmconfig_64.c~x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected
+++ a/arch/x86/pci/mmconfig_64.c
@@ -135,7 +135,7 @@ int __init pci_mmcfg_arch_reachable(unsi
 int __init pci_mmcfg_arch_init(void)
 {
 	int i;
-	pci_mmcfg_virt = kmalloc(sizeof(*pci_mmcfg_virt) *
+	pci_mmcfg_virt = kzalloc(sizeof(*pci_mmcfg_virt) *
 				 pci_mmcfg_config_num, GFP_KERNEL);
 	if (pci_mmcfg_virt == NULL) {
 		printk(KERN_ERR "PCI: Can not allocate memory for mmconfig structures\n");
@@ -149,9 +149,29 @@ int __init pci_mmcfg_arch_init(void)
 			printk(KERN_ERR "PCI: Cannot map mmconfig aperture for "
 					"segment %d\n",
 				pci_mmcfg_config[i].pci_segment);
+			pci_mmcfg_arch_free();
 			return 0;
 		}
 	}
 	raw_pci_ops = &pci_mmcfg;
 	return 1;
 }
+
+void __init pci_mmcfg_arch_free(void)
+{
+	int i;
+
+	if (pci_mmcfg_virt == NULL)
+		return;
+
+	for (i = 0; i < pci_mmcfg_config_num; ++i) {
+		if (pci_mmcfg_virt[i].virt) {
+			iounmap(pci_mmcfg_virt[i].virt);
+			pci_mmcfg_virt[i].virt = NULL;
+			pci_mmcfg_virt[i].cfg = NULL;
+		}
+	}
+
+	kfree(pci_mmcfg_virt);
+	pci_mmcfg_virt = NULL;
+}
diff -puN arch/x86/pci/pci.h~x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected arch/x86/pci/pci.h
--- a/arch/x86/pci/pci.h~x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected
+++ a/arch/x86/pci/pci.h
@@ -105,6 +105,7 @@ extern DECLARE_BITMAP(pci_mmcfg_fallback
 extern int __init pci_mmcfg_arch_reachable(unsigned int seg, unsigned int bus,
 					   unsigned int devfn);
 extern int __init pci_mmcfg_arch_init(void);
+extern void __init pci_mmcfg_arch_free(void);
 
 /*
  * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
sata_mv-fix-loop-with-last-port.patch
git-x86.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
