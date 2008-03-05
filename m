From: akpm@linux-foundation.org
Subject: - kprobes-move-kprobe-examples-to-samples.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:01 -0800
Message-ID: <200803050744.m257i1qH021469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765033AbYCEHpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ananth@in.ibm.com, mathieu.desnoyers@polymtl.ca, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Kprobes: move kprobe examples to samples/
has been removed from the -mm tree.  Its filename was
     kprobes-move-kprobe-examples-to-samples.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Kprobes: move kprobe examples to samples/
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Move kprobes examples from Documentation/kprobes.txt to under samples/.
Patch originally by Randy Dunlap.

o Updated the patch to apply on 2.6.25-rc3
o Modified examples code to build on multiple architectures. Currently,
  the kprobe and jprobe examples code works for x86 and powerpc
o Cleaned up unneeded #includes
o Cleaned up Kconfig per Sam Ravnborg's suggestions to fix build break
  on archs that don't have kretprobes
o Implemented suggestions by Mathieu Desnoyers on CONFIG_KRETPROBES
o Included Andrew Morton's cleanup based on x86-git
o Modified kretprobe_example to act as a arch-agnostic module to
  determine routine execution times:
	Use 'modprobe kretprobe_example func=<func_name>' to determine
	execution time of func_name in nanoseconds.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kprobes.txt           |  243 --------------------------
 samples/Kconfig                     |   11 +
 samples/Makefile                    |    2 
 samples/kprobes/Makefile            |    5 
 samples/kprobes/jprobe_example.c    |   68 +++++++
 samples/kprobes/kprobe_example.c    |   91 +++++++++
 samples/kprobes/kretprobe_example.c |  106 +++++++++++
 7 files changed, 287 insertions(+), 239 deletions(-)

diff -puN Documentation/kprobes.txt~kprobes-move-kprobe-examples-to-samples Documentation/kprobes.txt
--- a/Documentation/kprobes.txt~kprobes-move-kprobe-examples-to-samples
+++ a/Documentation/kprobes.txt
@@ -192,7 +192,8 @@ code mapping.
 The Kprobes API includes a "register" function and an "unregister"
 function for each type of probe.  Here are terse, mini-man-page
 specifications for these functions and the associated probe handlers
-that you'll write.  See the latter half of this document for examples.
+that you'll write.  See the files in the samples/kprobes/ sub-directory
+for examples.
 
 4.1 register_kprobe
 
