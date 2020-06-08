From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 14/54] panic: add sysctl to dump all CPUs
 backtraces on oops event
Date: Sun, 07 Jun 2020 21:40:48 -0700
Message-ID: <20200608044048.aELgRjIO6%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEkt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:40:49 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gpiccoli@canonical.com, keescook@chromium.org, linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, rdunlap@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org, yzaikin@google.com

From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: panic: add sysctl to dump all CPUs backtraces on oops event

Usually when the kernel reaches an oops condition, it's a point of no
return; in case not enough debug information is available in the kernel
splat, one of the last resorts would be to collect a kernel crash dump and
analyze it.  The problem with this approach is that in order to collect
the dump, a panic is required (to kexec-load the crash kernel).  When in
an environment of multiple virtual machines, users may prefer to try
living with the oops, at least until being able to properly shutdown their
VMs / finish their important tasks.

This patch implements a way to collect a bit more debug details when an
oops event is reached, by printing all the CPUs backtraces through the
usage of NMIs (on architectures that support that).  The sysctl added (and
documented) here was called "oops_all_cpu_backtrace", and when set will
(as the name suggests) dump all CPUs backtraces.

Far from ideal, this may be the last option though for users that for some
reason cannot panic on oops.  Most of times oopses are clear enough to
indicate the kernel portion that must be investigated, but in virtual
environments it's possible to observe hypervisor/KVM issues that could
lead to oopses shown in other guests CPUs (like virtual APIC crashes). 
This patch hence aims to help debug such complex issues without resorting
to kdump.

Link: http://lkml.kernel.org/r/20200327224116.21030-1-gpiccoli@canonical.com
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |   16 ++++++++++++++++
 include/linux/kernel.h                      |    6 ++++++
 kernel/panic.c                              |   11 +++++++++++
 kernel/sysctl.c                             |   11 +++++++++++
 4 files changed, 44 insertions(+)

--- a/Documentation/admin-guide/sysctl/kernel.rst~panic-add-sysctl-to-dump-all-cpus-backtraces-on-oops-event
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -646,6 +646,22 @@ rate for each task.
 scanned for a given scan.
 
 
+oops_all_cpu_backtrace:
+================
+
+If this option is set, the kernel will send an NMI to all CPUs to dump
+their backtraces when an oops event occurs. It should be used as a last
+resort in case a panic cannot be triggered (to protect VMs running, for
+example) or kdump can't be collected. This file shows up if CONFIG_SMP
+is enabled.
+
+0: Won't show all CPUs backtraces when an oops is detected.
+This is the default behavior.
+
+1: Will non-maskably interrupt all CPUs and dump their backtraces when
+an oops event is detected.
+
+
 osrelease, ostype & version
 ===========================
 
--- a/include/linux/kernel.h~panic-add-sysctl-to-dump-all-cpus-backtraces-on-oops-event
+++ a/include/linux/kernel.h
@@ -520,6 +520,12 @@ static inline u32 int_sqrt64(u64 x)
 }
 #endif
 
+#ifdef CONFIG_SMP
+extern unsigned int sysctl_oops_all_cpu_backtrace;
+#else
+#define sysctl_oops_all_cpu_backtrace 0
+#endif /* CONFIG_SMP */
+
 extern void bust_spinlocks(int yes);
 extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
 extern int panic_timeout;
--- a/kernel/panic.c~panic-add-sysctl-to-dump-all-cpus-backtraces-on-oops-event
+++ a/kernel/panic.c
@@ -36,6 +36,14 @@
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
 
+#ifdef CONFIG_SMP
+/*
+ * Should we dump all CPUs backtraces in an oops event?
+ * Defaults to 0, can be changed via sysctl.
+ */
+unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
+#endif /* CONFIG_SMP */
+
 int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
 static unsigned long tainted_mask =
 	IS_ENABLED(CONFIG_GCC_PLUGIN_RANDSTRUCT) ? (1 << TAINT_RANDSTRUCT) : 0;
@@ -522,6 +530,9 @@ void oops_enter(void)
 	/* can't trust the integrity of the kernel anymore: */
 	debug_locks_off();
 	do_oops_enter_exit();
+
+	if (sysctl_oops_all_cpu_backtrace)
+		trigger_all_cpu_backtrace();
 }
 
 /*
--- a/kernel/sysctl.c~panic-add-sysctl-to-dump-all-cpus-backtraces-on-oops-event
+++ a/kernel/sysctl.c
@@ -2150,6 +2150,17 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_SMP
+	{
+		.procname	= "oops_all_cpu_backtrace",
+		.data		= &sysctl_oops_all_cpu_backtrace,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif /* CONFIG_SMP */
 	{
 		.procname	= "pid_max",
 		.data		= &pid_max,
_
