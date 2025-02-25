Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F51EB64A
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 03:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740454013; cv=none; b=ncGWz4v+UzZ8EkDkh1G7HhZnOveFo37lD7hKhMY8gsxTcLgIPc9RvQ/WkRozuBL3S1NvU8bPeZmz1mB1mM6sUgHmCQLA5+EK5mumAumQn7x8fJLti9vrAX63WNg2XN4CZaLwwxGMHJMvvUIqYkTB3Yxo031yrnHGZgWPLHJ+XV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740454013; c=relaxed/simple;
	bh=Ss2HOr21At7kKJjyUerjs3I90/L5FkIt4snE/ZmEKdw=;
	h=Date:To:From:Subject:Message-Id; b=dkm7Cxiv5+G/2bTyTj8uXIAVnzu4C/iMDoB11/P8pU4gzN2yG5o7l1UEx4Wyf+9DLr3F9pZu49/QuK4KG8D2XtapBQ4NatV7DmvO0kGQdu/UYlgh7dECAztJTFRFqvBulh1Wtks1z4Qoll+UiECma4hKZAHrQCOb62lfqf3zynM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZHb7y+zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZHb7y+zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4897C4CED6;
	Tue, 25 Feb 2025 03:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740454012;
	bh=Ss2HOr21At7kKJjyUerjs3I90/L5FkIt4snE/ZmEKdw=;
	h=Date:To:From:Subject:From;
	b=ZHb7y+zcK98rVz0sbTXQfCzQTYN/AkuVtvCxKY1kKODSU+0v+S0mBCTyas9ZFyRc/
	 iB7cB2rrP3j29V8do575U7Bk3S9JJ/Ppxl1URmGsFy4UXAT8+Sxpc78slUZSUdD+rY
	 qsEE2ReT/h7v7YAErYTp6xpzbxJGG85OYqydVr+o=
Date: Mon, 24 Feb 2025 19:26:52 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,v-songbaohua@oppo.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-simplify-folio-swap-allocation.patch added to mm-unstable branch
Message-Id: <20250225032652.A4897C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: simplify folio swap allocation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-simplify-folio-swap-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-simplify-folio-swap-allocation.patch

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
Subject: mm, swap: simplify folio swap allocation
Date: Tue, 25 Feb 2025 02:02:12 +0800

With slot cache gone, clean up the allocation helpers even more. 
folio_alloc_swap will be the only entry for allocation and adding the
folio to swap cache (except suspend), making it opposite of
folio_free_swap.

Link: https://lkml.kernel.org/r/20250224180212.22802-8-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    8 +-
 mm/shmem.c           |   21 ++-----
 mm/swap.h            |    6 --
 mm/swap_state.c      |   57 ---------------------
 mm/swapfile.c        |  110 ++++++++++++++++++++++++++---------------
 mm/vmscan.c          |   16 +++++
 6 files changed, 94 insertions(+), 124 deletions(-)

--- a/include/linux/swap.h~mm-swap-simplify-folio-swap-allocation
+++ a/include/linux/swap.h
@@ -478,7 +478,7 @@ static inline long get_nr_swap_pages(voi
 }
 
 extern void si_swapinfo(struct sysinfo *);
-swp_entry_t folio_alloc_swap(struct folio *folio);
+int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask);
 bool folio_free_swap(struct folio *folio);
 void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
@@ -587,11 +587,9 @@ static inline int swp_swapcount(swp_entr
 	return 0;
 }
 
-static inline swp_entry_t folio_alloc_swap(struct folio *folio)
+static int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask)
 {
-	swp_entry_t entry;
-	entry.val = 0;
-	return entry;
+	return -EINVAL;
 }
 
 static inline bool folio_free_swap(struct folio *folio)
--- a/mm/shmem.c~mm-swap-simplify-folio-swap-allocation
+++ a/mm/shmem.c
@@ -1546,7 +1546,6 @@ static int shmem_writepage(struct page *
 	struct inode *inode = mapping->host;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
-	swp_entry_t swap;
 	pgoff_t index;
 	int nr_pages;
 	bool split = false;
@@ -1628,14 +1627,6 @@ try_split:
 		folio_mark_uptodate(folio);
 	}
 
-	swap = folio_alloc_swap(folio);
-	if (!swap.val) {
-		if (nr_pages > 1)
-			goto try_split;
-
-		goto redirty;
-	}
-
 	/*
 	 * Add inode to shmem_unuse()'s list of swapped-out inodes,
 	 * if it's not already there.  Do it now before the folio is
@@ -1648,20 +1639,20 @@ try_split:
 	if (list_empty(&info->swaplist))
 		list_add(&info->swaplist, &shmem_swaplist);
 
-	if (add_to_swap_cache(folio, swap,
-			__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN,
-			NULL) == 0) {
+	if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
 		shmem_recalc_inode(inode, 0, nr_pages);
-		swap_shmem_alloc(swap, nr_pages);
-		shmem_delete_from_page_cache(folio, swp_to_radix_entry(swap));
+		swap_shmem_alloc(folio->swap, nr_pages);
+		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		mutex_unlock(&shmem_swaplist_mutex);
 		BUG_ON(folio_mapped(folio));
 		return swap_writepage(&folio->page, wbc);
 	}
 
+	list_del_init(&info->swaplist);
 	mutex_unlock(&shmem_swaplist_mutex);
-	put_swap_folio(folio, swap);
+	if (nr_pages > 1)
+		goto try_split;
 redirty:
 	folio_mark_dirty(folio);
 	if (wbc->for_reclaim)
--- a/mm/swapfile.c~mm-swap-simplify-folio-swap-allocation
+++ a/mm/swapfile.c
@@ -1174,9 +1174,9 @@ static bool get_swap_device_info(struct
  * Fast path try to get swap entries with specified order from current
  * CPU's swap entry pool (a cluster).
  */
-static int swap_alloc_fast(swp_entry_t *entry,
-			   unsigned char usage,
-			   int order)
+static bool swap_alloc_fast(swp_entry_t *entry,
+			    unsigned char usage,
+			    int order)
 {
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
@@ -1206,47 +1206,31 @@ static int swap_alloc_fast(swp_entry_t *
 	return !!found;
 }
 
-swp_entry_t folio_alloc_swap(struct folio *folio)
+/* Rotate the device and switch to a new cluster */
+static bool swap_alloc_slow(swp_entry_t *entry,
+			    unsigned char usage,
+			    int order)
 {
-	unsigned int order = folio_order(folio);
-	unsigned int size = 1 << order;
-	struct swap_info_struct *si, *next;
-	swp_entry_t entry = {};
-	unsigned long offset;
 	int node;
+	unsigned long offset;
+	struct swap_info_struct *si, *next;
 
-	if (order) {
-		/*
-		 * Should not even be attempting large allocations when huge
-		 * page swap is disabled. Warn and fail the allocation.
-		 */
-		if (!IS_ENABLED(CONFIG_THP_SWAP) || size > SWAPFILE_CLUSTER) {
-			VM_WARN_ON_ONCE(1);
-			return entry;
-		}
-	}
-
-	/* Fast path using percpu cluster */
-	local_lock(&percpu_swap_cluster.lock);
-	if (swap_alloc_fast(&entry, SWAP_HAS_CACHE, order))
-		goto out_alloced;
-
-	/* Rotate the device and switch to a new cluster */
+	node = numa_node_id();
 	spin_lock(&swap_avail_lock);
 start_over:
-	node = numa_node_id();
 	plist_for_each_entry_safe(si, next, &swap_avail_heads[node], avail_lists[node]) {
+		/* Rotate the device and switch to a new cluster */
 		plist_requeue(&si->avail_lists[node], &swap_avail_heads[node]);
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
 			offset = cluster_alloc_swap_entry(si, order, SWAP_HAS_CACHE);
 			put_swap_device(si);
 			if (offset) {
-				entry = swp_entry(si->type, offset);
-				goto out_alloced;
+				*entry = swp_entry(si->type, offset);
+				return true;
 			}
 			if (order)
-				goto out_failed;
+				return false;
 		}
 
 		spin_lock(&swap_avail_lock);
@@ -1265,20 +1249,68 @@ start_over:
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
-out_failed:
+	return false;
+}
+
+/**
+ * folio_alloc_swap - allocate swap space for a folio
+ * @folio: folio we want to move to swap
+ * @gfp: gfp mask for shadow nodes
+ *
+ * Allocate swap space for the folio and add the folio to the
+ * swap cache.
+ *
+ * Context: Caller needs to hold the folio lock.
+ * Return: Whether the folio was added to the swap cache.
+ */
+int folio_alloc_swap(struct folio *folio, gfp_t gfp)
+{
+	unsigned int order = folio_order(folio);
+	unsigned int size = 1 << order;
+	swp_entry_t entry = {};
+
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
+
+	/*
+	 * Should not even be attempting large allocations when huge
+	 * page swap is disabled. Warn and fail the allocation.
+	 */
+	if (order && (!IS_ENABLED(CONFIG_THP_SWAP) || size > SWAPFILE_CLUSTER)) {
+		VM_WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	local_lock(&percpu_swap_cluster.lock);
+	if (swap_alloc_fast(&entry, SWAP_HAS_CACHE, order))
+		goto out_alloced;
+	if (swap_alloc_slow(&entry, SWAP_HAS_CACHE, order))
+		goto out_alloced;
 	local_unlock(&percpu_swap_cluster.lock);
-	return entry;
+	return -ENOMEM;
 
 out_alloced:
 	local_unlock(&percpu_swap_cluster.lock);
-	if (mem_cgroup_try_charge_swap(folio, entry)) {
-		put_swap_folio(folio, entry);
-		entry.val = 0;
-	} else {
-		atomic_long_sub(size, &nr_swap_pages);
-	}
+	if (mem_cgroup_try_charge_swap(folio, entry))
+		goto out_free;
+
+	/*
+	 * XArray node allocations from PF_MEMALLOC contexts could
+	 * completely exhaust the page allocator. __GFP_NOMEMALLOC
+	 * stops emergency reserves from being allocated.
+	 *
+	 * TODO: this could cause a theoretical memory reclaim
+	 * deadlock in the swap out path.
+	 */
+	if (add_to_swap_cache(folio, entry, gfp | __GFP_NOMEMALLOC, NULL))
+		goto out_free;
+
+	atomic_long_sub(size, &nr_swap_pages);
+	return 0;
 
-	return entry;
+out_free:
+	put_swap_folio(folio, entry);
+	return -ENOMEM;
 }
 
 static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
--- a/mm/swap.h~mm-swap-simplify-folio-swap-allocation
+++ a/mm/swap.h
@@ -50,7 +50,6 @@ static inline pgoff_t swap_cache_index(s
 }
 
 void show_swap_cache_info(void);
-bool add_to_swap(struct folio *folio);
 void *get_shadow_from_swap_cache(swp_entry_t entry);
 int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
 		      gfp_t gfp, void **shadowp);
@@ -163,11 +162,6 @@ struct folio *filemap_get_incore_folio(s
 	return filemap_get_folio(mapping, index);
 }
 
-static inline bool add_to_swap(struct folio *folio)
-{
-	return false;
-}
-
 static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
 {
 	return NULL;
--- a/mm/swap_state.c~mm-swap-simplify-folio-swap-allocation
+++ a/mm/swap_state.c
@@ -166,63 +166,6 @@ void __delete_from_swap_cache(struct fol
 	__lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr);
 }
 
-/**
- * add_to_swap - allocate swap space for a folio
- * @folio: folio we want to move to swap
- *
- * Allocate swap space for the folio and add the folio to the
- * swap cache.
- *
- * Context: Caller needs to hold the folio lock.
- * Return: Whether the folio was added to the swap cache.
- */
-bool add_to_swap(struct folio *folio)
-{
-	swp_entry_t entry;
-	int err;
-
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
-
-	entry = folio_alloc_swap(folio);
-	if (!entry.val)
-		return false;
-
-	/*
-	 * XArray node allocations from PF_MEMALLOC contexts could
-	 * completely exhaust the page allocator. __GFP_NOMEMALLOC
-	 * stops emergency reserves from being allocated.
-	 *
-	 * TODO: this could cause a theoretical memory reclaim
-	 * deadlock in the swap out path.
-	 */
-	/*
-	 * Add it to the swap cache.
-	 */
-	err = add_to_swap_cache(folio, entry,
-			__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN, NULL);
-	if (err)
-		goto fail;
-	/*
-	 * Normally the folio will be dirtied in unmap because its
-	 * pte should be dirty. A special case is MADV_FREE page. The
-	 * page's pte could have dirty bit cleared but the folio's
-	 * SwapBacked flag is still set because clearing the dirty bit
-	 * and SwapBacked flag has no lock protected. For such folio,
-	 * unmap will not set dirty bit for it, so folio reclaim will
-	 * not write the folio out. This can cause data corruption when
-	 * the folio is swapped in later. Always setting the dirty flag
-	 * for the folio solves the problem.
-	 */
-	folio_mark_dirty(folio);
-
-	return true;
-
-fail:
-	put_swap_folio(folio, entry);
-	return false;
-}
-
 /*
  * This must be called only on folios that have
  * been verified to be in the swap cache and locked.
--- a/mm/vmscan.c~mm-swap-simplify-folio-swap-allocation
+++ a/mm/vmscan.c
@@ -1289,7 +1289,7 @@ retry:
 					    split_folio_to_list(folio, folio_list))
 						goto activate_locked;
 				}
-				if (!add_to_swap(folio)) {
+				if (folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOWARN)) {
 					int __maybe_unused order = folio_order(folio);
 
 					if (!folio_test_large(folio))
@@ -1305,9 +1305,21 @@ retry:
 					}
 #endif
 					count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
-					if (!add_to_swap(folio))
+					if (folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOWARN))
 						goto activate_locked_split;
 				}
+				/*
+				 * Normally the folio will be dirtied in unmap because its
+				 * pte should be dirty. A special case is MADV_FREE page. The
+				 * page's pte could have dirty bit cleared but the folio's
+				 * SwapBacked flag is still set because clearing the dirty bit
+				 * and SwapBacked flag has no lock protected. For such folio,
+				 * unmap will not set dirty bit for it, so folio reclaim will
+				 * not write the folio out. This can cause data corruption when
+				 * the folio is swapped in later. Always setting the dirty flag
+				 * for the folio solves the problem.
+				 */
+				folio_mark_dirty(folio);
 			}
 		}
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-avoid-reclaiming-irrelevant-swap-cache.patch
mm-swap-drop-the-flag-ttrs_direct.patch
mm-swap-avoid-redundant-swap-device-pinning.patch
mm-swap-dont-update-the-counter-up-front.patch
mm-swap-use-percpu-cluster-as-allocation-fast-path.patch
mm-swap-remove-swap-slot-cache.patch
mm-swap-simplify-folio-swap-allocation.patch

