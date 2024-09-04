Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072EC59155
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423409; cv=none; b=WcV9NDoOfvTttY+lZMWLlD+aA/XKjmF0uEZJBw8HOKBg8s+U9jLC3FFl90XTKU9DAlUnxL17/AkErqWmEIccVJ2BoYewfdkjW372L/8Nu01wjvvZt5/6RMgt947DYkNS2Mbyl4iVhQt4aUU/fiMJ/nKawN+LTQEbzV/yAcI/vaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423409; c=relaxed/simple;
	bh=ySZRBcRsK2cNXA1MKbp7uB2QDz1lD82QycxWOmigm4w=;
	h=Date:To:From:Subject:Message-Id; b=f83zgpbGcj1CyxMDmi3gVJOiz0wXzwkc2fYGVrgBTYFJcqifx9lla2XzQXy8UEhBQ6jSC0pPOX45ySgYmcpcmF3x9DxkuaWnr3SPFHIkyvohPt4GJcp6UrwZVllWH9YFLNDjw14VqE1dbU5POtOGYb91OW3TqQZEhykLX5IvfS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yyz4t4LC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yyz4t4LC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0EBC4CEC2;
	Wed,  4 Sep 2024 04:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423408;
	bh=ySZRBcRsK2cNXA1MKbp7uB2QDz1lD82QycxWOmigm4w=;
	h=Date:To:From:Subject:From;
	b=Yyz4t4LC8vGWT60TiYYDEmc9KfS5d6WmT2eQt3KbG23ld3SiBXQYqVchCQGtNP4w0
	 oeSmb8vuyk0mTpA4qke70O+iKpIJlwW4fob/mkMiXOUF7HnNQEyOisRRjw7yhtHPKY
	 ZKwiVgewcYH1NdMeiPiSJdhHJJploYo/d0ZMeGhE=
Date: Tue, 03 Sep 2024 21:16:48 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,kaleshsingh@google.com,hughd@google.com,chrisl@kernel.org,21cnbao@gmail.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-add-a-fragment-cluster-list.patch removed from -mm tree
Message-Id: <20240904041648.7E0EBC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: add a fragment cluster list
has been removed from the -mm tree.  Its filename was
     mm-swap-add-a-fragment-cluster-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm: swap: add a fragment cluster list
Date: Tue, 30 Jul 2024 23:49:19 -0700

Now swap cluster allocator arranges the clusters in LRU style, so the
"cold" cluster stay at the head of nonfull lists are the ones that were
used for allocation long time ago and still partially occupied.  So if
allocator can't find enough contiguous slots to satisfy an high order
allocation, it's unlikely there will be slot being free on them to satisfy
the allocation, at least in a short period.

As a result, nonfull cluster scanning will waste time repeatly scanning
the unusable head of the list.

Also, multiple CPUs could content on the same head cluster of nonfull
list.  Unlike free clusters which are removed from the list when any CPU
starts using it, nonfull cluster stays on the head.

So introduce a new list frag list, all scanned nonfull clusters will be
moved to this list.  Both for avoiding repeated scanning and contention.

Frag list is still used as fallback for allocations, so if one CPU failed
to allocate one order of slots, it can still steal other CPU's clusters. 
And order 0 will favor the fragmented clusters to better protect nonfull
clusters

If any slots on a fragment list are being freed, move the fragment list
back to nonfull list indicating it worth another scan on the cluster. 
Compared to scan upon freeing a slot, this keep the scanning lazy and save
some CPU if there are still other clusters to use.

It may seems unneccessay to keep the fragmented cluster on list at all if
they can't be used for specific order allocation.  But this will start to
make sense once reclaim dring scanning is ready.

Link: https://lkml.kernel.org/r/20240730-swap-allocator-v5-7-cb9c148b9297@kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 +++
 mm/swapfile.c        |   41 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 4 deletions(-)

--- a/include/linux/swap.h~mm-swap-add-a-fragment-cluster-list
+++ a/include/linux/swap.h
@@ -259,6 +259,7 @@ struct swap_cluster_info {
 };
 #define CLUSTER_FLAG_FREE 1 /* This cluster is free */
 #define CLUSTER_FLAG_NONFULL 2 /* This cluster is on nonfull list */
+#define CLUSTER_FLAG_FRAG 4 /* This cluster is on nonfull list */
 
 /*
  * The first page in the swap file is the swap header, which is always marked
@@ -298,6 +299,8 @@ struct swap_info_struct {
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
 					/* list of cluster that contains at least one free slot */
