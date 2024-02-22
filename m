Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763DE17577
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560198; cv=none; b=Mdi43EGevnRUk7kq6HWk93xVjAxysNQf3IpBeQnOau6ykkbqAuRdNyZUScYVgeTcQAK/syPDOdHBYSS7N7LjZqganZXfWdN4exkjtPIXnvFOaWjWBrzhDeFXsLOpGBMq+ho1VlKLx/Akca5M1g2AN8vEsUVRaLjQMXG6AOTZL4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560198; c=relaxed/simple;
	bh=wV5y3xGkVLaCOS2FUh3ffvop5E3hNGvQcYbACm6XYIc=;
	h=Date:To:From:Subject:Message-Id; b=N2gm0XprCOy8YPKZwK+JZzWs9mPPqb4vfWCHX7cJKQeXiThsNH8g0uIaQFOP8A1c7FNv/GMds7dgGgG75t1FTYl0S0LJtFySOgSS1R5eOm+B7JZU/DTgtHnAVzz7ir5DDZEKP3ufBgfLF/Z6q2VJzEm0tVKjTVN8kdXDcqmNE9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EIiWvw2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EIiWvw2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA53C433C7;
	Thu, 22 Feb 2024 00:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560196;
	bh=wV5y3xGkVLaCOS2FUh3ffvop5E3hNGvQcYbACm6XYIc=;
	h=Date:To:From:Subject:From;
	b=EIiWvw2bjNeY1kOlOERmRotD53P/7XIkQqBbndajNTdt/SL5JTEWOTA/PL3/BQ5HN
	 cQ9Eib7zWxr98ITaSC2wr2Pc7rcersSeOuuCDplzEGoS9lyR/117p4FDrO8Dpc97Ml
	 Hj1N9Lc3KOcI4mPHJgKIMtBTu5r7DwJWs3n/EexI=
Date: Wed, 21 Feb 2024 16:03:15 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch removed from -mm tree
Message-Id: <20240222000315.DFA53C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: stop lru list shrinking when encounter warm region
has been removed from the -mm tree.  Its filename was
     mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: stop lru list shrinking when encounter warm region
Date: Sun, 04 Feb 2024 03:06:01 +0000

When the shrinker encounter an existing folio in swap cache, it means we
are shrinking into the warmer region.  We should terminate shrinking if
we're in the dynamic shrinker context.

This patch add LRU_STOP to support this, to avoid overshrinking.

Link: https://lkml.kernel.org/r/20240201-b4-zswap-invalidate-entry-v2-3-99d4084260a0@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |    2 ++
 mm/list_lru.c            |    3 +++
 mm/zswap.c               |    4 +++-
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/list_lru.h~mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region
+++ a/include/linux/list_lru.h
@@ -24,6 +24,8 @@ enum lru_status {
 	LRU_SKIP,		/* item cannot be locked, skip */
 	LRU_RETRY,		/* item not freeable. May drop the lock
 				   internally, but has to return locked. */
+	LRU_STOP,		/* stop lru list walking. May drop the lock
+				   internally, but has to return locked. */
 };
 
 struct list_lru_one {
--- a/mm/list_lru.c~mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region
+++ a/mm/list_lru.c
@@ -243,6 +243,9 @@ restart:
 			 */
 			assert_spin_locked(&nlru->lock);
 			goto restart;
+		case LRU_STOP:
+			assert_spin_locked(&nlru->lock);
+			goto out;
 		default:
 			BUG();
 		}
--- a/mm/zswap.c~mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region
+++ a/mm/zswap.c
@@ -1315,8 +1315,10 @@ static enum lru_status shrink_memcg_cb(s
 		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
 		 * shrinker context).
 		 */
-		if (writeback_result == -EEXIST && encountered_page_in_swapcache)
+		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
+			ret = LRU_STOP;
 			*encountered_page_in_swapcache = true;
+		}
 	} else {
 		zswap_written_back_pages++;
 	}
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch
mm-zsmalloc-remove-migrate_write_lock_nested.patch
mm-zsmalloc-remove-unused-zspage-isolated.patch
mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch
mm-zsmalloc-remove-set_zspage_mapping.patch
mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch
mm-zsmalloc-remove-get_zspage_mapping.patch
maintainers-add-chengming-zhou-as-a-zswap-reviewer.patch

