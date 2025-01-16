Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F84158524
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006255; cv=none; b=YPrVkYCXSUucv2dOXzuZ5mGxZIUHieDUlGMwHyYW7jQYkIkstYQs4n0dY60hBWbCqsfEGXMXzXpj2kXq5Xuh/9Fsy1H+1NOJ7wmThYywzjx7vX+6TTohAhP8lUXMjTNHYlwIDHnHUCglqoLfrEpI4M+D4c4xwPdn0D29IqKRYiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006255; c=relaxed/simple;
	bh=OHsXUCJlPYuFdPtc7gwZC+y804qz97TIM8DGMp81dPU=;
	h=Date:To:From:Subject:Message-Id; b=brY/0njXpV4foWczp1sFPXfP9NCNBScDbFYAySMXN8TGE4a+FWZp0EypFObHYzJQxiUFsdmtRydoY66gX9tmG0iPIBIFRB4pZ7m4KavsH8oDEMSYQ/1b5bJE4B0rWH0PHTYkOFDpRGIXOlCPY+0iK2EM91TudBa3gOO7gl3lRrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TTVNGVQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TTVNGVQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC78FC4CED6;
	Thu, 16 Jan 2025 05:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006254;
	bh=OHsXUCJlPYuFdPtc7gwZC+y804qz97TIM8DGMp81dPU=;
	h=Date:To:From:Subject:From;
	b=TTVNGVQU+wUDsyWY9Mo157ah6b1QXDO1bYkFy72AgHCmMiWgMYX0cAoQyh/kZ3VSh
	 mrQvHhPrDyVaUGPv2+pzheaJSAX0vPw33Te4dA47tMf22WKCytukYt15AgvmaBkCDX
	 2xCdRCL0IpglO8zLES+Pf+1pt77+6+BR8hogZJDM=
Date: Wed, 15 Jan 2025 21:44:14 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes.patch removed from -mm tree
Message-Id: <20250116054414.BC78FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: use an enum to define all cluster flags and wrap flags changes
has been removed from the -mm tree.  Its filename was
     mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: use an enum to define all cluster flags and wrap flags changes
Date: Tue, 14 Jan 2025 01:57:27 +0800

Currently, we are only using flags to indicate which list the cluster is
on.  Using one bit for each list type might be a waste, as the list type
grows, we will consume too many bits.  Additionally, the current mixed
usage of '&' and '==' is a bit confusing.

Make it clean by using an enum to define all possible cluster statuses. 
Only an off-list cluster will have the NONE (0) flag.  And use a wrapper
to annotate and sanitize all flag settings and list movements.

Link: https://lkml.kernel.org/r/20250113175732.48099-9-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   17 +++++++--
 mm/swapfile.c        |   76 +++++++++++++++++++++--------------------
 2 files changed, 53 insertions(+), 40 deletions(-)

--- a/include/linux/swap.h~mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes
+++ a/include/linux/swap.h
@@ -256,10 +256,19 @@ struct swap_cluster_info {
 	u8 order;
 	struct list_head list;
 };
-#define CLUSTER_FLAG_FREE 1 /* This cluster is free */
-#define CLUSTER_FLAG_NONFULL 2 /* This cluster is on nonfull list */
-#define CLUSTER_FLAG_FRAG 4 /* This cluster is on nonfull list */
-#define CLUSTER_FLAG_FULL 8 /* This cluster is on full list */
+
+/* All on-list cluster must have a non-zero flag. */
+enum swap_cluster_flags {
+	CLUSTER_FLAG_NONE = 0, /* For temporary off-list cluster */
+	CLUSTER_FLAG_FREE,
+	CLUSTER_FLAG_NONFULL,
+	CLUSTER_FLAG_FRAG,
+	/* Clusters with flags above are allocatable */
+	CLUSTER_FLAG_USABLE = CLUSTER_FLAG_FRAG,
+	CLUSTER_FLAG_FULL,
+	CLUSTER_FLAG_DISCARD,
+	CLUSTER_FLAG_MAX,
+};
 
 /*
  * The first page in the swap file is the swap header, which is always marked
--- a/mm/swapfile.c~mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes
+++ a/mm/swapfile.c
@@ -403,7 +403,7 @@ static void discard_swap_cluster(struct
 
 static inline bool cluster_is_free(struct swap_cluster_info *info)
 {
-	return info->flags & CLUSTER_FLAG_FREE;
+	return info->flags == CLUSTER_FLAG_FREE;
 }
 
 static inline unsigned int cluster_index(struct swap_info_struct *si,
@@ -434,6 +434,28 @@ static inline void unlock_cluster(struct
 	spin_unlock(&ci->lock);
 }
 
+static void move_cluster(struct swap_info_struct *si,
+			 struct swap_cluster_info *ci, struct list_head *list,
+			 enum swap_cluster_flags new_flags)
+{
+	VM_WARN_ON(ci->flags == new_flags);
+
+	BUILD_BUG_ON(1 << sizeof(ci->flags) * BITS_PER_BYTE < CLUSTER_FLAG_MAX);
+
+	if (ci->flags == CLUSTER_FLAG_NONE) {
+		list_add_tail(&ci->list, list);
+	} else {
+		if (ci->flags == CLUSTER_FLAG_FRAG) {
+			VM_WARN_ON(!si->frag_cluster_nr[ci->order]);
+			si->frag_cluster_nr[ci->order]--;
+		}
+		list_move_tail(&ci->list, list);
+	}
+	ci->flags = new_flags;
+	if (new_flags == CLUSTER_FLAG_FRAG)
+		si->frag_cluster_nr[ci->order]++;
+}
+
 /* Add a cluster to discard list and schedule it to do discard */
 static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 		struct swap_cluster_info *ci)
