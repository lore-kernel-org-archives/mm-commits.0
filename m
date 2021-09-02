Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241C5C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EA13610D2
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347571AbhIBV5Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347628AbhIBV5T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D09960F12;
        Thu,  2 Sep 2021 21:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619780;
        bh=BhxDNpVARis2frFmct7/+CvQ8G9IjaxZeoG6XegZF0c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DRe125AyZNc4Fyxg1QkA5D9PYBYV9zUkOC1NcHYjlTdyXYO78y4uUygTih5yTU1M/
         q6O07w1wEdfnt++3fn1MBX2vk7bch86WEpWbUZluBwTBQiZqRZAJhHQBV8PQckKcCJ
         4RBUSeHqcCfxKVI+Gl50rvY/Lyvuz/TbxV4fm9ec=
Date:   Thu, 02 Sep 2021 14:56:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anton@ozlabs.org,
        benh@kernel.crashing.org, linux-mm@kvack.org, luto@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, paulus@ozlabs.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 119/212] lazy tlb: shoot lazies, a non-refcounting
 lazy tlb option
Message-ID: <20210902215620._WXglfIJy%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

[npiggin@gmail.com: update comments]
  Link: https://lkml.kernel.org/r/1623121901.mszkmmum0n.astroid@bobo.none
Link: https://lkml.kernel.org/r/20210605014216.446867-4-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig  |   14 +++++++++++++
 kernel/fork.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

--- a/arch/Kconfig~lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option
+++ a/arch/Kconfig
@@ -438,6 +438,20 @@ config ARCH_WANT_IRQS_OFF_ACTIVATE_MM
 # to a kthread ->active_mm (non-arch code has been converted already).
 config MMU_LAZY_TLB_REFCOUNT
 	def_bool y
+	depends on !MMU_LAZY_TLB_SHOOTDOWN
+
+# This option allows MMU_LAZY_TLB_REFCOUNT=n. It ensures no CPUs are using an
+# mm as a lazy tlb beyond its last reference count, by shooting down these
+# users before the mm is deallocated. __mmdrop() first IPIs all CPUs that may
+# be using the mm as a lazy tlb, so that they may switch themselves to using
+# init_mm for their active mm. mm_cpumask(mm) is used to determine which CPUs
+# may be using mm as a lazy tlb mm.
+#
+# To implement this, an arch must ensure mm_cpumask(mm) contains at least all
+# possible CPUs in which the mm is lazy, and it must meet the requirements for
+# MMU_LAZY_TLB_REFCOUNT=n (see above).
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
