Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A602471435
	for <mm-commits@vger.kernel.org>; Sun,  4 Oct 2026 18:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791138093; cv=none; b=OZW+a6jbaXIE7lopOlZ0gkEGv2mP1rhOVgmAD7X06noKq/JI5r7QMBtn7SemlaBUr6WBH6cBa8OQdEJv1aymL/CrIyuglXsfHatgoMuEradG+wv4dR7g+j2fOOqTp1O90+zg09UyEw/8AzJau8gHgRd6qUoWp5iJaFxhTXd0Suo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791138093; c=relaxed/simple;
	bh=InHyPeCW6ameOspzFj4J/cMOx4oZKvzIUHBQzNfrsmc=;
	h=Date:To:From:Subject:Message-Id; b=j4tKH2XFBaM7xqCwhM2ABeLfEgqAPh4octRyQnLq0sU02R/RXTmPvhfpsEyP1d2p07m1K4/1YVJ5ksX6feWMGIt06A2lwSTQ4dGUe3oW+RN2jKJk3A+jvGjyFaTXrTWA7GUr+vt50oJI9cBMPxBNL7clCUaK4eJU33hqfKPUyYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HtfW/A1O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HtfW/A1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270231F00893;
	Sun,  4 Oct 2026 18:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791138092;
	bh=NAnUf2j43XrikMGkQV0AkFmmhmMiugBrG+rBvQgir50=;
	h=Date:To:From:Subject;
	b=HtfW/A1OOe43n48A3wNhISl+xDlSVSUim3c9fTPUeXBXWSWzLiSe6aezjQweHvl13
	 6CNA/j1janlmwovHBDE9+AFLSFhhSeD8+lzmn44e2eH96x34OvYdfe4i05svwc0j24
	 2fFR++a1ywUnWbHcK45a6thlA+f3VQTva++0naQQ=
Date: Sun, 04 Oct 2026 11:21:31 -0700
To: mm-commits@vger.kernel.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] hung_task-log-summary-line-when-warning-budget-is-exhausted.patch removed from -mm tree
Message-Id: <20261004182132.270231F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: log summary line when warning budget is exhausted
has been removed from the -mm tree.  Its filename was
     hung_task-log-summary-line-when-warning-budget-is-exhausted.patch

This patch was dropped because an updated version will be issued

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
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


