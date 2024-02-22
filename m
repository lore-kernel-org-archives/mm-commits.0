Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E80EFBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645184; cv=none; b=bdf9UuLvE7DdtRVlXvhsa/Waz+0U2onZyvOkglkzcE5b/cuJrWXiNSYQ2Pn7D89lu2EYrH2AyITfpjMeRtU5BFIA7BMr5lvL2YdJBZta0vEmrLsf5ySLqhOcwY1bajIHreBQ6f7Yq2JaY9bwmIkoGS5inb/3VP/2qM/sDB45qAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645184; c=relaxed/simple;
	bh=w2I8PuOg8pkFt1wQauG8jUbBcAt8j4pznPCWvsV0daE=;
	h=Date:To:From:Subject:Message-Id; b=Bi6YGbpiAb795uwIpwuAkRP/265jlat3z53wK8whViMWEzCrHVTcjPqUm+0i5k2rPdKtDcBWu7Ff8hPuDZorCWU16Kz6w/XSWBePZ9EMFwHUaD98tirAYTzVE4kl06M81GhSa7Xbk8nky27qkcDm4pUajcpILPEBuM95yrN6SfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZeMsQ3VQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZeMsQ3VQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1654C433C7;
	Thu, 22 Feb 2024 23:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645183;
	bh=w2I8PuOg8pkFt1wQauG8jUbBcAt8j4pznPCWvsV0daE=;
	h=Date:To:From:Subject:From;
	b=ZeMsQ3VQuPMzSRwHoH7x2+ZzWt6kkGy33VCkx3ZeR8EUSo8NBsR7eljuJBIdXq+NA
	 S6Qrvz05nwYhuD4Cj7FWmeSFvpSNpd0RpptfSjoN0M9vEErDtbMQHAwwbQmp0sR4T6
	 FmF/jWQS0U9y/fgyU9kZw94OJMNHcHt2gGnFFXpg=
Date: Thu, 22 Feb 2024 15:39:43 -0800
To: mm-commits@vger.kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch removed from -mm tree
Message-Id: <20240222233943.A1654C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ptrace_attach: shift send(SIGSTOP) into ptrace_set_stopped()
has been removed from the -mm tree.  Its filename was
     ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace_attach: shift send(SIGSTOP) into ptrace_set_stopped()
Date: Mon, 22 Jan 2024 18:16:31 +0100

Turn send_sig_info(SIGSTOP) into send_signal_locked(SIGSTOP) and move it
from ptrace_attach() to ptrace_set_stopped().

This looks more logical and avoids lock(siglock) right after unlock().

Link: https://lkml.kernel.org/r/20240122171631.GA29844@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/kernel/ptrace.c~ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped
+++ a/kernel/ptrace.c
@@ -375,10 +375,13 @@ static int check_ptrace_options(unsigned
 	return 0;
 }
 
-static inline void ptrace_set_stopped(struct task_struct *task)
+static inline void ptrace_set_stopped(struct task_struct *task, bool seize)
 {
 	guard(spinlock)(&task->sighand->siglock);
 
+	/* SEIZE doesn't trap tracee on attach */
+	if (!seize)
+		send_signal_locked(SIGSTOP, SEND_SIG_PRIV, task, PIDTYPE_PID);
 	/*
 	 * If the task is already STOPPED, set JOBCTL_TRAP_STOP and
 	 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
@@ -457,14 +460,8 @@ static int ptrace_attach(struct task_str
 				return -EPERM;
 
 			task->ptrace = flags;
-
 			ptrace_link(task, current);
-
-			/* SEIZE doesn't trap tracee on attach */
-			if (!seize)
-				send_sig_info(SIGSTOP, SEND_SIG_PRIV, task);
-
-			ptrace_set_stopped(task);
+			ptrace_set_stopped(task, seize);
 		}
 	}
 
_

Patches currently in -mm which might be from oleg@redhat.com are


