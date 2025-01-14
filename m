Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E06723A115
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836968; cv=none; b=G0yjtnVnXchkfcfGbx4oDCjBXNG7860Q7vWKiH8xB9dzDlXY7A16d/xn4f68+FcH9rhT6UvufXDO4b7sPVlObB9RQFGxagmfecY8nnqJJilnwZ5S9T0jTV5JzaxBbaf9ILvIHVfAvQb9fJ8hZISbRE8GfaSc1hfuNn3tuZQt470=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836968; c=relaxed/simple;
	bh=3WtOlMAzzmQOEYimRtw5oG6+qww3rf9TBBiv5xdbUAk=;
	h=Date:To:From:Subject:Message-Id; b=lU4m+IgqMP4Or4iL1b2XLrsnadAsMElKkWzZdlX83gbM+4NTvaFaKF4DI8JIYj42dSNEz1TtklO95jJjrxYN7zEhiKx4yMPlFpFVvBK/Ln8H2//wG2fR+91/ZKkDkvGvWkR4d45DjJSmPY7vggGaU3S/so7PzcrEaQ2hF3qc2HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vbVBiOlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vbVBiOlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73607C4CEDD;
	Tue, 14 Jan 2025 06:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836968;
	bh=3WtOlMAzzmQOEYimRtw5oG6+qww3rf9TBBiv5xdbUAk=;
	h=Date:To:From:Subject:From;
	b=vbVBiOlwBAfx2i8+WhyKM1LprEhRzSp8yD1tzNroez6xHJQ6aoeqLb9UuFloyrtP3
	 bhEHHayV9GOmyIls+y91z1ti9ZBgpfi0AliKD/XCpp7/umqyC5AkhikSLO4f59XdLJ
	 vzouvmxstpmB7NR3LHsdf3XrWEfgHFHBYB/sUIgY=
Date: Mon, 13 Jan 2025 22:42:47 -0800
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,peterz@infradead.org,mpe@ellerman.id.au,herton@redhat.com,npiggin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown.patch removed from -mm tree
Message-Id: <20250114064248.73607C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lazy tlb: fix hotplug exit race with MMU_LAZY_TLB_SHOOTDOWN
has been removed from the -mm tree.  Its filename was
     lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 2655421ae69f ("lazy tlb: shoot lazies, non-refcounting lazy tlb mm reference handling scheme")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/hotplug.h |    4 ----
 kernel/cpu.c                  |    9 +++++----
 kernel/sched/core.c           |   22 +++++++++++++++-------
 3 files changed, 20 insertions(+), 15 deletions(-)

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
@@ -905,12 +905,13 @@ static int finish_cpu(unsigned int cpu)
 	struct mm_struct *mm = idle->active_mm;
 
 	/*
-	 * idle_task_exit() will have switched to &init_mm, now
-	 * clean up any remaining active_mm state.
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


