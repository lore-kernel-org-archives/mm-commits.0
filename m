From: akpm@linux-foundation.org
Subject: [merged] kernel-smpc-cleanups.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:41 -0700
Message-ID: <20130507174741.82A5F5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:48733 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab3EGRro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:44 -0400
Received: by mail-vb0-f73.google.com with SMTP id e13so85124vbg.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, axboe@kernel.dk, mingo@elte.hu, rostedt@goodmis.org, shli@fusionio.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/smp.c: cleanups
has been removed from the -mm tree.  Its filename was
     kernel-smpc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/smp.c: cleanups

We sometimes use "struct call_single_data *data" and sometimes "struct
call_single_data *csd".  Use "csd" consistently.

We sometimes use "struct call_function_data *data" and sometimes "struct
call_function_data *cfd".  Use "cfd" consistently.

Also, avoid some 80-col layout tricks.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |   91 ++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 45 deletions(-)

diff -puN kernel/smp.c~kernel-smpc-cleanups kernel/smp.c
--- a/kernel/smp.c~kernel-smpc-cleanups
+++ a/kernel/smp.c
@@ -100,16 +100,16 @@ void __init call_function_init(void)
  * previous function call. For multi-cpu calls its even more interesting
  * as we'll have to ensure no other cpu is observing our csd.
  */
-static void csd_lock_wait(struct call_single_data *data)
+static void csd_lock_wait(struct call_single_data *csd)
 {
-	while (data->flags & CSD_FLAG_LOCK)
+	while (csd->flags & CSD_FLAG_LOCK)
 		cpu_relax();
 }
 
-static void csd_lock(struct call_single_data *data)
+static void csd_lock(struct call_single_data *csd)
 {
-	csd_lock_wait(data);
-	data->flags |= CSD_FLAG_LOCK;
+	csd_lock_wait(csd);
+	csd->flags |= CSD_FLAG_LOCK;
 
 	/*
 	 * prevent CPU from reordering the above assignment
@@ -119,16 +119,16 @@ static void csd_lock(struct call_single_
 	smp_mb();
 }
 
-static void csd_unlock(struct call_single_data *data)
+static void csd_unlock(struct call_single_data *csd)
 {
-	WARN_ON(!(data->flags & CSD_FLAG_LOCK));
+	WARN_ON(!(csd->flags & CSD_FLAG_LOCK));
 
 	/*
 	 * ensure we're all done before releasing data:
 	 */
 	smp_mb();
 
-	data->flags &= ~CSD_FLAG_LOCK;
+	csd->flags &= ~CSD_FLAG_LOCK;
 }
 
 /*
@@ -137,7 +137,7 @@ static void csd_unlock(struct call_singl
  * ->func, ->info, and ->flags set.
  */
 static
-void generic_exec_single(int cpu, struct call_single_data *data, int wait)
+void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 {
 	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
 	unsigned long flags;
@@ -145,7 +145,7 @@ void generic_exec_single(int cpu, struct
 
 	raw_spin_lock_irqsave(&dst->lock, flags);
 	ipi = list_empty(&dst->list);
-	list_add_tail(&data->list, &dst->list);
+	list_add_tail(&csd->list, &dst->list);
 	raw_spin_unlock_irqrestore(&dst->lock, flags);
 
 	/*
@@ -163,7 +163,7 @@ void generic_exec_single(int cpu, struct
 		arch_send_call_function_single_ipi(cpu);
 
 	if (wait)
-		csd_lock_wait(data);
+		csd_lock_wait(csd);
 }
 
 /*
@@ -173,7 +173,6 @@ void generic_exec_single(int cpu, struct
 void generic_smp_call_function_single_interrupt(void)
 {
 	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
-	unsigned int data_flags;
 	LIST_HEAD(list);
 
 	/*
@@ -186,25 +185,26 @@ void generic_smp_call_function_single_in
 	raw_spin_unlock(&q->lock);
 
 	while (!list_empty(&list)) {
-		struct call_single_data *data;
+		struct call_single_data *csd;
+		unsigned int csd_flags;
 
-		data = list_entry(list.next, struct call_single_data, list);
-		list_del(&data->list);
+		csd = list_entry(list.next, struct call_single_data, list);
+		list_del(&csd->list);
 
 		/*
-		 * 'data' can be invalid after this call if flags == 0
+		 * 'csd' can be invalid after this call if flags == 0
 		 * (when called through generic_exec_single()),
 		 * so save them away before making the call:
 		 */
-		data_flags = data->flags;
+		csd_flags = csd->flags;
 
-		data->func(data->info);
+		csd->func(csd->info);
 
 		/*
 		 * Unlocked CSDs are valid through generic_exec_single():
 		 */
-		if (data_flags & CSD_FLAG_LOCK)
-			csd_unlock(data);
+		if (csd_flags & CSD_FLAG_LOCK)
+			csd_unlock(csd);
 	}
 }
 
@@ -249,16 +249,16 @@ int smp_call_function_single(int cpu, sm
 		local_irq_restore(flags);
 	} else {
 		if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
-			struct call_single_data *data = &d;
+			struct call_single_data *csd = &d;
 
 			if (!wait)
-				data = &__get_cpu_var(csd_data);
+				csd = &__get_cpu_var(csd_data);
 
-			csd_lock(data);
+			csd_lock(csd);
 
-			data->func = func;
-			data->info = info;
-			generic_exec_single(cpu, data, wait);
+			csd->func = func;
+			csd->info = info;
+			generic_exec_single(cpu, csd, wait);
 		} else {
 			err = -ENXIO;	/* CPU not online */
 		}
@@ -325,7 +325,7 @@ EXPORT_SYMBOL_GPL(smp_call_function_any)
  * pre-allocated data structure. Useful for embedding @data inside
  * other structures, for instance.
  */
-void __smp_call_function_single(int cpu, struct call_single_data *data,
+void __smp_call_function_single(int cpu, struct call_single_data *csd,
 				int wait)
 {
 	unsigned int this_cpu;
@@ -343,11 +343,11 @@ void __smp_call_function_single(int cpu,
 
 	if (cpu == this_cpu) {
 		local_irq_save(flags);
-		data->func(data->info);
+		csd->func(csd->info);
 		local_irq_restore(flags);
 	} else {
-		csd_lock(data);
-		generic_exec_single(cpu, data, wait);
+		csd_lock(csd);
+		generic_exec_single(cpu, csd, wait);
 	}
 	put_cpu();
 }
@@ -369,7 +369,7 @@ void __smp_call_function_single(int cpu,
 void smp_call_function_many(const struct cpumask *mask,
 			    smp_call_func_t func, void *info, bool wait)
 {
-	struct call_function_data *data;
+	struct call_function_data *cfd;
 	int cpu, next_cpu, this_cpu = smp_processor_id();
 
 	/*
@@ -401,24 +401,24 @@ void smp_call_function_many(const struct
 		return;
 	}
 
-	data = &__get_cpu_var(cfd_data);
+	cfd = &__get_cpu_var(cfd_data);
 
-	cpumask_and(data->cpumask, mask, cpu_online_mask);
-	cpumask_clear_cpu(this_cpu, data->cpumask);
+	cpumask_and(cfd->cpumask, mask, cpu_online_mask);
+	cpumask_clear_cpu(this_cpu, cfd->cpumask);
 
 	/* Some callers race with other cpus changing the passed mask */
-	if (unlikely(!cpumask_weight(data->cpumask)))
+	if (unlikely(!cpumask_weight(cfd->cpumask)))
 		return;
 
 	/*
-	 * After we put an entry into the list, data->cpumask
-	 * may be cleared again when another CPU sends another IPI for
-	 * a SMP function call, so data->cpumask will be zero.
+	 * After we put an entry into the list, cfd->cpumask may be cleared
+	 * again when another CPU sends another IPI for a SMP function call, so
+	 * cfd->cpumask will be zero.
 	 */
-	cpumask_copy(data->cpumask_ipi, data->cpumask);
+	cpumask_copy(cfd->cpumask_ipi, cfd->cpumask);
 
-	for_each_cpu(cpu, data->cpumask) {
-		struct call_single_data *csd = per_cpu_ptr(data->csd, cpu);
+	for_each_cpu(cpu, cfd->cpumask) {
+		struct call_single_data *csd = per_cpu_ptr(cfd->csd, cpu);
 		struct call_single_queue *dst =
 					&per_cpu(call_single_queue, cpu);
 		unsigned long flags;
@@ -433,12 +433,13 @@ void smp_call_function_many(const struct
 	}
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(data->cpumask_ipi);
+	arch_send_call_function_ipi_mask(cfd->cpumask_ipi);
 
 	if (wait) {
-		for_each_cpu(cpu, data->cpumask) {
-			struct call_single_data *csd =
-					per_cpu_ptr(data->csd, cpu);
+		for_each_cpu(cpu, cfd->cpumask) {
+			struct call_single_data *csd;
+
+			csd = per_cpu_ptr(cfd->csd, cpu);
 			csd_lock_wait(csd);
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
clear_refs-sanitize-accepted-commands-declaration.patch
include-linux-mmh-complete-the-mm_walk-definition.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
mm-vmallocc-add-vfree-comment.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
rapidio-make-enumeration-discovery-configurable-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-4.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

