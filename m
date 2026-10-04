Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC31367B65
	for <mm-commits@vger.kernel.org>; Sun,  4 Oct 2026 20:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791144190; cv=none; b=XWP1xf3QHYB60bXisvGEMefEjn2QcZjRD5L1ZxEkUJ8cJseSM+wKzoG5eoltysO4QIxktrr3XLOYUzTuf7K3JKlvCD287JygW2hOKSZcLsrZNUCiaqSOneo1MpIwfsyko0MUIRmoikjINhxaCZpxaabSTY6A/VLg/JG+85dDEFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791144190; c=relaxed/simple;
	bh=QqgepMKCYKhPdROxapv+1GnLVdR+fstx3oaLleGfy0E=;
	h=Date:To:From:Subject:Message-Id; b=dUrHnm3WNHLy2sScrHx57Zu70AV4NJnB83eYjwtmtIZWob+27IWUk1l1tfq6GGtyzdHNdsoRcSKyZ11DE7rRJNbltv+jA6+SZEs5ki3gtEfSGiUt5rmF4ZZENefva9OrgXTkLdgK02LZTc/TD2oRcrMha5NmMvoMOcNv9yMKsrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H44fpx8L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H44fpx8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582971F000FF;
	Sun,  4 Oct 2026 20:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791144179;
	bh=gy4ai4v3lbU5pRHxJ+AoiEcO9n5aNs8i/3SkVV7jHbo=;
	h=Date:To:From:Subject;
	b=H44fpx8LDEbvrvOLSMGRfvv9oeoAyEimMr9Ip1khQa0fFewXS0BoQpsgRy/LQcRkP
	 YWUPEroyNW7aswXnyKW5pAU0Ogz04uwliYFC4X5dmXA+wlBDQFJHsyEaqzfrt0obUA
	 PfFR7NDk57nkB3hQGiBRfSkDKYp/IflKgMJ6LAV4=
Date: Sun, 04 Oct 2026 13:02:58 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,dianders@chromium.org,blum@kernel.org,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch added to mm-nonmm-unstable branch
Message-Id: <20261004200259.582971F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/perf: one digit too short in the raw event config copy
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch

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
Subject: watchdog/perf: one digit too short in the raw event config copy
Date: Sat, 3 Oct 2026 11:02:00 +0000

Commit 6164be01f179 ("watchdog/perf: optimize bytes copied and remove
manual NUL-termination") swapped strscpy(buf, str, sizeof(buf)) plus a
manual buf[len] = 0 for strscpy(buf, str, len), and that count is one
short.  strscpy() keeps the last byte of the destination for the NUL, so
the config loses its final digit, nmi_watchdog=r300,panic for example ends
up with buf = "30" and arms the raw event with the wrong config.

The empty case falls over too, strscpy() with a zero count writes nothing
at all, so nmi_watchdog=r,1 leaves buf uninitialized and kstrtoull() reads
whatever stack garbage is sitting there.

The old code was safe on both by accident, it filled the whole buffer
first and buf[len] = 0 then stomped the comma position, so the worst you
got was a truncated parse failure.

Pass len + 1 so the copy includes the character the NUL replaces, and
reject len >= sizeof(buf) like it was before the optimization, which also
turns an empty config back into a clean parse failure.

Link: https://lore.kernel.org/20261003110200.3-brads@mainlining.org
Fixes: 6164be01f179 ("watchdog/perf: optimize bytes copied and remove manual NUL-termination")
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Thorsten Blum <blum@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
---

 kernel/watchdog_perf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/watchdog_perf.c~watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy
+++ a/kernel/watchdog_perf.c
@@ -301,10 +301,10 @@ void __init hardlockup_config_perf_event
 	} else {
 		unsigned int len = comma - str;
 
-		if (len > sizeof(buf))
+		if (len >= sizeof(buf))
 			return;
 
-		strscpy(buf, str, len);
+		strscpy(buf, str, len + 1);
 		if (kstrtoull(buf, 16, &config))
 			return;
 	}
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
watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch

