Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F571C47082
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 23:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA4E861249
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 23:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhFHAAq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbhFHAAp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:00:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1452B60FE9;
        Mon,  7 Jun 2021 23:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623110333;
        bh=ooM6BeOz9q+mKU3SgGMiMMex99+/taKlXnmImUDmfBs=;
        h=Date:From:To:Subject:From;
        b=vU66RmjsRiYqXZD0w8nW+oWcGdqo1MLg+IWFUZJUoAFyXtCoHq7AK1vKT92kYoRTX
         tAb+A7aaaKuWKAJPxiL3CGzIzijRPxKSwPZlWFam+4AOZLZtUTB39st+Acc95yLNw1
         7Pid/0bmWn+QXc2UZQSWDSyKo/cHHZd97HHnS49k=
Date:   Mon, 07 Jun 2021 16:58:52 -0700
From:   akpm@linux-foundation.org
To:     anton@ozlabs.org, benh@kernel.crashing.org, luto@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, paulus@ozlabs.org,
        rdunlap@infradead.org
Subject:  +
 lazy-tlb-introduce-lazy-mm-refcount-helper-functions.patch added to -mm
 tree
Message-ID: <20210607235852.svngXZYVv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lazy tlb: introduce lazy mm refcount helper functions
has been added to the -mm tree.  Its filename is
     lazy-tlb-introduce-lazy-mm-refcount-helper-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lazy-tlb-introduce-lazy-mm-refcount-helper-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lazy-tlb-introduce-lazy-mm-refcount-helper-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
 kernel/kthread.c                     |   11 +++++++----
 kernel/sched/core.c                  |   15 ++++++++-------
 9 files changed, 34 insertions(+), 19 deletions(-)

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
@@ -1541,7 +1541,7 @@ void start_secondary(void *unused)
 {
 	unsigned int cpu = raw_smp_processor_id();
 
-	mmgrab(&init_mm);
+	mmgrab_lazy_tlb(&init_mm);
 	current->active_mm = &init_mm;
 
 	smp_store_cpu_info(cpu);
--- a/arch/powerpc/mm/book3s64/radix_tlb.c~lazy-tlb-introduce-lazy-mm-refcount-helper-functions
+++ a/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -663,10 +663,10 @@ void exit_lazy_flush_tlb(struct mm_struc
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
@@ -1029,9 +1029,9 @@ static int exec_mmap(struct mm_struct *m
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
@@ -602,7 +602,7 @@ static int finish_cpu(unsigned int cpu)
 	 */
 	if (mm != &init_mm)
 		idle->active_mm = &init_mm;
-	mmdrop(mm);
+	mmdrop_lazy_tlb(mm);
 	return 0;
 }
 
--- a/kernel/exit.c~lazy-tlb-introduce-lazy-mm-refcount-helper-functions
+++ a/kernel/exit.c
@@ -476,7 +476,7 @@ static void exit_mm(void)
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
@@ -1314,14 +1314,14 @@ void kthread_use_mm(struct mm_struct *mm
 	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
 	WARN_ON_ONCE(tsk->mm);
 
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
@@ -1341,7 +1341,7 @@ void kthread_use_mm(struct mm_struct *mm
 	 * mmdrop(), or explicitly with smp_mb().
 	 */
 	if (active_mm != mm)
-		mmdrop(active_mm);
+		mmdrop_lazy_tlb(active_mm);
 	else
 		smp_mb();
 
@@ -1375,10 +1375,13 @@ void kthread_unuse_mm(struct mm_struct *
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
@@ -4229,13 +4229,14 @@ static struct rq *finish_task_switch(str
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
@@ -4299,9 +4300,9 @@ context_switch(struct rq *rq, struct tas
 
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
@@ -4309,7 +4310,7 @@ context_switch(struct rq *rq, struct tas
 
 		next->active_mm = prev->active_mm;
 		if (prev->mm)                           // from user
-			mmgrab(prev->active_mm);
+			mmgrab_lazy_tlb(prev->active_mm);
 		else
 			prev->active_mm = NULL;
 	} else {                                        // to user
@@ -4325,7 +4326,7 @@ context_switch(struct rq *rq, struct tas
 		switch_mm_irqs_off(prev->active_mm, next->mm, next);
 
 		if (!prev->mm) {                        // from kernel
-			/* will mmdrop() in finish_task_switch(). */
+			/* will mmdrop_lazy_tlb() in finish_task_switch(). */
 			rq->prev_mm = prev->active_mm;
 			prev->active_mm = NULL;
 		}
@@ -8239,7 +8240,7 @@ void __init sched_init(void)
 	/*
 	 * The boot idle thread does lazy MMU switching as well:
 	 */
-	mmgrab(&init_mm);
+	mmgrab_lazy_tlb(&init_mm);
 	enter_lazy_tlb(&init_mm, current);
 
 	/*
_

Patches currently in -mm which might be from npiggin@gmail.com are

lazy-tlb-introduce-lazy-mm-refcount-helper-functions.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch
powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

