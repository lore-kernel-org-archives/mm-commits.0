From: akpm@linux-foundation.org
Subject: - pci-fix-section-mismatch-warning-in-pci_scan_child_bus.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:09:26 -0800
Message-ID: <200803042009.m24K9QYZ026751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbYCDUJg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:09:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pci: fix section mismatch warning in pci_scan_child_bus
has been removed from the -mm tree.  Its filename was
     pci-fix-section-mismatch-warning-in-pci_scan_child_bus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: fix section mismatch warning in pci_scan_child_bus
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.text+0x47bdb1): Section mismatch in reference from the function pci_scan_child_bus() to the function .devinit.text:pcibios_fixup_bus()

We had plenty of functions that could be annotated __devinit but due to the
former restriction that annotated symbols could not be annotated they were not
so.

So annotate these function and fix the references from the pci/hotplug/* code
to silence the resuting warnings.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug-pci.c              |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c     |    2 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c |    2 +-
 drivers/pci/hotplug/pciehp_pci.c       |    2 +-
 drivers/pci/hotplug/shpchp_pci.c       |    2 +-
 drivers/pci/probe.c                    |    8 ++++----
 6 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/pci/hotplug-pci.c~pci-fix-section-mismatch-warning-in-pci_scan_child_bus drivers/pci/hotplug-pci.c
--- a/drivers/pci/hotplug-pci.c~pci-fix-section-mismatch-warning-in-pci_scan_child_bus
+++ a/drivers/pci/hotplug-pci.c
@@ -4,7 +4,7 @@
 #include "pci.h"
 
 
-unsigned int pci_do_scan_bus(struct pci_bus *bus)
+unsigned int __devinit pci_do_scan_bus(struct pci_bus *bus)
 {
 	unsigned int max;
 
diff -puN drivers/pci/hotplug/acpiphp_glue.c~pci-fix-section-mismatch-warning-in-pci_scan_child_bus drivers/pci/hotplug/acpiphp_glue.c
--- a/drivers/pci/hotplug/acpiphp_glue.c~pci-fix-section-mismatch-warning-in-pci_scan_child_bus
+++ a/drivers/pci/hotplug/acpiphp_glue.c
@@ -1085,7 +1085,7 @@ static int acpiphp_bus_trim(acpi_handle 
  * This function should be called per *physical slot*,
  * not per each slot object in ACPI namespace.
  */
-static int enable_device(struct acpiphp_slot *slot)
+static int __ref enable_device(struct acpiphp_slot *slot)
 {
 	struct pci_dev *dev;
 	struct pci_bus *bus = slot->bridge->pci_bus;
diff -puN drivers/pci/hotplug/cpci_hotplug_pci.c~pci-fix-section-mismatch-warning-in-pci_scan_child_bus drivers/pci/hotplug/cpci_hotplug_pci.c
--- a/drivers/pci/hotplug/cpci_hotplug_pci.c~pci-fix-section-mismatch-warning-in-pci_scan_child_bus
+++ a/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -250,7 +250,7 @@ int cpci_led_off(struct slot* slot)
  * Device configuration functions
  */
 
-int cpci_configure_slot(struct slot* slot)
+int __ref cpci_configure_slot(struct slot* slot)
 {
 	struct pci_bus *parent;
 	int fn;
diff -puN drivers/pci/hotplug/pciehp_pci.c~pci-fix-section-mismatch-warning-in-pci_scan_child_bus drivers/pci/hotplug/pciehp_pci.c
--- a/drivers/pci/hotplug/pciehp_pci.c~pci-fix-section-mismatch-warning-in-pci_scan_child_bus
+++ a/drivers/pci/hotplug/pciehp_pci.c
@@ -167,7 +167,7 @@ static void program_fw_provided_values(s
 	}
 }
 
-static int pciehp_add_bridge(struct pci_dev *dev)
+static int __ref pciehp_add_bridge(struct pci_dev *dev)
 {
 	struct pci_bus *parent = dev->bus;
 	int pass, busnr, start = parent->secondary;
diff -puN drivers/pci/hotplug/shpchp_pci.c~pci-fix-section-mismatch-warning-in-pci_scan_child_bus drivers/pci/hotplug/shpchp_pci.c
--- a/drivers/pci/hotplug/shpchp_pci.c~pci-fix-section-mismatch-warning-in-pci_scan_child_bus
+++ a/drivers/pci/hotplug/shpchp_pci.c
@@ -96,7 +96,7 @@ static void program_fw_provided_values(s
 	}
 }
 
-int shpchp_configure_device(struct slot *p_slot)
+int __ref shpchp_configure_device(struct slot *p_slot)
 {
 	struct pci_dev *dev;
 	struct pci_bus *parent = p_slot->ctrl->pci_dev->subordinate;
diff -puN drivers/pci/probe.c~pci-fix-section-mismatch-warning-in-pci_scan_child_bus drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-fix-section-mismatch-warning-in-pci_scan_child_bus
+++ a/drivers/pci/probe.c
@@ -295,7 +295,7 @@ static void pci_read_bases(struct pci_de
 	}
 }
 
-void pci_read_bridge_bases(struct pci_bus *child)
+void __devinit pci_read_bridge_bases(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
 	u8 io_base_lo, io_limit_lo;
@@ -481,7 +481,7 @@ static void pci_fixup_parent_subordinate
  * them, we proceed to assigning numbers to the remaining buses in
  * order to avoid overlaps between old and new bus numbers.
  */
-int pci_scan_bridge(struct pci_bus *bus, struct pci_dev * dev, int max, int pass)
+int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev * dev, int max, int pass)
 {
 	struct pci_bus *child;
 	int is_cardbus = (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS);
@@ -1015,7 +1015,7 @@ int pci_scan_slot(struct pci_bus *bus, i
 	return nr;
 }
 
-unsigned int pci_scan_child_bus(struct pci_bus *bus)
+unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 {
 	unsigned int devfn, pass, max = bus->secondary;
 	struct pci_dev *dev;
@@ -1123,7 +1123,7 @@ err_out:
 	return NULL;
 }
 
-struct pci_bus *pci_scan_bus_parented(struct device *parent,
+struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {
 	struct pci_bus *b;
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-x86.patch
git-acpi.patch
git-alsa.patch
cpufreq-fix-section-mismatch-warnings.patch
drivers-base-cpu-fix-section-mismatch-in-cpucstore_online.patch
tags-add-menuconfig-symbols-as-well.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
pcmcia-annotate-cb_alloc-with-__ref.patch
scsi-fix-section-mismatch-in-aic94xx.patch
cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch
cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch
cpu-fix-section-mismatch-warnings-in-cpu_down.patch
cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch
tpm-fix-section-mismatch-warning.patch
serial-silence-section-mismatch-warnings-in-8250_pci.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
ipmi-remove-unused-target-and-action-in-makefile.patch

