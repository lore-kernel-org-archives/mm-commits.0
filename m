Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774A42D1913
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671889; cv=none; b=TLMIqBS6oLwHaMP6ovAXrbSkn0p+VR5cHFbJ5kQnh6i7moSQkvd9TsKz8l8S/AMiWW8UPTTzCMchdNEGD+iETExnosAS8VUqP9Mn7ti5giB9FBcoVOu4/fjbkGsxBDxRb3gqefNmw/P/FST1XQRuxkFWMyZCBpmX6y5uvlk7A94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671889; c=relaxed/simple;
	bh=1+JNcp2Ljdxb06ndk6pL8L8gK7o/4uSF0gd8d6hEtVc=;
	h=Date:To:From:Subject:Message-Id; b=UVFEeTJT+s21sa9RB5BPE4OO15dXtTb5nTi0SeW7kQpRoGMmkNDlA6cDRwPSGLH4FIfDfWOWO3APxdckX9atxn1Bf/4GND32vgoWlRAMJlbVjL0+tDzpKFprmel7rtfbolVT6+oevz4EM6baeRIxRIiP428WCoJl4WTO5vjWf1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XxqrQ30i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XxqrQ30i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0EBC4CEF7;
	Sat, 28 Mar 2026 04:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671889;
	bh=1+JNcp2Ljdxb06ndk6pL8L8gK7o/4uSF0gd8d6hEtVc=;
	h=Date:To:From:Subject:From;
	b=XxqrQ30iHt7lC5VAiQbeXfjEYZnVv2JQyZjfcdpeI7izUVshFk9qzTAlxWjPhBaSD
	 sxVujXVf62XROAh+PZhnwlMuXxGkK91Tvj26ZCUe0X0hfGvPgf1Fy5Hms3hc7+oDf6
	 nS23I+gzixPSAPyUnQREyJ6NY3rZh8W11JJVsRQg=
Date: Fri, 27 Mar 2026 21:24:48 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,kees@kernel.org,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent.patch removed from -mm tree
Message-Id: <20260328042449.4E0EBC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: exit: kill unnecessary thread_group_leader() checks in exit_notify() and do_notify_parent()
has been removed from the -mm tree.  Its filename was
     exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc; Deepanshu Kartikey <kartikey406@gmail.com>
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

kernel-fork-validate-exit_signal-in-kernel_clone-fix.patch

