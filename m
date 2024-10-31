Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C912412C491
	for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 03:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344508; cv=none; b=QjdT1XOY5Xut4+8bky5b33wB8EXVD1lGqOT6mWbIcFoLq0d0VGIjiFXN+MDf5eHw1C/dsI3ca5stw3cqdYp0K7Hjvd99Wuh097O7yqw8Gh4A4aHq25SgDMmelRX7ABwGu03YBxy3LIc8KLN6b0cAMvZ78E4cuHcGOPUI95EkvCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344508; c=relaxed/simple;
	bh=MaYR20UvsTNDJz0064Oe1rovks8vHgPg7EvoWXG9eIE=;
	h=Date:To:From:Subject:Message-Id; b=OR0yp8GcWbb9AJWLbna92pQPFUf0ddZz+pMzLCkNBReBXMkeE5U0jgBQ3xTINIHlLR129+0D05sKfg2fEz1oDyqjkZNUvTekV44qgDUbeGenu4HrNBHoGc4tLSZF+SzyIPZRAFI6pTOodMqDG5M726XLKTyoiXVb+MWJKjP1z/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bC1/L/Tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bC1/L/Tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B41FC4CECE;
	Thu, 31 Oct 2024 03:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344508;
	bh=MaYR20UvsTNDJz0064Oe1rovks8vHgPg7EvoWXG9eIE=;
	h=Date:To:From:Subject:From;
	b=bC1/L/TjJA5Lgwv+AECxB7/hmndjSm36MMVtQG2GnBy3pNC/UhxHt0fnx8oBVF5hB
	 Qscj0CMQSOMTOPNgLzXCAljJq3okO0RCHYTCoDTCQrLQzCRLF5Vo6Hl3BARSQiMcuK
	 ZY2FehUdmDmZqfw5aCNFqUA3z6XRVf1L9bfjOKOQ=
Date: Wed, 30 Oct 2024 20:15:08 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,kaleshsingh@google.com,hughd@google.com,chrisl@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-avoid-over-reclaim-of-full-clusters.patch removed from -mm tree
Message-Id: <20241031031508.8B41FC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: avoid over reclaim of full clusters
has been removed from the -mm tree.  Its filename was
     mm-swap-avoid-over-reclaim-of-full-clusters.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: avoid over reclaim of full clusters
Date: Wed, 23 Oct 2024 01:55:12 +0800

When running low on usable slots, cluster allocator will try to reclaim
the full clusters aggressively to reclaim HAS_CACHE slots.  This
guarantees that as long as there are any usable slots, HAS_CACHE or not,
the swap device will be usable and workload won't go OOM early.

Before the cluster allocator, swap allocator fails easily if device is
filled up with reclaimable HAS_CACHE slots.  Which can be easily
reproduced with following simple program:

    #include <stdio.h>
    #include <string.h>
    #include <linux/mman.h>
    #include <sys/mman.h>
    #define SIZE 8192UL * 1024UL * 1024UL
    int main(int argc, char **argv) {
        long tmp;
        char *p = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
               MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        memset(p, 0, SIZE);
        madvise(p, SIZE, MADV_PAGEOUT);
        for (unsigned long i = 0; i < SIZE; ++i)
            tmp += p[i];
        getchar(); /* Pause */
        return 0;
    }

Setup an 8G non ramdisk swap, the first run of the program will swapout 8G
ram successfully.  But run same program again after the first run paused,
the second run can't swapout all 8G memory as now half of the swap device
is pinned by HAS_CACHE.  There was a random scan in the old allocator that
may reclaim part of the HAS_CACHE by luck, but it's unreliable.

The new allocator's added reclaim of full clusters when device is low on
usable slots.  But when multiple CPUs are seeing the device is low on
usable slots at the same time, they ran into a thundering herd problem.

This is an observable problem on large machine with mass parallel
workload, as full cluster reclaim is slower on large swap device and
higher number of CPUs will also make things worse.

Testing using a 128G ZRAM on a 48c96t system.  When the swap device is
very close to full (eg.  124G / 128G), running build linux kernel with
make -j96 in a 1G memory cgroup will hung (not a softlockup though)
spinning in full cluster reclaim for about ~5min before go OOM.

To solve this, split the full reclaim into two parts:

- Instead of do a synchronous aggressively reclaim when device is low,
  do only one aggressively reclaim when device is strictly full with a
  kworker. This still ensures in worst case the device won't be unusable
  because of HAS_CACHE slots.

- To avoid allocation (especially higher order) suffer from HAS_CACHE
  filling up clusters and kworker not responsive enough, do one synchronous
  scan every time the free list is drained, and only scan one cluster. This
  is kind of similar to the random reclaim before, keeps the full clusters
  rotated and has a minimal latency. This should provide a fair reclaim
  strategy suitable for most workloads.

Link: https://lkml.kernel.org/r/20241022175512.10398-1-ryncsn@gmail.com
Fixes: 2cacbdfdee65 ("mm: swap: add a adaptive full cluster cache reclaim")
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/swapfile.c        |   49 +++++++++++++++++++++++++----------------
 2 files changed, 31 insertions(+), 19 deletions(-)

--- a/include/linux/swap.h~mm-swap-avoid-over-reclaim-of-full-clusters
+++ a/include/linux/swap.h
@@ -335,6 +335,7 @@ struct swap_info_struct {
 					 * list.
 					 */
 	struct work_struct discard_work; /* discard worker */
+	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_lists[]; /*
 					   * entries in swap_avail_heads, one
--- a/mm/swapfile.c~mm-swap-avoid-over-reclaim-of-full-clusters
+++ a/mm/swapfile.c
@@ -731,15 +731,16 @@ done:
 	return offset;
 }
 
-static void swap_reclaim_full_clusters(struct swap_info_struct *si)
+/* Return true if reclaimed a whole cluster */
+static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 {
 	long to_scan = 1;
 	unsigned long offset, end;
 	struct swap_cluster_info *ci;
 	unsigned char *map = si->swap_map;
-	int nr_reclaim, total_reclaimed = 0;
+	int nr_reclaim;
 
-	if (atomic_long_read(&nr_swap_pages) <= SWAPFILE_CLUSTER)
+	if (force)
 		to_scan = si->inuse_pages / SWAPFILE_CLUSTER;
 
 	while (!list_empty(&si->full_clusters)) {
@@ -749,28 +750,36 @@ static void swap_reclaim_full_clusters(s
 		end = min(si->max, offset + SWAPFILE_CLUSTER);
 		to_scan--;
 
+		spin_unlock(&si->lock);
 		while (offset < end) {
 			if (READ_ONCE(map[offset]) == SWAP_HAS_CACHE) {
-				spin_unlock(&si->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY | TTRS_DIRECT);
-				spin_lock(&si->lock);
-				if (nr_reclaim > 0) {
-					offset += nr_reclaim;
-					total_reclaimed += nr_reclaim;
-					continue;
-				} else if (nr_reclaim < 0) {
-					offset += -nr_reclaim;
+				if (nr_reclaim) {
+					offset += abs(nr_reclaim);
 					continue;
 				}
 			}
 			offset++;
 		}
-		if (to_scan <= 0 || total_reclaimed)
+		spin_lock(&si->lock);
+
+		if (to_scan <= 0)
 			break;
 	}
 }
 
+static void swap_reclaim_work(struct work_struct *work)
+{
+	struct swap_info_struct *si;
+
+	si = container_of(work, struct swap_info_struct, reclaim_work);
+
+	spin_lock(&si->lock);
+	swap_reclaim_full_clusters(si, true);
+	spin_unlock(&si->lock);
+}
+
 /*
  * Try to get swap entries with specified order from current cpu's swap entry
  * pool (a cluster). This might involve allocating a new cluster for current CPU
@@ -800,6 +809,10 @@ new_cluster:
 		goto done;
 	}
 
+	/* Try reclaim from full clusters if free clusters list is drained */
+	if (vm_swap_full())
+		swap_reclaim_full_clusters(si, false);
+
 	if (order < PMD_ORDER) {
 		unsigned int frags = 0;
 
@@ -881,13 +894,6 @@ new_cluster:
 	}
 
 done:
-	/* Try reclaim from full clusters if device is nearfull */
-	if (vm_swap_full() && (!found || (si->pages - si->inuse_pages) < SWAPFILE_CLUSTER)) {
-		swap_reclaim_full_clusters(si);
-		if (!found && !order && si->pages != si->inuse_pages)
-			goto new_cluster;
-	}
-
 	cluster->next[order] = offset;
 	return found;
 }
@@ -922,6 +928,9 @@ static void swap_range_alloc(struct swap
 		si->lowest_bit = si->max;
 		si->highest_bit = 0;
 		del_from_avail_list(si);
+
+		if (vm_swap_full())
+			schedule_work(&si->reclaim_work);
 	}
 }
 
@@ -2816,6 +2825,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	wait_for_completion(&p->comp);
 
 	flush_work(&p->discard_work);
+	flush_work(&p->reclaim_work);
 
 	destroy_swap_extents(p);
 	if (p->flags & SWP_CONTINUED)
@@ -3376,6 +3386,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 		return PTR_ERR(si);
 
 	INIT_WORK(&si->discard_work, swap_discard_work);
+	INIT_WORK(&si->reclaim_work, swap_reclaim_work);
 
 	name = getname(specialfile);
 	if (IS_ERR(name)) {
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-dont-pass-unnecessary-key-parameters.patch
mm-list_lru-dont-export-list_lru_add.patch
mm-list_lru-code-clean-up-for-reparenting.patch
mm-list_lru-simplify-reparenting-and-initial-allocation.patch
mm-list_lru-split-the-lock-to-per-cgroup-scope.patch
mm-list_lru-simplify-the-list_lru-walk-callback-function.patch
mm-zswap-avoid-touching-xarray-for-unnecessary-invalidation.patch

