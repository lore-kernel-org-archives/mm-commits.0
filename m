From: akpm@linux-foundation.org
Subject: + ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch added to -mm tree
Date: Tue, 26 Jun 2007 12:20:43 -0700
Message-ID: <200706261920.l5QJKhaf000390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758143AbXFZTVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 15:21:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, ak@suse.de, greg@kroah.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     ICH Force HPET: ICH5 fix a bug with suspend/resume
has been added to the -mm tree.  Its filename is
     ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ICH Force HPET: ICH5 fix a bug with suspend/resume
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

A bugfix in ich5 hpet force detect which caused resumes to fail.  Thanks to
Udo A Steinberg for reporting the problem.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/quirks.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/quirks.c~ich-force-hpet-ich5-fix-a-bug-with-suspend-resume arch/i386/kernel/quirks.c
--- a/arch/i386/kernel/quirks.c~ich-force-hpet-ich5-fix-a-bug-with-suspend-resume
+++ a/arch/i386/kernel/quirks.c
@@ -199,7 +199,6 @@ static void old_ich_force_enable_hpet(st
 		force_hpet_address = 0xFED00000 | (val << 12);
 		printk(KERN_DEBUG "HPET at base address 0x%lx\n",
 			       force_hpet_address);
-		cached_dev = dev;
 		return;
 	}
 
@@ -221,6 +220,7 @@ static void old_ich_force_enable_hpet(st
 		force_hpet_address = 0xFED00000 | (val << 12);
 		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
 			       force_hpet_address);
+		cached_dev = dev;
 		force_hpet_resume_type = OLD_ICH_FORCE_HPET_RESUME;
 		return;
 	}
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-menu-governor-and-hrtimer-compile-fix.patch
cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch
cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch
cpuidle-menu-governor-change-the-early-break-condition.patch
cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch
cpuidle-first-round-of-documentation-updates.patch
git-acpi-add-exports.patch
git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
x86_64-convert-to-cleckevents.patch
x86_64-block-irq-balancing-for-timer.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
git-newsetup.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
