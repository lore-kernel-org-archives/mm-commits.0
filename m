Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F30C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 06:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 457FB61181
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 06:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhDIGYe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 02:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233296AbhDIGYd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 02:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3223461178;
        Fri,  9 Apr 2021 06:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617949461;
        bh=Sb6n+hzZ4Y0DWgb94bHCLP7SZgps2mtFhrzawFg+eP8=;
        h=Date:From:To:Subject:From;
        b=fPMXTYiRLB9d2Y3YYTNOSlG4Q9n4DO/8i4daXlnTRY9OrqqfdxQM8+XxlxhOZOBBi
         +adUOsheXF9E7wfGttfhig+Mf7yG361/7QQjkLGQBOzg9tM9xjP0nK/3+fPmhhys69
         AtZF4uA5U/dquoYcS7UQ/G7FnVdQhLR1oWz3Z5KQ=
Date:   Thu, 08 Apr 2021 23:24:19 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, arnd@arndb.de,
        benh@kernel.crashing.org, bjorn.andersson@linaro.org, bp@alien8.de,
        christian.brauner@ubuntu.com, cminyard@mvista.com,
        ebiederm@xmission.com, haiyangz@microsoft.com, hpa@zytor.com,
        jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, jroedel@suse.de, keescook@chromium.org,
        kys@microsoft.com, mathieu.desnoyers@efficios.com,
        mathieu.poirier@linaro.org, mcgrof@kernel.org,
        mikelley@microsoft.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, ohad@wizery.com,
        paulmck@kernel.org, paulus@samba.org,
        penguin-kernel@i-love.sakura.ne.jp, rostedt@goodmis.org,
        rppt@linux.ibm.com, sthemmin@microsoft.com, tglx@linutronix.de,
        vbabka@suse.cz, wei.liu@kernel.org, yzaikin@google.com
Subject:  [failures] kernelh-split-out-panic-and-oops-helpers.patch
 removed from -mm tree
Message-ID: <20210409062419.qzaaFckdp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: split out panic and oops helpers
has been removed from the -mm tree.  Its filename was
     kernelh-split-out-panic-and-oops-helpers.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kernel.h: split out panic and oops helpers

kernel.h is being used as a dump for all kinds of stuff for a long time. 
Here is the attempt to start cleaning it up by splitting out panic and
oops helpers.

At the same time convert users in header and lib folder to use new header.
Though for time being include new header back to kernel.h to avoid
twisted indirected includes for existing users.

Link: https://lkml.kernel.org/r/20210406133158.73700-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Corey Minyard <cminyard@mvista.com>		[ipmi]
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Wei Liu <wei.liu@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup-common.c   |    1 
 arch/x86/include/asm/desc.h          |    1 
 arch/x86/kernel/cpu/mshyperv.c       |    1 
 arch/x86/kernel/setup.c              |    1 
 drivers/char/ipmi/ipmi_msghandler.c  |    1 
 drivers/remoteproc/remoteproc_core.c |    1 
 include/asm-generic/bug.h            |    3 
 include/linux/kernel.h               |   84 ---------------------
 include/linux/panic.h                |   98 +++++++++++++++++++++++++
 include/linux/panic_notifier.h       |   12 +++
 kernel/hung_task.c                   |    1 
 kernel/kexec_core.c                  |    1 
 kernel/panic.c                       |    1 
 kernel/rcu/tree.c                    |    2 
 kernel/sysctl.c                      |    1 
 kernel/trace/trace.c                 |    1 
 16 files changed, 126 insertions(+), 84 deletions(-)

--- a/arch/powerpc/kernel/setup-common.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/powerpc/kernel/setup-common.c
@@ -9,6 +9,7 @@
 #undef DEBUG
 
 #include <linux/export.h>
+#include <linux/panic_notifier.h>
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/init.h>
--- a/arch/x86/include/asm/desc.h~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/x86/include/asm/desc.h
@@ -9,6 +9,7 @@
 #include <asm/irq_vectors.h>
 #include <asm/cpu_entry_area.h>
 
+#include <linux/debug_locks.h>
 #include <linux/smp.h>
 #include <linux/percpu.h>
 
--- a/arch/x86/kernel/cpu/mshyperv.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/x86/kernel/cpu/mshyperv.c
@@ -17,6 +17,7 @@
 #include <linux/irq.h>
 #include <linux/kexec.h>
 #include <linux/i8253.h>
+#include <linux/panic_notifier.h>
 #include <linux/random.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
--- a/arch/x86/kernel/setup.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/x86/kernel/setup.c
@@ -14,6 +14,7 @@
 #include <linux/initrd.h>
 #include <linux/iscsi_ibft.h>
 #include <linux/memblock.h>
+#include <linux/panic_notifier.h>
 #include <linux/pci.h>
 #include <linux/root_dev.h>
 #include <linux/hugetlb.h>
--- a/drivers/char/ipmi/ipmi_msghandler.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -16,6 +16,7 @@
 
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/panic_notifier.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
--- a/drivers/remoteproc/remoteproc_core.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/remoteproc/remoteproc_core.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/panic_notifier.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/dma-map-ops.h>
--- a/include/asm-generic/bug.h~kernelh-split-out-panic-and-oops-helpers
+++ a/include/asm-generic/bug.h
@@ -17,7 +17,8 @@
 #endif
 
 #ifndef __ASSEMBLY__
-#include <linux/kernel.h>
+#include <linux/panic.h>
+#include <linux/printk.h>
 
 #ifdef CONFIG_BUG
 
--- a/include/linux/kernel.h~kernelh-split-out-panic-and-oops-helpers
+++ a/include/linux/kernel.h
@@ -14,6 +14,7 @@
 #include <linux/math.h>
 #include <linux/minmax.h>
 #include <linux/typecheck.h>
+#include <linux/panic.h>
 #include <linux/printk.h>
 #include <linux/build_bug.h>
 #include <linux/static_call_types.h>
@@ -70,7 +71,6 @@
 #define lower_32_bits(n) ((u32)((n) & 0xffffffff))
 
 struct completion;
-struct pt_regs;
 struct user;
 
 #ifdef CONFIG_PREEMPT_VOLUNTARY
@@ -175,14 +175,6 @@ void __might_fault(const char *file, int
 static inline void might_fault(void) { }
 #endif
 
-extern struct atomic_notifier_head panic_notifier_list;
-extern long (*panic_blink)(int state);
-__printf(1, 2)
-void panic(const char *fmt, ...) __noreturn __cold;
-void nmi_panic(struct pt_regs *regs, const char *msg);
-extern void oops_enter(void);
-extern void oops_exit(void);
-extern bool oops_may_print(void);
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
 
@@ -368,52 +360,8 @@ extern int __kernel_text_address(unsigne
 extern int kernel_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
 
-#ifdef CONFIG_SMP
-extern unsigned int sysctl_oops_all_cpu_backtrace;
-#else
-#define sysctl_oops_all_cpu_backtrace 0
-#endif /* CONFIG_SMP */
-
 extern void bust_spinlocks(int yes);
-extern int panic_timeout;
-extern unsigned long panic_print;
-extern int panic_on_oops;
-extern int panic_on_unrecovered_nmi;
-extern int panic_on_io_nmi;
-extern int panic_on_warn;
-extern unsigned long panic_on_taint;
-extern bool panic_on_taint_nousertaint;
-extern int sysctl_panic_on_rcu_stall;
-extern int sysctl_max_rcu_stall_to_panic;
-extern int sysctl_panic_on_stackoverflow;
-
-extern bool crash_kexec_post_notifiers;
-
-/*
- * panic_cpu is used for synchronizing panic() and crash_kexec() execution. It
- * holds a CPU number which is executing panic() currently. A value of
- * PANIC_CPU_INVALID means no CPU has entered panic() or crash_kexec().
- */
-extern atomic_t panic_cpu;
-#define PANIC_CPU_INVALID	-1
 
-/*
- * Only to be used by arch init code. If the user over-wrote the default
- * CONFIG_PANIC_TIMEOUT, honor it.
- */
-static inline void set_arch_panic_timeout(int timeout, int arch_default_timeout)
-{
-	if (panic_timeout == arch_default_timeout)
-		panic_timeout = timeout;
-}
-extern const char *print_tainted(void);
-enum lockdep_ok {
-	LOCKDEP_STILL_OK,
-	LOCKDEP_NOW_UNRELIABLE
-};
-extern void add_taint(unsigned flag, enum lockdep_ok);
-extern int test_taint(unsigned flag);
-extern unsigned long get_taint(void);
 extern int root_mountflags;
 
 extern bool early_boot_irqs_disabled;
@@ -432,36 +380,6 @@ extern enum system_states {
 	SYSTEM_SUSPEND,
 } system_state;
 
-/* This cannot be an enum because some may be used in assembly source. */
-#define TAINT_PROPRIETARY_MODULE	0
-#define TAINT_FORCED_MODULE		1
-#define TAINT_CPU_OUT_OF_SPEC		2
-#define TAINT_FORCED_RMMOD		3
-#define TAINT_MACHINE_CHECK		4
-#define TAINT_BAD_PAGE			5
-#define TAINT_USER			6
-#define TAINT_DIE			7
-#define TAINT_OVERRIDDEN_ACPI_TABLE	8
-#define TAINT_WARN			9
-#define TAINT_CRAP			10
-#define TAINT_FIRMWARE_WORKAROUND	11
-#define TAINT_OOT_MODULE		12
-#define TAINT_UNSIGNED_MODULE		13
-#define TAINT_SOFTLOCKUP		14
-#define TAINT_LIVEPATCH			15
-#define TAINT_AUX			16
-#define TAINT_RANDSTRUCT		17
-#define TAINT_FLAGS_COUNT		18
-#define TAINT_FLAGS_MAX			((1UL << TAINT_FLAGS_COUNT) - 1)
-
-struct taint_flag {
-	char c_true;	/* character printed when tainted */
-	char c_false;	/* character printed when not tainted */
-	bool module;	/* also show as a per-module taint flag */
-};
-
-extern const struct taint_flag taint_flags[TAINT_FLAGS_COUNT];
-
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
 #define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
--- /dev/null
+++ a/include/linux/panic.h
@@ -0,0 +1,98 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PANIC_H
+#define _LINUX_PANIC_H
+
+#include <linux/compiler_attributes.h>
+#include <linux/types.h>
+
+struct pt_regs;
+
+extern long (*panic_blink)(int state);
+__printf(1, 2)
+void panic(const char *fmt, ...) __noreturn __cold;
+void nmi_panic(struct pt_regs *regs, const char *msg);
+extern void oops_enter(void);
+extern void oops_exit(void);
+extern bool oops_may_print(void);
+
+#ifdef CONFIG_SMP
+extern unsigned int sysctl_oops_all_cpu_backtrace;
+#else
+#define sysctl_oops_all_cpu_backtrace 0
+#endif /* CONFIG_SMP */
+
+extern int panic_timeout;
+extern unsigned long panic_print;
+extern int panic_on_oops;
+extern int panic_on_unrecovered_nmi;
+extern int panic_on_io_nmi;
+extern int panic_on_warn;
+
+extern unsigned long panic_on_taint;
+extern bool panic_on_taint_nousertaint;
+
+extern int sysctl_panic_on_rcu_stall;
+extern int sysctl_max_rcu_stall_to_panic;
+extern int sysctl_panic_on_stackoverflow;
+
+extern bool crash_kexec_post_notifiers;
+
+/*
+ * panic_cpu is used for synchronizing panic() and crash_kexec() execution. It
+ * holds a CPU number which is executing panic() currently. A value of
+ * PANIC_CPU_INVALID means no CPU has entered panic() or crash_kexec().
+ */
+extern atomic_t panic_cpu;
+#define PANIC_CPU_INVALID	-1
+
+/*
+ * Only to be used by arch init code. If the user over-wrote the default
+ * CONFIG_PANIC_TIMEOUT, honor it.
+ */
+static inline void set_arch_panic_timeout(int timeout, int arch_default_timeout)
+{
+	if (panic_timeout == arch_default_timeout)
+		panic_timeout = timeout;
+}
+
+/* This cannot be an enum because some may be used in assembly source. */
+#define TAINT_PROPRIETARY_MODULE	0
+#define TAINT_FORCED_MODULE		1
+#define TAINT_CPU_OUT_OF_SPEC		2
+#define TAINT_FORCED_RMMOD		3
+#define TAINT_MACHINE_CHECK		4
+#define TAINT_BAD_PAGE			5
+#define TAINT_USER			6
+#define TAINT_DIE			7
+#define TAINT_OVERRIDDEN_ACPI_TABLE	8
+#define TAINT_WARN			9
+#define TAINT_CRAP			10
+#define TAINT_FIRMWARE_WORKAROUND	11
+#define TAINT_OOT_MODULE		12
+#define TAINT_UNSIGNED_MODULE		13
+#define TAINT_SOFTLOCKUP		14
+#define TAINT_LIVEPATCH			15
+#define TAINT_AUX			16
+#define TAINT_RANDSTRUCT		17
+#define TAINT_FLAGS_COUNT		18
+#define TAINT_FLAGS_MAX			((1UL << TAINT_FLAGS_COUNT) - 1)
+
+struct taint_flag {
+	char c_true;	/* character printed when tainted */
+	char c_false;	/* character printed when not tainted */
+	bool module;	/* also show as a per-module taint flag */
+};
+
+extern const struct taint_flag taint_flags[TAINT_FLAGS_COUNT];
+
+enum lockdep_ok {
+	LOCKDEP_STILL_OK,
+	LOCKDEP_NOW_UNRELIABLE,
+};
+
+extern const char *print_tainted(void);
+extern void add_taint(unsigned flag, enum lockdep_ok);
+extern int test_taint(unsigned flag);
+extern unsigned long get_taint(void);
+
+#endif	/* _LINUX_PANIC_H */
--- /dev/null
+++ a/include/linux/panic_notifier.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PANIC_NOTIFIERS_H
+#define _LINUX_PANIC_NOTIFIERS_H
+
+#include <linux/notifier.h>
+#include <linux/types.h>
+
+extern struct atomic_notifier_head panic_notifier_list;
+
+extern bool crash_kexec_post_notifiers;
+
+#endif	/* _LINUX_PANIC_NOTIFIERS_H */
--- a/kernel/hung_task.c~kernelh-split-out-panic-and-oops-helpers
+++ a/kernel/hung_task.c
@@ -15,6 +15,7 @@
 #include <linux/kthread.h>
 #include <linux/lockdep.h>
 #include <linux/export.h>
+#include <linux/panic_notifier.h>
 #include <linux/sysctl.h>
 #include <linux/suspend.h>
 #include <linux/utsname.h>
--- a/kernel/kexec_core.c~kernelh-split-out-panic-and-oops-helpers
+++ a/kernel/kexec_core.c
@@ -26,6 +26,7 @@
 #include <linux/suspend.h>
 #include <linux/device.h>
 #include <linux/freezer.h>
+#include <linux/panic_notifier.h>
 #include <linux/pm.h>
 #include <linux/cpu.h>
 #include <linux/uaccess.h>
--- a/kernel/panic.c~kernelh-split-out-panic-and-oops-helpers
+++ a/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/kexec.h>
+#include <linux/panic_notifier.h>
 #include <linux/sched.h>
 #include <linux/sysrq.h>
 #include <linux/init.h>
--- a/kernel/rcu/tree.c~kernelh-split-out-panic-and-oops-helpers
+++ a/kernel/rcu/tree.c
@@ -32,6 +32,8 @@
 #include <linux/export.h>
 #include <linux/completion.h>
 #include <linux/moduleparam.h>
+#include <linux/panic.h>
+#include <linux/panic_notifier.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
--- a/kernel/sysctl.c~kernelh-split-out-panic-and-oops-helpers
+++ a/kernel/sysctl.c
@@ -27,6 +27,7 @@
 #include <linux/sysctl.h>
 #include <linux/bitmap.h>
 #include <linux/signal.h>
+#include <linux/panic.h>
 #include <linux/printk.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
--- a/kernel/trace/trace.c~kernelh-split-out-panic-and-oops-helpers
+++ a/kernel/trace/trace.c
@@ -39,6 +39,7 @@
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
+#include <linux/panic_notifier.h>
 #include <linux/poll.h>
 #include <linux/nmi.h>
 #include <linux/fs.h>
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-drop-inclusion-in-bitmaph.patch

