From: akpm@osdl.org
Subject: + pci-mmconfig-reserve-resources-but-only-when-were-sure-about-them.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:37:29 -0800
Message-ID: <200612101937.kBAJbTEq001076@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762389AbWLJThk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:37:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: galibert@pobox.com, ak@suse.de


The patch titled
     PCI MMConfig: Reserve resources but only when we're sure about them.
has been added to the -mm tree.  Its filename is
     pci-mmconfig-reserve-resources-but-only-when-were-sure-about-them.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PCI MMConfig: Reserve resources but only when we're sure about them.
From: Olivier Galibert <galibert@pobox.com>

Put back the resource reservation as per
4c6e052adfe285ede5884e4e8c4d33af33932c13 but use it *only* when the range(s)
come from a chipset probe instead of the bios.

Signed-off-by: Olivier Galibert <galibert@pobox.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/pci/mmconfig-shared.c |   33 ++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN arch/i386/pci/mmconfig-shared.c~pci-mmconfig-reserve-resources-but-only-when-were-sure-about-them arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~pci-mmconfig-reserve-resources-but-only-when-were-sure-about-them
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -159,6 +159,37 @@ static int __init pci_mmcfg_check_hostbr
 	return name != NULL;
 }
 
+static __init void pci_mmcfg_insert_resources(void)
+{
+#define PCI_MMCFG_RESOURCE_NAME_LEN 19
+	int i;
+	struct resource *res;
+	char *names;
+	unsigned num_buses;
+
+	res = kcalloc(PCI_MMCFG_RESOURCE_NAME_LEN + sizeof(*res),
+			pci_mmcfg_config_num, GFP_KERNEL);
+
+	if (!res) {
+		printk(KERN_ERR "PCI: Unable to allocate MMCONFIG resources\n");
+		return;
+	}
+
+	names = (void *)&res[pci_mmcfg_config_num];
+	for (i = 0; i < pci_mmcfg_config_num; i++, res++) {
+		num_buses = pci_mmcfg_config[i].end_bus_number -
+		    pci_mmcfg_config[i].start_bus_number + 1;
+		res->name = names;
+		snprintf(names, PCI_MMCFG_RESOURCE_NAME_LEN, "PCI MMCONFIG %u",
+			pci_mmcfg_config[i].pci_segment_group_number);
+		res->start = pci_mmcfg_config[i].base_address;
+		res->end = res->start + (num_buses << 20) - 1;
+		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+		insert_resource(&iomem_resource, res);
+		names += PCI_MMCFG_RESOURCE_NAME_LEN;
+	}
+}
+
 void __init pci_mmcfg_init(int type)
 {
 	int known_bridge = 0;
@@ -192,6 +223,8 @@ void __init pci_mmcfg_init(int type)
 	if (pci_mmcfg_arch_init()) {
 		if (type == 1)
 			unreachable_devices();
+		if (known_bridge)
+			pci_mmcfg_insert_resources();
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
 	}
 }
_

Patches currently in -mm which might be from galibert@pobox.com are

pci-mmconfig-share-whats-shareable.patch
pci-mmconfig-only-call-unreachable_devices-when-type-1-is-available.patch
pci-mmconfig-only-map-whats-necessary.patch
pci-mmconfig-detect-and-support-the-e7520-and-the-945g-gz-p-pl.patch
pci-mmconfig-reserve-resources-but-only-when-were-sure-about-them.patch

