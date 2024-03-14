Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FD97350F
	for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2024 16:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710433071; cv=none; b=vCmDKaFEYCYDm8aRX6CkUxdROYCJalBy4cRhm7WN2SZcH/1Ur40LqWQ2XLH5UK4HuqElmCdLVLwkYLxssowU3c4UOWJ6SsVcqNC1ZWR/FgSn3ntyBoFhHndCxRK8Asb8fzaVuHjA+65UioTMUGcFOHlAqmfC8Fc5rhpqfwbNdOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710433071; c=relaxed/simple;
	bh=hSv7r2iyfrghbR3sr5YmH1/F3Pu+/z3q+I8hHSnvD98=;
	h=Date:To:From:Subject:Message-Id; b=eWn8L9ZQkaWc9Xs0PCyxxg9rH0GG5jwS3LoYq6BiCEyCmBeIElSlGLXZNSZDdJk0xxnolHW1wlJLAwRqQNy17XSKKKhGf6GH2T/ds2cTtyr9B0vhZ50rcjqBfWnW6Xk2rw16KQ7Aj7ksgPc22fG5YuhaIYr3Jn84pLBZ7lswW7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W23wuXFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W23wuXFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2609DC433F1;
	Thu, 14 Mar 2024 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710433071;
	bh=hSv7r2iyfrghbR3sr5YmH1/F3Pu+/z3q+I8hHSnvD98=;
	h=Date:To:From:Subject:From;
	b=W23wuXFxhGbFgZ5BRSA/NCjCciSS6ayTDDv2dEMGHYF5yqhJTTO8SCAAi5zMQCUJt
	 vpEqWhl0Ewxy1vlfZ9DVdtDzeSJuRGqieyYE9VKt0TqCXGD0l8gEnt/0CW6SkVmAY5
	 Q9S97kHlzkbfXMTew/irun917QpkY99Ek3qqNNa0=
Date: Thu, 14 Mar 2024 09:17:50 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-slab_mem_spread-flag-usage.patch removed from -mm tree
Message-Id: <20240314161751.2609DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove SLAB_MEM_SPREAD flag usage
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-slab_mem_spread-flag-usage.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


