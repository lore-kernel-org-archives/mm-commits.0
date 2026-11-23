Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415101;
	b=UhRvgFlStlXGMSEYWzhs/3/+OJJFm+4RTDRwj8HonvP7jXdB/1Z+IBseLCtUQhLlzRgu
	 DtgXags4tOv/CBpSTY2Q20djbMf2F418BLs39ccByrNejxHSaS6X01Xe3bPTAFE4Htvvo
	 /IZUTs1IPkhBOC0ojCRO1cADuxWixkdOMcFANkUJwsnd1qnjF2ing8JiGRfvm7junpcBX
	 vfylZilI+1PJ+7betWf+YE0/R6kgLnoaukDjXtAn6OTKw/armt6zoVNcA9Gr9xTIUTmBT
	 26pRHchxhfFXZ7BmyGgipAR9MT98rexH1+1oltN8sF+n4IwFDEGMtD6IF155AOJ0Gyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415101;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3L5NkUscXtyv/koLmMqC0BtdfCTTEGe22PeEbGot8/w=;
	b=5oVcg4pHUI1kPVuuTT2TJ2ighqeWAjsCPGRqO6TbclnP3AMSDF72JQYvAzalXOG+Ygz2
	 cE+wmR/Xy6cJKvNvcsV/5x/PCuEhhlaWpcuv2oj/nGDqQGhR4m0B0MkXM1FeSM9iYmhBD
	 11+esCGa0YrfgiYzQboeQUZ3wkqKtbARjBm9S5NBlD5XzDbFiUdlTRdfZX63Ayhp/WO/g
	 4fgPeiurxtNwEKqn8CxVyCtru0/ocNV/YKTFbswckLi4b7MlN7UlKGjMOCj8E16iY39J/
	 /cyxCTw05f0IYOgC1BScZLsX9qh7OEXLE29aT48PmHL4GKy/W4pOMq82Ou2icY8fEQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UiuuBvak;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB758606A33E;
	Mon, 23 Nov 2026 06:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UiuuBvak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AACE1F0089E;
	Mon, 23 Nov 2026 06:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415100;
	bh=3L5NkUscXtyv/koLmMqC0BtdfCTTEGe22PeEbGot8/w=;
	h=Date:To:From:Subject;
	b=UiuuBvakDKs0SLBg3bJYEl1R4+g0IUD/j42TJ17UTtOLlqvoxl3kBmx6NPuaKpinV
	 ydv2ZtzznzBiWGgarhVU9wDMgbmoWom0Ss2ZAcfWoHGjXkn563mHO6W1Wfm2STSVuc
	 pXd2hdVeVHZFT1KeyGqoRH5DAmN30pOW8HJ91Sjo=
Date: Sun, 22 Nov 2026 22:25:00 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,youngjun.park@lge.com,
	willy@infradead.org,weixugc@google.com,stable@vger.kernel.org,
	shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,
	qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,
	hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,brauner@kernel.org,
	baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	axelrasmussen@google.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-publish-cluster-tables-after-reacquiring-allocator-locks.patch removed from -mm tree
Message-Id: <20261123062500.8AACE1F0089E@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/swap: publish cluster tables after reacquiring allocator locks
has been removed from the -mm tree.  Its filename was
     mm-swap-publish-cluster-tables-after-reacquiring-allocator-locks.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm/swap: publish cluster tables after reacquiring allocator locks
Date: Tue, 10 Nov 2026 07:14:06 -0800

Under memory pressure, swap_cluster_populate() can publish a table
while its locks are dropped for a sleeping allocation. A cached
allocator can consume and free that table before the populating
allocator resumes, leaving the resumed scan with a NULL table.

    CPU0                           CPU1
    alloc_swap_scan_list()
      isolate_lock_cluster()
        swap_cluster_populate()
          drop local/global/ci locks
          swap_cluster_alloc_table()
            rcu_assign_pointer(ci->table, table)
                                   folio_alloc_swap()
                                     swap_alloc_fast()
                                       alloc_swap_scan_cluster()
                                         __swap_cluster_alloc_entries()
                                     mem_cgroup_try_charge_swap()
                                       return -ENOMEM
                                     swap_cache_del_folio()
                                       __swap_cache_del_folio()
                                         __swap_cache_do_del_folio()
                                           __swap_cluster_free_entries()
                                             free_cluster()
                                               __free_cluster()
                                                 swap_cluster_free_table()
          reacquire local/global/ci locks
          return ci
      alloc_swap_scan_cluster()
        cluster_scan_range()
          __swap_table_get()  /* NULL table */

Keep the count table, cgroup table and zero bitmap private until
swap_cluster_alloc_table() restores all allocator locks. Install them
under the cluster lock and retain it through the scan. Initial bad-slot
setup takes only the cluster lock because the device is unpublished.

The allocator releases its locks before the sleeping allocation. A
reclaimer that dropped ci->lock earlier can then resume and put the
cluster back on the free list. Abandon installation if the list state
changes or a table appears, freeing only private allocations. Restore
locks on allocation failure too, so the caller can return a still-isolated
cluster to its free list.

Link: https://lore.kernel.org/20261110151407.789960-3-nphamcs@gmail.com
Link: https://lore.kernel.org/all/sashiko-outbox-181086@kernel.org/
Fixes: cdd77f84d966 ("mm, swap: consolidate cluster allocation helpers")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-181084@kernel.org/
Suggested-by: Kairui Song <ryncsn@gmail.com>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: <stable@vger.kernel.org>

 mm/swapfile.c |  106 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 74 insertions(+), 32 deletions(-)

--- a/mm/swapfile.c~mm-swap-publish-cluster-tables-after-reacquiring-allocator-locks
+++ a/mm/swapfile.c
@@ -449,15 +449,23 @@ static void swap_cluster_free_table(stru
 	swap_cluster_free_count_table(table);
 }
 
