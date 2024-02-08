Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1919B67A1B;
	Thu,  8 Feb 2024 05:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369671; cv=none; b=sFi9IIYhb1GMQjr7JM751ljt6nBUU1M9m3AJppo60mhCJifHT8GD+nRPkN+ZCgLRy4fIHWrKUkVv8dU4SMza39xRNdhnZCmLJw6dcK9S5JX3VDcOa8T1g0AWoCo/qjQAL8M/JNGHXx9zt2E5QBVmBsZkhKx54I6fYLFEx/WfArg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369671; c=relaxed/simple;
	bh=cv3T42VnNAuPLv+dihtXU8586SWZPKhf4kfWaxHuYlQ=;
	h=Date:To:From:Subject:Message-Id; b=Zwl3hinDOUvC7Upf110Zm9wVgP793E8M/VY1JxVUdhAhl2DWMfA/osplxoqaXHJ/wsrv20PPG1Imfi1BnccIrDmnmfn8bcQWlUR285La1Ns5F2udEBcQu4umXUsLhl9dYt8TWgU0Kzc866IjxUmLa/wzJOSg8MunbCO8rMMEkDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E2B+BITx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E2B+BITx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843A3C433C7;
	Thu,  8 Feb 2024 05:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369670;
	bh=cv3T42VnNAuPLv+dihtXU8586SWZPKhf4kfWaxHuYlQ=;
	h=Date:To:From:Subject:From;
	b=E2B+BITxj5LyNoGxrWCp7UKmqafbMGyDx50JKmqMT1X6JoXn9wfpcXJ/ZY1BXH9JE
	 ibT9/VzI2B42ZeOoeUohrxbILJeJp/HQt988vZVurvwnymBHcxwzuNW/uY146x9rZ4
	 l4euFHX1MlsxUCqw2NEWp/iGi9yTAd3AVM2dx4y4=
Date: Wed, 07 Feb 2024 21:21:09 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ebiederm@xmission.com,dylanbhatch@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-proc-do_task_stat-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch removed from -mm tree
Message-Id: <20240208052110.843A3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc: do_task_stat: move thread_group_cputime_adjusted() outside of lock_task_sighand()
has been removed from the -mm tree.  Its filename was
     fs-proc-do_task_stat-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch

