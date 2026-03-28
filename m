Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9751FA859
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671897; cv=none; b=pakJsrYqOiYpBWCYyFrMd1mO/Vnq85/UdE8nLtmKXJvAoLeCL6/CdyvMHSUe9hdf4BhvsNNFUpTB6lhgwTC/Oeaf1+ULLH6YkhHKBs1tgf0K5YPR2gjFzk1HS4dLsXPlZrEgWGPqxvMUc+dx7TWLDeHBLLrj2O6sIfow3HhoLfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671897; c=relaxed/simple;
	bh=azLfO4OqfomIqV4MPfOUtOXvx6gFc+U2QEEI7dPGEQU=;
	h=Date:To:From:Subject:Message-Id; b=Y74e5qWhu0pj7UcHYgH0RlryZPoM1UQ+jSANad+4yqhGcnq1a8RKKnpaf2itAxcJDgqx5SUKQniCIEW5PaTW+mGF4S+9hK/snD3T9+JjiKc/K9gEGGYbuUI+i6TVUaVEytCM+NB1kltgmj/CmyPoGHCrCWwZ3+DUyQtAyVCxoUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MWHALB7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MWHALB7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6531AC4CEF7;
	Sat, 28 Mar 2026 04:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671897;
	bh=azLfO4OqfomIqV4MPfOUtOXvx6gFc+U2QEEI7dPGEQU=;
	h=Date:To:From:Subject:From;
	b=MWHALB7+0svFiiuCMClO7KgAMtCQZXr5+jYRgbzejsVKNo0G3XHy/0TLX/7yjleZ/
	 9cEeSDLq1NQom2qghkOuz2Em33Tja8TgrhTzaQVLZDnnZVDua2BXIRbtGvkz+5t/ss
	 L24BakWvuZD6q94CalofJPkhaLQy6k2Qr4+7nvl8=
Date: Fri, 27 Mar 2026 21:24:56 -0700
To: mm-commits@vger.kernel.org,vincent.guittot@linaro.org,tkhai@ya.ru,shuah@kernel.org,ptikhomirov@virtuozzo.com,peterz@infradead.org,mingo@redhat.com,kees@kernel.org,juri.lelli@redhat.com,jack@suse.cz,david@kernel.org,cyphar@cyphar.com,brauner@kernel.org,avagin@gmail.com,areber@redhat.com,alexander@mihalicyn.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] pid-document-the-pidns_adding-checks-in-alloc_pid-and-copy_process.patch removed from -mm tree
Message-Id: <20260328042457.6531AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pid: document the PIDNS_ADDING checks in alloc_pid() and copy_process()
has been removed from the -mm tree.  Its filename was
     pid-document-the-pidns_adding-checks-in-alloc_pid-and-copy_process.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: pid: document the PIDNS_ADDING checks in alloc_pid() and copy_process()
Date: Fri, 27 Feb 2026 13:04:20 +0100

Both copy_process() and alloc_pid() do the same PIDNS_ADDING check.  The
reasons for these checks, and the fact that both are necessary, are not
immediately obvious.  Add the comments.

Link: https://lkml.kernel.org/r/aaGIRElc78U4Er42@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Adrian Reber <areber@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc: Andrei Vagin <avagin@gmail.com>
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

 kernel/fork.c |    6 +++++-
 kernel/pid.c  |    5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/kernel/fork.c~pid-document-the-pidns_adding-checks-in-alloc_pid-and-copy_process
+++ a/kernel/fork.c
@@ -2393,7 +2393,11 @@ __latent_entropy struct task_struct *cop
 
 	rseq_fork(p, clone_flags);
 
-	/* Don't start children in a dying pid namespace */
+	/*
+	 * If zap_pid_ns_processes() was called after alloc_pid(), the new
+	 * child missed SIGKILL.  If current is not in the same namespace,
+	 * we can't rely on fatal_signal_pending() below.
+	 */
 	if (unlikely(!(ns_of_pid(pid)->pid_allocated & PIDNS_ADDING))) {
 		retval = -ENOMEM;
 		goto bad_fork_core_free;
--- a/kernel/pid.c~pid-document-the-pidns_adding-checks-in-alloc_pid-and-copy_process
+++ a/kernel/pid.c
@@ -314,6 +314,11 @@ struct pid *alloc_pid(struct pid_namespa
 	 *
 	 * This can't be done earlier because we need to preserve other
 	 * error conditions.
+	 *
+	 * We need this even if copy_process() does the same check. If two
+	 * or more tasks from parent namespace try to inject a child into a
+	 * dead namespace, one of free_pid() calls from the copy_process()
+	 * error path may try to wakeup the possibly freed ns->child_reaper.
 	 */
 	retval = -ENOMEM;
 	if (unlikely(!(ns->pid_allocated & PIDNS_ADDING)))
_

Patches currently in -mm which might be from oleg@redhat.com are

kernel-fork-validate-exit_signal-in-kernel_clone-fix.patch

