Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BA78C08;
	Wed, 24 Jan 2024 10:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091446; cv=none; b=enw2SJFYzZMSVMmCTNe0DvbmGFpNJp/BEkonDeNbK/hJ/oeuGcI10axRxYDLZMORr0+LbhDycdrY7a5S+WR4sKMQ+f7TULj215NfxCxQdq03EzArZxf01rXcJHq4pTkm72eZAe1dsy2qJCMwcbxgq/EBgKzMYHhk7fZXjdzdF2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091446; c=relaxed/simple;
	bh=1WnvG//jyFkx8NotXPlUwRacCiW8tReKOYaJcGAWasQ=;
	h=Date:To:From:Subject:Message-Id; b=as56paY2KiygP2qU0RcMN048gMrmqi2dsy2WLSaxePOCNbyAU67HEZoPYvpAjkMAJdmDOTISoOn/skkwBncFRdJgOX6C+ttBf8+fraZy+DxBGhuQcny6uiLIULmiXdvntFOtQVunz+CfWVpzKZYQqmdS7eahnXqRc6vzPuW4TSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y9zz55bR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y9zz55bR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44CCC433C7;
	Wed, 24 Jan 2024 10:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091446;
	bh=1WnvG//jyFkx8NotXPlUwRacCiW8tReKOYaJcGAWasQ=;
	h=Date:To:From:Subject:From;
	b=Y9zz55bRf+Bb47EQtm/ZVxWHwC1x5isbRv6/MLr6HPOFxn8V8wb91rqldWNFDc2jD
	 LSx9j+bmBeldw524TKDAWGh+F0oFQrsb/4dEY8z74uf6KTO+MYAnzXjjpcmL5HwhiL
	 +XsHo4bTTRAxMQkF5gQ5qZXWkmgsJPToYpKnUYYY=
Date: Wed, 24 Jan 2024 02:17:23 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ebiederm@xmission.com,dylanbhatch@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-do_task_stat-use-sig-stats_lock-to-gather-the-threads-children-stats.patch added to mm-hotfixes-unstable branch
Message-Id: <20240124101725.B44CCC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc: do_task_stat: use sig->stats_lock to gather the threads/children stats
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-do_task_stat-use-sig-stats_lock-to-gather-the-threads-children-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-do_task_stat-use-sig-stats_lock-to-gather-the-threads-children-stats.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch
getrusage-use-sig-stats_lock-rather-than-lock_task_sighand.patch
fs-proc-do_task_stat-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch
fs-proc-do_task_stat-use-sig-stats_lock-to-gather-the-threads-children-stats.patch
exit-wait_task_zombie-kill-the-no-longer-necessary-spin_lock_irqsiglock.patch
ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch

