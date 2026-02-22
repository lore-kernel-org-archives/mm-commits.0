Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE29D19E96D
	for <mm-commits@vger.kernel.org>; Sun, 22 Feb 2026 19:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771787946; cv=none; b=goAMt2Ok8LV5pG0zPvS/ELvbg9ABceM+2IeXli62JrUjUjGWYT+TUVSeDj90ZppugSGF9yNn9Bv4L3PyuxPnICxPZqCmG0su9EaB0tlSnfkzDD3UnNUZBE1T/nm7YWa/bS7HMIf/ymzgQwA3RqHhV/wxG9yc6gRbYOwo0EhPm00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771787946; c=relaxed/simple;
	bh=HYAkNNlJtKOFmFnKJyDlUk5VX0QEY4xFxsSKBZwmJJI=;
	h=Date:To:From:Subject:Message-Id; b=JtGanG5oAG7ZsbBDrt+ubAt70xPgYrjskAXSQvkEvoX8y9t/ujflyGsTmdJ0A49DWqAGiRJzcO24B4CueycnKvVHySfFVNSCxCeR5aiQsOG57IANDpEUJN7l3si9+kKGiTC0uAwx1KziYtlQo0jzVCnvwd5zK70HhFD9fAHbfkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T3olcq21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T3olcq21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645AFC116D0;
	Sun, 22 Feb 2026 19:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771787945;
	bh=HYAkNNlJtKOFmFnKJyDlUk5VX0QEY4xFxsSKBZwmJJI=;
	h=Date:To:From:Subject:From;
	b=T3olcq21E67TQds/W9bFYPs5IkOhnt/sTqdtHPoC8/QGJ+edfAv7iEd/sTM0d0Fl1
	 /JJOLYBvoVihsGHJBNRQfVGD/TYhLU8ENvVYjag77cA6wUawXabuafA1K26x2/cmdL
	 //hlQeji9KPunX/y47v9qw0c9ukSJEZZwpV9RWMY=
Date: Sun, 22 Feb 2026 11:19:04 -0800
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,kees@kernel.org,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + do_notify_parent-sanitize-the-valid_signal-checks.patch added to mm-nonmm-unstable branch
Message-Id: <20260222191905.645AFC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: do_notify_parent: sanitize the valid_signal() checks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     do_notify_parent-sanitize-the-valid_signal-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/do_notify_parent-sanitize-the-valid_signal-checks.patch

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
Subject: do_notify_parent: sanitize the valid_signal() checks
Date: Sun, 22 Feb 2026 16:23:47 +0100

The "sig" argument of do_notify_parent() must always be valid and it does
WARN_ON_ONCE(sig == -1) at the start.  The 2nd valid_signal() check before
__send_signal_locked() must always be true or we have a bug.

This is confusing.  Change do_notify_parent() to WARN and return early if
valid_signal(sig) is false.

Link: https://lkml.kernel.org/r/aZsfg0Y055yuAvsq@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/signal.c~do_notify_parent-sanitize-the-valid_signal-checks
+++ a/kernel/signal.c
@@ -2173,7 +2173,8 @@ bool do_notify_parent(struct task_struct
 	bool autoreap = false;
 	u64 utime, stime;
 
-	WARN_ON_ONCE(sig == -1);
+	if (WARN_ON_ONCE(!valid_signal(sig)))
+		return false;
 
 	/* do_notify_parent_cldstop should have been called instead.  */
 	WARN_ON_ONCE(task_is_stopped_or_traced(tsk));
@@ -2254,7 +2255,7 @@ bool do_notify_parent(struct task_struct
 	 * Send with __send_signal as si_pid and si_uid are in the
 	 * parent's namespaces.
 	 */
-	if (valid_signal(sig) && sig)
+	if (sig)
 		__send_signal_locked(sig, &info, tsk->parent, PIDTYPE_TGID, false);
 	__wake_up_parent(tsk, tsk->parent);
 	spin_unlock_irqrestore(&psig->siglock, flags);
_

Patches currently in -mm which might be from oleg@redhat.com are

exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent.patch
do_notify_parent-sanitize-the-valid_signal-checks.patch
complete_signal-kill-always-true-core_state-signal_group_exit-check.patch

