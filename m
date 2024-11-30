Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CBC1FB3
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 05:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732943588; cv=none; b=IGFk6lXLOAqKYmZzYWY2ZEktbV2xO7BD+3/ONxXtYqbKbY76giJAI3d4gHzf6b3Nqnke/uWPabS40+YQ500kqJyPdFsNJmSJokIhGS40mQCEM/ZbAHEXvbHwyQuwgt50Op5Imhc7uHiuCQFW96utloYUIvNXIkkEr0RA9x0kRYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732943588; c=relaxed/simple;
	bh=eRLUi8slAFgUpI9kDVu+4xoeGOe/p3+mEds2w3SAUHU=;
	h=Date:To:From:Subject:Message-Id; b=gfzlvIUkfD8LicSq73fT5Lj9O2iAKGfuAVZn0V+bI71wmAgtDdQbSiI5GDHOtTqsfbESZBndSBEWWHcFXlrsThFzFvku+/fg2zlVoCKwpW8J8Vc4wyDYAqW2qMDznbjUZdTYB1btr7GvJU0sX22O3Ct97IXrfZdlKluOUQIW5NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YTGqzEJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YTGqzEJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91FCC4CECC;
	Sat, 30 Nov 2024 05:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732943587;
	bh=eRLUi8slAFgUpI9kDVu+4xoeGOe/p3+mEds2w3SAUHU=;
	h=Date:To:From:Subject:From;
	b=YTGqzEJhbxnYt7ZzNwuERvRnHuOaFPp/34h2rW/pOwR1m9qVApb+zs4TD/Uuf940e
	 mYzt/RvNzICn3BtdK2fnKnKUhOVGjlsCBavVaW9rPJEfMToFDfZqRhltGKGq21vaxe
	 x3VOgMzy8+CxRISMZcYABNluNvPxSH2uoo8LmGz8=
Date: Fri, 29 Nov 2024 21:13:07 -0800
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,peterz@infradead.org,mpe@ellerman.id.au,herton@redhat.com,npiggin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown.patch added to mm-unstable branch
Message-Id: <20241130051307.A91FCC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lazy tlb: fix hotplug exit race with MMU_LAZY_TLB_SHOOTDOWN
has been added to the -mm mm-unstable branch.  Its filename is
     lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: lazy tlb: fix hotplug exit race with MMU_LAZY_TLB_SHOOTDOWN
Date: Mon, 4 Nov 2024 11:23:18 -0300

CPU unplug first calls __cpu_disable(), and that's where powerpc calls
cleanup_cpu_mmu_context(), which clears this CPU from mm_cpumask() of all
mms in the system.

However this CPU may still be using a lazy tlb mm, and its mm_cpumask bit
will be cleared from it.  The CPU does not switch away from the lazy tlb
mm until arch_cpu_idle_dead() calls idle_task_exit().

If that user mm exits in this window, it will not be subject to the lazy
tlb mm shootdown and may be freed while in use as a lazy mm by the CPU
that is being unplugged.

cleanup_cpu_mmu_context() could be moved later, but it looks better to
move the lazy tlb mm switching earlier.  The problem with doing the lazy
mm switching in idle_task_exit() is explained in commit bf2c59fce4074
("sched/core: Fix illegal RCU from offline CPUs"), which added a wart to
switch away from the mm but leave it set in active_mm to be cleaned up
later.

So instead, switch away from the lazy tlb mm at sched_cpu_wait_empty(),
which is the last hotplug state before teardown
(CPUHP_AP_SCHED_WAIT_EMPTY).  This CPU will never switch to a user thread
from this point, so it has no chance to pick up a new lazy tlb mm.  This
removes the lazy tlb mm handling wart in CPU unplug.

With this, idle_task_exit() is not needed anymore and can be cleaned up. 
This leaves the prototype alone, to be cleaned after this change.

