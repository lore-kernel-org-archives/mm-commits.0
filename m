Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8852030DEDC
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 19:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783278638; cv=none; b=fYtmvVi7b6L+kH/yJn5lg5+UO1zse18yb8bEWGeUTMoEdIgu6YTWQ+QXpI+s5w2gr9/jwhfCm0ND4pJ1WknXjH5fx9acL71iMm0hTgQvvoluiswv+SQcNxk5AvsckqTXjq35TwBGmt2U/Y2N6Fyh+6KgJj+jJ12XvJmlZSO3AFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783278638; c=relaxed/simple;
	bh=xmzVrh9NlUHBL3wiHI0XaMTvBZBxOLblO5PFwezHTH0=;
	h=Date:To:From:Subject:Message-Id; b=d0UNk2NcCwavHbSUGYx8n9IvlGhJ8CXyfzSnmvxlaVTWLpwJt0yuFv7icWzihc0yO59vvE42V+eAo7KsYgffrtof4Kbk9T58oiZOGG7zsFLZQyNl3tmM9RK7jwIgGK2yKeQt0grMR3BT6jdlTLpel0DsT+NRUkSx4igmIvD9804=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=12q062VK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="12q062VK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B051F000E9;
	Sun,  5 Jul 2026 19:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783278637;
	bh=8ARWOBjo2hfmR1+kO//P7sL8VZ+eB+bWU0GiJgWVAd8=;
	h=Date:To:From:Subject;
	b=12q062VKONyospmym9M5cUQIjztOkeU1o3Dw5zqAa46wfkiqwOHxLUa9H9ot23BnN
	 sL19cscMc4PZ9ivy1CM5IU70lifpTWUTZ0m7FoLYtptPKI3IZrUllR1g3I73Kk/Dx8
	 T/w+MzufA1B3VIfNNNGilrpJPhrz8FO1c/OAN8kA=
Date: Sun, 05 Jul 2026 12:10:36 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,pmladek@suse.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-fix-va_list-reuse-in-panic_try_force_cpu.patch added to mm-nonmm-unstable branch
Message-Id: <20260705191037.36B051F000E9@smtp.kernel.org>
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
From: Bradley Morgan <include@grrlz.net>
Subject: panic: fix va_list reuse in panic_try_force_cpu()
Date: Sun, 5 Jul 2026 16:41:23 +0000

vsnprintf() consumes the caller's va_list. When the redirect fails,
vpanic() reuses it for the panic message, which is undefined
behavior. Use va_copy().

Link: https://lore.kernel.org/20260705164123.18746-1-include@grrlz.net
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/panic.c~panic-fix-va_list-reuse-in-panic_try_force_cpu
+++ a/kernel/panic.c
@@ -412,7 +412,12 @@ static bool panic_try_force_cpu(const ch
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

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch
signal-avoid-shared-siginfo-namespace-rewrites.patch
panic-fix-va_list-reuse-in-panic_try_force_cpu.patch

