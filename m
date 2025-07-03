Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075B42BF011
	for <mm-commits@vger.kernel.org>; Thu,  3 Jul 2025 22:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751582500; cv=none; b=MVAVAnRMpYSltZZjJ7T1WH57C0EZMIkMbWoCmBF9zt9jBer0Ht4mmzV0FbMCcSO0SncT2B/6nZmBYX2Gfeli2ftKyEEXNKC5fR5C78aIgX9nPKgULTvi+CwAuJ4JBDzZ9GGFDsAn7qC3qbLie3ghhGGvkFVxXlbJ2vkNONhiP1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751582500; c=relaxed/simple;
	bh=1WmTLViqa5OwH5uYa7CNqVcyZ35t1KLBmJLJwpsb+U4=;
	h=Date:To:From:Subject:Message-Id; b=CndJ4Pkngi/82621nWPu38t73CCApc8b9tIXEj22qqgAzZb0v4XRQvarfCsu3ulwoI95b6O9CJOVQ4e7cngyxlx6hS/cOGghcrfbzdVGH97uOnvh2rJxmjZ+Vjpc4JZITrdCKY3GWZ18zjLc2Y9SUYsugt52outRKTNX2v5Eqio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OxavC6uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OxavC6uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69274C4CEED;
	Thu,  3 Jul 2025 22:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751582498;
	bh=1WmTLViqa5OwH5uYa7CNqVcyZ35t1KLBmJLJwpsb+U4=;
	h=Date:To:From:Subject:From;
	b=OxavC6uyb/eW6iY9gJq4Z3YNaYWSh4h+kzPNVtd43XqrFWrrJJ8Y6Tmyly8Mq0MUu
	 iks/gIEUKbm/jN+QEMzP5ZuDE2T6Q1FUPSnjYN7MFPXK4BPhl7IiJ/iFMJOvAW0Di7
	 Et/Ji610F2KQXqIb9VF0u653UNgFeuFzikGObVhg=
Date: Thu, 03 Jul 2025 15:41:37 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter.patch added to mm-nonmm-unstable branch
Message-Id: <20250703224138.69274C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: add 'panic_sys_info' sysctl to take human readable string parameter
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter.patch

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

Link: https://lkml.kernel.org/r/20250703021004.42328-4-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
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
+static const char sys_info_avail[] = "tasks,mem,timers,locks,ftrace,all_bt,blocked_tasks";
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

panic-clean-up-code-for-console-replay.patch
panic-generalize-panic_prints-function-to-show-sys-info.patch
panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter.patch
panic-add-panic_sys_info=-setup-option-for-kernel-cmdline.patch
panic-add-note-that-panic_print-sysctl-interface-is-deprecated.patch