herton: took the suggestions from https://lore.kernel.org/all/87jzvyprsw.ffs@tglx/
and made adjustments on the initial patch proposed by Nicholas.

Link: https://lkml.kernel.org/r/20230524060455.147699-1-npiggin@gmail.com
Link: https://lore.kernel.org/all/20230525205253.E2FAEC433EF@smtp.kernel.org/
Link: https://lkml.kernel.org/r/20241104142318.3295663-1-herton@redhat.com
Fixes: 2655421ae69fa ("lazy tlb: shoot lazies, non-refcounting lazy tlb mm reference handling scheme")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/hotplug.h |    4 ----
 kernel/cpu.c                  |   11 ++++++-----
 kernel/sched/core.c           |   22 +++++++++++++++-------
 3 files changed, 21 insertions(+), 16 deletions(-)

--- a/include/linux/sched/hotplug.h~lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown
+++ a/include/linux/sched/hotplug.h
@@ -18,10 +18,6 @@ extern int sched_cpu_dying(unsigned int
 # define sched_cpu_dying	NULL
 #endif
 
-#ifdef CONFIG_HOTPLUG_CPU
-extern void idle_task_exit(void);
-#else
 static inline void idle_task_exit(void) {}
-#endif
 
 #endif /* _LINUX_SCHED_HOTPLUG_H */
--- a/kernel/cpu.c~lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown
+++ a/kernel/cpu.c
@@ -904,13 +904,14 @@ static int finish_cpu(unsigned int cpu)
 	struct task_struct *idle = idle_thread_get(cpu);
 	struct mm_struct *mm = idle->active_mm;
 
-	/*
-	 * idle_task_exit() will have switched to &init_mm, now
-	 * clean up any remaining active_mm state.
+	/* 
+	 * sched_force_init_mm() ensured the use of &init_mm,
+	 * drop that refcount now that the CPU has stopped.
 	 */
-	if (mm != &init_mm)
-		idle->active_mm = &init_mm;
+	WARN_ON(mm != &init_mm);
+	idle->active_mm = NULL;
 	mmdrop_lazy_tlb(mm);
+
 	return 0;
 }
 
--- a/kernel/sched/core.c~lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown
+++ a/kernel/sched/core.c
@@ -7930,19 +7930,26 @@ void sched_setnuma(struct task_struct *p
 
 #ifdef CONFIG_HOTPLUG_CPU
 /*
- * Ensure that the idle task is using init_mm right before its CPU goes
- * offline.
+ * Invoked on the outgoing CPU in context of the CPU hotplug thread
+ * after ensuring that there are no user space tasks left on the CPU.
+ *
+ * If there is a lazy mm in use on the hotplug thread, drop it and
+ * switch to init_mm.
+ *
+ * The reference count on init_mm is dropped in finish_cpu().
  */
-void idle_task_exit(void)
+static void sched_force_init_mm(void)
 {
 	struct mm_struct *mm = current->active_mm;
 
-	BUG_ON(cpu_online(smp_processor_id()));
-	BUG_ON(current != this_rq()->idle);
-
 	if (mm != &init_mm) {
-		switch_mm(mm, &init_mm, current);
+		mmgrab_lazy_tlb(&init_mm);
+		local_irq_disable();
+		current->active_mm = &init_mm;
+		switch_mm_irqs_off(mm, &init_mm, current);
+		local_irq_enable();
 		finish_arch_post_lock_switch();
+		mmdrop_lazy_tlb(mm);
 	}
 
 	/* finish_cpu(), as ran on the BP, will clean up the active_mm state */
@@ -8344,6 +8351,7 @@ int sched_cpu_starting(unsigned int cpu)
 int sched_cpu_wait_empty(unsigned int cpu)
 {
 	balance_hotplug_wait();
+	sched_force_init_mm();
 	return 0;
 }
 
_

Patches currently in -mm which might be from npiggin@gmail.com are

lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown.patch

