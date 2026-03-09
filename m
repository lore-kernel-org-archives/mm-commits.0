Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84A0347BD1
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 20:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773086960; cv=none; b=bM0X1lRyzpb91vKRob2AMFEmi2tAYtdTm7IV20WI+TYAttKMCJgEGQrQK6Bw0mjatzRLqekwFOc/2dubOosY+CaaEo6+6anOGU+7cbEnW0TQFUQI0yUxpGmXzEEPAlauSivNi33SWxNczmQPJV0vpqOYETtTJhXdkgVPhJT+ST4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773086960; c=relaxed/simple;
	bh=IgIkHrH1Fc2Rzgrvbp4HIyY2e4IFrprSwzj+5kZBwhE=;
	h=Date:To:From:Subject:Message-Id; b=iMg55mNkSble8Cghrq49DJITS4MKO+VoRZmxWNT3Le19lU8vLJdoKhjTkHZ0l+v4C/tIUDoqNBU009c+K63jBhxhLUFrVmuDgfpm6Ujr0c3laXHFd+HhjcdCCDi9SVuC7OWgWGqHUn4N0XFEyUMPBCEKp1MFxq+sFz+/8EKPc5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y+e5biwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y+e5biwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FCFC4CEF7;
	Mon,  9 Mar 2026 20:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773086960;
	bh=IgIkHrH1Fc2Rzgrvbp4HIyY2e4IFrprSwzj+5kZBwhE=;
	h=Date:To:From:Subject:From;
	b=Y+e5biwaIoN9KdGCX91sfqAfEthyJ6S507YsI/e+KCDXwax53nH3hsnQix4oeubp7
	 rDVZFVYfeAZWNFoQG/1rIAT3NuJVfWp/dZSbxOPax9/xEK/IX7ytEh7DEvI8/Z8C9f
	 5f8BdwH4loE0VxpkyNLtnF/Vi/VSrX7yUotD5XzY=
Date: Mon, 09 Mar 2026 13:09:19 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,kees@kernel.org,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] do_notify_parent-sanitize-the-valid_signal-checks.patch removed from -mm tree
Message-Id: <20260309200920.56FCFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: do_notify_parent: sanitize the valid_signal() checks
has been removed from the -mm tree.  Its filename was
     do_notify_parent-sanitize-the-valid_signal-checks.patch

This patch was dropped because it was withdrawn

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
Cc; Deepanshu Kartikey <kartikey406@gmail.com>
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
complete_signal-kill-always-true-core_state-signal_group_exit-check.patch
pid-make-sub-init-creation-retryable.patch
pid-document-the-pidns_adding-checks-in-alloc_pid-and-copy_process.patch

