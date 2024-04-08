Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124707482
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 20:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712608671; cv=none; b=NZvU2rnTPsHPPElR494xXBVYzMq2DPpm0uMQ/AJTBFcupB/J4/HFPHeOkOxyc4AzRlis1wvhTVGN1PhCmsICazESC5gOTF0aIHMY6OyxEVY8HER9OuqqiwruumFtKAu8DJFy3UO7+HHK9KP5UIduDenA2wZuopHAJt6BNFbPbf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712608671; c=relaxed/simple;
	bh=6iqVT5C6qFeeS/2nwb2Ltfms6EVp+V/DyFAA7WrTFXw=;
	h=Date:To:From:Subject:Message-Id; b=QAxRpSwAmsv3OlN0RfW5G3MuQr3EDFbLI6d0+NN5PfCF4N4RhY4ftQQ6ikwoEU94xDhCWPhbPr1su3Xu40wTStay9SayCWvyBSo2fL6cNCwhjHRoU94tW3MNlGh38ymsW8tHKuFJdPCjonP/j+fgmM3/njB7mZ/Iei4jICSLIm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lGcBXdZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lGcBXdZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81606C433C7;
	Mon,  8 Apr 2024 20:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712608670;
	bh=6iqVT5C6qFeeS/2nwb2Ltfms6EVp+V/DyFAA7WrTFXw=;
	h=Date:To:From:Subject:From;
	b=lGcBXdZ+14NFoYyBqMu6KFFrppqss3cKBnDrhkohMzyWr1aW1LTns68QI3qqxgjtS
	 3Uy3YOcV6Rpj0qGs1Z3PeAoynSJedWGo6oMDdoYJ0MMjM7Ts4A9HBT8td+906DqsC2
	 B1N9i0DywtiA6jPzVJ3joddTW9y2NockD6Vr+3yE=
Date: Mon, 08 Apr 2024 13:37:49 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,mhocko@suse.com,ioworker0@gmail.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-simplify-struct-percpu_cluster.patch added to mm-unstable branch
Message-Id: <20240408203750.81606C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: simplify struct percpu_cluster
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-simplify-struct-percpu_cluster.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-simplify-struct-percpu_cluster.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: swap: simplify struct percpu_cluster
Date: Mon, 8 Apr 2024 19:39:42 +0100

struct percpu_cluster stores the index of cpu's current cluster and the
offset of the next entry that will be allocated for the cpu.  These two
pieces of information are redundant because the cluster index is just
(offset / SWAPFILE_CLUSTER).  The only reason for explicitly keeping the
cluster index is because the structure used for it also has a flag to
indicate "no cluster".  However this data structure also contains a spin
lock, which is never used in this context, as a side effect the code
copies the spinlock_t structure, which is questionable coding practice in
my view.

So let's clean this up and store only the next offset, and use a sentinal
value (SWAP_NEXT_INVALID) to indicate "no cluster".  SWAP_NEXT_INVALID is
chosen to be 0, because 0 will never be seen legitimately; The first page
in the swap file is the swap header, which is always marked bad to prevent
it from being allocated as an entry.  This also prevents the cluster to
which it belongs being marked free, so it will never appear on the free
list.

This change saves 16 bytes per cpu.  And given we are shortly going to
extend this mechanism to be per-cpu-AND-per-order, we will end up saving
16 * 9 = 144 bytes per cpu, which adds up if you have 256 cpus in the
system.

Link: https://lkml.kernel.org/r/20240408183946.2991168-4-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    9 ++++++++-
 mm/swapfile.c        |   22 +++++++++++-----------
 2 files changed, 19 insertions(+), 12 deletions(-)

--- a/include/linux/swap.h~mm-swap-simplify-struct-percpu_cluster
+++ a/include/linux/swap.h
@@ -261,12 +261,19 @@ struct swap_cluster_info {
 #define CLUSTER_FLAG_NEXT_NULL 2 /* This cluster has no next cluster */
 
 /*
+ * The first page in the swap file is the swap header, which is always marked
+ * bad to prevent it from being allocated as an entry. This also prevents the
+ * cluster to which it belongs being marked free. Therefore 0 is safe to use as
+ * a sentinel to indicate next is not valid in percpu_cluster.
+ */
+#define SWAP_NEXT_INVALID	0
+
+/*
  * We assign a cluster to each CPU, so each CPU can allocate swap entry from
  * its own cluster and swapout sequentially. The purpose is to optimize swapout
  * throughput.
  */
 struct percpu_cluster {
-	struct swap_cluster_info index; /* Current cluster index */
 	unsigned int next; /* Likely next allocation offset */
 };
 
--- a/mm/swapfile.c~mm-swap-simplify-struct-percpu_cluster
+++ a/mm/swapfile.c
@@ -609,7 +609,7 @@ scan_swap_map_ssd_cluster_conflict(struc
 		return false;
 
 	percpu_cluster = this_cpu_ptr(si->percpu_cluster);
-	cluster_set_null(&percpu_cluster->index);
+	percpu_cluster->next = SWAP_NEXT_INVALID;
 	return true;
 }
 
@@ -622,14 +622,14 @@ static bool scan_swap_map_try_ssd_cluste
 {
 	struct percpu_cluster *cluster;
 	struct swap_cluster_info *ci;
-	unsigned long tmp, max;
+	unsigned int tmp, max;
 
 new_cluster:
 	cluster = this_cpu_ptr(si->percpu_cluster);
-	if (cluster_is_null(&cluster->index)) {
+	tmp = cluster->next;
+	if (tmp == SWAP_NEXT_INVALID) {
 		if (!cluster_list_empty(&si->free_clusters)) {
-			cluster->index = si->free_clusters.head;
-			cluster->next = cluster_next(&cluster->index) *
+			tmp = cluster_next(&si->free_clusters.head) *
 					SWAPFILE_CLUSTER;
 		} else if (!cluster_list_empty(&si->discard_clusters)) {
 			/*
@@ -649,9 +649,7 @@ new_cluster:
 	 * Other CPUs can use our cluster if they can't find a free cluster,
 	 * check if there is still free entry in the cluster
 	 */
-	tmp = cluster->next;
-	max = min_t(unsigned long, si->max,
-		    (cluster_next(&cluster->index) + 1) * SWAPFILE_CLUSTER);
+	max = min_t(unsigned long, si->max, ALIGN(tmp + 1, SWAPFILE_CLUSTER));
 	if (tmp < max) {
 		ci = lock_cluster(si, tmp);
 		while (tmp < max) {
@@ -662,12 +660,13 @@ new_cluster:
 		unlock_cluster(ci);
 	}
 	if (tmp >= max) {
-		cluster_set_null(&cluster->index);
+		cluster->next = SWAP_NEXT_INVALID;
 		goto new_cluster;
 	}
-	cluster->next = tmp + 1;
 	*offset = tmp;
 	*scan_base = tmp;
+	tmp += 1;
+	cluster->next = tmp < max ? tmp : SWAP_NEXT_INVALID;
 	return true;
 }
 
@@ -3163,8 +3162,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 		}
 		for_each_possible_cpu(cpu) {
 			struct percpu_cluster *cluster;
+
 			cluster = per_cpu_ptr(p->percpu_cluster, cpu);
-			cluster_set_null(&cluster->index);
+			cluster->next = SWAP_NEXT_INVALID;
 		}
 	} else {
 		atomic_inc(&nr_rotate_swap);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags.patch
mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache.patch
mm-swap-simplify-struct-percpu_cluster.patch
mm-swap-update-get_swap_pages-to-take-folio-order.patch
mm-swap-allow-storage-of-all-mthp-orders.patch
mm-vmscan-avoid-split-during-shrink_folio_list.patch
mm-madvise-avoid-split-during-madv_pageout-and-madv_cold.patch

