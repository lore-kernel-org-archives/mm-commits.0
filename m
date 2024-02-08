Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C747667C4D;
	Thu,  8 Feb 2024 05:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369671; cv=none; b=toi8OqK4ukGYm76fE2o5AprKr9f0VcS10trUnBTmdlW+jvzI6av+XjgzZr0mrWHOM4sRLXocM423y4mwtu8I5fvCK2z9chscO1n63HdDeEaoI2Q+HF5hkByLwuXQMYbz749T7hEXryWLQNVB9F6M5eHlr6Juq/iOUZ8ImQnPZ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369671; c=relaxed/simple;
	bh=7Aq+/DIPZU3B6qihKtTr3KzQDLG6UTcLkzlPPJLFpy0=;
	h=Date:To:From:Subject:Message-Id; b=CrGSRS7CtWxf+8vj7d+qSvbebtMPeIx3m8bdRv6vzAhWDkvJygD/lbHNbMWqVlBBYNs47PA0wEQZBiErAWDTpLbsCkVOzzexhL9sTY9yWPgtxY5V9mLMMvu16gGfXEdLAizhc1wv1tZ0ADQjglHkZVhAUYRb/LRS9UybCXnW1A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JJYnXx6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JJYnXx6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905B8C43394;
	Thu,  8 Feb 2024 05:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369671;
	bh=7Aq+/DIPZU3B6qihKtTr3KzQDLG6UTcLkzlPPJLFpy0=;
	h=Date:To:From:Subject:From;
	b=JJYnXx6fOSGY0KEuU0jXd5pzu+Q06uKPRjzsKtLuBV9GlQRPKz5vNo35whUf2GdPQ
	 G8yDd1M5Jgw/AUP8dTJuqnqQKRyqi91wUxpJWTEgqHLNoDttxWR/fxluzoQBFaoSaA
	 X0a9lePQetyiRHK5Ah1Rq+jNLvIB3J5SGufdwQ+M=
Date: Wed, 07 Feb 2024 21:21:11 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ebiederm@xmission.com,dylanbhatch@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-proc-do_task_stat-use-sig-stats_lock-to-gather-the-threads-children-stats.patch removed from -mm tree
Message-Id: <20240208052111.905B8C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc: do_task_stat: use sig->stats_lock to gather the threads/children stats
has been removed from the -mm tree.  Its filename was
     fs-proc-do_task_stat-use-sig-stats_lock-to-gather-the-threads-children-stats.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/proc: do_task_stat: use sig->stats_lock to gather the threads/children stats
Date: Tue, 23 Jan 2024 16:33:57 +0100

lock_task_sighand() can trigger a hard lockup.  If NR_CPUS threads call
do_task_stat() at the same time and the process has NR_THREADS, it will
spin with irqs disabled O(NR_CPUS * NR_THREADS) time.

Change do_task_stat() to use sig->stats_lock to gather the statistics
outside of ->siglock protected section, in the likely case this code will
run lockless.

Link: https://lkml.kernel.org/r/20240123153357.GA21857@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   58 +++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

--- a/fs/proc/array.c~fs-proc-do_task_stat-use-sig-stats_lock-to-gather-the-threads-children-stats
+++ a/fs/proc/array.c
@@ -477,13 +477,13 @@ static int do_task_stat(struct seq_file
 	int permitted;
 	struct mm_struct *mm;
 	unsigned long long start_time;
-	unsigned long cmin_flt = 0, cmaj_flt = 0;
-	unsigned long  min_flt = 0,  maj_flt = 0;
-	u64 cutime, cstime, utime, stime;
-	u64 cgtime, gtime;
+	unsigned long cmin_flt, cmaj_flt, min_flt, maj_flt;
+	u64 cutime, cstime, cgtime, utime, stime, gtime;
 	unsigned long rsslim = 0;
 	unsigned long flags;
 	int exit_code = task->exit_code;
+	struct signal_struct *sig = task->signal;
+	unsigned int seq = 1;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -511,12 +511,8 @@ static int do_task_stat(struct seq_file
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
-	cutime = cstime = 0;
-	cgtime = gtime = 0;
 
 	if (lock_task_sighand(task, &flags)) {
-		struct signal_struct *sig = task->signal;
-
 		if (sig->tty) {
 			struct pid *pgrp = tty_get_pgrp(sig->tty);
 			tty_pgrp = pid_nr_ns(pgrp, ns);
@@ -527,27 +523,9 @@ static int do_task_stat(struct seq_file
 		num_threads = get_nr_threads(task);
 		collect_sigign_sigcatch(task, &sigign, &sigcatch);
 
-		cmin_flt = sig->cmin_flt;
-		cmaj_flt = sig->cmaj_flt;
-		cutime = sig->cutime;
-		cstime = sig->cstime;
-		cgtime = sig->cgtime;
 		rsslim = READ_ONCE(sig->rlim[RLIMIT_RSS].rlim_cur);
 
-		/* add up live thread stats at the group level */
 		if (whole) {
-			struct task_struct *t;
-
-			__for_each_thread(sig, t) {
-				min_flt += t->min_flt;
-				maj_flt += t->maj_flt;
-				gtime += task_gtime(t);
-			}
-
-			min_flt += sig->min_flt;
-			maj_flt += sig->maj_flt;
-			gtime += sig->gtime;
-
 			if (sig->flags & (SIGNAL_GROUP_EXIT | SIGNAL_STOP_STOPPED))
 				exit_code = sig->group_exit_code;
 		}
@@ -562,6 +540,34 @@ static int do_task_stat(struct seq_file
 	if (permitted && (!whole || num_threads < 2))
 		wchan = !task_is_running(task);
 
+	do {
+		seq++; /* 2 on the 1st/lockless path, otherwise odd */
+		flags = read_seqbegin_or_lock_irqsave(&sig->stats_lock, &seq);
+
+		cmin_flt = sig->cmin_flt;
+		cmaj_flt = sig->cmaj_flt;
+		cutime = sig->cutime;
+		cstime = sig->cstime;
+		cgtime = sig->cgtime;
+
+		if (whole) {
+			struct task_struct *t;
+
+			min_flt = sig->min_flt;
+			maj_flt = sig->maj_flt;
+			gtime = sig->gtime;
+
+			rcu_read_lock();
+			__for_each_thread(sig, t) {
+				min_flt += t->min_flt;
+				maj_flt += t->maj_flt;
+				gtime += task_gtime(t);
+			}
+			rcu_read_unlock();
+		}
+	} while (need_seqretry(&sig->stats_lock, seq));
+	done_seqretry_irqrestore(&sig->stats_lock, seq, flags);
+
 	if (whole) {
 		thread_group_cputime_adjusted(task, &utime, &stime);
 	} else {
_

Patches currently in -mm which might be from oleg@redhat.com are

ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch

