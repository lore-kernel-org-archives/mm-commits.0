Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A838061B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104140; cv=none; b=jcPkGovxQv6BkJWAsIuutU0Kem07rM73J2nV9mc0wnVVQeacAnayqBC76VovSdAHcQ1I24/0vvphEeXe7Sk4aV3FKEOpqwpNvihZZORyUn4dYbcw8D+1JBpMnWCAOrvF5FY8P5SWcM5OecECYIX4mQc9epJ++9n7YaU02A5BreQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104140; c=relaxed/simple;
	bh=umjNJxDUCB+JWpq2GULtpC5FjlCAMJHIRh0p2BFHhNA=;
	h=Date:To:From:Subject:Message-Id; b=gEyDfGUOJgiofjpzyq4pkcmBx4vl44gW0EJl2flCAAGXgPkQTXLiY0gMkrYOs0PGnnsKjgtRyDcTeCXVqTfZnrhr3gu0A5AXOCgPBnvvKsoE+kFAxP3g/TpIIJk7CkUh78VHHxOgUmyMiM75irgJ+bMSIOFd5oiJ5iURVIOa/w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jx1WxB1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jx1WxB1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C993EC113CD;
	Fri, 26 Apr 2024 04:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104139;
	bh=umjNJxDUCB+JWpq2GULtpC5FjlCAMJHIRh0p2BFHhNA=;
	h=Date:To:From:Subject:From;
	b=jx1WxB1aaO01TYDw2oAoy7D4jXUef5nHsbCZueAGO2JCDtJkb6lK1gUyms2wEL90E
	 0edcdBqxv2qS3rGhcXI/P4bpe/OnUjYRQqjhendIDDN41FriSHvlujEEeyLg12zYHq
	 77944/05VWkanNHHAMDIwkhGtlOUHbadRKfbli6E=
Date: Thu, 25 Apr 2024 21:02:19 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,mhocko@suse.com,ioworker0@gmail.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-simplify-struct-percpu_cluster.patch removed from -mm tree
Message-Id: <20240426040219.C993EC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: simplify struct percpu_cluster
has been removed from the -mm tree.  Its filename was
     mm-swap-simplify-struct-percpu_cluster.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch
mm-fix-race-between-__split_huge_pmd_locked-and-gup-fast.patch

