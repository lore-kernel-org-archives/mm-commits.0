Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79742219A79;
	Thu,  7 Aug 2025 22:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754606861; cv=none; b=GUv1alPsZ+ptlPRrfbCBC83vQH/eqZEBdpriXwY0Bd5YPxhS5iL3zVvFMHflFYeWF4aZFlAHMPI7ussdjasda/RgH2XwG4woMcGpfE0GsL09h8o5Vc0/3vaITRgx6hoctDpV53JavFDg2seVT5x9a177D31pG1FTQNey9wKnI58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754606861; c=relaxed/simple;
	bh=AFdbj0skQYjMg5havIsFj3cVBQZpyVUMrBwCBen6SFA=;
	h=Date:To:From:Subject:Message-Id; b=X9u9lJmSrggtvqgdTUEAgepSu9X4PaniaSh02RmHgJvhKKu9ikRdaSn3h23m9XQxm/+hvdqyTbpkVlviJbFRX/mQLTEsJcEM2DcHBBWEUyyrMpWbAzNEOoVotLTSk6qwUrEPNrDfmZ2T+hfkk6nk1RIwXdyEmAPA0qh/odRPr6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QIEEbaLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QIEEbaLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1939C4CEEB;
	Thu,  7 Aug 2025 22:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754606861;
	bh=AFdbj0skQYjMg5havIsFj3cVBQZpyVUMrBwCBen6SFA=;
	h=Date:To:From:Subject:From;
	b=QIEEbaLwR4StjZEYxljESYwx+a1z0LXQNB8B+YqpNkth6hz7s/cxSHADTUrN1ru1N
	 F2f9XnGEe5RdDKP/140oVbmXLmAc/sT3aNzt97cPM2NvF4p4Ddk/EIc6Onq1aBmETo
	 SgkxKT9KcNV/nJw9OZLF8Nl9KvPoEOhdsr3hd8+Q=
Date: Thu, 07 Aug 2025 15:47:40 -0700
To: mm-commits@vger.kernel.org,superman.xpt@gmail.com,stable@vger.kernel.org,wjl.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-proc_maps_open-allow-proc_mem_open-to-return-null.patch added to mm-hotfixes-unstable branch
Message-Id: <20250807224740.E1939C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: proc_maps_open allow proc_mem_open to return NULL
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     proc-proc_maps_open-allow-proc_mem_open-to-return-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-proc_maps_open-allow-proc_mem_open-to-return-null.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jialin Wang <wjl.linux@gmail.com>
Subject: proc: proc_maps_open allow proc_mem_open to return NULL
Date: Fri, 8 Aug 2025 00:54:55 +0800

commit 65c66047259f ("proc: fix the issue of proc_mem_open returning
NULL") breaks `perf record -g -p PID` when profiling a kernel thread.

The strace of `perf record -g -p $(pgrep kswapd0)` shows:

  openat(AT_FDCWD, "/proc/65/task/65/maps", O_RDONLY) = -1 ESRCH (No such process)

This patch partially reverts the commit to fix it.

Link: https://lkml.kernel.org/r/20250807165455.73656-1-wjl.linux@gmail.com
Fixes: 65c66047259f ("proc: fix the issue of proc_mem_open returning NULL")
Signed-off-by: Jialin Wang <wjl.linux@gmail.com>
Cc: Penglei Jiang <superman.xpt@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~proc-proc_maps_open-allow-proc_mem_open-to-return-null
+++ a/fs/proc/task_mmu.c
@@ -340,8 +340,8 @@ static int proc_maps_open(struct inode *
 
 	priv->inode = inode;
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR_OR_NULL(priv->mm)) {
-		int err = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
+	if (IS_ERR(priv->mm)) {
+		int err = PTR_ERR(priv->mm);
 
 		seq_release_private(inode, file);
 		return err;
_

Patches currently in -mm which might be from wjl.linux@gmail.com are

proc-proc_maps_open-allow-proc_mem_open-to-return-null.patch

