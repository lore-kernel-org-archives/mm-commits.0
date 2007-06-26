From: akpm@linux-foundation.org
Subject: + x86_64-fix-apic-typo.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:08:00 -0700
Message-ID: <200706260008.l5Q0800i014462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbXFZAO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:14:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     x86_64: fix APIC typo
has been added to the -mm tree.  Its filename is
     x86_64-fix-apic-typo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: fix APIC typo
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c    |    4 ++--
 arch/x86_64/kernel/mce_amd.c |    6 +++---
 include/asm-x86_64/apic.h    |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-fix-apic-typo arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-fix-apic-typo
+++ a/arch/x86_64/kernel/apic.c
@@ -990,8 +990,8 @@ int setup_profiling_timer(unsigned int m
 	return -EINVAL;
 }
 
-void setup_APIC_extened_lvt(unsigned char lvt_off, unsigned char vector,
-			    unsigned char msg_type, unsigned char mask)
+void setup_APIC_extended_lvt(unsigned char lvt_off, unsigned char vector,
+			     unsigned char msg_type, unsigned char mask)
 {
 	unsigned long reg = (lvt_off << 4) + K8_APIC_EXT_LVT_BASE;
 	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
diff -puN arch/x86_64/kernel/mce_amd.c~x86_64-fix-apic-typo arch/x86_64/kernel/mce_amd.c
--- a/arch/x86_64/kernel/mce_amd.c~x86_64-fix-apic-typo
+++ a/arch/x86_64/kernel/mce_amd.c
@@ -157,9 +157,9 @@ void __cpuinit mce_amd_feature_init(stru
 			high |= K8_APIC_EXT_LVT_ENTRY_THRESHOLD << 20;
 			wrmsr(address, low, high);
 
-			setup_APIC_extened_lvt(K8_APIC_EXT_LVT_ENTRY_THRESHOLD,
-					       THRESHOLD_APIC_VECTOR,
-					       K8_APIC_EXT_INT_MSG_FIX, 0);
+			setup_APIC_extended_lvt(K8_APIC_EXT_LVT_ENTRY_THRESHOLD,
+						THRESHOLD_APIC_VECTOR,
+						K8_APIC_EXT_INT_MSG_FIX, 0);
 
 			threshold_defaults.address = address;
 			threshold_restart_bank(&threshold_defaults, 0, 0);
diff -puN include/asm-x86_64/apic.h~x86_64-fix-apic-typo include/asm-x86_64/apic.h
--- a/include/asm-x86_64/apic.h~x86_64-fix-apic-typo
+++ a/include/asm-x86_64/apic.h
@@ -83,8 +83,8 @@ extern void disable_APIC_timer(void);
 extern void enable_APIC_timer(void);
 extern void setup_apic_routing(void);
 
-extern void setup_APIC_extened_lvt(unsigned char lvt_off, unsigned char vector,
-				   unsigned char msg_type, unsigned char mask);
+extern void setup_APIC_extended_lvt(unsigned char lvt_off, unsigned char vector,
+				    unsigned char msg_type, unsigned char mask);
 
 extern int apic_is_clustered_box(void);
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-acpi-add-exports.patch
git-arm.patch
i386-hpet-check-if-the-counter-works.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
timekeeping-fixup-shadow-variable-argument.patch
timerc-cleanup-recently-introduced-whitespace-damage.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
sys_time-speedup.patch
lguest-the-host-code.patch
