From: akpm@linux-foundation.org
Subject: [merged] pci-update-pci_set_vga_state-to-call-arch-functions.patch removed from -mm tree
Date: Wed, 24 Feb 2010 11:39:45 -0800
Message-ID: <201002241939.o1OJdjx6016315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757843Ab0BXTkX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 14:40:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, holt@sgi.com, hpa@zytor.com, jbarnes@virtuousgeek.org, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     pci: update pci_set_vga_state() to call arch functions
has been removed from the -mm tree.  Its filename was
     pci-update-pci_set_vga_state-to-call-arch-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: update pci_set_vga_state() to call arch functions
From: Mike Travis <travis@sgi.com>

Update pci_set_vga_state to call arch dependent functions to enable Legacy
VGA I/O transactions to be redirected to correct target.

[akpm@linux-foundation.org: make pci_register_set_vga_state() __init]
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c   |   25 ++++++++++++++++++++++++-
 include/linux/pci.h |    5 +++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff -puN drivers/pci/pci.c~pci-update-pci_set_vga_state-to-call-arch-functions drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-update-pci_set_vga_state-to-call-arch-functions
+++ a/drivers/pci/pci.c
@@ -2754,6 +2754,23 @@ int pci_resource_bar(struct pci_dev *dev
 	return 0;
 }
 
+/* Some architectures require additional programming to enable VGA */
+static arch_set_vga_state_t arch_set_vga_state;
+
+void __init pci_register_set_vga_state(arch_set_vga_state_t func)
+{
+	arch_set_vga_state = func;	/* NULL disables */
+}
+
+static int pci_set_vga_state_arch(struct pci_dev *dev, bool decode,
+		      unsigned int command_bits, bool change_bridge)
+{
+	if (arch_set_vga_state)
+		return arch_set_vga_state(dev, decode, command_bits,
+						change_bridge);
+	return 0;
+}
+
 /**
  * pci_set_vga_state - set VGA decode state on device and parents if requested
  * @dev: the PCI device
@@ -2767,9 +2784,15 @@ int pci_set_vga_state(struct pci_dev *de
 	struct pci_bus *bus;
 	struct pci_dev *bridge;
 	u16 cmd;
+	int rc;
 
 	WARN_ON(command_bits & ~(PCI_COMMAND_IO|PCI_COMMAND_MEMORY));
 
+	/* ARCH specific VGA enables */
+	rc = pci_set_vga_state_arch(dev, decode, command_bits, change_bridge);
+	if (rc)
+		return rc;
+
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 	if (decode == true)
 		cmd |= command_bits;
@@ -2984,6 +3007,7 @@ EXPORT_SYMBOL(pcim_pin_device);
 EXPORT_SYMBOL(pci_disable_device);
 EXPORT_SYMBOL(pci_find_capability);
 EXPORT_SYMBOL(pci_bus_find_capability);
+EXPORT_SYMBOL(pci_register_set_vga_state);
 EXPORT_SYMBOL(pci_release_regions);
 EXPORT_SYMBOL(pci_request_regions);
 EXPORT_SYMBOL(pci_request_regions_exclusive);
@@ -3015,4 +3039,3 @@ EXPORT_SYMBOL(pci_target_state);
 EXPORT_SYMBOL(pci_prepare_to_sleep);
 EXPORT_SYMBOL(pci_back_from_sleep);
 EXPORT_SYMBOL_GPL(pci_set_pcie_reset_state);
