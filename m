From: akpm@linux-foundation.org
Subject: + i386-hpet-assumes-boot-cpu-is-0.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:07:50 -0700
Message-ID: <200706260007.l5Q07olS014447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51389 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179AbXFZAIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:08:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisw@sous-sol.org, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     i386: hpet assumes boot cpu is 0
has been added to the -mm tree.  Its filename is
     i386-hpet-assumes-boot-cpu-is-0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ntp-move-the-cmos-update-code-into-ntpc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-convert-to-cleckevents.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
