From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Fri, 22 Mar 2013 11:54:58 -0700
Message-ID: <20130322185458.7D7FD5A4FE2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:51404 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3CVSy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Mar 2013 14:54:59 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so61384ghb.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2013 11:54:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/ftrace.c             |    5 --
 kernel/trace/trace.c              |   50 ----------------------------
 kernel/trace/trace.h              |    9 -----
 kernel/trace/trace_irqsoff.c      |   25 --------------
 kernel/trace/trace_sched_wakeup.c |   21 -----------
 5 files changed, 110 deletions(-)

diff -puN kernel/trace/ftrace.c~linux-next-git-rejects kernel/trace/ftrace.c
--- a/kernel/trace/ftrace.c~linux-next-git-rejects
+++ a/kernel/trace/ftrace.c
@@ -3137,10 +3137,6 @@ __unregister_ftrace_function_probe(char
 					continue;
 			}
 
-<<<<<<< HEAD
-			hlist_del_rcu(&entry->node);
-			call_rcu_sched(&entry->rcu, ftrace_free_entry_rcu);
-=======
 			rec_entry = ftrace_lookup_ip(hash, entry->ip);
 			/* It is possible more than one entry had this ip */
 			if (rec_entry)
@@ -3148,7 +3144,6 @@ __unregister_ftrace_function_probe(char
 
 			hlist_del_rcu(&entry->node);
 			list_add(&entry->free_list, &free_list);
->>>>>>> linux-next/akpm-base
 		}
 	}
 	__disable_ftrace_function_probe();
diff -puN kernel/trace/trace.h~linux-next-git-rejects kernel/trace/trace.h
--- a/kernel/trace/trace.h~linux-next-git-rejects
+++ a/kernel/trace/trace.h
@@ -371,12 +371,7 @@ struct tracer {
 	bool			enabled;
 #ifdef CONFIG_TRACER_MAX_TRACE
 	bool			use_max_tr;
-<<<<<<< HEAD
-	bool			allocated_snapshot;
-	bool			enabled;
-=======
 #endif
->>>>>>> linux-next/akpm-base
 };
 
 
@@ -1042,9 +1037,6 @@ extern const char *__stop___trace_bprint
 void trace_printk_init_buffers(void);
 void trace_printk_start_comm(void);
 int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set);
-<<<<<<< HEAD
-int set_tracer_flag(unsigned int mask, int enabled);
-=======
 int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled);
 
 /*
@@ -1057,7 +1049,6 @@ int set_tracer_flag(struct trace_array *
  * a purpose.
  */
 #define internal_trace_puts(str) __trace_puts(_THIS_IP_, str, strlen(str))
->>>>>>> linux-next/akpm-base
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
diff -puN kernel/trace/trace_irqsoff.c~linux-next-git-rejects kernel/trace/trace_irqsoff.c
--- a/kernel/trace/trace_irqsoff.c~linux-next-git-rejects
+++ a/kernel/trace/trace_irqsoff.c
@@ -33,10 +33,7 @@ enum {
 static int trace_type __read_mostly;
 
 static int save_flags;
-<<<<<<< HEAD
-=======
 static bool function_enabled;
->>>>>>> linux-next/akpm-base
 
 static void stop_irqsoff_tracer(struct trace_array *tr, int graph);
 static int start_irqsoff_tracer(struct trace_array *tr, int graph);
@@ -607,13 +604,8 @@ static void __irqsoff_tracer_init(struct
 	save_flags = trace_flags;
 
 	/* non overwrite screws up the latency tracers */
-<<<<<<< HEAD
-	set_tracer_flag(TRACE_ITER_OVERWRITE, 1);
-	set_tracer_flag(TRACE_ITER_LATENCY_FMT, 1);
-=======
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, 1);
->>>>>>> linux-next/akpm-base
 
 	tracing_max_latency = 0;
 	irqsoff_trace = tr;
@@ -632,13 +624,8 @@ static void irqsoff_tracer_reset(struct
 
 	stop_irqsoff_tracer(tr, is_graph());
 
-<<<<<<< HEAD
-	set_tracer_flag(TRACE_ITER_LATENCY_FMT, lat_flag);
-	set_tracer_flag(TRACE_ITER_OVERWRITE, overwrite_flag);
-=======
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, lat_flag);
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, overwrite_flag);
->>>>>>> linux-next/akpm-base
 }
 
 static void irqsoff_tracer_start(struct trace_array *tr)
@@ -671,11 +658,7 @@ static struct tracer irqsoff_tracer __re
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= irqsoff_set_flag,
-<<<<<<< HEAD
-	.flag_changed	= trace_keep_overwrite,
-=======
 	.flag_changed	= irqsoff_flag_changed,
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_irqsoff,
 #endif
@@ -709,11 +692,7 @@ static struct tracer preemptoff_tracer _
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= irqsoff_set_flag,
-<<<<<<< HEAD
-	.flag_changed	= trace_keep_overwrite,
-=======
 	.flag_changed	= irqsoff_flag_changed,
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptoff,
 #endif
@@ -749,11 +728,7 @@ static struct tracer preemptirqsoff_trac
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= irqsoff_set_flag,
-<<<<<<< HEAD
-	.flag_changed	= trace_keep_overwrite,
-=======
 	.flag_changed	= irqsoff_flag_changed,
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptirqsoff,
 #endif
diff -puN kernel/trace/trace_sched_wakeup.c~linux-next-git-rejects kernel/trace/trace_sched_wakeup.c
--- a/kernel/trace/trace_sched_wakeup.c~linux-next-git-rejects
+++ a/kernel/trace/trace_sched_wakeup.c
@@ -37,10 +37,7 @@ static int wakeup_graph_entry(struct ftr
 static void wakeup_graph_return(struct ftrace_graph_ret *trace);
 
 static int save_flags;
-<<<<<<< HEAD
-=======
 static bool function_enabled;
->>>>>>> linux-next/akpm-base
 
 #define TRACE_DISPLAY_GRAPH     1
 
@@ -589,13 +586,8 @@ static int __wakeup_tracer_init(struct t
 	save_flags = trace_flags;
 
 	/* non overwrite screws up the latency tracers */
-<<<<<<< HEAD
-	set_tracer_flag(TRACE_ITER_OVERWRITE, 1);
-	set_tracer_flag(TRACE_ITER_LATENCY_FMT, 1);
-=======
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, 1);
->>>>>>> linux-next/akpm-base
 
 	tracing_max_latency = 0;
 	wakeup_trace = tr;
@@ -624,13 +616,8 @@ static void wakeup_tracer_reset(struct t
 	/* make sure we put back any tasks we are tracing */
 	wakeup_reset(tr);
 
-<<<<<<< HEAD
-	set_tracer_flag(TRACE_ITER_LATENCY_FMT, lat_flag);
-	set_tracer_flag(TRACE_ITER_OVERWRITE, overwrite_flag);
-=======
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, lat_flag);
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, overwrite_flag);
->>>>>>> linux-next/akpm-base
 }
 
 static void wakeup_tracer_start(struct trace_array *tr)
@@ -656,11 +643,7 @@ static struct tracer wakeup_tracer __rea
 	.print_line	= wakeup_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= wakeup_set_flag,
-<<<<<<< HEAD
-	.flag_changed	= trace_keep_overwrite,
-=======
 	.flag_changed	= wakeup_flag_changed,
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
@@ -682,11 +665,7 @@ static struct tracer wakeup_rt_tracer __
 	.print_line	= wakeup_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= wakeup_set_flag,
