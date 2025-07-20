Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8931A41AAC
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977352; cv=none; b=DU0vyoupwApF0RIoXTxOtEjjzukSFnjgSGuKqd6/OeDjA+eZXOybXuD+BDwFyqkYN2cDes9seokzY/5yGWTCSXSdt036b+ptcDDeYPt+5PIGC99VH95llbSpAMmXRloYxo+Q+bq1eHVT4zYlgMYlpOsX0ORb6JnS6ou23XHASEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977352; c=relaxed/simple;
	bh=xpoMRWjVJqwi6z4geKR4NjBSk+BJoRYDErpVoPs6LBI=;
	h=Date:To:From:Subject:Message-Id; b=dNsBr0OIe1+lMylYLR9Hkfht8/YlmMTtb8jF+NixU6Se+W3hG1Jao9FEbERh0kH6iDrF9JcllYVHm+yJ8AowvWMtXSoiJ7du4dC2BiK1DbQW2tc7LbrHsNnuTJs6SByTlDjIwLDOr6AWfD0HhoEsZ9LrU/9neasVvwsE9Js4P/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xZpFwPsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xZpFwPsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B712C4CEE3;
	Sun, 20 Jul 2025 02:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977352;
	bh=xpoMRWjVJqwi6z4geKR4NjBSk+BJoRYDErpVoPs6LBI=;
	h=Date:To:From:Subject:From;
	b=xZpFwPsJ9Rt0ZtRoHDySZbjEyomvkQTwN3LkjRSB/HAEDfF9CAmVuH0UCZDw0FEeU
	 uKueDVI7TOCtk/ipHj4hwnPAAQStr2geqMm4+n83OPBa8oH32ha8frRexS04/m6uNz
	 YT+pAz30ooCKizAX1MbbDEyRxpt6+3Pd60WTzV8Q=
Date: Sat, 19 Jul 2025 19:09:11 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,nathan@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-generalize-panic_prints-function-to-show-sys-info.patch removed from -mm tree
Message-Id: <20250720020912.1B712C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: generalize panic_print's function to show sys info
has been removed from the -mm tree.  Its filename was
     panic-generalize-panic_prints-function-to-show-sys-info.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Nathan Chancellor <nathan@kernel.org>
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


