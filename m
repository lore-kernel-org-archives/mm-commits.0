From: akpm@linux-foundation.org
Subject: + ich-force-hpet-late-initialization-of-hpet-after-quirk.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:05:43 -0700
Message-ID: <200708242205.l7OM5h94017065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42399 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752854AbXHXWQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, ak@suse.de, greg@kroah.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     ich force hpet: late initialization of hpet after quirk
has been added to the -mm tree.  Its filename is
     ich-force-hpet-late-initialization-of-hpet-after-quirk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ich force hpet: late initialization of hpet after quirk
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

 arch/i386/kernel/hpet.c |   27 +++++++++++++++++++++++++--
 include/asm-i386/hpet.h |    1 +
 2 files changed, 26 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/hpet.c~ich-force-hpet-late-initialization-of-hpet-after-quirk arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~ich-force-hpet-late-initialization-of-hpet-after-quirk
+++ a/arch/i386/kernel/hpet.c
@@ -164,6 +164,7 @@ static struct clock_event_device hpet_cl
 	.set_next_event = hpet_legacy_next_event,
 	.shift		= 32,
 	.irq		= 0,
+	.rating		= 50,
 };
 
 static void hpet_start_counter(void)
@@ -178,6 +179,17 @@ static void hpet_start_counter(void)
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
@@ -299,7 +311,7 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-	.resume		= hpet_start_counter,
+	.resume		= hpet_restart_counter,
 #ifdef CONFIG_X86_64
 	.vread		= vread_hpet,
 #endif
@@ -412,10 +424,21 @@ out_nohpet:
  */
 static __init int hpet_late_init(void)
 {
-	if (!is_hpet_capable())
+	if (boot_hpet_disable)
 		return -ENODEV;
 
+	if (!hpet_address) {
+		if (!force_hpet_address)
+			return -ENODEV;
+
+		hpet_address = force_hpet_address;
+		hpet_enable();
+		if (!hpet_virt_address)
+			return -ENODEV;
+	}
+
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
+
 	return 0;
 }
 fs_initcall(hpet_late_init);
diff -puN include/asm-i386/hpet.h~ich-force-hpet-late-initialization-of-hpet-after-quirk include/asm-i386/hpet.h
--- a/include/asm-i386/hpet.h~ich-force-hpet-late-initialization-of-hpet-after-quirk
+++ a/include/asm-i386/hpet.h
@@ -64,6 +64,7 @@
 
 /* hpet memory map physical address */
 extern unsigned long hpet_address;
+extern unsigned long force_hpet_address;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 extern unsigned long hpet_readl(unsigned long a);
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
