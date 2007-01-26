From: akpm@osdl.org
Subject: - revert-nmi_known_cpu-check-during-boot-option-parsing.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:51:13 -0800
Message-ID: <200701260751.l0Q7pDbl010709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50446 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030799AbXAZHv0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:51:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, ak@suse.de, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Revert nmi_known_cpu() check during boot option parsing
has been removed from the -mm tree.  Its filename was
     revert-nmi_known_cpu-check-during-boot-option-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Revert nmi_known_cpu() check during boot option parsing
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

The patch
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f2802e7f571c05f9a901b1f5bd144aa730ccc88e
and another subsequent patch adds nmi_known_cpu() check while parsing boot
options in x86_64 and i386.  With that, "nmi_watchdog=2" stops working for
me on Intel Core 2 CPU based system.

The problem is, setup_nmi_watchdog is called while parsing the boot option
and identify_cpu is not done yet.  So, the return value of nmi_known_cpu()
is not valid at this point.

Revert that check.  Should not have any adverse effect as nmi_known_cpu()
check is done again later in enable_lapic_nmi_watchdog().

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/nmi.c   |    8 +-------
 arch/x86_64/kernel/nmi.c |    2 --
 2 files changed, 1 insertion(+), 9 deletions(-)

diff -puN arch/i386/kernel/nmi.c~revert-nmi_known_cpu-check-during-boot-option-parsing arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c~revert-nmi_known_cpu-check-during-boot-option-parsing
+++ a/arch/i386/kernel/nmi.c
@@ -310,13 +310,7 @@ static int __init setup_nmi_watchdog(cha
 
 	if ((nmi >= NMI_INVALID) || (nmi < NMI_NONE))
 		return 0;
-	/*
-	 * If any other x86 CPU has a local APIC, then
-	 * please test the NMI stuff there and send me the
-	 * missing bits. Right now Intel P6/P4 and AMD K7 only.
-	 */
-	if ((nmi == NMI_LOCAL_APIC) && (nmi_known_cpu() == 0))
-		return 0;  /* no lapic support */
+
 	nmi_watchdog = nmi;
 	return 1;
 }
diff -puN arch/x86_64/kernel/nmi.c~revert-nmi_known_cpu-check-during-boot-option-parsing arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c~revert-nmi_known_cpu-check-during-boot-option-parsing
+++ a/arch/x86_64/kernel/nmi.c
@@ -302,8 +302,6 @@ int __init setup_nmi_watchdog(char *str)
 	if ((nmi >= NMI_INVALID) || (nmi < NMI_NONE))
 		return 0;
 
-	if ((nmi == NMI_LOCAL_APIC) && (nmi_known_cpu() == 0))
-		return 0;  /* no lapic support */
 	nmi_watchdog = nmi;
 	return 1;
 }
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3.patch
ondemand-governor-restructure-the-work-callback.patch
ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-rework-threads-hotplug-management.patch
