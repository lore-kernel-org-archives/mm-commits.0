Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2D07081C
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742620254; cv=none; b=PufOV2Cedxu6UJ4Yeq+S8TNORbcYxEWTr4scM2BlkxCZn/LzbCNndLu1o1h/uF5RIAQVuosXPmj3WEnfVteUClQ9kuZf6iB0bqstiVW+iK1vwaVspyjuRW5JbDw3A3MLPEDObmrRWFB3QNiExrObSA9+zxLKAeWRVvy/6SAsxHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742620254; c=relaxed/simple;
	bh=mnDKCcjxETaemFLKQ7OE27O8NRUCnr8LbeKwvS7zbqw=;
	h=Date:To:From:Subject:Message-Id; b=cTdnm6w53sTf10pqCuiV3lLpffsaY7AvHfdovyKlfUsRKsNOXV8POX1lJkGTFu9iImqG1Fqqtq6erPELKvH2BfW3bueilm9+tYHksNlpUk3l7XGZdc3YgQETuTAxxW/XuerdDxupM2JA73JfanQRf1gkX6fEZ397wdCShcvdbg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vx/NzibF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vx/NzibF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E72C4CEDD;
	Sat, 22 Mar 2025 05:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742620254;
	bh=mnDKCcjxETaemFLKQ7OE27O8NRUCnr8LbeKwvS7zbqw=;
	h=Date:To:From:Subject:From;
	b=vx/NzibFwCNCpw4/cc9lTtlu1AvPeI4WJJz4DhCbuvtiK4at4v52ZXhLVvFZNs6Qa
	 Gkx8u0YoFJGtYmRWOSjQXFH7XVq6BxAWwo4iUVFmuOeo6DSSihcK+rUJho4jVr6+yW
	 au6KFlwVGZW3WGnvnqdYpeD/FytHJu9mQ2lxtUl8=
Date: Fri, 21 Mar 2025 22:10:53 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,ebiederm@xmission.com,adobriyan@gmail.com,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-procfs-fix-the-comment-above-proc_pid_wchan.patch removed from -mm tree
Message-Id: <20250322051054.50E72C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/procfs: fix the comment above proc_pid_wchan()
has been removed from the -mm tree.  Its filename was
     fs-procfs-fix-the-comment-above-proc_pid_wchan.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


