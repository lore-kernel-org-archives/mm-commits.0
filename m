Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6BB1FDA89
	for <mm-commits@vger.kernel.org>; Thu,  3 Jul 2025 22:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751582498; cv=none; b=YOy6lD/AAR1og+XMFTLgiIsGBV4vb2RPtNVN60LmtLqgp89cCc+V7zFroyI8FTaivlf8hSbeXc4nUAXjb00ynO+BOuRAwu9fxGW7Sfh9menEcc6H1KQ86USJLSBSPiM/X2GpwJjpDkukqAjKyaLP9iibcjuBQGGCzHbIXmuOdeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751582498; c=relaxed/simple;
	bh=sXsxMD/2H5j2HRV8bLfMtDCnmgrCAEZ0JN/OVtiy63Q=;
	h=Date:To:From:Subject:Message-Id; b=GzBk0nILYZM4HoNXoh6sg406H0/UNBwY+aFAEgcedONC62HknelawMTG6a7UoxndQC0INE+KOYlZmW+IFhYJSbYPGT3VNeLZxR/BG3xR1T0xrD4tCYegtV34KcgRwhhCHtyKY59g+ZFtUETWlMM+n9BYP8qWBe4gQ3xQ/N0Clis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G4QIOSOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G4QIOSOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6C1C4CEE3;
	Thu,  3 Jul 2025 22:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751582496;
	bh=sXsxMD/2H5j2HRV8bLfMtDCnmgrCAEZ0JN/OVtiy63Q=;
	h=Date:To:From:Subject:From;
	b=G4QIOSOheJk2L8A1KdlYR3xV/lqIlFAL8spaAVZOz3jhfuExOXyfm7InfFj26UmyV
	 7+X5300D2fG9BB/Gs6R8LLFGGVinpzrjb6hA3it5DWrUVsTGdPJu1h/KGU20Gw+be/
	 4crjvRsbzSePj9ZZD4XxsT6M9x6UNvlyoAmSe2Pw=
Date: Thu, 03 Jul 2025 15:41:36 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-generalize-panic_prints-function-to-show-sys-info.patch added to mm-nonmm-unstable branch
Message-Id: <20250703224136.AC6C1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: generalize panic_print's function to show sys info
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-generalize-panic_prints-function-to-show-sys-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-generalize-panic_prints-function-to-show-sys-info.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: panic: generalize panic_print's function to show sys info
Date: Thu, 3 Jul 2025 10:10:01 +0800

'panic_print' was introduced to help debugging kernel panic by dumping
different kinds of system information like tasks' call stack, memory,
ftrace buffer, etc.  Actually this function could also be used to help
debugging other cases like task-hung, soft/hard lockup, etc.  where user
may need the snapshot of system info at that time.

Extract system info dump function related code from panic.c to separate
file sys_info.[ch], for wider usage by other kernel parts for debugging.

Also modify the macro names about singulars/plurals.

Link: https://lkml.kernel.org/r/20250703021004.42328-3-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sys_info.h |   20 ++++++++++++++++++++
 kernel/panic.c           |   36 ++++--------------------------------
 lib/Makefile             |    2 +-
 lib/sys_info.c           |   32 ++++++++++++++++++++++++++++++++
 4 files changed, 57 insertions(+), 33 deletions(-)

diff --git a/include/linux/sys_info.h a/include/linux/sys_info.h
new file mode 100644
--- /dev/null
+++ a/include/linux/sys_info.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SYS_INFO_H
+#define _LINUX_SYS_INFO_H
+
+/*
+ * SYS_INFO_PANIC_CONSOLE_REPLAY is for panic case only, as it needs special
+ * handling which only fits panic case.
+ */
+#define SYS_INFO_TASKS			0x00000001
+#define SYS_INFO_MEM			0x00000002
+#define SYS_INFO_TIMERS			0x00000004
+#define SYS_INFO_LOCKS			0x00000008
+#define SYS_INFO_FTRACE			0x00000010
+#define SYS_INFO_PANIC_CONSOLE_REPLAY	0x00000020
+#define SYS_INFO_ALL_CPU_BT		0x00000040
+#define SYS_INFO_BLOCKED_TASKS		0x00000080
+
+void sys_info(unsigned long si_mask);
+
+#endif	/* _LINUX_SYS_INFO_H */
--- a/kernel/panic.c~panic-generalize-panic_prints-function-to-show-sys-info
+++ a/kernel/panic.c
@@ -36,6 +36,7 @@
 #include <linux/sysfs.h>
 #include <linux/context_tracking.h>
 #include <linux/seq_buf.h>
+#include <linux/sys_info.h>
 #include <trace/events/error_report.h>
 #include <asm/sections.h>
 
