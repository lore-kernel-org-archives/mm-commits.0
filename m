Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015AD5A78C
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970533; cv=none; b=qm9wIK2FeTgCxFMYT7Y41Xsp8VJvHwnzdVrIWP8x4AccjXb4zagXyytpRX2Auu66j9G0/a9WbSgg2EtlRQFszqApseE4nc/PCSWMqaBmyOPah3F4giCUuzfqCLfA+rVBsHdkTEd16Qw9CYWEiefgqSuap4rTDG6mzzr44hqafqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970533; c=relaxed/simple;
	bh=YrhL6LMBZ6J2Vb3QlygSp5scYAOgD69dwG1UeSQ2r5o=;
	h=Date:To:From:Subject:Message-Id; b=U4sg7jtcjHxicPsTv9O/Ke1eTq34TbuLMEdCnkLbBE3HbMBQfVBg1xoBj8n5VloIN4xYHJntJzZdGrGXhoxuMvMlp+c2paEmlxxA5WHCHGhps4dk+uapWkZKsjlc+9OLqkrwsR9Bp8yiunjm4BscqEQqFjRaaj91WTEFgtEBMwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q3j1C045; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q3j1C045"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249ACC433C7;
	Tue, 23 Jan 2024 00:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970532;
	bh=YrhL6LMBZ6J2Vb3QlygSp5scYAOgD69dwG1UeSQ2r5o=;
	h=Date:To:From:Subject:From;
	b=Q3j1C045EsSdNNW7rApe/aPSqfuMI9rl42kJ742nncDGRbNwu/lRw1fMvEsKsOkM1
	 wTClnjx9EGdcvsUFvVrQHI3Yp7UpPe6Gcg6PbSukpNilMyUefdZFK/9isjdqtVX5rz
	 2dpnhpBBCw+O0YCq1uXcxfgx9z7Lqh4cZex+Ud6A=
Date: Mon, 22 Jan 2024 16:42:09 -0800
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,dylanbhatch@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + getrusage-use-sig-stats_lock-rather-than-lock_task_sighand.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004212.249ACC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: getrusage: use sig->stats_lock rather than lock_task_sighand()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     getrusage-use-sig-stats_lock-rather-than-lock_task_sighand.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/getrusage-use-sig-stats_lock-rather-than-lock_task_sighand.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: getrusage: use sig->stats_lock rather than lock_task_sighand()
Date: Mon, 22 Jan 2024 16:50:53 +0100

lock_task_sighand() can trigger a hard lockup. If NR_CPUS threads call
getrusage() at the same time and the process has NR_THREADS, spin_lock_irq
will spin with irqs disabled O(NR_CPUS * NR_THREADS) time.

Change getrusage() to use sig->stats_lock, it was specifically designed
for this type of use. This way it runs lockless in the likely case.

TODO:
	- Change do_task_stat() to use sig->stats_lock too, then we can
	  remove spin_lock_irq(siglock) in wait_task_zombie().

	- Turn sig->stats_lock into seqcount_rwlock_t, this way the
	  readers in the slow mode won't exclude each other. See
	  https://lore.kernel.org/all/20230913154907.GA26210@redhat.com/

	- stats_lock has to disable irqs because ->siglock can be taken
	  in irq context, it would be very nice to change __exit_signal()
	  to avoid the siglock->stats_lock dependency.

Link: https://lkml.kernel.org/r/20240122155053.GA26214@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Dylan Hatch <dylanbhatch@google.com>
Tested-by: Dylan Hatch <dylanbhatch@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/kernel/sys.c~getrusage-use-sig-stats_lock-rather-than-lock_task_sighand
+++ a/kernel/sys.c
@@ -1788,7 +1788,9 @@ void getrusage(struct task_struct *p, in
 	unsigned long maxrss;
 	struct mm_struct *mm;
 	struct signal_struct *sig = p->signal;
+	unsigned int seq = 0;
 
+retry:
 	memset(r, 0, sizeof(*r));
 	utime = stime = 0;
 	maxrss = 0;
@@ -1800,8 +1802,7 @@ void getrusage(struct task_struct *p, in
 		goto out_thread;
 	}
 
-	if (!lock_task_sighand(p, &flags))
-		return;
+	flags = read_seqbegin_or_lock_irqsave(&sig->stats_lock, &seq);
 
 	switch (who) {
 	case RUSAGE_BOTH:
@@ -1829,14 +1830,23 @@ void getrusage(struct task_struct *p, in
 		r->ru_oublock += sig->oublock;
 		if (maxrss < sig->maxrss)
 			maxrss = sig->maxrss;
+
+		rcu_read_lock();
 		__for_each_thread(sig, t)
 			accumulate_thread_rusage(t, r);
+		rcu_read_unlock();
+
 		break;
 
 	default:
 		BUG();
 	}
-	unlock_task_sighand(p, &flags);
+
+	if (need_seqretry(&sig->stats_lock, seq)) {
+		seq = 1;
+		goto retry;
+	}
+	done_seqretry_irqrestore(&sig->stats_lock, seq, flags);
 
 	if (who == RUSAGE_CHILDREN)
 		goto out_children;
_

Patches currently in -mm which might be from oleg@redhat.com are

ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch
getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch
getrusage-use-sig-stats_lock-rather-than-lock_task_sighand.patch

