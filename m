Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CE91624C0
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 22:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785365463; cv=none; b=Irv6kuUb3InjjZ5sPnJW5n2AOWVKrgeCus5l8ZjWZ9AmdA+zGD/HVO6KKrBZSToHNgYObs8ICU+cIpDcl/KGaVTW8BnUvCTufqovDGHItqR8o4O1RI4g1d/cgcbIA75hDtykjU1Rf80VXlponRPqsNhQp6MIHUu7gpU5Kay3aqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785365463; c=relaxed/simple;
	bh=4dZsvHd5Kh8IWiV96aDdD08rj+aYYMhN9Pj+3FwJiPo=;
	h=Date:To:From:Subject:Message-Id; b=j/kZsuWKfOt1OMSZUVdkZpZgX8L93YoQAuqy1dea/uddqtJsI7ZHYgfwKJgnZfYPKN86p2sstgmwvwvAIu6NSj93g9UWFloGO5jCkO32yPpenRUbMx7LoAfPidISsUCqNrV0f5fDhKMbvRRAiML+1HYD0wnL0Bl6cVBJYHIIZjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fhCQaQw6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fhCQaQw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E838D1F000E9;
	Wed, 29 Jul 2026 22:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785365462;
	bh=8purD3vQJ6ryzcwXzm9BRjRzdMWigYBPicc2C5uZOIs=;
	h=Date:To:From:Subject;
	b=fhCQaQw63i2vUkUTO19s5AdtZ7xdAO6u7y3rnw98owOTyg3pdnXtZB3o+Z2832ux3
	 WHWRLK0JjGiS70juFqkDsWDVMORIF1Fjd1Ft4bfc1Vyng7PXzGgB1xvBPd13c3HQ2j
	 3HYGBRx5Gqmk663+fuzRI/NXdw7kxqNWH//kMB1k=
Date: Wed, 29 Jul 2026 15:51:01 -0700
To: mm-commits@vger.kernel.org,liuyongqiang13@huawei.com,hughd@google.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,yujiacheng3@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn-fix.patch added to mm-new branch
Message-Id: <20260729225101.E838D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jiacheng Yu <yujiacheng3@huawei.com>
Subject: mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn-fix
Date: Wed, 29 Jul 2026 12:12:00 +0000

drop redundant casts in shmem_evict_inode() pr_warn

blkcnt_t and i_ino are u64, %llu matches both directly, so drop the casts.

Link: https://lore.kernel.org/20260729121201.776566-1-yujiacheng3@huawei.com
Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn-fix
+++ a/mm/shmem.c
@@ -1442,8 +1442,7 @@ static void shmem_evict_inode(struct ino
 	shmem_free_inode(inode->i_sb, freed);
 	if (inode->i_blocks)
 		pr_warn("%s: ino=%llu i_blocks=%llu alloced=%lu swapped=%lu nrpages=%lu\n",
-			__func__, (unsigned long long)inode->i_ino,
-			(unsigned long long)inode->i_blocks,
+			__func__, inode->i_ino, inode->i_blocks,
 			info->alloced, info->swapped, inode->i_mapping->nrpages);
 	clear_inode(inode);
 #ifdef CONFIG_TMPFS_QUOTA
_

Patches currently in -mm which might be from yujiacheng3@huawei.com are

mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn.patch
mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn-fix.patch