@@ -420,249 +421,15 @@ e. Watchpoint probes (which fire on data
 
 8. Kprobes Example
 
-Here's a sample kernel module showing the use of kprobes to dump a
-stack trace and selected i386 registers when do_fork() is called.
------ cut here -----
-/*kprobe_example.c*/
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/kprobes.h>
-#include <linux/sched.h>
-
-/*For each probe you need to allocate a kprobe structure*/
-static struct kprobe kp;
-
-/*kprobe pre_handler: called just before the probed instruction is executed*/
-int handler_pre(struct kprobe *p, struct pt_regs *regs)
-{
-	printk("pre_handler: p->addr=0x%p, eip=%lx, eflags=0x%lx\n",
-		p->addr, regs->eip, regs->eflags);
-	dump_stack();
-	return 0;
-}
-
-/*kprobe post_handler: called after the probed instruction is executed*/
-void handler_post(struct kprobe *p, struct pt_regs *regs, unsigned long flags)
-{
-	printk("post_handler: p->addr=0x%p, eflags=0x%lx\n",
-		p->addr, regs->eflags);
-}
-
-/* fault_handler: this is called if an exception is generated for any
- * instruction within the pre- or post-handler, or when Kprobes
- * single-steps the probed instruction.
- */
-int handler_fault(struct kprobe *p, struct pt_regs *regs, int trapnr)
-{
-	printk("fault_handler: p->addr=0x%p, trap #%dn",
-		p->addr, trapnr);
-	/* Return 0 because we don't handle the fault. */
-	return 0;
-}
-
-static int __init kprobe_init(void)
-{
-	int ret;
-	kp.pre_handler = handler_pre;
-	kp.post_handler = handler_post;
-	kp.fault_handler = handler_fault;
-	kp.symbol_name = "do_fork";
-
-	ret = register_kprobe(&kp);
-	if (ret < 0) {
-		printk("register_kprobe failed, returned %d\n", ret);
-		return ret;
-	}
-	printk("kprobe registered\n");
-	return 0;
-}
-
-static void __exit kprobe_exit(void)
-{
-	unregister_kprobe(&kp);
-	printk("kprobe unregistered\n");
-}
-
-module_init(kprobe_init)
-module_exit(kprobe_exit)
-MODULE_LICENSE("GPL");
------ cut here -----
-
-You can build the kernel module, kprobe-example.ko, using the following
-Makefile:
------ cut here -----
-obj-m := kprobe-example.o
-KDIR := /lib/modules/$(shell uname -r)/build
-PWD := $(shell pwd)
-default:
-	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
-clean:
-	rm -f *.mod.c *.ko *.o
------ cut here -----
-
-$ make
-$ su -
-...
-# insmod kprobe-example.ko
-
-You will see the trace data in /var/log/messages and on the console
-whenever do_fork() is invoked to create a new process.
+See samples/kprobes/kprobe_example.c
 
 9. Jprobes Example
 
-Here's a sample kernel module showing the use of jprobes to dump
-the arguments of do_fork().
------ cut here -----
-/*jprobe-example.c */
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/uio.h>
-#include <linux/kprobes.h>
-
-/*
- * Jumper probe for do_fork.
- * Mirror principle enables access to arguments of the probed routine
- * from the probe handler.
- */
-
-/* Proxy routine having the same arguments as actual do_fork() routine */
-long jdo_fork(unsigned long clone_flags, unsigned long stack_start,
-	      struct pt_regs *regs, unsigned long stack_size,
-	      int __user * parent_tidptr, int __user * child_tidptr)
-{
-	printk("jprobe: clone_flags=0x%lx, stack_size=0x%lx, regs=0x%p\n",
-	       clone_flags, stack_size, regs);
-	/* Always end with a call to jprobe_return(). */
-	jprobe_return();
-	/*NOTREACHED*/
-	return 0;
-}
-
-static struct jprobe my_jprobe = {
-	.entry = jdo_fork
-};
-
-static int __init jprobe_init(void)
-{
-	int ret;
-	my_jprobe.kp.symbol_name = "do_fork";
-
-	if ((ret = register_jprobe(&my_jprobe)) <0) {
-		printk("register_jprobe failed, returned %d\n", ret);
-		return -1;
-	}
-	printk("Planted jprobe at %p, handler addr %p\n",
-	       my_jprobe.kp.addr, my_jprobe.entry);
-	return 0;
-}
-
-static void __exit jprobe_exit(void)
-{
-	unregister_jprobe(&my_jprobe);
-	printk("jprobe unregistered\n");
-}
-
-module_init(jprobe_init)
-module_exit(jprobe_exit)
-MODULE_LICENSE("GPL");
------ cut here -----
-
-Build and insert the kernel module as shown in the above kprobe
-example.  You will see the trace data in /var/log/messages and on
-the console whenever do_fork() is invoked to create a new process.
-(Some messages may be suppressed if syslogd is configured to
-eliminate duplicate messages.)
+See samples/kprobes/jprobe_example.c
 
 10. Kretprobes Example
 
-Here's a sample kernel module showing the use of return probes to
-report failed calls to sys_open().
------ cut here -----
-/*kretprobe-example.c*/
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/kprobes.h>
-#include <linux/ktime.h>
-
-/* per-instance private data */
-struct my_data {
-	ktime_t entry_stamp;
-};
-
-static const char *probed_func = "sys_open";
-
-/* Timestamp function entry. */
-static int entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
-{
-	struct my_data *data;
-
-	if(!current->mm)
-		return 1; /* skip kernel threads */
-
-	data = (struct my_data *)ri->data;
-	data->entry_stamp = ktime_get();
-	return 0;
-}
-
-/* If the probed function failed, log the return value and duration.
- * Duration may turn out to be zero consistently, depending upon the
- * granularity of time accounting on the platform. */
-static int return_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
-{
-	int retval = regs_return_value(regs);
-	struct my_data *data = (struct my_data *)ri->data;
-	s64 delta;
-	ktime_t now;
-
-	if (retval < 0) {
-		now = ktime_get();
-		delta = ktime_to_ns(ktime_sub(now, data->entry_stamp));
-		printk("%s: return val = %d (duration = %lld ns)\n",
-		       probed_func, retval, delta);
-	}
-	return 0;
-}
-
-static struct kretprobe my_kretprobe = {
-	.handler = return_handler,
-	.entry_handler = entry_handler,
-	.data_size = sizeof(struct my_data),
-	.maxactive = 20, /* probe up to 20 instances concurrently */
-};
-
-static int __init kretprobe_init(void)
-{
-	int ret;
-	my_kretprobe.kp.symbol_name = (char *)probed_func;
-
-	if ((ret = register_kretprobe(&my_kretprobe)) < 0) {
-		printk("register_kretprobe failed, returned %d\n", ret);
-		return -1;
-	}
-	printk("Kretprobe active on %s\n", my_kretprobe.kp.symbol_name);
-	return 0;
-}
-
-static void __exit kretprobe_exit(void)
-{
-	unregister_kretprobe(&my_kretprobe);
-	printk("kretprobe unregistered\n");
-	/* nmissed > 0 suggests that maxactive was set too low. */
-	printk("Missed probing %d instances of %s\n",
-	       my_kretprobe.nmissed, probed_func);
-}
-
-module_init(kretprobe_init)
-module_exit(kretprobe_exit)
-MODULE_LICENSE("GPL");
------ cut here -----
-
-Build and insert the kernel module as shown in the above kprobe
-example.  You will see the trace data in /var/log/messages and on the
-console whenever sys_open() returns a negative value.  (Some messages
-may be suppressed if syslogd is configured to eliminate duplicate
-messages.)
+See samples/kprobes/kretprobe_example.c
 
 For additional information on Kprobes, refer to the following URLs:
 http://www-106.ibm.com/developerworks/library/l-kprobes.html?ca=dgr-lnxw42Kprobe
diff -puN samples/Kconfig~kprobes-move-kprobe-examples-to-samples samples/Kconfig
--- a/samples/Kconfig~kprobes-move-kprobe-examples-to-samples
+++ a/samples/Kconfig
@@ -22,5 +22,16 @@ config SAMPLE_KOBJECT
 
 	  If in doubt, say "N" here.
 
+config SAMPLE_KPROBES
+	tristate "Build kprobes examples -- loadable modules only"
+	depends on KPROBES && m
+	help
+	  This build several kprobes example modules.
+
+config SAMPLE_KRETPROBES
+	tristate "Build kretprobes example -- loadable modules only"
+	default m
+	depends on SAMPLE_KPROBES && KRETPROBES
+
 endif # SAMPLES
 
diff -puN samples/Makefile~kprobes-move-kprobe-examples-to-samples samples/Makefile
--- a/samples/Makefile~kprobes-move-kprobe-examples-to-samples
+++ a/samples/Makefile
@@ -1,3 +1,3 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/
diff -puN /dev/null samples/kprobes/Makefile
--- /dev/null
+++ a/samples/kprobes/Makefile
@@ -0,0 +1,5 @@
+# builds the kprobes example kernel modules;
+# then to use one (as root):  insmod <module_name.ko>
+
+obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o
+obj-$(CONFIG_SAMPLE_KRETPROBES) += kretprobe_example.o
diff -puN /dev/null samples/kprobes/jprobe_example.c
--- /dev/null
+++ a/samples/kprobes/jprobe_example.c
@@ -0,0 +1,68 @@
+/*
+ * Here's a sample kernel module showing the use of jprobes to dump
+ * the arguments of do_fork().
+ *
+ * For more information on theory of operation of jprobes, see
+ * Documentation/kprobes.txt
+ *
+ * Build and insert the kernel module as done in the kprobe example.
+ * You will see the trace data in /var/log/messages and on the
+ * console whenever do_fork() is invoked to create a new process.
+ * (Some messages may be suppressed if syslogd is configured to
+ * eliminate duplicate messages.)
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+
+/*
+ * Jumper probe for do_fork.
+ * Mirror principle enables access to arguments of the probed routine
+ * from the probe handler.
+ */
+
+/* Proxy routine having the same arguments as actual do_fork() routine */
+static long jdo_fork(unsigned long clone_flags, unsigned long stack_start,
+	      struct pt_regs *regs, unsigned long stack_size,
+	      int __user *parent_tidptr, int __user *child_tidptr)
+{
+	printk(KERN_INFO "jprobe: clone_flags = 0x%lx, stack_size = 0x%lx,"
+			" regs = 0x%p\n",
+	       clone_flags, stack_size, regs);
+
+	/* Always end with a call to jprobe_return(). */
+	jprobe_return();
+	return 0;
+}
+
+static struct jprobe my_jprobe = {
+	.entry			= jdo_fork,
+	.kp = {
+		.symbol_name	= "do_fork",
+	},
+};
+
+static int __init jprobe_init(void)
+{
+	int ret;
+
+	ret = register_jprobe(&my_jprobe);
+	if (ret < 0) {
+		printk(KERN_INFO "register_jprobe failed, returned %d\n", ret);
+		return -1;
+	}
+	printk(KERN_INFO "Planted jprobe at %p, handler addr %p\n",
+	       my_jprobe.kp.addr, my_jprobe.entry);
+	return 0;
+}
+
+static void __exit jprobe_exit(void)
+{
+	unregister_jprobe(&my_jprobe);
+	printk(KERN_INFO "jprobe at %p unregistered\n", my_jprobe.kp.addr);
+}
+
+module_init(jprobe_init)
+module_exit(jprobe_exit)
+MODULE_LICENSE("GPL");
diff -puN /dev/null samples/kprobes/kprobe_example.c
--- /dev/null
+++ a/samples/kprobes/kprobe_example.c
@@ -0,0 +1,91 @@
+/*
+ * NOTE: This example is works on x86 and powerpc.
+ * Here's a sample kernel module showing the use of kprobes to dump a
+ * stack trace and selected registers when do_fork() is called.
+ *
+ * For more information on theory of operation of kprobes, see
+ * Documentation/kprobes.txt
+ *
+ * You will see the trace data in /var/log/messages and on the console
+ * whenever do_fork() is invoked to create a new process.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+
+/* For each probe you need to allocate a kprobe structure */
+static struct kprobe kp = {
+	.symbol_name	= "do_fork",
+};
+
+/* kprobe pre_handler: called just before the probed instruction is executed */
+static int handler_pre(struct kprobe *p, struct pt_regs *regs)
+{
+#ifdef CONFIG_X86
+	printk(KERN_INFO "pre_handler: p->addr = 0x%p, ip = %lx,"
+			" flags = 0x%lx\n",
+		p->addr, regs->ip, regs->flags);
+#endif
+#ifdef CONFIG_PPC
+	printk(KERN_INFO "pre_handler: p->addr = 0x%p, nip = 0x%lx,"
+			" msr = 0x%lx\n",
+		p->addr, regs->nip, regs->msr);
+#endif
+
+	/* A dump_stack() here will give a stack backtrace */
+	return 0;
+}
+
+/* kprobe post_handler: called after the probed instruction is executed */
+static void handler_post(struct kprobe *p, struct pt_regs *regs,
+				unsigned long flags)
+{
+#ifdef CONFIG_X86
+	printk(KERN_INFO "post_handler: p->addr = 0x%p, flags = 0x%lx\n",
+		p->addr, regs->flags);
+#endif
+#ifdef CONFIG_PPC
+	printk(KERN_INFO "post_handler: p->addr = 0x%p, msr = 0x%lx\n",
+		p->addr, regs->msr);
+#endif
+}
+
+/*
+ * fault_handler: this is called if an exception is generated for any
+ * instruction within the pre- or post-handler, or when Kprobes
+ * single-steps the probed instruction.
+ */
+static int handler_fault(struct kprobe *p, struct pt_regs *regs, int trapnr)
+{
+	printk(KERN_INFO "fault_handler: p->addr = 0x%p, trap #%dn",
+		p->addr, trapnr);
+	/* Return 0 because we don't handle the fault. */
+	return 0;
+}
+
+static int __init kprobe_init(void)
+{
+	int ret;
+	kp.pre_handler = handler_pre;
+	kp.post_handler = handler_post;
+	kp.fault_handler = handler_fault;
+
+	ret = register_kprobe(&kp);
+	if (ret < 0) {
+		printk(KERN_INFO "register_kprobe failed, returned %d\n", ret);
+		return ret;
+	}
+	printk(KERN_INFO "Planted kprobe at %p\n", kp.addr);
+	return 0;
+}
+
+static void __exit kprobe_exit(void)
+{
+	unregister_kprobe(&kp);
+	printk(KERN_INFO "kprobe at %p unregistered\n", kp.addr);
+}
+
+module_init(kprobe_init)
+module_exit(kprobe_exit)
+MODULE_LICENSE("GPL");
diff -puN /dev/null samples/kprobes/kretprobe_example.c
--- /dev/null
+++ a/samples/kprobes/kretprobe_example.c
@@ -0,0 +1,106 @@
+/*
+ * kretprobe_example.c
+ *
+ * Here's a sample kernel module showing the use of return probes to
+ * report the return value and total time taken for probed function
+ * to run.
+ *
+ * usage: insmod kretprobe_example.ko func=<func_name>
+ *
+ * If no func_name is specified, do_fork is instrumented
+ *
+ * For more information on theory of operation of kretprobes, see
+ * Documentation/kprobes.txt
+ *
+ * Build and insert the kernel module as done in the kprobe example.
+ * You will see the trace data in /var/log/messages and on the console
+ * whenever the probed function returns. (Some messages may be suppressed
+ * if syslogd is configured to eliminate duplicate messages.)
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+#include <linux/ktime.h>
+#include <linux/limits.h>
+
+static char func_name[NAME_MAX] = "do_fork";
+module_param_string(func, func_name, NAME_MAX, S_IRUGO);
+MODULE_PARM_DESC(func, "Function to kretprobe; this module will report the"
+			" function's execution time");
+
+/* per-instance private data */
+struct my_data {
+	ktime_t entry_stamp;
+};
+
+/* Here we use the entry_hanlder to timestamp function entry */
+static int entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	struct my_data *data;
+
+	if (!current->mm)
+		return 1;	/* Skip kernel threads */
+
+	data = (struct my_data *)ri->data;
+	data->entry_stamp = ktime_get();
+	return 0;
+}
+
+/*
+ * Return-probe handler: Log the return value and duration. Duration may turn
+ * out to be zero consistently, depending upon the granularity of time
+ * accounting on the platform.
+ */
+static int ret_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	int retval = regs_return_value(regs);
+	struct my_data *data = (struct my_data *)ri->data;
+	s64 delta;
+	ktime_t now;
+
+	now = ktime_get();
+	delta = ktime_to_ns(ktime_sub(now, data->entry_stamp));
+	printk(KERN_INFO "%s returned %d and took %lld ns to execute\n",
+			func_name, retval, (long long)delta);
+	return 0;
+}
+
+static struct kretprobe my_kretprobe = {
+	.handler		= ret_handler,
+	.entry_handler		= entry_handler,
+	.data_size		= sizeof(struct my_data),
+	/* Probe up to 20 instances concurrently. */
+	.maxactive		= 20,
+};
+
+static int __init kretprobe_init(void)
+{
+	int ret;
+
+	my_kretprobe.kp.symbol_name = func_name;
+	ret = register_kretprobe(&my_kretprobe);
+	if (ret < 0) {
+		printk(KERN_INFO "register_kretprobe failed, returned %d\n",
+				ret);
+		return -1;
+	}
+	printk(KERN_INFO "Planted return probe at %s: %p\n",
+			my_kretprobe.kp.symbol_name, my_kretprobe.kp.addr);
+	return 0;
+}
+
+static void __exit kretprobe_exit(void)
+{
+	unregister_kretprobe(&my_kretprobe);
+	printk(KERN_INFO "kretprobe at %p unregistered\n",
+			my_kretprobe.kp.addr);
+
+	/* nmissed > 0 suggests that maxactive was set too low. */
+	printk(KERN_INFO "Missed probing %d instances of %s\n",
+		my_kretprobe.nmissed, my_kretprobe.kp.symbol_name);
+}
+
+module_init(kretprobe_init)
+module_exit(kretprobe_exit)
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from ananth@in.ibm.com are

kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch

