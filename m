Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC835695
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 00:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736813991; cv=none; b=bgMQYhRGWxoIWnTw2GV+WdSto51DpVRdF0Qy2IqIjHMbvoUSuv7eWrzb+5CYqEsPSm6lBwoKkj5qDKPswHOjt3MHcvJKuogXQEX3x4nfhVBKGpQCQNk9m/U+foTtbPs3KwnXjhV4O4By1rPvzV1s8ElX7gUTnXmWPmlB9krINa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736813991; c=relaxed/simple;
	bh=QxPCXgRMrzSskz2RC9eClPJINtXhroiBuK6yXn0K5D8=;
	h=Date:To:From:Subject:Message-Id; b=DcUiVTR4GDglfB7aW4rkMMnJe6G1nxgSTFJ+tnogSFRmD0a/S0vAcw+ohPuXfTJW03IumxP9ivzzQMOAgCoE5n/fpgiWNnOv2UF/lm1T9mm20zAqX3XgsAJ/AmyuwgZmlwBXzMxKsVNqkxpKRSmPn9ix/WSnqPo71Hg44unhvUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Id8LnWfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Id8LnWfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056FAC4CED6;
	Tue, 14 Jan 2025 00:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736813991;
	bh=QxPCXgRMrzSskz2RC9eClPJINtXhroiBuK6yXn0K5D8=;
	h=Date:To:From:Subject:From;
	b=Id8LnWfS/hlLz3RHPepyKmPrxtLwoRlxCoa3JGELsFgdYhRFQRrZYgU9TNxSfKjzL
	 414rbkC3B4EhLiIpBCwyxZKHKagwoECAJqHApz+ZVfPd2e3LW0u30c/5BcvLbvfcQR
	 MrcjqxYldIhjxgbvalM/9E/TfqJBKbqvW+3+x088=
Date: Mon, 13 Jan 2025 16:19:50 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes.patch added to mm-unstable branch
Message-Id: <20250114001951.056FAC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: use an enum to define all cluster flags and wrap flags changes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes.patch

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
@@ -257,10 +257,19 @@ struct swap_cluster_info {
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

mm-memcontrol-avoid-duplicated-memcg-enable-check.patch
mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch
mm-swap_cgroup-remove-global-swap-cgroup-lock.patch
mm-swap_cgroup-decouple-swap-cgroup-recording-and-clearing.patch
mm-swap-minor-clean-up-for-swap-entry-allocation.patch
mm-swap-fold-swap_info_get_cont-in-the-only-caller.patch
mm-swap-remove-old-allocation-path-for-hdd.patch
mm-swap-use-cluster-lock-for-hdd.patch
mm-swap-clean-up-device-availability-check.patch
mm-swap-clean-up-plist-removal-and-adding.patch
mm-swap-hold-a-reference-during-scan-and-cleanup-flag-usage.patch
mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes.patch
mm-swap-reduce-contention-on-device-lock.patch
mm-swap-simplify-percpu-cluster-updating.patch
mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset.patch
mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch
mm-swap_slots-remove-slot-cache-for-freeing-path.patch