-<<<<<<< HEAD
-	.flag_changed	= trace_keep_overwrite,
-=======
 	.flag_changed	= wakeup_flag_changed,
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
diff -puN kernel/trace/trace.c~linux-next-git-rejects kernel/trace/trace.c
--- a/kernel/trace/trace.c~linux-next-git-rejects
+++ a/kernel/trace/trace.c
@@ -879,15 +879,9 @@ update_max_tr(struct trace_array *tr, st
 
 	arch_spin_lock(&ftrace_max_lock);
 
-<<<<<<< HEAD
-	buf = tr->buffer;
-	tr->buffer = max_tr.buffer;
-	max_tr.buffer = buf;
-=======
 	buf = tr->trace_buffer.buffer;
 	tr->trace_buffer.buffer = tr->max_buffer.buffer;
 	tr->max_buffer.buffer = buf;
->>>>>>> linux-next/akpm-base
 
 	__update_max_tr(tr, tsk, cpu);
 	arch_spin_unlock(&ftrace_max_lock);
@@ -3198,24 +3192,15 @@ int trace_keep_overwrite(struct tracer *
 	return 0;
 }
 
-<<<<<<< HEAD
-int set_tracer_flag(unsigned int mask, int enabled)
-=======
 int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
->>>>>>> linux-next/akpm-base
 {
 	/* do nothing if flag is already set */
 	if (!!(trace_flags & mask) == !!enabled)
 		return 0;
 
 	/* Give the tracer a chance to approve the change */
-<<<<<<< HEAD
-	if (current_trace->flag_changed)
-		if (current_trace->flag_changed(current_trace, mask, !!enabled))
-=======
 	if (tr->current_trace->flag_changed)
 		if (tr->current_trace->flag_changed(tr->current_trace, mask, !!enabled))
->>>>>>> linux-next/akpm-base
 			return -EINVAL;
 
 	if (enabled)
@@ -3227,15 +3212,9 @@ int set_tracer_flag(struct trace_array *
 		trace_event_enable_cmd_record(enabled);
 
 	if (mask == TRACE_ITER_OVERWRITE) {
-<<<<<<< HEAD
-		ring_buffer_change_overwrite(global_trace.buffer, enabled);
-#ifdef CONFIG_TRACER_MAX_TRACE
-		ring_buffer_change_overwrite(max_tr.buffer, enabled);
-=======
 		ring_buffer_change_overwrite(tr->trace_buffer.buffer, enabled);
 #ifdef CONFIG_TRACER_MAX_TRACE
 		ring_buffer_change_overwrite(tr->max_buffer.buffer, enabled);
->>>>>>> linux-next/akpm-base
 #endif
 	}
 
@@ -3263,22 +3242,14 @@ static int trace_set_options(struct trac
 
 	for (i = 0; trace_options[i]; i++) {
 		if (strcmp(cmp, trace_options[i]) == 0) {
-<<<<<<< HEAD
-			ret = set_tracer_flag(1 << i, !neg);
-=======
 			ret = set_tracer_flag(tr, 1 << i, !neg);
->>>>>>> linux-next/akpm-base
 			break;
 		}
 	}
 
 	/* If no option could be set, test the specific tracer options */
 	if (!trace_options[i])
-<<<<<<< HEAD
-		ret = set_tracer_option(current_trace, cmp, neg);
-=======
 		ret = set_tracer_option(tr->current_trace, cmp, neg);
->>>>>>> linux-next/akpm-base
 
 	mutex_unlock(&trace_types_lock);
 
@@ -3302,11 +3273,7 @@ tracing_trace_options_write(struct file
 
 	buf[cnt] = 0;
 
-<<<<<<< HEAD
-	ret = trace_set_options(buf);
-=======
 	ret = trace_set_options(tr, buf);
->>>>>>> linux-next/akpm-base
 	if (ret < 0)
 		return ret;
 
@@ -3687,14 +3654,6 @@ static int tracing_set_tracer(const char
 		goto out;
 
 	trace_branch_disable();
-<<<<<<< HEAD
-
-	current_trace->enabled = false;
-
-	if (current_trace->reset)
-		current_trace->reset(tr);
-=======
->>>>>>> linux-next/akpm-base
 
 	tr->current_trace->enabled = false;
 
@@ -3737,13 +3696,8 @@ static int tracing_set_tracer(const char
 			goto out;
 	}
 
-<<<<<<< HEAD
-	current_trace = t;
-	current_trace->enabled = true;
-=======
 	tr->current_trace = t;
 	tr->current_trace->enabled = true;
->>>>>>> linux-next/akpm-base
 	trace_branch_enable(tr);
  out:
 	mutex_unlock(&trace_types_lock);
@@ -5491,11 +5445,7 @@ trace_options_core_write(struct file *fi
 		return -EINVAL;
 
 	mutex_lock(&trace_types_lock);
-<<<<<<< HEAD
-	ret = set_tracer_flag(1 << index, val);
-=======
 	ret = set_tracer_flag(tr, 1 << index, val);
->>>>>>> linux-next/akpm-base
 	mutex_unlock(&trace_types_lock);
 
 	if (ret < 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
printk-provide-a-wake_up_klogd-off-case-fix.patch
mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting-fix.patch
dma-debug-fix-locking-bug-in-check_unmap-fix.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
kernel-sched-schedh-fix-warning.patch
loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch
loop-cleanup-partitions-when-detaching-loop-device-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-fix-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
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
aio-kill-ki_retry.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

