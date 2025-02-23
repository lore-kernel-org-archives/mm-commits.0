Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AE6B67F
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 01:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740275096; cv=none; b=Sg8lGuQpewHb5OKrhtnAyhuy65vAiURcpBsDo/J0RiMHQ3Eh4ht/L6FQ+UvBYuL3DrRedIQ5BpU6V0bDYzuZc1FE/RNo8jPkJaLwhgiMfa89w2XdAnwbDERKy+J6d4XSAyvGJlKBlppjN4g1f7X6hPql4wNt61Uv004v7f590gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740275096; c=relaxed/simple;
	bh=TT4y+Sim24F6iPAbiaIxZpWIzqCN+646azN+PQbCVOQ=;
	h=Date:To:From:Subject:Message-Id; b=OnIF7Z6p97hZdDqgNAlYQ+dhsZgpYg+ag81BV1ZxkHb4euHqIqhocOuiQJf2nJBlZnKsIjFsz8r+xhfVsnSX4vUnJJK78len/GRJvh2JHK8wEWPbvwU67XrnLuBOVReSFw9XVk/shxCX19aFAoNy5wyKWuuHhC4eqtqnha08cAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H8hdFTdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H8hdFTdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B79C4CED1;
	Sun, 23 Feb 2025 01:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740275095;
	bh=TT4y+Sim24F6iPAbiaIxZpWIzqCN+646azN+PQbCVOQ=;
	h=Date:To:From:Subject:From;
	b=H8hdFTdzo+jnk8DpTKsC/sOtJ1z111d05jgSx0bXhY8zCBWs2O7ZKWKqS77exFIRn
	 6w2SgQdZSu5PQdF1TuHjFmVHWNiVWh5AF13bD7T/Z3hcaK7jt5CuZTkFwX6G5G9OgB
	 U85ggJdzniT7QgwDDIwTEsEPgzls4vlyZ4ZJTBlM=
Date: Sat, 22 Feb 2025 17:44:54 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-correct-step-in-loop-to-wait-all-clusters-in-wait_for_allocation.patch added to mm-hotfixes-unstable branch
Message-Id: <20250223014455.61B79C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: use correct step in loop to wait all clusters in wait_for_allocation()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-use-correct-step-in-loop-to-wait-all-clusters-in-wait_for_allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-correct-step-in-loop-to-wait-all-clusters-in-wait_for_allocation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-swap-avoid-losting-cluster-in-swap_reclaim_full_clusters.patch
mm-swap-use-correct-step-in-loop-to-wait-all-clusters-in-wait_for_allocation.patch
mm-swap-avoid-bug_on-in-relocate_cluster.patch
mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch
mm-swap-correct-comment-in-swap_usage_sub.patch
mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch

