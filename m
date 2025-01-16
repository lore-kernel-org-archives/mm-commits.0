Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B959217E00E
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006259; cv=none; b=GE+obyC7VyWvKwZ/NPhS/H8tPc664eSN+om85zVgl/BAnYtqDbxzVujl43fV7QWJDVkH6u52QSqdaODmh44hAQblc82KMwNyupgiBZ3sQESzUMw4a8U0u7KwZzysf9GcupiYTH79kcqD28bpBLu9jDE7SbR57chhuTUej8AIu0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006259; c=relaxed/simple;
	bh=C1EDnB1YREVbzwpEvTUnau1989sYxNbRkh7jWXLkxJ0=;
	h=Date:To:From:Subject:Message-Id; b=IkfIPBoGM03hogTHXlYZLUacd3uFyvlPhvU/OLq3dqAOublc9dFCuJfEihQTOrKGfgWPXmoMM9lwArGlh3uL/SftNW6vEznq5XDCZbBOf+sFdqDgU6ptvpnXtEvnN+GDD1r763s0ZKKhdImHaLGm/uQ5sA+QjXy8yjqJCHyqNsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TtyuDTsy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TtyuDTsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400A9C4CED6;
	Thu, 16 Jan 2025 05:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006259;
	bh=C1EDnB1YREVbzwpEvTUnau1989sYxNbRkh7jWXLkxJ0=;
	h=Date:To:From:Subject:From;
	b=TtyuDTsyNpOOoYuPpOUVLi+jqyomZMwMtWDWxeNBEgzErVe13uRlCL9TAfsp8nwFm
	 dDr1Gbw3m8uVShZs01TmKxiPHqr7ZZHEC6E82MFM5Op6tfLk/v5cQCZknOyPkuE4Hl
	 xDnLOOZFe91fgISH8D5DX3DfMNE2IBHF8y7KR3v8=
Date: Wed, 15 Jan 2025 21:44:18 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-simplify-percpu-cluster-updating.patch removed from -mm tree
Message-Id: <20250116054419.400A9C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: simplify percpu cluster updating
has been removed from the -mm tree.  Its filename was
     mm-swap-simplify-percpu-cluster-updating.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: simplify percpu cluster updating
Date: Tue, 14 Jan 2025 01:57:29 +0800

Instead of using a returning argument, we can simply store the next
cluster offset to the fixed percpu location, which reduce the stack usage
and simplify the function:

Object size:
./scripts/bloat-o-meter mm/swapfile.o mm/swapfile.o.new
add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-271 (-271)
Function                                     old     new   delta
get_swap_pages                              2847    2733    -114
alloc_swap_scan_cluster                      894     737    -157
Total: Before=30833, After=30562, chg -0.88%

Stack usage:
Before:
swapfile.c:1190:5:get_swap_pages       240    static

After:
swapfile.c:1185:5:get_swap_pages       216    static

Link: https://lkml.kernel.org/r/20250113175732.48099-11-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 +-
 mm/swapfile.c        |   66 ++++++++++++++++++-----------------------
 2 files changed, 31 insertions(+), 39 deletions(-)

--- a/include/linux/swap.h~mm-swap-simplify-percpu-cluster-updating
+++ a/include/linux/swap.h
@@ -274,9 +274,9 @@ enum swap_cluster_flags {
  * The first page in the swap file is the swap header, which is always marked
  * bad to prevent it from being allocated as an entry. This also prevents the
  * cluster to which it belongs being marked free. Therefore 0 is safe to use as
- * a sentinel to indicate next is not valid in percpu_cluster.
+ * a sentinel to indicate an entry is not valid.
  */
-#define SWAP_NEXT_INVALID	0
+#define SWAP_ENTRY_INVALID	0
 
 #ifdef CONFIG_THP_SWAP
 #define SWAP_NR_ORDERS		(PMD_ORDER + 1)
--- a/mm/swapfile.c~mm-swap-simplify-percpu-cluster-updating
+++ a/mm/swapfile.c
@@ -765,23 +765,23 @@ static bool cluster_alloc_range(struct s
 	return true;
 }
 
-static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si, unsigned long offset,
-					    unsigned int *foundp, unsigned int order,
+/* Try use a new cluster for current CPU and allocate from it. */
+static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
+					    struct swap_cluster_info *ci,
+					    unsigned long offset,
+					    unsigned int order,
 					    unsigned char usage)
 {
-	unsigned long start = offset & ~(SWAPFILE_CLUSTER - 1);
+	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
 	unsigned int nr_pages = 1 << order;
 	bool need_reclaim, ret;
-	struct swap_cluster_info *ci;
 
-	ci = &si->cluster_info[offset / SWAPFILE_CLUSTER];
 	lockdep_assert_held(&ci->lock);
 
-	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER) {
-		offset = SWAP_NEXT_INVALID;
+	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
 		goto out;
-	}
 
 	for (end -= nr_pages; offset <= end; offset += nr_pages) {
 		need_reclaim = false;
@@ -795,34 +795,27 @@ static unsigned int alloc_swap_scan_clus
 			 * cluster has no flag set, and change of list
 			 * won't cause fragmentation.
 			 */
-			if (!cluster_is_usable(ci, order)) {
-				offset = SWAP_NEXT_INVALID;
+			if (!cluster_is_usable(ci, order))
 				goto out;
-			}
 			if (cluster_is_empty(ci))
 				offset = start;
 			/* Reclaim failed but cluster is usable, try next */
 			if (!ret)
 				continue;
 		}
-		if (!cluster_alloc_range(si, ci, offset, usage, order)) {
-			offset = SWAP_NEXT_INVALID;
-			goto out;
-		}
-		*foundp = offset;
-		if (ci->count == SWAPFILE_CLUSTER) {
-			offset = SWAP_NEXT_INVALID;
-			goto out;
-		}
+		if (!cluster_alloc_range(si, ci, offset, usage, order))
+			break;
+		found = offset;
 		offset += nr_pages;
+		if (ci->count < SWAPFILE_CLUSTER && offset <= end)
+			next = offset;
 		break;
 	}
-	if (offset > end)
-		offset = SWAP_NEXT_INVALID;
 out:
 	relocate_cluster(si, ci);
 	unlock_cluster(ci);
-	return offset;
+	__this_cpu_write(si->percpu_cluster->next[order], next);
+	return found;
 }
 
 /* Return true if reclaimed a whole cluster */
@@ -891,8 +884,8 @@ static unsigned long cluster_alloc_swap_
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(si, ci);
-			offset = alloc_swap_scan_cluster(si, offset, &found,
-							 order, usage);
+			found = alloc_swap_scan_cluster(si, ci, offset,
+							order, usage);
 		} else {
 			unlock_cluster(ci);
 		}
@@ -903,8 +896,8 @@ static unsigned long cluster_alloc_swap_
 new_cluster:
 	ci = isolate_lock_cluster(si, &si->free_clusters);
 	if (ci) {
-		offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
-						 &found, order, usage);
+		found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+						order, usage);
 		if (found)
 			goto done;
 	}
@@ -917,8 +910,8 @@ new_cluster:
 		unsigned int frags = 0, frags_existing;
 
 		while ((ci = isolate_lock_cluster(si, &si->nonfull_clusters[order]))) {
-			offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
-							 &found, order, usage);
+			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+							order, usage);
 			if (found)
 				goto done;
 			/* Clusters failed to allocate are moved to frag_clusters */
@@ -935,8 +928,8 @@ new_cluster:
 			 * per-CPU usage, but they could contain newly released
 			 * reclaimable (eg. lazy-freed swap cache) slots.
 			 */
-			offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
-							 &found, order, usage);
+			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+							order, usage);
 			if (found)
 				goto done;
 			frags++;
@@ -962,21 +955,20 @@ new_cluster:
 		 */
 		while ((ci = isolate_lock_cluster(si, &si->frag_clusters[o]))) {
 			atomic_long_dec(&si->frag_cluster_nr[o]);
-			offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
-							 &found, order, usage);
+			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+							0, usage);
 			if (found)
 				goto done;
 		}
 
 		while ((ci = isolate_lock_cluster(si, &si->nonfull_clusters[o]))) {
-			offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
-							 &found, order, usage);
+			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+							0, usage);
 			if (found)
 				goto done;
 		}
 	}
 done:
-	__this_cpu_write(si->percpu_cluster->next[order], offset);
 	local_unlock(&si->percpu_cluster->lock);
 
 	return found;
@@ -3200,7 +3192,7 @@ static struct swap_cluster_info *setup_c
 
 		cluster = per_cpu_ptr(si->percpu_cluster, cpu);
 		for (i = 0; i < SWAP_NR_ORDERS; i++)
-			cluster->next[i] = SWAP_NEXT_INVALID;
+			cluster->next[i] = SWAP_ENTRY_INVALID;
 		local_lock_init(&cluster->lock);
 	}
 
_

Patches currently in -mm which might be from kasong@tencent.com are


