Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A426017E4
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 00:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757118459; cv=none; b=k3Rp2gShdbsshQeZPSBqwLW0fkUuqSUQIVWoABDkgeukRZR/9K2Z8IJLBf8BoRjuWozkCgRwfhAETfnpQZDgFOiXV96fZqG8gTriV2FeVoGq6kNEA5AUVRI1Xj2K0/F1IdTImLvrH5JljQLPZyvJPI609rSeUCEGyh7r+w37bng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757118459; c=relaxed/simple;
	bh=JpD4e9QuVu9mGmu7kUB1U7IWvw6pyQg2dG8SwbyAtgk=;
	h=Date:To:From:Subject:Message-Id; b=dJHQ5A5j5k6Pch4anHmJBJtsjktk/CrEk+KvGF80JHNJupCrYggUxto2YzDX/ux+d/J0o5MNrP24/tEzoj/1w5D+tfgvdQoSRl5tpjHYEw2q8GBjLfQBnziKLFt06yqI+Z314jpkIM1AUnBst6nUdY4w6WXOwmrr1WodFXfPvEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zxxqFiV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zxxqFiV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A318C4CEF1;
	Sat,  6 Sep 2025 00:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757118459;
	bh=JpD4e9QuVu9mGmu7kUB1U7IWvw6pyQg2dG8SwbyAtgk=;
	h=Date:To:From:Subject:From;
	b=zxxqFiV65/UiUREVKhKiKlh3aGOlsy6X5fLdXknLje+fb7VaxtbasPSiowv6v+GNu
	 Tdjn4+mjwSGRYLdUNUBIg2iQN0UNAnkLke2s7auWFf8iHsZn1/0AmbIMiGgRdZqD8k
	 VcTgKlVka8CFZwTBw02OPWeBSETccPECrLRglGwM=
Date: Fri, 05 Sep 2025 17:27:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch added to mm-new branch
Message-Id: <20250906002739.6A318C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: use a single page for swap table when the size fits
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm, swap: use a single page for swap table when the size fits
Date: Sat, 6 Sep 2025 03:13:57 +0800

We have a cluster size of 512 slots.  Each slot consumes 8 bytes in swap
table so the swap table size of each cluster is exactly one page (4K).

If that condition is true, allocate one page direct and disable the slab
cache to reduce the memory usage of swap table and avoid fragmentation.

Link: https://lkml.kernel.org/r/20250905191357.78298-16-ryncsn@gmail.com
Co-developed-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_table.h |    2 +
 mm/swapfile.c   |   50 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 9 deletions(-)

--- a/mm/swapfile.c~mm-swap-use-a-single-page-for-swap-table-when-the-size-fits
+++ a/mm/swapfile.c
@@ -430,6 +430,38 @@ static inline unsigned int cluster_offse
 	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
 }
 
+static struct swap_table *swap_table_alloc(gfp_t gfp)
+{
+	struct folio *folio;
+
+	if (!SWP_TABLE_USE_PAGE)
+		return kmem_cache_zalloc(swap_table_cachep, gfp);
+
+	folio = folio_alloc(gfp | __GFP_ZERO, 0);
+	if (folio)
+		return folio_address(folio);
+	return NULL;
+}
+
+static void swap_table_free_folio_rcu_cb(struct rcu_head *head)
+{
+	struct folio *folio;
+
+	folio = page_folio(container_of(head, struct page, rcu_head));
+	folio_put(folio);
+}
+
+static void swap_table_free(struct swap_table *table)
+{
+	if (!SWP_TABLE_USE_PAGE) {
+		kmem_cache_free(swap_table_cachep, table);
+		return;
+	}
+
+	call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
+		 swap_table_free_folio_rcu_cb);
+}
+
 static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
 	unsigned int ci_off;
@@ -443,7 +475,7 @@ static void swap_cluster_free_table(stru
 	table = (void *)rcu_dereference_protected(ci->table, true);
 	rcu_assign_pointer(ci->table, NULL);
 
-	kmem_cache_free(swap_table_cachep, table);
+	swap_table_free(table);
 }
 
 /*
@@ -467,8 +499,7 @@ swap_cluster_alloc_table(struct swap_inf
 	lockdep_assert_held(&ci->lock);
 	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
 
-	table = kmem_cache_zalloc(swap_table_cachep,
-				  __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
 	if (table) {
 		rcu_assign_pointer(ci->table, table);
 		return ci;
@@ -483,7 +514,7 @@ swap_cluster_alloc_table(struct swap_inf
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
-	table = kmem_cache_zalloc(swap_table_cachep, __GFP_HIGH | GFP_KERNEL);
+	table = swap_table_alloc(__GFP_HIGH | GFP_KERNEL);
 
 	local_lock(&percpu_swap_cluster.lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
@@ -520,7 +551,7 @@ swap_cluster_alloc_table(struct swap_inf
 
 free_table:
 	if (table)
-		kmem_cache_free(swap_table_cachep, table);
+		swap_table_free(table);
 	return ci;
 }
 
@@ -738,7 +769,7 @@ static int inc_cluster_info_page(struct
 
 	ci = cluster_info + idx;
 	if (!ci->table) {
-		table = kmem_cache_zalloc(swap_table_cachep, GFP_KERNEL);
+		table = swap_table_alloc(GFP_KERNEL);
 		if (!table)
 			return -ENOMEM;
 		rcu_assign_pointer(ci->table, table);
@@ -4075,9 +4106,10 @@ static int __init swapfile_init(void)
 	 * only, and all swap cache readers (swap_cache_*) verifies
 	 * the content before use. So it's safe to use RCU slab here.
 	 */
-	swap_table_cachep = kmem_cache_create("swap_table",
-			    sizeof(struct swap_table),
-			    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
+	if (!SWP_TABLE_USE_PAGE)
+		swap_table_cachep = kmem_cache_create("swap_table",
+				    sizeof(struct swap_table),
+				    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
 
 #ifdef CONFIG_MIGRATION
 	if (swapfile_maximum_size >= (1UL << SWP_MIG_TOTAL_BITS))
--- a/mm/swap_table.h~mm-swap-use-a-single-page-for-swap-table-when-the-size-fits
+++ a/mm/swap_table.h
@@ -11,6 +11,8 @@ struct swap_table {
 	atomic_long_t entries[SWAPFILE_CLUSTER];
 };
 
+#define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
+
 /*
  * A swap table entry represents the status of a swap slot on a swap
  * (physical or virtual) device. The swap table in each cluster is a
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-only-scan-one-cluster-in-fragment-list.patch
mm-swap-remove-fragment-clusters-counter.patch
mm-swap-prefer-nonfull-over-free-clusters.patch
mm-mincore-swap-consolidate-swap-cache-checking-for-mincore.patch
mm-mincore-use-a-helper-for-checking-the-swap-cache.patch
mm-page-writeback-drop-usage-of-folio_index.patch
mm-swap-use-unified-helper-for-swap-cache-look-up.patch
mm-swap-fix-swap-cahe-index-error-when-retrying-reclaim.patch
mm-swap-check-page-poison-flag-after-locking-it.patch
mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch
mm-swap-rename-and-move-some-swap-cluster-definition-and-helpers.patch
mm-swap-tidy-up-swap-device-and-cluster-info-helpers.patch
mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch
mm-swap-cleanup-swap-cache-api-and-add-kerneldoc.patch
mm-swap-wrap-swap-cache-replacement-with-a-helper.patch
mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api.patch
mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch
mm-swap-remove-contention-workaround-for-swap-cache.patch
mm-swap-implement-dynamic-allocation-of-swap-table.patch
mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch

