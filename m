Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC20C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 928E460E8B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347917AbhIBV5X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347921AbhIBV5N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 724F86056B;
        Thu,  2 Sep 2021 21:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619774;
        bh=IPfkk6QQG/76t3gz7Ow4XtKlcRZwjotE1ru0dMHgOBA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oYrRF+5yCSq/h2s+TyiMDVcohSm0YWZAo/zARGKqAyfDCUqIVG8kPnHEN3sc093gT
         gA1V3GI9X8a5Kd7v68TqUmPUXEp6OBcJ8aJ1PfAqNY0aqsXWisUN8UnhZdhN7QsGuz
         LBkk9vS1kTCVunizvN5OF1I9BnVm5OJ4N6/NPErE=
Date:   Thu, 02 Sep 2021 14:56:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anton@ozlabs.org,
        benh@kernel.crashing.org, linux-mm@kvack.org, luto@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, paulus@ozlabs.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 117/212] lazy tlb: introduce lazy mm refcount
 helper functions
Message-ID: <20210902215614.5UnZ9KeL9%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>
Subject: lazy tlb: introduce lazy mm refcount helper functions

Patch series "shoot lazy tlbs", v4.

On a 16-socket 192-core POWER8 system, a context switching benchmark with
as many software threads as CPUs (so each switch will go in and out of
idle), upstream can achieve a rate of about 1 million context switches per
second.  After this series it goes up to 118 million.


This patch (of 4):

Add explicit _lazy_tlb annotated functions for lazy mm refcounting.  This
makes lazy mm references more obvious, and allows explicit refcounting to
be removed if it is not used.

If a kernel thread's current lazy tlb mm happens to be the one it wants to
use, then kthread_use_mm() cleverly transfers the mm refcount from the
lazy tlb mm reference to the returned reference.  If the lazy tlb mm
reference is no longer identical to a normal reference, this trick does
not work, so that is changed to be explicit about the two references.

[npiggin@gmail.com: fix a refcounting bug in kthread_use_mm]
  Link: https://lkml.kernel.org/r/1623125298.bx63h3mopj.astroid@bobo.none
Link: https://lkml.kernel.org/r/20210605014216.446867-1-npiggin@gmail.com
Link: https://lkml.kernel.org/r/20210605014216.446867-2-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-rpc/ecard.c            |    2 +-
 arch/powerpc/kernel/smp.c            |    2 +-
 arch/powerpc/mm/book3s64/radix_tlb.c |    4 ++--
 fs/exec.c                            |    4 ++--
 include/linux/sched/mm.h             |   11 +++++++++++
 kernel/cpu.c                         |    2 +-
 kernel/exit.c                        |    2 +-
 kernel/kthread.c                     |   21 +++++++++++++--------
 kernel/sched/core.c                  |   15 ++++++++-------
 9 files changed, 40 insertions(+), 23 deletions(-)

--- a/arch/arm/mach-rpc/ecard.c~lazy-tlb-introduce-lazy-mm-refcount-helper-functions
+++ a/arch/arm/mach-rpc/ecard.c
@@ -253,7 +253,7 @@ static int ecard_init_mm(void)
 	current->mm = mm;
 	current->active_mm = mm;
 	activate_mm(active_mm, mm);
-	mmdrop(active_mm);
+	mmdrop_lazy_tlb(active_mm);
 	ecard_init_pgtables(mm);
 	return 0;
 }
--- a/arch/powerpc/kernel/smp.c~lazy-tlb-introduce-lazy-mm-refcount-helper-functions
+++ a/arch/powerpc/kernel/smp.c
@@ -1556,7 +1556,7 @@ void start_secondary(void *unused)
 	if (IS_ENABLED(CONFIG_PPC32))
 		setup_kup();
 
-	mmgrab(&init_mm);
+	mmgrab_lazy_tlb(&init_mm);
 	current->active_mm = &init_mm;
 
 	smp_store_cpu_info(cpu);
--- a/arch/powerpc/mm/book3s64/radix_tlb.c~lazy-tlb-introduce-lazy-mm-refcount-helper-functions
+++ a/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -785,10 +785,10 @@ void exit_lazy_flush_tlb(struct mm_struc
 	if (current->active_mm == mm) {
 		WARN_ON_ONCE(current->mm != NULL);
 		/* Is a kernel thread and is using mm as the lazy tlb */
-		mmgrab(&init_mm);
+		mmgrab_lazy_tlb(&init_mm);
 		current->active_mm = &init_mm;
 		switch_mm_irqs_off(mm, &init_mm, current);
-		mmdrop(mm);
+		mmdrop_lazy_tlb(mm);
 	}
 
 	/*
--- a/fs/exec.c~lazy-tlb-introduce-lazy-mm-refcount-helper-functions
+++ a/fs/exec.c
@@ -1026,9 +1026,9 @@ static int exec_mmap(struct mm_struct *m
 		setmax_mm_hiwater_rss(&tsk->signal->maxrss, old_mm);
 		mm_update_next_owner(old_mm);
 		mmput(old_mm);
-		return 0;
+	} else {
+		mmdrop_lazy_tlb(active_mm);
 	}
-	mmdrop(active_mm);
 	return 0;
 }
 
--- a/include/linux/sched/mm.h~lazy-tlb-introduce-lazy-mm-refcount-helper-functions
+++ a/include/linux/sched/mm.h
@@ -49,6 +49,17 @@ static inline void mmdrop(struct mm_stru
 		__mmdrop(mm);
 }
 
+/* Helpers for lazy TLB mm refcounting */
+static inline void mmgrab_lazy_tlb(struct mm_struct *mm)
+{
+	mmgrab(mm);
+}
+
+static inline void mmdrop_lazy_tlb(struct mm_struct *mm)
+{
+	mmdrop(mm);
+}
+
 /**
  * mmget() - Pin the address space associated with a &struct mm_struct.
  * @mm: The address space to pin.
--- a/kernel/cpu.c~lazy-tlb-introduce-lazy-mm-refcount-helper-functions
+++ a/kernel/cpu.c
@@ -603,7 +603,7 @@ static int finish_cpu(unsigned int cpu)
 	 */
 	if (mm != &init_mm)
 		idle->active_mm = &init_mm;
-	mmdrop(mm);
+	mmdrop_lazy_tlb(mm);
 	return 0;
 }
 
--- a/kernel/exit.c~lazy-tlb-introduce-lazy-mm-refcount-helper-functions
+++ a/kernel/exit.c
@@ -475,7 +475,7 @@ static void exit_mm(void)
 		__set_current_state(TASK_RUNNING);
 		mmap_read_lock(mm);
 	}
-	mmgrab(mm);
+	mmgrab_lazy_tlb(mm);
 	BUG_ON(mm != current->active_mm);
 	/* more a memory barrier than a real lock */
 	task_lock(current);
--- a/kernel/kthread.c~lazy-tlb-introduce-lazy-mm-refcount-helper-functions
+++ a/kernel/kthread.c
@@ -1350,14 +1350,19 @@ void kthread_use_mm(struct mm_struct *mm
 	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
 	WARN_ON_ONCE(tsk->mm);
 
+	/*
+	 * It's possible that tsk->active_mm == mm here, but we must
+	 * still mmgrab(mm) and mmdrop_lazy_tlb(active_mm), because lazy
+	 * mm may not have its own refcount (see mmgrab/drop_lazy_tlb()).
+	 */
+	mmgrab(mm);
+
 	task_lock(tsk);
 	/* Hold off tlb flush IPIs while switching mm's */
 	local_irq_disable();
 	active_mm = tsk->active_mm;
-	if (active_mm != mm) {
-		mmgrab(mm);
+	if (active_mm != mm)
 		tsk->active_mm = mm;
-	}
 	tsk->mm = mm;
 	membarrier_update_current_mm(mm);
 	switch_mm_irqs_off(active_mm, mm, tsk);
@@ -1374,12 +1379,9 @@ void kthread_use_mm(struct mm_struct *mm
 	 * memory barrier after storing to tsk->mm, before accessing
 	 * user-space memory. A full memory barrier for membarrier
 	 * {PRIVATE,GLOBAL}_EXPEDITED is implicitly provided by
-	 * mmdrop(), or explicitly with smp_mb().
+	 * mmdrop_lazy_tlb().
 	 */
-	if (active_mm != mm)
-		mmdrop(active_mm);
-	else
-		smp_mb();
+	mmdrop_lazy_tlb(active_mm);
 
 	to_kthread(tsk)->oldfs = force_uaccess_begin();
 }
@@ -1411,10 +1413,13 @@ void kthread_unuse_mm(struct mm_struct *
 	local_irq_disable();
 	tsk->mm = NULL;
 	membarrier_update_current_mm(NULL);
+	mmgrab_lazy_tlb(mm);
 	/* active_mm is still 'mm' */
 	enter_lazy_tlb(mm, tsk);
 	local_irq_enable();
 	task_unlock(tsk);
+
+	mmdrop(mm);
 }
 EXPORT_SYMBOL_GPL(kthread_unuse_mm);
 
--- a/kernel/sched/core.c~lazy-tlb-introduce-lazy-mm-refcount-helper-functions
+++ a/kernel/sched/core.c
@@ -4586,13 +4586,14 @@ static struct rq *finish_task_switch(str
 	 * rq->curr, before returning to userspace, so provide them here:
 	 *
 	 * - a full memory barrier for {PRIVATE,GLOBAL}_EXPEDITED, implicitly
-	 *   provided by mmdrop(),
+	 *   provided by mmdrop_lazy_tlb(),
 	 * - a sync_core for SYNC_CORE.
 	 */
 	if (mm) {
 		membarrier_mm_sync_core_before_usermode(mm);
-		mmdrop(mm);
+		mmdrop_lazy_tlb(mm);
 	}
+
 	if (unlikely(prev_state == TASK_DEAD)) {
 		if (prev->sched_class->task_dead)
 			prev->sched_class->task_dead(prev);
@@ -4655,9 +4656,9 @@ context_switch(struct rq *rq, struct tas
 
 	/*
 	 * kernel -> kernel   lazy + transfer active
-	 *   user -> kernel   lazy + mmgrab() active
+	 *   user -> kernel   lazy + mmgrab_lazy_tlb() active
 	 *
-	 * kernel ->   user   switch + mmdrop() active
+	 * kernel ->   user   switch + mmdrop_lazy_tlb() active
 	 *   user ->   user   switch
 	 */
 	if (!next->mm) {                                // to kernel
@@ -4665,7 +4666,7 @@ context_switch(struct rq *rq, struct tas
 
 		next->active_mm = prev->active_mm;
 		if (prev->mm)                           // from user
-			mmgrab(prev->active_mm);
+			mmgrab_lazy_tlb(prev->active_mm);
 		else
 			prev->active_mm = NULL;
 	} else {                                        // to user
@@ -4681,7 +4682,7 @@ context_switch(struct rq *rq, struct tas
 		switch_mm_irqs_off(prev->active_mm, next->mm, next);
 
 		if (!prev->mm) {                        // from kernel
-			/* will mmdrop() in finish_task_switch(). */
+			/* will mmdrop_lazy_tlb() in finish_task_switch(). */
 			rq->prev_mm = prev->active_mm;
 			prev->active_mm = NULL;
 		}
@@ -9128,7 +9129,7 @@ void __init sched_init(void)
 	/*
 	 * The boot idle thread does lazy MMU switching as well:
 	 */
-	mmgrab(&init_mm);
+	mmgrab_lazy_tlb(&init_mm);
 	enter_lazy_tlb(&init_mm, current);
 
 	/*
_
