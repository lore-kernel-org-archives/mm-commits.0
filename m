Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8112376
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 00:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711068234; cv=none; b=myB0d4dK6xEfHzhAR+b9FqxVJ96+KHRWesDj9KJVtwuQyJWGpjEW8LnFAZLS69hAAIckKrXNbp+GhahBrxp5IHAOX+1zenqW2xN5a7m0OGUUHl7srHmy42RvkamdNEXdzncZjVPMcOKvQzi8PYjgjFaoqA1HatHuwsuBlSswQfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711068234; c=relaxed/simple;
	bh=V181N1sk8IBz5SzbjzuBNaTMZYL5XTP9Tpzfc/T8nDs=;
	h=Date:To:From:Subject:Message-Id; b=flZ9FEo+xqzVWtNlMQBjD+C8zScYNGVixvVwNG3/ILL8qFZfb9mFzgYij5U7oIi3R7Co8Dk2sv9q9f6bFlc/mBbW+c/16i5/4mRRokF2BBTZsKL6+DaOw5WXdCgJbDtrK57c5sjvPe7zru844wULllNqupDFZG/H2iBV+1y/02Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UKa8Dz7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UKa8Dz7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486DAC433F1;
	Fri, 22 Mar 2024 00:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711068234;
	bh=V181N1sk8IBz5SzbjzuBNaTMZYL5XTP9Tpzfc/T8nDs=;
	h=Date:To:From:Subject:From;
	b=UKa8Dz7TNx5+u+q/NKnIM+g2Ht250E2Y8xyv1t2hanGDugpeJf90HGAYu6Ih2XOvh
	 HeFC3XwJuqwIhE/m7ngUz6IT26kLGlQJenpsB+2powYnTpPdcEsDlt3zBb3Ajv4o+e
	 2L3d2Q0dVd8NX1rEsq/LAPwgDI9DYudcZHAbkC6Q=
Date: Thu, 21 Mar 2024 17:43:53 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-remove-nr_zswap_stored-atomic.patch added to mm-unstable branch
Message-Id: <20240322004354.486DAC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: remove nr_zswap_stored atomic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-remove-nr_zswap_stored-atomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-remove-nr_zswap_stored-atomic.patch

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
Cc: Chengming Zhou <chengming.zhou@linux.dev> [Bug #1]
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-nr_zswap_stored-atomic
+++ a/mm/zswap.c
@@ -180,8 +180,6 @@ struct zswap_pool {
 
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
-/* counter of pages stored in all zswap pools. */
-static atomic_t zswap_nr_stored = ATOMIC_INIT(0);
 
 /* The lock protects zswap_next_shrink updates. */
 static DEFINE_SPINLOCK(zswap_shrink_lock);
@@ -819,7 +817,6 @@ static void zswap_entry_free(struct zswa
 	else {
 		zswap_lru_del(&zswap_list_lru, entry);
 		zpool_free(zswap_find_zpool(entry), entry->handle);
-		atomic_dec(&zswap_nr_stored);
 		zswap_pool_put(entry->pool);
 	}
 	if (entry->objcg) {
@@ -1236,7 +1233,7 @@ static unsigned long zswap_shrinker_coun
 #else
 	/* use pool stats instead of memcg stats */
 	nr_backing = zswap_total_pages();
-	nr_stored = atomic_read(&zswap_nr_stored);
+	nr_stored = atomic_read(&zswap_stored_pages);
 #endif
 
 	if (!nr_stored)
@@ -1256,6 +1253,11 @@ static unsigned long zswap_shrinker_coun
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
@@ -1518,7 +1520,6 @@ insert_entry:
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
 		zswap_lru_add(&zswap_list_lru, entry);
-		atomic_inc(&zswap_nr_stored);
 	}
 
 	/* update stats */
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-add-null-check-to-obj_cgroup_put.patch
mm-zswap-remove-unnecessary-check-in-zswap_find_zpool.patch
percpu-clean-up-all-mappings-when-pcpu_map_pages-fails.patch
mm-zswap-remove-nr_zswap_stored-atomic.patch

