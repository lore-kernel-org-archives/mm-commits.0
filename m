Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB442F43
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423401; cv=none; b=U4/kd3Pyp+KYHvJsjaFIbL3rFi/CuGTS4ejFddMTyKZQtk4Zc/6TNATBAdSIB0P8Ye8QNg1obq7gOtfj1Wxx8uUCLsGDzDznOdpzWNgOnRgSrxCn1dNpqKfeY1SrvxlHyMf4mlGwawkyUXGpOvZTkeMHXXetJ+CC9Q7hBFtPDSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423401; c=relaxed/simple;
	bh=jPQFRnB6wQFpsuUZd8bPL+6BnakNstd6kkASBQVhjRo=;
	h=Date:To:From:Subject:Message-Id; b=EiX5AMG2YXaIx7hAkwM4mUK+N9rp2aOiAp9WtSEiGVz1zmTwbLclGbgesypNS5MCLoKsufbPPHD3+Y0gioRneKPGqvAwMbLBIKK2R+4NCjJchA9ec/fzOWBcFxPyv+/5MvQnG264DE3z5Um0g0ZxjbfFsaDVx0wqg2R4G9XxJAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qn6Jjevj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qn6Jjevj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C34C4CEC2;
	Wed,  4 Sep 2024 04:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423400;
	bh=jPQFRnB6wQFpsuUZd8bPL+6BnakNstd6kkASBQVhjRo=;
	h=Date:To:From:Subject:From;
	b=Qn6JjevjS8tz27wnFTY5pUF6hU0Cv6JkTan72VxweGi7A/7DksCjIT20f3UN11AvC
	 BBtzEEbnqmN1zk15vyKXLnwTrk8T3Rfc8FlFV97DGdUZPIV022ynhSq6VI/vsM6/nB
	 4Hzqdt0BL4PTmSxHvzDP2i4kPPtWniiRYof16WpQ=
Date: Tue, 03 Sep 2024 21:16:39 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,21cnbao@gmail.com,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-mthp-allocate-swap-entries-from-nonfull-list.patch removed from -mm tree
Message-Id: <20240904041640.71C34C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: mTHP allocate swap entries from nonfull list
has been removed from the -mm tree.  Its filename was
     mm-swap-mthp-allocate-swap-entries-from-nonfull-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chris Li <chrisl@kernel.org>
Subject: mm: swap: mTHP allocate swap entries from nonfull list
Date: Tue, 30 Jul 2024 23:49:14 -0700

Track the nonfull cluster as well as the empty cluster on lists.  Each
order has one nonfull cluster list.

The cluster will remember which order it was used during new cluster
allocation.

When the cluster has free entry, add to the nonfull[order] list.   When
the free cluster list is empty, also allocate from the nonempty list of
that order.

This improves the mTHP swap allocation success rate.

There are limitations if the distribution of numbers of different orders
of mTHP changes a lot.  e.g.  there are a lot of nonfull cluster assign to
order A while later time there are a lot of order B allocation while very
little allocation in order A.  Currently the cluster used by order A will
not reused by order B unless the cluster is 100% empty.

Link: https://lkml.kernel.org/r/20240730-swap-allocator-v5-2-cb9c148b9297@kernel.org
Signed-off-by: Chris Li <chrisl@kernel.org>
Reported-by: Barry Song <21cnbao@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++++
 mm/swapfile.c        |   38 +++++++++++++++++++++++++++++++++++---
 2 files changed, 39 insertions(+), 3 deletions(-)

--- a/include/linux/swap.h~mm-swap-mthp-allocate-swap-entries-from-nonfull-list
+++ a/include/linux/swap.h
@@ -254,9 +254,11 @@ struct swap_cluster_info {
 				 */
 	u16 count;
 	u8 flags;
+	u8 order;
 	struct list_head list;
 };
 #define CLUSTER_FLAG_FREE 1 /* This cluster is free */
+#define CLUSTER_FLAG_NONFULL 2 /* This cluster is on nonfull list */
 
 /*
  * The first page in the swap file is the swap header, which is always marked
@@ -294,6 +296,8 @@ struct swap_info_struct {
 	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct list_head free_clusters; /* free clusters list */
+	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
+					/* list of cluster that contains at least one free slot */
 	unsigned int lowest_bit;	/* index of first free in swap_map */
 	unsigned int highest_bit;	/* index of last free in swap_map */
 	unsigned int pages;		/* total of usable pages of swap */
--- a/mm/swapfile.c~mm-swap-mthp-allocate-swap-entries-from-nonfull-list
+++ a/mm/swapfile.c
@@ -361,14 +361,22 @@ static void swap_cluster_schedule_discar
 	memset(si->swap_map + idx * SWAPFILE_CLUSTER,
 			SWAP_MAP_BAD, SWAPFILE_CLUSTER);
 
-	list_add_tail(&ci->list, &si->discard_clusters);
+	VM_BUG_ON(ci->flags & CLUSTER_FLAG_FREE);
+	if (ci->flags & CLUSTER_FLAG_NONFULL)
+		list_move_tail(&ci->list, &si->discard_clusters);
+	else
+		list_add_tail(&ci->list, &si->discard_clusters);
+	ci->flags = 0;
 	schedule_work(&si->discard_work);
 }
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
+	if (ci->flags & CLUSTER_FLAG_NONFULL)
+		list_move_tail(&ci->list, &si->free_clusters);
+	else
+		list_add_tail(&ci->list, &si->free_clusters);
 	ci->flags = CLUSTER_FLAG_FREE;
-	list_add_tail(&ci->list, &si->free_clusters);
 }
 
 /*
@@ -491,8 +499,15 @@ static void dec_cluster_info_page(struct
 	VM_BUG_ON(ci->count == 0);
 	ci->count--;
 
-	if (!ci->count)
+	if (!ci->count) {
 		free_cluster(p, ci);
+		return;
+	}
+
+	if (!(ci->flags & CLUSTER_FLAG_NONFULL)) {
+		list_add_tail(&ci->list, &p->nonfull_clusters[ci->order]);
+		ci->flags |= CLUSTER_FLAG_NONFULL;
+	}
 }
 
 /*
@@ -553,6 +568,19 @@ new_cluster:
 	if (tmp == SWAP_NEXT_INVALID) {
 		if (!list_empty(&si->free_clusters)) {
 			ci = list_first_entry(&si->free_clusters, struct swap_cluster_info, list);
+			list_del(&ci->list);
+			spin_lock(&ci->lock);
+			ci->order = order;
+			ci->flags = 0;
+			spin_unlock(&ci->lock);
+			tmp = cluster_index(si, ci) * SWAPFILE_CLUSTER;
+		} else if (!list_empty(&si->nonfull_clusters[order])) {
+			ci = list_first_entry(&si->nonfull_clusters[order],
+					      struct swap_cluster_info, list);
+			list_del(&ci->list);
+			spin_lock(&ci->lock);
+			ci->flags = 0;
+			spin_unlock(&ci->lock);
 			tmp = cluster_index(si, ci) * SWAPFILE_CLUSTER;
 		} else if (!list_empty(&si->discard_clusters)) {
 			/*
@@ -959,6 +987,7 @@ static void swap_free_cluster(struct swa
 	ci = lock_cluster(si, offset);
 	memset(si->swap_map + offset, 0, SWAPFILE_CLUSTER);
 	ci->count = 0;
+	ci->order = 0;
 	ci->flags = 0;
 	free_cluster(si, ci);
 	unlock_cluster(ci);
@@ -2911,6 +2940,9 @@ static int setup_swap_map_and_extents(st
 	INIT_LIST_HEAD(&p->free_clusters);
 	INIT_LIST_HEAD(&p->discard_clusters);
 
+	for (i = 0; i < SWAP_NR_ORDERS; i++)
+		INIT_LIST_HEAD(&p->nonfull_clusters[i]);
+
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 		if (page_nr == 0 || page_nr > swap_header->info.last_page)
_

Patches currently in -mm which might be from chrisl@kernel.org are


