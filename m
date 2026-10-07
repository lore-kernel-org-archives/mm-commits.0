Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B21E35C197;
	Wed,  7 Oct 2026 02:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338717; cv=none; b=Wu+Df69rttkWqFbyVxt//0KBv7U8lNaQahKIY5XGcWu2Vahs0xZdVhmwhaJIn+yICwvftQZBasOxpzqySKzszyr6hKGhd7Ta3UR0lFQBrN5T5rC3BLaB9PYzPBYQ81ZH89YPv31w+Mr4S5HarxUOxku1PFvq1/DEvrIaY+gPeac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338717; c=relaxed/simple;
	bh=5XpZ4X4pa3rEssQz50lYlq0lnNGzoCfhjwlGc6oS9BA=;
	h=Date:To:From:Subject:Message-Id; b=b46wC7UV7HcS6/K47Wl46IYVMMgE572EGz93nQZomIxYYVwqmNP4btMxTyf1Jgmqt0b1aU+gHbe2IqNds73hGb3d+T9IxJRougXKjLLinrKHkeUMTTkXOe8lNMbSc0dJ2meRtjGsx3NDAphUDgUQfsYSv7Uiu1b3d/R5tcKlsJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mjScxCbL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mjScxCbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F881F0089C;
	Wed,  7 Oct 2026 02:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338716;
	bh=SQdF4yK0O4yBomTqIj3aZLrn1AvTpfxweylCS2heRbE=;
	h=Date:To:From:Subject;
	b=mjScxCbLEQsbgVp3ZtrH5nU9dSMSCidINSSicqi8o1gpYRzPjQJnhHVORbG4JLv7R
	 mbcOUkJMiAlyxmhuOpHrQgKfDhKTexPrAarfHB50mMgftnWqQiNRn/Miorp/cb9U3L
	 FM7zE66SqrOnIZGZrQAI6Zdybe1ZLPL4aldvTwRc=
Date: Tue, 06 Oct 2026 19:05:15 -0700
To: mm-commits@vger.kernel.org,wim@linux-watchdog.org,wangjinchao600@gmail.com,stable@vger.kernel.org,sashiko-bot@kernel.org,pmladek@suse.com,linux@roeck-us.net,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-fix-redirect-cpu-race-in-panic_try_force_cpu.patch removed from -mm tree
Message-Id: <20261007020515.E1F881F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: fix redirect CPU race in panic_try_force_cpu()
has been removed from the -mm tree.  Its filename was
     panic-fix-redirect-cpu-race-in-panic_try_force_cpu.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch

