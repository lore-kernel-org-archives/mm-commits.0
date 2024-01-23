Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CE15FDDF
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970536; cv=none; b=i/KlOL+Hgg9ljl1lx6DJekLQZLetObRss0uf8Vg640gqlKIwnk1TAgphxwLPOAgG08r1uH5tFLFsrKJEXA/31OAODlna5RTGeuHMZxKPReiGL1TS82sGKPq0z2sC7tajG5auH7vrHcUPUTRnJKUju+BStJ9IUCleE1VsDFLlpXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970536; c=relaxed/simple;
	bh=46nDkDeY0NSxvsBeXm+iTiZ9l8v9AFyLZxDD16wyL2E=;
	h=Date:To:From:Subject:Message-Id; b=NhS/vOSJsVXlzEZ+TDBzK6yOU+evKxppNYQUltuCkWCecBoaqfEebMRQBEV/wYHurUkBRrEhx+65BkleYWj4uO3j5EPm9zUQ2wYBbbRUh8klhsrA7hJKs87J37YqyPd8RmOauMNGogVc42pDghlRY0Me7ZGiDajyRvMX+/zUITU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lOFWJGRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lOFWJGRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD07C43394;
	Tue, 23 Jan 2024 00:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970536;
	bh=46nDkDeY0NSxvsBeXm+iTiZ9l8v9AFyLZxDD16wyL2E=;
	h=Date:To:From:Subject:From;
	b=lOFWJGRrsNOWR1p2P/IrBzHYxcR+TaR/altvedvCvalwiq+iKPsAWlz5vlx/y9qsN
	 R7Op4+eg6M6ltXAfR2e8YiSgn8Z2gZYj5C3Qn1D51y2Ncdpc3u6etK1XNCYqLEdMJD
	 i4+S3SAeEwnmISiseLdk2Hjwr0Z6qtaB+g/8rzKs=
Date: Mon, 22 Jan 2024 16:42:13 -0800
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,dylanbhatch@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004216.1BD07C43394@smtp.kernel.org>
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
Date: Mon, 22 Jan 2024 16:50:50 +0100

Patch series "getrusage: use sig->stats_lock", v2.


This patch (of 2):

thread_group_cputime() does its own locking, we can safely shift
thread_group_cputime_adjusted() which does another for_each_thread loop
outside of ->siglock protected section.

This is also preparation for the next patch which changes getrusage() to
use stats_lock instead of siglock, thread_group_cputime() takes the same
lock.  With the current implementation recursive read_seqbegin_or_lock()
is fine, thread_group_cputime() can't enter the slow mode if the caller
holds stats_lock, yet this looks more safe and better performance-wise.

Link: https://lkml.kernel.org/r/20240122155023.GA26169@redhat.com
Link: https://lkml.kernel.org/r/20240122155050.GA26205@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Dylan Hatch <dylanbhatch@google.com>
Tested-by: Dylan Hatch <dylanbhatch@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
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

ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch
getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch
getrusage-use-sig-stats_lock-rather-than-lock_task_sighand.patch

