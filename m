Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9B11411DE
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756834; cv=none; b=ZFO38BBo3AAVncclPQ4X4rv93Rs9R/WTvOwg3KpOTD/ZMrXWJ+w24Kku05daaHhpb+Os6H/GCjF0GrrTRkeKHUUAmOmQOFbO9wOC0esG6u+fj/eDF8z9sUP2MhWP5qH26i2u/IXyCXo0L4RgwV9bpBz0XMtqbk7ER2wOO/G44Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756834; c=relaxed/simple;
	bh=hJ+zTNODnpRSWsXAYSw8x/NdS2C2TukTjEEtkRCbfLU=;
	h=Date:To:From:Subject:Message-Id; b=FIKEyt5tqhBbgQIu+qPnhvV0h4W+CM5Ob8RUHmiDvVZ+CuWvMo+AWZH/FDIz+ke2/QVHfeMgcMDBiB+Qs+bcZQpoWKk7urmDeXacPBr3jTWwfucYpPYEETOS5KPX1t2scfAGZe3xkrpxGlejm36iApKjQlJW/VcsznfGEkjF+5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jeZxVRuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jeZxVRuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9CEC4CEF1;
	Sun,  1 Jun 2025 05:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756834;
	bh=hJ+zTNODnpRSWsXAYSw8x/NdS2C2TukTjEEtkRCbfLU=;
	h=Date:To:From:Subject:From;
	b=jeZxVRuGT9WVVvW2r/swp90U2n82I/FAtZT1OmEt38R6PnVKGOgQEaHa7PbaaxtAZ
	 tFUxD/30NLsdkWgkp9Fu+HcsxlA1TG3pAVyxwPtH2eF363987aMFGpHsOsI8oIzzmE
	 h7mfy1IHFD1gedmm661K/MxFEHYsS8yxlJyKgwpE=
Date: Sat, 31 May 2025 22:47:13 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,kasong@tencent.com,hughd@google.com,baolin.wang@linux.alibaba.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch removed from -mm tree
Message-Id: <20250601054713.EB9CEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: add missing shmem_unacct_size() in __shmem_file_setup()
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: shmem: add missing shmem_unacct_size() in __shmem_file_setup()
Date: Sat, 17 May 2025 01:09:36 +0800

We will miss shmem_unacct_size() when is_idmapped_mnt() returns a failure.
Move is_idmapped_mnt() before shmem_acct_size() to fix the issue.

Link: https://lkml.kernel.org/r/20250516170939.965736-3-shikemeng@huaweicloud.com
Fixes: 7a80e5b8c6fa ("shmem: support idmapped mounts for tmpfs")
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

mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch
mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch
mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch
mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

