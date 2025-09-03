Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CF11917FB
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 21:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756935872; cv=none; b=Zv2ql8PuPNBmx8DQGsBdU6YFTmhu83sHqq94tjgVPI+gBjZ1LPX5Ud7G6P3/obUbPoNsVA4rjce3EosBNalmMxH6nbAWpmyM+591YPmB5q1VMuTK/fD6pcK66XVIB2kqGecw2XXFf7pJBi2eh+Te/8MjaBrOytb6OKvJ2xOlMPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756935872; c=relaxed/simple;
	bh=IloxD+ajuHgzMrpv6oxc8v+6L7bOkSGRVpoza1BEx8c=;
	h=Date:To:From:Subject:Message-Id; b=pioA1EhVtI3jXV1vm9w38emNqPPQB8gyK/ES+j7g8IVz86tvYQF7rVpLzbTT2z0yHxTB3JQMpT+I05XDWx1NEvFFUDYz7ENF/8FHjrNUKBaiwbNffvaxxGewjCL31cDiW/pOqfsDwO8SxH0iKVeStQ0LkL/8DFJHaCuB67mgG/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K/55E1Jc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K/55E1Jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783EEC4CEF4;
	Wed,  3 Sep 2025 21:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756935871;
	bh=IloxD+ajuHgzMrpv6oxc8v+6L7bOkSGRVpoza1BEx8c=;
	h=Date:To:From:Subject:From;
	b=K/55E1JcKBFP1/rVi6m6RCzmrC5Goti2DCKya0/+/wnoSO/XwMAXeOLS5XTyhTRrR
	 wcqSjGnOUzq4jAwmKhtfC0kqxN3FIZQlq2/TH7nm9UVUShhqDVHkhk+9DeW6Sn0LC/
	 jy3G+jaAEJNw8iJPU2u13KmDSTbqKQbrP2WfdzKQ=
Date: Wed, 03 Sep 2025 14:44:30 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,john.ogness@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-remove-redundant-panic-cpu-backtrace.patch added to mm-nonmm-unstable branch
Message-Id: <20250903214431.783EEC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: remove redundant panic-cpu backtrace
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-remove-redundant-panic-cpu-backtrace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-remove-redundant-panic-cpu-backtrace.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: panic: remove redundant panic-cpu backtrace
Date: Wed, 3 Sep 2025 12:04:18 +0200

Backtraces from all CPUs are printed during panic() when
SYS_INFO_ALL_CPU_BT is set.  It shows the backtrace for the panic-CPU even
when it has already been explicitly printed before.

Do not change the legacy code which prints the backtrace in various
contexts, for example, as part of Oops report, right after panic message. 
It will always be visible in the crash dump.

Instead, remember when the backtrace was printed, and skip it when dumping
the optional backtraces on all CPUs.

[pmladek@suse.com: Handle situations when the backtrace was not printed for the panic CPU]
Link: https://lkml.kernel.org/r/20250903100418.410026-1-pmladek@suse.com
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://lore.kernel.org/r/20250731030314.3818040-1-senozhatsky@chromium.org
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/kernel/panic.c~panic-remove-redundant-panic-cpu-backtrace
+++ a/kernel/panic.c
@@ -67,6 +67,7 @@ static unsigned int warn_limit __read_mo
 static bool panic_console_replay;
 
 bool panic_triggering_all_cpu_backtrace;
+bool panic_this_cpu_backtrace_printed;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -380,6 +381,19 @@ void check_panic_on_warn(const char *ori
 		      origin, limit);
 }
 
+static void panic_trigger_all_cpu_backtrace(void)
+{
+	/* Temporary allow non-panic CPUs to write their backtraces. */
+	panic_triggering_all_cpu_backtrace = true;
+
+	if (panic_this_cpu_backtrace_printed)
+		trigger_allbutcpu_cpu_backtrace(raw_smp_processor_id());
+	else
+		trigger_all_cpu_backtrace();
+
+	panic_triggering_all_cpu_backtrace = false;
+}
+
 /*
  * Helper that triggers the NMI backtrace (if set in panic_print)
  * and then performs the secondary CPUs shutdown - we cannot have
@@ -387,12 +401,8 @@ void check_panic_on_warn(const char *ori
  */
 static void panic_other_cpus_shutdown(bool crash_kexec)
 {
-	if (panic_print & SYS_INFO_ALL_CPU_BT) {
-		/* Temporary allow non-panic CPUs to write their backtraces. */
-		panic_triggering_all_cpu_backtrace = true;
-		trigger_all_cpu_backtrace();
-		panic_triggering_all_cpu_backtrace = false;
-	}
+	if (panic_print & SYS_INFO_ALL_CPU_BT)
+		panic_trigger_all_cpu_backtrace();
 
 	/*
 	 * Note that smp_send_stop() is the usual SMP shutdown function,
@@ -470,13 +480,15 @@ void vpanic(const char *fmt, va_list arg
 		buf[len - 1] = '\0';
 
 	pr_emerg("Kernel panic - not syncing: %s\n", buf);
-#ifdef CONFIG_DEBUG_BUGVERBOSE
 	/*
 	 * Avoid nested stack-dumping if a panic occurs during oops processing
 	 */
-	if (!test_taint(TAINT_DIE) && oops_in_progress <= 1)
+	if (test_taint(TAINT_DIE) || oops_in_progress > 1) {
+		panic_this_cpu_backtrace_printed = true;
+	} else if (IS_ENABLED(CONFIG_DEBUG_BUGVERBOSE)) {
 		dump_stack();
-#endif
+		panic_this_cpu_backtrace_printed = true;
+	}
 
 	/*
 	 * If kgdb is enabled, give it a chance to run before we stop all
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-protect-recomp_algorithm_show-with-init_lock.patch
panic-remove-redundant-panic-cpu-backtrace.patch

