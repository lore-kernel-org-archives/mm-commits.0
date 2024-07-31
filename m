Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53D545023
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 19:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722455673; cv=none; b=TRa5pjaD/ml6n2P3Rc2df1ws0Rd3yfCv4KNL3mni2530RpVyaHwrYZw6r81F0ZY6ZIK+58xYeFfG9l4Okucv9SmetwT8HjNnxpQwxN0JULaWW2WIn3A9ffgeO3m3dhmQEQx8lNenKz56lifZ0fYwkcxm/KQzQp0U5hjjTit+PNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722455673; c=relaxed/simple;
	bh=/s130KRwKskuK939M7FbmkyK4PndKHlLvc0Do57BYOI=;
	h=Date:To:From:Subject:Message-Id; b=pVueukZ3remmogNz6KF/UfEpsXxZBh7tpbD42Vq36kcoe8Bu8tkziaUc+LBopaJU+FKM2qIa2wvTOStpQNZKEuD3pZY9fy1NuyIZqhxIMIFN051orNdIiU6jDxw4r4/z2DNWCdqW18L4m15YjclCQI8t06Uau5y18jMmWep51ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WZKqNtvs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WZKqNtvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DCAC116B1;
	Wed, 31 Jul 2024 19:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722455673;
	bh=/s130KRwKskuK939M7FbmkyK4PndKHlLvc0Do57BYOI=;
	h=Date:To:From:Subject:From;
	b=WZKqNtvsfMVxI6B6KrKo0ivqT4gB/6+GLJ2kYowpg39OxzaCi3f5quwidQfMLJjgI
	 Zr1kGBn5xZR0V+/35Hc1230RKh7PwIJZUlzUMvREbWeFnCGD7anjOQbNaoqGmDflr4
	 UqokOmAIcHS0fHvIyyiGZPwK+HxN8Dld4Putye+Y=
Date: Wed, 31 Jul 2024 12:54:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kasong@tencent.com,cerasuolodomenico@gmail.com,liuzhaoyu.zackary@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-allocate-folio-only-first-time-in-__read_swap_cache_async.patch added to mm-unstable branch
Message-Id: <20240731195433.20DCAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: allocate folio only first time in __read_swap_cache_async()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-allocate-folio-only-first-time-in-__read_swap_cache_async.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-allocate-folio-only-first-time-in-__read_swap_cache_async.patch

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

mm-swap-allocate-folio-only-first-time-in-__read_swap_cache_async.patch

