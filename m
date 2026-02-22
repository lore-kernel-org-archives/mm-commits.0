Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0627E3EBF08
	for <mm-commits@vger.kernel.org>; Sun, 22 Feb 2026 19:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771787948; cv=none; b=fqM/COWpgmxYwm78MaMjllQ3NcAKVXaj7Bd/xmJx3IvXi9lkGOwKqo79zjLB3+wWOc0Vy0Ufuab7dmZuKrYvbplSUciRFHDk+ffGIuJ2XWmHaIqLrZ2I/8YbCn3MPJXnfniegmWo9J028URgAKWO8hHgeHygZR/zifTk1R0MzFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771787948; c=relaxed/simple;
	bh=Oeeg9HCJq1XZ8bDo1z9eIRTkmk9Xlics67f96llgHyY=;
	h=Date:To:From:Subject:Message-Id; b=QmLXK7mS7ez0bZc9PC4E3neE4Jo/Lz8+6Cce5F2+Akn05pjid7I25MNhHM6vofTrmm6OdHpEuqE/DKauMCgBAOd//PcztMamg477auXlrwdjLJQk4/Xs7IjFXk0bEmahlKS+BlClPahlp0kgKYO+MxFTEpcbaBISVasnLZdzvjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fzTdL1bU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fzTdL1bU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABCCC116D0;
	Sun, 22 Feb 2026 19:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771787947;
	bh=Oeeg9HCJq1XZ8bDo1z9eIRTkmk9Xlics67f96llgHyY=;
	h=Date:To:From:Subject:From;
	b=fzTdL1bUKUkHujlmpjR8JxG8N6v1oMgJjocf3bv6invdkBgOlfKN/w3Ji9hSoJRnM
	 Z2nQ5HyhFk79FqVBsYUGoqoIUa67igpPBqRQ0fhTGd7Nmpf6HO5CMOfPbDO+AuWJaK
	 XRTkURqzkovLTnW9D5/w/efwLVGKXZJ48D6nIWr8=
Date: Sun, 22 Feb 2026 11:19:06 -0800
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,kees@kernel.org,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + complete_signal-kill-always-true-core_state-signal_group_exit-check.patch added to mm-nonmm-unstable branch
Message-Id: <20260222191907.8ABCCC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: complete_signal: kill always-true "core_state || !SIGNAL_GROUP_EXIT" check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     complete_signal-kill-always-true-core_state-signal_group_exit-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/complete_signal-kill-always-true-core_state-signal_group_exit-check.patch

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
Subject: complete_signal: kill always-true "core_state || !SIGNAL_GROUP_EXIT" check
Date: Sun, 22 Feb 2026 16:24:00 +0100

The "(signal->core_state || !(signal->flags & SIGNAL_GROUP_EXIT))" check
in complete_signal() is not obvious at all, and in fact it only adds
unnecessary confusion: this condition is always true.

prepare_signal() does:

	if (signal->flags & SIGNAL_GROUP_EXIT) {
		if (signal->core_state)
			return sig == SIGKILL;
		/*
		 * The process is in the middle of dying, drop the signal.
		 */
		return false;
	}

This means that "!signal->core_state && (signal->flags &
SIGNAL_GROUP_EXIT)" in complete_signal() is never possible.

If SIGNAL_GROUP_EXIT is set, prepare_signal() can only return true if
signal->core_state is not NULL.

Link: https://lkml.kernel.org/r/aZsfkDhnqJ4s1oTs@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/signal.c~complete_signal-kill-always-true-core_state-signal_group_exit-check
+++ a/kernel/signal.c
@@ -1000,9 +1000,7 @@ static void complete_signal(int sig, str
 	 * Found a killable thread.  If the signal will be fatal,
 	 * then start taking the whole group down immediately.
 	 */
-	if (sig_fatal(p, sig) &&
-	    (signal->core_state || !(signal->flags & SIGNAL_GROUP_EXIT)) &&
-	    !sigismember(&t->real_blocked, sig) &&
+	if (sig_fatal(p, sig) && !sigismember(&t->real_blocked, sig) &&
 	    (sig == SIGKILL || !p->ptrace)) {
 		/*
 		 * This signal will be fatal to the whole group.
_

Patches currently in -mm which might be from oleg@redhat.com are

exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent.patch
do_notify_parent-sanitize-the-valid_signal-checks.patch
complete_signal-kill-always-true-core_state-signal_group_exit-check.patch

