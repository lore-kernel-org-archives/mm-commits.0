From: akpm@linux-foundation.org
Subject: + add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch added to -mm tree
Date: Mon, 25 Jun 2007 21:33:27 -0700
Message-ID: <200706260433.l5Q4XRmn018374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58607 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191AbXFZEdq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 00:33:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, mingo@elte.hu, oleg@tv-sign.ru


The patch titled
     Add generic exit-time stack-depth checking to CONFIG_DEBUG_STACK_USAGE
has been added to the -mm tree.  Its filename is
     add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add generic exit-time stack-depth checking to CONFIG_DEBUG_STACK_USAGE
From: Jeff Dike <jdike@addtoit.com>

Add generic exit-time stack-depth checking to CONFIG_DEBUG_STACK_USAGE.

This also adds UML support.

Tested on UML and i386.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.debug        |    9 +++++++++
 arch/um/defconfig            |    1 +
 include/asm-um/thread_info.h |    9 +++++++++
 kernel/exit.c                |   24 ++++++++++++++++++++++++
 4 files changed, 43 insertions(+)

diff -puN arch/um/Kconfig.debug~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage arch/um/Kconfig.debug
--- a/arch/um/Kconfig.debug~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage
+++ a/arch/um/Kconfig.debug
@@ -47,4 +47,13 @@ config GCOV
         If you're involved in UML kernel development and want to use gcov,
         say Y.  If you're unsure, say N.
 
+config DEBUG_STACK_USAGE
+	bool "Stack utilization instrumentation"
+	default N
+	help
+	  Track the maximum kernel stack usage - this will look at each
+	  kernel stack at process exit and log it if it's the deepest
+	  stack seen so far.
+
+	  This option will slow down process creation and destruction somewhat.
 endmenu
diff -puN arch/um/defconfig~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage arch/um/defconfig
--- a/arch/um/defconfig~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage
+++ a/arch/um/defconfig
@@ -527,3 +527,4 @@ CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_GPROF is not set
 # CONFIG_GCOV is not set
+# CONFIG_DEBUG_STACK_USAGE is not set
diff -puN include/asm-um/thread_info.h~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage include/asm-um/thread_info.h
--- a/include/asm-um/thread_info.h~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage
+++ a/include/asm-um/thread_info.h
@@ -52,10 +52,19 @@ static inline struct thread_info *curren
 	return ti;
 }
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+
+#define alloc_thread_info(tsk) \
+	((struct thread_info *) __get_free_pages(GFP_KERNEL | __GFP_ZERO, \
+						 CONFIG_KERNEL_STACK_ORDER))
+#else
+
 /* thread information allocation */
 #define alloc_thread_info(tsk) \
 	((struct thread_info *) __get_free_pages(GFP_KERNEL, \
 						 CONFIG_KERNEL_STACK_ORDER))
+#endif
+
 #define free_thread_info(ti) \
 	free_pages((unsigned long)(ti),CONFIG_KERNEL_STACK_ORDER)
 
diff -puN kernel/exit.c~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage kernel/exit.c
--- a/kernel/exit.c~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage
+++ a/kernel/exit.c
@@ -868,6 +868,27 @@ static void exit_notify(struct task_stru
 		release_task(tsk);
 }
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+static void check_stack_usage(void)
+{
+	static DEFINE_SPINLOCK(low_water_lock);
+	static int lowest_to_date = THREAD_SIZE;
+	unsigned long *n = end_of_stack(current), free;
+
+	while (*n == 0)
+		n++;
+	free = (unsigned long)n - (unsigned long)end_of_stack(current);
+
+	spin_lock(&low_water_lock);
+	if (free < lowest_to_date) {
+		printk(KERN_WARNING "Greatest stack depth - %ld bytes left\n",
+		       free);
+		lowest_to_date = free;
+	}
+	spin_unlock(&low_water_lock);
+}
+#endif
+
 fastcall NORET_TYPE void do_exit(long code)
 {
 	struct task_struct *tsk = current;
@@ -959,6 +980,9 @@ fastcall NORET_TYPE void do_exit(long co
 	exit_sem(tsk);
 	__exit_files(tsk);
 	__exit_fs(tsk);
+#ifdef CONFIG_DEBUG_STACK_USAGE
+	check_stack_usage();
+#endif
 	exit_thread();
 	cpuset_exit(tsk);
 	exit_keys(tsk);
_

Patches currently in -mm which might be from jdike@addtoit.com are

hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
uml-use-get_free_pages-to-allocate-kernel-stacks.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage-fix.patch
uml-add-stack-usage-monitoring.patch
