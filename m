From: akpm@linux-foundation.org
Subject: - move-kprobes-examples-to-samples-resend.patch removed from -mm tree
Date: Tue, 11 Dec 2007 21:39:13 -0800
Message-ID: <200712120539.lBC5dDZW027854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876AbXLLFkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:40:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ananth@in.ibm.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Move kprobes examples to samples/
has been removed from the -mm tree.  Its filename was
     move-kprobes-examples-to-samples-resend.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Move kprobes examples to samples/
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Move kprobes examples from Documentation/kprobes.txt to under samples/.
Patch originally by Randy Dunlap.

In addition, I have

o Updated the patch to apply on 2.6.23-mm1
o Modified examples code to build on multiple architectures. Currently,
  the examples code works for x86_64, x86_32 and powerpc
o Cleaned up unneeded #includes

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kprobes.txt           |  214 --------------------------
 samples/Kconfig                     |    6 
 samples/Makefile                    |    2 
 samples/kprobes/Makefile            |    5 
 samples/kprobes/jprobe_example.c    |   64 +++++++
 samples/kprobes/kprobe_example.c    |   89 ++++++++++
 samples/kprobes/kretprobe_example.c |   59 +++++++
 7 files changed, 229 insertions(+), 210 deletions(-)

diff -puN Documentation/kprobes.txt~move-kprobes-examples-to-samples-resend Documentation/kprobes.txt
--- a/Documentation/kprobes.txt~move-kprobes-examples-to-samples-resend
+++ a/Documentation/kprobes.txt
@@ -166,7 +166,8 @@ code mapping.
 The Kprobes API includes a "register" function and an "unregister"
 function for each type of probe.  Here are terse, mini-man-page
 specifications for these functions and the associated probe handlers
-that you'll write.  See the latter half of this document for examples.
+that you'll write.  See the files in the samples/kprobes/ sub-directory
+for examples.
 
 4.1 register_kprobe
 
