From: akpm@linux-foundation.org
Subject: + x86-ia64-smp-use-workqueues-unconditionally-during-do_boot_cpu.patch added to -mm tree
Date: Mon, 02 Aug 2010 15:30:29 -0700
Message-ID: <201008022230.o72MUTMk015115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753976Ab0HBWbT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Aug 2010 18:31:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, hpa@zytor.com, mingo@elte.hu, oleg@redhat.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com


The patch titled
     x86, ia64, smp: use workqueues unconditionally during do_boot_cpu()
has been added to the -mm tree.  Its filename is
     x86-ia64-smp-use-workqueues-unconditionally-during-do_boot_cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86, ia64, smp: use workqueues unconditionally during do_boot_cpu()
From: Suresh Siddha <suresh.b.siddha@intel.com>

Workqueues are now initialized as part of the early_initcall().  So they
are available for use during cold boot process aswell.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/smpboot.c |   15 ++++++---------
 arch/x86/kernel/smpboot.c  |    8 ++------
 2 files changed, 8 insertions(+), 15 deletions(-)

diff -puN arch/ia64/kernel/smpboot.c~x86-ia64-smp-use-workqueues-unconditionally-during-do_boot_cpu arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~x86-ia64-smp-use-workqueues-unconditionally-during-do_boot_cpu
+++ a/arch/ia64/kernel/smpboot.c
@@ -508,21 +508,18 @@ do_boot_cpu (int sapicid, int cpu)
 		.done	= COMPLETION_INITIALIZER(c_idle.done),
 	};
 
+	/*
+	 * We can't use kernel_thread since we must avoid to
+	 * reschedule the child.
+	 */
  	c_idle.idle = get_idle_for_cpu(cpu);
  	if (c_idle.idle) {
 		init_idle(c_idle.idle, cpu);
  		goto do_rest;
 	}
 
-	/*
-	 * We can't use kernel_thread since we must avoid to reschedule the child.
-	 */
-	if (!keventd_up())
-		c_idle.work.func(&c_idle.work);
-	else {
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-	}
+	schedule_work(&c_idle.work);
+	wait_for_completion(&c_idle.done);
 
 	if (IS_ERR(c_idle.idle))
 		panic("failed fork for CPU %d", cpu);
diff -puN arch/x86/kernel/smpboot.c~x86-ia64-smp-use-workqueues-unconditionally-during-do_boot_cpu arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~x86-ia64-smp-use-workqueues-unconditionally-during-do_boot_cpu
+++ a/arch/x86/kernel/smpboot.c
@@ -735,12 +735,8 @@ static int __cpuinit do_boot_cpu(int api
 		goto do_rest;
 	}
 
-	if (!keventd_up())
-		c_idle.work.func(&c_idle.work);
-	else {
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-	}
+	schedule_work(&c_idle.work);
+	wait_for_completion(&c_idle.done);
 
 	if (IS_ERR(c_idle.idle)) {
 		printk("failed fork for CPU %d\n", cpu);
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

linux-next.patch
x86-ia64-smp-use-workqueues-unconditionally-during-do_boot_cpu.patch

