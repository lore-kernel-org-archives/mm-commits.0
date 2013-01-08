From: akpm@linux-foundation.org
Subject: + kernel-smpc-cleanups.patch added to -mm tree
Date: Tue, 08 Jan 2013 14:39:41 -0800
Message-ID: <20130108223941.9614B820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60714 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3AHWjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 17:39:42 -0500
Received: by mail-yh0-f74.google.com with SMTP id w68so144370yhw.1
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 14:39:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, axboe@kernel.dk, mingo@elte.hu, rostedt@goodmis.org, shli@fusionio.com, shli@kernel.org


The patch titled
     Subject: kernel/smp.c: cleanups
has been added to the -mm tree.  Its filename is
     kernel-smpc-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 kernel/smp.c |   87 ++++++++++++++++++++++++-------------------------
 1 file changed, 44 insertions(+), 43 deletions(-)

diff -puN kernel/smp.c~kernel-smpc-cleanups kernel/smp.c
--- a/kernel/smp.c~kernel-smpc-cleanups
+++ a/kernel/smp.c
@@ -95,16 +95,16 @@ void __init call_function_init(void)
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
-	data->flags = CSD_FLAG_LOCK;
+	csd_lock_wait(csd);
+	csd->flags = CSD_FLAG_LOCK;
 
 	/*
 	 * prevent CPU from reordering the above assignment
@@ -114,16 +114,16 @@ static void csd_lock(struct call_single_
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
@@ -132,7 +132,7 @@ static void csd_unlock(struct call_singl
  * ->func, ->info, and ->flags set.
  */
 static
-void generic_exec_single(int cpu, struct call_single_data *data, int wait)
+void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 {
 	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
 	unsigned long flags;
@@ -140,7 +140,7 @@ void generic_exec_single(int cpu, struct
 
 	raw_spin_lock_irqsave(&dst->lock, flags);
 	ipi = list_empty(&dst->list);
-	list_add_tail(&data->list, &dst->list);
+	list_add_tail(&csd->list, &dst->list);
 	raw_spin_unlock_irqrestore(&dst->lock, flags);
 
 	/*
@@ -158,7 +158,7 @@ void generic_exec_single(int cpu, struct
 		arch_send_call_function_single_ipi(cpu);
 
 	if (wait)
-		csd_lock_wait(data);
+		csd_lock_wait(csd);
 }
 
 /*
@@ -168,7 +168,6 @@ void generic_exec_single(int cpu, struct
 void generic_smp_call_function_single_interrupt(void)
 {
 	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
-	unsigned int data_flags;
 	LIST_HEAD(list);
 
 	/*
@@ -181,25 +180,26 @@ void generic_smp_call_function_single_in
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
 
@@ -244,16 +244,16 @@ int smp_call_function_single(int cpu, sm
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
@@ -320,7 +320,7 @@ EXPORT_SYMBOL_GPL(smp_call_function_any)
  * pre-allocated data structure. Useful for embedding @data inside
  * other structures, for instance.
  */
-void __smp_call_function_single(int cpu, struct call_single_data *data,
+void __smp_call_function_single(int cpu, struct call_single_data *csd,
 				int wait)
 {
 	unsigned int this_cpu;
@@ -338,11 +338,11 @@ void __smp_call_function_single(int cpu,
 
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
@@ -364,7 +364,7 @@ void __smp_call_function_single(int cpu,
 void smp_call_function_many(const struct cpumask *mask,
 			    smp_call_func_t func, void *info, bool wait)
 {
-	struct call_function_data *data;
+	struct call_function_data *cfd;
 	int cpu, next_cpu, this_cpu = smp_processor_id();
 
 	/*
@@ -396,21 +396,21 @@ void smp_call_function_many(const struct
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
 
-	for_each_cpu(cpu, data->cpumask) {
-		struct call_single_data *csd = per_cpu_ptr(data->csd, cpu);
-		struct call_single_queue *dst =
-					&per_cpu(call_single_queue, cpu);
+	for_each_cpu(cpu, cfd->cpumask) {
+		struct call_single_data *csd = per_cpu_ptr(cfd->csd, cpu);
+		struct call_single_queue *dst;
 		unsigned long flags;
 
+		dst = &per_cpu(call_single_queue, cpu);
 		csd_lock(csd);
 		csd->func = func;
 		csd->info = info;
@@ -421,12 +421,13 @@ void smp_call_function_many(const struct
 	}
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(data->cpumask);
+	arch_send_call_function_ipi_mask(cfd->cpumask);
 
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
linux-next-git-rejects.patch
make-my-i386-build-work.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch
drivers-rtc-rtc-da9055c-fix-cross-section-reference.patch
arch-mn10300-kconfig-select-config_generic_atomic64.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
kernel-auditc-avoid-negative-sleep-durations.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-fix-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
aio-smoosh-struct-kiocb-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

