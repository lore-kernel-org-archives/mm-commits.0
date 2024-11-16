Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27495621;
	Sat, 16 Nov 2024 23:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731799855; cv=none; b=fxizFwxO1Sdlti2R8PFVL390PGCJNiHz6Fg4WNSyYqdzIfVqv6+HxdFq1oYs36Nix/umBQlJ57Nnpp+rVLLf220XjxUxOTSth3bGWVDkB9rMPBk63qr5Ww4kDEw46y508C2w0ulZd+PSnYoikm6daeQf2Q3OZDPk+kFdYUAVA0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731799855; c=relaxed/simple;
	bh=pFSKbNtJgt4gZgqd5/3angfseALOzBp8X5mUpHiH1FE=;
	h=Date:To:From:Subject:Message-Id; b=E+7AsXbrFLWQmW8HLorEheXikPO+dU68NVsi7vPx1MIvVDnZgeGRHPwHPGF1F7vo4qPPUpn+K2LpA+pLr6lZ9+IcOtLjwg2wPmxNFXjQagbTzRwSdatXFwUNH0Ulk3KUHL/NTnAgO+EFlCSedetOakaG85gtMvjZHpk0/JTC9hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q23Gy8wq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q23Gy8wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FBAC4CEC3;
	Sat, 16 Nov 2024 23:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731799854;
	bh=pFSKbNtJgt4gZgqd5/3angfseALOzBp8X5mUpHiH1FE=;
	h=Date:To:From:Subject:From;
	b=Q23Gy8wqh1ktt2eWfpMILqNQtxzKnN1zw2Y2p7Qahd5A98scqpi+kfGf/LqeKbj+A
	 zP1qHW3psu3fYTe1OdkT5Z/2+5D//h76xj1p2nZHgmUfGuVzBdoxbTewn6Neus/aKb
	 kPhIYVb6fJZ/hdo+ja1GwHDKQZ5dzUpa12VslROA=
Date: Sat, 16 Nov 2024 15:30:50 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,stable@vger.kernel.org,hughd@google.com,chuck.lever@oracle.com,aha310510@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-revert-mm-shmem-fix-data-race-in-shmem_getattr.patch removed from -mm tree
Message-Id: <20241116233053.F1FBAC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: revert "mm: shmem: fix data-race in shmem_getattr()"
has been removed from the -mm tree.  Its filename was
     mm-revert-mm-shmem-fix-data-race-in-shmem_getattr.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: revert "mm: shmem: fix data-race in shmem_getattr()"
Date: Fri Nov 15 04:57:24 PM PST 2024

Revert d949d1d14fa2 ("mm: shmem: fix data-race in shmem_getattr()") as
suggested by Chuck [1].  It is causing deadlocks when accessing tmpfs over
NFS.

As Hugh commented, "added just to silence a syzbot sanitizer splat: added
where there has never been any practical problem".

Link: https://lkml.kernel.org/r/ZzdxKF39VEmXSSyN@tissot.1015granger.net [1]
Fixes: d949d1d14fa2 ("mm: shmem: fix data-race in shmem_getattr()")
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
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

