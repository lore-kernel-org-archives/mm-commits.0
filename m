Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6541411DE
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756835; cv=none; b=Ov8Uv1EAXMpXXyejuVoWXflU/KCouW5xtctUtstnwau5L25DBTkOxYEpjs1TQw6wnigoqt+hesHsFlbJ5chCLE4JaWmGEdRDA99BRSmTN+oxPYUXxpa3gcdzntOYNeHMh24dKkvvGp+4oqixfuiqBUmQ38cxDOb3hiLigJp/8NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756835; c=relaxed/simple;
	bh=8YZuUTfF+mxVRPjbz9HLUx0tDC2ULS6G82Chc6aIHdw=;
	h=Date:To:From:Subject:Message-Id; b=ahDvRjP4flXjl6g76vmaAhCXj85S2E16tgWijPD+3/Vx7DowAKGi94ST5EHS+uHKvb/lQ2Oc2vNyB57OliZxMwlL8imJ/VNHhfhF9ywEB/BlE7e+WKJZVgUfR60nYsSmdjxDRKMHUfK0hIdvq2VMQp/kp+lJRtfV4oy4hU2tl7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gtsb0WBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gtsb0WBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20547C4CEED;
	Sun,  1 Jun 2025 05:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756835;
	bh=8YZuUTfF+mxVRPjbz9HLUx0tDC2ULS6G82Chc6aIHdw=;
	h=Date:To:From:Subject:From;
	b=Gtsb0WBucH71rVb1a/iIrFPwHgc3KATnJLehx0ChN8t792uFnXQK9unK9bR4fb9IB
	 MKa4TqAml5K+zvSVxU39EsZ2yq13LqbVQvsT1cUgked5jIYVlwYNmIXxDqHQjkM2rz
	 djdAxS0k3Yy9I7ntLZVucyHyF7mH0Z9fYQ4Jbrqg=
Date: Sat, 31 May 2025 22:47:14 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,kasong@tencent.com,hughd@google.com,baolin.wang@linux.alibaba.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch removed from -mm tree
Message-Id: <20250601054715.20547C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: fix potential dead loop in shmem_unuse()
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/shmem: fix potential dead loop in shmem_unuse()
Date: Sat, 17 May 2025 01:09:37 +0800

If multi shmem_unuse() for different swap type is called concurrently, a
dead loop could occur as following:

shmem_unuse(typeA)               shmem_unuse(typeB)
 mutex_lock(&shmem_swaplist_mutex)
 list_for_each_entry_safe(info, next, ...)
  ...
  mutex_unlock(&shmem_swaplist_mutex)
  /* info->swapped may drop to 0 */
  shmem_unuse_inode(&info->vfs_inode, type)

                                  mutex_lock(&shmem_swaplist_mutex)
                                  list_for_each_entry(info, next, ...)
                                   if (!info->swapped)
                                    list_del_init(&info->swaplist)

                                  ...
                                  mutex_unlock(&shmem_swaplist_mutex)

  mutex_lock(&shmem_swaplist_mutex)
  /* iterate with offlist entry and encounter a dead loop */
  next = list_next_entry(info, swaplist);
  ...

Restart the iteration if the inode is already off shmem_swaplist list to
fix the issue.

Link: https://lkml.kernel.org/r/20250516170939.965736-4-shikemeng@huaweicloud.com
Fixes: b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-potential-dead-loop-in-shmem_unuse
+++ a/mm/shmem.c
@@ -1505,6 +1505,7 @@ int shmem_unuse(unsigned int type)
 		return 0;
 
 	mutex_lock(&shmem_swaplist_mutex);
+start_over:
 	list_for_each_entry_safe(info, next, &shmem_swaplist, swaplist) {
 		if (!info->swapped) {
 			list_del_init(&info->swaplist);
@@ -1523,13 +1524,15 @@ int shmem_unuse(unsigned int type)
 		cond_resched();
 
 		mutex_lock(&shmem_swaplist_mutex);
-		next = list_next_entry(info, swaplist);
-		if (!info->swapped)
-			list_del_init(&info->swaplist);
 		if (atomic_dec_and_test(&info->stop_eviction))
 			wake_up_var(&info->stop_eviction);
 		if (error)
 			break;
+		if (list_empty(&info->swaplist))
+			goto start_over;
+		next = list_next_entry(info, swaplist);
+		if (!info->swapped)
+			list_del_init(&info->swaplist);
 	}
 	mutex_unlock(&shmem_swaplist_mutex);
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch
mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch
mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch
mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

