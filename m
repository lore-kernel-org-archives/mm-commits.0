Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD61319E994
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 05:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239452; cv=none; b=OVR01rsjpSCLmj8gl7uGhN+lkpVPw+felaQiI10VnWUGZpuFf4IMVBcWVW7zhtFgoBk/EU9PDJDmS/CjFMKUcazMAFaHpaKo+E1/tyDmuqHloLQvs7XdNUZ9PLDU9LuFpZsbIVigPFUvuCLBdXG1+jIOK5afAagQZBgg9viHa9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239452; c=relaxed/simple;
	bh=D61EtfG+daAkHy86eVAv9vRk4t3+/uL5cH9SrQqV9yc=;
	h=Date:To:From:Subject:Message-Id; b=LVxYeN5xrvpWSPmvmXNADQ0car69a8lib9yY2SstzS5pWg5jf1dlUFxC4rRbBFgWHGLrZ97YuzZ9TTy76ob5cyFz7lx0bplYmsCx32MdvNu3+tKHPouf5TVhnR/TAYN9/NL7Bl+d7TYIy+isXaiGRQiL5sjKPx6TVZJq2jC+EiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DQDGi13N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DQDGi13N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CD6C4CEE4;
	Thu,  6 Mar 2025 05:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239452;
	bh=D61EtfG+daAkHy86eVAv9vRk4t3+/uL5cH9SrQqV9yc=;
	h=Date:To:From:Subject:From;
	b=DQDGi13NQJuyxB93SYMAz/3Q4h5P3jJFVHK83kyIxI2zx8o643eFeGak1vRaZyGkQ
	 dfRSJJq4itK7tjsGh/VVGMQaItnl98gCVuK+dJdBV6NDoI7P3x7u4yi2plaw2VTLgr
	 PTMSyIU7ohKFywyTJ6hooqFUcQCwQh2yO6CWtSfM=
Date: Wed, 05 Mar 2025 21:37:31 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-use-correct-step-in-loop-to-wait-all-clusters-in-wait_for_allocation.patch removed from -mm tree
Message-Id: <20250306053732.82CD6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: use correct step in loop to wait all clusters in wait_for_allocation()
has been removed from the -mm tree.  Its filename was
     mm-swap-use-correct-step-in-loop-to-wait-all-clusters-in-wait_for_allocation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: use correct step in loop to wait all clusters in wait_for_allocation()
Date: Sun, 23 Feb 2025 00:08:46 +0800

Use correct step in loop to wait all clusters in wait_for_allocation(). 
If we miss some cluster in wait_for_allocation(), use after free may occur
as follows:

shmem_writepage                  swapoff
 folio_alloc_swap
  get_swap_pages
   scan_swap_map_slots
    cluster_alloc_swap_entry
     alloc_swap_scan_cluster
      cluster_alloc_range
       /* SWP_WRITEOK is valid */
       if (!(si->flags & SWP_WRITEOK))

                                  ...
                                  del_from_avail_list(p, true);
                                  ...
                                  /* miss the cluster in shmem_writepage */
                                  wait_for_allocation()
                                  ...
                                  try_to_unuse()

       memset(si->swap_map + start, usage, nr_pages);
       swap_range_alloc(si, nr_pages);
       ci->count += nr_pages;
       /* return a valid entry */

                                  ...
                                  exit_swap_address_space(p->type);
                                  ...

 ...
 add_to_swap_cache
  /* dereference swap_address_space(entry) which is NULL */
  xas_lock_irq(&xas);

Link: https://lkml.kernel.org/r/20250222160850.505274-3-shikemeng@huaweicloud.com
Fixes: 9a0ddeb79880 ("mm, swap: hold a reference during scan and cleanup flag usage")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-use-correct-step-in-loop-to-wait-all-clusters-in-wait_for_allocation
+++ a/mm/swapfile.c
@@ -2645,7 +2645,6 @@ static void wait_for_allocation(struct s
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
 		ci = lock_cluster(si, offset);
 		unlock_cluster(ci);
-		offset += SWAPFILE_CLUSTER;
 	}
 }
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch
mm-swap-correct-comment-in-swap_usage_sub.patch
mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch

