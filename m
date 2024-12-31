Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1C380B
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735604046; cv=none; b=YfhhTvIxlDZp6hZt8gIHS5BAcdNPZcmpHEyq9HAgbmSroLapm4YnobtN5cmBfNSssyVzgrdsE5O9WXXMxdeI3k3ZEdsW+b9Y3RvLi8vmpxLAqOtJo2iZ7XEBAqxku4exCpJVsBMDZmBxbEAKhE23Jo9NYOjsuRL+5itRfODjWGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735604046; c=relaxed/simple;
	bh=W/xhwkKqQVkQg65XPqyR7vjnQ24+Fa0QfJIGdXJfMAQ=;
	h=Date:To:From:Subject:Message-Id; b=Kv6FfbyRlweAUjuI6d1VE2E1hfQPt9f2JClFzmxiLpNOWJ2FDgHNswTkmx3GuyvwhcvYi3tKe/jswZV4Dn2so26khEfwza0tO5KFL4YMi74hNOMNt+2uLHQNTp8OFQpcuNTT1PoZO4j9+iwpaVuunWpJ1UzE52cce54qs+DkqjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y/u0U/5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y/u0U/5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F47FC4CED0;
	Tue, 31 Dec 2024 00:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735604046;
	bh=W/xhwkKqQVkQg65XPqyR7vjnQ24+Fa0QfJIGdXJfMAQ=;
	h=Date:To:From:Subject:From;
	b=Y/u0U/5wE56LplnE5pJbSrPETWX0j3un+LYo7v2E8ALENMMuvRb+qnrLOKHkTsvAe
	 s21kZNE7SYlXWGkNTBA4o0t48d6MunlGKqEibcbIFF44P+tLkHUSrfJSzOHFyHt0El
	 eoUak62IQwb0/SXdqMyir9NBviK8XmGAqsIcV6Kw=
Date: Mon, 30 Dec 2024 16:14:06 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-simplify-percpu-cluster-updating.patch added to mm-unstable branch
Message-Id: <20241231001406.9F47FC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: simplify percpu cluster updating
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-simplify-percpu-cluster-updating.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-simplify-percpu-cluster-updating.patch

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
Subject: mm, swap: simplify percpu cluster updating
Date: Tue, 31 Dec 2024 01:46:18 +0800

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

Link: https://lkml.kernel.org/r/20241230174621.61185-11-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
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
@@ -275,9 +275,9 @@ enum swap_cluster_flags {
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
@@ -759,23 +759,23 @@ static bool cluster_alloc_range(struct s
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
@@ -789,34 +789,27 @@ static unsigned int alloc_swap_scan_clus
 			 * cluster has no flag set, and change of list
 			 * won't cause fragmentation.
 			 */
-			if (!cluster_is_usable(ci, order)) {
-				offset = SWAP_NEXT_INVALID;
+			if (!cluster_is_usable(ci, order))
 				goto out;
-			}
 			if (cluster_is_free(ci))
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
@@ -885,8 +878,8 @@ static unsigned long cluster_alloc_swap_
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_free(ci))
 				offset = cluster_offset(si, ci);
-			offset = alloc_swap_scan_cluster(si, offset, &found,
-							 order, usage);
+			found = alloc_swap_scan_cluster(si, ci, offset,
+							order, usage);
 		} else {
 			unlock_cluster(ci);
 		}
@@ -897,8 +890,8 @@ static unsigned long cluster_alloc_swap_
 new_cluster:
 	ci = cluster_isolate_lock(si, &si->free_clusters);
 	if (ci) {
-		offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
-						 &found, order, usage);
+		found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+						order, usage);
 		if (found)
 			goto done;
 	}
@@ -911,8 +904,8 @@ new_cluster:
 		unsigned int frags = 0, frags_existing;
 
 		while ((ci = cluster_isolate_lock(si, &si->nonfull_clusters[order]))) {
-			offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
-							 &found, order, usage);
+			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+							order, usage);
 			/*
 			 * With `fragmenting` set to true, it will surely take
 			 * the cluster off nonfull list
@@ -932,8 +925,8 @@ new_cluster:
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
@@ -959,21 +952,20 @@ new_cluster:
 		 */
 		while ((ci = cluster_isolate_lock(si, &si->frag_clusters[o]))) {
 			atomic_long_dec(&si->frag_cluster_nr[o]);
-			offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci),
-							 &found, order, usage);
+			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+							0, usage);
 			if (found)
 				goto done;
 		}
 
 		while ((ci = cluster_isolate_lock(si, &si->nonfull_clusters[o]))) {
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
@@ -3194,7 +3186,7 @@ static struct swap_cluster_info *setup_c
 
 		cluster = per_cpu_ptr(si->percpu_cluster, cpu);
 		for (i = 0; i < SWAP_NR_ORDERS; i++)
-			cluster->next[i] = SWAP_NEXT_INVALID;
+			cluster->next[i] = SWAP_ENTRY_INVALID;
 		local_lock_init(&cluster->lock);
 	}
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-fix-false-warning-of-negative-counter.patch
mm-madvise-fix-potential-workingset-node-list_lru-leaks.patch
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

