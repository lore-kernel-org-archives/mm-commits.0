Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179DDC47094
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 23:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFD5961263
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 23:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFHAAz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230272AbhFHAAy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:00:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8F0D6120F;
        Mon,  7 Jun 2021 23:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623110342;
        bh=O+c+zfsr9jg132aTDo4F5Fe8r8vNge7AMANEndc/BPI=;
        h=Date:From:To:Subject:From;
        b=NCUnwjbQDmJqxx0FqwWoAoAFAOhehAS/56aMjJJAD5TOI2pXtdzcgzji2vH2a58UG
         F+bFOkqHChXfyXOVwOGbNmNbauAJMOUI5s838ukKYgn3Ezendoj5GMYT9emx7zjM8I
         AoS7vWpcv94ymuraqgFY5MQoYue1wsV0cgM054PQ=
Date:   Mon, 07 Jun 2021 16:59:01 -0700
From:   akpm@linux-foundation.org
To:     anton@ozlabs.org, benh@kernel.crashing.org, luto@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, paulus@ozlabs.org,
        rdunlap@infradead.org
Subject:  +
 lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch added to -mm
 tree
Message-ID: <20210607235901.Bg8XJlX48%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lazy tlb: shoot lazies, a non-refcounting lazy tlb option
has been added to the -mm tree.  Its filename is
     lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch

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
Subject: lazy tlb: shoot lazies, a non-refcounting lazy tlb option

On big systems, the mm refcount can become highly contented when doing a
lot of context switching with threaded applications (particularly
switching between the idle thread and an application thread).

Abandoning lazy tlb slows switching down quite a bit in the important
user->idle->user cases, so instead implement a non-refcounted scheme that
causes __mmdrop() to IPI all CPUs in the mm_cpumask and shoot down any
remaining lazy ones.

Shootdown IPIs are some concern, but they have not been observed to be a
big problem with this scheme (the powerpc implementation generated 314
additional interrupts on a 144 CPU system during a kernel compile).  There
are a number of strategies that could be employed to reduce IPIs if they
turn out to be a problem for some workload.

Link: https://lkml.kernel.org/r/20210605014216.446867-4-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig  |   13 ++++++++++++
 kernel/fork.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

--- a/arch/Kconfig~lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option
+++ a/arch/Kconfig
@@ -421,6 +421,19 @@ config ARCH_WANT_IRQS_OFF_ACTIVATE_MM
 # Use normal mm refcounting for MMU_LAZY_TLB kernel thread references.
 config MMU_LAZY_TLB_REFCOUNT
 	def_bool y
+	depends on !MMU_LAZY_TLB_SHOOTDOWN
+
+# Instead of refcounting the lazy mm struct for kernel thread references
+# (which can cause contention with multi-threaded apps on large multiprocessor
+# systems), this option causes __mmdrop to IPI all CPUs in the mm_cpumask and
+# switch to init_mm if they were using the to-be-freed mm as the lazy tlb. To
+# implement this, architectures must use _lazy_tlb variants of mm refcounting
+# when releasing kernel thread mm references, and mm_cpumask must include at
+# least all possible CPUs in which the mm might be lazy, at the time of the
+# final mmdrop. mmgrab/mmdrop in arch/ code must be switched to _lazy_tlb
+# postfix as necessary.
+config MMU_LAZY_TLB_SHOOTDOWN
+	bool
 
 config ARCH_HAVE_NMI_SAFE_CMPXCHG
 	bool
--- a/kernel/fork.c~lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option
+++ a/kernel/fork.c
@@ -674,6 +674,53 @@ static void check_mm(struct mm_struct *m
 #define allocate_mm()	(kmem_cache_alloc(mm_cachep, GFP_KERNEL))
 #define free_mm(mm)	(kmem_cache_free(mm_cachep, (mm)))
 
+static void do_shoot_lazy_tlb(void *arg)
+{
+	struct mm_struct *mm = arg;
+
+	if (current->active_mm == mm) {
+		WARN_ON_ONCE(current->mm);
+		current->active_mm = &init_mm;
+		switch_mm(mm, &init_mm, current);
+	}
+}
+
+static void do_check_lazy_tlb(void *arg)
+{
+	struct mm_struct *mm = arg;
+
+	WARN_ON_ONCE(current->active_mm == mm);
+}
+
+static void shoot_lazy_tlbs(struct mm_struct *mm)
+{
+	if (IS_ENABLED(CONFIG_MMU_LAZY_TLB_SHOOTDOWN)) {
+		/*
+		 * IPI overheads have not found to be expensive, but they could
+		 * be reduced in a number of possible ways, for example (in
+		 * roughly increasing order of complexity):
+		 * - A batch of mms requiring IPIs could be gathered and freed
+		 *   at once.
+		 * - CPUs could store their active mm somewhere that can be
+		 *   remotely checked without a lock, to filter out
+		 *   false-positives in the cpumask.
+		 * - After mm_users or mm_count reaches zero, switching away
+		 *   from the mm could clear mm_cpumask to reduce some IPIs
+		 *   (some batching or delaying would help).
+		 * - A delayed freeing and RCU-like quiescing sequence based on
+		 *   mm switching to avoid IPIs completely.
+		 */
+		on_each_cpu_mask(mm_cpumask(mm), do_shoot_lazy_tlb, (void *)mm, 1);
+		if (IS_ENABLED(CONFIG_DEBUG_VM))
+			on_each_cpu(do_check_lazy_tlb, (void *)mm, 1);
+	} else {
+		/*
+		 * In this case, lazy tlb mms are refounted and would not reach
+		 * __mmdrop until all CPUs have switched away and mmdrop()ed.
+		 */
+	}
+}
+
 /*
  * Called when the last reference to the mm
  * is dropped: either by a lazy thread or by
@@ -683,6 +730,10 @@ void __mmdrop(struct mm_struct *mm)
 {
 	BUG_ON(mm == &init_mm);
 	WARN_ON_ONCE(mm == current->mm);
+
+	/* Ensure no CPUs are using this as their lazy tlb mm */
+	shoot_lazy_tlbs(mm);
+
 	WARN_ON_ONCE(mm == current->active_mm);
 	mm_free_pgd(mm);
 	destroy_context(mm);
_

Patches currently in -mm which might be from npiggin@gmail.com are

lazy-tlb-introduce-lazy-mm-refcount-helper-functions.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch
powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

