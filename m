Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BC21F91D6
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 19:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772308636; cv=none; b=qJDIvRYf/D2rKkv/lJjiLeHDjk5zr5n5/jGQxbB3HDFq5dri/EBoQbJth1B3B/TwsghPCl5i0p9ntJ/CAZNu/rhsfpi0+rSINCWUtj97/nvoC76d6gT/TyT/XTDGJBJRoXfw2rwDX30tlLsl5UxLOocNfun+aGOWg8TPjBaJZsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772308636; c=relaxed/simple;
	bh=UXNf1dhg6lP15RBNb6ApfwHsYCstITTB7dOErKn3VmM=;
	h=Date:To:From:Subject:Message-Id; b=hE/mhxpSpUvkDMBzXKq+aUQhnRx7wnzCawhmOh9vaQhTRzK0g5HrgywZNFa9avKFSzlP8l7QUBPoQYCRB2QEtUsxNX4JpQ9AT9ius9pdhJIcgoRgGQ86XsSixYV9rLksmj8gQlXuHbLdYlgO4bYE7SqLsHVEVdJyIKOKEge9rAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1MykB16F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1MykB16F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3618C116D0;
	Sat, 28 Feb 2026 19:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772308635;
	bh=UXNf1dhg6lP15RBNb6ApfwHsYCstITTB7dOErKn3VmM=;
	h=Date:To:From:Subject:From;
	b=1MykB16FvdYkcevUgpXWOq2HTFTIZIsJ8fMeWRzkFMI5j1IPZKdVGOjwczBrgjrif
	 6P4akTMPVtqc8/dwh61Nh6rpeQn6RUvvptL2q3Ji7a3hLs8AXPK4bGsU4z3Xs4riNV
	 iKfi1mUK98rr4kAhr6BxkfnjEQWG9tUrX2oGV9DM=
Date: Sat, 28 Feb 2026 11:57:15 -0800
To: mm-commits@vger.kernel.org,vincent.guittot@linaro.org,tkhai@ya.ru,shuah@kernel.org,ptikhomirov@virtuozzo.com,peterz@infradead.org,mingo@redhat.com,kees@kernel.org,juri.lelli@redhat.com,jack@suse.cz,david@kernel.org,cyphar@cyphar.com,brauner@kernel.org,avagin@gmail.com,areber@redhat.com,alexander@mihalicyn.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pid-make-sub-init-creation-retryable.patch added to mm-nonmm-unstable branch
Message-Id: <20260228195715.A3618C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pid: make sub-init creation retryable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     pid-make-sub-init-creation-retryable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-make-sub-init-creation-retryable.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: pid: make sub-init creation retryable
Date: Fri, 27 Feb 2026 13:03:41 +0100

Patch series "pid: make sub-init creation retryable".


This patch (of 2):

Currently we allow only one attempt to create init in a new namespace.  If
the first fork() fails after alloc_pid() succeeds, free_pid() clears
PIDNS_ADDING and thus disables further PID allocations.

Nowadays this looks like an unnecessary limitation.  The original reason
to handle "case PIDNS_ADDING" in free_pid() is gone, most probably after
commit 69879c01a0c3 ("proc: Remove the now unnecessary internal mount of
proc").

Change free_pid() to keep ns->pid_allocated == PIDNS_ADDING, and change
alloc_pid() to reset the cursor early, right after taking pidmap_lock.

Test-case:

	#define _GNU_SOURCE
	#include <linux/sched.h>
	#include <sys/syscall.h>
	#include <sys/wait.h>
	#include <assert.h>
	#include <sched.h>
	#include <errno.h>

	int main(void)
	{
		struct clone_args args = {
			.exit_signal = SIGCHLD,
			.flags	= CLONE_PIDFD,
			.pidfd	= 0,
		};
		unsigned long pidfd;
		int pid;

		assert(unshare(CLONE_NEWPID) == 0);

		pid = syscall(__NR_clone3, &args, sizeof(args));
		assert(pid == -1 && errno == EFAULT);

		args.pidfd = (unsigned long)&pidfd;
		pid = syscall(__NR_clone3, &args, sizeof(args));
		if (pid)
			assert(pid > 0 && wait(NULL) == pid);
		else
			assert(getpid() == 1);

		return 0;
	}

Link: https://lkml.kernel.org/r/aaGHu3ixbw9Y7kFj@redhat.com
Link: https://lkml.kernel.org/r/aaGIHa7vGdwhEc_D@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrei Vagin <avagin@gmail.com>
Cc: Adrian Reber <areber@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/kernel/pid.c~pid-make-sub-init-creation-retryable
+++ a/kernel/pid.c
@@ -131,9 +131,8 @@ void free_pid(struct pid *pid)
 			wake_up_process(ns->child_reaper);
 			break;
 		case PIDNS_ADDING:
-			/* Handle a fork failure of the first process */
-			WARN_ON(ns->child_reaper);
-			ns->pid_allocated = 0;
+			/* Only possible if the 1st fork fails */
+			WARN_ON(READ_ONCE(ns->child_reaper));
 			break;
 		}
 
@@ -236,6 +235,10 @@ struct pid *alloc_pid(struct pid_namespa
 	retried_preload = false;
 	idr_preload(GFP_KERNEL);
 	spin_lock(&pidmap_lock);
+	/* For the case when the previous attempt to create init failed */
+	if (ns->pid_allocated == PIDNS_ADDING)
+		idr_set_cursor(&ns->idr, 0);
+
 	for (tmp = ns, i = ns->level; i >= 0;) {
 		int tid = set_tid[ns->level - i];
 
@@ -338,10 +341,6 @@ out_free:
 		idr_remove(&upid->ns->idr, upid->nr);
 	}
 
-	/* On failure to allocate the first pid, reset the state */
-	if (ns->pid_allocated == PIDNS_ADDING)
-		idr_set_cursor(&ns->idr, 0);
-
 	spin_unlock(&pidmap_lock);
 	idr_preload_end();
 
_

Patches currently in -mm which might be from oleg@redhat.com are

exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent.patch
do_notify_parent-sanitize-the-valid_signal-checks.patch
complete_signal-kill-always-true-core_state-signal_group_exit-check.patch
pid-make-sub-init-creation-retryable.patch
pid-document-the-pidns_adding-checks-in-alloc_pid-and-copy_process.patch

