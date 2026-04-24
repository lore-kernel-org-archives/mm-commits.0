Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE3519CCF5;
	Fri, 24 Apr 2026 16:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777048987; cv=none; b=s4106k7CpLG9KXTq/iADhROZfySPC51StOiIb31+Cg+JEeIX5P8FNpWZpT0bqODph5oETlJIarJ2PFWnIul4lGJ25tlQC0goQbbnAd9T2o+yrzkuVFLrNi5NA4hbeCN5XJtXVGSj5UeVTiJnyZXmWs7TX9Rd9lu2gchPikBipyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777048987; c=relaxed/simple;
	bh=lVrWuISnAX3cWzHsUBJCTF+WP7hg/DzLZ0tOb6JVFc8=;
	h=Date:To:From:Subject:Message-Id; b=Nx5eMj8744+tVc/HGn7doyW1FIiR9rHgTNywjTQeNKnD2RDWrluzkeBoX5C/UIo0BIxaOYSYxyHM0qi+Lgo7R4Zmgo2fAwpVQH6o6KNajbv5xGvRe8WRY3cBzZSJXEhqeSeSNV/2Kghsd8D+tR4e3n0fs1fB0Uz8/kLMUVDk4Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O2mish4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O2mish4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC6FC2BCB2;
	Fri, 24 Apr 2026 16:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777048987;
	bh=lVrWuISnAX3cWzHsUBJCTF+WP7hg/DzLZ0tOb6JVFc8=;
	h=Date:To:From:Subject:From;
	b=O2mish4RxtmIyHE9LEJffpoczpGJJwtutPxcllah4cAloLchDFNbJV7M+3peHpADf
	 z7pNl9epX+s5kAhfR8QtWLpN51czxIbo2AbxGrIcrVnURoXp6v3pf375kYMc/3/8gM
	 vwdQs5fi3LeD1eDzMk8jqJofqHL2KBF9XE7I22/E=
Date: Fri, 24 Apr 2026 09:43:06 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,thomas.orgis@uni-hamburg.de,stable@vger.kernel.org,oleg@redhat.com,balbirs@nvidia.com,cyyzero16@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-retain-dead-thread-stats-in-tgid-queries.patch added to mm-nonmm-unstable branch
Message-Id: <20260424164307.5AC6FC2BCB2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taskstats: retain dead thread stats in TGID queries
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-retain-dead-thread-stats-in-tgid-queries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-retain-dead-thread-stats-in-tgid-queries.patch

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
From: Yiyang Chen <cyyzero16@gmail.com>
Subject: taskstats: retain dead thread stats in TGID queries
Date: Mon, 13 Apr 2026 23:45:44 +0800

Patch series "taskstats: fix TGID dead-thread stat retention", v3.

This series fixes a taskstats TGID aggregation bug where fields added in
the TGID query path were not preserved after thread exit, and adds a
kselftest covering the regression.

The first patch keeps the cached TGID aggregate used for dead threads in
step with the fields already accumulated for live threads, and also fixes
the final TGID exit notification emitted when group_dead is true.

The second patch adds a kselftest that verifies TGID CPU stats do not
regress after a worker thread exits and has been reaped.


This patch (of 2):

fill_stats_for_tgid() builds TGID stats from two sources: the cached
aggregate in signal->stats and a scan of the live threads in the group.

However, fill_tgid_exit() only accumulates delay accounting into
signal->stats.  This means that once a thread exits, TGID queries lose the
fields that fill_stats_for_tgid() adds for live threads.

This gap was introduced incrementally by two earlier changes that extended
fill_stats_for_tgid() but did not make the corresponding update to
fill_tgid_exit():

- commit 8c733420bdd5 ("taskstats: add e/u/stime for TGID command")
  added ac_etime, ac_utime, and ac_stime to the TGID query path.
- commit b663a79c1915 ("taskstats: add context-switch counters")
  added nvcsw and nivcsw to the TGID query path.

As a result, those fields were accounted for live threads in TGID queries,
but were dropped from the cached TGID aggregate after thread exit.  The
final TGID exit notification emitted when group_dead is true also copies
that cached aggregate, so it loses the same fields.

Factor the per-task TGID accumulation into tgid_stats_add_task() and use
it in both fill_stats_for_tgid() and fill_tgid_exit().  This keeps the
cached aggregate used for dead threads aligned with the live-thread
accumulation used by TGID queries.

