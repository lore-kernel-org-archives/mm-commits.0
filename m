From: akpm@linux-foundation.org
Subject: [merged]
 kernel-used-macros-from-compilerh-instead-of-__attribute__.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:39:45 -0700
Message-ID: <53446ca1.JjhcDVu1r8PoYkoX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898AbaDHVjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:39:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rjw@sisk.pl, mingo@elte.hu, gidisrael@gmail.com

Subject: [merged] kernel-used-macros-from-compilerh-instead-of-__attribute__.patch removed from -mm tree
To: gidisrael@gmail.com,mingo@elte.hu,rjw@sisk.pl,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:39:45 -0700


The patch titled
     Subject: kernel: use macros from compiler.h instead of __attribute__((...))
has been removed from the -mm tree.  Its filename was
     kernel-used-macros-from-compilerh-instead-of-__attribute__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gideon Israel Dsouza <gidisrael@gmail.com>
Subject: kernel: use macros from compiler.h instead of __attribute__((...))

To increase compiler portability there is <linux/compiler.h> which
provides convenience macros for various gcc constructs.  Eg: __weak for
__attribute__((weak)).  I've replaced all instances of gcc attributes with
the right macro in the kernel subsystem.

Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c             |    3 ++-
 kernel/kallsyms.c         |   11 ++++++-----
 kernel/kexec.c            |    5 +++--
 kernel/ksysfs.c           |    5 +++--
 kernel/power/power.h      |    3 ++-
 kernel/power/snapshot.c   |    3 ++-
 kernel/power/suspend.c    |    5 +++--
 kernel/power/swap.c       |    2 +-
 kernel/sched/clock.c      |    3 ++-
 kernel/sched/core.c       |    3 ++-
 kernel/signal.c           |    4 +++-
 kernel/time/timekeeping.c |    5 +++--
 kernel/trace/trace.h      |    3 ++-
 13 files changed, 34 insertions(+), 21 deletions(-)

diff -puN kernel/fork.c~kernel-used-macros-from-compilerh-instead-of-__attribute__ kernel/fork.c
--- a/kernel/fork.c~kernel-used-macros-from-compilerh-instead-of-__attribute__
+++ a/kernel/fork.c
@@ -73,6 +73,7 @@
 #include <linux/signalfd.h>
 #include <linux/uprobes.h>
 #include <linux/aio.h>
+#include <linux/compiler.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -286,7 +287,7 @@ void __init fork_init(unsigned long memp
 		init_task.signal->rlim[RLIMIT_NPROC];
 }
 
-int __attribute__((weak)) arch_dup_task_struct(struct task_struct *dst,
+int __weak arch_dup_task_struct(struct task_struct *dst,
 					       struct task_struct *src)
 {
 	*dst = *src;
diff -puN kernel/kallsyms.c~kernel-used-macros-from-compilerh-instead-of-__attribute__ kernel/kallsyms.c
--- a/kernel/kallsyms.c~kernel-used-macros-from-compilerh-instead-of-__attribute__
+++ a/kernel/kallsyms.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
+#include <linux/compiler.h>
 
 #include <asm/sections.h>
 
@@ -36,8 +37,8 @@
  * These will be re-linked against their real values
  * during the second link stage.
  */
-extern const unsigned long kallsyms_addresses[] __attribute__((weak));
-extern const u8 kallsyms_names[] __attribute__((weak));
+extern const unsigned long kallsyms_addresses[] __weak;
+extern const u8 kallsyms_names[] __weak;
 
 /*
  * Tell the compiler that the count isn't in the small data section if the arch
@@ -46,10 +47,10 @@ extern const u8 kallsyms_names[] __attri
 extern const unsigned long kallsyms_num_syms
 __attribute__((weak, section(".rodata")));
 
-extern const u8 kallsyms_token_table[] __attribute__((weak));
-extern const u16 kallsyms_token_index[] __attribute__((weak));
+extern const u8 kallsyms_token_table[] __weak;
+extern const u16 kallsyms_token_index[] __weak;
 
-extern const unsigned long kallsyms_markers[] __attribute__((weak));
+extern const unsigned long kallsyms_markers[] __weak;
 
 static inline int is_kernel_inittext(unsigned long addr)
 {
diff -puN kernel/kexec.c~kernel-used-macros-from-compilerh-instead-of-__attribute__ kernel/kexec.c
--- a/kernel/kexec.c~kernel-used-macros-from-compilerh-instead-of-__attribute__
+++ a/kernel/kexec.c
@@ -32,6 +32,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/syscore_ops.h>
+#include <linux/compiler.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1551,10 +1552,10 @@ void vmcoreinfo_append_str(const char *f
  * provide an empty default implementation here -- architecture
  * code may override this
  */
-void __attribute__ ((weak)) arch_crash_save_vmcoreinfo(void)
+void __weak arch_crash_save_vmcoreinfo(void)
 {}
 
-unsigned long __attribute__ ((weak)) paddr_vmcoreinfo_note(void)
+unsigned long __weak paddr_vmcoreinfo_note(void)
 {
 	return __pa((unsigned long)(char *)&vmcoreinfo_note);
 }
diff -puN kernel/ksysfs.c~kernel-used-macros-from-compilerh-instead-of-__attribute__ kernel/ksysfs.c
--- a/kernel/ksysfs.c~kernel-used-macros-from-compilerh-instead-of-__attribute__
+++ a/kernel/ksysfs.c
@@ -18,6 +18,7 @@
 #include <linux/stat.h>
 #include <linux/sched.h>
 #include <linux/capability.h>
+#include <linux/compiler.h>
 
 #include <linux/rcupdate.h>	/* rcu_expedited */
 
@@ -162,8 +163,8 @@ KERNEL_ATTR_RW(rcu_expedited);
 /*
  * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
  */
-extern const void __start_notes __attribute__((weak));
-extern const void __stop_notes __attribute__((weak));
+extern const void __start_notes __weak;
+extern const void __stop_notes __weak;
 #define	notes_size (&__stop_notes - &__start_notes)
 
 static ssize_t notes_read(struct file *filp, struct kobject *kobj,
diff -puN kernel/power/power.h~kernel-used-macros-from-compilerh-instead-of-__attribute__ kernel/power/power.h
--- a/kernel/power/power.h~kernel-used-macros-from-compilerh-instead-of-__attribute__
+++ a/kernel/power/power.h
@@ -2,6 +2,7 @@
 #include <linux/suspend_ioctls.h>
 #include <linux/utsname.h>
 #include <linux/freezer.h>
+#include <linux/compiler.h>
 
 struct swsusp_info {
 	struct new_utsname	uts;
@@ -11,7 +12,7 @@ struct swsusp_info {
 	unsigned long		image_pages;
 	unsigned long		pages;
 	unsigned long		size;
-} __attribute__((aligned(PAGE_SIZE)));
+} __aligned(PAGE_SIZE);
 
 #ifdef CONFIG_HIBERNATION
 /* kernel/power/snapshot.c */
diff -puN kernel/power/snapshot.c~kernel-used-macros-from-compilerh-instead-of-__attribute__ kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~kernel-used-macros-from-compilerh-instead-of-__attribute__
+++ a/kernel/power/snapshot.c
@@ -27,6 +27,7 @@
 #include <linux/highmem.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/compiler.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -155,7 +156,7 @@ static inline void free_image_page(void
 struct linked_page {
 	struct linked_page *next;
 	char data[LINKED_PAGE_DATA_SIZE];
-} __attribute__((packed));
+} __packed;
 
 static inline void
 free_list_of_pages(struct linked_page *list, int clear_page_nosave)
diff -puN kernel/power/suspend.c~kernel-used-macros-from-compilerh-instead-of-__attribute__ kernel/power/suspend.c
--- a/kernel/power/suspend.c~kernel-used-macros-from-compilerh-instead-of-__attribute__
+++ a/kernel/power/suspend.c
@@ -26,6 +26,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/ftrace.h>
 #include <trace/events/power.h>
+#include <linux/compiler.h>
 
 #include "power.h"
 
@@ -156,13 +157,13 @@ static int suspend_prepare(suspend_state
 }
 
 /* default implementation */
-void __attribute__ ((weak)) arch_suspend_disable_irqs(void)
+void __weak arch_suspend_disable_irqs(void)
 {
 	local_irq_disable();
 }
 
 /* default implementation */
-void __attribute__ ((weak)) arch_suspend_enable_irqs(void)
+void __weak arch_suspend_enable_irqs(void)
 {
 	local_irq_enable();
 }
diff -puN kernel/power/swap.c~kernel-used-macros-from-compilerh-instead-of-__attribute__ kernel/power/swap.c
--- a/kernel/power/swap.c~kernel-used-macros-from-compilerh-instead-of-__attribute__
+++ a/kernel/power/swap.c
@@ -101,7 +101,7 @@ struct swsusp_header {
 	unsigned int flags;	/* Flags to pass to the "boot" kernel */
 	char	orig_sig[10];
 	char	sig[10];
-} __attribute__((packed));
+} __packed;
 
 static struct swsusp_header *swsusp_header;
 
diff -puN kernel/sched/clock.c~kernel-used-macros-from-compilerh-instead-of-__attribute__ kernel/sched/clock.c
--- a/kernel/sched/clock.c~kernel-used-macros-from-compilerh-instead-of-__attribute__
+++ a/kernel/sched/clock.c
@@ -60,13 +60,14 @@
 #include <linux/sched.h>
 #include <linux/static_key.h>
 #include <linux/workqueue.h>
+#include <linux/compiler.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
  * This is default implementation.
  * Architectures and sub-architectures can override this.
  */
-unsigned long long __attribute__((weak)) sched_clock(void)
+unsigned long long __weak sched_clock(void)
 {
 	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
 					* (NSEC_PER_SEC / HZ);
diff -puN kernel/sched/core.c~kernel-used-macros-from-compilerh-instead-of-__attribute__ kernel/sched/core.c
--- a/kernel/sched/core.c~kernel-used-macros-from-compilerh-instead-of-__attribute__
+++ a/kernel/sched/core.c
@@ -73,6 +73,7 @@
 #include <linux/init_task.h>
 #include <linux/binfmts.h>
 #include <linux/context_tracking.h>
+#include <linux/compiler.h>
 
 #include <asm/switch_to.h>
 #include <asm/tlb.h>
@@ -6498,7 +6499,7 @@ static cpumask_var_t fallback_doms;
  * cpu core maps. It is supposed to return 1 if the topology changed
  * or 0 if it stayed the same.
  */
-int __attribute__((weak)) arch_update_cpu_topology(void)
+int __weak arch_update_cpu_topology(void)
 {
 	return 0;
 }
diff -puN kernel/signal.c~kernel-used-macros-from-compilerh-instead-of-__attribute__ kernel/signal.c
--- a/kernel/signal.c~kernel-used-macros-from-compilerh-instead-of-__attribute__
+++ a/kernel/signal.c
@@ -33,6 +33,8 @@
 #include <linux/uprobes.h>
 #include <linux/compat.h>
 #include <linux/cn_proc.h>
+#include <linux/compiler.h>
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>
 
@@ -3618,7 +3620,7 @@ SYSCALL_DEFINE3(sigsuspend, int, unused1
 }
 #endif
 
-__attribute__((weak)) const char *arch_vma_name(struct vm_area_struct *vma)
+__weak const char *arch_vma_name(struct vm_area_struct *vma)
 {
 	return NULL;
 }
diff -puN kernel/time/timekeeping.c~kernel-used-macros-from-compilerh-instead-of-__attribute__ kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~kernel-used-macros-from-compilerh-instead-of-__attribute__
+++ a/kernel/time/timekeeping.c
@@ -22,6 +22,7 @@
 #include <linux/tick.h>
 #include <linux/stop_machine.h>
 #include <linux/pvclock_gtod.h>
+#include <linux/compiler.h>
 
 #include "tick-internal.h"
 #include "ntp_internal.h"
@@ -760,7 +761,7 @@ u64 timekeeping_max_deferment(void)
  *
  *  XXX - Do be sure to remove it once all arches implement it.
  */
-void __attribute__((weak)) read_persistent_clock(struct timespec *ts)
+void __weak read_persistent_clock(struct timespec *ts)
 {
 	ts->tv_sec = 0;
 	ts->tv_nsec = 0;
@@ -775,7 +776,7 @@ void __attribute__((weak)) read_persiste
  *
  *  XXX - Do be sure to remove it once all arches implement it.
  */
-void __attribute__((weak)) read_boot_clock(struct timespec *ts)
+void __weak read_boot_clock(struct timespec *ts)
 {
 	ts->tv_sec = 0;
 	ts->tv_nsec = 0;
diff -puN kernel/trace/trace.h~kernel-used-macros-from-compilerh-instead-of-__attribute__ kernel/trace/trace.h
--- a/kernel/trace/trace.h~kernel-used-macros-from-compilerh-instead-of-__attribute__
+++ a/kernel/trace/trace.h
@@ -13,6 +13,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/trace_seq.h>
 #include <linux/ftrace_event.h>
+#include <linux/compiler.h>
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 #include <asm/unistd.h>		/* For NR_SYSCALLS	     */
@@ -1279,7 +1280,7 @@ int set_tracer_flag(struct trace_array *
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
 	extern struct ftrace_event_call					\
-	__attribute__((__aligned__(4))) event_##call;
+	__aligned(4) event_##call;
 #undef FTRACE_ENTRY_DUP
 #define FTRACE_ENTRY_DUP(call, struct_name, id, tstruct, print, filter)	\
 	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print), \
_

Patches currently in -mm which might be from gidisrael@gmail.com are

origin.patch

