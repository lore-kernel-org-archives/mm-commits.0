Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B071411DE
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756836; cv=none; b=CqOlhzazbwhVndgzE232J2SP/Vf0s/xSfrW2AKJAh2bxDe/OVDTrOwBg4213hf9ls9Y9x6ph4lp+bvs2I9JRntlzLs/ABP/5BZl3p/JLx428+gDAfd/u5XFnK6sFSQLI+41ILhnk4QOLo8bTQGGLwK3bymg5mP0Pu1kBwZJRKg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756836; c=relaxed/simple;
	bh=ez4grP7Ylysa0FtGqfoiA6j3vlggHtU5+y1DwYm2qrw=;
	h=Date:To:From:Subject:Message-Id; b=iueT1P2VhZrvmAJjyDwJOVedogYE7fNqF75bL1KSaOCY3a5gZ+9hMus39tBOkBYaC7GZT6u6W8FFHW32S10tym1p7h7XwvHNp/8j1ucCHbyYmb9L51xWOGgpsel+bOxqrk1VI63JFrwf1f83N5upT6PfOwiG0gSNSwAi8VsBvLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nvWIybW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nvWIybW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C733C4CEED;
	Sun,  1 Jun 2025 05:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756836;
	bh=ez4grP7Ylysa0FtGqfoiA6j3vlggHtU5+y1DwYm2qrw=;
	h=Date:To:From:Subject:From;
	b=nvWIybW3CfUFjL55FBUqVSSdRp22/WzUvMbezgP0YXIm5HLcxEkiR10ITah9FKatn
	 EqRXPUfCgfcMhxRx4ITB+QpEpxpEZOZ79zlhXTI14o0I8rXhUhF+tnGbxRhmDMyhIo
	 JJr2cxcVcVTtEQFDFhDFa2qozcrHos7TpkdsS1/Q=
Date: Sat, 31 May 2025 22:47:15 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,kasong@tencent.com,hughd@google.com,baolin.wang@linux.alibaba.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch removed from -mm tree
Message-Id: <20250601054716.4C733C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: only remove inode from swaplist when it's swapped page count is 0
has been removed from the -mm tree.  Its filename was
     mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: shmem: only remove inode from swaplist when it's swapped page count is 0
Date: Sat, 17 May 2025 01:09:38 +0800

Even if we fail to allocate a swap entry, the inode might have previously
allocated entry and we might take inode containing swap entry off
swaplist.  As a result, try_to_unuse() may enter a potential dead loop to
repeatedly look for inode and clean it's swap entry.  Only take inode off
swaplist when it's swapped page count is 0 to fix the issue.

Link: https://lkml.kernel.org/r/20250516170939.965736-5-shikemeng@huaweicloud.com
Fixes: b487a2da3575 ("mm, swap: simplify folio swap allocation")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202505161438.9009cf47-lkp@intel.com
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0
+++ a/mm/shmem.c
@@ -1651,8 +1651,8 @@ try_split:
 		BUG_ON(folio_mapped(folio));
 		return swap_writepage(&folio->page, wbc);
 	}
-
-	list_del_init(&info->swaplist);
+	if (!info->swapped)
+		list_del_init(&info->swaplist);
 	mutex_unlock(&shmem_swaplist_mutex);
 	if (nr_pages > 1)
 		goto try_split;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch
mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch
mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch
mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

