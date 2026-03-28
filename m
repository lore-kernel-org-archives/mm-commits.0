Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891A5337BB0
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671966; cv=none; b=V5Hqx0b+oWGp+gGNyPl0Mhp8lUOS8c4NRZR0FQ2k7uNoj3nYAXLOtDMNyeihTMTpNfy2W6ClkUWbCO1PVfsZ/HEiXnAt8T77qmU5RXGMqxyo/rfZyD8NhC7u/W2oP++4Re7brNB3ZS98C6e+weomI/xUcH/zd5kIVw9s1ikihZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671966; c=relaxed/simple;
	bh=lyCgjnlWg2rIhnHuKmrMlWutQfba383WJH2UnFwVFfs=;
	h=Date:To:From:Subject:Message-Id; b=H8BtdC6fTPsnaQW/T13jRlwCzpnwAVJc3FGYHEyVqQscDS9Zzy9E+Bpf42QdTQrVldneWQ8k3OWse3zCfxRAtSnakzaGAYge24bfVcLLIgLLARiA4oJyRk9hyGomZw+a6zWC77ej2DZF2mVmOfkUhFDmbViGDun01QEGakCnF4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oZTzZIP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oZTzZIP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548CCC4CEF7;
	Sat, 28 Mar 2026 04:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671966;
	bh=lyCgjnlWg2rIhnHuKmrMlWutQfba383WJH2UnFwVFfs=;
	h=Date:To:From:Subject:From;
	b=oZTzZIP03DPn+0UllY3k52IZaeyOHorQAmdzTlHY2n6agjU3djZOLBThnbhKsXSYP
	 qSLQsZWcHwDTYhht8xf8+C3OCsj+gaPWV900YxOAX0Zg2ypUgVRrd942pwbTT3rFTM
	 MNGQ4/whbV7eyCmZJVQXJHOyixKBdPSfOrSCN1Vg=
Date: Fri, 27 Mar 2026 21:26:05 -0700
To: mm-commits@vger.kernel.org,Kartikey406@gmail.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] do_notify_parent-sanitize-the-valid_signal-checks.patch removed from -mm tree
Message-Id: <20260328042606.548CCC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: do_notify_parent: sanitize the valid_signal() checks
has been removed from the -mm tree.  Its filename was
     do_notify_parent-sanitize-the-valid_signal-checks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kernel-fork-validate-exit_signal-in-kernel_clone-fix.patch

