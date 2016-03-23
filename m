From: akpm@linux-foundation.org
Subject: [merged] kernel-convert-pr_warning-to-pr_warn.patch removed from
 -mm tree
Date: Wed, 23 Mar 2016 10:42:59 -0700
Message-ID: <56f2d5a3.A/FL3AhTQNLGGZqH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325AbcCWRnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:43:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, rafael.j.wysocki@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/...: convert pr_warning to pr_warn
has been removed from the -mm tree.  Its filename was
     kernel-convert-pr_warning-to-pr_warn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: kernel/...: convert pr_warning to pr_warn

Use the more common logging method with the eventual goal
of removing pr_warning altogether.

Miscellanea:

o Realign arguments
o Coalesce formats
o Add missing space between a few coalesced formats

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>	[kernel/power/suspend.c]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c                  |    4 +-
 kernel/power/suspend.c               |    3 -
 kernel/time/tick-sched.c             |    8 ++---
 kernel/trace/blktrace.c              |    4 +-
 kernel/trace/ftrace.c                |    7 +---
 kernel/trace/trace.c                 |   40 ++++++++++++-------------
 kernel/trace/trace_functions_graph.c |    6 +--
 kernel/trace/trace_kprobe.c          |   27 ++++++----------
 kernel/trace/trace_mmiotrace.c       |    2 -
 kernel/trace/trace_probe.c           |    4 +-
 kernel/trace/trace_stat.c            |    3 -
 kernel/trace/trace_uprobe.c          |    2 -
 kernel/tracepoint.c                  |    2 -
 13 files changed, 52 insertions(+), 60 deletions(-)

diff -puN kernel/irq/manage.c~kernel-convert-pr_warning-to-pr_warn kernel/irq/manage.c
--- a/kernel/irq/manage.c~kernel-convert-pr_warning-to-pr_warn
+++ a/kernel/irq/manage.c
@@ -1322,8 +1322,8 @@ __setup_irq(unsigned int irq, struct irq
 
 		if (nmsk != omsk)
 			/* hope the handler works with current  trigger mode */
-			pr_warning("irq %d uses trigger mode %u; requested %u\n",
-				   irq, nmsk, omsk);
+			pr_warn("irq %d uses trigger mode %u; requested %u\n",
+				irq, nmsk, omsk);
 	}
 
 	*old_ptr = new;
diff -puN kernel/power/suspend.c~kernel-convert-pr_warning-to-pr_warn kernel/power/suspend.c
--- a/kernel/power/suspend.c~kernel-convert-pr_warning-to-pr_warn
+++ a/kernel/power/suspend.c
@@ -473,8 +473,7 @@ static int enter_state(suspend_state_t s
 	if (state == PM_SUSPEND_FREEZE) {
 #ifdef CONFIG_PM_DEBUG
 		if (pm_test_level != TEST_NONE && pm_test_level <= TEST_CPUS) {
-			pr_warning("PM: Unsupported test mode for suspend to idle,"
-				   "please choose none/freezer/devices/platform.\n");
+			pr_warn("PM: Unsupported test mode for suspend to idle, please choose none/freezer/devices/platform.\n");
 			return -EAGAIN;
 		}
 #endif
diff -puN kernel/time/tick-sched.c~kernel-convert-pr_warning-to-pr_warn kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~kernel-convert-pr_warning-to-pr_warn
+++ a/kernel/time/tick-sched.c
@@ -378,7 +378,7 @@ static int __init tick_nohz_full_setup(c
 {
 	alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
 	if (cpulist_parse(str, tick_nohz_full_mask) < 0) {
-		pr_warning("NOHZ: Incorrect nohz_full cpumask\n");
+		pr_warn("NO_HZ: Incorrect nohz_full cpumask\n");
 		free_bootmem_cpumask_var(tick_nohz_full_mask);
 		return 1;
 	}
@@ -446,8 +446,7 @@ void __init tick_nohz_init(void)
 	 * interrupts to avoid circular dependency on the tick
 	 */
 	if (!arch_irq_work_has_interrupt()) {
-		pr_warning("NO_HZ: Can't run full dynticks because arch doesn't "
-			   "support irq work self-IPIs\n");
+		pr_warn("NO_HZ: Can't run full dynticks because arch doesn't support irq work self-IPIs\n");
 		cpumask_clear(tick_nohz_full_mask);
 		cpumask_copy(housekeeping_mask, cpu_possible_mask);
 		tick_nohz_full_running = false;
@@ -457,7 +456,8 @@ void __init tick_nohz_init(void)
 	cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
-		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n", cpu);
+		pr_warn("NO_HZ: Clearing %d from nohz_full range for timekeeping\n",
+			cpu);
 		cpumask_clear_cpu(cpu, tick_nohz_full_mask);
 	}
 
diff -puN kernel/trace/blktrace.c~kernel-convert-pr_warning-to-pr_warn kernel/trace/blktrace.c
--- a/kernel/trace/blktrace.c~kernel-convert-pr_warning-to-pr_warn
+++ a/kernel/trace/blktrace.c
@@ -1437,12 +1437,12 @@ static struct trace_event trace_blk_even
 static int __init init_blk_tracer(void)
 {
 	if (!register_trace_event(&trace_blk_event)) {
-		pr_warning("Warning: could not register block events\n");
+		pr_warn("Warning: could not register block events\n");
 		return 1;
 	}
 
 	if (register_tracer(&blk_tracer) != 0) {
-		pr_warning("Warning: could not register the block tracer\n");
+		pr_warn("Warning: could not register the block tracer\n");
 		unregister_trace_event(&trace_blk_event);
 		return 1;
 	}
diff -puN kernel/trace/ftrace.c~kernel-convert-pr_warning-to-pr_warn kernel/trace/ftrace.c
--- a/kernel/trace/ftrace.c~kernel-convert-pr_warning-to-pr_warn
+++ a/kernel/trace/ftrace.c
@@ -1058,8 +1058,7 @@ static __init void ftrace_profile_tracef
 	entry = tracefs_create_file("function_profile_enabled", 0644,
 				    d_tracer, NULL, &ftrace_profile_fops);
 	if (!entry)
-		pr_warning("Could not create tracefs "
-			   "'function_profile_enabled' entry\n");
+		pr_warn("Could not create tracefs 'function_profile_enabled' entry\n");
 }
 
 #else /* CONFIG_FUNCTION_PROFILER */
@@ -2314,8 +2313,8 @@ unsigned long ftrace_get_addr_curr(struc
 	if (rec->flags & FTRACE_FL_TRAMP_EN) {
 		ops = ftrace_find_tramp_ops_curr(rec);
 		if (FTRACE_WARN_ON(!ops)) {
-			pr_warning("Bad trampoline accounting at: %p (%pS)\n",
-				    (void *)rec->ip, (void *)rec->ip);
+			pr_warn("Bad trampoline accounting at: %p (%pS)\n",
+				(void *)rec->ip, (void *)rec->ip);
 			/* Ftrace is shutting down, return anything */
 			return (unsigned long)FTRACE_ADDR;
 		}
diff -puN kernel/trace/trace.c~kernel-convert-pr_warning-to-pr_warn kernel/trace/trace.c
--- a/kernel/trace/trace.c~kernel-convert-pr_warning-to-pr_warn
+++ a/kernel/trace/trace.c
@@ -2071,20 +2071,20 @@ void trace_printk_init_buffers(void)
 
 	/* trace_printk() is for debug use only. Don't use it in production. */
 
-	pr_warning("\n");
-	pr_warning("**********************************************************\n");
-	pr_warning("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
-	pr_warning("**                                                      **\n");
-	pr_warning("** trace_printk() being used. Allocating extra memory.  **\n");
-	pr_warning("**                                                      **\n");
-	pr_warning("** This means that this is a DEBUG kernel and it is     **\n");
-	pr_warning("** unsafe for production use.                           **\n");
-	pr_warning("**                                                      **\n");
-	pr_warning("** If you see this message and you are not debugging    **\n");
-	pr_warning("** the kernel, report this immediately to your vendor!  **\n");
-	pr_warning("**                                                      **\n");
-	pr_warning("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
-	pr_warning("**********************************************************\n");
+	pr_warn("\n");
+	pr_warn("**********************************************************\n");
+	pr_warn("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
+	pr_warn("**                                                      **\n");
+	pr_warn("** trace_printk() being used. Allocating extra memory.  **\n");
+	pr_warn("**                                                      **\n");
+	pr_warn("** This means that this is a DEBUG kernel and it is     **\n");
+	pr_warn("** unsafe for production use.                           **\n");
+	pr_warn("**                                                      **\n");
+	pr_warn("** If you see this message and you are not debugging    **\n");
+	pr_warn("** the kernel, report this immediately to your vendor!  **\n");
+	pr_warn("**                                                      **\n");
+	pr_warn("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
+	pr_warn("**********************************************************\n");
 
 	/* Expand the buffers to set size */
 	tracing_update_buffers();
@@ -4101,7 +4101,7 @@ trace_insert_enum_map_file(struct module
 	 */
 	map_array = kmalloc(sizeof(*map_array) * (len + 2), GFP_KERNEL);
 	if (!map_array) {
-		pr_warning("Unable to allocate trace enum mapping\n");
+		pr_warn("Unable to allocate trace enum mapping\n");
 		return;
 	}
 
@@ -6131,7 +6131,7 @@ tracing_init_tracefs_percpu(struct trace
 	snprintf(cpu_dir, 30, "cpu%ld", cpu);
 	d_cpu = tracefs_create_dir(cpu_dir, d_percpu);
 	if (!d_cpu) {
-		pr_warning("Could not create tracefs '%s' entry\n", cpu_dir);
+		pr_warn("Could not create tracefs '%s' entry\n", cpu_dir);
 		return;
 	}
 
@@ -6318,7 +6318,7 @@ struct dentry *trace_create_file(const c
 
 	ret = tracefs_create_file(name, mode, parent, data, fops);
 	if (!ret)
-		pr_warning("Could not create tracefs '%s' entry\n", name);
+		pr_warn("Could not create tracefs '%s' entry\n", name);
 
 	return ret;
 }
@@ -6337,7 +6337,7 @@ static struct dentry *trace_options_init
 
 	tr->options = tracefs_create_dir("options", d_tracer);
 	if (!tr->options) {
-		pr_warning("Could not create tracefs directory 'options'\n");
+		pr_warn("Could not create tracefs directory 'options'\n");
 		return NULL;
 	}
 
@@ -7248,8 +7248,8 @@ __init static int tracer_alloc_buffers(v
 	if (trace_boot_clock) {
 		ret = tracing_set_clock(&global_trace, trace_boot_clock);
 		if (ret < 0)
-			pr_warning("Trace clock %s not defined, going back to default\n",
-				   trace_boot_clock);
+			pr_warn("Trace clock %s not defined, going back to default\n",
+				trace_boot_clock);
 	}
 
 	/*
diff -puN kernel/trace/trace_functions_graph.c~kernel-convert-pr_warning-to-pr_warn kernel/trace/trace_functions_graph.c
--- a/kernel/trace/trace_functions_graph.c~kernel-convert-pr_warning-to-pr_warn
+++ a/kernel/trace/trace_functions_graph.c
@@ -1350,7 +1350,7 @@ void graph_trace_open(struct trace_itera
  out_err_free:
 	kfree(data);
  out_err:
-	pr_warning("function graph tracer: not enough memory\n");
+	pr_warn("function graph tracer: not enough memory\n");
 }
 
 void graph_trace_close(struct trace_iterator *iter)
@@ -1468,12 +1468,12 @@ static __init int init_graph_trace(void)
 	max_bytes_for_cpu = snprintf(NULL, 0, "%d", nr_cpu_ids - 1);
 
 	if (!register_trace_event(&graph_trace_entry_event)) {
-		pr_warning("Warning: could not register graph trace events\n");
+		pr_warn("Warning: could not register graph trace events\n");
 		return 1;
 	}
 
 	if (!register_trace_event(&graph_trace_ret_event)) {
-		pr_warning("Warning: could not register graph trace events\n");
+		pr_warn("Warning: could not register graph trace events\n");
 		return 1;
 	}
 
diff -puN kernel/trace/trace_kprobe.c~kernel-convert-pr_warning-to-pr_warn kernel/trace/trace_kprobe.c
--- a/kernel/trace/trace_kprobe.c~kernel-convert-pr_warning-to-pr_warn
+++ a/kernel/trace/trace_kprobe.c
@@ -459,16 +459,14 @@ static int __register_trace_kprobe(struc
 	if (ret == 0)
 		tk->tp.flags |= TP_FLAG_REGISTERED;
 	else {
-		pr_warning("Could not insert probe at %s+%lu: %d\n",
-			   trace_kprobe_symbol(tk), trace_kprobe_offset(tk), ret);
+		pr_warn("Could not insert probe at %s+%lu: %d\n",
+			trace_kprobe_symbol(tk), trace_kprobe_offset(tk), ret);
 		if (ret == -ENOENT && trace_kprobe_is_on_module(tk)) {
-			pr_warning("This probe might be able to register after"
-				   "target module is loaded. Continue.\n");
+			pr_warn("This probe might be able to register after target module is loaded. Continue.\n");
 			ret = 0;
 		} else if (ret == -EILSEQ) {
-			pr_warning("Probing address(0x%p) is not an "
-				   "instruction boundary.\n",
-				   tk->rp.kp.addr);
+			pr_warn("Probing address(0x%p) is not an instruction boundary.\n",
+				tk->rp.kp.addr);
 			ret = -EINVAL;
 		}
 	}
@@ -529,7 +527,7 @@ static int register_trace_kprobe(struct
 	/* Register new event */
 	ret = register_kprobe_event(tk);
 	if (ret) {
-		pr_warning("Failed to register probe event(%d)\n", ret);
+		pr_warn("Failed to register probe event(%d)\n", ret);
 		goto end;
 	}
 
@@ -564,10 +562,9 @@ static int trace_kprobe_module_callback(
 			__unregister_trace_kprobe(tk);
 			ret = __register_trace_kprobe(tk);
 			if (ret)
-				pr_warning("Failed to re-register probe %s on"
-					   "%s: %d\n",
-					   trace_event_name(&tk->tp.call),
-					   mod->name, ret);
+				pr_warn("Failed to re-register probe %s on %s: %d\n",
+					trace_event_name(&tk->tp.call),
+					mod->name, ret);
 		}
 	}
 	mutex_unlock(&probe_lock);
@@ -1336,16 +1333,14 @@ static __init int init_kprobe_trace(void
 
 	/* Event list interface */
 	if (!entry)
-		pr_warning("Could not create tracefs "
-			   "'kprobe_events' entry\n");
+		pr_warn("Could not create tracefs 'kprobe_events' entry\n");
 
 	/* Profile interface */
 	entry = tracefs_create_file("kprobe_profile", 0444, d_tracer,
 				    NULL, &kprobe_profile_ops);
 
 	if (!entry)
-		pr_warning("Could not create tracefs "
-			   "'kprobe_profile' entry\n");
+		pr_warn("Could not create tracefs 'kprobe_profile' entry\n");
 	return 0;
 }
 fs_initcall(init_kprobe_trace);
diff -puN kernel/trace/trace_mmiotrace.c~kernel-convert-pr_warning-to-pr_warn kernel/trace/trace_mmiotrace.c
--- a/kernel/trace/trace_mmiotrace.c~kernel-convert-pr_warning-to-pr_warn
+++ a/kernel/trace/trace_mmiotrace.c
@@ -146,7 +146,7 @@ static ssize_t mmio_read(struct trace_it
 		/* XXX: This is later than where events were lost. */
 		trace_seq_printf(s, "MARK 0.000000 Lost %lu events.\n", n);
 		if (!overrun_detected)
-			pr_warning("mmiotrace has lost events.\n");
+			pr_warn("mmiotrace has lost events\n");
 		overrun_detected = true;
 		goto print_out;
 	}
diff -puN kernel/trace/trace_probe.c~kernel-convert-pr_warning-to-pr_warn kernel/trace/trace_probe.c
--- a/kernel/trace/trace_probe.c~kernel-convert-pr_warning-to-pr_warn
+++ a/kernel/trace/trace_probe.c
@@ -636,8 +636,8 @@ ssize_t traceprobe_probes_write(struct f
 			*tmp = '\0';
 			size = tmp - kbuf + 1;
 		} else if (done + size < count) {
-			pr_warning("Line length is too long: "
-				   "Should be less than %d.", WRITE_BUFSIZE);
+			pr_warn("Line length is too long: Should be less than %d\n",
+				WRITE_BUFSIZE);
 			ret = -EINVAL;
 			goto out;
 		}
diff -puN kernel/trace/trace_stat.c~kernel-convert-pr_warning-to-pr_warn kernel/trace/trace_stat.c
--- a/kernel/trace/trace_stat.c~kernel-convert-pr_warning-to-pr_warn
+++ a/kernel/trace/trace_stat.c
@@ -281,8 +281,7 @@ static int tracing_stat_init(void)
 
 	stat_dir = tracefs_create_dir("trace_stat", d_tracing);
 	if (!stat_dir)
-		pr_warning("Could not create tracefs "
-			   "'trace_stat' entry\n");
+		pr_warn("Could not create tracefs 'trace_stat' entry\n");
 	return 0;
 }
 
diff -puN kernel/trace/trace_uprobe.c~kernel-convert-pr_warning-to-pr_warn kernel/trace/trace_uprobe.c
--- a/kernel/trace/trace_uprobe.c~kernel-convert-pr_warning-to-pr_warn
+++ a/kernel/trace/trace_uprobe.c
@@ -334,7 +334,7 @@ static int register_trace_uprobe(struct
 
 	ret = register_uprobe_event(tu);
 	if (ret) {
-		pr_warning("Failed to register probe event(%d)\n", ret);
+		pr_warn("Failed to register probe event(%d)\n", ret);
 		goto end;
 	}
 
diff -puN kernel/tracepoint.c~kernel-convert-pr_warning-to-pr_warn kernel/tracepoint.c
--- a/kernel/tracepoint.c~kernel-convert-pr_warning-to-pr_warn
+++ a/kernel/tracepoint.c
@@ -491,7 +491,7 @@ static __init int init_tracepoints(void)
 
 	ret = register_module_notifier(&tracepoint_module_nb);
 	if (ret)
-		pr_warning("Failed to register tracepoint module enter notifier\n");
+		pr_warn("Failed to register tracepoint module enter notifier\n");
 
 	return ret;
 }
_

Patches currently in -mm which might be from joe@perches.com are


