From: akpm@linux-foundation.org
Subject: - pci-fix-4x-section-mismatch-warnings.patch removed from -mm tree
Date: Sun, 03 Feb 2008 12:22:31 -0800
Message-ID: <200802032022.m13KMCq8029994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbYBCUWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 15:22:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, bunk@kernel.org, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     pci: fix 4x section mismatch warnings
has been removed from the -mm tree.  Its filename was
     pci-fix-4x-section-mismatch-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: fix 4x section mismatch warnings
From: Sam Ravnborg <sam@ravnborg.org>

The following warnings were issued during build of
drivers/pci with an allyesconfig build:
WARNING: o-x86_64/drivers/pci/built-in.o(.text+0xdaf): Section mismatch in reference from the function pci_add_new_bus() to the function .devinit.text:pci_alloc_child_bus()
WARNING: o-x86_64/drivers/pci/built-in.o(.text+0x15e2): Section mismatch in reference from the function pci_scan_single_device() to the function .devinit.text:pci_scan_device()
WARNING: o-x86_64/drivers/pci/built-in.o(.text+0x1b0c5): Section mismatch in reference from the function pci_bus_assign_resources() to the function .devinit.text:pci_setup_bridge()
WARNING: o-x86_64/drivers/pci/built-in.o(.text+0x1b32d): Section mismatch in reference from the function pci_bus_size_bridges() to the function .devinit.text:pci_bus_size_cardbus()

Investigating each case closer it looked like all
referred functions are only used in the init phase
or during hotplug.
So to avoid wasting too much memory in the non-hotplug
case the simpler fix was to allow the fuctions to
use code/data from the __devinit sections.
This was done in all four case by adding the __ref
annotation.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c     |    4 ++--
 drivers/pci/setup-bus.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/pci/probe.c~pci-fix-4x-section-mismatch-warnings drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-fix-4x-section-mismatch-warnings
+++ a/drivers/pci/probe.c
@@ -452,7 +452,7 @@ pci_alloc_child_bus(struct pci_bus *pare
 	return child;
 }
 
-struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev, int busnr)
+struct pci_bus *__ref pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev, int busnr)
 {
 	struct pci_bus *child;
 
@@ -967,7 +967,7 @@ void pci_device_add(struct pci_dev *dev,
 	up_write(&pci_bus_sem);
 }
 
-struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn)
+struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
 {
 	struct pci_dev *dev;
 
diff -puN drivers/pci/setup-bus.c~pci-fix-4x-section-mismatch-warnings drivers/pci/setup-bus.c
--- a/drivers/pci/setup-bus.c~pci-fix-4x-section-mismatch-warnings
+++ a/drivers/pci/setup-bus.c
@@ -454,7 +454,7 @@ pci_bus_size_cardbus(struct pci_bus *bus
 	}
 }
 
-void pci_bus_size_bridges(struct pci_bus *bus)
+void __ref pci_bus_size_bridges(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 	unsigned long mask, prefmask;
@@ -509,7 +509,7 @@ void pci_bus_size_bridges(struct pci_bus
 }
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
-void pci_bus_assign_resources(struct pci_bus *bus)
+void __ref pci_bus_assign_resources(struct pci_bus *bus)
 {
 	struct pci_bus *b;
 	struct pci_dev *dev;
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
sdio-fix-module-device-table-definition-for-m68k.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
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
linux-kernel-markers-create-modpost-file.patch
avoid-overflows-in-kernel-timec.patch
cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus.patch
cpu-fix-section-mismatch-related-to-cpu_chain.patch
cpu-do-not-annotate-exported-register_cpu_notifier.patch
cpu-silence-section-mismatch-warnings-for-hotcpu-notifies.patch
