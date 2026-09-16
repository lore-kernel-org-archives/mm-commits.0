Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9A94DA9D3;
	Wed, 16 Sep 2026 20:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591551; cv=none; b=ILQFU4uwesGQZ6/Xa5YTvaMFyy+kvCuL0AKUaeSZTEqTS/Xj0n7CdwDJlUcT2Qmv+tAHBgl4PYRlEMQvhlnn8W/HHA8JrWvy20QSduyo81rw2FrVfeVxHL8K25sqdgYQyE7O37ZmzEMUYxM4/3MTyrFVX2ZYGpe7IgsWouGAVGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591551; c=relaxed/simple;
	bh=WGrPZAXt0NSIL1j0P0toEtUnAZYxZC2mHWPH1s854V8=;
	h=Date:To:From:Subject:Message-Id; b=WuQq57nS3owIyUo7SBRIfvbR2KY5JSGT6LwH1Ua6f7/Pcuf/Q/gbMfB0Ttg7X2odqdg5A/wU+4/GmMcWYo5lImwSGpriPwD5HMo4Z9R44PdBe8YkexxS3fFQaXEnaUEpgNBkAiVsdW973IR7y6KZ91PY9swEUJnvfYm3ZcnhD1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Cixrhsq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Cixrhsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0E21F0089B;
	Wed, 16 Sep 2026 20:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789591537;
	bh=kXg6pw4Yqsf7MZWgDC4mlXdVWuGwLcguQERjMhFndxo=;
	h=Date:To:From:Subject;
	b=2CixrhsqNmiZ2IPEsf+YFbQMkbFIFxpWHZYhPQmPAdZFOhFzpS7I7a4xou4FpBKgn
	 HeRAI8tZCR46upK3bUyXZvyEneFFyncG9D78JFUliLlDDPe1Kw7G9akyxk1zu5y5dV
	 E6EmRE4xBixz9FxU+Tbf3MP74NXiBlzsShHE8RPw=
Date: Wed, 16 Sep 2026 13:45:37 -0700
To: mm-commits@vger.kernel.org,wim@linux-watchdog.org,wangjinchao600@gmail.com,stable@vger.kernel.org,sashiko-bot@kernel.org,pmladek@suse.com,linux@roeck-us.net,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-fix-redirect-cpu-race-in-panic_try_force_cpu.patch added to mm-nonmm-unstable branch
Message-Id: <20260916204537.9D0E21F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: fix redirect CPU race in panic_try_force_cpu()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-fix-redirect-cpu-race-in-panic_try_force_cpu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-fix-redirect-cpu-race-in-panic_try_force_cpu.patch

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
Subject: panic: fix redirect CPU race in panic_try_force_cpu()
Date: Wed, 16 Sep 2026 18:29:52 +0000

Patch series "panic: fix panic_force_cpu= redirect races and NMI bypass",
v7.

The panic_force_cpu= parameter redirects a panic to a specific CPU so the
crash kernel runs there.  The redirect code in panic_try_force_cpu() had
two races and an NMI bypass, all found by Sashiko.  This series closes
them and kills one more hack that the rework turned up.

Panic from NMI still goes through the redirect path first, so the crash
kernel ends up on the CPU the admin asked for.  The redirect buffer is a
static 1KB now, no initcall, no fallback message.


This patch (of 6):

The cmpxchg() in panic_try_force_cpu() makes sure that only one CPU tries
to redirect panic() to the requested CPU.  It is similar to the cmpxchg()
in panic_try_start() which makes sure that only one CPU does the panic(). 
In both situations, only the winner of cmpxchg() should proceed further. 
Other CPUs should go offline.

There is a bug because the cmpxchg loser returns false and falls through
into vpanic().  Two non-target CPUs A and B panic, the requested CPU is C:

             cpu A                          cpu B
          ----------                     ----------
    panic()                              panic()
    vpanic()                             vpanic()
    panic_try_force_cpu()                panic_try_force_cpu()
        cmpxchg wins                        cmpxchg fails
        redirect = A                        old_cpu = A
        IPI -> C                            return false      <- BUG
        return true                     panic_try_start() wins
    panic_smp_self_stop()                __crash_kexec() on B
    (A stops)                            (target C bypassed)

The loser must stop, not fall through.  It cannot just return true,
though.  A CPU that already won the redirect cmpxchg can reenter
panic_try_force_cpu() on the same CPU, for example a nested NMI during the
message formatting, before the IPI is sent:

             cpu A (1st)                  cpu A (nested)
          ----------                     ----------
    panic()
    vpanic()
    panic_try_force_cpu()
        cmpxchg wins (redirect = A)
        vsnprintf(msg) ...
            <-- NMI, nested panic -->
                                     panic()
                                     vpanic()
                                     panic_try_force_cpu()
                                         cmpxchg fails
                                         old_cpu == A (this CPU)
                                         return true   <- would halt
                                     panic_smp_self_stop()
                                     (IPI never sent, panic abandoned)

Check old_cpu against this_cpu so a second call from the same CPU returns
false and falls through to panic_try_start() instead.

Also fix the panic_in_progress() check.  We must not redirect when
panic_cpu is already assigned.  Return true to stop when the panic is on
another CPU, false to proceed when it is this one.

Update the panic_try_force_cpu() doc comment for the new return value
semantics.

Link: https://lore.kernel.org/20260916182957.7788-1-brads@mainlining.org
Link: https://lore.kernel.org/20260916182957.7788-2-brads@mainlining.org
Fixes: 2e171ab29f91 ("panic: add panic_force_cpu= parameter to redirect panic to a specific CPU")
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260705164123.18746-1-include@grrlz.net
Closes: https://sashiko.dev/#/patchset/20260707172252.4842-1-include@grrlz.net
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
---

 kernel/panic.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/kernel/panic.c~panic-fix-redirect-cpu-race-in-panic_try_force_cpu
+++ a/kernel/panic.c
@@ -371,8 +371,9 @@ int __weak panic_smp_redirect_cpu(int ta
  * for the crash kernel to function correctly. This function redirects
  * panic handling to the CPU specified via the panic_force_cpu= boot parameter.
  *
- * Returns false if panic should proceed on current CPU.
- * Returns true if panic was redirected.
+ * Returns true when this CPU must stop: the panic was redirected or is
+ * already running on another CPU.
+ * Returns false when panic() should proceed on this CPU.
  */
 __printf(1, 0)
 static bool panic_try_force_cpu(const char *fmt, va_list args)
@@ -396,16 +397,20 @@ static bool panic_try_force_cpu(const ch
 		return false;
 	}
 
-	/* Another panic already in progress */
+	/*
+	 * Don't redirect when a panic is already in progress. Stop this
+	 * CPU when it's another one, proceed when it's this one.
+	 */
 	if (panic_in_progress())
-		return false;
+		return panic_on_other_cpu();
 
 	/*
-	 * Only one CPU can do the redirect. Use atomic cmpxchg to ensure
-	 * we don't race with another CPU also trying to redirect.
+	 * Only one CPU can do the redirection. Others should go offline.
+	 * Continue with panic() when we already tried the redirection
+	 * from this CPU before, for example via nmi_panic().
 	 */
 	if (!atomic_try_cmpxchg(&panic_redirect_cpu, &old_cpu, this_cpu))
-		return false;
+		return old_cpu != this_cpu;
 
 	/*
 	 * Use dynamically allocated buffer if available, otherwise
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

