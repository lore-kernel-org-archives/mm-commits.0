Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D344842C518
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 06:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525615; cv=none; b=GkikQRoOY3M56VruIFKF9zj1XSeFLxM2Has9npm9xMTkQ2mj++7u7pLXdXdt5JHOg3W4c7//ZMNr1R8NN0auHAXhmEXyrVR1NDhJc1NzHsPTsqHJxMaPWRNXWNdccXRHHk+3nJBQ0MczPzbnfi+gC0BLAiNPU9EtjS/5rab+C1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525615; c=relaxed/simple;
	bh=01h1hqqzqYkuBBe0zG/PQVX4ysTubolimSN58TCl1Uo=;
	h=Date:To:From:Subject:Message-Id; b=t7wMnO1vDEtwL57+y+bj3CYJJiSHusLjfbbxiYvC91ZTEWMhpFAj4yWnWrjPHSzCZ0CY4Qoudx8CpCf5+UB1s8keeE2DUmCL8Wb1kARP+skfByjKaMccroQ19rbRmyG5bZtK5wtl2ytkpdSwrCMiW5ojfm1fo1FM3IUsxuqHpGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rIVRu4j8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rIVRu4j8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53A81F000FF;
	Fri,  9 Oct 2026 06:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525613;
	bh=bzTj9tf7eijO66zPfMT/PhD/7QJT9H2Xxc9LcGkp2Sg=;
	h=Date:To:From:Subject;
	b=rIVRu4j87r6KeXmDJFbyCn5vcjimDMsHxezM6K3I8nFCeaNUJvT8olhtApsSAhVSq
	 KxJ9q7p6vQFPqX3PvKyIQ9LheDv3xLSXI6ya5zwbyAJcmNmDjsibn0E8LzyAZ5HxpB
	 z/hUrflwDh/WSbMdypdQ46MszQG2WBHD8o+0PYpQ=
Date: Thu, 08 Oct 2026 23:00:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,yeoreum.yun@arm.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shivamkalra98@zohomail.in,shikemeng@huaweicloud.com,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,nphamcs@gmail.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split.patch removed from -mm tree
Message-Id: <20261009060013.A53A81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: clean up after-split folio freeing in __folio_split
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: clean up after-split folio freeing in __folio_split
Date: Wed, 23 Sep 2026 23:32:46 +0200

Replace free_folio_and_swap_cache() with an explicit folio_free_swap() and
folio_put() in the after-split loop.  free_folio_and_swap_cache() must
trylock it again and re-check folio_mapped() before freeing the swap cache
entries.  If the trylock loses a race, the entries are left behind even
though the folio reference is dropped.

The sub folios are still locked here, so just directly call
folio_free_swap() under the lock if it's unmapped, then unlock and drop
the reference.  This makes the swap cache freeing deterministic and the
reference drop explicit.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-15-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split
+++ a/mm/huge_memory.c
@@ -4325,7 +4325,8 @@ static int __folio_split(struct folio *f
 		struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
-	bool is_anon = folio_test_anon(folio);
+	const bool is_anon = folio_test_anon(folio);
+	const bool is_swapcache = folio_test_swapcache(folio);
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4365,14 +4366,16 @@ static int __folio_split(struct folio *f
 		if (new_folio == page_folio(lock_at))
 			continue;
 
-		folio_unlock(new_folio);
 		/*
 		 * Subpages whose mapping has been zapped may be freed
 		 * earlier, but freeing them requires taking the
-		 * lru_lock, so we defer put_page() on tail pages until
+		 * lru_lock, so we defer folio_put() on tail pages until
 		 * after the split completes.
 		 */
-		free_folio_and_swap_cache(new_folio);
+		if (is_swapcache && !folio_mapped(new_folio))
+			folio_free_swap(new_folio);
+		folio_unlock(new_folio);
+		folio_put(new_folio);
 	}
 
 out:
@@ -4399,7 +4402,7 @@ out:
  * isolated from LRU (if applicable)
  *
  * Upon return, the folio is not remapped, split folios are not added to LRU,
- * free_folio_and_swap_cache() is not called, and new folios remain locked.
+ * folio_free_swap() is not called, and new folios remain locked.
  *
  * Return: 0 on success, -EAGAIN if the folio cannot be split (e.g., due to
  *         insufficient reference count or extra pins).
_

Patches currently in -mm which might be from kasong@tencent.com are


