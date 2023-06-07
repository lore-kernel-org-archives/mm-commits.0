Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105B0C7EE23
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 20:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjFGUAh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbjFGUAP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 16:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CAA19AA
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 13:00:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 847576429C
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 20:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B14C433D2;
        Wed,  7 Jun 2023 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686168009;
        bh=9JhF9gCg7qkIHML1jsVfn9nXHMmg3AeR8ZpqMn3SWwY=;
        h=Date:To:From:Subject:From;
        b=vtfSAxmjQJ+GkDPDIK3dKaVWcTsVG+XZ2FJGFEV3O9SVOyx9jtEkVgtoBzrJpNR9U
         aynnPUGPrqRxTui62R9ps/94/6SlLByGh1Fx+qlpuJj1DlcEe3+vq71pb84sSpJJ+i
         I2d4sHZXyqLL2Mzstan68cYscqIrAoWDL76r5JBw=
Date:   Wed, 07 Jun 2023 13:00:09 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        sachinp@linux.ibm.com, peterz@infradead.org, npiggin@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lazy-tlb-consolidate-lazy-tlb-mm-switching.patch removed from -mm tree
Message-Id: <20230607200009.D7B14C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lazy tlb: consolidate lazy tlb mm switching
has been removed from the -mm tree.  Its filename was
     lazy-tlb-consolidate-lazy-tlb-mm-switching.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: lazy tlb: consolidate lazy tlb mm switching
Date: Wed, 24 May 2023 16:04:55 +1000

Switching a kernel thread using a "lazy tlb mm" to init_mm is a relatively
common sequence that is not quite trivial.  Consolidate this into a
function.

This fixes a bug in do_shoot_lazy_tlb() for any arch that implements
finish_arch_post_lock_switch().  None select MMU_LAZY_TLB_SHOOTDOWN at the
moment.

[npiggin@gmail.com: fix an upstream powerpc bug]
  Link: https://lkml.kernel.org/r/20230607005622.583318-1-npiggin@gmail.com
Link: https://lkml.kernel.org/r/20230524060455.147699-2-npiggin@gmail.com
Fixes: 2655421ae69fa ("lazy tlb: shoot lazies, non-refcounting lazy tlb mm reference handling scheme")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/radix_tlb.c |   16 +++++++----
 include/linux/sched/task.h           |    2 +
 kernel/fork.c                        |    7 +----
 kernel/sched/core.c                  |   34 +++++++++++++++++--------
 4 files changed, 38 insertions(+), 21 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_tlb.c~lazy-tlb-consolidate-lazy-tlb-mm-switching
+++ a/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -795,12 +795,16 @@ void exit_lazy_flush_tlb(struct mm_struc
 		goto out;
 
 	if (current->active_mm == mm) {
-		WARN_ON_ONCE(current->mm != NULL);
-		/* Is a kernel thread and is using mm as the lazy tlb */
-		mmgrab_lazy_tlb(&init_mm);
-		current->active_mm = &init_mm;
-		switch_mm_irqs_off(mm, &init_mm, current);
-		mmdrop_lazy_tlb(mm);
+		unsigned long flags;
+
+		/*
+		 * It is a kernel thread and is using mm as the lazy tlb, so
+		 * switch it to init_mm. This is not always called from IPI
+		 * (e.g., flush_type_needed), so must disable irqs.
+		 */
+		local_irq_save(flags);
+		kthread_end_lazy_tlb_mm();
+		local_irq_restore(flags);
 	}
 
 	/*
--- a/include/linux/sched/task.h~lazy-tlb-consolidate-lazy-tlb-mm-switching
+++ a/include/linux/sched/task.h
@@ -61,6 +61,8 @@ extern int lockdep_tasklist_lock_is_held
 extern asmlinkage void schedule_tail(struct task_struct *prev);
 extern void init_idle(struct task_struct *idle, int cpu);
 
+extern void kthread_end_lazy_tlb_mm(void);
+
 extern int sched_fork(unsigned long clone_flags, struct task_struct *p);
 extern void sched_cgroup_fork(struct task_struct *p, struct kernel_clone_args *kargs);
 extern void sched_post_fork(struct task_struct *p);
--- a/kernel/fork.c~lazy-tlb-consolidate-lazy-tlb-mm-switching
+++ a/kernel/fork.c
@@ -854,11 +854,8 @@ static void do_shoot_lazy_tlb(void *arg)
 {
 	struct mm_struct *mm = arg;
 
-	if (current->active_mm == mm) {
-		WARN_ON_ONCE(current->mm);
-		current->active_mm = &init_mm;
-		switch_mm(mm, &init_mm, current);
-	}
+	if (current->active_mm == mm)
+		kthread_end_lazy_tlb_mm();
 }
 
 static void cleanup_lazy_tlbs(struct mm_struct *mm)
--- a/kernel/sched/core.c~lazy-tlb-consolidate-lazy-tlb-mm-switching
+++ a/kernel/sched/core.c
@@ -5347,6 +5347,29 @@ context_switch(struct rq *rq, struct tas
 }
 
 /*
+ * If this kthread has a user process's mm for its active_mm (aka lazy tlb mm)
+ * then switch away from it, to init_mm. Must not be called while using an
+ * mm with kthread_use_mm().
+ */
+void kthread_end_lazy_tlb_mm(void)
+{
+	struct mm_struct *mm = current->active_mm;
+
+	WARN_ON_ONCE(!irqs_disabled());
+
+	if (WARN_ON_ONCE(current->mm))
+		return; /* Not a kthread or doing kthread_use_mm */
+
+	if (mm != &init_mm) {
+		mmgrab_lazy_tlb(&init_mm);
+		current->active_mm = &init_mm;
+		switch_mm_irqs_off(mm, &init_mm, current);
+		finish_arch_post_lock_switch();
+		mmdrop_lazy_tlb(mm);
+	}
+}
+
+/*
  * nr_running and nr_context_switches:
  *
  * externally visible scheduler statistics: current number of runnable
@@ -9375,17 +9398,8 @@ void sched_setnuma(struct task_struct *p
  */
 void idle_task_prepare_exit(void)
 {
-	struct mm_struct *mm = current->active_mm;
-
 	WARN_ON(!irqs_disabled());
-
-	if (mm != &init_mm) {
-		mmgrab_lazy_tlb(&init_mm);
-		current->active_mm = &init_mm;
-		switch_mm_irqs_off(mm, &init_mm, current);
-		finish_arch_post_lock_switch();
-		mmdrop_lazy_tlb(mm);
-	}
+	kthread_end_lazy_tlb_mm();
 	/* finish_cpu() will mmdrop the init_mm ref after this CPU stops */
 }
 
_

Patches currently in -mm which might be from npiggin@gmail.com are


