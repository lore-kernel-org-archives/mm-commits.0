Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3066C77B6E
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjC1XVL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjC1XVJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72DD1BFD
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F3DF619F4
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92971C433EF;
        Tue, 28 Mar 2023 23:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045666;
        bh=ro0X2vV3oebRRa2KhQT9BASN6f5JGUCCaLchduO32r4=;
        h=Date:To:From:Subject:From;
        b=fm55L6Ph8zU5dG2sZFAHI0tpJqpUklsEMwAnyxCDKaEx/rZakKkDHntVID9mrh0BB
         xSbVZooJz4zeVuD4tqCdXCPuZbnQBkenmlRLGP4gN2WkR7CKDeXkeQzRtUTYDVKLwU
         CHyqtGeOAKBJy0DoR+/J5+Sieq2ktQIn6xx5HFDw=
Date:   Tue, 28 Mar 2023 16:21:06 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        torvalds@linux-foundation.org, riel@redhat.com,
        peterz@infradead.org, nadav.amit@gmail.com, mpe@ellerman.id.au,
        luto@kernel.org, dave.hansen@linux.intel.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        npiggin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions.patch removed from -mm tree
Message-Id: <20230328232106.92971C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lazy tlb: introduce lazy tlb mm refcount helper functions
has been removed from the -mm tree.  Its filename was
     lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: lazy tlb: introduce lazy tlb mm refcount helper functions
Date: Fri, 3 Feb 2023 17:18:34 +1000

Add explicit _lazy_tlb annotated functions for lazy tlb mm refcounting. 
This makes the lazy tlb mm references more obvious, and allows the
refcounting scheme to be modified in later changes.  There is no
functional change with this patch.

Link: https://lkml.kernel.org/r/20230203071837.1136453-3-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-rpc/ecard.c            |    2 +-
 arch/powerpc/kernel/smp.c            |    2 +-
 arch/powerpc/mm/book3s64/radix_tlb.c |    4 ++--
 fs/exec.c                            |    2 +-
 include/linux/sched/mm.h             |   16 ++++++++++++++++
 kernel/cpu.c                         |    2 +-
 kernel/exit.c                        |    2 +-
 kernel/kthread.c                     |   12 ++++++++++--
 kernel/sched/core.c                  |   15 ++++++++-------
 9 files changed, 41 insertions(+), 16 deletions(-)

--- a/arch/arm/mach-rpc/ecard.c~lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions
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
--- a/arch/powerpc/kernel/smp.c~lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions
+++ a/arch/powerpc/kernel/smp.c
@@ -1611,7 +1611,7 @@ void start_secondary(void *unused)
 	if (IS_ENABLED(CONFIG_PPC32))
 		setup_kup();
 
-	mmgrab(&init_mm);
+	mmgrab_lazy_tlb(&init_mm);
 	current->active_mm = &init_mm;
 
 	smp_store_cpu_info(cpu);
--- a/arch/powerpc/mm/book3s64/radix_tlb.c~lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions
+++ a/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -797,10 +797,10 @@ void exit_lazy_flush_tlb(struct mm_struc
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
--- a/fs/exec.c~lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions
+++ a/fs/exec.c
@@ -1034,7 +1034,7 @@ static int exec_mmap(struct mm_struct *m
 		mmput(old_mm);
 		return 0;
 	}
-	mmdrop(active_mm);
+	mmdrop_lazy_tlb(active_mm);
 	return 0;
 }
 
--- a/include/linux/sched/mm.h~lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions
+++ a/include/linux/sched/mm.h
@@ -79,6 +79,22 @@ static inline void mmdrop_sched(struct m
 }
 #endif
 
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
+static inline void mmdrop_lazy_tlb_sched(struct mm_struct *mm)
+{
+	mmdrop_sched(mm);
+}
+
 /**
  * mmget() - Pin the address space associated with a &struct mm_struct.
  * @mm: The address space to pin.
--- a/kernel/cpu.c~lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions
+++ a/kernel/cpu.c
@@ -623,7 +623,7 @@ static int finish_cpu(unsigned int cpu)
 	 */
 	if (mm != &init_mm)
 		idle->active_mm = &init_mm;
-	mmdrop(mm);
+	mmdrop_lazy_tlb(mm);
 	return 0;
 }
 
--- a/kernel/exit.c~lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions
+++ a/kernel/exit.c
@@ -537,7 +537,7 @@ static void exit_mm(void)
 		return;
 	sync_mm_rss(mm);
 	mmap_read_lock(mm);
-	mmgrab(mm);
+	mmgrab_lazy_tlb(mm);
 	BUG_ON(mm != current->active_mm);
 	/* more a memory barrier than a real lock */
 	task_lock(current);
--- a/kernel/kthread.c~lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions
+++ a/kernel/kthread.c
@@ -1415,6 +1415,11 @@ void kthread_use_mm(struct mm_struct *mm
 	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
 	WARN_ON_ONCE(tsk->mm);
 
+	/*
+	 * It is possible for mm to be the same as tsk->active_mm, but
+	 * we must still mmgrab(mm) and mmdrop_lazy_tlb(active_mm),
+	 * because these references are not equivalent.
+	 */
 	mmgrab(mm);
 
 	task_lock(tsk);
@@ -1438,9 +1443,9 @@ void kthread_use_mm(struct mm_struct *mm
 	 * memory barrier after storing to tsk->mm, before accessing
 	 * user-space memory. A full memory barrier for membarrier
 	 * {PRIVATE,GLOBAL}_EXPEDITED is implicitly provided by
-	 * mmdrop().
+	 * mmdrop_lazy_tlb().
 	 */
-	mmdrop(active_mm);
+	mmdrop_lazy_tlb(active_mm);
 }
 EXPORT_SYMBOL_GPL(kthread_use_mm);
 
@@ -1468,10 +1473,13 @@ void kthread_unuse_mm(struct mm_struct *
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
 
--- a/kernel/sched/core.c~lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions
+++ a/kernel/sched/core.c
@@ -5203,13 +5203,14 @@ static struct rq *finish_task_switch(str
 	 * rq->curr, before returning to userspace, so provide them here:
 	 *
 	 * - a full memory barrier for {PRIVATE,GLOBAL}_EXPEDITED, implicitly
-	 *   provided by mmdrop(),
+	 *   provided by mmdrop_lazy_tlb(),
 	 * - a sync_core for SYNC_CORE.
 	 */
 	if (mm) {
 		membarrier_mm_sync_core_before_usermode(mm);
-		mmdrop_sched(mm);
+		mmdrop_lazy_tlb_sched(mm);
 	}
+
 	if (unlikely(prev_state == TASK_DEAD)) {
 		if (prev->sched_class->task_dead)
 			prev->sched_class->task_dead(prev);
@@ -5266,9 +5267,9 @@ context_switch(struct rq *rq, struct tas
 
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
@@ -5276,7 +5277,7 @@ context_switch(struct rq *rq, struct tas
 
 		next->active_mm = prev->active_mm;
 		if (prev->mm)                           // from user
-			mmgrab(prev->active_mm);
+			mmgrab_lazy_tlb(prev->active_mm);
 		else
 			prev->active_mm = NULL;
 	} else {                                        // to user
@@ -5293,7 +5294,7 @@ context_switch(struct rq *rq, struct tas
 		lru_gen_use_mm(next->mm);
 
 		if (!prev->mm) {                        // from kernel
-			/* will mmdrop() in finish_task_switch(). */
+			/* will mmdrop_lazy_tlb() in finish_task_switch(). */
 			rq->prev_mm = prev->active_mm;
 			prev->active_mm = NULL;
 		}
@@ -9935,7 +9936,7 @@ void __init sched_init(void)
 	/*
 	 * The boot idle thread does lazy MMU switching as well:
 	 */
-	mmgrab(&init_mm);
+	mmgrab_lazy_tlb(&init_mm);
 	enter_lazy_tlb(&init_mm, current);
 
 	/*
_

Patches currently in -mm which might be from npiggin@gmail.com are


