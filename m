Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8BB34C130
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338658; cv=none; b=uvVsLUcffK7EVhrU4TutLQ9dvKvyBwl0XyIwmReSZ5Sxg3U2ktWQRnbUE0UTPGFA30GU5GC30cmzzrlDIsSWu+uSz2x44i4PdU6/8dcsezmTdrbE52ZUqweRdWaevJZ9OsWT7v3EAyS/JW2n21mWXcXUWoLGiL38v3zhSXRFth8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338658; c=relaxed/simple;
	bh=cNr1A28wjFQAYuJvR0u6HjhBx/xVs+zwsl1z8Yn4XH0=;
	h=Date:To:From:Subject:Message-Id; b=u8OIf6ROFT5Qv/4mmwtniPuIbJ0iCkBnfzL+hKnt21T5EzMa84MXrlWG3tU6lwfTkk1vWmwWEyxCPBa4q5b/GwNAl6iyfhq3r/cPG0qemI3PMLoYr+zGsl8ftZ1sBzBCT5MauJnyhHpGiC0Nbp2BwC21RJqYOdH/XPvjdQEvTWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gcKf+Eit; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gcKf+Eit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C1D1F0089B;
	Wed,  7 Oct 2026 02:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338656;
	bh=K1hQvzGjfQHBCUpJM+O9+T1xIBwPRKdMAjuhR1HEfoo=;
	h=Date:To:From:Subject;
	b=gcKf+EitSu64HyJigIMeiWLeldojr7PhXRMH6VKwjoi8pGRmeJbuVXaapPcLQlSLR
	 Pr5CqqUNnEuIRKgwkp5zTH3tbuGJlfFvY1ct6Bkjc+rusSz0m6k7qD17REp1ED4Om2
	 B+v4F2JfQBZWWuac8mK58YKYB9JV6E5ZUFxol0bk=
Date: Tue, 06 Oct 2026 19:04:15 -0700
To: mm-commits@vger.kernel.org,steve@abita.co,sean@ashe.io,pmladek@suse.com,nick.lange@gmail.com,neelx@suse.com,mproche@gmail.com,mhiramat@kernel.org,lance.yang@linux.dev,david.laight.linux@gmail.com,chjohnst@gmail.com,brads@mainlining.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-log-summary-line-when-warning-budget-is-exhausted.patch removed from -mm tree
Message-Id: <20261007020416.58C1D1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: log summary line when warning budget is exhausted
has been removed from the -mm tree.  Its filename was
     hung_task-log-summary-line-when-warning-budget-is-exhausted.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


