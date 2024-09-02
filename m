Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7684D8BC
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247732; cv=none; b=YoV13gIbH4p6bHk3AfE+SFbK5hUIFqv4GtAnMNXKd0KH9csVCxXBwq49p8a1w1NJ201Wg4lGlk34yuNWrHXrXOqNFHqi9owm6Ry9RTSzHsn/ZB5ibjh3KOuvQi9QFqQ7tQz0NVDDu0VbNeWGaN8SSE6p3ogoRZ65j0rMrpl9Qa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247732; c=relaxed/simple;
	bh=3N63zZjueHjVWJa4MRM3BjU54iUMRUxL5HTWy4FKuVg=;
	h=Date:To:From:Subject:Message-Id; b=SbuAkxNcTMEt3zJTv2qvqzCdLBW3/b+33LmS0W6DqvPAAzhhPi0Of+z806p4T5+kbcBOVWIqcbmmbF6h3LiAJYAOToI0KMVdWdcj/6bR1hhNXIlwxNdh0xvU1b/vYFt/oqSTK8nNvWlOWjCIcel7U8wW+man0vSn76FEGVnx0yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0JvfKSBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0JvfKSBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E7FC4CEC2;
	Mon,  2 Sep 2024 03:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247732;
	bh=3N63zZjueHjVWJa4MRM3BjU54iUMRUxL5HTWy4FKuVg=;
	h=Date:To:From:Subject:From;
	b=0JvfKSBdrZ2RuRM9hkts9CFfqJKK8oCY7cTFVRvFhDXw489Qmw6i4lyF/RMWZ1pKa
	 mFYbvkNm2HoSEmrRZtQcceh0cXpYpis/cYj62LnevQYbqEIC6ORxAgo2RRyTHjZ7go
	 GeDZRGD8O9+bwC6fSzrCVO8P6U6p/sQibRC2cFrQ=
Date: Sun, 01 Sep 2024 20:28:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kasong@tencent.com,cerasuolodomenico@gmail.com,liuzhaoyu.zackary@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-allocate-folio-only-first-time-in-__read_swap_cache_async.patch removed from -mm tree
Message-Id: <20240902032851.E3E7FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: allocate folio only first time in __read_swap_cache_async()
has been removed from the -mm tree.  Its filename was
     mm-swap-allocate-folio-only-first-time-in-__read_swap_cache_async.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhaoyu Liu <liuzhaoyu.zackary@bytedance.com>
Subject: mm: swap: allocate folio only first time in __read_swap_cache_async()
Date: Wed, 31 Jul 2024 21:31:01 +0800

It should be checked by filemap_get_folio() if SWAP_HAS_CACHE was
marked while reading a share swap page. It would re-allocate a folio
if the swap cache was not ready now. We save the new folio to avoid
page allocating again.

Link: https://lkml.kernel.org/r/20240731133101.GA2096752@bytedance
Signed-off-by: Zhaoyu Liu <liuzhaoyu.zackary@bytedance.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   60 ++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

--- a/mm/swap_state.c~mm-swap-allocate-folio-only-first-time-in-__read_swap_cache_async
+++ a/mm/swap_state.c
@@ -435,6 +435,8 @@ struct folio *__read_swap_cache_async(sw
 {
 	struct swap_info_struct *si;
 	struct folio *folio;
+	struct folio *new_folio = NULL;
+	struct folio *result = NULL;
 	void *shadow = NULL;
 
 	*new_page_allocated = false;
@@ -463,16 +465,19 @@ struct folio *__read_swap_cache_async(sw
 		 * else swap_off will be aborted if we return NULL.
 		 */
 		if (!swap_swapcount(si, entry) && swap_slot_cache_enabled)
-			goto fail_put_swap;
+			goto put_and_return;
 
 		/*
-		 * Get a new folio to read into from swap.  Allocate it now,
-		 * before marking swap_map SWAP_HAS_CACHE, when -EEXIST will
-		 * cause any racers to loop around until we add it to cache.
-		 */
-		folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
-		if (!folio)
-                        goto fail_put_swap;
+		 * Get a new folio to read into from swap.  Allocate it now if
+		 * new_folio not exist, before marking swap_map SWAP_HAS_CACHE,
+		 * when -EEXIST will cause any racers to loop around until we
+		 * add it to cache.
+		 */
+		if (!new_folio) {
+			new_folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
+			if (!new_folio)
+				goto put_and_return;
+		}
 
 		/*
 		 * Swap entry may have been freed since our caller observed it.
@@ -480,10 +485,8 @@ struct folio *__read_swap_cache_async(sw
 		err = swapcache_prepare(entry, 1);
 		if (!err)
 			break;
-
-		folio_put(folio);
-		if (err != -EEXIST)
-			goto fail_put_swap;
+		else if (err != -EEXIST)
+			goto put_and_return;
 
 		/*
 		 * Protect against a recursive call to __read_swap_cache_async()
@@ -494,7 +497,7 @@ struct folio *__read_swap_cache_async(sw
 		 * __read_swap_cache_async() in the writeback path.
 		 */
 		if (skip_if_exists)
-			goto fail_put_swap;
+			goto put_and_return;
 
 		/*
 		 * We might race against __delete_from_swap_cache(), and
@@ -509,36 +512,37 @@ struct folio *__read_swap_cache_async(sw
 	/*
 	 * The swap entry is ours to swap in. Prepare the new folio.
 	 */
+	__folio_set_locked(new_folio);
+	__folio_set_swapbacked(new_folio);
 
-	__folio_set_locked(folio);
-	__folio_set_swapbacked(folio);
-
-	if (mem_cgroup_swapin_charge_folio(folio, NULL, gfp_mask, entry))
+	if (mem_cgroup_swapin_charge_folio(new_folio, NULL, gfp_mask, entry))
 		goto fail_unlock;
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (add_to_swap_cache(folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
+	if (add_to_swap_cache(new_folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
 		goto fail_unlock;
 
 	mem_cgroup_swapin_uncharge_swap(entry);
 
 	if (shadow)
-		workingset_refault(folio, shadow);
+		workingset_refault(new_folio, shadow);
 
-	/* Caller will initiate read into locked folio */
-	folio_add_lru(folio);
+	/* Caller will initiate read into locked new_folio */
+	folio_add_lru(new_folio);
 	*new_page_allocated = true;
+	folio = new_folio;
 got_folio:
-	put_swap_device(si);
-	return folio;
+	result = folio;
+	goto put_and_return;
 
 fail_unlock:
-	put_swap_folio(folio, entry);
-	folio_unlock(folio);
-	folio_put(folio);
-fail_put_swap:
+	put_swap_folio(new_folio, entry);
+	folio_unlock(new_folio);
+put_and_return:
 	put_swap_device(si);
-	return NULL;
+	if (!(*new_page_allocated) && new_folio)
+		folio_put(new_folio);
+	return result;
 }
 
 /*
_

Patches currently in -mm which might be from liuzhaoyu.zackary@bytedance.com are


