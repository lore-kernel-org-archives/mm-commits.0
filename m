Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717A7446C18;
	Wed, 16 Sep 2026 20:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591555; cv=none; b=EYf+WBWwY7KQW+w3SUxA+K7W6YTdWx00QtRuyDCYgRXaRHxveroxTi5Vw/xvjJu3nSMVF+0kGgJm+P+8CNbGZz0m8UnOAwI+39+Szka9NXPvochOSqPXvoSzKAAiUwLZvfCajsLEPzKZ4HXCsZtZIwofITrK+7ff6CtGNEqWHMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591555; c=relaxed/simple;
	bh=yDi8FybVWUA+27V732kMddkyRUtz4zer80grPgDRIHU=;
	h=Date:To:From:Subject:Message-Id; b=XHNvYbYI1i9d4sPIJJ33Lzop84D5SKiArUIMmjpo2YD7WMmM8EMmbjXYAWXlrzg1TRxAu9JVpFczOkP2cO4aZ77KAvh1bd10Svz9OIvceT8fmAymoW+tj1lmo3mQIRuoM7WAnYShpNacb6vWeAGjJkxhnoWQ247r52vLJ1zDH7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ftBI3xGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ftBI3xGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45D91F00893;
	Wed, 16 Sep 2026 20:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789591539;
	bh=ZZ23Qha1+aRWBUPDkE7pY8nCKGH2kvdmPz0vQbXuWQ4=;
	h=Date:To:From:Subject;
	b=ftBI3xGHWDps5RDtW806TXRtASbwYp/ogWIJyiNNCzi+dmMjfGfOzzfm9RHwT3tIX
	 DXrspmRebuySTsa5WC17bC1wxKQZROPRm9T0hbXjR7NFKuc7+NPw3nb3BCvOtbgxgQ
	 Zj40IuLArXawp9TDOpir3lnQaQei1pYLsRq9LUEc=
Date: Wed, 16 Sep 2026 13:45:39 -0700
To: mm-commits@vger.kernel.org,wim@linux-watchdog.org,wangjinchao600@gmail.com,stable@vger.kernel.org,sashiko-bot@kernel.org,pmladek@suse.com,linux@roeck-us.net,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-flatten-nmi_panic-control-flow.patch added to mm-nonmm-unstable branch
Message-Id: <20260916204539.A45D91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: flatten nmi_panic control flow
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-flatten-nmi_panic-control-flow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-flatten-nmi_panic-control-flow.patch

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
Subject: panic: flatten nmi_panic control flow
Date: Wed, 16 Sep 2026 18:29:53 +0000

panic() is __noreturn, so the else after panic_try_start() is dead.  Drop
it so the force_cpu path can be added cleanly on top.

Link: https://lore.kernel.org/20260916182957.7788-3-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Sashiko <sashiko-bot@kernel.org>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
---

 kernel/panic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/panic.c~panic-flatten-nmi_panic-control-flow
+++ a/kernel/panic.c
@@ -517,7 +517,8 @@ void nmi_panic(struct pt_regs *regs, con
 {
 	if (panic_try_start())
 		panic("%s", msg);
-	else if (panic_on_other_cpu())
+
+	if (panic_on_other_cpu())
 		nmi_panic_self_stop(regs);
 }
 EXPORT_SYMBOL(nmi_panic);
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

