Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB277364BA
	for <mm-commits@vger.kernel.org>; Thu, 20 Mar 2025 01:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742432811; cv=none; b=letm3pAbnSMleLCear9tK0Hu8aKKWiB+/e2GNSWLbh756iWuuxr15mGXfcRy5EkP/qgsgp9uhge0qyEoTYbfAblU3XHynsDyl7iiMzrqofAvG6OuqB1o+cmEhishaR5lvSrn0IydmGYQdWF6YcSlwhamZvo4KagFVj+9RNM7R1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742432811; c=relaxed/simple;
	bh=j7moBb/gnYEnSe8jw2I3k/rKhtkGUx4OFExeURtA3q8=;
	h=Date:To:From:Subject:Message-Id; b=V1H7ZaJToEspIzSXvachZzJMcmbXwrV3sFu6v7J2JjtzT+dZqdWltDMrWWA+dcCycReyYwKg3Q82DHZo7GlevL+eKrIF3tQwCriudRqJ7QNSMM1GLMfs03a4dCvwP1dyfRJ49PMnK5veYZjhMC6eGW8Qv/mHQPkLGw1VATfN/0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Ukf6D/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Ukf6D/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2C1C4CEE4;
	Thu, 20 Mar 2025 01:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742432811;
	bh=j7moBb/gnYEnSe8jw2I3k/rKhtkGUx4OFExeURtA3q8=;
	h=Date:To:From:Subject:From;
	b=0Ukf6D/aOfFcO6iDTqU7rrwZ5Z51y8J5qlwhcxY1xJMMfmqotW+GQJHDFNV57H4zr
	 CRUHR7yLjaf+lInQ3bnc58q2IbUFemrUH9SLbK9Y1JbZgTZO5feGhUqHYRxHzmvgp1
	 cqzlTjK0B84QMykYGCfyuSVmK+VP9cKgEy61TzNo=
Date: Wed, 19 Mar 2025 18:06:50 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,ebiederm@xmission.com,adobriyan@gmail.com,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-procfs-fix-the-comment-above-proc_pid_wchan.patch added to mm-nonmm-unstable branch
Message-Id: <20250320010651.2C2C1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/procfs: fix the comment above proc_pid_wchan()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-procfs-fix-the-comment-above-proc_pid_wchan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-procfs-fix-the-comment-above-proc_pid_wchan.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Bart Van Assche <bvanassche@acm.org>
Subject: fs/procfs: fix the comment above proc_pid_wchan()
Date: Wed, 19 Mar 2025 14:02:22 -0700

proc_pid_wchan() used to report kernel addresses to user space but that is
no longer the case today.  Bring the comment above proc_pid_wchan() in
sync with the implementation.

Link: https://lkml.kernel.org/r/20250319210222.1518771-1-bvanassche@acm.org
Fixes: b2f73922d119 ("fs/proc, core/debug: Don't expose absolute kernel addresses via wchan")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/base.c~fs-procfs-fix-the-comment-above-proc_pid_wchan
+++ a/fs/proc/base.c
@@ -416,7 +416,7 @@ static const struct file_operations proc
 #ifdef CONFIG_KALLSYMS
 /*
  * Provides a wchan file via kallsyms in a proper one-value-per-file format.
- * Returns the resolved symbol.  If that fails, simply return the address.
+ * Returns the resolved symbol to user space.
  */
 static int proc_pid_wchan(struct seq_file *m, struct pid_namespace *ns,
 			  struct pid *pid, struct task_struct *task)
_

Patches currently in -mm which might be from bvanassche@acm.org are

fs-procfs-fix-the-comment-above-proc_pid_wchan.patch

