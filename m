From: akpm@linux-foundation.org
Subject: - ich-force-hpet-ich5-quirk-to-force-detect-enable.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:18:43 -0700
Message-ID: <200710150918.l9F9IhJ2027434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760429AbXJOJ0b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:26:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, ak@suse.de, greg@kroah.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ich force hpet: ich5 quirk to force detect enable
has been removed from the -mm tree.  Its filename was
     ich-force-hpet-ich5-quirk-to-force-detect-enable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ich force hpet: ich5 quirk to force detect enable
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

force_enable hpet for ICH5.

[akpm@linux-foundation.org: fix use-uninitialised warnings]
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c   |    2 
 arch/i386/kernel/quirks.c |  103 +++++++++++++++++++++++++++++++++++-
 include/asm-i386/hpet.h   |    2 
 include/linux/pci_ids.h   |    1 
 4 files changed, 105 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/hpet.c~ich-force-hpet-ich5-quirk-to-force-detect-enable arch/i386/kernel/hpet.c
--- a/arch/x86/kernel/hpet_32.c~ich-force-hpet-ich5-quirk-to-force-detect-enable
+++ a/arch/x86/kernel/hpet_32.c
@@ -181,7 +181,7 @@ static void hpet_start_counter(void)
 
 static void hpet_resume_device(void)
 {
-	ich_force_hpet_resume();
+	force_hpet_resume();
 }
 
 static void hpet_restart_counter(void)
diff -puN arch/i386/kernel/quirks.c~ich-force-hpet-ich5-quirk-to-force-detect-enable arch/i386/kernel/quirks.c
--- a/arch/x86/kernel/quirks.c~ich-force-hpet-ich5-quirk-to-force-detect-enable
+++ a/arch/x86/kernel/quirks.c
@@ -53,9 +53,15 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
 #if defined(CONFIG_HPET_TIMER)
 unsigned long force_hpet_address;
 
+static enum {
+	NONE_FORCE_HPET_RESUME,
+	OLD_ICH_FORCE_HPET_RESUME,
+	ICH_FORCE_HPET_RESUME
+} force_hpet_resume_type;
+
 static void __iomem *rcba_base;
 
-void ich_force_hpet_resume(void)
+static void ich_force_hpet_resume(void)
 {
 	u32 val;
 
@@ -133,6 +139,7 @@ static void ich_force_enable_hpet(struct
 		iounmap(rcba_base);
 		printk(KERN_DEBUG "Failed to force enable HPET\n");
 	} else {
+		force_hpet_resume_type = ICH_FORCE_HPET_RESUME;
 		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
 			       force_hpet_address);
 	}
@@ -148,4 +155,98 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
                          ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_1,
                          ich_force_enable_hpet);
+
+
+static struct pci_dev *cached_dev;
+
+static void old_ich_force_hpet_resume(void)
+{
+	u32 val;
+	u32 uninitialized_var(gen_cntl);
+
+	if (!force_hpet_address || !cached_dev)
+		return;
+
+	pci_read_config_dword(cached_dev, 0xD0, &gen_cntl);
+	gen_cntl &= (~(0x7 << 15));
+	gen_cntl |= (0x4 << 15);
+
+	pci_write_config_dword(cached_dev, 0xD0, gen_cntl);
+	pci_read_config_dword(cached_dev, 0xD0, &gen_cntl);
+	val = gen_cntl >> 15;
+	val &= 0x7;
+	if (val == 0x4)
+		printk(KERN_DEBUG "Force enabled HPET at resume\n");
+	else
+		BUG();
+}
+
+static void old_ich_force_enable_hpet(struct pci_dev *dev)
+{
+	u32 val;
+	u32 uninitialized_var(gen_cntl);
+
+	if (hpet_address || force_hpet_address)
+		return;
+
+	pci_read_config_dword(dev, 0xD0, &gen_cntl);
+	/*
+	 * Bit 17 is HPET enable bit.
+	 * Bit 16:15 control the HPET base address.
+	 */
+	val = gen_cntl >> 15;
+	val &= 0x7;
+	if (val & 0x4) {
+		val &= 0x3;
+		force_hpet_address = 0xFED00000 | (val << 12);
+		printk(KERN_DEBUG "HPET at base address 0x%lx\n",
+			       force_hpet_address);
+		cached_dev = dev;
+		return;
+	}
+
+	/*
+	 * HPET is disabled. Trying enabling at FED00000 and check
+	 * whether it sticks
+	 */
+	gen_cntl &= (~(0x7 << 15));
+	gen_cntl |= (0x4 << 15);
+	pci_write_config_dword(dev, 0xD0, gen_cntl);
+
+	pci_read_config_dword(dev, 0xD0, &gen_cntl);
+
+	val = gen_cntl >> 15;
+	val &= 0x7;
+	if (val & 0x4) {
+		/* HPET is enabled in HPTC. Just not reported by BIOS */
+		val &= 0x3;
+		force_hpet_address = 0xFED00000 | (val << 12);
+		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+			       force_hpet_address);
+		force_hpet_resume_type = OLD_ICH_FORCE_HPET_RESUME;
+		return;
+	}
+
+	printk(KERN_DEBUG "Failed to force enable HPET\n");
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801EB_0,
+                         old_ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801EB_12,
+                         old_ich_force_enable_hpet);
+
+void force_hpet_resume(void)
+{
+	switch (force_hpet_resume_type) {
+	    case ICH_FORCE_HPET_RESUME:
+		return ich_force_hpet_resume();
+
+	    case OLD_ICH_FORCE_HPET_RESUME:
+		return old_ich_force_hpet_resume();
+
+	    default:
+		break;
+	}
+}
+
 #endif
diff -puN include/asm-i386/hpet.h~ich-force-hpet-ich5-quirk-to-force-detect-enable include/asm-i386/hpet.h
--- a/include/asm-x86/hpet_32.h~ich-force-hpet-ich5-quirk-to-force-detect-enable
+++ a/include/asm-x86/hpet_32.h
@@ -68,7 +68,7 @@ extern unsigned long force_hpet_address;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 extern unsigned long hpet_readl(unsigned long a);
-extern void ich_force_hpet_resume(void);
+extern void force_hpet_resume(void);
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 
diff -puN include/linux/pci_ids.h~ich-force-hpet-ich5-quirk-to-force-detect-enable include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~ich-force-hpet-ich5-quirk-to-force-detect-enable
+++ a/include/linux/pci_ids.h
@@ -2246,6 +2246,7 @@
 #define PCI_DEVICE_ID_INTEL_82801EB_5	0x24d5
 #define PCI_DEVICE_ID_INTEL_82801EB_6	0x24d6
 #define PCI_DEVICE_ID_INTEL_82801EB_11	0x24db
+#define PCI_DEVICE_ID_INTEL_82801EB_12	0x24dc
 #define PCI_DEVICE_ID_INTEL_82801EB_13	0x24dd
 #define PCI_DEVICE_ID_INTEL_ESB_1	0x25a1
 #define PCI_DEVICE_ID_INTEL_ESB_2	0x25a2
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
git-acpi.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
