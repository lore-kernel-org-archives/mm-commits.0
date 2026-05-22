Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AD52D6E6C
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 02:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779415624; cv=none; b=soZ5LwLaOqmd1k04TkFv3rAskC6D5cJWxnktmDNgPk5lYEHWcWw7kF5OAykxpH99AKwIy1tXK37LL38FT3MaxxjthP180MkjA8kseooebyKxEoUWX0B2Z0My0/Oja6V9X0HIvtHnCNbkFkxNF59Up4ahBsoFBym/mlOUjHPtf8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779415624; c=relaxed/simple;
	bh=rSmvRc0alCDdX4Ve7XHT586fai9FgtyHM0T6w110lTU=;
	h=Date:To:From:Subject:Message-Id; b=q8JAq4HuQmmqW5lzJMwQdLs+U+rBpxWDx/VCPttKW5hy9kATLntbcQjj/EL7mpGQhf0V0itkKGVt+H923jS8Rh6FlsyxNPOehp5LEcvBGn7LD1lZzHcjryIIO9ye1VTyPvTUrVSIzgQQd6f+KxlStmlF2WJKdMBmB0uqnobaB8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M5E7LEoA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M5E7LEoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F821F000E9;
	Fri, 22 May 2026 02:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779415623;
	bh=TQQm6Sr5gX8x4k1nFkY5IsPc/HIwqdTpF8xM0INDDVE=;
	h=Date:To:From:Subject;
	b=M5E7LEoA7lIyzYvLCphn21gjfngUIYZJUmAFPgWESFosOU2u+EonMorw6wHmRIoLF
	 2gaIi+Wi1Jttzb1lQDA4bcpm1KNdLcXJ1jujsgfCSraqbeMQJRVtW4yLLHWiOAE4XM
	 G+JL04/h8QL+d6WZ6b8jOr/aAXB0/idCXYWOReRY=
Date: Thu, 21 May 2026 19:07:02 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,penguin-kernel@I-love.SAKURA.ne.jp,oleg@redhat.com,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,ljs@kernel.org,liam@infradead.org,kees@kernel.org,Kartikey406@gmail.com,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,brauner@kernel.org,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kernel-fork-validate-exit_signal-in-kernel_clone.patch removed from -mm tree
Message-Id: <20260522020703.24F821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/fork: validate exit_signal in kernel_clone()
has been removed from the -mm tree.  Its filename was
     kernel-fork-validate-exit_signal-in-kernel_clone.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[oleg@redhat.com: the comment above kernel_clone() should be updated]
  Link: https://lore.kernel.org/abwvgU17W8wuW2-J@redhat.com
Link: https://lore.kernel.org/20260316151956.563558-1-kartikey406@gmail.com
Fixes: 3f2c788a1314 ("fork: prevent accidental access to clone3 features")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bbe6b99feefc3a0842de
Tested-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20260307064202.353405-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20260316104536.558108-1-kartikey406@gmail.com/T/ [v2]
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Ben Segall <bsegall@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/kernel/fork.c~kernel-fork-validate-exit_signal-in-kernel_clone
+++ a/kernel/fork.c
@@ -2664,8 +2664,6 @@ struct task_struct *create_io_thread(int
  *
  * It copies the process, and if successful kick-starts
  * it and waits for it to finish using the VM if required.
- *
- * args->exit_signal is expected to be checked for sanity by the caller.
  */
 pid_t kernel_clone(struct kernel_clone_args *args)
 {
@@ -2700,6 +2698,9 @@ pid_t kernel_clone(struct kernel_clone_a
 	    (args->pidfd == args->parent_tid))
 		return -EINVAL;
 
+	if (!valid_signal(args->exit_signal))
+		return -EINVAL;
+
 	/*
 	 * Determine whether and which event to report to ptracer.  When
 	 * called from kernel_thread or CLONE_UNTRACED is explicitly
@@ -2898,11 +2899,9 @@ static noinline int copy_clone_args_from
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

mm-hugetlb-fix-hugetlb-cgroup-rsvd-charge-uncharge-mismatch.patch

