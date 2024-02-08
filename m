Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F9667A07;
	Thu,  8 Feb 2024 05:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369668; cv=none; b=ZH6JUbQ+ArLbzynzQKSgGkpUK5eNWwZrO3fWDmCAe4O5f7aoBOEFSUvX9ZVKaIciuuvhL0oVfHcPpZi4ZFlBgbcBSuVe6ssvULRmepwlW9xLenhFDXuQGl1llebgOXczdDtHEVmtg4v5crBcweIAmW/wMh557mTL5hR9zhMSB1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369668; c=relaxed/simple;
	bh=er1i4IvsDd/Z1asgf9uiM2hnY2Je4OMv3Br3vJKPu9U=;
	h=Date:To:From:Subject:Message-Id; b=b9gygM/QfW60nVgrK2/4WCLK+RhNL+Q8FqCD93TwdwAYa+7cEVxeEa+o5FF75OTr2oXwsf5sDGilaiGtckRj1OQMDDwCxZdab72j76A8CfZHSgpTrYsPE9XtQG2pkhASDT1IHTik+lIHIwZ00M9zhIWtoJeGpIMPXKeoDuziCGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pRi2hO08; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pRi2hO08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E888CC433F1;
	Thu,  8 Feb 2024 05:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369668;
	bh=er1i4IvsDd/Z1asgf9uiM2hnY2Je4OMv3Br3vJKPu9U=;
	h=Date:To:From:Subject:From;
	b=pRi2hO08C0bKTJ/LAbm9EFof/oH34aqGy+uBvKLUJCEue6meRmnNxANcf3LPc4PHn
	 CJZ4ApJyG7DOnHmTinaMLPVR4ig7krqRcy3hAqv/Rl5LLZP8Xd+rHkgRyxoN4L10FO
	 TIdwEbBOnupknhrO899Le4WYfMeqkkbZVq1deZ/k=
Date: Wed, 07 Feb 2024 21:21:07 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ebiederm@xmission.com,dylanbhatch@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch removed from -mm tree
Message-Id: <20240208052107.E888CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: getrusage: move thread_group_cputime_adjusted() outside of lock_task_sighand()
has been removed from the -mm tree.  Its filename was
     getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: <stable@vger.kernel.org>
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

