Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8585F15533F
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977357; cv=none; b=DwTrpRzon+S6ET2XfpMi6qVDPsYFx8q4Adun9XJU9AAN7MAHHs94v2a6S5cxRjUbvWexNsbUzLTKsmZpqrR5xmziphq41Ats3bePQxQzcvXBVyp0Eqj/8myAOw2vcHWtUqj8G1W+r9rNDoIspp8bNbywD4q2S2Bnhze1ug10y6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977357; c=relaxed/simple;
	bh=BG1D7rSOXcsaDhgMH7DKimU/NufnkE7HTxOIHyYfjCw=;
	h=Date:To:From:Subject:Message-Id; b=dg/dq8QAWZ8z37IdgYT0U5oXpw1ZlBPnN+mzuDj4q8DUlLkQjUXAj4NyKEZRdX2F3A5LsnsF43BEWJAewN5VNtExpBDYhAmhvQ4c/5DVIpMF+Lsl+zBe8KMTepi4JLpUn3G80lGaMPgUpziQRJJDZkdrew2WICF2aEFBbbc6XlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t/Wczu8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t/Wczu8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B828C4CEF4;
	Sun, 20 Jul 2025 02:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977357;
	bh=BG1D7rSOXcsaDhgMH7DKimU/NufnkE7HTxOIHyYfjCw=;
	h=Date:To:From:Subject:From;
	b=t/Wczu8JkZ/B+Z8xYgSRv9h95OgKWyI4T43mCAbpn0f/CXnOcG+Fn40Lk3mgvyyIr
	 AKOFyvmHIyUAPBmrAHanZlnwSig3E11SIW/Kb2QN16awWnaCWRiNTf7NvDa3/G7+o3
	 k6k3m5N082GLeUE43mXJHrMUSaArJO5jaDc7LOH4=
Date: Sat, 19 Jul 2025 19:09:16 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,nathan@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-add-note-that-panic_print-sysctl-interface-is-deprecated.patch removed from -mm tree
Message-Id: <20250720020917.4B828C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: add note that panic_print sysctl interface is deprecated
has been removed from the -mm tree.  Its filename was
     panic-add-note-that-panic_print-sysctl-interface-is-deprecated.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Nathan Chancellor <nathan@kernel.org>
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


