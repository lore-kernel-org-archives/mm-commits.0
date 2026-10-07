Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A7F35E1BC;
	Wed,  7 Oct 2026 02:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338722; cv=none; b=VVJvMPkc2qw4bcqgKmQdFtLdfXRQdEh313FHX+7QJTfpgEYsS9JPI0pVyc2m2ALHKsIXCsgsZRryikQ2JhomFkBDNmu4q0XBM6PgJXomwyHnlYKVQiTe6VGv1YZFrtK8cUdV2ON5ePxyM+p0Vc2GS4LwDvIy+lfrDROMemkCQa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338722; c=relaxed/simple;
	bh=1sTT1gwtsHxIuFydD+TBxnWx5cRe6qY6P+ocQwGUKIY=;
	h=Date:To:From:Subject:Message-Id; b=igaM9dgYrgrmztnc4D2Nze5uGVzxRSq/D94G0mTqkb0JViaTfPihxE9dnvqIGD1zIiQWDwObx3ms++sm5gkdpG3CLSvHKB9SECh2ot479ermL/AV4N2DFXd4ErZ3cIl/msi8sL6eG7hsQh4UIreqW1u5liA0yjxbzMYS90AKfQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F6DgC9AI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F6DgC9AI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1131F0089C;
	Wed,  7 Oct 2026 02:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338721;
	bh=cS3p29f7t16rLO2zc0S5NhESUkce+fuTN0MgILFGNTo=;
	h=Date:To:From:Subject;
	b=F6DgC9AIAsNxnHv2+6qjuSCWfFHaNsMVsYnCJS2K2HXCujPw/aUaUhcNmTVPocv69
	 2jT0RCZ0o/o1XSOMIBz6Cno0X4dPgX+1ifQ5X12MlTuUOlmj+Em4+An2z6Iwb88+2+
	 BZZjWC/cTyXc2tjyp5IxurIdvrl9qPB/gmLS8vmc=
Date: Tue, 06 Oct 2026 19:05:20 -0700
To: mm-commits@vger.kernel.org,wim@linux-watchdog.org,wangjinchao600@gmail.com,stable@vger.kernel.org,sashiko-bot@kernel.org,pmladek@suse.com,linux@roeck-us.net,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-allow-force_cpu-redirect-from-an-nmi.patch removed from -mm tree
Message-Id: <20261007020520.EA1131F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: allow force_cpu redirect from an NMI
has been removed from the -mm tree.  Its filename was
     panic-allow-force_cpu-redirect-from-an-nmi.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch

