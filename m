Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C7867A07;
	Thu,  8 Feb 2024 05:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369669; cv=none; b=SHKv2tn248+9DA+GD6YMEerRZ6Xg8NclzUWGrbxQZpAdL1NAY3sj8r3Yw4WAGHnN4WEbKxMb/aKSAuMvKoBT1gMAoKJIzj7YKTTEjgmoyjAH6O/U2ytnaImPiLw2Tm9hWwKA4rORRyCMjzxwU9/hT4ONCfX+YZtBd4lCCMQJwQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369669; c=relaxed/simple;
	bh=p//1hciOSJH4iE2gXRKVDl82oRu+Uz8rr1Swmzfzars=;
	h=Date:To:From:Subject:Message-Id; b=Rv1EWvMPdw2qRJZpgloMujNRZ9n7InJipeIiaKg4v5WihfLVf+IEGdWXxv3hdzMFDpwDCpOFRufHYy13GM6oL5YwqfWPYzu0ch7XSdjTE4VF9gRqk6TN5dn75e/TapcwC/Bo+GsLwQ1b5zWg+m8PiQl0btA2KfJHQkrPPZiJp4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E7VR7qYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E7VR7qYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDA8C433C7;
	Thu,  8 Feb 2024 05:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369669;
	bh=p//1hciOSJH4iE2gXRKVDl82oRu+Uz8rr1Swmzfzars=;
	h=Date:To:From:Subject:From;
	b=E7VR7qYHeo87Pj+jAzw2OSkoz0OdA5DeYuXvoCC+6W+aRC4fJZICNpDyuFdLdppaB
	 rDX0ViTl4Xb6mfn/etMRw8m2Nnsgl9JOQy8ed+Jfi/WPDmHMGM8mGi06Pncosc9sXT
	 3gRPmnVoywPie6bsKQ1tKa6K2VmYsZWpP0IoKM7M=
Date: Wed, 07 Feb 2024 21:21:08 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ebiederm@xmission.com,dylanbhatch@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] getrusage-use-sig-stats_lock-rather-than-lock_task_sighand.patch removed from -mm tree
Message-Id: <20240208052109.4DDA8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: getrusage: use sig->stats_lock rather than lock_task_sighand()
has been removed from the -mm tree.  Its filename was
     getrusage-use-sig-stats_lock-rather-than-lock_task_sighand.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: <stable@vger.kernel.org>
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

