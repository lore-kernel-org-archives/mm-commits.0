From: akpm@linux-foundation.org
Subject: - profile-likely-unlikely-macros.patch removed from -mm tree
Date: Tue, 21 Aug 2007 02:05:27 -0700
Message-ID: <200708210910.l7L9AYa1016287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59624 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233AbXHUJKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 05:10:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, hzhong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Profile likely/unlikely macros
has been removed from the -mm tree.  Its filename was
     profile-likely-unlikely-macros.patch

This patch was dropped because it no gets ".data overlaps section .text" errors in the vdso stuff

------------------------------------------------------
Subject: Profile likely/unlikely macros
From: Daniel Walker <dwalker@mvista.com>

-ENOCHANGELOG!

Creates /proc/likely_prof.

[randy.dunlap@oracle.com: profile_likely: export do_check_likely]
Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Hua Zhong <hzhong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/vsyscall.c |    4 
 include/linux/compiler.h      |   35 +++++++
 lib/Kconfig.debug             |    8 +
 lib/Makefile                  |    2 
 lib/likely_prof.c             |  146 ++++++++++++++++++++++++++++++++
 5 files changed, 193 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/vsyscall.c~profile-likely-unlikely-macros arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~profile-likely-unlikely-macros
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -122,7 +122,7 @@ static __always_inline void do_vgettimeo
 		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
 
 		vread = __vsyscall_gtod_data.clock.vread;
-		if (unlikely(!__vsyscall_gtod_data.sysctl_enabled || !vread)) {
+		if (!__vsyscall_gtod_data.sysctl_enabled || !vread) {
 			gettimeofday(tv,NULL);
 			return;
 		}
@@ -163,7 +163,7 @@ time_t __vsyscall(1) vtime(time_t *t)
 {
 	struct timeval tv;
 	time_t result;
-	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
+	if (!__vsyscall_gtod_data.sysctl_enabled)
 		return time_syscall(t);
 
 	vgettimeofday(&tv, 0);
diff -puN include/linux/compiler.h~profile-likely-unlikely-macros include/linux/compiler.h
--- a/include/linux/compiler.h~profile-likely-unlikely-macros
+++ a/include/linux/compiler.h
@@ -51,6 +51,40 @@ extern void __chk_io_ptr(const volatile 
 # include <linux/compiler-intel.h>
 #endif
 
+#if defined(CONFIG_PROFILE_LIKELY) && !(defined(CONFIG_MODULE_UNLOAD) && defined(MODULE))
+struct likeliness {
+	const char *func;
+	char *file;
+	int line;
+	int type;
+	unsigned int count[2];
+	struct likeliness *next;
+};
+
+extern int do_check_likely(struct likeliness *likeliness, int exp);
+
+#define LP_UNSEEN	4
+
+#define __check_likely(exp, is_likely)					\
+	({								\
+		static struct likeliness likeliness = {			\
+			.func = __func__,				\
+			.file = __FILE__,				\
+			.line = __LINE__,				\
+			.type = is_likely | LP_UNSEEN,			\
+		};							\
+		do_check_likely(&likeliness, !!(exp));			\
+	})
+
+/*
+ * We check for constant values with __builtin_constant_p() since
+ * it's not interesting to profile them, and there is a compiler
+ * bug in gcc 3.x which blows up during constant evalution when
+ * CONFIG_PROFILE_LIKELY is turned on.
+ */
+#define likely(x)	(__builtin_constant_p(x) ? (!!(x)) : __check_likely((x), 1))
+#define unlikely(x)	(__builtin_constant_p(x) ? (!!(x)) : __check_likely((x), 0))
+#else
 /*
  * Generic compiler-dependent macros required for kernel
  * build go below this comment. Actual compiler/compiler version
@@ -59,6 +93,7 @@ extern void __chk_io_ptr(const volatile 
 
 #define likely(x)	__builtin_expect(!!(x), 1)
 #define unlikely(x)	__builtin_expect(!!(x), 0)
+#endif
 
 /* Optimization barrier */
 #ifndef barrier
diff -puN lib/Kconfig.debug~profile-likely-unlikely-macros lib/Kconfig.debug
--- a/lib/Kconfig.debug~profile-likely-unlikely-macros
+++ a/lib/Kconfig.debug
@@ -430,6 +430,14 @@ config STACK_UNWIND
 	  This enables more precise stack traces, omitting all unrelated
 	  occurrences of pointers into kernel code from the dump.
 
+config	PROFILE_LIKELY
+	bool "Record return values from likely/unlikely macros"
+	default n
+	help
+	  Adds profiling on likely/unlikly macros . To see the
+	  results of the profiling you can view the following,
+		/proc/likely_prof
+
 config FORCED_INLINING
 	bool "Force gcc to inline functions marked 'inline'"
 	depends on DEBUG_KERNEL
diff -puN lib/Makefile~profile-likely-unlikely-macros lib/Makefile
--- a/lib/Makefile~profile-likely-unlikely-macros
+++ a/lib/Makefile
@@ -67,6 +67,8 @@ obj-$(CONFIG_FAULT_INJECTION) += fault-i
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
+obj-$(CONFIG_PROFILE_LIKELY) += likely_prof.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff -puN /dev/null lib/likely_prof.c
--- /dev/null
+++ a/lib/likely_prof.c
@@ -0,0 +1,146 @@
+/*
+ * This code should enable profiling the likely and unlikely macros.
+ *
+ * Output goes in /proc/likely_prof
+ *
+ * Authors:
+ * Daniel Walker <dwalker@mvista.com>
+ * Hua Zhong <hzhong@gmail.com>
+ * Andrew Morton <akpm@osdl.org>
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
+
+#include <asm/bug.h>
+#include <asm/atomic.h>
+
+static struct likeliness *likeliness_head;
+
+int do_check_likely(struct likeliness *likeliness, int ret)
+{
+	static unsigned long likely_lock;
+
+	if (ret)
+		likeliness->count[1]++;
+	else
+		likeliness->count[0]++;
+
+	if (likeliness->type & LP_UNSEEN) {
+		/*
+		 * We don't simple use a spinlock because internally to the
+		 * spinlock there is a call to unlikely which causes recursion.
+		 * We opted for this method because we didn't need a preempt/irq
+		 * disable and it was a bit cleaner then using internal __raw
+		 * spinlock calls.
+		 */
+		if (!test_and_set_bit(0, &likely_lock)) {
+			if (likeliness->type & LP_UNSEEN) {
+				likeliness->type &= (~LP_UNSEEN);
+				likeliness->next = likeliness_head;
+				likeliness_head = likeliness;
+			}
+			smp_mb__before_clear_bit();
+			clear_bit(0, &likely_lock);
+		}
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(do_check_likely);
+
+static void * lp_seq_start(struct seq_file *out, loff_t *pos)
+{
+
+	if (!*pos) {
+
+		seq_printf(out, "Likely Profiling Results\n");
+		seq_printf(out, " --------------------------------------------"
+				"------------------------\n");
+		seq_printf(out, "[+- ] Type | # True | # False | Function:"
+				"Filename@Line\n");
+
+		out->private = likeliness_head;
+	}
+
+	return out->private;
+}
+
+static void *lp_seq_next(struct seq_file *out, void *p, loff_t *pos)
+{
+	struct likeliness *entry = p;
+
+	if (entry->next) {
+		++(*pos);
+		out->private = entry->next;
+	} else
+		out->private = NULL;
+
+	return out->private;
+}
+
+static int lp_seq_show(struct seq_file *out, void *p)
+{
+	struct likeliness *entry = p;
+	unsigned int true = entry->count[1];
+	unsigned int false = entry->count[0];
+
+	if (!entry->type) {
+		if (true > false)
+			seq_printf(out, "+");
+		else
+			seq_printf(out, " ");
+
+		seq_printf(out, "unlikely ");
+	} else {
+		if (true < false)
+			seq_printf(out, "-");
+		else
+			seq_printf(out, " ");
+
+		seq_printf(out, "likely   ");
+	}
+
+	seq_printf(out, "|%9u|%9u\t%s()@:%s@%d\n", true, false,
+			entry->func, entry->file, entry->line);
+
+	return 0;
+}
+
+static void lp_seq_stop(struct seq_file *m, void *p)
+{
+}
+
+struct seq_operations likely_profiling_ops = {
+	.start  = lp_seq_start,
+	.next   = lp_seq_next,
+	.stop   = lp_seq_stop,
+	.show   = lp_seq_show
+};
+
+static int lp_results_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &likely_profiling_ops);
+}
+
+static struct file_operations proc_likely_operations  = {
+	.open           = lp_results_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
+static int __init init_likely(void)
+{
+	struct proc_dir_entry *entry;
+	entry = create_proc_entry("likely_prof", 0, &proc_root);
+	if (entry)
+		entry->proc_fops = &proc_likely_operations;
+
+	return 0;
+}
+__initcall(init_likely);
_

Patches currently in -mm which might be from dwalker@mvista.com are

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
