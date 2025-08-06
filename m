Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF7A1D86FF
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 22:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754519222; cv=none; b=aT0VtTAHMcly8htdoxbN6Xlfxk++UyQf7/uGh7jj7Yvb/ZOP8ZMQxQFalchCVK7YIsBvMNkocU3Opu+4c/hFngeidDtvIfZCdxNohPPp7MLHMsC+r2E25EihWxmt2y0IbD5z+olpa86dz05PA0NV5xjAGv4EIucNW4Fo+x1IIlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754519222; c=relaxed/simple;
	bh=kNOMV5MKb0jrNHq5K8uRinH35PBiHtGv3SVKdS276ao=;
	h=Date:To:From:Subject:Message-Id; b=oc5tMOnY2kQyTmqdq9cVV3G7isW+Uw5NvGOfdNc8TopFNZY0vzucXHFZKc26wTudkSQKg+SPqs/uUP5UHJtjlxVl9cJIsnk/UZT0YGkaPYgMb40JOPltxaii32edAWWA0S3PuZC0cBplQ0OhZQ+V/MjJsHzhTPM+W8gUShFcVIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Is7k7fP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Is7k7fP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E21C4CEE7;
	Wed,  6 Aug 2025 22:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754519222;
	bh=kNOMV5MKb0jrNHq5K8uRinH35PBiHtGv3SVKdS276ao=;
	h=Date:To:From:Subject:From;
	b=Is7k7fP5YTRBkg/NRaOTne7DTOA2cdapa6FiGlQ2vm2jXej7XhImwvA/ME1TjqhXA
	 GoKkTYbS8evZq0QiWBM63rqSpwt5H0HpCh5tQHBroO9QWTgJ8qGRPpczUl00guk7mH
	 Vf6X0PhmnzkQ1wwZrfgMa/KDCRP5I5LYbVx4U5ok=
Date: Wed, 06 Aug 2025 15:27:01 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-fragment-clusters-counter.patch added to mm-new branch
Message-Id: <20250806222702.02E21C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: remove fragment clusters counter
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-remove-fragment-clusters-counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-fragment-clusters-counter.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: remove fragment clusters counter
Date: Thu, 7 Aug 2025 00:17:47 +0800

It was used for calculating the iteration number when the swap allocator
wants to scan the whole fragment list.  Now the allocator only scans one
fragment cluster at a time, so no one uses this counter anymore.

Remove it as a cleanup; the performance change is marginal:

Build linux kernel using 10G ZRAM, make -j96, defconfig with 2G cgroup
memory limit, on top of tmpfs, 64kB mTHP enabled:

Before:  sys time: 6278.45s
After:   sys time: 6176.34s

Change to 8G ZRAM:

Before:  sys time: 5572.85s
After:   sys time: 5531.49s

Link: https://lkml.kernel.org/r/20250806161748.76651-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/swapfile.c        |    7 -------
 2 files changed, 8 deletions(-)

--- a/include/linux/swap.h~mm-swap-remove-fragment-clusters-counter
+++ a/include/linux/swap.h
@@ -310,7 +310,6 @@ struct swap_info_struct {
 					/* list of cluster that contains at least one free slot */
 	struct list_head frag_clusters[SWAP_NR_ORDERS];
 					/* list of cluster that are fragmented or contented */
-	atomic_long_t frag_cluster_nr[SWAP_NR_ORDERS];
 	unsigned int pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
 	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
--- a/mm/swapfile.c~mm-swap-remove-fragment-clusters-counter
+++ a/mm/swapfile.c
@@ -470,11 +470,6 @@ static void move_cluster(struct swap_inf
 	else
 		list_move_tail(&ci->list, list);
 	spin_unlock(&si->lock);
-
-	if (ci->flags == CLUSTER_FLAG_FRAG)
-		atomic_long_dec(&si->frag_cluster_nr[ci->order]);
-	else if (new_flags == CLUSTER_FLAG_FRAG)
-		atomic_long_inc(&si->frag_cluster_nr[ci->order]);
 	ci->flags = new_flags;
 }
 
@@ -965,7 +960,6 @@ new_cluster:
 		 * allocation, but reclaim may drop si->lock and race with another user.
 		 */
 		while ((ci = isolate_lock_cluster(si, &si->frag_clusters[o]))) {
-			atomic_long_dec(&si->frag_cluster_nr[o]);
 			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
 							0, usage);
 			if (found)
@@ -3217,7 +3211,6 @@ static struct swap_cluster_info *setup_c
 	for (i = 0; i < SWAP_NR_ORDERS; i++) {
 		INIT_LIST_HEAD(&si->nonfull_clusters[i]);
 		INIT_LIST_HEAD(&si->frag_clusters[i]);
-		atomic_long_set(&si->frag_cluster_nr[i], 0);
 	}
 
 	/*
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-only-scan-one-cluster-in-fragment-list.patch
mm-swap-remove-fragment-clusters-counter.patch
mm-swap-prefer-nonfull-over-free-clusters.patch

