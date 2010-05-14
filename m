From: akpm@linux-foundation.org
Subject: [obsolete] x86-pci-do-not-expect-pci-devices-to-return-zeroes-in-pcie-space.patch removed from -mm tree
Date: Fri, 14 May 2010 16:02:25 -0700
Message-ID: <201005142302.o4EN2PiU027721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab0ENXCt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 May 2010 19:02:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: petr@vandrovec.name, hpa@zytor.com, jacob.jun.pan@intel.com, jbarnes@virtuousgeek.org, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86/pci: do not expect PCI devices to return zeroes in PCIe space
has been removed from the -mm tree.  Its filename was
     x86-pci-do-not-expect-pci-devices-to-return-zeroes-in-pcie-space.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86/pci: do not expect PCI devices to return zeroes in PCIe space
From: Petr Vandrovec <petr@vandrovec.name>

openSUSE11.3 32bit kernels hang when installed to the VMware's VMs because
Moorestown fixed capabilities detection code enters endless loop on
Intel's AGP bridges (with device ID=7191).

There is no reason why old pre-PCIe/PCI-X devices should return zeroes
when configuration space above 0x100 is accessed.  If these devices decode
just low 8 bits of register number, conventional space repeats 15 times in
PCIe config space.  And Moorestown parser for fixed bars then can enter
endless loop when finding Intel AGP bridge device 0x7191 with secondary
latency timer programmed to 0x40 - when such device is encountered, code
will enter endless loop of reading registers 0x718 (reading 0x40010100)
and 0x400 (reading 0x71918086).

This change adds additional condition to the test: if device id/vendor
match first PCIe capability, then device is not really PCIe.  It should
not cause any problems: fixed_bar_cap is invoked only on Intel's devices,
so only time there is possibilty to have false match would be if first
PCIe capability would have ID 0x8086, and even then that address of next
capability pointer and capability version will match device ID seems
highly unlikely.

This fix unbreaks 32bit 2.6.33+ kernels configured with Moorestown support
to boot on AMD rev 10h+ processors under VMware in VMs which lack PCIe
support.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=15888

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jacob Pan <jacob.jun.pan@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/mrst.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/x86/pci/mrst.c~x86-pci-do-not-expect-pci-devices-to-return-zeroes-in-pcie-space arch/x86/pci/mrst.c
--- a/arch/x86/pci/mrst.c~x86-pci-do-not-expect-pci-devices-to-return-zeroes-in-pcie-space
+++ a/arch/x86/pci/mrst.c
@@ -55,12 +55,16 @@ static int fixed_bar_cap(struct pci_bus 
 {
 	int pos;
 	u32 pcie_cap = 0, cap_data;
+	u32 devid;
 
 	pos = PCIE_CAP_OFFSET;
 
 	if (!raw_pci_ext_ops)
 		return 0;
 
+	if (raw_pci_ops->read(pci_domain_nr(bus), bus->number, devfn, 0, 4, &devid))
+		return 0;
+
 	while (pos) {
 		if (raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
 					  devfn, pos, 4, &pcie_cap))
@@ -69,6 +73,9 @@ static int fixed_bar_cap(struct pci_bus 
 		if (pcie_cap == 0xffffffff)
 			return 0;
 
+		if (pcie_cap == devid && pos == PCIE_CAP_OFFSET)
+			return 0;
+
 		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
 			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
 					      devfn, pos + 4, 4, &cap_data);
_

Patches currently in -mm which might be from petr@vandrovec.name are

x86-pci-do-not-expect-pci-devices-to-return-zeroes-in-pcie-space.patch

