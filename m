Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F415466B
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247760; cv=none; b=lwzEo9W7bzDF2aY3oD3nSjJMcK5HMowt7S1eGRGpCBdKBp4jmXQ6LgjqYVO9LUJpP3DTriHhkBtqp6iMNOM1t1zXB1Jnk2Kx9+lqU1CjZtB55bfxHongVle4RQx4Hl82LlwpiAEKo9BU2n1Tl2Re/jlqwms9/+eJQe74oX1ftHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247760; c=relaxed/simple;
	bh=7pGWj99Cfe44TZIO4FFiLQ74m/B1xqyQG3kU8l0clnI=;
	h=Date:To:From:Subject:Message-Id; b=cNM0GOLhI2am76CHBbUQjPMgWnr9kySCdxCu4k8ouj7BPaWkdgaiSwUTZ8Ns1txb1Z2bur8wkiIzk1qxTSVzVdM6Cp+yDh8y3fguPzpoCum02uziS9JGre3zVYJpwN6g+ALo3g9lK00BzDO+X+JQd2/5iuBybv0YA5AtP/A3kts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TUsocQM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TUsocQM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6F0C4CEC2;
	Mon,  2 Sep 2024 03:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247760;
	bh=7pGWj99Cfe44TZIO4FFiLQ74m/B1xqyQG3kU8l0clnI=;
	h=Date:To:From:Subject:From;
	b=TUsocQM16oGF8rxdRxpVyBHFN5VNJ2Bm8/3L1WvQQ0/1bV3QpbQUW3mGqNaUZPELU
	 y7cv7TzbIZo3JLPLa1LqnLYZVC+QKksQsJb4K/CF+hVPfzjFBQH0ggWykN01kPgids
	 aB29EOglD0RI7iq/jzeAnV6fr4MDlSfvywTUCWcs=
Date: Sun, 01 Sep 2024 20:29:20 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,hannes@cmpxchg.org,flintglass@gmail.com,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zswap-track-swapins-from-disk-more-accurately.patch removed from -mm tree
Message-Id: <20240902032920.9D6F0C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zswap: track swapins from disk more accurately
has been removed from the -mm tree.  Its filename was
     zswap-track-swapins-from-disk-more-accurately.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: track swapins from disk more accurately
Date: Mon, 5 Aug 2024 16:22:43 -0700

Currently, there are a couple of issues with our disk swapin tracking for
dynamic zswap shrinker heuristics:

1. We only increment the swapin counter on pivot pages. This means we
   are not taking into account pages that also need to be swapped in,
   but are already taken care of as part of the readahead window.

2. We are also incrementing when the pages are read from the zswap pool,
   which is inaccurate.

This patch rectifies these issues by incrementing the counter whenever we
need to perform a non-zswap read.  Note that we are slightly overcounting,
as a page might be read into memory by the readahead algorithm even though
it will not be neeeded by users - however, this is an acceptable
inaccuracy, as the readahead logic itself will adapt to these kind of
scenarios.

To test this change, I built the kernel under a cgroup with its memory.max
set to 2 GB:

real: 236.66s
user: 4286.06s
sys: 652.86s
swapins: 81552

For comparison, with just the new second chance algorithm, the build time
is as follows:

real: 244.85s
user: 4327.22s
sys: 664.39s
swapins: 94663

Without neither:

real: 263.89s
user: 4318.11s
sys: 673.29s
swapins: 227300.5

(average over 5 runs)

With this change, the kernel CPU time reduces by a further 1.7%, and the
real time is reduced by another 3.3%, compared to just the second chance
algorithm by itself.  The swapins count also reduces by another 13.85%.

Combinng the two changes, we reduce the real time by 10.32%, kernel CPU
time by 3%, and number of swapins by 64.12%.

To gauge the new scheme's ability to offload cold data, I ran another
benchmark, in which the kernel was built under a cgroup with memory.max
set to 3 GB, but with 0.5 GB worth of cold data allocated before each
build (in a shmem file).

Under the old scheme:

real: 197.18s
user: 4365.08s
sys: 289.02s
zswpwb: 72115.2

Under the new scheme:

real: 195.8s
user: 4362.25s
sys: 290.14s
zswpwb: 87277.8

(average over 5 runs)

Notice that we actually observe a 21% increase in the number of written
back pages - so the new scheme is just as good, if not better at
offloading pages from the zswap pool when they are cold.  Build time
reduces by around 0.7% as a result.

[nphamcs@gmail.com: squeeze a comment into a single line]
  Link: https://lkml.kernel.org/r/20240806004518.3183562-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20240805232243.2896283-3-nphamcs@gmail.com
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Takero Funaki <flintglass@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c    |    9 ++++++++-
 mm/swap_state.c |    8 ++------
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/mm/page_io.c~zswap-track-swapins-from-disk-more-accurately
+++ a/mm/page_io.c
@@ -521,7 +521,13 @@ void swap_read_folio(struct folio *folio
 
 	if (zswap_load(folio)) {
 		folio_unlock(folio);
-	} else if (data_race(sis->flags & SWP_FS_OPS)) {
+		goto finish;
+	}
+
+	/* We have to read from slower devices. Increase zswap protection. */
+	zswap_folio_swapin(folio);
+
+	if (data_race(sis->flags & SWP_FS_OPS)) {
 		swap_read_folio_fs(folio, plug);
 	} else if (synchronous) {
 		swap_read_folio_bdev_sync(folio, sis);
@@ -529,6 +535,7 @@ void swap_read_folio(struct folio *folio
 		swap_read_folio_bdev_async(folio, sis);
 	}
 
+finish:
 	if (workingset) {
 		delayacct_thrashing_end(&in_thrashing);
 		psi_memstall_leave(&pflags);
--- a/mm/swap_state.c~zswap-track-swapins-from-disk-more-accurately
+++ a/mm/swap_state.c
@@ -702,10 +702,8 @@ skip:
 	/* The page was likely read above, so no need for plugging here */
 	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
-	if (unlikely(page_allocated)) {
-		zswap_folio_swapin(folio);
+	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
-	}
 	return folio;
 }
 
@@ -854,10 +852,8 @@ skip:
 	/* The folio was likely read above, so no need for plugging here */
 	folio = __read_swap_cache_async(targ_entry, gfp_mask, mpol, targ_ilx,
 					&page_allocated, false);
-	if (unlikely(page_allocated)) {
-		zswap_folio_swapin(folio);
+	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
-	}
 	return folio;
 }
 
_

Patches currently in -mm which might be from nphamcs@gmail.com are


