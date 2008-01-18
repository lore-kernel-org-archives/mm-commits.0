From: akpm@linux-foundation.org
Subject: + x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch added to -mm tree
Date: Fri, 18 Jan 2008 13:58:59 -0800
Message-ID: <200801182159.m0ILx0hd007240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41393 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138AbYARV71 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jan 2008 16:59:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, yinghai.lu@Sun.COM


The patch titled
     x86: clear pci_mmcfg_virt when mmcfg get rejected
has been added to the -mm tree.  Its filename is
     x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch

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
 	raw_pci_ops_extcfg = &pci_mmcfg;
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
 	raw_pci_ops_extcfg = &pci_mmcfg;
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
@@ -107,6 +107,7 @@ extern DECLARE_BITMAP(pci_mmcfg_fallback
 extern int __init pci_mmcfg_arch_reachable(unsigned int seg, unsigned int bus,
 					   unsigned int devfn);
 extern int __init pci_mmcfg_arch_init(void);
+extern void __init pci_mmcfg_arch_free(void);
 
 /*
  * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
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
kernel-printkc-concerns-about-the-console-handover.patch
