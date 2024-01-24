Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B238C08;
	Wed, 24 Jan 2024 10:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091452; cv=none; b=jkL1BFqet7MYI82m0Ypb3ET241SbIDswcpGcTpd4oWzR1Kkb78P49ag+kJbWI0Qk64mrqU/pltQsMsOtXmekdvDTUYDZi7y/Kwcu9Py2fiRBEMxsLE+OjjHlKEyd7SYmVHGQAlLKfU8gjg98ZwI1eolW+7JaBOYz42hjC3bhhI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091452; c=relaxed/simple;
	bh=O9A6yBZds1dVCfzvTKLXF7jzI6MmPn1h8mNNvyWzHao=;
	h=Date:To:From:Subject:Message-Id; b=aOthA9xqIcTOGeRVm24p03KaVeVRSrzTq2Hzdh5QNiz/Cn/ZGcItF5pCit2uveU/YdQ8zqq5TOCq13rbDUx70FE17gSY71Wt4qTeSG8MVUuqbHbB9+6LtS8MGDjn4GMmVZ28ur8ghYNlcFWYUrae1IgbFU7t1QOsgA1OE9rS9yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bue/JsSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bue/JsSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08858C43390;
	Wed, 24 Jan 2024 10:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091452;
	bh=O9A6yBZds1dVCfzvTKLXF7jzI6MmPn1h8mNNvyWzHao=;
	h=Date:To:From:Subject:From;
	b=Bue/JsSyfkyAqmqoImWccbiysCt1wZ0NM+IaGD6wGyyDDb1U2FEBuUS5XYFA7Sk0l
	 AelKMFsu7uZvtSgk+asBGGDJ2f9LJb828zfufXfeedBb4tMi6KIOslHTaK/Wh1RODi
	 CcCxmCuq0wptw0myEXOj5VmWXQHwD/S+5JgpUeUE=
Date: Wed, 24 Jan 2024 02:17:29 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ebiederm@xmission.com,dylanbhatch@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + exit-wait_task_zombie-kill-the-no-longer-necessary-spin_lock_irqsiglock.patch added to mm-hotfixes-unstable branch
Message-Id: <20240124101732.08858C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: exit: wait_task_zombie: kill the no longer necessary spin_lock_irq(siglock)
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     exit-wait_task_zombie-kill-the-no-longer-necessary-spin_lock_irqsiglock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/exit-wait_task_zombie-kill-the-no-longer-necessary-spin_lock_irqsiglock.patch

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
Subject: exit: wait_task_zombie: kill the no longer necessary spin_lock_irq(siglock)
Date: Tue, 23 Jan 2024 16:34:00 +0100

After the recent changes nobody use siglock to read the values protected
by stats_lock, we can kill spin_lock_irq(&current->sighand->siglock) and
update the comment.

With this patch only __exit_signal() and thread_group_start_cputime() take
stats_lock under siglock.

Link: https://lkml.kernel.org/r/20240123153359.GA21866@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/kernel/exit.c~exit-wait_task_zombie-kill-the-no-longer-necessary-spin_lock_irqsiglock
+++ a/kernel/exit.c
@@ -1127,17 +1127,14 @@ static int wait_task_zombie(struct wait_
 		 * and nobody can change them.
 		 *
 		 * psig->stats_lock also protects us from our sub-threads
-		 * which can reap other children at the same time. Until
-		 * we change k_getrusage()-like users to rely on this lock
-		 * we have to take ->siglock as well.
+		 * which can reap other children at the same time.
 		 *
 		 * We use thread_group_cputime_adjusted() to get times for
 		 * the thread group, which consolidates times for all threads
 		 * in the group including the group leader.
 		 */
 		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
-		spin_lock_irq(&current->sighand->siglock);
-		write_seqlock(&psig->stats_lock);
+		write_seqlock_irq(&psig->stats_lock);
 		psig->cutime += tgutime + sig->cutime;
 		psig->cstime += tgstime + sig->cstime;
 		psig->cgtime += task_gtime(p) + sig->gtime + sig->cgtime;
@@ -1160,8 +1157,7 @@ static int wait_task_zombie(struct wait_
 			psig->cmaxrss = maxrss;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
-		write_sequnlock(&psig->stats_lock);
-		spin_unlock_irq(&current->sighand->siglock);
+		write_sequnlock_irq(&psig->stats_lock);
 	}
 
 	if (wo->wo_rusage)
_

Patches currently in -mm which might be from oleg@redhat.com are

getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch
getrusage-use-sig-stats_lock-rather-than-lock_task_sighand.patch
fs-proc-do_task_stat-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch
fs-proc-do_task_stat-use-sig-stats_lock-to-gather-the-threads-children-stats.patch
exit-wait_task_zombie-kill-the-no-longer-necessary-spin_lock_irqsiglock.patch
ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch

