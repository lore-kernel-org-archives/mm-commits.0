Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA7867A17;
	Thu,  8 Feb 2024 05:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369673; cv=none; b=cql2pUJ4AoorU8wO+3wRLu0+hU55GS7CoEHp+TIgp8dYupitX377QiEpg/DFFapm4UALXLIoaza124ANNOMH6BEm7AMcMZBXdUNb2DN7aXIhbZUoUzSDfAcpwzGMhL9n6IO3c9+ViGY5UiT+X2pGwyLGnyRNlUqqX1TH9h7sG5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369673; c=relaxed/simple;
	bh=WI6vCWYiVzwbu/CwGfuo3VAccowsUhs3oSt4z31I5dw=;
	h=Date:To:From:Subject:Message-Id; b=GuL6xHFB6iUbHtmzFihZ0HWuoqFjNgiOgj4IRh0iJbUgR0pLB1bWZ0tX8aVAjQ1hke7uFEQEbe/VepBM7kMeeOCeZ6WxA2NNcalHP+uYzemIvfnKc5e+J2/Kk3xbjXH6K6Y+qiIPeIdfSFNoInySgBigD6YyS4BncDvBQ5Fu64I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jtwZ0yjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jtwZ0yjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879CAC433F1;
	Thu,  8 Feb 2024 05:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369672;
	bh=WI6vCWYiVzwbu/CwGfuo3VAccowsUhs3oSt4z31I5dw=;
	h=Date:To:From:Subject:From;
	b=jtwZ0yjJefEU0AowME7HSF/Gu/Iwa9XUk7qI6I2t8ZUkXpGQ1sojFuBd3bdIqLfvJ
	 qKTklK6nIcrLqYv5NJb7wl8ps7yLh6TA7nzlkLunfQ85okkO1Tofkoi4vVcwsrnwg3
	 gzLKtZzsucKeRkTHnSNSDhQLcR1zBk7DypElRTzI=
Date: Wed, 07 Feb 2024 21:21:12 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ebiederm@xmission.com,dylanbhatch@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] exit-wait_task_zombie-kill-the-no-longer-necessary-spin_lock_irqsiglock.patch removed from -mm tree
Message-Id: <20240208052112.879CAC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: exit: wait_task_zombie: kill the no longer necessary spin_lock_irq(siglock)
has been removed from the -mm tree.  Its filename was
     exit-wait_task_zombie-kill-the-no-longer-necessary-spin_lock_irqsiglock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch

