Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B38B2D94AF
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 15:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675727; cv=none; b=NUd7vgQ9lq6ZLTh7tEKmxDrcNXnFG0UBkMoFUe32ummR/8vj36QXqEIurQzJxtwcRvdj0PNrNxow68zJzFoW1fnskZnyVFbOb4uPdvZDSzX39a6JwA/bxsMvrR95Q6/rs5UkXD1bm3nlGtUrt45lSHOifmnCY+svQfDWbxrybzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675727; c=relaxed/simple;
	bh=zuizUDw2yjVNEZVq2EALz2nBUPukulevWA7qi6tCKjg=;
	h=Date:To:From:Subject:Message-Id; b=AVE9etppM1C8yowjRjCxPjPAESZoIlkKATcgJYancQKooXw+r+cWufHK+0LotTr0yFBI9xew2J2fngOaLUQ72fYVtEjPxD+ZJSKyD25vs8FlFN2y4su4Ad2SYPKNvT2BuZVFVFyTerRWxHQq1C0Hl2M4yknlRE/cv5XAISPxQSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aB/qvaTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aB/qvaTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CA4C19421;
	Mon, 16 Mar 2026 15:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773675726;
	bh=zuizUDw2yjVNEZVq2EALz2nBUPukulevWA7qi6tCKjg=;
	h=Date:To:From:Subject:From;
	b=aB/qvaToNqEyVawD10sBYuXrGTX5JzEF8kz9SXUR1xkvy6kv9ybVfoSBTrbj2l6QO
	 FnBoZXpJ5XSqsNTimr8zfNdhjKnxfuBUwEAOdDkowFTbAEo06mvQjH7Ban8ND5AnkI
	 7m/hq188BGSe4r6IAawxnV/inqTw+0A0lmGU9NC0=
Date: Mon, 16 Mar 2026 08:42:06 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,oleg@redhat.com,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,ljs@kernel.org,Liam.Howlett@oracle.com,liam.howlett@oracle.com,kees@kernel.org,Kartikey406@gmail.com,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,brauner@kernel.org,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-fork-validate-exit_signal-in-kernel_clone.patch added to mm-nonmm-unstable branch
Message-Id: <20260316154206.C5CA4C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/fork: validate exit_signal in kernel_clone()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-fork-validate-exit_signal-in-kernel_clone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-fork-validate-exit_signal-in-kernel_clone.patch

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
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: kernel/fork: validate exit_signal in kernel_clone()
Date: Mon, 16 Mar 2026 20:49:56 +0530

When a child process exits, it sends exit_signal to its parent via
do_notify_parent().  The clone() syscall constructs exit_signal as:

(lower_32_bits(clone_flags) & CSIGNAL)

CSIGNAL is 0xff, so values in the range 65-255 are possible.  However,
valid_signal() only accepts signals up to _NSIG (64 on x86_64).  A
non-zero non-valid exit_signal acts the same as exit_signal == 0: the
parent process is not signaled when the child terminates.

The syzkaller reproducer triggers this by calling clone() with flags=0x80,
resulting in exit_signal = (0x80 & CSIGNAL) = 128, which exceeds _NSIG and
is not a valid signal.

The v1 of this patch added the check only in the clone() syscall handler,
which is incomplete.  kernel_clone() has other callers such as
sys_ia32_clone() which would remain unprotected.  Move the check to
kernel_clone() to cover all callers.

Since the valid_signal() check is now in kernel_clone() and covers all
callers including clone3(), the same check in copy_clone_args_from_user()
becomes redundant and is removed.  The higher 32bits check for clone3() is
kept as it is clone3() specific.

Note that this is a user-visible change: previously, passing an invalid
exit_signal to clone() was silently accepted.  The man page for clone()
does not document any defined behavior for invalid exit_signal values, so
rejecting them with -EINVAL is the correct behavior.  It is unlikely that
any sane application relies on passing an invalid exit_signal.

Link: https://lkml.kernel.org/r/20260316151956.563558-1-kartikey406@gmail.com
Fixes: 3f2c788a1314 ("fork: prevent accidental access to clone3 features")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Reported-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bbe6b99feefc3a0842de
Tested-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20260307064202.353405-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20260316104536.558108-1-kartikey406@gmail.com/T/ [v2]
Cc: Ben Segall <bsegall@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/fork.c~kernel-fork-validate-exit_signal-in-kernel_clone
+++ a/kernel/fork.c
@@ -2642,6 +2642,9 @@ pid_t kernel_clone(struct kernel_clone_a
 	    (args->pidfd == args->parent_tid))
 		return -EINVAL;
 
+	if (!valid_signal(args->exit_signal))
+		return -EINVAL;
+
 	/*
 	 * Determine whether and which event to report to ptracer.  When
 	 * called from kernel_thread or CLONE_UNTRACED is explicitly
@@ -2840,11 +2843,9 @@ static noinline int copy_clone_args_from
 		return -EINVAL;
 
 	/*
-	 * Verify that higher 32bits of exit_signal are unset and that
-	 * it is a valid signal
+	 * Verify that higher 32bits of exit_signal are unset
 	 */
-	if (unlikely((args.exit_signal & ~((u64)CSIGNAL)) ||
-		     !valid_signal(args.exit_signal)))
+	if (unlikely(args.exit_signal & ~((u64)CSIGNAL)))
 		return -EINVAL;
 
 	if ((args.flags & CLONE_INTO_CGROUP) &&
_

Patches currently in -mm which might be from kartikey406@gmail.com are

kernel-fork-validate-exit_signal-in-kernel_clone.patch