@@ -447,10 +469,8 @@ static void swap_cluster_schedule_discar
 	 */
 	memset(si->swap_map + idx * SWAPFILE_CLUSTER,
 			SWAP_MAP_BAD, SWAPFILE_CLUSTER);
-
-	VM_BUG_ON(ci->flags & CLUSTER_FLAG_FREE);
-	list_move_tail(&ci->list, &si->discard_clusters);
-	ci->flags = 0;
+	VM_BUG_ON(ci->flags == CLUSTER_FLAG_FREE);
+	move_cluster(si, ci, &si->discard_clusters, CLUSTER_FLAG_DISCARD);
 	schedule_work(&si->discard_work);
 }
 
@@ -458,12 +478,7 @@ static void __free_cluster(struct swap_i
 {
 	lockdep_assert_held(&si->lock);
 	lockdep_assert_held(&ci->lock);
-
-	if (ci->flags)
-		list_move_tail(&ci->list, &si->free_clusters);
-	else
-		list_add_tail(&ci->list, &si->free_clusters);
-	ci->flags = CLUSTER_FLAG_FREE;
+	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
 }
 
@@ -479,6 +494,8 @@ static void swap_do_scheduled_discard(st
 	while (!list_empty(&si->discard_clusters)) {
 		ci = list_first_entry(&si->discard_clusters, struct swap_cluster_info, list);
 		list_del(&ci->list);
+		/* Must clear flag when taking a cluster off-list */
+		ci->flags = CLUSTER_FLAG_NONE;
 		idx = cluster_index(si, ci);
 		spin_unlock(&si->lock);
 
@@ -519,9 +536,6 @@ static void free_cluster(struct swap_inf
 	lockdep_assert_held(&si->lock);
 	lockdep_assert_held(&ci->lock);
 
-	if (ci->flags & CLUSTER_FLAG_FRAG)
-		si->frag_cluster_nr[ci->order]--;
-
 	/*
 	 * If the swap is discardable, prepare discard the cluster
 	 * instead of free it immediately. The cluster will be freed
@@ -573,13 +587,9 @@ static void dec_cluster_info_page(struct
 		return;
 	}
 
-	if (!(ci->flags & CLUSTER_FLAG_NONFULL)) {
-		VM_BUG_ON(ci->flags & CLUSTER_FLAG_FREE);
-		if (ci->flags & CLUSTER_FLAG_FRAG)
-			si->frag_cluster_nr[ci->order]--;
-		list_move_tail(&ci->list, &si->nonfull_clusters[ci->order]);
-		ci->flags = CLUSTER_FLAG_NONFULL;
-	}
+	if (ci->flags != CLUSTER_FLAG_NONFULL)
+		move_cluster(si, ci, &si->nonfull_clusters[ci->order],
+			     CLUSTER_FLAG_NONFULL);
 }
 
 static bool cluster_reclaim_range(struct swap_info_struct *si,
@@ -663,11 +673,13 @@ static bool cluster_alloc_range(struct s
 	if (!(si->flags & SWP_WRITEOK))
 		return false;
 
+	VM_BUG_ON(ci->flags == CLUSTER_FLAG_NONE);
+	VM_BUG_ON(ci->flags > CLUSTER_FLAG_USABLE);
+
 	if (cluster_is_free(ci)) {
-		if (nr_pages < SWAPFILE_CLUSTER) {
-			list_move_tail(&ci->list, &si->nonfull_clusters[order]);
-			ci->flags = CLUSTER_FLAG_NONFULL;
-		}
+		if (nr_pages < SWAPFILE_CLUSTER)
+			move_cluster(si, ci, &si->nonfull_clusters[order],
+				     CLUSTER_FLAG_NONFULL);
 		ci->order = order;
 	}
 
@@ -675,14 +687,8 @@ static bool cluster_alloc_range(struct s
 	swap_range_alloc(si, nr_pages);
 	ci->count += nr_pages;
 
-	if (ci->count == SWAPFILE_CLUSTER) {
-		VM_BUG_ON(!(ci->flags &
-			  (CLUSTER_FLAG_FREE | CLUSTER_FLAG_NONFULL | CLUSTER_FLAG_FRAG)));
-		if (ci->flags & CLUSTER_FLAG_FRAG)
-			si->frag_cluster_nr[ci->order]--;
-		list_move_tail(&ci->list, &si->full_clusters);
-		ci->flags = CLUSTER_FLAG_FULL;
-	}
+	if (ci->count == SWAPFILE_CLUSTER)
+		move_cluster(si, ci, &si->full_clusters, CLUSTER_FLAG_FULL);
 
 	return true;
 }
@@ -821,9 +827,7 @@ new_cluster:
 		while (!list_empty(&si->nonfull_clusters[order])) {
 			ci = list_first_entry(&si->nonfull_clusters[order],
 					      struct swap_cluster_info, list);
-			list_move_tail(&ci->list, &si->frag_clusters[order]);
-			ci->flags = CLUSTER_FLAG_FRAG;
-			si->frag_cluster_nr[order]++;
+			move_cluster(si, ci, &si->frag_clusters[order], CLUSTER_FLAG_FRAG);
 			offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
 							 &found, order, usage);
 			frags++;
_

Patches currently in -mm which might be from kasong@tencent.com are


