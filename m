From: akpm@linux-foundation.org
Subject: - hpet-force-enable-on-vt8235-37-chipsets.patch removed from -mm tree
Date: Tue, 11 Sep 2007 15:58:24 -0700
Message-ID: <200709112258.l8BMwOIx001551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49625 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760239AbXIKW7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 18:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: us15@os.inf.tu-dresden.de, ak@suse.de, greg@kroah.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     Force enable HPET on VT8235/8237 chipsets
has been removed from the -mm tree.  Its filename was
     hpet-force-enable-on-vt8235-37-chipsets.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: Force enable HPET on VT8235/8237 chipsets
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>

This patch adds quirks to force enable HPET on Via VT8235 and VT8237 chipse=
ts.  The datasheet for 8237 documents HPET functionality (although wrongly)
wher= eas HPET is undocumented for 8235.

Tested on A7V880 (8237) and K7VT4A+ (8235) boards.

Signed-off-by: Udo A. Steinberg <us15@os.inf.tu-dresden.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/quirks.c |   68 +++++++++++++++++++++++++++++++++++-
 1 files changed, 67 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/quirks.c~hpet-force-enable-on-vt8235-37-chipsets arch/i386/kernel/quirks.c
--- a/arch/i386/kernel/quirks.c~hpet-force-enable-on-vt8235-37-chipsets
+++ a/arch/i386/kernel/quirks.c
@@ -56,7 +56,8 @@ unsigned long force_hpet_address;
 static enum {
 	NONE_FORCE_HPET_RESUME,
 	OLD_ICH_FORCE_HPET_RESUME,
-	ICH_FORCE_HPET_RESUME
+	ICH_FORCE_HPET_RESUME,
+	VT8237_FORCE_HPET_RESUME
 } force_hpet_resume_type;
 
 static void __iomem *rcba_base;
@@ -245,6 +246,68 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801EB_12,
                          old_ich_force_enable_hpet);
 
+
+static void vt8237_force_hpet_resume(void)
+{
+	u32 val;
+
+	if (!force_hpet_address || !cached_dev)
+		return;
+
+	val = 0xfed00000 | 0x80;
+	pci_write_config_dword(cached_dev, 0x68, val);
+
+	pci_read_config_dword(cached_dev, 0x68, &val);
+	if (val & 0x80)
+		printk(KERN_DEBUG "Force enabled HPET at resume\n");
+	else
+		BUG();
+}
+
+static void vt8237_force_enable_hpet(struct pci_dev *dev)
+{
+	u32 uninitialized_var(val);
+
+	if (hpet_address || force_hpet_address)
+		return;
+
+	pci_read_config_dword(dev, 0x68, &val);
+	/*
+	 * Bit 7 is HPET enable bit.
+	 * Bit 31:10 is HPET base address (contrary to what datasheet claims)
+	 */
+	if (val & 0x80) {
+		force_hpet_address = (val & ~0x3ff);
+		printk(KERN_DEBUG "HPET at base address 0x%lx\n",
+			       force_hpet_address);
+		return;
+	}
+
+	/*
+	 * HPET is disabled. Trying enabling at FED00000 and check
+	 * whether it sticks
+	 */
+	val = 0xfed00000 | 0x80;
+	pci_write_config_dword(dev, 0x68, val);
+
+	pci_read_config_dword(dev, 0x68, &val);
+	if (val & 0x80) {
+		force_hpet_address = (val & ~0x3ff);
+		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+			       force_hpet_address);
+		cached_dev = dev;
+		force_hpet_resume_type = VT8237_FORCE_HPET_RESUME;
+		return;
+	}
+
+	printk(KERN_DEBUG "Failed to force enable HPET\n");
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8235,
+			 vt8237_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,
+			 vt8237_force_enable_hpet);
+
 void force_hpet_resume(void)
 {
 	switch (force_hpet_resume_type) {
@@ -254,6 +317,9 @@ void force_hpet_resume(void)
 	    case OLD_ICH_FORCE_HPET_RESUME:
 		return old_ich_force_hpet_resume();
 
+	    case VT8237_FORCE_HPET_RESUME:
+		return vt8237_force_hpet_resume();
+
 	    default:
 		break;
 	}
_

Patches currently in -mm which might be from us15@os.inf.tu-dresden.de are

hpet-force-enable-on-ich34.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
