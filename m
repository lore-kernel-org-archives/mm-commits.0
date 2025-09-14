Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09148156C6A
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810154; cv=none; b=rEeNLS1rdOhiYLkMwjKbsNEyEbDOr8VrQjizAZOeefDzWNGSJD61Cpsw8fdPFYuPaelxd3crN4f0srxn2bDdXBE5WdKQiasw2teIhf358GVG1RX6eigtQ6/P0qFe2EHgxo3hu+yVcZidsefMHFV+IDGTHQ64uU9LWChQUD5yqwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810154; c=relaxed/simple;
	bh=04EBLzfswWThHKC4vYRT1EnY7bjz9HkHER7jzSctLCU=;
	h=Date:To:From:Subject:Message-Id; b=aGomsY1U8xCe8pPJ9uBBERNvdw/K0fvcZ1UVRFOxvxGJZ5goMLktPhCw6gN6i5NToYfSuQlW4cZHfvxb35TkyJnvJgNgE3g1M7jEyaKfBE9kw8HtDzdCclN0UCnaMP1Mee8dLhyuNGwxp8p/CFQkJXnuttDvEGfpDINvyL4kKw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cPMf2snE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cPMf2snE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D21C4CEEB;
	Sun, 14 Sep 2025 00:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810153;
	bh=04EBLzfswWThHKC4vYRT1EnY7bjz9HkHER7jzSctLCU=;
	h=Date:To:From:Subject:From;
	b=cPMf2snEn9tobWs3IZ3G+ME8VYhcbm/fA1TIzpYJ2uOHNff6TBdGQVF/AxuFBw47U
	 GsrvoADSvoyxU+lMhII2A5ZnQdHYAqV9fzlOEIEDQTqWdKp0qEbwML2la6Q3YvBy6k
	 jjiywmP+0sVsEbctvcyR0cF3yOC3nsP0xMawg9G0=
Date: Sat, 13 Sep 2025 17:35:53 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,john.ogness@linutronix.de,feng.tang@linux.alibaba.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-remove-redundant-panic-cpu-backtrace.patch removed from -mm tree
Message-Id: <20250914003553.89D21C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: remove redundant panic-cpu backtrace
has been removed from the -mm tree.  Its filename was
     panic-remove-redundant-panic-cpu-backtrace.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: make panic_this_cpu_backtrace_printed static]
  Closes: https://lore.kernel.org/oe-kbuild-all/202509050048.FMpVvh1u-lkp@intel.com/
[pmladek@suse.com: Handle situations when the backtrace was not printed for the panic CPU]
Link: https://lkml.kernel.org/r/20250903100418.410026-1-pmladek@suse.com
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://lore.kernel.org/r/20250731030314.3818040-1-senozhatsky@chromium.org
Signed-off-by: Petr Mladek <pmladek@suse.com>
Tested-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/kernel/panic.c~panic-remove-redundant-panic-cpu-backtrace
+++ a/kernel/panic.c
@@ -67,6 +67,7 @@ static unsigned int warn_limit __read_mo
 static bool panic_console_replay;
 
 bool panic_triggering_all_cpu_backtrace;
+static bool panic_this_cpu_backtrace_printed;
 
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