@@ -392,220 +393,15 @@ e. Watchpoint probes (which fire on data
 
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
+See samples/kprobes/kprobe_example.c.
 
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
+See samples/kprobes/jprobe_example.c.
 
 10. Kretprobes Example
 
-Here's a sample kernel module showing the use of return probes to
-report failed calls to sys_open().
------ cut here -----
-/*kretprobe-example.c*/
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/kprobes.h>
-
-static const char *probed_func = "sys_open";
-
-/* Return-probe handler: If the probed function fails, log the return value. */
-static int ret_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
-{
-	int retval = regs_return_value(regs);
-	if (retval < 0) {
-		printk("%s returns %d\n", probed_func, retval);
-	}
-	return 0;
-}
-
-static struct kretprobe my_kretprobe = {
-	.handler = ret_handler,
-	/* Probe up to 20 instances concurrently. */
-	.maxactive = 20
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
-	printk("Planted return probe at %p\n", my_kretprobe.kp.addr);
-	return 0;
-}
-
-static void __exit kretprobe_exit(void)
-{
-	unregister_kretprobe(&my_kretprobe);
-	printk("kretprobe unregistered\n");
-	/* nmissed > 0 suggests that maxactive was set too low. */
-	printk("Missed probing %d instances of %s\n",
-		my_kretprobe.nmissed, probed_func);
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
+See samples/kprobes/kretprobe_example.c.
 
 For additional information on Kprobes, refer to the following URLs:
 http://www-106.ibm.com/developerworks/library/l-kprobes.html?ca=dgr-lnxw42Kprobe
diff -puN samples/Kconfig~move-kprobes-examples-to-samples-resend samples/Kconfig
--- a/samples/Kconfig~move-kprobes-examples-to-samples-resend
+++ a/samples/Kconfig
@@ -22,5 +22,11 @@ config SAMPLE_KOBJECT
 
 	  If in doubt, say "N" here.
 
+config SAMPLE_KPROBES
+	tristate "Build kprobes examples -- loadable modules only"
+	depends on KPROBES && m
+	help
+	  This build several kprobes example modules.
+
 endif # SAMPLES
 
diff -puN /dev/null samples/kprobes/jprobe_example.c
--- /dev/null
+++ a/samples/kprobes/jprobe_example.c
@@ -0,0 +1,64 @@
+/*
+ * Here's a sample kernel module showing the use of jprobes to dump
+ * the arguments of do_fork().
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
+	      int __user * parent_tidptr, int __user * child_tidptr)
+{
+	printk("jprobe: clone_flags = 0x%lx, stack_size = 0x%lx, regs = 0x%p\n",
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
+		printk("register_jprobe failed, returned %d\n", ret);
+		return -1;
+	}
+	printk("Planted jprobe at %p, handler addr %p\n",
+	       my_jprobe.kp.addr, my_jprobe.entry);
+	return 0;
+}
+
+static void __exit jprobe_exit(void)
+{
+	unregister_jprobe(&my_jprobe);
+	printk("jprobe at %p unregistered\n", my_jprobe.kp.addr);
+}
+
+module_init(jprobe_init)
+module_exit(jprobe_exit)
+MODULE_LICENSE("GPL");
diff -puN /dev/null samples/kprobes/kprobe_example.c
--- /dev/null
+++ a/samples/kprobes/kprobe_example.c
@@ -0,0 +1,89 @@
+/*
+ * NOTE: This example is works on x86 and powerpc.
+ * Here's a sample kernel module showing the use of kprobes to dump a
+ * stack trace and selected registers when do_fork() is called.
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
+#ifdef CONFIG_X86_32
+	printk("pre_handler: p->addr = 0x%p, eip = %lx, eflags = 0x%lx\n",
+		p->addr, regs->eip, regs->eflags);
+#endif
+#ifdef CONFIG_X86_64
+	printk("pre_handler: p->addr = 0x%p, rip = %lx, eflags = 0x%lx\n",
+		p->addr, regs->rip, regs->eflags);
+#endif
+#ifdef CONFIG_PPC
+	printk("pre_handler: p->addr = 0x%p, nip = 0x%lx, msr = 0x%lx\n",
+		p->addr, regs->nip, regs->msr);
+#endif
+
+	/* A dump_stack() here will give a stack backtrace */
+	return 0;
+}
+
+/* kprobe post_handler: called after the probed instruction is executed */
+static void handler_post(struct kprobe *p, struct pt_regs *regs, unsigned long flags)
+{
+#if defined(CONFIG_X86_32) || defined(CONFIG_X86_64)
+	printk("post_handler: p->addr = 0x%p, eflags = 0x%lx\n",
+		p->addr, regs->eflags);
+#endif
+#ifdef CONFIG_PPC
+	printk("post_handler: p->addr = 0x%p, msr = 0x%lx\n",
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
+	printk("fault_handler: p->addr = 0x%p, trap #%dn",
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
+		printk("register_kprobe failed, returned %d\n", ret);
+		return ret;
+	}
+	printk("Planted kprobe at %p\n", kp.addr);
+	return 0;
+}
+
+static void __exit kprobe_exit(void)
+{
+	unregister_kprobe(&kp);
+	printk("kprobe at %p unregistered\n", kp.addr);
+}
+
+module_init(kprobe_init)
+module_exit(kprobe_exit)
+MODULE_LICENSE("GPL");
diff -puN /dev/null samples/kprobes/kretprobe_example.c
--- /dev/null
+++ a/samples/kprobes/kretprobe_example.c
@@ -0,0 +1,59 @@
+/*
+ * Here's a sample kernel module showing the use of return probes to
+ * report the return value from do_fork().
+ *
+ * Build and insert the kernel module as done in the kprobe example.
+ * You will see the trace data in /var/log/messages and on the console
+ * whenever sys_open() returns a negative value.  (Some messages
+ * may be suppressed if syslogd is configured to eliminate duplicate
+ * messages.)
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+
+/* Return-probe handler: If the probed function fails, log the return value. */
+static int ret_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	int retval = regs_return_value(regs);
+
+	printk("do_fork returns %d\n", retval);
+	return 0;
+}
+
+static struct kretprobe my_kretprobe = {
+	.handler		= ret_handler,
+	.kp = {
+		.symbol_name	= "do_fork",
+	},
+	/* Probe up to 20 instances concurrently. */
+	.maxactive		= 20,
+};
+
+static int __init kretprobe_init(void)
+{
+	int ret;
+
+	ret = register_kretprobe(&my_kretprobe);
+	if (ret < 0) {
+		printk("register_kretprobe failed, returned %d\n", ret);
+		return -1;
+	}
+	printk("Planted return probe at %p\n", my_kretprobe.kp.addr);
+	return 0;
+}
+
+static void __exit kretprobe_exit(void)
+{
+	unregister_kretprobe(&my_kretprobe);
+	printk("kretprobe at %p unregistered\n", my_kretprobe.kp.addr);
+
+	/* nmissed > 0 suggests that maxactive was set too low. */
+	printk("Missed probing %d instances of do_fork()\n",
+		my_kretprobe.nmissed);
+}
+
+module_init(kretprobe_init)
+module_exit(kretprobe_exit)
+MODULE_LICENSE("GPL");
diff -puN /dev/null samples/kprobes/Makefile
--- /dev/null
+++ a/samples/kprobes/Makefile
@@ -0,0 +1,5 @@
+# builds the kprobes example kernel modules;
+# then to use one (as root):  insmod <module_name.ko>
+
+obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o \
+		kretprobe_example.o
diff -puN samples/Makefile~move-kprobes-examples-to-samples-resend samples/Makefile
--- a/samples/Makefile~move-kprobes-examples-to-samples-resend
+++ a/samples/Makefile
@@ -1,3 +1,3 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/
_

Patches currently in -mm which might be from ananth@in.ibm.com are

create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
move-kprobes-examples-to-samples-resend-vs-git-x86.patch
