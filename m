Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F0A46F4A3;
	Wed, 16 Sep 2026 20:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591558; cv=none; b=cy/2QnFVWNaBa1Ee53uolbyeS4HEmnSOoHSEojjXcoAnkpYAh0xl+uts5lU5JLkBKFaXB79Crxk2XRX/1clMLB8yHysmwubvWMjwOe69KycuTedG9z4LnUjQjq1mzxrP61fG9wp9te805FetGXJ6gv1K2eYa2FnvYe7v0Qxw+1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591558; c=relaxed/simple;
	bh=5ZckBG32fcXZ3WoQYmLUyc2UPA+dLuWeSx/4die7qO0=;
	h=Date:To:From:Subject:Message-Id; b=jnQtOy2s5y/p25DS5SnYn0nuF0f/uhrB7Aow0IO9oH6lbDvXijE1J4jW4xA5bvFqkG4cnA2S4iBwSoC85X9wzF4KVgJoiJ2nguO+qcGBWSOjzaOeFHInmLCgBroexMsO9FBYniAy7UveImelpQgQR788BxXN/w3mDXDtBZDw6A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bxsw6aBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bxsw6aBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9ACE1F00898;
	Wed, 16 Sep 2026 20:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789591541;
	bh=Gq81EsN1ivRYB8+wqReGGnuPIT6fNkq7Jtao2oFBb8I=;
	h=Date:To:From:Subject;
	b=bxsw6aBKD0fmAck/trRk201nXyudJsZjkXKxWoXJ/MUsZnPEdveCneiUOBeQDCD9q
	 YWo/IOB27920q7/eG8QPwMAoKzh2cRbAiliBjdF6+J7sJHRNsFs7PrxO8OM2WNEL6k
	 bx5p0/pDnOVXZQ2qXh5R5jSwBLuZkjudR1t77+Vc=
Date: Wed, 16 Sep 2026 13:45:41 -0700
To: mm-commits@vger.kernel.org,wim@linux-watchdog.org,wangjinchao600@gmail.com,stable@vger.kernel.org,sashiko-bot@kernel.org,pmladek@suse.com,linux@roeck-us.net,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-fix-va_list-reuse-in-panic_try_force_cpu.patch added to mm-nonmm-unstable branch
Message-Id: <20260916204541.A9ACE1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: fix va_list reuse in panic_try_force_cpu()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-fix-va_list-reuse-in-panic_try_force_cpu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-fix-va_list-reuse-in-panic_try_force_cpu.patch

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
Subject: panic: fix va_list reuse in panic_try_force_cpu()
Date: Wed, 16 Sep 2026 18:29:54 +0000

vsnprintf() consumes the caller's va_list.  When the redirect fails,
vpanic() reuses it for the panic message, which is undefined behavior. 
Use va_copy().

Link: https://lore.kernel.org/20260916182957.7788-4-brads@mainlining.org
Fixes: 2e171ab29f91 ("panic: add panic_force_cpu= parameter to redirect panic to a specific CPU")
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>

Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Sashiko <sashiko-bot@kernel.org>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
---

 kernel/panic.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/panic.c~panic-fix-va_list-reuse-in-panic_try_force_cpu
+++ a/kernel/panic.c
@@ -417,7 +417,12 @@ static bool panic_try_force_cpu(const ch
 	 * fall back to static message for early boot panics or allocation failure.
 	 */
 	if (panic_force_buf) {
-		vsnprintf(panic_force_buf, PANIC_MSG_BUFSZ, fmt, args);
+		va_list ap;
+
+		/* Do not consume args, the caller reuses it if we fail */
+		va_copy(ap, args);
+		vsnprintf(panic_force_buf, PANIC_MSG_BUFSZ, fmt, ap);
+		va_end(ap);
 		msg = panic_force_buf;
 	} else {
 		msg = "Redirected panic (buffer unavailable)";
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