+	struct list_head frag_clusters[SWAP_NR_ORDERS];
+					/* list of cluster that are fragmented or contented */
 	unsigned int lowest_bit;	/* index of first free in swap_map */
 	unsigned int highest_bit;	/* index of last free in swap_map */
 	unsigned int pages;		/* total of usable pages of swap */
--- a/mm/swapfile.c~mm-swap-add-a-fragment-cluster-list
+++ a/mm/swapfile.c
@@ -572,7 +572,10 @@ static void dec_cluster_info_page(struct
 
 	if (!(ci->flags & CLUSTER_FLAG_NONFULL)) {
 		VM_BUG_ON(ci->flags & CLUSTER_FLAG_FREE);
-		list_add_tail(&ci->list, &p->nonfull_clusters[ci->order]);
+		if (ci->flags & CLUSTER_FLAG_FRAG)
+			list_move_tail(&ci->list, &p->nonfull_clusters[ci->order]);
+		else
+			list_add_tail(&ci->list, &p->nonfull_clusters[ci->order]);
 		ci->flags = CLUSTER_FLAG_NONFULL;
 	}
 }
@@ -610,7 +613,8 @@ static inline void cluster_alloc_range(s
 	ci->count += nr_pages;
 
 	if (ci->count == SWAPFILE_CLUSTER) {
-		VM_BUG_ON(!(ci->flags & (CLUSTER_FLAG_FREE | CLUSTER_FLAG_NONFULL)));
+		VM_BUG_ON(!(ci->flags &
+			  (CLUSTER_FLAG_FREE | CLUSTER_FLAG_NONFULL | CLUSTER_FLAG_FRAG)));
 		list_del(&ci->list);
 		ci->flags = 0;
 	}
@@ -666,6 +670,7 @@ static unsigned long cluster_alloc_swap_
 	struct percpu_cluster *cluster;
 	struct swap_cluster_info *ci, *n;
 	unsigned int offset, found = 0;
+	LIST_HEAD(fraged);
 
 new_cluster:
 	lockdep_assert_held(&si->lock);
@@ -686,13 +691,29 @@ new_cluster:
 
 	if (order < PMD_ORDER) {
 		list_for_each_entry_safe(ci, n, &si->nonfull_clusters[order], list) {
+			list_move_tail(&ci->list, &fraged);
+			ci->flags = CLUSTER_FLAG_FRAG;
 			offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
 							 &found, order, usage);
 			if (found)
-				goto done;
+				break;
 		}
+
+		if (!found) {
+			list_for_each_entry_safe(ci, n, &si->frag_clusters[order], list) {
+				offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
+								 &found, order, usage);
+				if (found)
+					break;
+			}
+		}
+
+		list_splice_tail(&fraged, &si->frag_clusters[order]);
 	}
 
+	if (found)
+		goto done;
+
 	if (!list_empty(&si->discard_clusters)) {
 		/*
 		 * we don't have free cluster but have some clusters in
@@ -706,7 +727,17 @@ new_cluster:
 	if (order)
 		goto done;
 
+	/* Order 0 stealing from higher order */
 	for (int o = 1; o < SWAP_NR_ORDERS; o++) {
+		if (!list_empty(&si->frag_clusters[o])) {
+			ci = list_first_entry(&si->frag_clusters[o],
+					      struct swap_cluster_info, list);
+			offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci), &found,
+							 0, usage);
+			VM_BUG_ON(!found);
+			goto done;
+		}
+
 		if (!list_empty(&si->nonfull_clusters[o])) {
 			ci = list_first_entry(&si->nonfull_clusters[o], struct swap_cluster_info,
 					      list);
@@ -3008,8 +3039,10 @@ static int setup_swap_map_and_extents(st
 	INIT_LIST_HEAD(&p->free_clusters);
 	INIT_LIST_HEAD(&p->discard_clusters);
 
-	for (i = 0; i < SWAP_NR_ORDERS; i++)
+	for (i = 0; i < SWAP_NR_ORDERS; i++) {
 		INIT_LIST_HEAD(&p->nonfull_clusters[i]);
+		INIT_LIST_HEAD(&p->frag_clusters[i]);
+	}
 
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
_

Patches currently in -mm which might be from kasong@tencent.com are


