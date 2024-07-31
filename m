Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF1B167296
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 20:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722458502; cv=none; b=aWsx3VChP1PaCuMwPK6z+EocWG4iPWkiPmpmtDkN5dayFZjJuEtzYleeKXYLWtZRqMNc0EGhjmEsiU5sCNjrsSarCzVMQrJTO5kzfmPJP0EnjFHWWthhqLr98mpUyRcWW9miShq23cbghY6T8dFlZ81py6pSJSWXjur1qSHc1Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722458502; c=relaxed/simple;
	bh=vybR8gEyqWffHh4ofQj+NI9b01tyDGeZwE547kC12yg=;
	h=Date:To:From:Subject:Message-Id; b=bf7O3g7yVKJ4TXYSeOHFl8HAN3RXFLxur70uYUz3rERNClaFrEVZhWbnVrPWx18jPh2T6rnhubZxPLDKcQ4niadzuUk2DWSd9jFErfDeS0pGR1a0FKJAUQz1yT3RRCSBJCxoot2FvWa9Py4Xi02HOmpxW4oncclTFFMcFF6zgsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e8fJKkBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e8fJKkBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3819C116B1;
	Wed, 31 Jul 2024 20:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722458501;
	bh=vybR8gEyqWffHh4ofQj+NI9b01tyDGeZwE547kC12yg=;
	h=Date:To:From:Subject:From;
	b=e8fJKkBXAnibC2TsTaRsgThxgyJRnsdWxr2lEXOlHAIGlWprY4PszTQEhQSvtenNs
	 Gb6rQrlNEZt1DtabQBp4y2ozz0qYtMShrJ5T0Ab+fd1YA1e3SW0M+tv8xpzmCpcOkT
	 Wrx2OgCocQa70Zg93mKbuDEQREvr7XxeVxS/d764=
Date: Wed, 31 Jul 2024 13:41:41 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,kaleshsingh@google.com,hughd@google.com,chrisl@kernel.org,21cnbao@gmail.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-relaim-the-cached-parts-that-got-scanned.patch added to mm-unstable branch
Message-Id: <20240731204141.A3819C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: relaim the cached parts that got scanned
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-relaim-the-cached-parts-that-got-scanned.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-relaim-the-cached-parts-that-got-scanned.patch

This patch will later appear in the mm-unstable branch at
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
From: Kairui Song <kasong@tencent.com>
Subject: mm: swap: relaim the cached parts that got scanned
Date: Tue, 30 Jul 2024 23:49:20 -0700

This commit implements reclaim during scan for cluster allocator.

Cluster scanning were unable to reuse SWAP_HAS_CACHE slots, which could
result in low allocation success rate or early OOM.

So to ensure maximum allocation success rate, integrate reclaiming with
scanning.  If found a range of suitable swap slots but fragmented due to
HAS_CACHE, just try to reclaim the slots.

Link: https://lkml.kernel.org/r/20240730-swap-allocator-v5-8-cb9c148b9297@kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/swapfile.c        |  140 +++++++++++++++++++++++++++++++----------
 2 files changed, 110 insertions(+), 31 deletions(-)

