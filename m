Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABB421D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489954; cv=none; b=gu5dNQivEmWkSxYi4Jg+ReZ2ytkSm9PNvYMZer2wrtUxDgaV3HszyfJ/JNPoiVycOOyOq8+QeYjCZYSftDhwtjQ/JSvvsJa2EbJzTsy4HKEHhOOSokLdNbW/iBKdLA0YXZO1NbaOD1VD5ne5BJhg+sMu/XJDFdLNA0f87Vdi6ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489954; c=relaxed/simple;
	bh=GIQGBypa9vaKfnMh95gSpi2oJ82w1QDfTOKyQE+/Zi0=;
	h=Date:To:From:Subject:Message-Id; b=rNoddNIafqE3GMq0qQ+aPIOjBqxtMj4cAAb/fYmgh1uSaIS4SAFpxd78bkSsY0CvCYKx+yMJkSujcfRu/eN5Mr5tfGfCMuN5fuxhHb5cWW3fr/ye10IJnm44jfTgME/F6WuYfRy6C4BV3uq0CvlS4AZmcpZ8kXfw4mkDt0DP/Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qExHnMpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qExHnMpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC880C4CEE7;
	Sun, 21 Sep 2025 21:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489953;
	bh=GIQGBypa9vaKfnMh95gSpi2oJ82w1QDfTOKyQE+/Zi0=;
	h=Date:To:From:Subject:From;
	b=qExHnMpdxodNyt0zjj+jkbOyQLsfkG9YmgCCmloIIo9G3RXIx/OsGNZA8ZpqmuSSe
	 P/ddYeIGXIRi7iSYYSjxfaz4nGn8MfDKGRIHCVtiGPF0KYRuyCc03TfCrBIn1l8h0h
	 QmJP194E0oqigzcKVPr+JA213FBO+gO9W8VxECsk=
Date: Sun, 21 Sep 2025 14:25:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,sj@kernel.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch removed from -mm tree
Message-Id: <20250921212553.CC880C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: use a single page for swap table when the size fits
has been removed from the -mm tree.  Its filename was
     mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: use a single page for swap table when the size fits
Date: Wed, 17 Sep 2025 00:01:00 +0800

We have a cluster size of 512 slots.  Each slot consumes 8 bytes in swap
table so the swap table size of each cluster is exactly one page (4K).

If that condition is true, allocate one page direct and disable the slab
cache to reduce the memory usage of swap table and avoid fragmentation.

Link: https://lkml.kernel.org/r/20250916160100.31545-16-ryncsn@gmail.com
Co-developed-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Suggested-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
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
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_table.h |    2 +
 mm/swapfile.c   |   51 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 43 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-swap-use-a-single-page-for-swap-table-when-the-size-fits
+++ a/mm/swapfile.c
@@ -434,6 +434,38 @@ static inline unsigned int cluster_offse
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
@@ -447,7 +479,7 @@ static void swap_cluster_free_table(stru
 	table = (void *)rcu_dereference_protected(ci->table, true);
 	rcu_assign_pointer(ci->table, NULL);
 
-	kmem_cache_free(swap_table_cachep, table);
+	swap_table_free(table);
 }
 
 /*
@@ -470,8 +502,7 @@ swap_cluster_alloc_table(struct swap_inf
 	/* The cluster must be free and was just isolated from the free list. */
 	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
 
-	table = kmem_cache_zalloc(swap_table_cachep,
-				  __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
 	if (table) {
 		rcu_assign_pointer(ci->table, table);
 		return ci;
@@ -487,8 +518,7 @@ swap_cluster_alloc_table(struct swap_inf
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	table = kmem_cache_zalloc(swap_table_cachep,
-				  __GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL);
+	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -506,7 +536,7 @@ swap_cluster_alloc_table(struct swap_inf
 	/* Nothing except this helper should touch a dangling empty cluster. */
 	if (WARN_ON_ONCE(cluster_table_is_alloced(ci))) {
 		if (table)
-			kmem_cache_free(swap_table_cachep, table);
+			swap_table_free(table);
 		return ci;
 	}
 
@@ -734,7 +764,7 @@ static int inc_cluster_info_page(struct
 
 	ci = cluster_info + idx;
 	if (!ci->table) {
-		table = kmem_cache_zalloc(swap_table_cachep, GFP_KERNEL);
+		table = swap_table_alloc(GFP_KERNEL);
 		if (!table)
 			return -ENOMEM;
 		rcu_assign_pointer(ci->table, table);
@@ -4072,9 +4102,10 @@ static int __init swapfile_init(void)
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


