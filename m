Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC08F39DBCA
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 17:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165405; cv=none; b=q4/2MlwKXprqZWYVfupSrSIsKlmGiLi48habnCdCYQ75SHGkIWXKwE/vldLnKdCVeE7AM0gF3LNWH/ErYVZLjEjH2ojDnHXg9nbg6IHZ4GbOdMw2S1MpO29nw55yWxMK2ENNFuIdzaNjEEmsymR4Td6vht1suKtUCVc3+G53Mmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165405; c=relaxed/simple;
	bh=36jlDcFy23N9ZFgsd/Kj51gMBa84K7XZvMBGxRSeStc=;
	h=Date:To:From:Subject:Message-Id; b=QCR8HZaVBIE6SUVAfvHQsPKRs3j8WKlBjG7UwvIVHU1+WKZUIUFuoxZMx4RC4MVWNDfmtLAJQzbSX/mC4vpeL1MYmnNlKZ/dUAiPnpuq4vUHHaqoUQM1+gVZiiADAoHV+ty8mWbi0zghY6GAkA2XBo54tRLuF3MVkA3F18apmlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M6r/K8NI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M6r/K8NI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705FEC19423;
	Tue, 10 Mar 2026 17:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773165405;
	bh=36jlDcFy23N9ZFgsd/Kj51gMBa84K7XZvMBGxRSeStc=;
	h=Date:To:From:Subject:From;
	b=M6r/K8NIuNXS4dJWCcTShyjKl1RzBDYq5RqVJ4z0W/zormyo7T/E4PP1xXYH7zIiY
	 ribGIv3XpEXCgk9aEtJLvuZG7IAXNEv9pNs+S9bt0WHpOzuJnsGUnsDPg5luSj0Iql
	 OXPvQaA9uagGYhm+3BQpYRvvTdQtzxqpVK/dXyVU=
Date: Tue, 10 Mar 2026 10:56:44 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation.patch added to mm-new branch
Message-Id: <20260310175645.705FEC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: strengthen locking assertions and invariants in cluster allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm/swap: strengthen locking assertions and invariants in cluster allocation
Date: Tue, 10 Mar 2026 09:56:57 +0800

swap_cluster_alloc_table() requires several locks to be held by its
callers: ci->lock, the per-CPU swap_cluster lock, and, for non-solid-state
devices (non-SWP_SOLIDSTATE), the si->global_cluster_lock.

While most call paths (e.g., via cluster_alloc_swap_entry() or
alloc_swap_scan_list()) correctly acquire these locks before invocation,
the path through swap_reclaim_work() -> swap_reclaim_full_clusters() ->
isolate_lock_cluster() is distinct.  This path operates exclusively on
si->full_clusters, where the swap allocation tables are guaranteed to be
already allocated.  Consequently, isolate_lock_cluster() should never
trigger a call to swap_cluster_alloc_table() for these clusters.

Strengthen the locking and state assertions to formalize these invariants:

1. Add a lockdep_assert_held() for si->global_cluster_lock in
   swap_cluster_alloc_table() for non-SWP_SOLIDSTATE devices.
2. Reorder existing lockdep assertions in swap_cluster_alloc_table() to
   match the actual lock acquisition order (per-CPU lock, then global lock,
   then cluster lock).
3. Add a VM_WARN_ON_ONCE() in isolate_lock_cluster() to ensure that table
   allocations are only attempted for clusters being isolated from the
   free list. Attempting to allocate a table for a cluster from other
   lists (like the full list during reclaim) indicates a violation of
   subsystem invariants.

These changes ensure locking consistency and help catch potential
synchronization or logic issues during development.

Link: https://lkml.kernel.org/r/20260310015657.42395-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation
+++ a/mm/swapfile.c
@@ -498,8 +498,10 @@ swap_cluster_alloc_table(struct swap_inf
 	 * Only cluster isolation from the allocator does table allocation.
 	 * Swap allocator uses percpu clusters and holds the local lock.
 	 */
-	lockdep_assert_held(&ci->lock);
 	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
+	if (!(si->flags & SWP_SOLIDSTATE))
+		lockdep_assert_held(&si->global_cluster_lock);
+	lockdep_assert_held(&ci->lock);
 
 	/* The cluster must be free and was just isolated from the free list. */
 	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
@@ -600,6 +602,7 @@ static struct swap_cluster_info *isolate
 		struct swap_info_struct *si, struct list_head *list)
 {
 	struct swap_cluster_info *ci, *found = NULL;
+	u8 flags;
 
 	spin_lock(&si->lock);
 	list_for_each_entry(ci, list, list) {
@@ -612,6 +615,7 @@ static struct swap_cluster_info *isolate
 			  ci->flags != CLUSTER_FLAG_FULL);
 
 		list_del(&ci->list);
+		flags = ci->flags;
 		ci->flags = CLUSTER_FLAG_NONE;
 		found = ci;
 		break;
@@ -619,6 +623,9 @@ static struct swap_cluster_info *isolate
 	spin_unlock(&si->lock);
 
 	if (found && !cluster_table_is_alloced(found)) {
+		/* Table of non-free cluster must be allocated. */
+		VM_WARN_ON_ONCE(flags != CLUSTER_FLAG_FREE);
+
 		/* Only an empty free cluster's swap table can be freed. */
 		VM_WARN_ON_ONCE(list != &si->free_clusters);
 		VM_WARN_ON_ONCE(!cluster_is_empty(found));
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation.patch

