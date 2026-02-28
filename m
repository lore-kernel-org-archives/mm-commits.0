Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C9D1F91D6
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 19:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772308638; cv=none; b=GrJA96JiF22BBwSXqqAfFc/3p+ubyS10GIeiM0bn2DqjpIguj/DuFdUF8Un9R6kCqdEc6s9jZUu5WY+YJY1M4r2Mpjo7yW70j1V9Bb6JNR1b5yeaL9Wp795ditIQ0qsjN0i98qZDOqqWRJZ+HCTlx1X3GwixG0kDiCRpwcSFKo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772308638; c=relaxed/simple;
	bh=KfTsvSg9Tq6ofG3yOMqdf+w3meQhoCFq00qsIZBjyLY=;
	h=Date:To:From:Subject:Message-Id; b=GumqGe4Z7vj/7SCyNLXl+dtO1SLQAlXkqvA5kPFMQY4XFGKWER+VqMeckeyU6Qr3ZP8t24oY95NfuNRMkx06azIbbaWs8hreou21H9IzSLBTkVdn8IglObQD1BnfhRvZwPJAUH51u3WwiEBHCz5pNqnkLTuhHaXDO0JnlBC25MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JP/cp+V6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JP/cp+V6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA298C116D0;
	Sat, 28 Feb 2026 19:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772308637;
	bh=KfTsvSg9Tq6ofG3yOMqdf+w3meQhoCFq00qsIZBjyLY=;
	h=Date:To:From:Subject:From;
	b=JP/cp+V68qXDTyJmrlWtcJ4h1OiJ5gXJpEhnL2tQrr6zbvPGUtBUK3GiK7Kgm7JcQ
	 RPPnRNtJtBo5cWofkiP5syiEv4r0ElQgpQCOxwd6pNAnDHvoDTqgj8We6wRzx7evLQ
	 9v5zpM8ZSnrO06qyvQH3QsBKigO8XjPyl7wd3tig=
Date: Sat, 28 Feb 2026 11:57:17 -0800
To: mm-commits@vger.kernel.org,vincent.guittot@linaro.org,tkhai@ya.ru,shuah@kernel.org,ptikhomirov@virtuozzo.com,peterz@infradead.org,mingo@redhat.com,kees@kernel.org,juri.lelli@redhat.com,jack@suse.cz,david@kernel.org,cyphar@cyphar.com,brauner@kernel.org,avagin@gmail.com,areber@redhat.com,alexander@mihalicyn.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pid-document-the-pidns_adding-checks-in-alloc_pid-and-copy_process.patch added to mm-nonmm-unstable branch
Message-Id: <20260228195717.DA298C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pid: document the PIDNS_ADDING checks in alloc_pid() and copy_process()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     pid-document-the-pidns_adding-checks-in-alloc_pid-and-copy_process.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-document-the-pidns_adding-checks-in-alloc_pid-and-copy_process.patch

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
@@ -2397,7 +2397,11 @@ __latent_entropy struct task_struct *cop
 
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

exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent.patch
do_notify_parent-sanitize-the-valid_signal-checks.patch
complete_signal-kill-always-true-core_state-signal_group_exit-check.patch
pid-make-sub-init-creation-retryable.patch
pid-document-the-pidns_adding-checks-in-alloc_pid-and-copy_process.patch

