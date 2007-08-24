From: akpm@linux-foundation.org
Subject: + ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:05:39 -0700
Message-ID: <200708242205.l7OM5dHS017059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756616AbXHXWVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:21:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, ak@suse.de, greg@kroah.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     ich force hpet: ich7 or later quirk to force detect enable
has been added to the -mm tree.  Its filename is
     ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ich force hpet: ich7 or later quirk to force detect enable
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Force detect and/or enable HPET on ICH chipsets.  This patch just handles the
detection part and following patches use this information.  Adds a function to
repeat the force enabling during resume time.

Using HPET this way, instead of PIT increases the time CPUs can reside in
C-state when system is totally idle.  On my test system with Core 2 Duo,
average C-state residency goes up from ~20mS to ~80mS.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/quirks.c |  101 ++++++++++++++++++++++++++++++++++++
 include/asm-i386/hpet.h   |    1 
 2 files changed, 102 insertions(+)

diff -puN arch/i386/kernel/quirks.c~ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable arch/i386/kernel/quirks.c
--- a/arch/i386/kernel/quirks.c~ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable
+++ a/arch/i386/kernel/quirks.c
@@ -4,6 +4,8 @@
 #include <linux/pci.h>
 #include <linux/irq.h>
 
+#include <asm/hpet.h>
+
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
 
 static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
@@ -47,3 +49,102 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7525_MCH,	quirk_intel_irqbalance);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7520_MCH,	quirk_intel_irqbalance);
 #endif
+
+#if defined(CONFIG_HPET_TIMER)
+unsigned long force_hpet_address;
+
+static void __iomem *rcba_base;
+
+void ich_force_hpet_resume(void)
+{
+	u32 val;
+
+	if (!force_hpet_address)
+		return;
+
+	if (rcba_base == NULL)
+		BUG();
+
+	/* read the Function Disable register, dword mode only */
+	val = readl(rcba_base + 0x3404);
+	if (!(val & 0x80)) {
+		/* HPET disabled in HPTC. Trying to enable */
+		writel(val | 0x80, rcba_base + 0x3404);
+	}
+
+	val = readl(rcba_base + 0x3404);
+	if (!(val & 0x80))
+		BUG();
+	else
+		printk(KERN_DEBUG "Force enabled HPET at resume\n");
+
+	return;
+}
+
+static void ich_force_enable_hpet(struct pci_dev *dev)
+{
+	u32 val, rcba;
+	int err = 0;
+
+	if (hpet_address || force_hpet_address)
+		return;
+
+	pci_read_config_dword(dev, 0xF0, &rcba);
+	rcba &= 0xFFFFC000;
+	if (rcba == 0) {
+		printk(KERN_DEBUG "RCBA disabled. Cannot force enable HPET\n");
+		return;
+	}
+
+	/* use bits 31:14, 16 kB aligned */
+	rcba_base = ioremap_nocache(rcba, 0x4000);
+	if (rcba_base == NULL) {
+		printk(KERN_DEBUG "ioremap failed. Cannot force enable HPET\n");
+		return;
+	}
+
+	/* read the Function Disable register, dword mode only */
+	val = readl(rcba_base + 0x3404);
+
+	if (val & 0x80) {
+		/* HPET is enabled in HPTC. Just not reported by BIOS */
+		val = val & 0x3;
+		force_hpet_address = 0xFED00000 | (val << 12);
+		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+			       force_hpet_address);
+		iounmap(rcba_base);
+		return;
+	}
+
+	/* HPET disabled in HPTC. Trying to enable */
+	writel(val | 0x80, rcba_base + 0x3404);
+
+	val = readl(rcba_base + 0x3404);
+	if (!(val & 0x80)) {
+		err = 1;
+	} else {
+		val = val & 0x3;
+		force_hpet_address = 0xFED00000 | (val << 12);
+	}
+
+	if (err) {
+		force_hpet_address = 0;
+		iounmap(rcba_base);
+		printk(KERN_DEBUG "Failed to force enable HPET\n");
+	} else {
+		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+			       force_hpet_address);
+	}
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_0,
+                         ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,
+                         ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_1,
+                         ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_31,
+                         ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_1,
+                         ich_force_enable_hpet);
+#endif
diff -puN include/asm-i386/hpet.h~ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable include/asm-i386/hpet.h
--- a/include/asm-i386/hpet.h~ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable
+++ a/include/asm-i386/hpet.h
@@ -67,6 +67,7 @@ extern unsigned long hpet_address;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 extern unsigned long hpet_readl(unsigned long a);
+extern void ich_force_hpet_resume(void);
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
git-acpi.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
hpet-force-enable-on-ich34.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
