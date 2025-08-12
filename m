Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94941A9FBA;
	Tue, 12 Aug 2025 06:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754978489; cv=none; b=dtfE8XHNgTfVePow7GLKx9aRTK6wweWkiajsG/w85lRz90rx9SYj3mn2gZJshrwUtiw8phfq4tSGOKG761FveJcLsUVAC2LHpipKYdkkvsxBsle6tjWp36n3QJxlycThdpz78cG81Qcv9ZCWxCFsCRI5H8ZMBMcsSNqPl9XPPH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754978489; c=relaxed/simple;
	bh=kHUmZi6Ro2jQDTTMrAt5oJCn2qzTWXRjjIO5jW8UTgI=;
	h=Date:To:From:Subject:Message-Id; b=sNIRfJRf4QJHGOqBADBQtJm71vcXGpRIyhDBcdo9KG7bPgSs9E8jqqV278xi+Gi7wlv1TGEpUpwmb3KCgxhiDvQQaAY1HRh/waDJ6SRmtnnJXdocVX2YRpEKmY0JonV/gZxn3w/yRSAtj8nS63sc+fKerdIxKP6+0dGVjI+p+CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sb1Zq/SX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sb1Zq/SX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC8EC4CEF0;
	Tue, 12 Aug 2025 06:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754978489;
	bh=kHUmZi6Ro2jQDTTMrAt5oJCn2qzTWXRjjIO5jW8UTgI=;
	h=Date:To:From:Subject:From;
	b=Sb1Zq/SXnUzsTQ82GcGMpfCnfjED3XNOJ4mEnNAxua7hQDLEq2dRlB5s7Ge1bUn5K
	 pXhBCbtOPjD8V9gL8BsbbT+bDHL5nxvlYkUhoN0d5XgwqVFYIlHPZTfEHpagmI+FS6
	 iHjKNUU9AbW3JOXdQLLJzmlFQyI30yazPVpuh8sM=
Date: Mon, 11 Aug 2025 23:01:29 -0700
To: mm-commits@vger.kernel.org,superman.xpt@gmail.com,stable@vger.kernel.org,wjl.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] proc-proc_maps_open-allow-proc_mem_open-to-return-null.patch removed from -mm tree
Message-Id: <20250812060129.8FC8EC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: proc_maps_open allow proc_mem_open to return NULL
has been removed from the -mm tree.  Its filename was
     proc-proc_maps_open-allow-proc_mem_open-to-return-null.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jialin Wang <wjl.linux@gmail.com>
Subject: proc: proc_maps_open allow proc_mem_open to return NULL
Date: Fri, 8 Aug 2025 00:54:55 +0800

The commit 65c66047259f ("proc: fix the issue of proc_mem_open returning
NULL") caused proc_maps_open() to return -ESRCH when proc_mem_open()
returns NULL.  This breaks legitimate /proc/<pid>/maps access for kernel
threads since kernel threads have NULL mm_struct.

The regression causes perf to fail and exit when profiling a kernel
thread:

  # perf record -v -g -p $(pgrep kswapd0)
  ...
  couldn't open /proc/65/task/65/maps

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


