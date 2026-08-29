Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDADEEA8
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 22:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788043628; cv=none; b=RGGhHIJWO6ze4FVFE1LKRRzgYOtlDvL4A7MYHKwE+9BQEfDp8esLrOFhi45wbnc5WTwk+EqseIVIwfxO1rvn23ny4zduqRGo+vbajbn2t37z9v6X921YhVURQM7d5T/S8Esyh9mexOh1Lyi9wy9MHGLvkdtyro5vtzvThOPChFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788043628; c=relaxed/simple;
	bh=X5akXfxiPE/wk0g+8XbdJNE1N6WxFZu/pYsKr59EBzw=;
	h=Date:To:From:Subject:Message-Id; b=FYirK6gvhQWrg8yHSpXFWKMBFKA7mSpAuCVSqvnyQsGvUnwvhAptzsEBOCsxfuvdWUlbC6anbw6rXeg+VXJXXMrD3/MXJn5kP3DgH0Q7UB2YpmD16OgbKHynm712EN/hcdUHHCq99d0XdgGFM5pSqsMctqRijTnvAIMEE3L9p0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B5vzKvhs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B5vzKvhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597551F000E9;
	Sat, 29 Aug 2026 22:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788043627;
	bh=G9Eh5WWDsDpeLG7yJYCcBw/9Ka7XTq2no57UWBAMpKo=;
	h=Date:To:From:Subject;
	b=B5vzKvhsMWv3tw9KzAXtRQ+zdRwtKUFZZsGalrmnQLEzJIUYYNVOhdPr6//9p2qtw
	 OHKOaD4ECUbWZ+GOeyayKwnWPHSM1lPg9tR9b/QqosGWcCq6gETebF0Z2IzBApgU+i
	 +/eEqXbnRm2uq1zRlT0x3aLLl8Kf5Cr2Mmnqfx7k=
Date: Sat, 29 Aug 2026 15:47:06 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,david.laight.linux@gmail.com,brads@mainlining.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-log-summary-line-when-warning-budget-is-exhausted.patch added to mm-nonmm-unstable branch
Message-Id: <20260829224707.597551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: log summary line when warning budget is exhausted
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-log-summary-line-when-warning-budget-is-exhausted.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-log-summary-line-when-warning-budget-is-exhausted.patch

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
From: Aaron Tomlin <atomlin@atomlin.com>
Subject: hung_task: log summary line when warning budget is exhausted
Date: Sat, 29 Aug 2026 10:53:21 -0400

Once the warning budget is exhausted, hung_task_info() normally stops
printing per-task details.  When panic is triggered, full details are
still printed so diagnostics remain available before panic.

To retain visibility without restoring per-task output after budget
exhaustion, emit a single aggregate summary line at the end of each
watchdog scan that detects hung tasks with an exhausted budget.  This
keeps non-panic per-task reports budgeted during system-wide hangs.

Link: https://lore.kernel.org/20260829145321.18423-3-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/hung_task.c~hung_task-log-summary-line-when-warning-budget-is-exhausted
+++ a/kernel/hung_task.c
@@ -277,7 +277,7 @@ static void hung_task_info(struct task_s
 		debug_show_blocker(t, timeout);
 
 		if (!hung_task_warnings_budget)
-			pr_info("Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings\n");
+			pr_info("hung_task: further per-task details suppressed until warning budget is reset or panic is triggered (see sysctl kernel.hung_task_warnings)\n");
 	}
 
 	touch_nmi_watchdog();
@@ -363,6 +363,10 @@ static void check_hung_uninterruptible_t
 		return;
 	}
 
+	if (!hung_task_warnings_budget && !hung_task_call_panic)
+		pr_info("hung_task: %lu hung tasks detected, warning budget exhausted\n",
+			this_round_count);
+
 	if (need_warning || hung_task_call_panic) {
 		si_mask |= SYS_INFO_LOCKS;
 
_

Patches currently in -mm which might be from atomlin@atomlin.com are

hung_task-reset-warning-budget-when-problem-gets-resolved.patch
hung_task-log-summary-line-when-warning-budget-is-exhausted.patch

