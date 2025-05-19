Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78F4B67A
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 23:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747695689; cv=none; b=seGd5bjdP8BzGwlAaa4BlHuW687JaDplwIEsIPZg42QdJzS3gpf3ZCFfNSBW59csiDt2eofK7PRCWXPQhsubdj4JdFlPkMWj6HsQbNsvmbzjRpg3i3RRnOfi7pT7TboqB63Q9HBmrdwPDuKRlKVrt1v4/jcVXGbluq1V5pMqA1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747695689; c=relaxed/simple;
	bh=W/HDvLM9xUVTVuLG7pNDrD/z2vTXxZbeOlh84nwioa0=;
	h=Date:To:From:Subject:Message-Id; b=GK5DdAkY1M7oc3/z9ihoTUycZRJIbsK3nxq5mOu0/Xkeg3Od1Alu4OPs+VsRZ7IHQRJQ3dXE/NNl1RUbS+yl8O5zbHg+XpgLr71c+VA2n312Hqs+1tVQU/+suPfy57m4rHI/QWV3ZJjMAjwd8H2NiUvMMwS8e8ZPuSpevQcPK+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M0U8E6fs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M0U8E6fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337A4C4CEE4;
	Mon, 19 May 2025 23:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747695689;
	bh=W/HDvLM9xUVTVuLG7pNDrD/z2vTXxZbeOlh84nwioa0=;
	h=Date:To:From:Subject:From;
	b=M0U8E6fsvFJHyGmEzLm3CroivbQ54/6OKMNptcR48n9wx2k4DifUaeqSCMzCzErjC
	 5PPCbeCWdP8o1vjriKvJHdP/qnySIor4YRb4/HgHVZwnPL10ZgAoEPySBt/2Mcyj3a
	 +2/LnmLtotuj8HcJvvMRioyRw9ZAn72VyD5Xs/s8=
Date: Mon, 19 May 2025 16:01:28 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,kasong@tencent.com,hughd@google.com,baolin.wang@linux.alibaba.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch added to mm-new branch
Message-Id: <20250519230129.337A4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: add missing shmem_unacct_size() in __shmem_file_setup()
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: shmem: add missing shmem_unacct_size() in __shmem_file_setup()
Date: Sat, 17 May 2025 01:09:36 +0800

We will miss shmem_unacct_size() when is_idmapped_mnt() returns a failure.
Move is_idmapped_mnt() before shmem_acct_size() to fix the issue.

Link: https://lkml.kernel.org/r/20250516170939.965736-3-shikemeng@huaweicloud.com
Fixes: 7a80e5b8c6fa7 ("shmem: support idmapped mounts for tmpfs")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup
+++ a/mm/shmem.c
@@ -5812,12 +5812,12 @@ static struct file *__shmem_file_setup(s
 	if (size < 0 || size > MAX_LFS_FILESIZE)
 		return ERR_PTR(-EINVAL);
 
-	if (shmem_acct_size(flags, size))
-		return ERR_PTR(-ENOMEM);
-
 	if (is_idmapped_mnt(mnt))
 		return ERR_PTR(-EINVAL);
 
+	if (shmem_acct_size(flags, size))
+		return ERR_PTR(-ENOMEM);
+
 	inode = shmem_get_inode(&nop_mnt_idmap, mnt->mnt_sb, NULL,
 				S_IFREG | S_IRWXUGO, 0, flags);
 	if (IS_ERR(inode)) {
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch
mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch
mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch
mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch

