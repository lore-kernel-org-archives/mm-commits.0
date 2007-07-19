From: akpm@linux-foundation.org
Subject: - i386-hpet-assumes-boot-cpu-is-0.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:37 -0700
Message-ID: <200707192010.l6JKAbef020689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761071AbXGSUSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:18:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisw@sous-sol.org, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     i386: hpet assumes boot cpu is 0
has been removed from the -mm tree.  Its filename was
     i386-hpet-assumes-boot-cpu-is-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: hpet assumes boot cpu is 0
From: Chris Wright <chrisw@sous-sol.org>

I fixed this in x86_64.  Looks like the kind of thing that will break voyager
on i386.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/hpet.c~i386-hpet-assumes-boot-cpu-is-0 arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~i386-hpet-assumes-boot-cpu-is-0
+++ a/arch/i386/kernel/hpet.c
@@ -325,7 +325,7 @@ int __init hpet_enable(void)
 		 * Start hpet with the boot cpu mask and make it
 		 * global after the IO_APIC has been initialized.
 		 */
-		hpet_clockevent.cpumask =cpumask_of_cpu(0);
+		hpet_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
 		clockevents_register_device(&hpet_clockevent);
 		global_clock_event = &hpet_clockevent;
 		return 1;
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

origin.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
security-convert-lsm-into-a-static-interface.patch
security-convert-lsm-into-a-static-interface-fix.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
