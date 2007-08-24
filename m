From: akpm@linux-foundation.org
Subject: + ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:05:49 -0700
Message-ID: <200708242205.l7OM5n49017077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41038 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759687AbXHXWQB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:16:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, ak@suse.de, greg@kroah.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     ich force hpet: ich5 fix a bug with suspend resume
has been added to the -mm tree.  Its filename is
     ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ich force hpet: ich5 fix a bug with suspend resume
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
@@ -201,7 +201,6 @@ static void old_ich_force_enable_hpet(st
 		force_hpet_address = 0xFED00000 | (val << 12);
 		printk(KERN_DEBUG "HPET at base address 0x%lx\n",
 			       force_hpet_address);
-		cached_dev = dev;
 		return;
 	}
 
@@ -223,6 +222,7 @@ static void old_ich_force_enable_hpet(st
 		force_hpet_address = 0xFED00000 | (val << 12);
 		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
 			       force_hpet_address);
+		cached_dev = dev;
 		force_hpet_resume_type = OLD_ICH_FORCE_HPET_RESUME;
 		return;
 	}
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
