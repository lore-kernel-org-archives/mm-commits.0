Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E18B3EBF08
	for <mm-commits@vger.kernel.org>; Sun, 22 Feb 2026 19:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771787943; cv=none; b=PyZmi7olK9VRdrTdbKv3Z5/K1cYgSPOdsZ4JZWvy32Qrlou2P+B9myC/JWQKcMzvp4LVwKe0xPqq2+68hKTx3wUTBWai1qNEQSPjmXG6d6OzFU0Uwv6v4ApUWyGFzVrI8Aai+xw962yJMaPuX0omjTJUEq4ieUxEMv4xbzfqSHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771787943; c=relaxed/simple;
	bh=hhOiblFihTlpD9sDno2jso3/6+4MDmS9A0Hp9y7GRcs=;
	h=Date:To:From:Subject:Message-Id; b=q8SZea+MxOtBKmxDOUlHCw1pYoSEmLvC8vSFC/GWvW+0sx/w5tG0Z3N8SWnzdIrtk4F2v8HtklVFiBG4YD54MN0QA6ybapWQjDU288Nu+fU6ZNkvcm06PJ8CNRi9F9elD979+/rD09czbDUVT5BwsOVT9rhKUNqqcJwb5YBQwxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DGSvaSf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DGSvaSf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09770C116D0;
	Sun, 22 Feb 2026 19:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771787943;
	bh=hhOiblFihTlpD9sDno2jso3/6+4MDmS9A0Hp9y7GRcs=;
	h=Date:To:From:Subject:From;
	b=DGSvaSf/VJsv+OkSaDmgE4yAGdiyd79qc7IjfDJpfmXyl+19DH+GerXe8BAoBuaA+
	 2zWEMu8E2KjnAWl0CJQobzNrfRJwzgs63/B5hGKw/yR/cSvd+ybEecvX452j4QA8bS
	 OI6xJpgu6oOyaSvMWDjdg+KqLFjnbpDRvoLJDDqQ=
Date: Sun, 22 Feb 2026 11:19:02 -0800
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,kees@kernel.org,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent.patch added to mm-nonmm-unstable branch
Message-Id: <20260222191903.09770C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: exit: kill unnecessary thread_group_leader() checks in exit_notify() and do_notify_parent()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent.patch

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
Subject: exit: kill unnecessary thread_group_leader() checks in exit_notify() and do_notify_parent()
Date: Sun, 22 Feb 2026 16:23:37 +0100

thread_group_empty(tsk) is only possible if tsk is a group leader, and
thread_group_empty() already does the thread_group_leader() check.

So it makes no sense to check "thread_group_leader() &&
thread_group_empty()"; thread_group_empty() alone is enough.

Link: https://lkml.kernel.org/r/aZsfeegKZPZZszJh@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c   |    8 +++-----
 kernel/signal.c |    3 +--
 2 files changed, 4 insertions(+), 7 deletions(-)

--- a/kernel/exit.c~exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent
+++ a/kernel/exit.c
@@ -748,14 +748,12 @@ static void exit_notify(struct task_stru
 	tsk->exit_state = EXIT_ZOMBIE;
 
 	if (unlikely(tsk->ptrace)) {
-		int sig = thread_group_leader(tsk) &&
-				thread_group_empty(tsk) &&
-				!ptrace_reparented(tsk) ?
-			tsk->exit_signal : SIGCHLD;
+		int sig = thread_group_empty(tsk) && !ptrace_reparented(tsk)
+			  ? tsk->exit_signal : SIGCHLD;
 		autoreap = do_notify_parent(tsk, sig);
 	} else if (thread_group_leader(tsk)) {
 		autoreap = thread_group_empty(tsk) &&
-			do_notify_parent(tsk, tsk->exit_signal);
+			   do_notify_parent(tsk, tsk->exit_signal);
 	} else {
 		autoreap = true;
 		/* untraced sub-thread */
--- a/kernel/signal.c~exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent
+++ a/kernel/signal.c
@@ -2178,8 +2178,7 @@ bool do_notify_parent(struct task_struct
 	/* do_notify_parent_cldstop should have been called instead.  */
 	WARN_ON_ONCE(task_is_stopped_or_traced(tsk));
 
-	WARN_ON_ONCE(!tsk->ptrace &&
-	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
+	WARN_ON_ONCE(!tsk->ptrace && !thread_group_empty(tsk));
 
 	/* ptraced, or group-leader without sub-threads */
 	do_notify_pidfd(tsk);
_

Patches currently in -mm which might be from oleg@redhat.com are

exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent.patch
do_notify_parent-sanitize-the-valid_signal-checks.patch
complete_signal-kill-always-true-core_state-signal_group_exit-check.patch