@@ -69,14 +70,6 @@ bool panic_triggering_all_cpu_backtrace;
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
 
-#define PANIC_PRINT_TASK_INFO		0x00000001
-#define PANIC_PRINT_MEM_INFO		0x00000002
-#define PANIC_PRINT_TIMER_INFO		0x00000004
-#define PANIC_PRINT_LOCK_INFO		0x00000008
-#define PANIC_PRINT_FTRACE_INFO		0x00000010
-#define PANIC_CONSOLE_REPLAY		0x00000020
-#define PANIC_PRINT_ALL_CPU_BT		0x00000040
-#define PANIC_PRINT_BLOCKED_TASKS	0x00000080
 unsigned long panic_print;
 
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
@@ -240,31 +233,10 @@ EXPORT_SYMBOL(nmi_panic);
 
 static void panic_console_replay(void)
 {
-	if (panic_print & PANIC_CONSOLE_REPLAY)
+	if (panic_print & SYS_INFO_PANIC_CONSOLE_REPLAY)
 		console_flush_on_panic(CONSOLE_REPLAY_ALL);
 }
 
-static void panic_print_sys_info(void)
-{
-	if (panic_print & PANIC_PRINT_TASK_INFO)
-		show_state();
-
-	if (panic_print & PANIC_PRINT_MEM_INFO)
-		show_mem();
-
-	if (panic_print & PANIC_PRINT_TIMER_INFO)
-		sysrq_timer_list_show();
-
-	if (panic_print & PANIC_PRINT_LOCK_INFO)
-		debug_show_all_locks();
-
-	if (panic_print & PANIC_PRINT_FTRACE_INFO)
-		ftrace_dump(DUMP_ALL);
-
-	if (panic_print & PANIC_PRINT_BLOCKED_TASKS)
-		show_state_filter(TASK_UNINTERRUPTIBLE);
-}
-
 void check_panic_on_warn(const char *origin)
 {
 	unsigned int limit;
@@ -285,7 +257,7 @@ void check_panic_on_warn(const char *ori
  */
 static void panic_other_cpus_shutdown(bool crash_kexec)
 {
-	if (panic_print & PANIC_PRINT_ALL_CPU_BT) {
+	if (panic_print & SYS_INFO_ALL_CPU_BT) {
 		/* Temporary allow non-panic CPUs to write their backtraces. */
 		panic_triggering_all_cpu_backtrace = true;
 		trigger_all_cpu_backtrace();
@@ -410,7 +382,7 @@ void panic(const char *fmt, ...)
 	 */
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
-	panic_print_sys_info();
+	sys_info(panic_print);
 
 	kmsg_dump_desc(KMSG_DUMP_PANIC, buf);
 
--- a/lib/Makefile~panic-generalize-panic_prints-function-to-show-sys-info
+++ a/lib/Makefile
@@ -40,7 +40,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
 	 nmi_backtrace.o win_minmax.o memcat_p.o \
-	 buildid.o objpool.o iomem_copy.o
+	 buildid.o objpool.o iomem_copy.o sys_info.o
 
 lib-$(CONFIG_UNION_FIND) += union_find.o
 lib-$(CONFIG_PRINTK) += dump_stack.o
diff --git a/lib/sys_info.c a/lib/sys_info.c
new file mode 100644
--- /dev/null
+++ a/lib/sys_info.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/sched/debug.h>
+#include <linux/console.h>
+#include <linux/kernel.h>
+#include <linux/ftrace.h>
+#include <linux/nmi.h>
+
+#include <linux/sys_info.h>
+
+void sys_info(unsigned long si_mask)
+{
+	if (si_mask & SYS_INFO_TASKS)
+		show_state();
+
+	if (si_mask & SYS_INFO_MEM)
+		show_mem();
+
+	if (si_mask & SYS_INFO_TIMERS)
+		sysrq_timer_list_show();
+
+	if (si_mask & SYS_INFO_LOCKS)
+		debug_show_all_locks();
+
+	if (si_mask & SYS_INFO_FTRACE)
+		ftrace_dump(DUMP_ALL);
+
+	if (si_mask & SYS_INFO_ALL_CPU_BT)
+		trigger_all_cpu_backtrace();
+
+	if (si_mask & SYS_INFO_BLOCKED_TASKS)
+		show_state_filter(TASK_UNINTERRUPTIBLE);
+}
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

panic-clean-up-code-for-console-replay.patch
panic-generalize-panic_prints-function-to-show-sys-info.patch
panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter.patch
panic-add-panic_sys_info=-setup-option-for-kernel-cmdline.patch
panic-add-note-that-panic_print-sysctl-interface-is-deprecated.patch

