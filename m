Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8298438A9C2
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898408; cv=none; b=KPwZKRr/YbPpNiTcjHeBRzQa3Ku7yx9E9p42A21We/nhjpe7oaKiZ73fYOicfCwYaI26W2HBwoh7gAyeaKVjzo1/MFFY7hqHMlZ/bLWTR9rAUu5s64pXu3z7gvEpd4Cp+8PWlipKXrxLb3IneK7LsgSbofJCdhZY79RAlzBXjAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898408; c=relaxed/simple;
	bh=FDUnBe6syUr6Z9b7efCzf+owN88nLTix60ZBYOoYOdY=;
	h=Date:To:From:Subject:Message-Id; b=cIi3y5/cMC43cSvKt6zE9uZPvcwt01WAp5ZvQM2tSGHlluHTEmqFTp7AJMJXKUDLpYFsM9GU76AUlg/7bMi7wAetUEJXHJWU+YwXpSGpOb8rvIULI9pP0YbSAWD4KVDRjkxiZAFa99a8JBNV2UhukHEhcwzd89VGuYQNFftncH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cl9g4Lwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cl9g4Lwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B243C4CEF1;
	Sat, 31 Jan 2026 22:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898408;
	bh=FDUnBe6syUr6Z9b7efCzf+owN88nLTix60ZBYOoYOdY=;
	h=Date:To:From:Subject:From;
	b=Cl9g4LwmdVUGPBXpg4iAPxdLptdHwwNWnmSj+TNn/R4eygnn35zM2ELlu+nkT2v91
	 /AGffsCYdvYJV8Wo9aG4Y/24v3FaFUGx0Eq6okyEnL0wIjhphX+krsdJx4CSOgYV3P
	 KuIrYC06STnt2Z9R0keHIi1yhlFL4meKJpnX+pCc=
Date: Sat, 31 Jan 2026 14:26:47 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,rafael@kernel.org,nphamcs@gmail.com,kartikey406@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-consolidate-cluster-reclaim-and-usability-check.patch removed from -mm tree
Message-Id: <20260131222648.5B243C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: consolidate cluster reclaim and usability check
has been removed from the -mm tree.  Its filename was
     mm-swap-consolidate-cluster-reclaim-and-usability-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: consolidate cluster reclaim and usability check
Date: Sat, 20 Dec 2025 03:43:39 +0800

Swap cluster cache reclaim requires releasing the lock, so the cluster may
become unusable after the reclaim.  To prepare for checking swap cache
using the swap table directly, consolidate the swap cluster reclaim and
the check logic.

We will want to avoid touching the cluster's data completely with the swap
table, to avoid RCU overhead here.  And by moving the cluster usable check
into the reclaim helper, it will also help avoid a redundant scan of the
slots if the cluster is no longer usable, and we will want to avoid
touching the cluster.

Also, adjust it very slightly while at it: always scan the whole region
during reclaim, don't skip slots covered by a reclaimed folio.  Because
the reclaim is lockless, it's possible that new cache lands at any time. 
And for allocation, we want all caches to be reclaimed to avoid
fragmentation.  Besides, if the scan offset is not aligned with the size
of the reclaimed folio, we might skip some existing cache and fail the
reclaim unexpectedly.

There should be no observable behavior change.  It might slightly improve
the fragmentation issue or performance.

Link: https://lkml.kernel.org/r/20251220-swap-table-p2-v5-10-8862a265a033@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

--- a/mm/swapfile.c~mm-swap-consolidate-cluster-reclaim-and-usability-check
+++ a/mm/swapfile.c
@@ -777,33 +777,51 @@ static int swap_cluster_setup_bad_slot(s
 	return 0;
 }
 
+/*
+ * Reclaim drops the ci lock, so the cluster may become unusable (freed or
+ * stolen by a lower order). @usable will be set to false if that happens.
+ */
 static bool cluster_reclaim_range(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
-				  unsigned long start, unsigned long end)
+				  unsigned long start, unsigned int order,
+				  bool *usable)
 {
+	unsigned int nr_pages = 1 << order;
+	unsigned long offset = start, end = start + nr_pages;
 	unsigned char *map = si->swap_map;
-	unsigned long offset = start;
 	int nr_reclaim;
 
 	spin_unlock(&ci->lock);
 	do {
 		switch (READ_ONCE(map[offset])) {
 		case 0:
-			offset++;
 			break;
 		case SWAP_HAS_CACHE:
 			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-			if (nr_reclaim > 0)
-				offset += nr_reclaim;
-			else
+			if (nr_reclaim < 0)
 				goto out;
 			break;
 		default:
 			goto out;
 		}
-	} while (offset < end);
+	} while (++offset < end);
 out:
 	spin_lock(&ci->lock);
+
+	/*
+	 * We just dropped ci->lock so cluster could be used by another
+	 * order or got freed, check if it's still usable or empty.
+	 */
+	if (!cluster_is_usable(ci, order)) {
+		*usable = false;
+		return false;
+	}
+	*usable = true;
+
+	/* Fast path, no need to scan if the whole cluster is empty */
+	if (cluster_is_empty(ci))
+		return true;
+
 	/*
 	 * Recheck the range no matter reclaim succeeded or not, the slot
 	 * could have been be freed while we are not holding the lock.
@@ -900,9 +918,10 @@ static unsigned int alloc_swap_scan_clus
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
 	unsigned int nr_pages = 1 << order;
-	bool need_reclaim, ret;
+	bool need_reclaim, ret, usable;
 
 	lockdep_assert_held(&ci->lock);
+	VM_WARN_ON(!cluster_is_usable(ci, order));
 
 	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
 		goto out;
@@ -912,14 +931,8 @@ static unsigned int alloc_swap_scan_clus
 		if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
 			continue;
 		if (need_reclaim) {
-			ret = cluster_reclaim_range(si, ci, offset, offset + nr_pages);
-			/*
-			 * Reclaim drops ci->lock and cluster could be used
-			 * by another order. Not checking flag as off-list
-			 * cluster has no flag set, and change of list
-			 * won't cause fragmentation.
-			 */
-			if (!cluster_is_usable(ci, order))
+			ret = cluster_reclaim_range(si, ci, offset, order, &usable);
+			if (!usable)
 				goto out;
 			if (cluster_is_empty(ci))
 				offset = start;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch

