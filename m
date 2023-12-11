Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C877493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2vPa221b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2AEC433C9;
	Mon, 11 Dec 2023 01:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257786;
	bh=/AM8J2tsvMw+ZFW4B7qTrwClpl0D0w+SFsGGeUAWjlk=;
	h=Date:To:From:Subject:From;
	b=2vPa221b1PlcBS9JfqovLmqZw4hEdeCGx6EtfuiRVvGxxpOkCZ5CZnsKbX77FmWxC
	 xTQFgR/qIVQS/CoSKbepAbpkmHmE+QS5hIYqgdCgMwYSF/fsXIUogYMonVOKLZBIv0
	 kAJ46Xvqcrg36bQuiZOi19imPgiMiSdkgZGIaeLs=
Date: Sun, 10 Dec 2023 17:23:06 -0800
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] __ptrace_unlink-kill-the-obsolete-fixme-code.patch removed from -mm tree
Message-Id: <20231211012306.AB2AEC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: __ptrace_unlink: kill the obsolete "FIXME" code
has been removed from the -mm tree.  Its filename was
     __ptrace_unlink-kill-the-obsolete-fixme-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: __ptrace_unlink: kill the obsolete "FIXME" code
Date: Tue, 21 Nov 2023 17:26:50 +0100

The corner case described by the comment is no longer possible after the
commit 7b3c36fc4c23 ("ptrace: fix task_join_group_stop() for the case when
current is traced"), task_join_group_stop() ensures that the new thread
has the correct signr in JOBCTL_STOP_SIGMASK regardless of ptrace.

Link: https://lkml.kernel.org/r/20231121162650.GA6635@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/kernel/ptrace.c~__ptrace_unlink-kill-the-obsolete-fixme-code
+++ a/kernel/ptrace.c
@@ -145,20 +145,9 @@ void __ptrace_unlink(struct task_struct
 	 */
 	if (!(child->flags & PF_EXITING) &&
 	    (child->signal->flags & SIGNAL_STOP_STOPPED ||
-	     child->signal->group_stop_count)) {
+	     child->signal->group_stop_count))
 		child->jobctl |= JOBCTL_STOP_PENDING;
 
-		/*
-		 * This is only possible if this thread was cloned by the
-		 * traced task running in the stopped group, set the signal
-		 * for the future reports.
-		 * FIXME: we should change ptrace_init_task() to handle this
-		 * case.
-		 */
-		if (!(child->jobctl & JOBCTL_STOP_SIGMASK))
-			child->jobctl |= SIGSTOP;
-	}
-
 	/*
 	 * If transition to TASK_STOPPED is pending or in TASK_TRACED, kick
 	 * @child in the butt.  Note that @resume should be used iff @child
_

Patches currently in -mm which might be from oleg@redhat.com are


