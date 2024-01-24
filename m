Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E81A18B09;
	Wed, 24 Jan 2024 10:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091449; cv=none; b=npJBX8Z1jrkX4qT4TmmWipaAxYYLGmeHPchb/NkNH+iEBf30P9yjKLnC7emr/+rKz3jbRSu8Ufo9NyVVu0kM1k4GWMSvEefaYqIopzV9KfmZ8hSHG4hR2opCice0gIGCUAp9j33ru8UAjIdZOhJQPgQQF+V4K/I1Zqv5NMKn4uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091449; c=relaxed/simple;
	bh=xewqOWNToJccyxc7C9N9xqz03PibygApLAZ2FuD96/Q=;
	h=Date:To:From:Subject:Message-Id; b=RcqvnBt7iK0/bZbmJZZGB5PR/EAhY+5ALkybTjD2MVL3kfE5ZfbXNLp+RZEDDAUyBJUnW906Q4m+IEw8urZvR3YpBQrYkMgr0nCpqGr+spyeXZOeF3yFprWNc+yzW56MN4sjbAmL6qK2jzczKdtnWFGzq7asCC2yW0E3DIHj6ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JL7Pf3m/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JL7Pf3m/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF51EC433C7;
	Wed, 24 Jan 2024 10:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091449;
	bh=xewqOWNToJccyxc7C9N9xqz03PibygApLAZ2FuD96/Q=;
	h=Date:To:From:Subject:From;
	b=JL7Pf3m/Jy5ExaIAIa7HFl38aJKf+U9CzRnD5OKWaQVJ7MHKVTcYNJfS5cRQNLQY5
	 c3540DmuYdSMGIyIyGa4P7+Y01O+FoZeqOUYT/7Wi8RxMwDrUuQccm5vv32ORKLs5v
	 iMKrQr75BH+iwEYzL4mxCvENZxCS17cPDBw9P+E4=
Date: Wed, 24 Jan 2024 02:17:26 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ebiederm@xmission.com,dylanbhatch@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-do_task_stat-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch added to mm-hotfixes-unstable branch
Message-Id: <20240124101728.DF51EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc: do_task_stat: move thread_group_cputime_adjusted() outside of lock_task_sighand()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-do_task_stat-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-do_task_stat-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch

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
Subject: fs/proc: do_task_stat: move thread_group_cputime_adjusted() outside of lock_task_sighand()
Date: Tue, 23 Jan 2024 16:33:55 +0100

Patch series "fs/proc: do_task_stat: use sig->stats_".

do_task_stat() has the same problem as getrusage() had before "getrusage:
use sig->stats_lock rather than lock_task_sighand()": a hard lockup.  If
NR_CPUS threads call lock_task_sighand() at the same time and the process
has NR_THREADS, spin_lock_irq will spin with irqs disabled O(NR_CPUS *
NR_THREADS) time.


This patch (of 3):

thread_group_cputime() does its own locking, we can safely shift
thread_group_cputime_adjusted() which does another for_each_thread loop
outside of ->siglock protected section.

Not only this removes for_each_thread() from the critical section with
irqs disabled, this removes another case when stats_lock is taken with
siglock held.  We want to remove this dependency, then we can change the
users of stats_lock to not disable irqs.

Link: https://lkml.kernel.org/r/20240123153313.GA21832@redhat.com
Link: https://lkml.kernel.org/r/20240123153355.GA21854@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/proc/array.c~fs-proc-do_task_stat-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand
+++ a/fs/proc/array.c
@@ -511,7 +511,7 @@ static int do_task_stat(struct seq_file
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
-	cutime = cstime = utime = stime = 0;
+	cutime = cstime = 0;
 	cgtime = gtime = 0;
 
 	if (lock_task_sighand(task, &flags)) {
@@ -546,7 +546,6 @@ static int do_task_stat(struct seq_file
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_cputime_adjusted(task, &utime, &stime);
 			gtime += sig->gtime;
 
 			if (sig->flags & (SIGNAL_GROUP_EXIT | SIGNAL_STOP_STOPPED))
@@ -562,10 +561,13 @@ static int do_task_stat(struct seq_file
 
 	if (permitted && (!whole || num_threads < 2))
 		wchan = !task_is_running(task);
-	if (!whole) {
+
+	if (whole) {
+		thread_group_cputime_adjusted(task, &utime, &stime);
+	} else {
+		task_cputime_adjusted(task, &utime, &stime);
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
-		task_cputime_adjusted(task, &utime, &stime);
 		gtime = task_gtime(task);
 	}
 
_

Patches currently in -mm which might be from oleg@redhat.com are

getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch
getrusage-use-sig-stats_lock-rather-than-lock_task_sighand.patch
fs-proc-do_task_stat-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch
fs-proc-do_task_stat-use-sig-stats_lock-to-gather-the-threads-children-stats.patch
exit-wait_task_zombie-kill-the-no-longer-necessary-spin_lock_irqsiglock.patch
ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch

