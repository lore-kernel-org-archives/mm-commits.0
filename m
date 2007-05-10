From: akpm@linux-foundation.org
Subject: + uml-monitor-stack-usage.patch added to -mm tree
Date: Wed, 09 May 2007 21:08:04 -0700
Message-ID: <200705100408.l4A484kK011612@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757345AbXEJEII (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:08:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: monitor stack usage
has been added to the -mm tree.  Its filename is
     uml-monitor-stack-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: monitor stack usage
From: Jeff Dike <jdike@addtoit.com>

In preparation for reducing stack size, add a mechanism to see how much of a
kernel stack is used.  This fills a new stack with 0x6b on allocation and sees
where the lowest non-0x6b byte is on process exit.  It keeps track of the
lowest value and logs values as they get lower.

The lowest values I've seen so far are ~1250 bytes remaining on i386 (with
order 0 stacks) and ~2650 on x86_64 (order 1).

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.debug        |    8 +++++++
 arch/um/defconfig            |    1 
 arch/um/kernel/process.c     |   35 +++++++++++++++++++++++++++++++++
 include/asm-um/thread_info.h |   16 +++++++++++++++
 4 files changed, 60 insertions(+)

diff -puN arch/um/Kconfig.debug~uml-monitor-stack-usage arch/um/Kconfig.debug
--- a/arch/um/Kconfig.debug~uml-monitor-stack-usage
+++ a/arch/um/Kconfig.debug
@@ -47,4 +47,12 @@ config GCOV
         If you're involved in UML kernel development and want to use gcov,
         say Y.  If you're unsure, say N.
 
+config STACK_USAGE
+	bool "Track kernel stack usage"
+	default N
+	help
+	Track the maximum kernel stack usage - this will look at each
+	kernel stack at process exit and log it if it's the deepest
+	stack seen so far.
+
 endmenu
diff -puN arch/um/defconfig~uml-monitor-stack-usage arch/um/defconfig
--- a/arch/um/defconfig~uml-monitor-stack-usage
+++ a/arch/um/defconfig
@@ -527,3 +527,4 @@ CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_GPROF is not set
 # CONFIG_GCOV is not set
+# CONFIG_STACK_USAGE is not set
diff -puN arch/um/kernel/process.c~uml-monitor-stack-usage arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-monitor-stack-usage
+++ a/arch/um/kernel/process.c
@@ -427,3 +427,38 @@ unsigned long arch_align_stack(unsigned 
 	return sp & ~0xf;
 }
 #endif
+
+#ifdef CONFIG_STACK_USAGE
+
+static int lowest_to_date = THREAD_SIZE;
+
+void mark_stack(struct thread_info *stack)
+{
+	if(stack == NULL)
+		return;
+
+	memset(stack, 0x6b, THREAD_SIZE);
+}
+
+void check_stack_usage(struct thread_info *s)
+{
+	unsigned int *stack;
+	unsigned int *p, *end;
+	int left;
+
+	stack = (unsigned int *) (s + 1);
+	end = (unsigned int *) ((unsigned long) stack + THREAD_SIZE);
+	for(p = stack; p < end; p++){
+		if(*p != 0x6b6b6b6b){
+			left = (p - stack);
+			if(left < lowest_to_date){
+				printk("Greatest stack depth - %d bytes left\n",
+				       left * sizeof(*p));
+				lowest_to_date = left;
+			}
+			return;
+		}
+	}
+}
+
+#endif
diff -puN include/asm-um/thread_info.h~uml-monitor-stack-usage include/asm-um/thread_info.h
--- a/include/asm-um/thread_info.h~uml-monitor-stack-usage
+++ a/include/asm-um/thread_info.h
@@ -52,6 +52,20 @@ static inline struct thread_info *curren
 	return ti;
 }
 
+#ifdef CONFIG_STACK_USAGE
+
+extern void mark_stack(struct thread_info *stack);
+extern void check_stack_usage(struct thread_info *stack);
+
+#define alloc_thread_info(tsk) \
+	({ struct thread_info *stack = kmalloc(THREAD_SIZE, GFP_KERNEL); \
+	   mark_stack(stack); \
+	   stack; \
+	 })
+#define free_thread_info(ti) ({ check_stack_usage(ti) ; kfree(ti); })
+
+#else
+
 /* thread information allocation */
 #define alloc_thread_info(tsk) \
 	((struct thread_info *) kmalloc(THREAD_SIZE, GFP_KERNEL))
@@ -59,6 +73,8 @@ static inline struct thread_info *curren
 
 #endif
 
+#endif
+
 #define PREEMPT_ACTIVE		0x10000000
 
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-remove-task_protections.patch
uml-use-um_thread_size-in-userspace-code.patch
uml-tidy-irq-code.patch
uml-irq-stacks.patch
uml-monitor-stack-usage.patch
uml-shrink-kernel-stacks.patch