Link: https://lore.kernel.org/cover.1776094300.git.cyyzero16@gmail.com
Link: https://lore.kernel.org/abd2a15d33343636ab5ba43d540bcfe508bd66c7.1776094300.git.cyyzero16@gmail.com
Fixes: 8c733420bdd5 ("taskstats: add e/u/stime for TGID command")
Fixes: b663a79c1915 ("taskstats: add context-switch counters")
Signed-off-by: Yiyang Chen <cyyzero16@gmail.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Cc: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |   62 ++++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

--- a/kernel/taskstats.c~taskstats-retain-dead-thread-stats-in-tgid-queries
+++ a/kernel/taskstats.c
@@ -210,13 +210,39 @@ static int fill_stats_for_pid(pid_t pid,
 	return 0;
 }
 
+static void tgid_stats_add_task(struct taskstats *stats,
+				struct task_struct *tsk, u64 now_ns)
+{
+	u64 delta, utime, stime;
+
+	/*
+	 * Each accounting subsystem calls its functions here to
+	 * accumulate its per-task stats for tsk, into the per-tgid structure
+	 *
+	 *	per-task-foo(stats, tsk);
+	 */
+	delayacct_add_tsk(stats, tsk);
+
+	/* calculate task elapsed time in nsec */
+	delta = now_ns - tsk->start_time;
+	/* Convert to micro seconds */
+	do_div(delta, NSEC_PER_USEC);
+	stats->ac_etime += delta;
+
+	task_cputime(tsk, &utime, &stime);
+	stats->ac_utime += div_u64(utime, NSEC_PER_USEC);
+	stats->ac_stime += div_u64(stime, NSEC_PER_USEC);
+
+	stats->nvcsw += tsk->nvcsw;
+	stats->nivcsw += tsk->nivcsw;
+}
+
 static int fill_stats_for_tgid(pid_t tgid, struct taskstats *stats)
 {
 	struct task_struct *tsk, *first;
 	unsigned long flags;
 	int rc = -ESRCH;
-	u64 delta, utime, stime;
-	u64 start_time;
+	u64 now_ns;
 
 	/*
 	 * Add additional stats from live tasks except zombie thread group
@@ -233,30 +259,12 @@ static int fill_stats_for_tgid(pid_t tgi
 	else
 		memset(stats, 0, sizeof(*stats));
 
-	start_time = ktime_get_ns();
+	now_ns = ktime_get_ns();
 	for_each_thread(first, tsk) {
 		if (tsk->exit_state)
 			continue;
-		/*
-		 * Accounting subsystem can call its functions here to
-		 * fill in relevant parts of struct taskstsats as follows
-		 *
-		 *	per-task-foo(stats, tsk);
-		 */
-		delayacct_add_tsk(stats, tsk);
-
-		/* calculate task elapsed time in nsec */
-		delta = start_time - tsk->start_time;
-		/* Convert to micro seconds */
-		do_div(delta, NSEC_PER_USEC);
-		stats->ac_etime += delta;
-
-		task_cputime(tsk, &utime, &stime);
-		stats->ac_utime += div_u64(utime, NSEC_PER_USEC);
-		stats->ac_stime += div_u64(stime, NSEC_PER_USEC);
 
-		stats->nvcsw += tsk->nvcsw;
-		stats->nivcsw += tsk->nivcsw;
+		tgid_stats_add_task(stats, tsk, now_ns);
 	}
 
 	unlock_task_sighand(first, &flags);
@@ -275,18 +283,14 @@ out:
 static void fill_tgid_exit(struct task_struct *tsk)
 {
 	unsigned long flags;
+	u64 now_ns;
 
 	spin_lock_irqsave(&tsk->sighand->siglock, flags);
 	if (!tsk->signal->stats)
 		goto ret;
 
-	/*
-	 * Each accounting subsystem calls its functions here to
-	 * accumalate its per-task stats for tsk, into the per-tgid structure
-	 *
-	 *	per-task-foo(tsk->signal->stats, tsk);
-	 */
-	delayacct_add_tsk(tsk->signal->stats, tsk);
+	now_ns = ktime_get_ns();
+	tgid_stats_add_task(tsk->signal->stats, tsk, now_ns);
 ret:
 	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
 	return;
_

Patches currently in -mm which might be from cyyzero16@gmail.com are

tools-accounting-getdelays-fix-wformat-truncation-warning-in-format_timespec.patch
taskstats-retain-dead-thread-stats-in-tgid-queries.patch
selftests-acct-add-taskstats-tgid-retention-test.patch

