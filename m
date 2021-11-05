Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17184C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02DDC6126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhKEUle (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhKEUlb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:41:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A608611C0;
        Fri,  5 Nov 2021 20:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144731;
        bh=PiwF7oMDAByYs1eamiVwxptlyfzBEUPJOm8BcTrHjF4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ubVkohP+TeIEt65JUxTaupiuFPhaU0hesOWTOyahGTD9Hedg+Dt6Ba9I32VB6xTL6
         mwL3fx2TqoDULkz/dxAa2iFm78piaKYEiZcwMV2eUIN50lwHLWL512rE2qJV0gJk7c
         ifoAVKUechPAXwvRHtaVMz/zPHdI6pqTiQfvs9H4=
Date:   Fri, 05 Nov 2021 13:38:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anton@ozlabs.org,
        benh@kernel.crashing.org, linux-mm@kvack.org, luto@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, paulus@ozlabs.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 080/262] lazy tlb: allow lazy tlb mm refcounting
 to be configurable
Message-ID: <20211105203851.Ise-VKP1_%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>
Subject: lazy tlb: allow lazy tlb mm refcounting to be configurable

Add CONFIG_MMU_TLB_REFCOUNT which enables refcounting of the lazy tlb mm
when it is context switched.  This can be disabled by architectures that
don't require this refcounting if they clean up lazy tlb mms when the last
refcount is dropped.  Currently this is always enabled, which is what
existing code does, so the patch is effectively a no-op.

Rename rq->prev_mm to rq->prev_lazy_mm, because that's what it is.

[akpm@linux-foundation.org: fix comment]
[npiggin@gmail.com: update comments]
  Link: https://lkml.kernel.org/r/1623121605.j47gdpccep.astroid@bobo.none
Link: https://lkml.kernel.org/r/20210605014216.446867-3-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig             |   14 ++++++++++++++
 include/linux/sched/mm.h |   14 ++++++++++++--
 kernel/sched/core.c      |   22 ++++++++++++++++++----
 kernel/sched/sched.h     |    4 +++-
 4 files changed, 47 insertions(+), 7 deletions(-)

--- a/arch/Kconfig~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable
+++ a/arch/Kconfig
@@ -428,6 +428,20 @@ config ARCH_WANT_IRQS_OFF_ACTIVATE_MM
 	  irqs disabled over activate_mm. Architectures that do IPI based TLB
 	  shootdowns should enable this.
 
+# Use normal mm refcounting for MMU_LAZY_TLB kernel thread references.
+# MMU_LAZY_TLB_REFCOUNT=n can improve the scalability of context switching
+# to/from kernel threads when the same mm is running on a lot of CPUs (a large
+# multi-threaded application), by reducing contention on the mm refcount.
+#
+# This can be disabled if the architecture ensures no CPUs are using an mm as a
+# "lazy tlb" beyond its final refcount (i.e., by the time __mmdrop frees the mm
+# or its kernel page tables). This could be arranged by arch_exit_mmap(), or
+# final exit(2) TLB flush, for example. arch code must also ensure the
+# _lazy_tlb variants of mmgrab/mmdrop are used when dropping the lazy reference
+# to a kthread ->active_mm (non-arch code has been converted already).
+config MMU_LAZY_TLB_REFCOUNT
+	def_bool y
+
 config ARCH_HAVE_NMI_SAFE_CMPXCHG
 	bool
 
--- a/include/linux/sched/mm.h~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable
+++ a/include/linux/sched/mm.h
@@ -52,12 +52,22 @@ static inline void mmdrop(struct mm_stru
 /* Helpers for lazy TLB mm refcounting */
 static inline void mmgrab_lazy_tlb(struct mm_struct *mm)
 {
-	mmgrab(mm);
+	if (IS_ENABLED(CONFIG_MMU_LAZY_TLB_REFCOUNT))
+		mmgrab(mm);
 }
 
 static inline void mmdrop_lazy_tlb(struct mm_struct *mm)
 {
-	mmdrop(mm);
+	if (IS_ENABLED(CONFIG_MMU_LAZY_TLB_REFCOUNT)) {
+		mmdrop(mm);
+	} else {
+		/*
+		 * mmdrop_lazy_tlb must provide a full memory barrier, see the
+		 * membarrier comment in finish_task_switch which relies on
+		 * this.
+		 */
+		smp_mb();
+	}
 }
 
 /**
--- a/kernel/sched/core.c~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable
+++ a/kernel/sched/core.c
@@ -4772,7 +4772,7 @@ static struct rq *finish_task_switch(str
 	__releases(rq->lock)
 {
 	struct rq *rq = this_rq();
-	struct mm_struct *mm = rq->prev_mm;
+	struct mm_struct *mm = NULL;
 	long prev_state;
 
 	/*
@@ -4791,7 +4791,10 @@ static struct rq *finish_task_switch(str
 		      current->comm, current->pid, preempt_count()))
 		preempt_count_set(FORK_PREEMPT_COUNT);
 
-	rq->prev_mm = NULL;
+#ifdef CONFIG_MMU_LAZY_TLB_REFCOUNT
+	mm = rq->prev_lazy_mm;
+	rq->prev_lazy_mm = NULL;
+#endif
 
 	/*
 	 * A task struct has one reference for the use as "current".
@@ -4927,9 +4930,20 @@ context_switch(struct rq *rq, struct tas
 		switch_mm_irqs_off(prev->active_mm, next->mm, next);
 
 		if (!prev->mm) {                        // from kernel
-			/* will mmdrop_lazy_tlb() in finish_task_switch(). */
-			rq->prev_mm = prev->active_mm;
+#ifdef CONFIG_MMU_LAZY_TLB_REFCOUNT
+			/* Will mmdrop_lazy_tlb() in finish_task_switch(). */
+			rq->prev_lazy_mm = prev->active_mm;
 			prev->active_mm = NULL;
+#else
+			/*
+			 * Without MMU_LAZY_TLB_REFCOUNT there is no lazy
+			 * tracking (because no rq->prev_lazy_mm) in
+			 * finish_task_switch, so no mmdrop_lazy_tlb(), so no
+			 * memory barrier for membarrier (see the membarrier
+			 * comment in finish_task_switch()).  Do it here.
+			 */
+			smp_mb();
+#endif
 		}
 	}
 
--- a/kernel/sched/sched.h~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable
+++ a/kernel/sched/sched.h
@@ -977,7 +977,9 @@ struct rq {
 	struct task_struct	*idle;
 	struct task_struct	*stop;
 	unsigned long		next_balance;
-	struct mm_struct	*prev_mm;
+#ifdef CONFIG_MMU_LAZY_TLB_REFCOUNT
+	struct mm_struct	*prev_lazy_mm;
+#endif
 
 	unsigned int		clock_update_flags;
 	u64			clock;
_
