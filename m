Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1884DE70D;
	Wed, 16 Sep 2026 20:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591567; cv=none; b=fma+yLOo6+JC8s2OSylb9b2RHN/+1Z2IBSpw8eIKwEh4CfK7EJHmxMJRmslCICz4ZyAEDmMpGOypKi3btCyPibRp6y6Ndz6B2BzfcW5AZ56aLEK7DKc9zz0D/8QCOVFucKhBaDc6/OO8MJShBl/HzmHsA/64KLvHLAMrYhUuTkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591567; c=relaxed/simple;
	bh=1mVPjeEZdgPw16T/Q4sMFG2G5KaktUy4WZmCSkXMkFk=;
	h=Date:To:From:Subject:Message-Id; b=JDkGZGxp1b0B67CVs7h8hYemF/skftggpmkilH8Jcs5yk+uFgJIVDpqGKDAOAamFJeCbjIvORuVC3vbxew+NzKFJU3RF2UIoHTXvZKpiWkxR6ss12IbGgmNuv8tm2siA8/XUikpeF32XkZnweNpJbReqmAX5kjCFR82V/skpjfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nroI+Ca1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nroI+Ca1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7E31F00899;
	Wed, 16 Sep 2026 20:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789591546;
	bh=3OMJddD1qtU8Jt2odThJoyawociOfw8xY3SwSSKNmeA=;
	h=Date:To:From:Subject;
	b=nroI+Ca14OS2RTeyagJ3eOA6OOMiQ46tpaqVRBd8AezN8ZNENDNaUZNRqwIERLZi9
	 75IMCFXWl1REe0wm5YXEoslbO3/IUJSHxuQvOJgv2cByaW7R4aWzHCrCtMTgN9a/zg
	 cR2mbC3EmSUGIn1/SMNGP5DquV4DcgK6hA3yAtPU=
Date: Wed, 16 Sep 2026 13:45:46 -0700
To: mm-commits@vger.kernel.org,wim@linux-watchdog.org,wangjinchao600@gmail.com,stable@vger.kernel.org,sashiko-bot@kernel.org,pmladek@suse.com,linux@roeck-us.net,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-allow-force_cpu-redirect-from-an-nmi.patch added to mm-nonmm-unstable branch
Message-Id: <20260916204546.BB7E31F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: allow force_cpu redirect from an NMI
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-allow-force_cpu-redirect-from-an-nmi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-allow-force_cpu-redirect-from-an-nmi.patch

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
Subject: panic: allow force_cpu redirect from an NMI
Date: Wed, 16 Sep 2026 18:29:56 +0000

nmi_panic() claims panic_cpu via panic_try_start() before calling panic().
When the panic later reaches panic_try_force_cpu(), the
panic_in_progress() check sees panic_cpu set and refuses to redirect.  The
crash kernel runs on the CPU that took the NMI instead of the CPU
requested with panic_force_cpu=:

  nmi_panic()
    panic_try_start()              wins, panic_cpu = X
    panic("%s", msg)
      vpanic()
        panic_try_force_cpu()
          panic_in_progress()      true, panic_cpu is X
          return false             redirect bypassed
        panic_try_start()          already won
        __crash_kexec()            on X, not the requested CPU

Try the redirect before claiming panic_cpu instead, as suggested by Petr
Mladek.  nmi_panic() now calls panic_try_force_cpu() first and claims
panic_cpu only when no redirect happened.  The requested CPU claims
panic_cpu itself when it runs panic(), so panic_cpu does not need to be
handed off.  panic_try_force_cpu() copies the arguments before formatting
(patch 3), so nmi_panic() can pass them to vpanic() again when no redirect
happens.

The redirect IPI is sent with smp_call_function_single_async(), which is
not guaranteed to work from NMI context.  Treat it as best effort.  It is
worth the risk because the redirection is only used when the crash kernel
would not work on the panicking CPU anyway.

Keep returning when the panic is already running on this CPU.  A nested
NMI, for example with unknown_nmi_panic while this CPU is inside panic(),
must return and let the interrupted panic() continue instead of parking
the CPU in nmi_panic_self_stop().

Mark the redirecting CPU offline before stopping it, like vpanic() does,
so that panic_other_cpus_shutdown() on the target CPU does not wait for
it.

Link: https://lore.kernel.org/20260916182957.7788-6-brads@mainlining.org
Fixes: 2e171ab29f91 ("panic: add panic_force_cpu= parameter to redirect panic to a specific CPU")
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260708164312.19044-1-include@grrlz.net
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
---

 kernel/panic.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/kernel/panic.c~panic-allow-force_cpu-redirect-from-an-nmi
+++ a/kernel/panic.c
@@ -513,10 +513,11 @@ bool panic_on_other_cpu(void)
 EXPORT_SYMBOL(panic_on_other_cpu);
 
 /*
- * A variant of panic() called from NMI context. We return if we've already
- * panicked on this CPU. If another CPU already panicked, loop in
- * nmi_panic_self_stop() which can provide architecture dependent code such
- * as saving register state for crash dump.
+ * A variant of panic() called from NMI context. The panic is first
+ * redirected to the CPU requested via panic_force_cpu=, when configured.
+ * We return if we've already panicked on this CPU. If another CPU already
+ * panicked, loop in nmi_panic_self_stop() which can provide architecture
+ * dependent code for saving register state for crash dump.
  */
 void nmi_panic(struct pt_regs *regs, const char *fmt, ...)
 {
@@ -524,6 +525,16 @@ void nmi_panic(struct pt_regs *regs, con
 
 	va_start(args, fmt);
 
+	/* Try to redirect to the requested CPU before claiming panic_cpu. */
+	if (panic_try_force_cpu(fmt, args)) {
+		/*
+		 * Mark ourselves offline so panic_other_cpus_shutdown() won't
+		 * wait for us on architectures that check num_online_cpus().
+		 */
+		set_cpu_online(raw_smp_processor_id(), false);
+		nmi_panic_self_stop(regs);
+	}
+
 	if (panic_try_start())
 		vpanic(fmt, args);
 
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

