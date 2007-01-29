From: akpm@osdl.org
Subject: + powerpc-rtas-msi-support.patch added to -mm tree
Date: Mon, 29 Jan 2007 15:07:26 -0800
Message-ID: <200701292307.l0TN7QYH001986@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60992 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842AbXA2XHh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 18:07:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@ellerman.id.au, benh@kernel.crashing.org, ebiederm@xmission.com, paulus@samba.org


The patch titled
     PowerPC RTAS MSI support
has been added to the -mm tree.  Its filename is
     powerpc-rtas-msi-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PowerPC RTAS MSI support
From: Michael Ellerman <michael@ellerman.id.au>

This patch implements MSI and MSI-X support for PowerPC, using the RTAS
firmware interfaces.  The support is only enabled on machines which have
the required firmware tokens present - other systems will simply return an
error for every call to pci_enable_msi/x().

When using RTAS for MSI support, the firmware is entirely in control of the
setup of MSI, all operations occur via firmware calls.  As this isx
fundamentally incompatible with the current MSI code, which assumes it can
configure the device directly, for now we completely disable the existing
MSI code.  Discussion is ongoing on how to better integrate the two
approaches.

In order to match the Linux model, where MSI is disabled by default, we
need to check every device as it's found and disable MSI if it's been
pre-enabled by firmware.  For now we do that in pSeries_irq_bus_setup(), a
more flexible approach has already been merged in the powerpc tree.

This patch also includes the required incantations to inform firmware that
we support MSI.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/powerpc/kernel/Makefile           |    3 
 arch/powerpc/kernel/irq.c              |   28 -
 arch/powerpc/kernel/msi.c              |  494 +++++++++++++++++++++++
 arch/powerpc/kernel/prom_init.c        |    8 
 arch/powerpc/platforms/pseries/pci.c   |    1 
 arch/powerpc/platforms/pseries/setup.c |    2 
 drivers/pci/Kconfig                    |    2 
 drivers/pci/Makefile                   |    4 
 include/asm-powerpc/machdep.h          |    5 
 include/asm-powerpc/msi.h              |   50 ++
 include/linux/pci.h                    |    5 
 11 files changed, 566 insertions(+), 36 deletions(-)

diff -puN arch/powerpc/kernel/Makefile~powerpc-rtas-msi-support arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~powerpc-rtas-msi-support
+++ a/arch/powerpc/kernel/Makefile
@@ -65,6 +65,9 @@ obj-$(CONFIG_MODULES)		+= $(module-y)
 pci64-$(CONFIG_PPC64)		+= pci_64.o pci_dn.o
 pci32-$(CONFIG_PPC32)		:= pci_32.o
 obj-$(CONFIG_PCI)		+= $(pci64-y) $(pci32-y)
+
+obj-$(CONFIG_PCI_MSI)		+= msi.o
+
 kexec-$(CONFIG_PPC64)		:= machine_kexec_64.o
 kexec-$(CONFIG_PPC32)		:= machine_kexec_32.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o crash.o $(kexec-y)
diff -puN arch/powerpc/kernel/irq.c~powerpc-rtas-msi-support arch/powerpc/kernel/irq.c
--- a/arch/powerpc/kernel/irq.c~powerpc-rtas-msi-support
+++ a/arch/powerpc/kernel/irq.c
@@ -947,34 +947,6 @@ arch_initcall(irq_late_init);
 
 #endif /* CONFIG_PPC_MERGE */
 
