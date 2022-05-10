Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592FFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbiEJEUF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbiEJESa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:18:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517AB157939
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFC9FB81AF4
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E81C385C2;
        Tue, 10 May 2022 04:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156057;
        bh=Tw/YDlZE4oWpcJaeXbtHu1kEddbOwcYY8wfjWWRE/sM=;
        h=Date:To:From:Subject:From;
        b=NWK8MNF73vzyJmiBpdnPxlXUItYPQzhl2YPUZA6OyRuvLvaAHe/yX8gnU+dU/FZ11
         sFNEdGcXpx1TQwE06f9Fu3DDnUIZ6LejvyvpIRZKcEqQObVXfEsn/I5318cQFI5igu
         WZ5vJ7jnu7fgyXbAn8GDsXRxACTITJyi5DshLGaY=
Date:   Mon, 09 May 2022 21:14:17 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, dvyukov@google.com, bigeasy@linutronix.de,
        andreyknvl@gmail.com, qiang1.zhang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel.patch removed from -mm tree
Message-Id: <20220510041417.A3E81C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: fix sleeping function called from invalid context on RT kernel
has been removed from the -mm tree.  Its filename was
     kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel.patch

This patch was dropped because it was merged into mm-stable

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

[akpm@linux-foundation.org: reduce ifdeffery]
Link: https://lkml.kernel.org/r/20220401134649.2222485-1-qiang1.zhang@intel.com
Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |   52 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

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
 
@@ -308,10 +319,31 @@ static void qlist_move_cache(struct qlis
 	}
 }
 
-static void per_cpu_remove_cache(void *arg)
+#ifndef CONFIG_PREEMPT_RT
+static void __per_cpu_remove_cache(struct qlist_head *q, void *arg)
 {
 	struct kmem_cache *cache = arg;
 	struct qlist_head to_free = QLIST_INIT;
+
+	qlist_move_cache(q, &to_free, cache);
+	qlist_free_all(&to_free, cache);
+}
+#else
+static void __per_cpu_remove_cache(struct qlist_head *q, void *arg)
+{
+	struct kmem_cache *cache = arg;
+	unsigned long flags;
+	struct cpu_shrink_qlist *sq;
+
+	sq = this_cpu_ptr(&shrink_qlist);
+	raw_spin_lock_irqsave(&sq->lock, flags);
+	qlist_move_cache(q, &sq->qlist, cache);
+	raw_spin_unlock_irqrestore(&sq->lock, flags);
+}
+#endif
+
+static void per_cpu_remove_cache(void *arg)
+{
 	struct qlist_head *q;
 
 	q = this_cpu_ptr(&cpu_quarantine);
@@ -322,8 +354,7 @@ static void per_cpu_remove_cache(void *a
 	 */
 	if (READ_ONCE(q->offline))
 		return;
-	qlist_move_cache(q, &to_free, cache);
-	qlist_free_all(&to_free, cache);
+	__per_cpu_remove_cache(q, arg);
 }
 
 /* Free all quarantined objects belonging to cache. */
@@ -341,6 +372,21 @@ void kasan_quarantine_remove_cache(struc
 	 */
 	on_each_cpu(per_cpu_remove_cache, cache, 1);
 
+#ifdef CONFIG_PREEMPT_RT
+	{
+		int cpu;
+		struct cpu_shrink_qlist *sq;
+
+		for_each_online_cpu(cpu) {
+			sq = per_cpu_ptr(&shrink_qlist, cpu);
+			raw_spin_lock_irqsave(&sq->lock, flags);
+			qlist_move_cache(&sq->qlist, &to_free, cache);
+			raw_spin_unlock_irqrestore(&sq->lock, flags);
+		}
+		qlist_free_all(&to_free, cache);
+	}
+#endif
+
 	raw_spin_lock_irqsave(&quarantine_lock, flags);
 	for (i = 0; i < QUARANTINE_BATCHES; i++) {
 		if (qlist_empty(&global_quarantine[i]))
_

Patches currently in -mm which might be from qiang1.zhang@intel.com are


