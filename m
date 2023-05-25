Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C65C77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 20:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbjEYUw5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 16:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjEYUw4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 16:52:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45E3D3
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 13:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89ECE64AFE
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 20:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FAEC433EF;
        Thu, 25 May 2023 20:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685047974;
        bh=tHYDDOlNYbUFM3SqmeJ3GPqWMWDNTavOpZMjefOndVs=;
        h=Date:To:From:Subject:From;
        b=xFO3qzjkBjpsODJDQ6vQ6Yh1rZDST1kVFD/MxwnM/KgoObBnmr0HBbO8+ZEa8EA66
         UElt4pjqbidYHIO6SGJDogV/iXod/GmMhbe9+k1r11PNs3oGkBQpMuwuCLzAc4Orsw
         rvmmftJ0gzJqHuVrljSMMqaZfOnVvINjurYoyWjM=
Date:   Thu, 25 May 2023 13:52:53 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, npiggin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown.patch added to mm-hotfixes-unstable branch
Message-Id: <20230525205253.E2FAEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lazy tlb: fix hotplug exit race with MMU_LAZY_TLB_SHOOTDOWN
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Date: Wed, 24 May 2023 16:04:54 +1000

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

So instead, switch away from the lazy tlb mm on the stopper kthread before
the CPU is taken down.  This CPU will never switch to a user thread from
this point, so it has no chance to pick up a new lazy tlb mm.  This
removes the lazy tlb mm handling wart in CPU unplug.

idle_task_exit() remains to reduce churn in the patch.  It could be
removed entirely after this because finish_cpu() makes a similar check. 
finish_cpu() itself is not strictly needed because init_mm will never have
its refcount drop to zero.  But it is conceptually nicer to keep it rather
than have the idle thread drop the reference on the mm it is using.

Link: https://lkml.kernel.org/r/20230524060455.147699-1-npiggin@gmail.com
Fixes: 2655421ae69fa ("lazy tlb: shoot lazies, non-refcounting lazy tlb mm reference handling scheme")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/hotplug.h |    2 ++
 kernel/cpu.c                  |   11 +++++++----
 kernel/sched/core.c           |   24 +++++++++++++++++++-----
 3 files changed, 28 insertions(+), 9 deletions(-)

--- a/include/linux/sched/hotplug.h~lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown
+++ a/include/linux/sched/hotplug.h
@@ -19,8 +19,10 @@ extern int sched_cpu_dying(unsigned int
 #endif
 
 #ifdef CONFIG_HOTPLUG_CPU
+extern void idle_task_prepare_exit(void);
 extern void idle_task_exit(void);
 #else
+static inline void idle_task_prepare_exit(void) {}
 static inline void idle_task_exit(void) {}
 #endif
 
--- a/kernel/cpu.c~lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown
+++ a/kernel/cpu.c
@@ -618,12 +618,13 @@ static int finish_cpu(unsigned int cpu)
 	struct mm_struct *mm = idle->active_mm;
 
 	/*
-	 * idle_task_exit() will have switched to &init_mm, now
-	 * clean up any remaining active_mm state.
+	 * idle_task_prepare_exit() ensured the idle task was using
+	 * &init_mm. Now that the CPU has stopped, drop that refcount.
 	 */
-	if (mm != &init_mm)
-		idle->active_mm = &init_mm;
+	WARN_ON(mm != &init_mm);
+	idle->active_mm = NULL;
 	mmdrop_lazy_tlb(mm);
+
 	return 0;
 }
 
@@ -1030,6 +1031,8 @@ static int take_cpu_down(void *_param)
 	enum cpuhp_state target = max((int)st->target, CPUHP_AP_OFFLINE);
 	int err, cpu = smp_processor_id();
 
+	idle_task_prepare_exit();
+
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
 	if (err < 0)
--- a/kernel/sched/core.c~lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown
+++ a/kernel/sched/core.c
@@ -9373,19 +9373,33 @@ void sched_setnuma(struct task_struct *p
  * Ensure that the idle task is using init_mm right before its CPU goes
  * offline.
  */
-void idle_task_exit(void)
+void idle_task_prepare_exit(void)
 {
 	struct mm_struct *mm = current->active_mm;
 
-	BUG_ON(cpu_online(smp_processor_id()));
-	BUG_ON(current != this_rq()->idle);
+	WARN_ON(!irqs_disabled());
 
 	if (mm != &init_mm) {
-		switch_mm(mm, &init_mm, current);
+		mmgrab_lazy_tlb(&init_mm);
+		current->active_mm = &init_mm;
+		switch_mm_irqs_off(mm, &init_mm, current);
 		finish_arch_post_lock_switch();
+		mmdrop_lazy_tlb(mm);
 	}
+	/* finish_cpu() will mmdrop the init_mm ref after this CPU stops */
+}
+
+/*
+ * After the CPU is offline, double check that it was previously switched to
+ * init_mm. This call can be removed because the condition is caught in
+ * finish_cpu() as well.
+ */
+void idle_task_exit(void)
+{
+	BUG_ON(cpu_online(smp_processor_id()));
+	BUG_ON(current != this_rq()->idle);
 
-	/* finish_cpu(), as ran on the BP, will clean up the active_mm state */
+	WARN_ON_ONCE(current->active_mm != &init_mm);
 }
 
 static int __balance_push_cpu_stop(void *arg)
_

Patches currently in -mm which might be from npiggin@gmail.com are

lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown.patch
lazy-tlb-consolidate-lazy-tlb-mm-switching.patch

