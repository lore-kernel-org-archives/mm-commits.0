Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34AA2D1913
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671891; cv=none; b=m5QVezLep6grv2hcN9TEoDZhDPDH/RVvedWF5eOlHwv6ruyGzdIxmQyc30HDRQQT8lGUWjKroE7nxc1jrGz9wdRS9zEEk4E9SrbuPXfPZJ3xQe55O9fRMZnFH1HT5bGnpw+emVSJQKktobh8KFREAbTdQ69KRQ05CzIA5J/SaFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671891; c=relaxed/simple;
	bh=ottk9sLOh/NkFMXy/Ya5ORlVmFwTLppwdT3hOeU68SU=;
	h=Date:To:From:Subject:Message-Id; b=FWBfDh+rDcZ0OR6La85quU9Y+shm3GoyOBpecfL7Ie0IcyMnYXe2OxF6VUvXu768fqxq3GCdkhgPFCMpKw1xdEibS6zCEPjEsbeSqh9X94gg0vfds56JGBPinfvUswj8DpWkMc6c1/qw2POpqCZ1Qznv29C5ULCZQVXBFMv/PoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=13WkdBwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="13WkdBwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898BBC4CEF7;
	Sat, 28 Mar 2026 04:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671890;
	bh=ottk9sLOh/NkFMXy/Ya5ORlVmFwTLppwdT3hOeU68SU=;
	h=Date:To:From:Subject:From;
	b=13WkdBwxACdj2dV53F6frtmplRyVqSp1NUiqysrHbnx6LcuEMFV5GTTs3IXzHFua9
	 1/yzPoanOEZpAxl1woDgnY2kKcfgCa/bw/ZpLgDsFihVe1pODmmjVqfNsomdrqyqnr
	 iRRDqFrUcf7/qLisOOR3J4+AFerz+4IfoRc+0geI=
Date: Fri, 27 Mar 2026 21:24:50 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,kees@kernel.org,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] complete_signal-kill-always-true-core_state-signal_group_exit-check.patch removed from -mm tree
Message-Id: <20260328042450.898BBC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: complete_signal: kill always-true "core_state || !SIGNAL_GROUP_EXIT" check
has been removed from the -mm tree.  Its filename was
     complete_signal-kill-always-true-core_state-signal_group_exit-check.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc; Deepanshu Kartikey <kartikey406@gmail.com>
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

kernel-fork-validate-exit_signal-in-kernel_clone-fix.patch

