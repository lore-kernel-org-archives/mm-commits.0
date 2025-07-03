Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D9F2BF011
	for <mm-commits@vger.kernel.org>; Thu,  3 Jul 2025 22:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751582502; cv=none; b=M2UIkHS6BKYsuzn9qzVKHTGumVvYrr17DPqJDN6/4ZZPM/9Ebd8BAJbXTeheSuyAf3+OBvYsgbaYR11IZSfHD2TxLX7hYX5u4nkY/Fa0xQ+Te47MFY0IoqyLlK4nyKfE4L+2nmIgGiuyZfeVxoFqrJacPF7H8nWfj0TL1/Xc79Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751582502; c=relaxed/simple;
	bh=yctivoqnRxfYwR9RVYamq6KWHQErlcHCJvYvXjlv5Ng=;
	h=Date:To:From:Subject:Message-Id; b=k0sATUGlgJezyQMKN1lMrslitTzGDsfyGRz/ALGtz7ikWa9XXRKAe68r8gOS3Pm1uPvI/NqPnFivYBZ01F/a2apSKeUlHPsI+5NmuywGZJDsQk6YUX7Viwt/1CnDewb6/ENAyNFKvEyXDpYcYzBCxwDVBz7u/4+IRMA4RalJiBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UER7o36R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UER7o36R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9A6C4CEED;
	Thu,  3 Jul 2025 22:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751582501;
	bh=yctivoqnRxfYwR9RVYamq6KWHQErlcHCJvYvXjlv5Ng=;
	h=Date:To:From:Subject:From;
	b=UER7o36RaoCzHIl/bP1wgurdacOGmiSRmveod9uwAcL41M0WYNH63mN9YYcdguAUE
	 KOHDrgFNtTXvotQ8/jxivBBfH1f+OMhxjVgdq0sd1qAc7Y8sHCeA3Crhz5xzjl6DL9
	 3Tshy9t2P9HQ69UR8RjyNexGuM2rBHlUwKRWMB7s=
Date: Thu, 03 Jul 2025 15:41:40 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-note-that-panic_print-sysctl-interface-is-deprecated.patch added to mm-nonmm-unstable branch
Message-Id: <20250703224141.8F9A6C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: add note that panic_print sysctl interface is deprecated
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-add-note-that-panic_print-sysctl-interface-is-deprecated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-add-note-that-panic_print-sysctl-interface-is-deprecated.patch

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
Subject: panic: add note that panic_print sysctl interface is deprecated
Date: Thu, 3 Jul 2025 10:10:04 +0800

Add a dedicated core parameter 'panic_console_replay' for controlling
console replay, and add note that 'panic_print' sysctl interface will be
obsoleted by 'panic_sys_info' and 'panic_console_replay'.  When it
happens, the SYS_INFO_PANIC_CONSOLE_REPLAY can be removed as well.

Link: https://lkml.kernel.org/r/20250703021004.42328-6-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    4 ++
 kernel/panic.c                                  |   21 ++++++++------
 2 files changed, 17 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~panic-add-note-that-panic_print-sysctl-interface-is-deprecated
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4578,6 +4578,10 @@
 
                         This is a human readable alternative to the 'panic_print' option.
 
+	panic_console_replay
+			When panic happens, replay all kernel messages on
+			consoles at the end of panic.
+
 	parkbd.port=	[HW] Parallel port number the keyboard adapter is
 			connected to, default is 0.
 			Format: <parport#>
--- a/kernel/panic.c~panic-add-note-that-panic_print-sysctl-interface-is-deprecated
+++ a/kernel/panic.c
@@ -64,6 +64,7 @@ int panic_on_warn __read_mostly;
 unsigned long panic_on_taint;
 bool panic_on_taint_nousertaint = false;
 static unsigned int warn_limit __read_mostly;
+static bool panic_console_replay;
 
 bool panic_triggering_all_cpu_backtrace;
 
@@ -77,6 +78,13 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list
 EXPORT_SYMBOL(panic_notifier_list);
 
 #ifdef CONFIG_SYSCTL
+static int sysctl_panic_print_handler(const struct ctl_table *table, int write,
+			   void *buffer, size_t *lenp, loff_t *ppos)
+{
+	pr_info_once("Kernel: 'panic_print' sysctl interface will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
+	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
+}
+
 static const struct ctl_table kern_panic_table[] = {
 #ifdef CONFIG_SMP
 	{
@@ -108,7 +116,7 @@ static const struct ctl_table kern_panic
 		.data		= &panic_print,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
+		.proc_handler	= sysctl_panic_print_handler,
 	},
 	{
 		.procname	= "panic_on_warn",
@@ -247,12 +255,6 @@ void nmi_panic(struct pt_regs *regs, con
 }
 EXPORT_SYMBOL(nmi_panic);
 
-static void panic_console_replay(void)
-{
-	if (panic_print & SYS_INFO_PANIC_CONSOLE_REPLAY)
-		console_flush_on_panic(CONSOLE_REPLAY_ALL);
-}
-
 void check_panic_on_warn(const char *origin)
 {
 	unsigned int limit;
@@ -427,7 +429,9 @@ void panic(const char *fmt, ...)
 	debug_locks_off();
 	console_flush_on_panic(CONSOLE_FLUSH_PENDING);
 
-	panic_console_replay();
+	if ((panic_print & SYS_INFO_PANIC_CONSOLE_REPLAY) ||
+		panic_console_replay)
+		console_flush_on_panic(CONSOLE_REPLAY_ALL);
 
 	if (!panic_blink)
 		panic_blink = no_blink;
@@ -869,6 +873,7 @@ core_param(panic_print, panic_print, ulo
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 core_param(panic_on_warn, panic_on_warn, int, 0644);
 core_param(crash_kexec_post_notifiers, crash_kexec_post_notifiers, bool, 0644);
+core_param(panic_console_replay, panic_console_replay, bool, 0644);
 
 static int __init oops_setup(char *s)
 {
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

panic-clean-up-code-for-console-replay.patch
panic-generalize-panic_prints-function-to-show-sys-info.patch
panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter.patch
panic-add-panic_sys_info=-setup-option-for-kernel-cmdline.patch
panic-add-note-that-panic_print-sysctl-interface-is-deprecated.patch

