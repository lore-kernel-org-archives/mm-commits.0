From: akpm@linux-foundation.org
Subject: + x86-mmconf-enable-mcfg-early.patch added to -mm tree
Date: Fri, 18 Jan 2008 13:59:01 -0800
Message-ID: <200801182159.m0ILx2co007249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359AbYARV72 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jan 2008 16:59:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, yinghai.lu@Sun.COM


The patch titled
     x86: MMCONF enable MCFG early
has been added to the -mm tree.  Its filename is
     x86-mmconf-enable-mcfg-early.patch

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
Subject: x86: MMCONF enable MCFG early
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Patch
	x86: validate against ACPI motherboard resources

changed the mmconf init sequence, and init MMCONF late in acpi_init.

here change it back to old sequence
1. check hostbridge in early
2. check MCFG with e820 in early
3. if all fail, will check MCFg with acpi _CRS in acpi_init

So we can make MCONF working again when acpi=off is set if hostbridge support
that.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/mmconfig-shared.c |  106 +++++++++++++++++--------------
 1 file changed, 61 insertions(+), 45 deletions(-)

diff -puN arch/x86/pci/mmconfig-shared.c~x86-mmconf-enable-mcfg-early arch/x86/pci/mmconfig-shared.c
--- a/arch/x86/pci/mmconfig-shared.c~x86-mmconf-enable-mcfg-early
+++ a/arch/x86/pci/mmconfig-shared.c
@@ -274,7 +274,7 @@ static int __init is_acpi_reserved(unsig
 	return mcfg_res.flags;
 }
 
-static void __init pci_mmcfg_reject_broken(void)
+static void __init pci_mmcfg_reject_broken(int type, int early)
 {
 	typeof(pci_mmcfg_config[0]) *cfg;
 	int i;
@@ -299,34 +299,43 @@ static void __init pci_mmcfg_reject_brok
 	}
 
 	for (i = 0; i < pci_mmcfg_config_num; i++) {
+		int valid = 0;
 		u32 size = (cfg->end_bus_number + 1) << 20;
 		cfg = &pci_mmcfg_config[i];
-		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lu "
+		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "
 		       "segment %hu buses %u - %u\n",
 		       i, (unsigned long)cfg->address, cfg->pci_segment,
 		       (unsigned int)cfg->start_bus_number,
 		       (unsigned int)cfg->end_bus_number);
+
+		if (!early)
 		if (is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
 			printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
 			       "in ACPI motherboard resources\n",
 			       cfg->address);
-		} else {
+			valid = 1;
+		}
+
+		if (valid)
+			continue;
+
+		if (!early)
 			printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
 			       " reserved in ACPI motherboard resources\n",
 			       cfg->address);
-			/* Don't try to do this check unless configuration
-			   type 1 is available. */
-			if ((pci_probe & PCI_PROBE_CONF1) &&
-			    e820_all_mapped(cfg->address,
-					    cfg->address + size - 1,
-					    E820_RESERVED))
-				printk(KERN_NOTICE
-				       "PCI: MCFG area at %Lx reserved in "
-				       "E820\n",
-				       cfg->address);
-			else
-				goto reject;
+		/* Don't try to do this check unless configuration
+		   type 1 is available. */
+		if (type == 1 && e820_all_mapped(cfg->address,
+						  cfg->address + size - 1,
+						  E820_RESERVED)) {
+			printk(KERN_NOTICE
+			       "PCI: MCFG area at %Lx reserved in E820\n",
+			       cfg->address);
+			valid = 1;
 		}
+
+		if (!valid)
+			goto reject;
 	}
 
 	return;
@@ -339,46 +348,37 @@ reject:
 	pci_mmcfg_config_num = 0;
 }
 
-void __init pci_mmcfg_early_init(int type)
-{
-	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
-		return;
-
-	/* If type 1 access is available, no need to enable MMCONFIG yet, we can
-	   defer until later when the ACPI interpreter is available to better
-	   validate things. */
-	if (type == 1)
-		return;
-
-	acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
-
-	if ((pci_mmcfg_config_num == 0) ||
-	    (pci_mmcfg_config == NULL) ||
-	    (pci_mmcfg_config[0].address == 0))
-		return;
-
-	if (pci_mmcfg_arch_init())
-		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-}
+static int __initdata known_bridge;
 
-void __init pci_mmcfg_late_init(void)
+void __init __pci_mmcfg_init(int type, int early)
 {
-	int known_bridge = 0;
-
 	/* MMCONFIG disabled */
 	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
 		return;
 
 	/* MMCONFIG already enabled */
+	if (!early)
 	if (!(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
 		return;
 
-	if ((pci_probe & PCI_PROBE_CONF1) && pci_mmcfg_check_hostbridge())
-		known_bridge = 1;
-	else
-		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
+	/* for late to exit */
+	if (known_bridge)
+		return;
 
-	pci_mmcfg_reject_broken();
+	if (early && type == 1) {
+		if (pci_mmcfg_check_hostbridge())
+			known_bridge = 1;
+#if 0
+	/* check e820 in late? */
+		else
+			return;
+#endif
+	}
+
+	if (!known_bridge) {
+		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
+		pci_mmcfg_reject_broken(type, early);
+	}
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
@@ -386,10 +386,11 @@ void __init pci_mmcfg_late_init(void)
 		return;
 
 	if (pci_mmcfg_arch_init()) {
-		if (pci_probe & PCI_PROBE_CONF1)
+		if (type == 1)
 			unreachable_devices();
 		if (known_bridge)
 			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
+
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
 	} else {
 		/*
@@ -400,6 +401,21 @@ void __init pci_mmcfg_late_init(void)
 	}
 }
 
+void __init pci_mmcfg_early_init(int type)
+{
+	__pci_mmcfg_init(type, 1);
+}
+
+void __init pci_mmcfg_late_init(void)
+{
+	int type = 0;
+
+	if (pci_probe & PCI_PROBE_CONF1)
+		type = 1;
+
+	__pci_mmcfg_init(type, 0);
+}
+
 static int __init pci_mmcfg_late_insert_resources(void)
 {
 	/*
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
