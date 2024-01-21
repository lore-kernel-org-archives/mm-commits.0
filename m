Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758FF31A78
	for <mm-commits@vger.kernel.org>; Sun, 21 Jan 2024 22:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705875221; cv=none; b=WqAdTZ99vBtlcaWTcSbfbcbnD6CqhRi43puApYVFT2MoF75+ldYxxcH96VtWO0wqkmI9zchzwwya7/bfSwpm3QdmprG3bplQPPwG1udxL/rVRDZBF5JJHSrWkb9Nsf32sZb4bu9ldvkUlsTrZuxC+hvVxQ5EgFpbvmeiBzbpyzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705875221; c=relaxed/simple;
	bh=7c2EjBt/yCpJameGtFYVsnEe+OOHar91X/GIXV/EPjA=;
	h=Date:To:From:Subject:Message-Id; b=KaYTWHycMTvU03ZA377pZ8ScCZsdXqNwF3Tb/5IvomDunIBrAVMIakYRtznjcfvp7/urAsQI1jEZcBi/5YtgCFzoazCCCTCgUtemkMmCTDGcajGxTTYwkdlVVQbQJrl94Ex/e4/d/kubCT+UXQAAjkAGkBFj+CNEMK20DfNxjDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GWxUupm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GWxUupm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D988C433F1;
	Sun, 21 Jan 2024 22:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705875220;
	bh=7c2EjBt/yCpJameGtFYVsnEe+OOHar91X/GIXV/EPjA=;
	h=Date:To:From:Subject:From;
	b=GWxUupm3yssBfpnJofSNjFZmptlx6bIuTtDrKoccUunQzyeDJyo0mDCzP2zeWtlXP
	 LcDe4FPIHUY1riLu4GMxdeIBEHDluXuos4yBmPiDgyUXUn+kKYxjtuaSEllZyWqnrt
	 DRae3ClRWVR2HitC3eg08Aa2odUhBPaIcHt1IT1c=
Date: Sun, 21 Jan 2024 14:13:38 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,Vincent.Whitchurch@axis.com,tglx@linutronix.de,shr@devkernel.io,revest@chromium.org,omosnace@redhat.com,ojeda@kernel.org,michael.christie@oracle.com,mcgrof@kernel.org,keescook@chromium.org,josh@joshtriplett.org,joey.gouly@arm.com,joel@joelfernandes.org,frederic@kernel.org,ebiederm@xmission.com,dylanbhatch@google.com,dvyukov@google.com,deller@gmx.de,david@redhat.com,catalin.marinas@arm.com,bigeasy@linutronix.de,ardb@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + getrusage-use-sig-stats_lock.patch added to mm-nonmm-unstable branch
Message-Id: <20240121221340.7D988C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: getrusage: use sig->stats_lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     getrusage-use-sig-stats_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/getrusage-use-sig-stats_lock.patch

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
Subject: getrusage: use sig->stats_lock
Date: Fri, 19 Jan 2024 15:15:29 +0100

Rather than lock_task_sighand(), sig->stats_lock was specifically designed
for this type of use.  This way getrusage runs lockless in the likely
case.

TODO:
	- Change do_task_stat() to use sig->stats_lock too, then we can
	  remove spin_lock_irq(siglock) in wait_task_zombie().

	- Turn sig->stats_lock into seqcount_rwlock_t, this way the
	  readers in the slow mode won't exclude each other. See
	  https://lore.kernel.org/all/20230913154907.GA26210@redhat.com/

	- stats_lock has to disable irqs because ->siglock can be taken
	  in irq context, it would be very nice to change __exit_signal()
	  to avoid the siglock->stats_lock dependency.

Link: https://lkml.kernel.org/r/20240119141529.GB23739@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Dylan Hatch <dylanbhatch@google.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Whitchurch <Vincent.Whitchurch@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/kernel/sys.c~getrusage-use-sig-stats_lock
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

getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch
getrusage-use-sig-stats_lock.patch

