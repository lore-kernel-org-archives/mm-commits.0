Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEC56BB4B
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423411; cv=none; b=gBQs4tpHTtvWXFnTULzYUBfz4OEB9DXBQtv8LFuPkwKtJ9mANsgQ3CnxbiWqjTnLfVuKRYUyd/6NcndmIuE4T2gFWBsLiBihVUkYdojCFf3TqoSVnCHs89tJfzIAU0MCSdaEOyV8TUp5AjkUMP6rasQaJlscBB8J+0fC1LVaKKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423411; c=relaxed/simple;
	bh=EPEvXvJmVduDTa3lQKg7XGHSbppHUOAa1m0KFPVJ+eQ=;
	h=Date:To:From:Subject:Message-Id; b=nEk0TJ/GfhM38Ya+ThD79u3tgsVVl4AUymmwhoVG72+oTXUxo3naPS2iHkJTpmA6rBR6BvHoeudTsqB5t++5ZMx1d1tPkbXVjihs5jbV5w6JHdON7ck5s57FGhbdd0RG0Zes43xirZf/IU4q/ZsrWMCBsAMxJzjoZf37/qqY0GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lFM+oyEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lFM+oyEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12F8C4CEC2;
	Wed,  4 Sep 2024 04:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423410;
	bh=EPEvXvJmVduDTa3lQKg7XGHSbppHUOAa1m0KFPVJ+eQ=;
	h=Date:To:From:Subject:From;
	b=lFM+oyEWeW7W+8uVo7Sowcd+J+XJrwuJMASnMF3XC5mlHNTM9KR5sH8vFnbbGPaD1
	 8CVm3ouph89K5yBZ5Z6aqBMvY9da1nQU0FM6neuH962UhdKaCOuXT+9uV6AptQbgJd
	 vFYMC7wrtseVOWenDCB8sdGDRfMUzZHbDignTes8=
Date: Tue, 03 Sep 2024 21:16:50 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryncsn@gmail.com,ryan.roberts@arm.com,kaleshsingh@google.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-add-a-adaptive-full-cluster-cache-reclaim.patch removed from -mm tree
Message-Id: <20240904041650.D12F8C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: add a adaptive full cluster cache reclaim
has been removed from the -mm tree.  Its filename was
     mm-swap-add-a-adaptive-full-cluster-cache-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm: swap: add a adaptive full cluster cache reclaim
Date: Tue, 30 Jul 2024 23:49:21 -0700

Link all full cluster with one full list, and reclaim from it when the
allocation have ran out of all usable clusters.

There are many reason a folio can end up being in the swap cache while
having no swap count reference.  So the best way to search for such slots
is still by iterating the swap clusters.

With the list as an LRU, iterating from the oldest cluster and keep them
rotating is a very doable and clean way to free up potentially not inuse
clusters.

When any allocation failure, try reclaim and rotate only one cluster. 
This is adaptive for high order allocations they can tolerate fallback. 
So this avoids latency, and give the full cluster list an fair chance to
get reclaimed.  It release the usage stress for the fallback order 0
allocation or following up high order allocation.

If the swap device is getting very full, reclaim more aggresively to
ensure no OOM will happen.  This ensures order 0 heavy workload won't go
OOM as order 0 won't fail if any cluster still have any space.

[ryncsn@gmail.com: fix discard of full cluster]
  Link: https://lkml.kernel.org/r/CAMgjq7CWwK75_2Zi5P40K08pk9iqOcuWKL6khu=x4Yg_nXaQag@mail.gmail.com
Link: https://lkml.kernel.org/r/20240730-swap-allocator-v5-9-cb9c148b9297@kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +
 mm/swapfile.c        |   68 +++++++++++++++++++++++++++++++++--------
 2 files changed, 57 insertions(+), 13 deletions(-)

--- a/include/linux/swap.h~mm-swap-add-a-adaptive-full-cluster-cache-reclaim
+++ a/include/linux/swap.h
@@ -260,6 +260,7 @@ struct swap_cluster_info {
 #define CLUSTER_FLAG_FREE 1 /* This cluster is free */
 #define CLUSTER_FLAG_NONFULL 2 /* This cluster is on nonfull list */
 #define CLUSTER_FLAG_FRAG 4 /* This cluster is on nonfull list */
+#define CLUSTER_FLAG_FULL 8 /* This cluster is on full list */
 
 /*
  * The first page in the swap file is the swap header, which is always marked
@@ -297,6 +298,7 @@ struct swap_info_struct {
 	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct list_head free_clusters; /* free clusters list */
+	struct list_head full_clusters; /* full clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
 					/* list of cluster that contains at least one free slot */
 	struct list_head frag_clusters[SWAP_NR_ORDERS];
--- a/mm/swapfile.c~mm-swap-add-a-adaptive-full-cluster-cache-reclaim
+++ a/mm/swapfile.c
@@ -440,10 +440,7 @@ static void swap_cluster_schedule_discar
 			SWAP_MAP_BAD, SWAPFILE_CLUSTER);
 
 	VM_BUG_ON(ci->flags & CLUSTER_FLAG_FREE);
-	if (ci->flags & CLUSTER_FLAG_NONFULL)
-		list_move_tail(&ci->list, &si->discard_clusters);
-	else
-		list_add_tail(&ci->list, &si->discard_clusters);
+	list_move_tail(&ci->list, &si->discard_clusters);
 	ci->flags = 0;
 	schedule_work(&si->discard_work);
 }
@@ -453,7 +450,7 @@ static void __free_cluster(struct swap_i
 	lockdep_assert_held(&si->lock);
 	lockdep_assert_held(&ci->lock);
 
-	if (ci->flags & CLUSTER_FLAG_NONFULL)
+	if (ci->flags)
 		list_move_tail(&ci->list, &si->free_clusters);
 	else
 		list_add_tail(&ci->list, &si->free_clusters);
@@ -480,7 +477,6 @@ static void swap_do_scheduled_discard(st
 				SWAPFILE_CLUSTER);
 
 		spin_lock(&si->lock);
-
 		spin_lock(&ci->lock);
 		__free_cluster(si, ci);
 		memset(si->swap_map + idx * SWAPFILE_CLUSTER,
@@ -576,12 +572,9 @@ static void dec_cluster_info_page(struct
 
 	if (!(ci->flags & CLUSTER_FLAG_NONFULL)) {
 		VM_BUG_ON(ci->flags & CLUSTER_FLAG_FREE);
-		if (ci->flags & CLUSTER_FLAG_FRAG) {
+		if (ci->flags & CLUSTER_FLAG_FRAG)
 			p->frag_cluster_nr[ci->order]--;
-			list_move_tail(&ci->list, &p->nonfull_clusters[ci->order]);
-		} else {
-			list_add_tail(&ci->list, &p->nonfull_clusters[ci->order]);
-		}
+		list_move_tail(&ci->list, &p->nonfull_clusters[ci->order]);
 		ci->flags = CLUSTER_FLAG_NONFULL;
 	}
 }
@@ -674,8 +667,8 @@ static void cluster_alloc_range(struct s
 			  (CLUSTER_FLAG_FREE | CLUSTER_FLAG_NONFULL | CLUSTER_FLAG_FRAG)));
 		if (ci->flags & CLUSTER_FLAG_FRAG)
 			si->frag_cluster_nr[ci->order]--;
-		list_del(&ci->list);
-		ci->flags = 0;
+		list_move_tail(&ci->list, &si->full_clusters);
+		ci->flags = CLUSTER_FLAG_FULL;
 	}
 }
 
@@ -718,6 +711,46 @@ done:
 	return offset;
 }
 
+static void swap_reclaim_full_clusters(struct swap_info_struct *si)
+{
+	long to_scan = 1;
+	unsigned long offset, end;
+	struct swap_cluster_info *ci;
+	unsigned char *map = si->swap_map;
+	int nr_reclaim, total_reclaimed = 0;
+
+	if (atomic_long_read(&nr_swap_pages) <= SWAPFILE_CLUSTER)
+		to_scan = si->inuse_pages / SWAPFILE_CLUSTER;
+
+	while (!list_empty(&si->full_clusters)) {
+		ci = list_first_entry(&si->full_clusters, struct swap_cluster_info, list);
+		list_move_tail(&ci->list, &si->full_clusters);
+		offset = cluster_offset(si, ci);
+		end = min(si->max, offset + SWAPFILE_CLUSTER);
+		to_scan--;
+
+		while (offset < end) {
+			if (READ_ONCE(map[offset]) == SWAP_HAS_CACHE) {
+				spin_unlock(&si->lock);
+				nr_reclaim = __try_to_reclaim_swap(si, offset,
+								   TTRS_ANYWAY | TTRS_DIRECT);
+				spin_lock(&si->lock);
+				if (nr_reclaim > 0) {
+					offset += nr_reclaim;
+					total_reclaimed += nr_reclaim;
+					continue;
+				} else if (nr_reclaim < 0) {
+					offset += -nr_reclaim;
+					continue;
+				}
+			}
+			offset++;
+		}
+		if (to_scan <= 0 || total_reclaimed)
+			break;
+	}
+}
+
 /*
  * Try to get swap entries with specified order from current cpu's swap entry
  * pool (a cluster). This might involve allocating a new cluster for current CPU
@@ -826,7 +859,15 @@ new_cluster:
 				goto done;
 		}
 	}
+
 done:
+	/* Try reclaim from full clusters if device is nearfull */
+	if (vm_swap_full() && (!found || (si->pages - si->inuse_pages) < SWAPFILE_CLUSTER)) {
+		swap_reclaim_full_clusters(si);
+		if (!found && !order && si->pages != si->inuse_pages)
+			goto new_cluster;
+	}
+
 	cluster->next[order] = offset;
 	return found;
 }
@@ -3115,6 +3156,7 @@ static int setup_swap_map_and_extents(st
 	nr_good_pages = maxpages - 1;	/* omit header page */
 
 	INIT_LIST_HEAD(&p->free_clusters);
+	INIT_LIST_HEAD(&p->full_clusters);
 	INIT_LIST_HEAD(&p->discard_clusters);
 
 	for (i = 0; i < SWAP_NR_ORDERS; i++) {
_

Patches currently in -mm which might be from kasong@tencent.com are


