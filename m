Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9975430D402
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 22:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790981732; cv=none; b=eDeML4n0vwHdSTyta4p0Q1gVqezV2q07mzh6tVK+cB15j/a1IUZmm7+AsmcoNHXvyt83c4ZBc88gtw+woY+uHlOI0/aUMbMHLPlfnXydc1u/uKVycf5FvzgRFBgs9YlVu3Q/LiQkjzgrqetz6+gfFDxIe5/OOtZjWU2wtUV8miQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790981732; c=relaxed/simple;
	bh=8W9K2msCbKGur5ILobHL1a1n6nOB3NFYH5QyI1WfSaw=;
	h=Date:To:From:Subject:Message-Id; b=pGij0vi6sxcVutwUhdlsS+2jJcKafvdiRHqpglN+1m2scOtK8l1EMB8SBABbzb58w5rEhpWroQopd4khTfhxnIns0PqTShD7h+qgDmPStKLT0PSX97NgjHhBl3r8IdCeBJmNc/sCCBvQyMo75i7P18ALobvpY46s+nNtLRn1+Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xVBq8IbD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xVBq8IbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098A21F000FF;
	Fri,  2 Oct 2026 22:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790981731;
	bh=E4jhqfl1wBqHXtDnvhwOYVZZiOrea3hpMQb81fTN7Nk=;
	h=Date:To:From:Subject;
	b=xVBq8IbD86MyQkJG56UomjkZgnq9HqEtewD0qLGurtJAtRHgWe64mTULo/NFgqwen
	 k4KpQOVF7Xf+0Tx7kmaQUvmJoZhNiXje3XtjaWbb7v1FCCRsnzoeheqsGAMlRS6YBd
	 zTXXmyXfdUj2FOBKmMu7IYJMu/iDN82LzKqYkqXc=
Date: Fri, 02 Oct 2026 15:55:30 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,dianders@chromium.org,blum@kernel.org,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] watchdog-perf-reject-empty-config-before-the-raw-event-parse.patch removed from -mm tree
Message-Id: <20261002225531.098A21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/perf: reject empty config before the raw event parse
has been removed from the -mm tree.  Its filename was
     watchdog-perf-reject-empty-config-before-the-raw-event-parse.patch

This patch was dropped because an updated version will be issued

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

