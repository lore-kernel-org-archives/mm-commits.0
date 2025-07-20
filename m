Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7636A1624C5
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977353; cv=none; b=tTf6xJFP4NZagP+jwV5GhwMP5fBe/7iUeRG7p2B9z1pEoCO0PLyoXV7yGn0Dko8LJW2CWgJ1oXVB4VpgNU1td53dK+LrVnyUFtft+vLzeqAqk0fEQUOdN7/0N5xjUG1ZgTsdN2kNuFH7g0oIFWQitJK8aVWpP7Fvpd15f2+HtHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977353; c=relaxed/simple;
	bh=IKN1adXLdG6wVk/EAEMlaOzfExUSmIwrQDbp6/og9X4=;
	h=Date:To:From:Subject:Message-Id; b=uAcT6PUWcUwwDqY7HYt5cNClpbjZygN5OCFeVRqCRqYWtsNamvY0/t5mMNnD8Y8FTIsAY8DabYUcYiHTCM1yLcGvZOyKdlWEXNOTW7WOhrtAnfbPAtxZ5XPRz7J2NaMkeodTLjx+AGRD0oNUxXyc7BYLG8ABl1G2uvXScj3ltlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gN4+czbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gN4+czbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A7DC4CEE3;
	Sun, 20 Jul 2025 02:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977353;
	bh=IKN1adXLdG6wVk/EAEMlaOzfExUSmIwrQDbp6/og9X4=;
	h=Date:To:From:Subject:From;
	b=gN4+czbn4r1PWgG/t45k6LhBODJicNLaiu2Xm1fJ8iVn3z9lDxyxVmqI7J0sFnHT2
	 cZDeL7BXUj5yhmaKFnEAQGvs1wEo9uRVUdY33ollPsZzNAMIChj79ph/AFf7Y3t+Yu
	 pGWOh5A6JPRf5KcSEMViCV+pzW9K58DfynDUg0RQ=
Date: Sat, 19 Jul 2025 19:09:12 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,nathan@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,andriy.shevchenko@linux.intel.com,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter.patch removed from -mm tree
Message-Id: <20250720020913.47A7DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: add 'panic_sys_info' sysctl to take human readable string parameter
has been removed from the -mm tree.  Its filename was
     panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: panic: add 'panic_sys_info' sysctl to take human readable string parameter
Date: Thu, 3 Jul 2025 10:10:02 +0800

Bitmap definition for 'panic_print' is hard to remember and decode.  Add
'panic_sys_info='sysctl to take human readable string like
"tasks,mem,timers,locks,ftrace,..." and translate it into bitmap.

The detailed mapping is:
	SYS_INFO_TASKS		"tasks"
	SYS_INFO_MEM		"mem"
	SYS_INFO_TIMERS		"timers"
	SYS_INFO_LOCKS		"locks"
	SYS_INFO_FTRACE		"ftrace"
	SYS_INFO_ALL_CPU_BT	"all_bt"
	SYS_INFO_BLOCKED_TASKS	"blocked_tasks"

[nathan@kernel.org: add __maybe_unused to sys_info_avail]
  Link: https://lkml.kernel.org/r/20250708-fix-clang-sys_info_avail-warning-v1-1-60d239eacd64@kernel.org
Link: https://lkml.kernel.org/r/20250703021004.42328-4-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |   18 +++
 include/linux/sys_info.h                    |    8 +
 kernel/panic.c                              |    7 +
 lib/sys_info.c                              |   90 ++++++++++++++++++
 4 files changed, 123 insertions(+)

--- a/Documentation/admin-guide/sysctl/kernel.rst~panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -899,6 +899,24 @@ So for example to print tasks and memory
   echo 3 > /proc/sys/kernel/panic_print
 
 
+panic_sys_info
+==============
+
+A comma separated list of extra information to be dumped on panic,
+for example, "tasks,mem,timers,...".  It is a human readable alternative
+to 'panic_print'. Possible values are:
+
+=============   ===================================================
+tasks           print all tasks info
+mem             print system memory info
+timer           print timers info
+lock            print locks info if CONFIG_LOCKDEP is on
+ftrace          print ftrace buffer
+all_bt          print all CPUs backtrace (if available in the arch)
+blocked_tasks   print only tasks in uninterruptible (blocked) state
+=============   ===================================================
+
+
 panic_on_rcu_stall
 ==================
 
--- a/include/linux/sys_info.h~panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter
+++ a/include/linux/sys_info.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_SYS_INFO_H
 #define _LINUX_SYS_INFO_H
 