-static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
+/*
+ * Return with ci locked. An unlocked allocator also needs si's outer locks;
+ * initial bad-slot setup passes NULL because the device is not published.
+ */
+static int swap_cluster_alloc_table(struct swap_info_struct *si,
+				    struct swap_cluster_info *ci,
+				    gfp_t gfp, bool locked)
 {
 	struct swap_table *table = NULL;
+#ifdef CONFIG_MEMCG
+	struct swap_memcg_table *memcg_table = NULL;
+#endif
+#if !SWAP_TABLE_HAS_ZEROFLAG
+	unsigned long *zero_bitmap = NULL;
+#endif
 	struct folio *folio;
-
-	/* The cluster must be empty and not on any list during allocation. */
-	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
-	if (rcu_access_pointer(ci->table))
-		return 0;
+	int ret = -ENOMEM;
 
 	if (SWP_TABLE_USE_PAGE) {
 		folio = folio_alloc(gfp | __GFP_ZERO, 0);
@@ -467,27 +475,49 @@ static int swap_cluster_alloc_table(stru
 		table = kmem_cache_zalloc(swap_table_cachep, gfp);
 	}
 	if (!table)
-		return -ENOMEM;
+		goto lock;
 
 #ifdef CONFIG_MEMCG
 	if (!mem_cgroup_disabled()) {
-		VM_WARN_ON_ONCE(ci->memcg_table);
-		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
-		if (!ci->memcg_table) {
-			swap_cluster_free_count_table(table);
-			return -ENOMEM;
-		}
+		memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
+		if (!memcg_table)
+			goto lock;
 	}
 #endif
 
 #if !SWAP_TABLE_HAS_ZEROFLAG
-	VM_WARN_ON_ONCE(ci->zero_bitmap);
-	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
-	if (!ci->zero_bitmap) {
-		swap_cluster_free_table(ci);
-		swap_cluster_free_count_table(table);
-		return -ENOMEM;
+	zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
+	if (!zero_bitmap)
+		goto lock;
+#endif
+	ret = 0;
+
+lock:
+	if (!locked) {
+		if (si) {
+			local_lock(&percpu_swap_cluster.lock);
+			if (!(si->flags & SWP_SOLIDSTATE))
+				spin_lock(&si->global_cluster_lock);
+		}
+		spin_lock(&ci->lock);
 	}
+	lockdep_assert_held(&ci->lock);
+
+	/* A stale reclaimer may have returned the cluster to the free list. */
+	if (ci->flags != CLUSTER_FLAG_NONE || cluster_table_is_alloced(ci))
+		ret = -EAGAIN;
+	if (ret)
+		goto free;
+
+	/* The cluster must be empty and not on any list during allocation. */
+	VM_WARN_ON_ONCE(!cluster_is_empty(ci));
+#ifdef CONFIG_MEMCG
+	VM_WARN_ON_ONCE(ci->memcg_table);
+	ci->memcg_table = memcg_table;
+#endif
+#if !SWAP_TABLE_HAS_ZEROFLAG
+	VM_WARN_ON_ONCE(ci->zero_bitmap);
+	ci->zero_bitmap = zero_bitmap;
 #endif
 
 	/*
@@ -496,6 +526,17 @@ static int swap_cluster_alloc_table(stru
 	 */
 	rcu_assign_pointer(ci->table, table);
 	return 0;
+
+free:
+#ifdef CONFIG_MEMCG
+	kfree(memcg_table);
+#endif
+#if !SWAP_TABLE_HAS_ZEROFLAG
+	bitmap_free(zero_bitmap);
+#endif
+	if (table)
+		swap_cluster_free_count_table(table);
+	return ret;
 }
 
 /*
@@ -546,8 +587,8 @@ swap_cluster_populate(struct swap_info_s
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
 
-	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					  __GFP_NOWARN))
+	if (!swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					      __GFP_NOWARN, true))
 		return ci;
 
 	/*
@@ -560,8 +601,8 @@ swap_cluster_populate(struct swap_info_s
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					   GFP_KERNEL);
+	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					     GFP_KERNEL, false);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -571,13 +612,9 @@ swap_cluster_populate(struct swap_info_s
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	local_lock(&percpu_swap_cluster.lock);
-	if (!(si->flags & SWP_SOLIDSTATE))
-		spin_lock(&si->global_cluster_lock);
-	spin_lock(&ci->lock);
-
 	if (ret) {
-		move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
+		if (ret != -EAGAIN)
+			move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 		spin_unlock(&ci->lock);
 		return NULL;
 	}
@@ -825,9 +862,13 @@ static int swap_cluster_setup_bad_slot(s
 
 	ci = cluster_info + idx;
 	/* Need to allocate swap table first for initial bad slot marking. */
-	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
-		return -ENOMEM;
-	spin_lock(&ci->lock);
+	if (!ci->count) {
+		ret = swap_cluster_alloc_table(NULL, ci, GFP_KERNEL, false);
+		if (ret)
+			goto out;
+	} else {
+		spin_lock(&ci->lock);
+	}
 	/* Check for duplicated bad swap slots. */
 	if (__swap_table_xchg(ci, ci_off, SWP_TB_BAD) != SWP_TB_NULL) {
 		pr_warn("Duplicated bad slot offset %d\n", offset);
@@ -835,6 +876,7 @@ static int swap_cluster_setup_bad_slot(s
 	} else {
 		ci->count++;
 	}
+out:
 	spin_unlock(&ci->lock);
 
 	WARN_ON(ci->count > SWAPFILE_CLUSTER);
_

Patches currently in -mm which might be from nphamcs@gmail.com are


