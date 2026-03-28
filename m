Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574A41FA859
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671896; cv=none; b=CxIR1mzxbrcsdaILNO0FLdtXneK3PUTRFZrGmoa6p8y3KDJwjNrnUWoMoIjxJaWBjJFIGQTFgxWYb6n0ARQFH0Z3QIrmrwIb5JLPNNj416+/R48qi3elzAlkF18JGDKkS3mlE9FLcsS0s8gzPJq5hBEnC2gD18ni2QO7TsqLgJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671896; c=relaxed/simple;
	bh=2DNiGOYieqpLjkTkdJOPm74xMUA1UrY8CHySpWa8Owk=;
	h=Date:To:From:Subject:Message-Id; b=Iyd+ke188atIGQor5zamI1zrFjzwSAZuq7BlU0gZKNfz9HOCzuRWwyR8/PBLCLs/fttHmLS+I9V1L0SWnkdHjIASMynVBwQbA7FtmqgXUTCdMxD6pkMM79qj8eN8qpu3ON3GboXhMn6L/hDtjNjVN5ZKd6WT6jT98QUm9My6LLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N2kQ62HL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N2kQ62HL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01870C4CEF7;
	Sat, 28 Mar 2026 04:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671896;
	bh=2DNiGOYieqpLjkTkdJOPm74xMUA1UrY8CHySpWa8Owk=;
	h=Date:To:From:Subject:From;
	b=N2kQ62HL4CJ5nIHPe6C1Fs1056JBZZo3Mr3AmTHkvAMtQPsB9O4JKSVhKa5Op0ZkB
	 qmb4GVwKFvXZho/AvC5R7NbbnrD5Hg+CGzHtC7ntz3qqZqrhk18W060vqDy9wLeoYV
	 Owwq6Dpjf5/7TYR62FxxW81p2yQTFjylDM3nOreQ=
Date: Fri, 27 Mar 2026 21:24:55 -0700
To: mm-commits@vger.kernel.org,vincent.guittot@linaro.org,tkhai@ya.ru,shuah@kernel.org,ptikhomirov@virtuozzo.com,peterz@infradead.org,mingo@redhat.com,kees@kernel.org,juri.lelli@redhat.com,jack@suse.cz,david@kernel.org,cyphar@cyphar.com,brauner@kernel.org,avagin@gmail.com,areber@redhat.com,alexander@mihalicyn.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] pid-make-sub-init-creation-retryable.patch removed from -mm tree
Message-Id: <20260328042456.01870C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pid: make sub-init creation retryable
has been removed from the -mm tree.  Its filename was
     pid-make-sub-init-creation-retryable.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kernel-fork-validate-exit_signal-in-kernel_clone-fix.patch

