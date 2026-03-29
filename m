Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26E919D093
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744864; cv=none; b=d7QcyZqOMd5TmWQWL8bTfWtCcUoW71dvPECsZ4EHF/wTIFvnh8spCD061oOJVf0d/uJu4/omXN5LVr3/s6R0OsCWkUgudbJTmoZj06dvpTiEosy0sddjXoiVNOW4YmRfkZlvwuHawkRgMG+tGRZiTbWSvUnIsUxbwk7m9yVM69U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744864; c=relaxed/simple;
	bh=NLj0WqKF7P2Koul68p1+QIYm1e0C1CPVOqdTnl0aAFk=;
	h=Date:To:From:Subject:Message-Id; b=Q9CK2Ap9Y6mFNp7tbx3NLt0dLMc66PUIUXmjUwbF1/oK4nGER0Cw9Q5V5ieSBml0CcOgts1OoliZyglNWWc2r1/q6fcftI3KAIWG8KaafWcvT5j7qiTA7ECBoyS/JV8FK0dHE4m/7LkWjqSLyp2P7pKHiQnvj5hsv1mY3eo7GUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C1ccIix9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C1ccIix9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B50DC4CEF7;
	Sun, 29 Mar 2026 00:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744864;
	bh=NLj0WqKF7P2Koul68p1+QIYm1e0C1CPVOqdTnl0aAFk=;
	h=Date:To:From:Subject:From;
	b=C1ccIix9cpKXGF9lcBQAmWlg0hLVtKleC3vTDmjN6OtImZCpAew1wKIHWK66G9crq
	 8AeDS9/CR/Seryr0FyaWVL5NrBAWDbizOO8lRFDzpUqbQ+RCkyY8d6ye0ImBxoo8Ee
	 2rHkDrK94ocrPsajU+9ZKtfME7la6qZGyZgCkaAw=
Date: Sat, 28 Mar 2026 17:41:04 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation.patch removed from -mm tree
Message-Id: <20260329004104.9B50DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: strengthen locking assertions and invariants in cluster allocation
has been removed from the -mm tree.  Its filename was
     mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[zhuhui@kylinos.cn: remove redundant comment, per Barry]
  Link: https://lkml.kernel.org/r/20260311022241.177801-1-hui.zhu@linux.dev
[zhuhui@kylinos.cn: initialize `flags', per Chris]
  Link: https://lkml.kernel.org/r/20260312023024.903143-1-hui.zhu@linux.dev
Link: https://lkml.kernel.org/r/20260310015657.42395-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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
+	u8 flags = CLUSTER_FLAG_NONE;
 
 	spin_lock(&si->lock);
 	list_for_each_entry(ci, list, list) {
@@ -612,6 +615,7 @@ static struct swap_cluster_info *isolate
 			  ci->flags != CLUSTER_FLAG_FULL);
 
 		list_del(&ci->list);
+		flags = ci->flags;
 		ci->flags = CLUSTER_FLAG_NONE;
 		found = ci;
 		break;
@@ -620,6 +624,7 @@ static struct swap_cluster_info *isolate
 
 	if (found && !cluster_table_is_alloced(found)) {
 		/* Only an empty free cluster's swap table can be freed. */
+		VM_WARN_ON_ONCE(flags != CLUSTER_FLAG_FREE);
 		VM_WARN_ON_ONCE(list != &si->free_clusters);
 		VM_WARN_ON_ONCE(!cluster_is_empty(found));
 		return swap_cluster_alloc_table(si, found);
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-memcontrol-batch-memcg-charging-in-__memcg_slab_post_alloc_hook.patch