-#ifdef CONFIG_PCI_MSI
-int pci_enable_msi(struct pci_dev * pdev)
-{
-	if (ppc_md.enable_msi)
-		return ppc_md.enable_msi(pdev);
-	else
-		return -1;
-}
-EXPORT_SYMBOL(pci_enable_msi);
-
-void pci_disable_msi(struct pci_dev * pdev)
-{
-	if (ppc_md.disable_msi)
-		ppc_md.disable_msi(pdev);
-}
-EXPORT_SYMBOL(pci_disable_msi);
-
-void pci_scan_msi_device(struct pci_dev *dev) {}
-int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec) {return -1;}
-void pci_disable_msix(struct pci_dev *dev) {}
-void msi_remove_pci_irq_vectors(struct pci_dev *dev) {}
-void disable_msi_mode(struct pci_dev *dev, int pos, int type) {}
-void pci_no_msi(void) {}
-EXPORT_SYMBOL(pci_enable_msix);
-EXPORT_SYMBOL(pci_disable_msix);
-
-#endif
-
 #ifdef CONFIG_PPC64
 static int __init setup_noirqdistrib(char *str)
 {
diff -puN /dev/null arch/powerpc/kernel/msi.c
--- /dev/null
+++ a/arch/powerpc/kernel/msi.c
@@ -0,0 +1,494 @@
+/*
+ * Copyright (C) 2006 Jake Moilanen <moilanen@austin.ibm.com>, IBM Corp.
+ * Copyright 2006-2007, Michael Ellerman, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+/* #define DEBUG 1 */
+
+#include <linux/kernel.h>
+#include <linux/msi.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/irq.h>
+#include <asm/msi.h>
+#include <asm/machdep.h>
+#include <asm/rtas.h>
+#include <asm/hw_irq.h>
+#include <asm/ppc-pci.h>
+
+/* Disabled by default */
+static int no_msi = 1;
+
+void pci_no_msi(void)
+{
+	printk(KERN_DEBUG "PCI MSI disabled on command line.\n");
+	no_msi++;
+}
+
+
+/* msi_info helpers */
+
+static int alloc_msi_info(struct pci_dev *pdev, int num,
+			  struct msix_entry *entries, int type)
+{
+	struct msi_info *info;
+	unsigned int entries_size;
+
+	entries_size = sizeof(struct msix_entry) * num;
+
+	info = kzalloc(sizeof(struct msi_info) + entries_size, GFP_KERNEL);
+	if (!info) {
+		msi_debug_dev(pdev, "kzalloc failed\n");
+		return -ENOMEM;
+	}
+
+	info->type = type;
+	info->num = num;
+	info->entries = (struct msix_entry *)(info + 1);
+
+	BUG_ON(pdev->msi_info); /* don't leak info structs */
+	pdev->msi_info = info;
+
+	return 0;
+}
+
+static void free_msi_info(struct pci_dev *pdev)
+{
+	kfree(pdev->msi_info);
+	pdev->msi_info = NULL;
+}
+
+
+/* RTAS Helpers */
+
+static int query_token, change_token;
+
+#define RTAS_QUERY_FN		0
+#define RTAS_CHANGE_FN		1
+#define RTAS_RESET_FN		2
+#define RTAS_CHANGE_MSI_FN	3
+#define RTAS_CHANGE_MSIX_FN	4
+
+static struct pci_dn *get_pdn(struct pci_dev *pdev)
+{
+	struct device_node *dn;
+	struct pci_dn *pdn;
+
+	dn = pci_device_to_OF_node(pdev);
+	if (!dn) {
+		msi_debug_dev(pdev, "No OF device node\n");
+		return NULL;
+	}
+
+	pdn = PCI_DN(dn);
+	if (!pdn) {
+		msi_debug_dev(pdev, "No PCI DN\n");
+		return NULL;
+	}
+
+	return pdn;
+}
+
+static int rtas_change_msi(struct pci_dn *pdn, u32 func, u32 num_irqs)
+{
+	u32 addr, seq_num, rtas_ret[3];
+	unsigned long buid;
+	int rc;
+
+	addr = rtas_config_addr(pdn->busno, pdn->devfn, 0);
+	buid = pdn->phb->buid;
+
+	seq_num = 1;
+	do {
+		if (func == RTAS_CHANGE_MSI_FN || func == RTAS_CHANGE_MSIX_FN)
+			rc = rtas_call(change_token, 6, 4, rtas_ret, addr,
+					BUID_HI(buid), BUID_LO(buid),
+					func, num_irqs, seq_num);
+		else
+			rc = rtas_call(change_token, 6, 3, rtas_ret, addr,
+					BUID_HI(buid), BUID_LO(buid),
+					func, num_irqs, seq_num);
+
+		seq_num = rtas_ret[1];
+	} while (rtas_busy_delay(rc));
+
+	if (rc) {
+		msi_debug("error (%d)\n", rc);
+		return rc;
+	}
+
+	return rtas_ret[0];
+}
+
+static void rtas_disable_msi(struct pci_dev *pdev)
+{
+	struct pci_dn *pdn;
+
+	pdn = get_pdn(pdev);
+	if (!pdn)
+		return;
+
+	if (rtas_change_msi(pdn, RTAS_CHANGE_FN, 0) != 0) {
+		msi_debug_dev(pdev, "Setting MSIs to 0 failed!\n");
+		BUG();
+	}
+}
+
+static int rtas_query_irq_number(struct pci_dn *pdn, int offset)
+{
+	u32 addr, rtas_ret[2];
+	unsigned long buid;
+	int rc;
+
+	addr = rtas_config_addr(pdn->busno, pdn->devfn, 0);
+	buid = pdn->phb->buid;
+
+	do {
+		rc = rtas_call(query_token, 4, 3, rtas_ret, addr,
+			       BUID_HI(buid), BUID_LO(buid), offset);
+	} while (rtas_busy_delay(rc));
+
+	if (rc) {
+		msi_debug("error (%d) querying source number\n", rc);
+		return rc;
+	}
+
+	return rtas_ret[0];
+}
+
+static void msi_rtas_free(struct pci_dev *pdev, int num,
+			struct msix_entry *entries, int type)
+{
+	int i;
+
+	for (i = 0; i < num; i++) {
+		irq_dispose_mapping(entries[i].vector);
+	}
+
+	rtas_disable_msi(pdev);
+}
+
+static int check_req_msi(struct pci_dev *pdev)
+{
+	struct device_node *dn;
+	struct pci_dn *pdn;
+	const u32 *req_msi;
+
+	pdn = get_pdn(pdev);
+	if (!pdn)
+		return -1;
+
+	dn = pdn->node;
+
+	req_msi = get_property(dn, "ibm,req#msi", NULL);
+	if (!req_msi) {
+		msi_debug_dev(pdev, "No ibm,req#msi\n");
+		return -1;
+	}
+
+	if (*req_msi == 0) {
+		msi_debug_dev(pdev, "ibm,req#msi requests 0 MSIs\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int msi_rtas_check(struct pci_dev *pdev, int num,
+			struct msix_entry *entries, int type)
+{
+	int i, rc;
+
+	rc = check_req_msi(pdev);
+	if (rc)
+		return rc;
+
+	/*
+	 * Firmware gives us no control over which entries are allocated
+	 * for MSI-X, it seems to assume we want 0 - n. For now just insist
+	 * that the entries array entry members are 0 - n.
+	 */
+	for (i = 0; i < num; i++) {
+		if (entries[i].entry != i) {
+			msi_debug_dev(pdev, "entries[%d].entry (%d) != %d\n", i,
+					entries[i].entry, i);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+static int msi_rtas_alloc(struct pci_dev *pdev, int num,
+			struct msix_entry *entries, int type)
+{
+	struct pci_dn *pdn;
+	int hwirq, virq, i, rc;
+
+	pdn = get_pdn(pdev);
+	if (!pdn)
+		return -1;
+
+	/*
+	 * Try the new more explicit firmware interface, if that fails fall
+	 * back to the old interface. The old interface is known to never
+	 * return MSI-Xs.
+	 */
+	if (type == PCI_CAP_ID_MSI) {
+		rc = rtas_change_msi(pdn, RTAS_CHANGE_MSI_FN, num);
+
+		if (rc != num) {
+			msi_debug_dev(pdev, "trying the old firmware "
+				      "interface.\n");
+			rc = rtas_change_msi(pdn, RTAS_CHANGE_FN, num);
+		}
+	} else
+		rc = rtas_change_msi(pdn, RTAS_CHANGE_MSIX_FN, num);
+
+	if (rc != num) {
+		msi_debug_dev(pdev, "rtas_change_msi() failed\n");
+
+		/*
+		 * In case of an error it's not clear whether the device is
+		 * left with MSI enabled or not, so we explicitly disable.
+		 */
+		goto out_free;
+	}
+
+	for (i = 0; i < num; i++) {
+		hwirq = rtas_query_irq_number(pdn, i);
+		if (hwirq < 0) {
+			msi_debug_dev(pdev, "error (%d) getting hwirq\n",
+				      hwirq);
+			goto out_free;
+		}
+
+		virq = irq_create_mapping(NULL, hwirq);
+
+		if (virq == NO_IRQ) {
+			msi_debug_dev(pdev, "Failed mapping hwirq %d\n", hwirq);
+			goto out_free;
+		}
+
+		entries[i].vector = virq;
+	}
+
+	return 0;
+
+ out_free:
+	msi_rtas_free(pdev, num, entries, type);
+	return -1;
+}
+
+void msi_rtas_pci_irq_fixup(struct pci_dev *pdev)
+{
+	/* No LSI -> leave MSIs (if any) configured */
+	if (pdev->irq == NO_IRQ) {
+		msi_debug_dev(pdev, "no LSI, nothing to do.\n");
+		return;
+	}
+
+	/* No MSI -> MSIs can't have been assigned by fw, leave LSI */
+	if (check_req_msi(pdev)) {
+		msi_debug_dev(pdev, "no req#msi, nothing to do.\n");
+		return;
+	}
+
+	msi_debug_dev(pdev, "disabling existing MSI\n");
+	rtas_disable_msi(pdev);
+}
+
+int msi_rtas_init(void)
+{
+	query_token  = rtas_token("ibm,query-interrupt-source-number");
+	change_token = rtas_token("ibm,change-msi");
+
+	if ((query_token == RTAS_UNKNOWN_SERVICE) ||
+			(change_token == RTAS_UNKNOWN_SERVICE)) {
+		msi_debug("Couldn't find RTAS tokens, no MSI support.\n");
+		return -1;
+	}
+
+	msi_debug("Using RTAS MSI.\n");
+	no_msi--;
+
+	return 0;
+}
+
+/* Generic helpers */
+
+static int msi_supported(struct pci_dev *pdev)
+{
+	if (!pdev) {
+		msi_debug("NULL pci dev!\n");
+		return -1;
+	}
+
+	if (no_msi) {
+		msi_debug_dev(pdev, "MSI globally disabled.\n");
+		return -2;
+	}
+
+	if (pdev->no_msi) {
+		msi_debug_dev(pdev, "MSI disabled for this device.\n");
+		return -3;
+	}
+
+	return 0;
+}
+
+static int generic_msi_enable(struct pci_dev *pdev, int nvec,
+				struct msix_entry *entries, int type)
+{
+	int i, rc;
+
+	rc = msi_supported(pdev);
+	if (rc)
+		return rc;
+
+	if (!entries || !nvec) {
+		msi_debug_dev(pdev, "bad entries/nvec (%p/%d)\n", entries, nvec);
+		return -EINVAL;
+	}
+
+	if (pdev->msi_info) {
+		/* XXX Can we make this idempotent? */
+		msi_debug_dev(pdev, "msi_info already exists, bailing.\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < nvec; i++)
+		entries[i].vector = NO_IRQ;
+
+	rc = msi_rtas_check(pdev, nvec, entries, type);
+	if (rc) {
+		msi_debug_dev(pdev, "check failed (%d)\n", rc);
+		return rc;
+	}
+
+	rc = alloc_msi_info(pdev, nvec, entries, type);
+	if (rc)
+		return rc;
+
+	rc = msi_rtas_alloc(pdev, nvec, entries, type);
+	if (rc) {
+		msi_debug_dev(pdev, "alloc failed (%d)\n", rc);
+		goto out_free_info;
+	}
+
+	/* Copy the updated entries into the msi_info */
+	memcpy(pdev->msi_info->entries, entries,
+			sizeof(struct msix_entry) * nvec);
+	pci_intx(pdev, 0);
+
+	return 0;
+
+ out_free_info:
+	free_msi_info(pdev);
+
+	return rc;
+}
+
+static int generic_msi_disable(struct pci_dev *pdev, int type)
+{
+	struct msi_info *info;
+	int rc;
+
+	rc = msi_supported(pdev);
+	if (rc)
+		return rc;
+
+	info = pdev->msi_info;
+	if (!info) {
+		msi_debug_dev(pdev, "no info\n");
+		return -1;
+	}
+
+	msi_rtas_free(pdev, info->num, info->entries, type);
+
+	pci_intx(pdev, 1);
+
+	return 0;
+}
+
+
+/* MSI */
+
+int pci_enable_msi(struct pci_dev *pdev)
+{
+	struct msix_entry entry;
+	int rc;
+
+	entry.entry = 0;
+
+	rc = generic_msi_enable(pdev, 1, &entry, PCI_CAP_ID_MSI);
+	if (rc)
+		return rc;
+
+	pdev->msi_info->saved_irq = pdev->irq;
+	pdev->irq = entry.vector;
+	pdev->msi_enabled = 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_enable_msi);
+
+void pci_disable_msi(struct pci_dev *pdev)
+{
+	if (generic_msi_disable(pdev, PCI_CAP_ID_MSI) != 0)
+		return;
+
+	pdev->irq = pdev->msi_info->saved_irq;
+	free_msi_info(pdev);
+	pdev->msi_enabled = 0;
+}
+EXPORT_SYMBOL_GPL(pci_disable_msi);
+
+
+/* MSI-X */
+
+int pci_enable_msix(struct pci_dev *pdev, struct msix_entry *entries, int nvec)
+{
+	int rc;
+
+	rc = generic_msi_enable(pdev, nvec, entries, PCI_CAP_ID_MSIX);
+	if (rc)
+		return rc;
+
+	pdev->msix_enabled = 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_enable_msix);
+
+void pci_disable_msix(struct pci_dev *pdev)
+{
+	if (generic_msi_disable(pdev, PCI_CAP_ID_MSIX) != 0)
+		return;
+
+	free_msi_info(pdev);
+	pdev->msix_enabled = 0;
+}
+EXPORT_SYMBOL_GPL(pci_disable_msix);
+
+
+/* Stubs for now */
+
+void disable_msi_mode(struct pci_dev *dev, int pos, int type)
+{
+	return;
+}
+
+void pci_scan_msi_device(struct pci_dev *dev)
+{
+	return;
+}
+
+void msi_remove_pci_irq_vectors(struct pci_dev* dev)
+{
+	return;
+}
diff -puN arch/powerpc/kernel/prom_init.c~powerpc-rtas-msi-support arch/powerpc/kernel/prom_init.c
--- a/arch/powerpc/kernel/prom_init.c~powerpc-rtas-msi-support
+++ a/arch/powerpc/kernel/prom_init.c
@@ -635,6 +635,12 @@ static void __init early_cmdline_parse(v
 /* ibm,dynamic-reconfiguration-memory property supported */
 #define OV5_DRCONF_MEMORY	0x20
 #define OV5_LARGE_PAGES		0x10	/* large pages supported */
+/* PCIe/MSI support.  Without MSI full PCIe is not supported */
+#ifdef CONFIG_PCI_MSI
+#define OV5_MSI			0x01	/* PCIe/MSI support */
+#else
+#define OV5_MSI			0x00
+#endif /* CONFIG_PCI_MSI */
 
 /*
  * The architecture vector has an array of PVR mask/value pairs,
@@ -679,7 +685,7 @@ static unsigned char ibm_architecture_ve
 	/* option vector 5: PAPR/OF options */
 	3 - 2,				/* length */
 	0,				/* don't ignore, don't halt */
-	OV5_LPAR | OV5_SPLPAR | OV5_LARGE_PAGES | OV5_DRCONF_MEMORY,
+	OV5_LPAR | OV5_SPLPAR | OV5_LARGE_PAGES | OV5_DRCONF_MEMORY | OV5_MSI,
 };
 
 /* Old method - ELF header with PT_NOTE sections */
diff -puN arch/powerpc/platforms/pseries/pci.c~powerpc-rtas-msi-support arch/powerpc/platforms/pseries/pci.c
--- a/arch/powerpc/platforms/pseries/pci.c~powerpc-rtas-msi-support
+++ a/arch/powerpc/platforms/pseries/pci.c
@@ -50,6 +50,7 @@ void pcibios_name_device(struct pci_dev 
 				dev->dev.name[sizeof(dev->dev.name)-1] = '\0';
 			}
 		}
+		msi_rtas_pci_irq_fixup(dev);
 	}
 }   
 DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, pcibios_name_device);
diff -puN arch/powerpc/platforms/pseries/setup.c~powerpc-rtas-msi-support arch/powerpc/platforms/pseries/setup.c
--- a/arch/powerpc/platforms/pseries/setup.c~powerpc-rtas-msi-support
+++ a/arch/powerpc/platforms/pseries/setup.c
@@ -65,6 +65,7 @@
 #include <asm/i8259.h>
 #include <asm/udbg.h>
 #include <asm/smp.h>
+#include <asm/msi.h>
 
 #include "plpar_wrappers.h"
 #include "ras.h"
@@ -284,6 +285,7 @@ static void __init pseries_discover_pic(
 #ifdef CONFIG_SMP
 			smp_init_pseries_xics();
 #endif
+			msi_rtas_init();
 			return;
 		}
 	}
diff -puN drivers/pci/Kconfig~powerpc-rtas-msi-support drivers/pci/Kconfig
--- a/drivers/pci/Kconfig~powerpc-rtas-msi-support
+++ a/drivers/pci/Kconfig
@@ -4,7 +4,7 @@
 config PCI_MSI
 	bool "Message Signaled Interrupts (MSI and MSI-X)"
 	depends on PCI
-	depends on (X86_LOCAL_APIC && X86_IO_APIC) || IA64
+	depends on (X86_LOCAL_APIC && X86_IO_APIC) || IA64 || (PPC_MERGE && PPC_RTAS)
 	help
 	   This allows device drivers to enable MSI (Message Signaled
 	   Interrupts).  Message Signaled Interrupts enable a device to
diff -puN drivers/pci/Makefile~powerpc-rtas-msi-support drivers/pci/Makefile
--- a/drivers/pci/Makefile~powerpc-rtas-msi-support
+++ a/drivers/pci/Makefile
@@ -14,8 +14,10 @@ obj-$(CONFIG_HOTPLUG) += hotplug.o
 # Build the PCI Hotplug drivers if we were asked to
 obj-$(CONFIG_HOTPLUG_PCI) += hotplug/
 
-# Build the PCI MSI interrupt support
+# Build the PCI MSI interrupt support, but not for arch/powerpc
+ifndef CONFIG_PPC_MERGE
 obj-$(CONFIG_PCI_MSI) += msi.o
+endif
 
 # Build the Hypertransport interrupt support
 obj-$(CONFIG_HT_IRQ) += htirq.o
diff -puN include/asm-powerpc/machdep.h~powerpc-rtas-msi-support include/asm-powerpc/machdep.h
--- a/include/asm-powerpc/machdep.h~powerpc-rtas-msi-support
+++ a/include/asm-powerpc/machdep.h
@@ -243,11 +243,6 @@ struct machdep_calls {
 	 */
 	void (*machine_kexec)(struct kimage *image);
 #endif /* CONFIG_KEXEC */
-
-#ifdef CONFIG_PCI_MSI
-	int (*enable_msi)(struct pci_dev *pdev);
-	void (*disable_msi)(struct pci_dev *pdev);
-#endif /* CONFIG_PCI_MSI */
 };
 
 extern void power4_idle(void);
diff -puN /dev/null include/asm-powerpc/msi.h
--- /dev/null
+++ a/include/asm-powerpc/msi.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright 2006-2007, Michael Ellerman, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_POWERPC_MSI_H
+#define _ASM_POWERPC_MSI_H
+
+#include <linux/pci.h>
+#include <linux/msi.h>
+
+/**
+ * struct msi_info - MSI state information.
+ *
+ * @type: The type of MSI, PCI_CAP_ID_MSI or PCI_CAP_ID_MSIX.
+ * @saved_irq: Saved LSI irq that was originally in dev->irq.
+ * @num: The number of MSIs assigned to the device.
+ * @entries: Array of msix_entry structs, one per MSI.
+ * @msix_base: Base of the MSI-X table.
+ *
+ * Records the state of any MSIs allocated to a pci_dev.
+ */
+struct msi_info {
+	int type;
+	unsigned int saved_irq;
+	unsigned int num;
+	struct msix_entry *entries;
+	void __iomem *msix_base;
+};
+
+#define msi_debug(fmt, args...)	\
+	pr_debug("MSI:%s:%d: " fmt, __FUNCTION__, __LINE__, ## args)
+
+/* Use this if you have a pci dev handy */
+#define msi_debug_dev(pdev, fmt, args...)	\
+	dev_dbg(&pdev->dev, "MSI:%s:%d: " fmt, __FUNCTION__, __LINE__, ## args)
+
+#ifdef CONFIG_PCI_MSI
+extern int msi_rtas_init(void);
+extern void msi_rtas_pci_irq_fixup(struct pci_dev *pdev);
+#else
+static inline int msi_rtas_init(void) { return -1; };
+static inline void msi_rtas_pci_irq_fixup(struct pci_dev *pdev) { };
+#endif
+
+#endif /* _ASM_POWERPC_MSI_H */
diff -puN include/linux/pci.h~powerpc-rtas-msi-support include/linux/pci.h
--- a/include/linux/pci.h~powerpc-rtas-msi-support
+++ a/include/linux/pci.h
@@ -107,6 +107,8 @@ struct pci_cap_saved_state {
 	u32 data[0];
 };
 
+struct msi_info;
+
 /*
  * The pci_dev structure is used to describe PCI devices.
  */
@@ -174,6 +176,9 @@ struct pci_dev {
 	struct bin_attribute *rom_attr; /* attribute descriptor for sysfs ROM entry */
 	int rom_attr_enabled;		/* has display of the rom attribute been enabled? */
 	struct bin_attribute *res_attr[DEVICE_COUNT_RESOURCE]; /* sysfs file for resources */
+#if defined(CONFIG_PCI_MSI) && defined(CONFIG_PPC_MERGE)
+	struct	msi_info *msi_info;
+#endif
 };
 
 #define pci_dev_g(n) list_entry(n, struct pci_dev, global_list)
_

Patches currently in -mm which might be from michael@ellerman.id.au are

powerpc-rtas-msi-support.patch
