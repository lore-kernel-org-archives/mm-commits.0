Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CF333E5
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 15:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710258098; cv=none; b=bKvpF7uJJtyAUlbvG9pBcN1QQYFTvK4uTs2PvXrUMuXDPllfaA23RmFvH2Bn4NjwYfet5rrGAOgsimjmqe11l8gILvSkoULRDwtnXOwVgF9g2W6nRM4seSP/v011jGvKu0wWB+6NGFc+gzppR5Cm3cd7eQW7LEykFsEqCpsjUkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710258098; c=relaxed/simple;
	bh=McHxpJC2Xf8W5y74l/Bm1WD26PkZyG7F5qd/9s5nRIo=;
	h=Date:To:From:Subject:Message-Id; b=lW8eOwDJPr1dJrO0Azdw1C2IkFk+j03mI1d0iVwBfgiGsWaFvDpDqsEz0ExTbNojtkOahIcZZaqnk1fOqGpOmqGXUzILzk/xhQho3KgjadX8iW77dKsUFwo5a/VGmJ5qRYIvMgS1Fa7CLXA1EjVI1QvqdnaaJRXb0VjijI3GWsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BslOxr2X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BslOxr2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2694C433F1;
	Tue, 12 Mar 2024 15:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710258097;
	bh=McHxpJC2Xf8W5y74l/Bm1WD26PkZyG7F5qd/9s5nRIo=;
	h=Date:To:From:Subject:From;
	b=BslOxr2Xe+2X+TL0SClnmOrqVTtxouNDtsxO8pe3WevxCQC21ASbRvdMonsuVxR2Z
	 DgvdpYWLzlUZYqXRssdxC74+/eKBvPLbLS/pGCDUrf8KtPm0iasLC90AEVHNqAejue
	 fBvFmbBwF0v7LF+mTojERlxTpL7u3VsaXOyarCEI=
Date: Tue, 12 Mar 2024 08:41:37 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-slab_mem_spread-flag-usage.patch added to mm-nonmm-unstable branch
Message-Id: <20240312154137.E2694C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove SLAB_MEM_SPREAD flag usage
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-slab_mem_spread-flag-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-slab_mem_spread-flag-usage.patch

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
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: ocfs2: remove SLAB_MEM_SPREAD flag usage
Date: Sat, 24 Feb 2024 13:50:08 +0000

The SLAB_MEM_SPREAD flag is already a no-op as of 6.8-rc1, remove
its usage so we can delete it from slab. No functional change.

Link: https://lkml.kernel.org/r/20240224135008.829878-1-chengming.zhou@linux.dev
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmfs/dlmfs.c |    2 +-
 fs/ocfs2/super.c       |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/dlmfs/dlmfs.c~ocfs2-remove-slab_mem_spread-flag-usage
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -578,7 +578,7 @@ static int __init init_dlmfs_fs(void)
 	dlmfs_inode_cache = kmem_cache_create("dlmfs_inode_cache",
 				sizeof(struct dlmfs_inode_private),
 				0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
-					SLAB_MEM_SPREAD|SLAB_ACCOUNT),
+					SLAB_ACCOUNT),
 				dlmfs_init_once);
 	if (!dlmfs_inode_cache) {
 		status = -ENOMEM;
--- a/fs/ocfs2/super.c~ocfs2-remove-slab_mem_spread-flag-usage
+++ a/fs/ocfs2/super.c
@@ -1706,18 +1706,17 @@ static int ocfs2_initialize_mem_caches(v
 				       sizeof(struct ocfs2_inode_info),
 				       0,
 				       (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
+						SLAB_ACCOUNT),
 				       ocfs2_inode_init_once);
 	ocfs2_dquot_cachep = kmem_cache_create("ocfs2_dquot_cache",
 					sizeof(struct ocfs2_dquot),
 					0,
-					(SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT,
 					NULL);
 	ocfs2_qf_chunk_cachep = kmem_cache_create("ocfs2_qf_chunk_cache",
 					sizeof(struct ocfs2_quota_chunk),
 					0,
-					(SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD),
+					SLAB_RECLAIM_ACCOUNT,
 					NULL);
 	if (!ocfs2_inode_cachep || !ocfs2_dquot_cachep ||
 	    !ocfs2_qf_chunk_cachep) {
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

ocfs2-remove-slab_mem_spread-flag-usage.patch