--- a/include/linux/swap.h~mm-swap-relaim-the-cached-parts-that-got-scanned
+++ a/include/linux/swap.h
@@ -301,6 +301,7 @@ struct swap_info_struct {
 					/* list of cluster that contains at least one free slot */
 	struct list_head frag_clusters[SWAP_NR_ORDERS];
 					/* list of cluster that are fragmented or contented */
+	unsigned int frag_cluster_nr[SWAP_NR_ORDERS];
 	unsigned int lowest_bit;	/* index of first free in swap_map */
 	unsigned int highest_bit;	/* index of last free in swap_map */
 	unsigned int pages;		/* total of usable pages of swap */
--- a/mm/swapfile.c~mm-swap-relaim-the-cached-parts-that-got-scanned
+++ a/mm/swapfile.c
@@ -513,6 +513,10 @@ static void free_cluster(struct swap_inf
 	VM_BUG_ON(ci->count != 0);
 	lockdep_assert_held(&si->lock);
 	lockdep_assert_held(&ci->lock);
+
+	if (ci->flags & CLUSTER_FLAG_FRAG)
+		si->frag_cluster_nr[ci->order]--;
+
 	/*
 	 * If the swap is discardable, prepare discard the cluster
 	 * instead of free it immediately. The cluster will be freed
@@ -572,31 +576,84 @@ static void dec_cluster_info_page(struct
 
 	if (!(ci->flags & CLUSTER_FLAG_NONFULL)) {
 		VM_BUG_ON(ci->flags & CLUSTER_FLAG_FREE);
-		if (ci->flags & CLUSTER_FLAG_FRAG)
+		if (ci->flags & CLUSTER_FLAG_FRAG) {
+			p->frag_cluster_nr[ci->order]--;
 			list_move_tail(&ci->list, &p->nonfull_clusters[ci->order]);
-		else
+		} else {
 			list_add_tail(&ci->list, &p->nonfull_clusters[ci->order]);
+		}
 		ci->flags = CLUSTER_FLAG_NONFULL;
 	}
 }
 
-static inline bool cluster_scan_range(struct swap_info_struct *si, unsigned int start,
-				      unsigned int nr_pages)
+static bool cluster_reclaim_range(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
+				  unsigned long start, unsigned long end)
 {
-	unsigned char *p = si->swap_map + start;
-	unsigned char *end = p + nr_pages;
+	unsigned char *map = si->swap_map;
+	unsigned long offset;
+
+	spin_unlock(&ci->lock);
+	spin_unlock(&si->lock);
+
+	for (offset = start; offset < end; offset++) {
+		switch (READ_ONCE(map[offset])) {
+		case 0:
+			continue;
+		case SWAP_HAS_CACHE:
+			if (__try_to_reclaim_swap(si, offset, TTRS_ANYWAY | TTRS_DIRECT) > 0)
+				continue;
+			goto out;
+		default:
+			goto out;
+		}
+	}
+out:
+	spin_lock(&si->lock);
+	spin_lock(&ci->lock);
 
-	while (p < end)
-		if (*p++)
+	/*
+	 * Recheck the range no matter reclaim succeeded or not, the slot
+	 * could have been be freed while we are not holding the lock.
+	 */
+	for (offset = start; offset < end; offset++)
+		if (READ_ONCE(map[offset]))
 			return false;
 
 	return true;
 }
 
+static bool cluster_scan_range(struct swap_info_struct *si,
+			       struct swap_cluster_info *ci,
+			       unsigned long start, unsigned int nr_pages)
+{
+	unsigned long offset, end = start + nr_pages;
+	unsigned char *map = si->swap_map;
+	bool need_reclaim = false;
 
-static inline void cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster_info *ci,
-						unsigned int start, unsigned char usage,
-						unsigned int order)
+	for (offset = start; offset < end; offset++) {
+		switch (READ_ONCE(map[offset])) {
+		case 0:
+			continue;
+		case SWAP_HAS_CACHE:
+			if (!vm_swap_full())
+				return false;
+			need_reclaim = true;
+			continue;
+		default:
+			return false;
+		}
+	}
+
+	if (need_reclaim)
+		return cluster_reclaim_range(si, ci, start, end);
+
+	return true;
+}
+
+static void cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster_info *ci,
+				unsigned int start, unsigned char usage,
+				unsigned int order)
 {
 	unsigned int nr_pages = 1 << order;
 
@@ -615,6 +672,8 @@ static inline void cluster_alloc_range(s
 	if (ci->count == SWAPFILE_CLUSTER) {
 		VM_BUG_ON(!(ci->flags &
 			  (CLUSTER_FLAG_FREE | CLUSTER_FLAG_NONFULL | CLUSTER_FLAG_FRAG)));
+		if (ci->flags & CLUSTER_FLAG_FRAG)
+			si->frag_cluster_nr[ci->order]--;
 		list_del(&ci->list);
 		ci->flags = 0;
 	}
@@ -640,7 +699,7 @@ static unsigned int alloc_swap_scan_clus
 	}
 
 	while (offset <= end) {
-		if (cluster_scan_range(si, offset, nr_pages)) {
+		if (cluster_scan_range(si, ci, offset, nr_pages)) {
 			cluster_alloc_range(si, ci, offset, usage, order);
 			*foundp = offset;
 			if (ci->count == SWAPFILE_CLUSTER) {
@@ -668,9 +727,8 @@ static unsigned long cluster_alloc_swap_
 					      unsigned char usage)
 {
 	struct percpu_cluster *cluster;
-	struct swap_cluster_info *ci, *n;
+	struct swap_cluster_info *ci;
 	unsigned int offset, found = 0;
-	LIST_HEAD(fraged);
 
 new_cluster:
 	lockdep_assert_held(&si->lock);
@@ -690,25 +748,42 @@ new_cluster:
 	}
 
 	if (order < PMD_ORDER) {
-		list_for_each_entry_safe(ci, n, &si->nonfull_clusters[order], list) {
-			list_move_tail(&ci->list, &fraged);
+		unsigned int frags = 0;
+
+		while (!list_empty(&si->nonfull_clusters[order])) {
+			ci = list_first_entry(&si->nonfull_clusters[order],
+					      struct swap_cluster_info, list);
+			list_move_tail(&ci->list, &si->frag_clusters[order]);
 			ci->flags = CLUSTER_FLAG_FRAG;
+			si->frag_cluster_nr[order]++;
 			offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
 							 &found, order, usage);
+			frags++;
 			if (found)
 				break;
 		}
 
 		if (!found) {
-			list_for_each_entry_safe(ci, n, &si->frag_clusters[order], list) {
+			/*
+			 * Nonfull clusters are moved to frag tail if we reached
+			 * here, count them too, don't over scan the frag list.
+			 */
+			while (frags < si->frag_cluster_nr[order]) {
+				ci = list_first_entry(&si->frag_clusters[order],
+						      struct swap_cluster_info, list);
+				/*
+				 * Rotate the frag list to iterate, they were all failing
+				 * high order allocation or moved here due to per-CPU usage,
+				 * this help keeping usable cluster ahead.
+				 */
+				list_move_tail(&ci->list, &si->frag_clusters[order]);
 				offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
 								 &found, order, usage);
+				frags++;
 				if (found)
 					break;
 			}
 		}
-
-		list_splice_tail(&fraged, &si->frag_clusters[order]);
 	}
 
 	if (found)
@@ -729,25 +804,28 @@ new_cluster:
 
 	/* Order 0 stealing from higher order */
 	for (int o = 1; o < PMD_ORDER; o++) {
-		if (!list_empty(&si->frag_clusters[o])) {
+		/*
+		 * Clusters here have at least one usable slots and can't fail order 0
+		 * allocation, but reclaim may drop si->lock and race with another user.
+		 */
+		while (!list_empty(&si->frag_clusters[o])) {
 			ci = list_first_entry(&si->frag_clusters[o],
 					      struct swap_cluster_info, list);
-			offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci), &found,
-							 0, usage);
-			VM_BUG_ON(!found);
-			goto done;
+			offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
+							 &found, 0, usage);
+			if (found)
+				goto done;
 		}
 
-		if (!list_empty(&si->nonfull_clusters[o])) {
-			ci = list_first_entry(&si->nonfull_clusters[o], struct swap_cluster_info,
-					      list);
+		while (!list_empty(&si->nonfull_clusters[o])) {
+			ci = list_first_entry(&si->nonfull_clusters[o],
+					      struct swap_cluster_info, list);
 			offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
 							 &found, 0, usage);
-			VM_BUG_ON(!found);
-			goto done;
+			if (found)
+				goto done;
 		}
 	}
-
 done:
 	cluster->next[order] = offset;
 	return found;
@@ -3045,6 +3123,7 @@ static int setup_swap_map_and_extents(st
 	for (i = 0; i < SWAP_NR_ORDERS; i++) {
 		INIT_LIST_HEAD(&p->nonfull_clusters[i]);
 		INIT_LIST_HEAD(&p->frag_clusters[i]);
+		p->frag_cluster_nr[i] = 0;
 	}
 
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
@@ -3088,7 +3167,6 @@ static int setup_swap_map_and_extents(st
 	if (!cluster_info)
 		return nr_extents;
 
-
 	/*
 	 * Reduce false cache line sharing between cluster_info and
 	 * sharing same address space.
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-clean-up-initialization-helper.patch
mm-swap-skip-slot-cache-on-freeing-for-mthp.patch
mm-swap-allow-cache-reclaim-to-skip-slot-cache.patch
mm-swap-add-a-fragment-cluster-list.patch
mm-swap-relaim-the-cached-parts-that-got-scanned.patch
mm-swap-add-a-adaptive-full-cluster-cache-reclaim.patch

