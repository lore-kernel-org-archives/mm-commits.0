Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351EEC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 21:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236714AbiDFVk0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Apr 2022 17:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbiDFVhA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Apr 2022 17:37:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF762C5C
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 13:50:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B95E616F3
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 20:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7E9C385A3;
        Wed,  6 Apr 2022 20:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649278259;
        bh=spy8LYaPR+JZkmjdAQp30zjMA/v8xnYPr1FpIxwRI0k=;
        h=Date:To:From:Subject:From;
        b=BG23MjPLbr2dIiR4Kth3Jw3FW1K3K6THNbEiC1Am7M3etaB/oiQziH+cwUHG+lOTq
         sVDO2Iz6Aumsd5KL472P6+Rffg4n+TrcTt6Yj2Xt+zz+4cb4NV4QiMxoxFhm/Z7sWI
         EjPEG1kRKo+tgwTk+XvwiaDq6Un1RDpIxrhDaTeU=
Date:   Wed, 06 Apr 2022 13:50:58 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, dvyukov@google.com, bigeasy@linutronix.de,
        andreyknvl@gmail.com, qiang1.zhang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel.patch added to -mm tree
Message-Id: <20220406205058.EA7E9C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix sleeping function called from invalid context on RT kernel
has been added to the -mm tree.  Its filename is
     kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zqiang <qiang1.zhang@intel.com>
Subject: kasan: fix sleeping function called from invalid context on RT kernel

BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:46
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1, name: swapper/0
preempt_count: 1, expected: 0
...........
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.1-rt16-yocto-preempt-rt #22
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
Call Trace:
<TASK>
dump_stack_lvl+0x60/0x8c
dump_stack+0x10/0x12
 __might_resched.cold+0x13b/0x173
rt_spin_lock+0x5b/0xf0
 ___cache_free+0xa5/0x180
qlist_free_all+0x7a/0x160
per_cpu_remove_cache+0x5f/0x70
smp_call_function_many_cond+0x4c4/0x4f0
on_each_cpu_cond_mask+0x49/0xc0
kasan_quarantine_remove_cache+0x54/0xf0
kasan_cache_shrink+0x9/0x10
kmem_cache_shrink+0x13/0x20
acpi_os_purge_cache+0xe/0x20
acpi_purge_cached_objects+0x21/0x6d
acpi_initialize_objects+0x15/0x3b
acpi_init+0x130/0x5ba
do_one_initcall+0xe5/0x5b0
kernel_init_freeable+0x34f/0x3ad
kernel_init+0x1e/0x140
ret_from_fork+0x22/0x30

When the kmem_cache_shrink() was called, the IPI was triggered, the
___cache_free() is called in IPI interrupt context, the local-lock or
spin-lock will be acquired.  On PREEMPT_RT kernel, these locks are
replaced with sleepbale rt-spinlock, so the above problem is triggered. 
Fix it by moving the qlist_free_allfrom() from IPI interrupt context to
task context when PREEMPT_RT is enabled.

Link: https://lkml.kernel.org/r/20220401134649.2222485-1-qiang1.zhang@intel.com
Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |   40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

--- a/mm/kasan/quarantine.c~kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel
+++ a/mm/kasan/quarantine.c
@@ -99,6 +99,17 @@ static unsigned long quarantine_size;
 static DEFINE_RAW_SPINLOCK(quarantine_lock);
 DEFINE_STATIC_SRCU(remove_cache_srcu);
 
+#ifdef CONFIG_PREEMPT_RT
+struct cpu_shrink_qlist {
+	raw_spinlock_t lock;
+	struct qlist_head qlist;
+};
+
+static DEFINE_PER_CPU(struct cpu_shrink_qlist, shrink_qlist) = {
+	.lock = __RAW_SPIN_LOCK_UNLOCKED(shrink_qlist.lock),
+};
+#endif
+
 /* Maximum size of the global queue. */
 static unsigned long quarantine_max_size;
 
@@ -311,12 +322,23 @@ static void qlist_move_cache(struct qlis
 static void per_cpu_remove_cache(void *arg)
 {
 	struct kmem_cache *cache = arg;
-	struct qlist_head to_free = QLIST_INIT;
 	struct qlist_head *q;
-
+#ifndef CONFIG_PREEMPT_RT
+	struct qlist_head to_free = QLIST_INIT;
+#else
+	unsigned long flags;
+	struct cpu_shrink_qlist *sq;
+#endif
 	q = this_cpu_ptr(&cpu_quarantine);
+#ifndef CONFIG_PREEMPT_RT
 	qlist_move_cache(q, &to_free, cache);
 	qlist_free_all(&to_free, cache);
+#else
+	sq = this_cpu_ptr(&shrink_qlist);
+	raw_spin_lock_irqsave(&sq->lock, flags);
+	qlist_move_cache(q, &sq->qlist, cache);
+	raw_spin_unlock_irqrestore(&sq->lock, flags);
+#endif
 }
 
 /* Free all quarantined objects belonging to cache. */
@@ -324,6 +346,10 @@ void kasan_quarantine_remove_cache(struc
 {
 	unsigned long flags, i;
 	struct qlist_head to_free = QLIST_INIT;
+#ifdef CONFIG_PREEMPT_RT
+	int cpu;
+	struct cpu_shrink_qlist *sq;
+#endif
 
 	/*
 	 * Must be careful to not miss any objects that are being moved from
@@ -334,6 +360,16 @@ void kasan_quarantine_remove_cache(struc
 	 */
 	on_each_cpu(per_cpu_remove_cache, cache, 1);
 
+#ifdef CONFIG_PREEMPT_RT
+	for_each_online_cpu(cpu) {
+		sq = per_cpu_ptr(&shrink_qlist, cpu);
+		raw_spin_lock_irqsave(&sq->lock, flags);
+		qlist_move_cache(&sq->qlist, &to_free, cache);
+		raw_spin_unlock_irqrestore(&sq->lock, flags);
+	}
+	qlist_free_all(&to_free, cache);
+#endif
+
 	raw_spin_lock_irqsave(&quarantine_lock, flags);
 	for (i = 0; i < QUARANTINE_BATCHES; i++) {
 		if (qlist_empty(&global_quarantine[i]))
_

Patches currently in -mm which might be from qiang1.zhang@intel.com are

irq_work-use-kasan_record_aux_stack_noalloc-record-callstack.patch
kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel.patch

