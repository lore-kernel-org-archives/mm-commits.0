Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1FF1411DE
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756838; cv=none; b=imP0pr4C14/4eRUoWbTovzNzuzuwX6fyU3XOtYIfSps2ApnK8j+mxIsjMntV2/KxfSmsSnCoOSPQbs8YpflZLyCDeg11W9SYika3Sn/3tNIHcQMfN5XJMTiDlsvU+uvVjzNfvzwOukNGa/LdSX2WbxIHkn1a2kFPCZZK1nYa5Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756838; c=relaxed/simple;
	bh=lXTVMOaGW1RjjW75QD0z1ImRfniDFPQs0lrfwWNhoWY=;
	h=Date:To:From:Subject:Message-Id; b=lNkRoubauFGzwbSNKTtR2WgkBhKBp3aNwfZW1rpt+xongEhhmAJg5q2gzHS1pTrG4159s6zdUcsKfQBm4BBeZ2Izk1qOC0NlR2D+ZyovQgTFQrC60Ikodwkd1X5VXR6tFbwp8ItdGWC06JnZQvrzK4CSnBBoClZrXRx25jVzWvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MkzMABCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MkzMABCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CFAC4CEED;
	Sun,  1 Jun 2025 05:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756837;
	bh=lXTVMOaGW1RjjW75QD0z1ImRfniDFPQs0lrfwWNhoWY=;
	h=Date:To:From:Subject:From;
	b=MkzMABCdhwRfWHOkfBDk4BoJ3NJRf3iwf1D+V2tUZhJ69334gQWXQr08TnnbGJ7Hp
	 XyGZ/z4H4iOOJAd+daZdjOMNdTVws+mrGe1ZAqXneGT1+2oQiu41VlPltkSUldbk43
	 e2JSj6sB+Ma52yisuprQBjjRz57KRp/asWSmgaiY=
Date: Sat, 31 May 2025 22:47:16 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,kasong@tencent.com,hughd@google.com,baolin.wang@linux.alibaba.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch removed from -mm tree
Message-Id: <20250601054717.72CFAC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: remove unneeded xa_is_value() check in shmem_unuse_swap_entries()
has been removed from the -mm tree.  Its filename was
     mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/shmem: remove unneeded xa_is_value() check in shmem_unuse_swap_entries()
Date: Sat, 17 May 2025 01:09:39 +0800

As only value entry will be added to fbatch in shmem_find_swap_entries(),
there is no need to do xa_is_value() check in shmem_unuse_swap_entries().

Link: https://lkml.kernel.org/r/20250516170939.965736-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries
+++ a/mm/shmem.c
@@ -1446,8 +1446,6 @@ static int shmem_unuse_swap_entries(stru
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
-		if (!xa_is_value(folio))
-			continue;
 		error = shmem_swapin_folio(inode, indices[i], &folio, SGP_CACHE,
 					mapping_gfp_mask(mapping), NULL, NULL);
 		if (error == 0) {
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch
mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch
mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch
mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

