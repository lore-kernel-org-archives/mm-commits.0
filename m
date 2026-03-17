Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A5B37C109
	for <mm-commits@vger.kernel.org>; Tue, 17 Mar 2026 17:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773770023; cv=none; b=L6eadjriJOxL/qPUTdlpdO6GfDjnt04P61VFec9IvayJbL3akq+k7FEbvjBGBUUp8bnhg3s4Vxkz7N0ayVQyFkfpt7lLtLii8dvae3plf1mOzxhEFaVnXHopmXs5Kg6LZ0lrlP8Ytgr/KT7fQYu2Eqow4FjPltQELq7Xzi5rjMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773770023; c=relaxed/simple;
	bh=VMQsiRgafQdv+oTPUR4YnNoAhIp6aMQ3MWxbYexJXao=;
	h=Date:To:From:Subject:Message-Id; b=sh6CMB3V8kGVxD4QZZ3nOHrRyZobe1U5X9ffCgZ9KcGfF+AD6oJVs/iF9wiI2gzETHR3s0xYepPdUqJgso68ocX0B6Xt2mrKxkaqeJNdFZRu8ipCRIxTdZCzKemy6of7ATOJuSGTADWAljHAilbHnJBGxvy0933a3DlLrV9Py5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UdhhVk2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UdhhVk2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0861C4CEF7;
	Tue, 17 Mar 2026 17:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773770022;
	bh=VMQsiRgafQdv+oTPUR4YnNoAhIp6aMQ3MWxbYexJXao=;
	h=Date:To:From:Subject:From;
	b=UdhhVk2L2P/DJx8FzWbeZfMXGOu3+C9+mR+DqXzMULtIn0ggE88d1+C2A4b6LgCuz
	 SrzCI3ImOIQMfgqmR42tJFsH/qUEs7gm3NYMsnunTPIQslUyr/L+TEle5a2vQ55U9F
	 yWqtJuWvU3NugGyB8SSPZW1CmCqOgjNbe1efyaS4=
Date: Tue, 17 Mar 2026 10:53:42 -0700
To: mm-commits@vger.kernel.org,Kartikey406@gmail.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + do_notify_parent-sanitize-the-valid_signal-checks.patch added to mm-nonmm-unstable branch
Message-Id: <20260317175342.D0861C4CEF7@smtp.kernel.org>
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
Date: Tue, 17 Mar 2026 14:58:18 +0100

Now that kernel_clone() checks valid_signal(args->exit_signal), the "sig"
argument of do_notify_parent() must always be valid or we have a bug.

However, do_notify_parent() only checks that sig != -1 at the start, then
it does another valid_signal() check before __send_signal_locked().

This is confusing.  Change do_notify_parent() to WARN and return early if
valid_signal(sig) is false.

Link: https://lkml.kernel.org/r/abld-ilvMEZ7VgMw@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/signal.c~do_notify_parent-sanitize-the-valid_signal-checks
+++ a/kernel/signal.c
@@ -2171,7 +2171,8 @@ bool do_notify_parent(struct task_struct
 	bool autoreap = false;
 	u64 utime, stime;
 
-	WARN_ON_ONCE(sig == -1);
+	if (WARN_ON_ONCE(!valid_signal(sig)))
+		return false;
 
 	/* do_notify_parent_cldstop should have been called instead.  */
 	WARN_ON_ONCE(task_is_stopped_or_traced(tsk));
@@ -2252,7 +2253,7 @@ bool do_notify_parent(struct task_struct
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
complete_signal-kill-always-true-core_state-signal_group_exit-check.patch
pid-make-sub-init-creation-retryable.patch
pid-document-the-pidns_adding-checks-in-alloc_pid-and-copy_process.patch
do_notify_parent-sanitize-the-valid_signal-checks.patch

