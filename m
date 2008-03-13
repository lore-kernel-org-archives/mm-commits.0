From: akpm@linux-foundation.org
Subject: - pnp-disable-pnp-motherboard-resources-that-overlap-pci-bars.patch removed from -mm tree
Date: Thu, 13 Mar 2008 11:59:57 -0700
Message-ID: <200803131859.m2DIxvJY027994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559AbYCMTBs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:01:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, avuton@gmail.com, hancockr@shaw.ca, karl.bellve@umassmed.edu, lenb@kernel.org, mhall@mhcomputing.net, shaohua.li@intel.com, trenn@suse.de, wrie


The patch titled
     PNP: disable PNP motherboard resources that overlap PCI BARs
has been removed from the -mm tree.  Its filename was
     pnp-disable-pnp-motherboard-resources-that-overlap-pci-bars.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PNP: disable PNP motherboard resources that overlap PCI BARs
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Some BIOSes have PNP motherboard devices with resources that partially overlap
PCI BARs.  The PNP system driver claims these motherboard resources, which
prevents the normal PCI driver from requesting them later.

This patch disables the PNP resources that conflict with PCI BARs so they
won't be claimed by the PNP system driver.

Of course, this only works if PCI devices have already been enumerated. 
Currently this is the case because PCI devices are discovered before any PNP
init via this path:

    acpi_pci_root_init() -> acpi_pci_root_add() -> pci_acpi_scan_root() ->
	pci_scan_bus_parented() -> pci_scan_child_bus() -> ...

Avuton Olrich tested this and confirmed that it fixes his ALSA sound card (see
http://lkml.org/lkml/2008/1/27/168).

References:
    https://bugzilla.redhat.com/show_bug.cgi?id=280641
    https://bugzilla.redhat.com/show_bug.cgi?id=313491
    http://lkml.org/lkml/2008/1/9/449
    http://thread.gmane.org/gmane.linux.acpi.devel/27312
    http://lkml.org/lkml/2008/1/27/168

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Matthew Hall <mhall@mhcomputing.net>
Cc: Willem Riede <wriede@riede.org>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Karl Bellve <karl.bellve@umassmed.edu>
Cc: Avuton Olrich <avuton@gmail.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |   73 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff -puN drivers/pnp/quirks.c~pnp-disable-pnp-motherboard-resources-that-overlap-pci-bars drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-disable-pnp-motherboard-resources-that-overlap-pci-bars
+++ a/drivers/pnp/quirks.c
@@ -108,6 +108,77 @@ static void quirk_sb16audio_resources(st
 		       "pnp: SB audio device quirk - increasing port range\n");
 }
 
+
+#include <linux/pci.h>
+
+static void quirk_system_pci_resources(struct pnp_dev *dev)
+{
+	struct pci_dev *pdev = NULL;
+	resource_size_t pnp_start, pnp_end, pci_start, pci_end;
+	int i, j;
+
+	/*
+	 * Some BIOSes have PNP motherboard devices with resources that
+	 * partially overlap PCI BARs.  The PNP system driver claims these
+	 * motherboard resources, which prevents the normal PCI driver from
+	 * requesting them later.
+	 *
+	 * This patch disables the PNP resources that conflict with PCI BARs
+	 * so they won't be claimed by the PNP system driver.
+	 */
+	for_each_pci_dev(pdev) {
+		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+			if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM) ||
+			    pci_resource_len(pdev, i) == 0)
+				continue;
+
+			pci_start = pci_resource_start(pdev, i);
+			pci_end = pci_resource_end(pdev, i);
+			for (j = 0; j < PNP_MAX_MEM; j++) {
+				if (!pnp_mem_valid(dev, j) ||
+				    pnp_mem_len(dev, j) == 0)
+					continue;
+
+				pnp_start = pnp_mem_start(dev, j);
+				pnp_end = pnp_mem_end(dev, j);
+
+				/*
+				 * If the PNP region doesn't overlap the PCI
+				 * region at all, there's no problem.
+				 */
+				if (pnp_end < pci_start || pnp_start > pci_end)
+					continue;
+
+				/*
+				 * If the PNP region completely encloses (or is
+				 * at least as large as) the PCI region, that's
+				 * also OK.  For example, this happens when the
+				 * PNP device describes a bridge with PCI
+				 * behind it.
+				 */
+				if (pnp_start <= pci_start &&
+				    pnp_end >= pci_end)
+					continue;
+
+				/*
+				 * Otherwise, the PNP region overlaps *part* of
+				 * the PCI region, and that might prevent a PCI
+				 * driver from requesting its resources.
+				 */
+				dev_warn(&dev->dev, "mem resource "
+					"(0x%llx-0x%llx) overlaps %s BAR %d "
+					"(0x%llx-0x%llx), disabling\n",
+					(unsigned long long) pnp_start,
+					(unsigned long long) pnp_end,
+					pci_name(pdev), i,
+					(unsigned long long) pci_start,
+					(unsigned long long) pci_end);
+				pnp_mem_flags(dev, j) = 0;
+			}
+		}
+	}
+}
+
 /*
  *  PnP Quirks
  *  Cards or devices that need some tweaking due to incomplete resource info
@@ -128,6 +199,8 @@ static struct pnp_fixup pnp_fixups[] = {
 	{"CTL0043", quirk_sb16audio_resources},
 	{"CTL0044", quirk_sb16audio_resources},
 	{"CTL0045", quirk_sb16audio_resources},
+	{"PNP0c01", quirk_system_pci_resources},
+	{"PNP0c02", quirk_system_pci_resources},
 	{""}
 };
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
git-acpi.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
pnp-use-dev_printk-for-quirk-messages.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch

