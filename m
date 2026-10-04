Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1951A47F3D4
	for <mm-commits@vger.kernel.org>; Sun,  4 Oct 2026 18:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791138521; cv=none; b=HsNBzEXyknThNlbMedj39pncmfEDU6FkUAj9+7WxY1FSFxqq56In8yh9KjPoxvaSaEPaas5AFEUyRGv/LGFyhtkX5Wbw+IOvh6mnBKDmVd/ertxiB/SY4hoY+8Umtrmk9ele2wSJaVoMWnFCeSlpI7SNnCJthy0B8EDOxkNeP3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791138521; c=relaxed/simple;
	bh=o4L/o7x0lJ05btyFA15REMY12kLiJyW43s6HE0N1tQs=;
	h=Date:To:From:Subject:Message-Id; b=BGgZCmBEE0Qamg9LZ01Wk2lHF+GxR6+DVIrYOLRSSRGpcaksR7MO8CCXsoZUY3Y02h4e4NAnTYcQvIkWzIIzrSM2L8QUJOtbCR0EryQwfnOxRbryVgM/fRZKjGzlamse5Yc/NzHQUKJixGKWIIlVPR8zdD051RpnRvioXayL8LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wmFyeKS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wmFyeKS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1271F000FF;
	Sun,  4 Oct 2026 18:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791138519;
	bh=alLgtAn1zEnZPFzCLSbE0jjN+qQ4VyDqKtdfsdG/5Sk=;
	h=Date:To:From:Subject;
	b=wmFyeKS4zFHhVsP9YG9yPt2lOXKffhVToBFCZkCe8e+mLlhjyjq14QZFs5tP1m5Oe
	 sByTbM9X5lJ/D7Fj9O/MmUs3fUevCAcnv5+/5YO6igZsINLDB8TJ6PSIlsKCorgd7C
	 OGkyPo9oB1TTN5VybAtRb78UmLtAMnsVuUtrMTWk=
Date: Sun, 04 Oct 2026 11:28:39 -0700
To: mm-commits@vger.kernel.org,steve@abita.co,sean@ashe.io,pmladek@suse.com,nick.lange@gmail.com,neelx@suse.com,mproche@gmail.com,mhiramat@kernel.org,lance.yang@linux.dev,david.laight.linux@gmail.com,chjohnst@gmail.com,brads@mainlining.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-log-summary-line-when-warning-budget-is-exhausted.patch added to mm-nonmm-unstable branch
Message-Id: <20261004182839.9B1271F000FF@smtp.kernel.org>
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
Date: Sun,  4 Oct 2026 12:36:10 -0400

Once the warning budget is exhausted, hung_task_info() normally stops
printing per-task details. When panic is triggered, full details are
still printed so diagnostics remain available before panic.

To retain visibility without restoring per-task output after budget
exhaustion, emit a single aggregate summary line at the end of each
watchdog scan that detects hung tasks with an exhausted budget. This
keeps non-panic per-task reports budgeted during system-wide hangs.

Link: https://lore.kernel.org/20261004163610.413506-3-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Daniel Vacek <neelx@suse.com>
Cc: Sean Ashe <sean@ashe.io>
Cc: <chjohnst@gmail.com>
Cc: <steve@abita.co>
Cc: <mproche@gmail.com>
Cc: <nick.lange@gmail.com>
---

 kernel/hung_task.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/hung_task.c~hung_task-log-summary-line-when-warning-budget-is-exhausted
+++ a/kernel/hung_task.c
@@ -276,8 +276,8 @@ static void hung_task_info(struct task_s
 		sched_show_task(t);
 		debug_show_blocker(t, timeout);
 
-		if (!hung_task_warnings_budget)
-			pr_info("Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings\n");
+		if (!hung_task_warnings_budget && !hung_task_call_panic)
+			pr_info("hung_task: further per-task details suppressed until warning budget is reset (see sysctl kernel.hung_task_warnings)\n");
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

