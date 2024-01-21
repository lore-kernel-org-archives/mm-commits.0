Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB8131A78
	for <mm-commits@vger.kernel.org>; Sun, 21 Jan 2024 22:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705875224; cv=none; b=aqMSy859u8vP4kZXhjBRpHc8JVz1k2z2IVvaY25Z38Wp1t+IUUEGMwyh6oBCuHqtr4LJnZrTKlRmXlgDFG3i8MVj2sARuzl1UAqOgm7J6RnYYYVtapf+KnmLphRRUIGe3aCDKqlVs+IQK7XPmHCdc7cNNwqCQ9KiCGTMAKxF9ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705875224; c=relaxed/simple;
	bh=XHk8MerCPw8rXm5BtRJUUcP3sOMwVf8V14RuZkI7k4E=;
	h=Date:To:From:Subject:Message-Id; b=kXfwNvZ94a8hCfOZFnV69TjkNGK4oPKOE2CFyI3HFy+szmjkSLBaZKhztow4QMRteC2dYYPWLTpI/0f8RHzM3fV8PoU7rRm3nLfSnng9o3eC87FDFgiRzKkpkuhxQYCUjUewtH68o8gdSznEGLQGORao4DKYP60Xm0FGPxNVsmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s6HxYJH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s6HxYJH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49D3C433C7;
	Sun, 21 Jan 2024 22:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705875224;
	bh=XHk8MerCPw8rXm5BtRJUUcP3sOMwVf8V14RuZkI7k4E=;
	h=Date:To:From:Subject:From;
	b=s6HxYJH082Iuhs0M4cjGjGUGx0uCbb+vk79D/m0N4WCxRNHFXSBS3ZPALv54BPhAZ
	 z64Vyhzf5trvpuZLbTFlJZJZ6fZK7cS3wyy13eBz39bxTJyPmPTSFCDgc8LLDLAy1c
	 c/gdFr/IJGyNBOl9UP2E0klDhbI4wD0tMPjwut44=
Date: Sun, 21 Jan 2024 14:13:41 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,Vincent.Whitchurch@axis.com,tglx@linutronix.de,shr@devkernel.io,revest@chromium.org,omosnace@redhat.com,ojeda@kernel.org,michael.christie@oracle.com,mcgrof@kernel.org,keescook@chromium.org,josh@joshtriplett.org,joey.gouly@arm.com,joel@joelfernandes.org,frederic@kernel.org,ebiederm@xmission.com,dylanbhatch@google.com,dvyukov@google.com,deller@gmx.de,david@redhat.com,catalin.marinas@arm.com,bigeasy@linutronix.de,ardb@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch added to mm-nonmm-unstable branch
Message-Id: <20240121221343.B49D3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: getrusage: move thread_group_cputime_adjusted() outside of lock_task_sighand()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch

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
Subject: getrusage: move thread_group_cputime_adjusted() outside of lock_task_sighand()
Date: Fri, 19 Jan 2024 15:15:01 +0100

thread_group_cputime() does its own locking, we can safely shift
thread_group_cputime_adjusted() which does another for_each_thread loop
outside of ->siglock protected section.

This is also preparation for the next patch which changes getrusage() to
use stats_lock instead of siglock.  Currently the deadlock is not
possible, if getrusage() enters the slow path and takes stats_lock,
read_seqretry() in thread_group_cputime() must always return 0, so
thread_group_cputime() will never try to take the same lock.  Yet this
looks more safe and better performance-wise.

Link: https://lkml.kernel.org/r/20240119141501.GA23739@redhat.com
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

 kernel/sys.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

--- a/kernel/sys.c~getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand
+++ a/kernel/sys.c
@@ -1785,17 +1785,19 @@ void getrusage(struct task_struct *p, in
 	struct task_struct *t;
 	unsigned long flags;
 	u64 tgutime, tgstime, utime, stime;
-	unsigned long maxrss = 0;
+	unsigned long maxrss;
+	struct mm_struct *mm;
 	struct signal_struct *sig = p->signal;
 
-	memset((char *)r, 0, sizeof (*r));
+	memset(r, 0, sizeof(*r));
 	utime = stime = 0;
+	maxrss = 0;
 
 	if (who == RUSAGE_THREAD) {
 		task_cputime_adjusted(current, &utime, &stime);
 		accumulate_thread_rusage(p, r);
 		maxrss = sig->maxrss;
-		goto out;
+		goto out_thread;
 	}
 
 	if (!lock_task_sighand(p, &flags))
@@ -1819,9 +1821,6 @@ void getrusage(struct task_struct *p, in
 		fallthrough;
 
 	case RUSAGE_SELF:
-		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
-		utime += tgutime;
-		stime += tgstime;
 		r->ru_nvcsw += sig->nvcsw;
 		r->ru_nivcsw += sig->nivcsw;
 		r->ru_minflt += sig->min_flt;
@@ -1839,19 +1838,24 @@ void getrusage(struct task_struct *p, in
 	}
 	unlock_task_sighand(p, &flags);
 
-out:
-	r->ru_utime = ns_to_kernel_old_timeval(utime);
-	r->ru_stime = ns_to_kernel_old_timeval(stime);
-
-	if (who != RUSAGE_CHILDREN) {
-		struct mm_struct *mm = get_task_mm(p);
+	if (who == RUSAGE_CHILDREN)
+		goto out_children;
 
-		if (mm) {
-			setmax_mm_hiwater_rss(&maxrss, mm);
-			mmput(mm);
-		}
+	thread_group_cputime_adjusted(p, &tgutime, &tgstime);
+	utime += tgutime;
+	stime += tgstime;
+
+out_thread:
+	mm = get_task_mm(p);
+	if (mm) {
+		setmax_mm_hiwater_rss(&maxrss, mm);
+		mmput(mm);
 	}
+
+out_children:
 	r->ru_maxrss = maxrss * (PAGE_SIZE / 1024); /* convert pages to KBs */
+	r->ru_utime = ns_to_kernel_old_timeval(utime);
+	r->ru_stime = ns_to_kernel_old_timeval(stime);
 }
 
 SYSCALL_DEFINE2(getrusage, int, who, struct rusage __user *, ru)
_

Patches currently in -mm which might be from oleg@redhat.com are

getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch
getrusage-use-sig-stats_lock.patch

