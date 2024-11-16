Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BC96FB0;
	Sat, 16 Nov 2024 01:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731718856; cv=none; b=hMtfDotBeEJq7ynzSykINSWTZUD065nlv0+wwwEdxWtPKve18zlIvQpPDE6Yvbqsw2PbVwYuj2gkatI7FDBvcVjaAas8Aa9qr/4w7yDYScpazLaazB/m8OsFvKawrZeQAIEej9ipf5H8nneOfHGlGkpfTK5sDpsqXKsQmWAp64M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731718856; c=relaxed/simple;
	bh=QOC0H8qbTZOuS02ORO4XjPKY8ShoQkmQvNIFJLrCWK4=;
	h=Date:To:From:Subject:Message-Id; b=hz/d13WnZJcz6P0n07MPWkYc66IMWvkFq3iOzahp0JNrCxmlv//O0YLL4KQYK28M7/2VQyriX5CLgwa1+DytqkmVaaOAkzCwPNp+F5JUEiTIxQaClJWn9alcQS41GigBwclqYDLWNXdxVRcfZT1evdHG8PlOcDBpxksB82Bzu3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RJJwZjuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RJJwZjuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A67C4CECF;
	Sat, 16 Nov 2024 01:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731718855;
	bh=QOC0H8qbTZOuS02ORO4XjPKY8ShoQkmQvNIFJLrCWK4=;
	h=Date:To:From:Subject:From;
	b=RJJwZjuQfbTzb/u0jnwOLiNxgqku5YtVMxP3FoexDQ0E23e8o2sc+yJFShZ/cGlCH
	 ppHefXSLpBDTxLx2r91yPvbib+biOBAx+/jxArbaOjtHVz7+dBnKb9m6oosBdOQCat
	 l/HU9/lJfL1R/sl2kn5rCq/FsSU28laJ7wabYomI=
Date: Fri, 15 Nov 2024 17:00:51 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,stable@vger.kernel.org,hughd@google.com,chuck.lever@oracle.com,aha310510@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-revert-mm-shmem-fix-data-race-in-shmem_getattr.patch added to mm-hotfixes-unstable branch
Message-Id: <20241116010055.48A67C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: revert "mm: shmem: fix data-race in shmem_getattr()"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-revert-mm-shmem-fix-data-race-in-shmem_getattr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-revert-mm-shmem-fix-data-race-in-shmem_getattr.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: revert "mm: shmem: fix data-race in shmem_getattr()"
Date: Fri Nov 15 04:57:24 PM PST 2024

Revert d949d1d14fa2 ("mm: shmem: fix data-race in shmem_getattr()") as
suggested by Chuck [1].  It is causing deadlocks when accessing tmpfs over
NFS.

Link: https://lkml.kernel.org/r/ZzdxKF39VEmXSSyN@tissot.1015granger.net [1]
Fixes: https://lkml.kernel.org/r/ZzdxKF39VEmXSSyN@tissot.1015granger.net
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/shmem.c~mm-revert-mm-shmem-fix-data-race-in-shmem_getattr
+++ a/mm/shmem.c
@@ -1166,9 +1166,7 @@ static int shmem_getattr(struct mnt_idma
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 			STATX_ATTR_IMMUTABLE |
 			STATX_ATTR_NODUMP);
-	inode_lock_shared(inode);
 	generic_fillattr(idmap, request_mask, inode, stat);
-	inode_unlock_shared(inode);
 
 	if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
 		stat->blksize = HPAGE_PMD_SIZE;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch
mm-revert-mm-shmem-fix-data-race-in-shmem_getattr.patch

