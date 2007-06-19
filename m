From: akpm@linux-foundation.org
Subject: + uml-add-stack-usage-monitoring.patch added to -mm tree
Date: Tue, 19 Jun 2007 11:55:24 -0700
Message-ID: <200706191855.l5JItOcQ018520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58185 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759297AbXFSS4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 14:56:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: add stack usage monitoring
has been added to the -mm tree.  Its filename is
     uml-add-stack-usage-monitoring.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: add stack usage monitoring
From: Jeff Dike <jdike@addtoit.com>

Add a mechanism to see how much of a kernel stack is used.  This allocates
zeroed stacks and sees where the lowest non-zero byte is on process exit.  It
keeps track of the lowest value and logs values as they get lower.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.debug        |    9 +++++++++
 arch/um/defconfig            |    1 +
 arch/um/kernel/process.c     |   29 +++++++++++++++++++++++++++++
 include/asm-um/thread_info.h |   16 ++++++++++++++++
 4 files changed, 55 insertions(+)

diff -puN arch/um/Kconfig.debug~uml-add-stack-usage-monitoring arch/um/Kconfig.debug
--- a/arch/um/Kconfig.debug~uml-add-stack-usage-monitoring
+++ a/arch/um/Kconfig.debug
@@ -47,4 +47,13 @@ config GCOV
         If you're involved in UML kernel development and want to use gcov,
         say Y.  If you're unsure, say N.
 
+config DEBUG_STACK_USAGE
+	bool "Stack utilization instrumentation"
+	default N
+	help
+	Track the maximum kernel stack usage - this will look at each
+	kernel stack at process exit and log it if it's the deepest
+	stack seen so far.
+
+	This option will slow down process creation and destruction somewhat.
 endmenu
diff -puN arch/um/defconfig~uml-add-stack-usage-monitoring arch/um/defconfig
--- a/arch/um/defconfig~uml-add-stack-usage-monitoring
+++ a/arch/um/defconfig
@@ -527,3 +527,4 @@ CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_GPROF is not set
 # CONFIG_GCOV is not set
+# CONFIG_DEBUG_STACK_USAGE is not set
diff -puN arch/um/kernel/process.c~uml-add-stack-usage-monitoring arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-add-stack-usage-monitoring
+++ a/arch/um/kernel/process.c
@@ -427,3 +427,32 @@ unsigned long arch_align_stack(unsigned 
 	return sp & ~0xf;
 }
 #endif
+
+#ifdef CONFIG_DEBUG_STACK_USAGE
+
+static DEFINE_SPINLOCK(low_water_lock);
+static int lowest_to_date = THREAD_SIZE;
+
+void check_stack_usage(struct thread_info *s)
+{
+	unsigned int *stack, *p, *end;
+	int left;
+
+	stack = (unsigned int *) (s + 1);
+	end = (unsigned int *) ((unsigned long) s + THREAD_SIZE);
+	for(p = stack; p < end; p++){
+		if(*p != 0)
+			break;
+	}
+
+	left = (p - stack) * sizeof(*p);
+
+	spin_lock(&low_water_lock);
+	if(left < lowest_to_date){
+		printk("Greatest stack depth - %d bytes left\n", left);
+		lowest_to_date = left;
+	}
+	spin_unlock(&low_water_lock);
+}
+
+#endif
diff -puN include/asm-um/thread_info.h~uml-add-stack-usage-monitoring include/asm-um/thread_info.h
--- a/include/asm-um/thread_info.h~uml-add-stack-usage-monitoring
+++ a/include/asm-um/thread_info.h
@@ -52,6 +52,20 @@ static inline struct thread_info *curren
 	return ti;
 }
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+
+extern void check_stack_usage(struct thread_info *stack);
+
+#define alloc_thread_info(tsk) \
+	((struct thread_info *) __get_free_pages(GFP_KERNEL | __GFP_ZERO, \
+						 CONFIG_KERNEL_STACK_ORDER))
+
+#define free_thread_info(ti) ({ check_stack_usage(ti) ; \
+			        free_pages((unsigned long)(ti), \
+					   CONFIG_KERNEL_STACK_ORDER); })
+
+#else
+
 /* thread information allocation */
 #define alloc_thread_info(tsk) \
 	((struct thread_info *) __get_free_pages(GFP_KERNEL, \
@@ -61,6 +75,8 @@ static inline struct thread_info *curren
 
 #endif
 
+#endif
+
 #define PREEMPT_ACTIVE		0x10000000
 
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
_

Patches currently in -mm which might be from jdike@addtoit.com are

hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
uml-use-get_free_pages-to-allocate-kernel-stacks.patch
uml-add-stack-usage-monitoring.patch
