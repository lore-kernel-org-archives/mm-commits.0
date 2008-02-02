From: akpm@linux-foundation.org
Subject: - pci-fix-section-mismatch-warnings-referring-to-pci_do_scan_bus.patch removed from -mm tree
Date: Sat, 02 Feb 2008 02:34:45 -0800
Message-ID: <200802021034.m12AYQ2h027617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759209AbYBBKfF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 2 Feb 2008 05:35:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, bunk@kernel.org, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     pci: fix section mismatch warnings referring to pci_do_scan_bus
has been removed from the -mm tree.  Its filename was
     pci-fix-section-mismatch-warnings-referring-to-pci_do_scan_bus.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: fix section mismatch warnings referring to pci_do_scan_bus
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: o-x86_64/drivers/pci/built-in.o(.text+0xb054): Section mismatch in reference from the function cpci_configure_slot() to the function .devinit.text:pci_do_scan_bus()
WARNING: o-x86_64/drivers/pci/built-in.o(.text+0x153ab): Section mismatch in reference from the function shpchp_configure_device() to the function .devinit.text:pci_do_scan_bus()
WARNING: o-x86_64/drivers/pci/built-in.o(__ksymtab+0xc0): Section mismatch in reference from the variable __ksymtab_pci_do_scan_bus to the function .devinit.text:pci_do_scan_bus()

PCI hotplug were the only user of pci_do_scan_bus()
so moving this function to the directory of
PCI Hotplug was a logical way to fix so
we only include this function in the kernel
when the CONFIG_HOTPLUG_PCI is enabled.

Then the abuse of __devinit could be dropped and
we no longer trigger the above warnings.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/Makefile   |    1 +
 drivers/pci/hotplug/pci-core.c |   20 ++++++++++++++++++++
 drivers/pci/probe.c            |   15 ---------------
 3 files changed, 21 insertions(+), 15 deletions(-)

diff -puN drivers/pci/hotplug/Makefile~pci-fix-section-mismatch-warnings-referring-to-pci_do_scan_bus drivers/pci/hotplug/Makefile
--- a/drivers/pci/hotplug/Makefile~pci-fix-section-mismatch-warnings-referring-to-pci_do_scan_bus
+++ a/drivers/pci/hotplug/Makefile
@@ -1,6 +1,7 @@
 #
 # Makefile for the Linux kernel pci hotplug controller drivers.
 #
+obj-y := pci-core.o
 
 obj-$(CONFIG_HOTPLUG_PCI)		+= pci_hotplug.o
 obj-$(CONFIG_HOTPLUG_PCI_COMPAQ)	+= cpqphp.o
diff -puN /dev/null drivers/pci/hotplug/pci-core.c
--- /dev/null
+++ a/drivers/pci/hotplug/pci-core.c
@@ -0,0 +1,20 @@
+/* Core PCI functionality used only by PCI hotplug */
+
+#include <linux/pci.h>
+#include "../pci.h"
+
+
+unsigned int pci_do_scan_bus(struct pci_bus *bus)
+{
+	unsigned int max;
+
+	max = pci_scan_child_bus(bus);
+
+	/*
+	 * Make the discovered devices available.
+	 */
+	pci_bus_add_devices(bus);
+
+	return max;
+}
+EXPORT_SYMBOL(pci_do_scan_bus);
diff -puN drivers/pci/probe.c~pci-fix-section-mismatch-warnings-referring-to-pci_do_scan_bus drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-fix-section-mismatch-warnings-referring-to-pci_do_scan_bus
+++ a/drivers/pci/probe.c
@@ -1076,20 +1076,6 @@ unsigned int pci_scan_child_bus(struct p
 	return max;
 }
 
-unsigned int __devinit pci_do_scan_bus(struct pci_bus *bus)
-{
-	unsigned int max;
-
-	max = pci_scan_child_bus(bus);
-
-	/*
-	 * Make the discovered devices available.
-	 */
-	pci_bus_add_devices(bus);
-
-	return max;
-}
-
 struct pci_bus * pci_create_bus(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {
@@ -1176,7 +1162,6 @@ EXPORT_SYMBOL(pci_scan_bus_parented);
 
 #ifdef CONFIG_HOTPLUG
 EXPORT_SYMBOL(pci_add_new_bus);
-EXPORT_SYMBOL(pci_do_scan_bus);
 EXPORT_SYMBOL(pci_scan_slot);
 EXPORT_SYMBOL(pci_scan_bridge);
 EXPORT_SYMBOL_GPL(pci_scan_child_bus);
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
sdio-fix-module-device-table-definition-for-m68k.patch
hamradio-fix-dmascc-section-mismatch.patch
pci-fix-section-mismatch-warnings-referring-to-pci_do_scan_bus.patch
pci-fix-4x-section-mismatch-warnings.patch
git-x86.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
mm-fix-section-mismatch-warning-in-sparsec.patch
m68k-use-cc-cross-prefix.patch
cris-avoid-using-arch-links-in-kconfig.patch
uml-remove-topdir.patch
remove-support-for-un-needed-_extratext-section.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
kallsyms-should-prefer-non-weak-symbols.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
tpm-infineon-section-mismatch.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
linux-kernel-markers-create-modpost-file.patch
avoid-overflows-in-kernel-timec.patch
remove-__init_refok-and-__initdata_refok.patch
cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus.patch
cpu-fix-section-mismatch-related-to-cpu_chain.patch
cpu-do-not-annotate-exported-register_cpu_notifier.patch
cpu-silence-section-mismatch-warnings-for-hotcpu-notifies.patch
