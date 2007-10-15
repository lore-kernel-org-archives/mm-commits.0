From: akpm@linux-foundation.org
Subject: - ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:18:45 -0700
Message-ID: <200710150918.l9F9Ij66027439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40722 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757471AbXJOJZG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:25:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, ak@suse.de, greg@kroah.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ich force hpet: ich5 fix a bug with suspend resume
has been removed from the -mm tree.  Its filename was
     ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/quirks.c~ich-force-hpet-ich5-fix-a-bug-with-suspend-resume arch/i386/kernel/quirks.c
--- a/arch/x86/kernel/quirks.c~ich-force-hpet-ich5-fix-a-bug-with-suspend-resume
+++ a/arch/x86/kernel/quirks.c
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
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
