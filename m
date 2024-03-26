Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D2E20B20;
	Tue, 26 Mar 2024 18:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476495; cv=none; b=hQwN8CyfZrQSddQUIxZOv8xggLLgf33gBnNL01tvL+FPIB+we3ErpmSJPRGPht4Jutpqb1VvHsdnTqJ3hpgfW8OwRp1V7pjFXOk/T1LrA696IRGsXTW3uYKhA2BUj3VejuCLH8oHqnlGMZu/0Hj31fQLEFljQWKaeEspfj/FYM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476495; c=relaxed/simple;
	bh=wOrGwxBRJqBWLjd21xQ45OtOdT+g/P18NdW7s+3Txhs=;
	h=Date:To:From:Subject:Message-Id; b=LL85GNz64DerXuxjqve2UJl7olhYYu67zJ4UW8IYPpGNhkUicXijsTlKz0pzXo0K6bX7qlXf90P2FAGm84nzKao0VsI0U0hOJRo8v6XkSnGUpcNY1s4+EW5zb7aQk1t5A5pKLCHDnHN+mpK6wK5miP1lyTX5/XCzhVAiIay2vA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FXh575WN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FXh575WN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F869C43390;
	Tue, 26 Mar 2024 18:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476494;
	bh=wOrGwxBRJqBWLjd21xQ45OtOdT+g/P18NdW7s+3Txhs=;
	h=Date:To:From:Subject:From;
	b=FXh575WN/bxPhmWPJKCU1MnyqCM14dHtfMJZgl5kLYfMzqtqpL+r4e5rMg1tnth9B
	 /4Khy6vCMpUXQXV3agCocxqoC8MCwQwJjMFYWPixKnJJByjnV2doIbzuycirRPxZem
	 xIDblMb9Ed4tVCapmPkqJvKxAewQVPmkIjKxsBqU=
Date: Tue, 26 Mar 2024 11:08:13 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nphamcs@gmail.com,jannh@google.com,chengming.zhou@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-cachestat-fix-two-shmem-bugs.patch removed from -mm tree
Message-Id: <20240326180814.6F869C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cachestat: fix two shmem bugs
has been removed from the -mm tree.  Its filename was
     mm-cachestat-fix-two-shmem-bugs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: cachestat: fix two shmem bugs
Date: Fri, 15 Mar 2024 05:55:56 -0400

When cachestat on shmem races with swapping and invalidation, there
are two possible bugs:

1) A swapin error can have resulted in a poisoned swap entry in the
   shmem inode's xarray. Calling get_shadow_from_swap_cache() on it
   will result in an out-of-bounds access to swapper_spaces[].

   Validate the entry with non_swap_entry() before going further.

2) When we find a valid swap entry in the shmem's inode, the shadow
   entry in the swapcache might not exist yet: swap IO is still in
   progress and we're before __remove_mapping; swapin, invalidation,
   or swapoff have removed the shadow from swapcache after we saw the
   shmem swap entry.

   This will send a NULL to workingset_test_recent(). The latter
   purely operates on pointer bits, so it won't crash - node 0, memcg
   ID 0, eviction timestamp 0, etc. are all valid inputs - but it's a
   bogus test. In theory that could result in a false "recently
   evicted" count.

   Such a false positive wouldn't be the end of the world. But for
   code clarity and (future) robustness, be explicit about this case.

   Bail on get_shadow_from_swap_cache() returning NULL.

Link: https://lkml.kernel.org/r/20240315095556.GC581298@cmpxchg.org
Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Chengming Zhou <chengming.zhou@linux.dev>	[Bug #1]
Reported-by: Jann Horn <jannh@google.com>		[Bug #2]
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>				[v6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/filemap.c~mm-cachestat-fix-two-shmem-bugs
+++ a/mm/filemap.c
@@ -4197,7 +4197,23 @@ static void filemap_cachestat(struct add
 				/* shmem file - in swap cache */
 				swp_entry_t swp = radix_to_swp_entry(folio);
 
+				/* swapin error results in poisoned entry */
+				if (non_swap_entry(swp))
+					goto resched;
+
+				/*
+				 * Getting a swap entry from the shmem
+				 * inode means we beat
+				 * shmem_unuse(). rcu_read_lock()
+				 * ensures swapoff waits for us before
+				 * freeing the swapper space. However,
+				 * we can race with swapping and
+				 * invalidation, so there might not be
+				 * a shadow in the swapcache (yet).
+				 */
 				shadow = get_shadow_from_swap_cache(swp);
+				if (!shadow)
+					goto resched;
 			}
 #endif
 			if (workingset_test_recent(shadow, true, &workingset))
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-optimize-zswap-pool-size-tracking.patch
mm-zpool-return-pool-size-in-pages.patch
mm-page_alloc-remove-pcppage-migratetype-caching.patch
mm-page_alloc-optimize-free_unref_folios.patch
mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch
mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch
mm-page_alloc-fix-move_freepages_block-range-error.patch
mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-close-migratetype-race-between-freeing-and-stealing.patch
mm-page_isolation-prepare-for-hygienic-freelists.patch
mm-page_isolation-prepare-for-hygienic-freelists-fix.patch
mm-page_alloc-consolidate-free-page-accounting.patch

