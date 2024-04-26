Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83E47604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103969; cv=none; b=oeIqG5JH3mI1zUp4PmfxWhjIO9uUuULsVYdK9mlMIo9EWUImDngfczPi/Sj7bherA1oD2d9NmFhITxV/C+bGEe1twYBk3nAKO6psiPKAex/xWEx1BKewAdlwbuBaRRiTbguDHj55AHzNbAp1rLFwKZnyNfIZAubnsG8dD051okw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103969; c=relaxed/simple;
	bh=5bkjZfVqfg9g6mQvxDz7iwGol3Kc9lVOdJhH8CEOtow=;
	h=Date:To:From:Subject:Message-Id; b=AnTc0auszNwf+0g9WLZVlvdQK6zz0G4diYTxJQZjulnPXnbc5Xpirj3cjNUjaD2YviKlbIkB40A2hh01TrsJMPZ+nZr2qOkOeRc6yJfGB1qpp6R/M61Nx+qqeCuMNjqDm5H51tzQOerPOwo/9k0mvdYm4anuuZ1PKkPO583WUt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kxXt+UqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kxXt+UqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC72C116B1;
	Fri, 26 Apr 2024 03:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103968;
	bh=5bkjZfVqfg9g6mQvxDz7iwGol3Kc9lVOdJhH8CEOtow=;
	h=Date:To:From:Subject:From;
	b=kxXt+UqE1He+d2FLPT4KtXlPt3KJtqplfD6SgUbGgC0FeZq7G3anPgmpoDxmEuM60
	 dOa6+MxFuyXSNUmlXo9y0mwqizERiz4rmKjvbzl5BbxnZgftPTXaEKeOS+jjToDBY1
	 edtnn7mea01IFHuIrkl7PQ1ETYt9Gu8nTD1Nd6jg=
Date: Thu, 25 Apr 2024 20:59:28 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-remove-nr_zswap_stored-atomic.patch removed from -mm tree
Message-Id: <20240426035928.BEC72C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: remove nr_zswap_stored atomic
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-nr_zswap_stored-atomic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: remove nr_zswap_stored atomic
Date: Fri, 22 Mar 2024 00:10:01 +0000

nr_stored was introduced by commit b5ba474f3f51 ("zswap: shrink zswap pool
based on memory pressure") as a per zswap_pool counter of the number of
stored pages that are not same-filled pages.  It is used in
zswap_shrinker_count() to scale the number of freeable compressed pages by
the compression ratio.  That is, to reduce the amount of writeback from
zswap with higher compression ratios as the ROI from IO diminishes.

Later on, commit bf9b7df23cb3 ("mm/zswap: global lru and shrinker shared
by all zswap_pools") made the shrinker global (not per zswap_pool), and
replaced nr_stored with nr_zswap_stored (initially introduced as
zswap.nr_stored), which is now a global counter.

The counter is now awfully close to zswap_stored_pages.  The only
difference is that the latter also includes same-filled pages.  Also, when
memcgs are enabled, we use memcg_page_state(memcg, MEMCG_ZSWAPPED), which
includes same-filled pages anyway (i.e.  equivalent to
zswap_stored_pages).

Use zswap_stored_pages instead in zswap_shrinker_count() to keep things
consistent whether memcgs are enabled or not, and add a comment about the
number of freeable pages possibly being scaled down more than it should if
we have lots of same-filled pages (i.e.  inflated compression ratio).

Remove nr_zswap_stored and one atomic operation in the store and free
paths.

Link: https://lkml.kernel.org/r/20240322001001.1562517-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-nr_zswap_stored-atomic
+++ a/mm/zswap.c
@@ -181,8 +181,6 @@ struct zswap_pool {
 
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
-/* counter of pages stored in all zswap pools. */
-static atomic_t zswap_nr_stored = ATOMIC_INIT(0);
 
 /* The lock protects zswap_next_shrink updates. */
 static DEFINE_SPINLOCK(zswap_shrink_lock);
@@ -885,7 +883,6 @@ static void zswap_entry_free(struct zswa
 	else {
 		zswap_lru_del(&zswap_list_lru, entry);
 		zpool_free(zswap_find_zpool(entry), entry->handle);
-		atomic_dec(&zswap_nr_stored);
 		zswap_pool_put(entry->pool);
 	}
 	if (entry->objcg) {
@@ -1325,7 +1322,7 @@ static unsigned long zswap_shrinker_coun
 		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
 	} else {
 		nr_backing = zswap_total_pages();
-		nr_stored = atomic_read(&zswap_nr_stored);
+		nr_stored = atomic_read(&zswap_stored_pages);
 	}
 
 	if (!nr_stored)
@@ -1345,6 +1342,11 @@ static unsigned long zswap_shrinker_coun
 	 * This ensures that the better zswap compresses memory, the fewer
 	 * pages we will evict to swap (as it will otherwise incur IO for
 	 * relatively small memory saving).
+	 *
+	 * The memory saving factor calculated here takes same-filled pages into
+	 * account, but those are not freeable since they almost occupy no
+	 * space. Hence, we may scale nr_freeable down a little bit more than we
+	 * should if we have a lot of same-filled pages.
 	 */
 	return mult_frac(nr_freeable, nr_backing, nr_stored);
 }
@@ -1590,7 +1592,6 @@ insert_entry:
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
 		zswap_lru_add(&zswap_list_lru, entry);
-		atomic_inc(&zswap_nr_stored);
 	}
 	spin_unlock(&tree->lock);
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-always-shrink-in-zswap_store-if-zswap_pool_reached_full.patch
mm-zswap-refactor-limit-checking-from-zswap_store.patch
mm-zswap-move-more-same-filled-pages-checks-outside-of-zswap_store.patch
mm-zswap-remove-same_filled-module-params.patch
mm-zswap-remove-same_filled-module-params-fix.patch

