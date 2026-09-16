Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5DC45D5D9;
	Wed, 16 Sep 2026 20:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591567; cv=none; b=f4NSdiFfPhTJUuHDc3wIl6/MkWmLFfVm6Xzw2MR/Nr4IACrfY/ptgaWZY7Dp0g/XFTMNT2ke9UDNF+PSJzvJxZZjkW5mxrEt4O2QfkN1cMSlnLeeZP3pQHkPFnKuH5l5XT9IErq9ig8BXtL7HtpXOUJmP1H2JumDebC+3RKEaYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591567; c=relaxed/simple;
	bh=4aUJla20XSw2zpwp+zRLpl+Ltb+93Ly8ZzDr47mkjqg=;
	h=Date:To:From:Subject:Message-Id; b=JSW3UMhBlevmd9EOdrMNgD/hC//oJsoHDEs6ygIzlMRO+hff9gFq47IjeBUt4zSC4rplDKako8RGRYD9LLYSTiNpMTk5PeCW9/1D4YmPX5n16g+niAgJ+VlbyN649p/jF9b9v1IFQXZoneBzqZDpc6TweeE9Up3pWByOdZM/P5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RAxiPo9M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RAxiPo9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FFC1F0089D;
	Wed, 16 Sep 2026 20:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789591548;
	bh=AXlvgDUm5s6mZVaU+yROZoOQHiVzby3T01O7oSB/org=;
	h=Date:To:From:Subject;
	b=RAxiPo9MJYs6s3EsfmI2NaaQZHyxskE//vhhbXy1zKGKPv4YB9kvg40MScBBbbxXG
	 kbihSYlLHuRDUP7LV5FuHwBXqeuBDXKDaA+Ftd8vA9yud+Nv+2WvCPife7sQCCmLQB
	 9xierTSQjA/7R7RC1kGIExX1tEgf8GvrlyR+br4U=
Date: Wed, 16 Sep 2026 13:45:48 -0700
To: mm-commits@vger.kernel.org,wim@linux-watchdog.org,wangjinchao600@gmail.com,stable@vger.kernel.org,sashiko-bot@kernel.org,pmladek@suse.com,linux@roeck-us.net,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-kill-the-buffer-unavailable-redirect-fallback.patch added to mm-nonmm-unstable branch
Message-Id: <20260916204548.C2FFC1F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: kill the "buffer unavailable" redirect fallback
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-kill-the-buffer-unavailable-redirect-fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-kill-the-buffer-unavailable-redirect-fallback.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Bradley Morgan <brads@mainlining.org>
Subject: panic: kill the "buffer unavailable" redirect fallback
Date: Wed, 16 Sep 2026 18:29:57 +0000

The redirect buffer is a disgusting terrible hack.  panic_force_buf is
kmalloc'ed in a late_initcall, and until then the redirect delivers this
as the panic message:

  Redirected panic (buffer unavailable)

The whole point of the redirect is to hand the panic message to the target
CPU, so the crash kernel boots knowing it panicked and not why.  And that
window is the entire boot, from the early_param to the late_initcall,
which is exactly when you most want the message.

Make it a static 1KB buffer and kill the initcall.  The cost is 1KB of
.bss in SMP crash dump builds, and it is only ever touched when
panic_force_cpu= is set anyway.  The local msg variable is gone too, the
buffer goes directly to panic_smp_redirect_cpu().

Link: https://lore.kernel.org/20260916182957.7788-7-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Sashiko <sashiko-bot@kernel.org>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
---

 kernel/panic.c |   34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

--- a/kernel/panic.c~panic-kill-the-buffer-unavailable-redirect-fallback
+++ a/kernel/panic.c
@@ -307,7 +307,7 @@ atomic_t panic_cpu = ATOMIC_INIT(PANIC_C
 atomic_t panic_redirect_cpu = ATOMIC_INIT(PANIC_CPU_INVALID);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_CRASH_DUMP)
-static char *panic_force_buf;
+static char panic_force_buf[PANIC_MSG_BUFSZ];
 
 static int __init panic_force_cpu_setup(char *str)
 {
@@ -326,17 +326,6 @@ static int __init panic_force_cpu_setup(
 }
 early_param("panic_force_cpu", panic_force_cpu_setup);
 
-static int __init panic_force_cpu_late_init(void)
-{
-	if (panic_force_cpu < 0)
-		return 0;
-
-	panic_force_buf = kmalloc(PANIC_MSG_BUFSZ, GFP_KERNEL);
-
-	return 0;
-}
-late_initcall(panic_force_cpu_late_init);
-
 static void do_panic_on_target_cpu(void *info)
 {
 	panic("%s", (char *)info);
@@ -380,7 +369,7 @@ static bool panic_try_force_cpu(const ch
 {
 	int this_cpu = raw_smp_processor_id();
 	int old_cpu = PANIC_CPU_INVALID;
-	const char *msg;
+	va_list ap;
 
 	/* Feature not enabled via boot parameter */
 	if (panic_force_cpu < 0)
@@ -413,20 +402,11 @@ static bool panic_try_force_cpu(const ch
 		return old_cpu != this_cpu;
 
 	/*
-	 * Use dynamically allocated buffer if available, otherwise
-	 * fall back to static message for early boot panics or allocation failure.
+	 * Do not consume args, the caller reuses them if we fail.
 	 */
-	if (panic_force_buf) {
-		va_list ap;
-
-		/* Do not consume args, the caller reuses it if we fail */
-		va_copy(ap, args);
-		vsnprintf(panic_force_buf, PANIC_MSG_BUFSZ, fmt, ap);
-		va_end(ap);
-		msg = panic_force_buf;
-	} else {
-		msg = "Redirected panic (buffer unavailable)";
-	}
+	va_copy(ap, args);
+	vsnprintf(panic_force_buf, PANIC_MSG_BUFSZ, fmt, ap);
+	va_end(ap);
 
 	console_verbose();
 	bust_spinlocks(1);
@@ -441,7 +421,7 @@ static bool panic_try_force_cpu(const ch
 		dump_stack();
 	}
 
-	if (panic_smp_redirect_cpu(panic_force_cpu, (void *)msg) != 0) {
+	if (panic_smp_redirect_cpu(panic_force_cpu, panic_force_buf) != 0) {
 		atomic_set(&panic_redirect_cpu, PANIC_CPU_INVALID);
 		pr_warn("panic: failed to redirect to CPU %d, continuing on CPU %d\n",
 			panic_force_cpu, this_cpu);
_

Patches currently in -mm which might be from brads@mainlining.org are

taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch
mailmap-update-email-address-for-bradley-morgan.patch
taskstats-drop-the-unused-cpu_dont_care-enum-member.patch
panic-fix-redirect-cpu-race-in-panic_try_force_cpu.patch
panic-flatten-nmi_panic-control-flow.patch
panic-fix-va_list-reuse-in-panic_try_force_cpu.patch
panic-restore-variable-arguments-to-nmi_panic.patch
panic-allow-force_cpu-redirect-from-an-nmi.patch
panic-kill-the-buffer-unavailable-redirect-fallback.patch

