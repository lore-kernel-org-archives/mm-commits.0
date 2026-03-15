Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D24919539F;
	Sun, 15 Mar 2026 20:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773607418; cv=none; b=lJfJktyc8jz4HaGzzvDzOHbC1yVqdk3n4u5eT/jiXthaaKODFoHqOWJwAbtzi6eVbocRIu53i9JrdOEsdsfYy1qNyfG3EWC4bLBjL+rYPaJ1DFmeH5tWJ9e1cwq1r3n8ZR0XPPSAoYp8DR35xVepUjJiZh25wnXu6yze8eBm3iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773607418; c=relaxed/simple;
	bh=m+AZNwVISlRtlPucyx9mZpMA7diB7VjTP/3aEWFd8cg=;
	h=Date:To:From:Subject:Message-Id; b=hPPun6HHhWdvD59IX9amTNa6r0RSVKoeYEy8DrMrKa2a8ZxhY2+Tvy1dfgPszsd4d6rpO/m0/LhsjX+WgPNuKnTjEpBOf9S5Pxl2nCdt2+sHrwH9/zzq7BG60//5X1V/UgojwVC+SdoxQ4c3OGZpnbC3CX5OP8Yk+OTLcaqRrtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d/mSeMrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d/mSeMrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0897C4CEF7;
	Sun, 15 Mar 2026 20:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773607418;
	bh=m+AZNwVISlRtlPucyx9mZpMA7diB7VjTP/3aEWFd8cg=;
	h=Date:To:From:Subject:From;
	b=d/mSeMrfhm7pvCWdx44c4UJ4xCrqtzPvVl9w0pVLREdNdybFY33rhU0RxWXHQxfiI
	 3gKIT90dLfPa6G5ENBLRNAAs7YPPBh43a1uqB151wF6V6WodCPHkRSz8M842LWepYr
	 vZz61hVEC2NHTzKIYobYGoW4qy7bofYFVpn0M1cc=
Date: Sun, 15 Mar 2026 13:43:37 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,oleg@redhat.com,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kees@kernel.org,Kartikey406@gmail.com,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,brauner@kernel.org,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kernel-fork-validate-exit_signal-in-clone-syscall.patch removed from -mm tree
Message-Id: <20260315204337.F0897C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/fork: validate exit_signal in clone() syscall
has been removed from the -mm tree.  Its filename was
     kernel-fork-validate-exit_signal-in-clone-syscall.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: kernel/fork: validate exit_signal in clone() syscall
Date: Sat, 7 Mar 2026 12:12:02 +0530

When a child process exits, it sends exit_signal to its parent via
do_notify_parent().  The clone() syscall constructs exit_signal as:

  (lower_32_bits(clone_flags) & CSIGNAL)

CSIGNAL is 0xff, so values in the range 65-255 are possible.  However,
valid_signal() only accepts signals up to _NSIG (64 on x86_64), causing a
WARN_ON in do_notify_parent() when the process exits:

  WARNING: kernel/signal.c:2174 do_notify_parent+0xc7e/0xd70

The syzkaller reproducer triggers this by calling clone() with flags=0x80,
resulting in exit_signal = (0x80 & CSIGNAL) = 128, which exceeds _NSIG and
is not a valid signal.

The comment above kernel_clone() states that callers are expected to
validate exit_signal.  clone3() correctly does this:

  if (unlikely((args.exit_signal & ~((u64)CSIGNAL)) ||
               !valid_signal(args.exit_signal)))
          return -EINVAL;

The clone() syscall has no such check.  Add the missing valid_signal()
check to clone(), consistent with the existing validation in clone3().

Link: https://lkml.kernel.org/r/20260307064202.353405-1-kartikey406@gmail.com
Fixes: 3f2c788a1314 ("fork: prevent accidental access to clone3 features")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Reported-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bbe6b99feefc3a0842de
Tested-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Cc: Ben Segall <bsegall@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/fork.c~kernel-fork-validate-exit_signal-in-clone-syscall
+++ a/kernel/fork.c
@@ -2796,7 +2796,8 @@ SYSCALL_DEFINE5(clone, unsigned long, cl
 		.stack		= newsp,
 		.tls		= tls,
 	};
-
+	if (!valid_signal(args.exit_signal))
+		return -EINVAL;
 	return kernel_clone(&args);
 }
 #endif
_

Patches currently in -mm which might be from kartikey406@gmail.com are


