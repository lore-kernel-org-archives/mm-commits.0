Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689D31411DE
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756833; cv=none; b=I+CnTmzZlfJVoea0gVKzfauNi6GjPwMEMC3IjRWloaSxFn7fMYtTG2JfWrELE16bMOu0p15OLxJwtAjBs5DC1RJL60RexuM0G8sQYDFMRTdoBOfYhcKCoI1/aAwU0apz5utvheVeqOGOZm8fXJiJIl4Hby/5zHjUkckojZREAmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756833; c=relaxed/simple;
	bh=nytfbRtElJJsCzuqBpGucmK23K+c5CXqbXX31IyJbFo=;
	h=Date:To:From:Subject:Message-Id; b=Yv6FLzKnaN5iNvRsrMIRHSQwA5xH5ixrntk73xiQqjBvVIRcTDZARfRY74eZvEs4FE9LbJYU3kajN0mOggJbyVw+gq3YTsXTvyXhg5nA7r6Lt2Qte5zxgoUQsBZknpznKHFb8Z8iI7LESV3RTdDid7LjAc+MRn1Ut/mEzAFUA2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e+iknmkK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e+iknmkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB37DC4CEED;
	Sun,  1 Jun 2025 05:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756832;
	bh=nytfbRtElJJsCzuqBpGucmK23K+c5CXqbXX31IyJbFo=;
	h=Date:To:From:Subject:From;
	b=e+iknmkKV3rk9aJwHru3Qj4TP+L9/EmYrB/iijm8BaJsmzrWhUUC+mVmZGMSeiwJH
	 zriVpoFR8HJytAmp4Gy7OS4Xpe5/DZkBzRxDDjA4sRCkK6xPdeq802ct0NwK/qX9Ex
	 6ZLdcKTMXkYY96Iw/eK+sO5G+KN3DWlB6zlCEIwE=
Date: Sat, 31 May 2025 22:47:12 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,kasong@tencent.com,hughd@google.com,baolin.wang@linux.alibaba.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch removed from -mm tree
Message-Id: <20250601054712.CB37DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: avoid unpaired folio_unlock() in shmem_swapin_folio()
has been removed from the -mm tree.  Its filename was
     mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: shmem: avoid unpaired folio_unlock() in shmem_swapin_folio()
Date: Sat, 17 May 2025 01:09:35 +0800

Patch series "Some random fixes and cleanup to shmem", v3.

This series contains some simple fixes and cleanup which are made during
learning shmem.  More details can be found in respective patches.


This patch (of 5):

If we get a folio from swap_cache_get_folio() successfully but encounter a
failure before the folio is locked, we will unlock the folio which was not
previously locked.

Put the folio and set it to NULL when a failure occurs before the folio is
locked to fix the issue.

Link: https://lkml.kernel.org/r/20250516170939.965736-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20250516170939.965736-2-shikemeng@huaweicloud.com
Fixes: 058313515d5a ("mm: shmem: fix potential data corruption during shmem swapin")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shmem.c~mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio
+++ a/mm/shmem.c
@@ -2335,6 +2335,8 @@ static int shmem_swapin_folio(struct ino
 		 */
 		split_order = shmem_split_large_entry(inode, index, swap, gfp);
 		if (split_order < 0) {
+			folio_put(folio);
+			folio = NULL;
 			error = split_order;
 			goto failed;
 		}
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch
mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch
mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch
mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

