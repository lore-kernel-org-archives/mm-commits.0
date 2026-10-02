Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32911407597
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 21:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790976268; cv=none; b=MWPcVgvA5+SMHaz6LpkDP2Ky9fllV0gbvjXPSJutemaT1PCdFqzf7F+Elv2QwHz6r005oph5xrCa6op8ULOoUhLdkwVlNAeYil0mIJCAkwMclgqENgbj4gWdXVl8wAtsZzfu5cyPu9J1mrWqjYlbtl/PRBn+T2raiLL4QnZ4upI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790976268; c=relaxed/simple;
	bh=KaFwxL3tyFqaXhwoaq6vEB5J479MmYBQ6rJ/yqeC5P8=;
	h=Date:To:From:Subject:Message-Id; b=De7lsW2Lh/f/dw7qD6CW+l8caym0NoPv77lNNBI1N/kdUubYkp8rakQJz+M3a7P7wb1l/HhQZvt739IvJ2/Cs+rqKTI1kjld/sxAWthsTfDzt9Lm5n3myFj1VdV/R8C5QoJ86PZGJKuLmkQEdehLDWoIMGbLDlUpNwlLSpNhCHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oMT3tOk5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oMT3tOk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61B91F000FF;
	Fri,  2 Oct 2026 21:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790976267;
	bh=jwiX8bB8z8CzjomJFZp7/zI5eAJO2fipHQZO1JANQ+k=;
	h=Date:To:From:Subject;
	b=oMT3tOk5ZJxB2gaiDN6HBgyDgN4dW4rPLa08ELQnnrKtcLMiUqXlAUSIRDd//MiKP
	 NGeEB6iE4Hg7DrlOW+U5GYAu1ceLSpC/RRDC5nOyJcRL5SYdZlpz1eJr/YqRn+pJVJ
	 XZScaAiMC+qvMGT+Kb2I8v5RjnZbLGMtrF29nUiM=
Date: Fri, 02 Oct 2026 14:24:26 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,dianders@chromium.org,blum@kernel.org,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-perf-reject-empty-config-before-the-raw-event-parse.patch added to mm-nonmm-unstable branch
Message-Id: <20261002212426.E61B91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/perf: reject empty config before the raw event parse
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-perf-reject-empty-config-before-the-raw-event-parse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-perf-reject-empty-config-before-the-raw-event-parse.patch

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
Subject: watchdog/perf: reject empty config before the raw event parse
Date: Fri, 2 Oct 2026 17:39:13 +0000

Commit 6164be01f179 ("watchdog/perf: optimize bytes copied and remove
manual NUL-termination") replaced strscpy(buf, str, sizeof(buf)) plus a
manual buf[len] = 0 with strscpy(buf, str, len).  strscpy() writes nothing
at all when the count is zero, so on a comma directly after the "r"
prefix, nmi_watchdog=r,1 for example, len is 0, buf stays uninitialized,
and kstrtoull() parses whatever stack garbage is there.

The old code was safe here by accident, strscpy() filled the whole buffer
before buf[len] = 0 overwrote the comma position, so a zero length just
produced an empty string and a clean parse failure.

Treat an empty config the same as an overlong one and return early.

Link: https://lore.kernel.org/20261002175000.1-brads@mainlining.org
Fixes: 6164be01f179 ("watchdog/perf: optimize bytes copied and remove manual NUL-termination")
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Thorsten Blum <blum@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Douglas Anderson <dianders@chromium.org>
---

 kernel/watchdog_perf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/watchdog_perf.c~watchdog-perf-reject-empty-config-before-the-raw-event-parse
+++ a/kernel/watchdog_perf.c
@@ -301,7 +301,7 @@ void __init hardlockup_config_perf_event
 	} else {
 		unsigned int len = comma - str;
 
-		if (len > sizeof(buf))
+		if (!len || len > sizeof(buf))
 			return;
 
 		strscpy(buf, str, len);
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
watchdog-perf-reject-empty-config-before-the-raw-event-parse.patch

