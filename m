From: akpm@linux-foundation.org
Subject: - ich-force-hpet-late-initialization-of-hpet-after-quirk.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:48:54 -0700
Message-ID: <200707191948.l6JJmsLj018938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763325AbXGSTtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 15:49:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, ak@suse.de, greg@kroah.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ICH Force HPET: late initialization of hpet after quirk
has been removed from the -mm tree.  Its filename was
     ich-force-hpet-late-initialization-of-hpet-after-quirk.patch

This patch was dropped because Changes in Andi's tree destroyed this patch series

------------------------------------------------------
Subject: ICH Force HPET: late initialization of hpet after quirk
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Enable HPET later during boot, after the force detect in PCI quirks.  Also add
a call to repeat the force enabling at resume time.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |   50 ++++++++++++++++++++++++++++++++++----
 include/asm-i386/hpet.h |    1 
 2 files changed, 46 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/hpet.c~ich-force-hpet-late-initialization-of-hpet-after-quirk arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~ich-force-hpet-late-initialization-of-hpet-after-quirk
+++ a/arch/i386/kernel/hpet.c
@@ -25,6 +25,8 @@ extern struct clock_event_device *global
  */
 unsigned long hpet_address;
 
+static void __iomem * hpet_virt_address;
+
 #ifdef CONFIG_X86_64
 
 #include <asm/pgtable.h>
@@ -34,19 +36,22 @@ static inline void hpet_set_mapping(void
 {
 	set_fixmap_nocache(FIX_HPET_BASE, hpet_address);
 	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
+	hpet_virt_address = (void __iomem *)fix_to_virt(FIX_HPET_BASE);
+
 }
 
 static inline void __iomem *hpet_get_virt_address(void)
 {
-	return (void __iomem *)fix_to_virt(FIX_HPET_BASE);
+	return hpet_virt_address;
 }
 
-static inline void hpet_clear_mapping(void) { }
+static inline void hpet_clear_mapping(void)
+{
+	hpet_virt_address = NULL;
+}
 
 #else
 
-static void __iomem * hpet_virt_address;
-
 static inline unsigned long hpet_readl(unsigned long a)
 {
 	return readl(hpet_virt_address + a);
@@ -173,6 +178,7 @@ static struct clock_event_device hpet_cl
 	.set_next_event = hpet_legacy_next_event,
 	.shift		= 32,
 	.irq		= 0,
+	.rating		= 50,
 };
 
 static void hpet_start_counter(void)
@@ -187,6 +193,17 @@ static void hpet_start_counter(void)
 	hpet_writel(cfg, HPET_CFG);
 }
 
+static void hpet_resume_device(void)
+{
+	ich_force_hpet_resume();
+}
+
+static void hpet_restart_counter(void)
+{
+	hpet_resume_device();
+	hpet_start_counter();
+}
+
 static void hpet_enable_legacy_int(void)
 {
 	unsigned long cfg = hpet_readl(HPET_CFG);
@@ -308,7 +325,7 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-	.resume		= hpet_start_counter,
+	.resume		= hpet_restart_counter,
 #ifdef CONFIG_X86_64
 	.vread		= vread_hpet,
 #endif
@@ -371,6 +388,9 @@ int __init hpet_enable(void)
 {
 	unsigned long id;
 
+	if (hpet_get_virt_address())
+		return 0;
+
 	if (!is_hpet_capable())
 		return 0;
 
@@ -415,6 +435,26 @@ out_nohpet:
 }
 
 
+static int __init hpet_late_init(void)
+{
+	if (boot_hpet_disable)
+		return -ENODEV;
+
+	if (!hpet_address) {
+		if (!force_hpet_address)
+			return -ENODEV;
+
+		hpet_address = force_hpet_address;
+		hpet_enable();
+		if (!hpet_get_virt_address())
+			return -ENODEV;
+	}
+
+	return 0;
+}
+fs_initcall(hpet_late_init);
+
+
 #ifdef CONFIG_HPET_EMULATE_RTC
 
 /* HPET in LegacyReplacement Mode eats up RTC interrupt line. When, HPET
diff -puN include/asm-i386/hpet.h~ich-force-hpet-late-initialization-of-hpet-after-quirk include/asm-i386/hpet.h
--- a/include/asm-i386/hpet.h~ich-force-hpet-late-initialization-of-hpet-after-quirk
+++ a/include/asm-i386/hpet.h
@@ -64,6 +64,7 @@
 
 /* hpet memory map physical address */
 extern unsigned long hpet_address;
+extern unsigned long force_hpet_address;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
x86_64-block-irq-balancing-for-timer.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