+#include <linux/sysctl.h>
+
 /*
  * SYS_INFO_PANIC_CONSOLE_REPLAY is for panic case only, as it needs special
  * handling which only fits panic case.
@@ -16,5 +18,11 @@
 #define SYS_INFO_BLOCKED_TASKS		0x00000080
 
 void sys_info(unsigned long si_mask);
+unsigned long sys_info_parse_param(char *str);
 
+#ifdef CONFIG_SYSCTL
+int sysctl_sys_info_handler(const struct ctl_table *ro_table, int write,
+					  void *buffer, size_t *lenp,
+					  loff_t *ppos);
+#endif
 #endif	/* _LINUX_SYS_INFO_H */
--- a/kernel/panic.c~panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter
+++ a/kernel/panic.c
@@ -126,6 +126,13 @@ static const struct ctl_table kern_panic
 		.mode           = 0644,
 		.proc_handler   = proc_douintvec,
 	},
+	{
+		.procname	= "panic_sys_info",
+		.data		= &panic_print,
+		.maxlen         = sizeof(panic_print),
+		.mode		= 0644,
+		.proc_handler	= sysctl_sys_info_handler,
+	},
 };
 
 static __init int kernel_panic_sysctls_init(void)
--- a/lib/sys_info.c~panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter
+++ a/lib/sys_info.c
@@ -3,10 +3,100 @@
 #include <linux/console.h>
 #include <linux/kernel.h>
 #include <linux/ftrace.h>
+#include <linux/sysctl.h>
 #include <linux/nmi.h>
 
 #include <linux/sys_info.h>
 
+struct sys_info_name {
+	unsigned long bit;
+	const char *name;
+};
+
+/*
+ * When 'si_names' gets updated,  please make sure the 'sys_info_avail'
+ * below is updated accordingly.
+ */
+static const struct sys_info_name  si_names[] = {
+	{ SYS_INFO_TASKS,		"tasks" },
+	{ SYS_INFO_MEM,			"mem" },
+	{ SYS_INFO_TIMERS,		"timers" },
+	{ SYS_INFO_LOCKS,		"locks" },
+	{ SYS_INFO_FTRACE,		"ftrace" },
+	{ SYS_INFO_ALL_CPU_BT,		"all_bt" },
+	{ SYS_INFO_BLOCKED_TASKS,	"blocked_tasks" },
+};
+
+/* Expecting string like "xxx_sys_info=tasks,mem,timers,locks,ftrace,..." */
+unsigned long sys_info_parse_param(char *str)
+{
+	unsigned long si_bits = 0;
+	char *s, *name;
+	int i;
+
+	s = str;
+	while ((name = strsep(&s, ",")) && *name) {
+		for (i = 0; i < ARRAY_SIZE(si_names); i++) {
+			if (!strcmp(name, si_names[i].name)) {
+				si_bits |= si_names[i].bit;
+				break;
+			}
+		}
+	}
+
+	return si_bits;
+}
+
+#ifdef CONFIG_SYSCTL
+
+static const char sys_info_avail[] __maybe_unused = "tasks,mem,timers,locks,ftrace,all_bt,blocked_tasks";
+
+int sysctl_sys_info_handler(const struct ctl_table *ro_table, int write,
+					  void *buffer, size_t *lenp,
+					  loff_t *ppos)
+{
+	char names[sizeof(sys_info_avail) + 1];
+	struct ctl_table table;
+	unsigned long *si_bits_global;
+
+	si_bits_global = ro_table->data;
+
+	if (write) {
+		unsigned long si_bits;
+		int ret;
+
+		table = *ro_table;
+		table.data = names;
+		table.maxlen = sizeof(names);
+		ret = proc_dostring(&table, write, buffer, lenp, ppos);
+		if (ret)
+			return ret;
+
+		si_bits = sys_info_parse_param(names);
+		/* The access to the global value is not synchronized. */
+		WRITE_ONCE(*si_bits_global, si_bits);
+		return 0;
+	} else {
+		/* for 'read' operation */
+		char *delim = "";
+		int i, len = 0;
+
+		for (i = 0; i < ARRAY_SIZE(si_names); i++) {
+			if (*si_bits_global & si_names[i].bit) {
+				len += scnprintf(names + len, sizeof(names) - len,
+					"%s%s", delim, si_names[i].name);
+				delim = ",";
+			}
+		}
+
+		table = *ro_table;
+		table.data = names;
+		table.maxlen = sizeof(names);
+		return proc_dostring(&table, write, buffer, lenp, ppos);
+	}
+}
+#endif
+
 void sys_info(unsigned long si_mask)
 {
 	if (si_mask & SYS_INFO_TASKS)
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are


