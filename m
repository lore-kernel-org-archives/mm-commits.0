Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3F23AA4E3
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783454423; cv=none; b=UT1LksDeS4J3rUHs2Jzs5fBbiOB0D9IZcWgmgY0jMZiAx63CGznXCMKUx2E527PC92raxfgYDRvB8aWHelRzvHpN8GzW+1JeApZWY3r5EDApDRKtrMP9As9smtJmZMPvA3Szhidyk4i7q+MUMat0t75FAtwlBG6hTbiX9j2iI3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783454423; c=relaxed/simple;
	bh=jddN+vKIZ5JT+ULaiaKP62J88TSu+7BoN7ABBrFy+2U=;
	h=Date:To:From:Subject:Message-Id; b=u1Bj9VVdORQ8w+h6EOd+zhkvQWNxM5Lo8TCPwtAbuovoOqxBa+hBdVBiuRfLvvapq+TEiqoVq7q27C3umDzEUHAK4UwOmHbi7A5LBGkxL+2mSsciK37sZlSqp4eVz6ezG0at6f/FpLdjlPgvNOPS8ZxivXgyYJIpd7s5yyvYmEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h2x+OI1C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h2x+OI1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858E31F000E9;
	Tue,  7 Jul 2026 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783454421;
	bh=xsvi5/am9xAVNYcJqBW7CPJ+CHqfHRiFmJHa9y/dZWM=;
	h=Date:To:From:Subject;
	b=h2x+OI1CMmXR9YguyqnhUba6oSWj8PwRcG670PEYq7SXMcF9mpOmvFUm/dYm0zGoQ
	 RVtI6p4S44IHso/SIyVPMGLyGTWkKwT0dq+NWuk6hiSI+jsQdDZVXrMWMZ+MxKYQz+
	 UlnG6i3vtMPAmtO+ZZHoM6JjFXXHlHCeVVqC6x8w=
Date: Tue, 07 Jul 2026 13:00:21 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-stop-cpus-that-lose-the-panic_redirect_cpu-race.patch added to mm-nonmm-unstable branch
Message-Id: <20260707200021.858E31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: stop CPUs that lose the panic_redirect_cpu race
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-stop-cpus-that-lose-the-panic_redirect_cpu-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-stop-cpus-that-lose-the-panic_redirect_cpu-race.patch

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
From: Bradley Morgan <include@grrlz.net>
Subject: panic: stop CPUs that lose the panic_redirect_cpu race
Date: Tue, 7 Jul 2026 18:32:53 +0000

Loser of the redirect cmpxchg must stop, not fall through to
panic_try_start().

This issue was found by sashiko [1].

Link: https://lore.kernel.org/20260707183253.9793-1-include@grrlz.net
Link: https://sashiko.dev/#/patchset/20260705164123.18746-1-include%40grrlz.net [1]
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/kernel/panic.c~panic-stop-cpus-that-lose-the-panic_redirect_cpu-race
+++ a/kernel/panic.c
@@ -400,12 +400,9 @@ static bool panic_try_force_cpu(const ch
 	if (panic_in_progress())
 		return false;
 
-	/*
-	 * Only one CPU can do the redirect. Use atomic cmpxchg to ensure
-	 * we don't race with another CPU also trying to redirect.
-	 */
+	/* Which CPU won the race? */
 	if (!atomic_try_cmpxchg(&panic_redirect_cpu, &old_cpu, this_cpu))
-		return false;
+		return old_cpu != this_cpu;
 
 	/*
 	 * Use dynamically allocated buffer if available, otherwise
_

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch
signal-avoid-shared-siginfo-namespace-rewrites.patch
panic-fix-va_list-reuse-in-panic_try_force_cpu.patch
reboot-use-lookup-tables-for-sysfs-mode-and-type-strings.patch
reboot-use-a-lookup-table-for-hw_protection_action-strings.patch
panic-stop-cpus-that-lose-the-panic_redirect_cpu-race.patch

