From: akpm@linux-foundation.org
Subject: + x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron.patch added to -mm tree
Date: Wed, 12 Sep 2007 15:42:37 -0700
Message-ID: <200709122242.l8CMgb34022883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44718 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331AbXILWmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Sep 2007 18:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, yinghai.lu@Sun.COM


The patch titled
     x86_64: check MSR to get MMCONFIG for AMD Family 10h Opteron
has been added to the -mm tree.  Its filename is
     x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: check MSR to get MMCONFIG for AMD Family 10h Opteron
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

So even MCFG is not there, we still can use MMCONFIG.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/mmconfig-shared.c |   58 ++++++++++++++++++++++++++----
 1 files changed, 52 insertions(+), 6 deletions(-)

diff -puN arch/i386/pci/mmconfig-shared.c~x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -133,33 +133,79 @@ static const char __init *pci_mmcfg_inte
 	return "Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub";
 }
 
+static const char __init *pci_mmcfg_amd_fam10h(void)
+{
+	u32 low, high, address;
+	u64 base;
+	int i;
+	unsigned segnbits = 0, busnbits;
+
+	address = 0xc0010058;
+	if (rdmsr_safe(address, &low, &high))
+		return NULL;
+
+	/* mmconfig is not enable */
+	if (!(low & 1))
+		return NULL;
+
+	base = high & 0xffff;
+	base <<= 32;
+
+	busnbits = (low >> 2) & 0x0f;
+	if (busnbits > 8) {
+		segnbits = busnbits - 8;
+		busnbits = 8;
+	}
+
+	pci_mmcfg_config_num = (1 << segnbits);
+	pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]) * pci_mmcfg_config_num, GFP_KERNEL);
+	if (!pci_mmcfg_config)
+		return NULL;
+
+	for (i=0; i < (1 << segnbits); i++) {
+		pci_mmcfg_config[i].address = base + (1<<28) * i;
+		pci_mmcfg_config[i].pci_segment = i;
+		pci_mmcfg_config[i].start_bus_number = 0;
+		pci_mmcfg_config[i].end_bus_number = (1 << busnbits) - 1;
+	}
+
+	return "AMD Family 10h NB";
+}
+
 struct pci_mmcfg_hostbridge_probe {
+	u32 bus;
+	u32 devfn;
 	u32 vendor;
 	u32 device;
 	const char *(*probe)(void);
 };
 
 static struct pci_mmcfg_hostbridge_probe pci_mmcfg_probes[] __initdata = {
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
+	{ 0, PCI_DEVFN(0, 0), PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
+	{ 0, PCI_DEVFN(0, 0), PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
+	{ 0, PCI_DEVFN(0x18, 0), PCI_VENDOR_ID_AMD, 0x1200, pci_mmcfg_amd_fam10h },
+	{ 0xff, PCI_DEVFN(0, 0), PCI_VENDOR_ID_AMD, 0x1200, pci_mmcfg_amd_fam10h },
 };
 
 static int __init pci_mmcfg_check_hostbridge(void)
 {
 	u32 l;
+	u32 bus, devfn;
 	u16 vendor, device;
 	int i;
 	const char *name;
 
-	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0, 4, &l);
-	vendor = l & 0xffff;
-	device = (l >> 16) & 0xffff;
-
 	pci_mmcfg_config_num = 0;
 	pci_mmcfg_config = NULL;
 	name = NULL;
 
 	for (i = 0; !name && i < ARRAY_SIZE(pci_mmcfg_probes); i++) {
+		bus =  pci_mmcfg_probes[i].bus;
+		devfn = pci_mmcfg_probes[i].devfn;
+		pci_conf1_read(0, bus, devfn, 0, 4, &l);
+		vendor = l & 0xffff;
+		device = (l >> 16) & 0xffff;
+
 		if (pci_mmcfg_probes[i].vendor == vendor &&
 		    pci_mmcfg_probes[i].device == device)
 			name = pci_mmcfg_probes[i].probe();
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
serial-keep-the-dtr-setting-for-serial-console.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-make-io-apic-not-connected-pin-print-complete.patch
x86-use-num_online_nodes-to-get-physical-cpus-numbers-for.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
