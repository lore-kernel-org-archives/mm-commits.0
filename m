Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3A8B660;
	Thu, 10 Jul 2025 03:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752119226; cv=none; b=O4+zsYCACtpT4QPRR8fRqMF8LQ9yTQwl2ox0SLBH+W5mNidXLAkRsd/AKr8klANkSF/7rzf7SD+EysUylmZr7JfyETdBAARwXAxQt4Ji7H73Na7EIfQeK8opychT9VCHLkqArjs3T2HI/+HHUilliAOIFdGp8puhG/LZ7LF5m30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752119226; c=relaxed/simple;
	bh=ecUlYZ/+WcTsQU3WcRk6IiNaD5f96M/z98/FnbKCE0Y=;
	h=Date:To:From:Subject:Message-Id; b=Ub3mLB3Vt+m+3B1d7LFziW6rSt1hOF3kP7l6xtQoZUuGRYx/dg3cm9yfhnsbfDznVqwHymsMilWbHlEwgeFiRJp2/epzrNMCOi4brAFU/Wry0nsfbjgpewo288Ot/PNUCwcqLgrx8IT1/85R6ZwcJokU+ItVLh0+HZpLrd6laXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oMm3RZJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oMm3RZJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DA4C4CEE3;
	Thu, 10 Jul 2025 03:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752119225;
	bh=ecUlYZ/+WcTsQU3WcRk6IiNaD5f96M/z98/FnbKCE0Y=;
	h=Date:To:From:Subject:From;
	b=oMm3RZJOTkXXcROSQ9fVt5gcDgiRQszAhaYlnu25Cdlq96N9IHh5MytjCuD0rzhT3
	 +E4yrVU4SGW1KHMkUypiIq0Cv8OcQo1zXKSzRG95O8XiwzsBKlTVn4VSrgO1yd7OIq
	 YaDLg0BiiS0rs2UaOZb60LKMvkY68UYJeeE+dUso=
Date: Wed, 09 Jul 2025 20:47:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch added to mm-new branch
Message-Id: <20250710034705.26DA4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: improve cached mTHP handling and fix potential hung
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/shmem, swap: improve cached mTHP handling and fix potential hung
Date: Thu, 10 Jul 2025 11:36:59 +0800

Patch series "mm/shmem, swap: bugfix and improvement of mTHP swap in", v5.

The current mTHP swapin path have several problems.  It may potentially
hang, may cause redundant faults due to false positive swap cache lookup,
and it will involve at least 4 Xarray tree walks (get order, get order
again, confirm swap, insert folio).  And for !CONFIG_TRANSPARENT_HUGEPAGE
builds, it will performs some mTHP related checks.

This series fixes all of the mentioned issues, and the code should be more
robust and prepared for the swap table series.  Now tree walks is reduced
to twice (get order & confirm, insert folio), !CONFIG_TRANSPARENT_HUGEPAGE
build overhead is also minimized, and comes with a sanity check now.

The performance is slightly better after this series, sequential swap in
of 24G data from ZRAM, using transparent_hugepage_tmpfs=always (24 samples
each):

Before:         Avg: 10.67s,  stddev: 0.04
After patch 1:  Avg: 10.49s,  stddev: 0.04
After patch 2:  Avg: 10.42s,  stddev: 0.05
After patch 3:  Avg: 10.45s,  stddev: 0.05
After patch 4:  Avg: 10.49s,  stddev: 0.04
After patch 5:  Avg: 9.67s,   stddev: 0.03
After patch 6:  Avg: 9.67s,   stddev: 0.04
After patch 7:  Avg: 9.68s,   stddev: 0.05
After patch 8:  Avg: 9.66s,   stddev: 0.04

Several patches improve the performance by a little, which is about ~10%
faster in total.

Build kernel test showed very slightly improvement, testing with make -j48
with defconfig in a 768M memcg also using ZRAM as swap, and
transparent_hugepage_tmpfs=always (6 test runs):

Before:         avg: 3353.66s, stddev: 33.73
After patch 1:  avg: 3354.19s, stddev: 42.54
After patch 2:  avg: 3364.16s, stddev: 52.74
After patch 3:  avg: 3355.73s, stddev: 36.17
After patch 4:  avg: 3352.78s, stddev: 39.80
After patch 5:  avg: 3355.19s, stddev: 50.78
After patch 6:  avg: 3333.63s, stddev: 32.50
After patch 7:  avg: 3297.70s, stddev: 38.93
After patch 8:  avg: 3302.35s, stddev: 50.61


This patch (of 8):

The current swap-in code assumes that, when a swap entry in shmem mapping
is order 0, its cached folios (if present) must be order 0 too, which
turns out not always correct.

The problem is shmem_split_large_entry is called before verifying the
folio will eventually be swapped in, one possible race is:

    CPU1                          CPU2
shmem_swapin_folio
/* swap in of order > 0 swap entry S1 */
  folio = swap_cache_get_folio
  /* folio = NULL */
  order = xa_get_order
  /* order > 0 */
  folio = shmem_swap_alloc_folio
  /* mTHP alloc failure, folio = NULL */
  <... Interrupted ...>
                                 shmem_swapin_folio
                                 /* S1 is swapped in */
                                 shmem_writeout
                                 /* S1 is swapped out, folio cached */
  shmem_split_large_entry(..., S1)
  /* S1 is split, but the folio covering it has order > 0 now */

Now any following swapin of S1 will hang: `xa_get_order` returns 0, and
folio lookup will return a folio with order > 0.  The
`xa_get_order(&mapping->i_pages, index) != folio_order(folio)` will always
return false causing swap-in to return -EEXIST.

And this looks fragile.  So fix this up by allowing seeing a larger folio
in swap cache, and check the whole shmem mapping range covered by the
swapin have the right swap value upon inserting the folio.  And drop the
redundant tree walks before the insertion.

This will actually improve performance, as it avoids two redundant Xarray
tree walks in the hot path, and the only side effect is that in the
failure path, shmem may redundantly reallocate a few folios causing
temporary slight memory pressure.

And worth noting, it may seems the order and value check before inserting
might help reducing the lock contention, which is not true.  The swap
cache layer ensures raced swapin will either see a swap cache folio or
failed to do a swapin (we have SWAP_HAS_CACHE bit even if swap cache is
bypassed), so holding the folio lock and checking the folio flag is
already good enough for avoiding the lock contention.  The chance that a
folio passes the swap entry value check but the shmem mapping slot has
changed should be very low.

Link: https://lkml.kernel.org/r/20250710033706.71042-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20250710033706.71042-2-ryncsn@gmail.com
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung
+++ a/mm/shmem.c
@@ -884,7 +884,9 @@ static int shmem_add_to_page_cache(struc
 				   pgoff_t index, void *expected, gfp_t gfp)
 {
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
-	long nr = folio_nr_pages(folio);
+	unsigned long nr = folio_nr_pages(folio);
+	swp_entry_t iter, swap;
+	void *entry;
 
 	VM_BUG_ON_FOLIO(index != round_down(index, nr), folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -896,14 +898,24 @@ static int shmem_add_to_page_cache(struc
 
 	gfp &= GFP_RECLAIM_MASK;
 	folio_throttle_swaprate(folio, gfp);
+	swap = iter = radix_to_swp_entry(expected);
 
 	do {
 		xas_lock_irq(&xas);
-		if (expected != xas_find_conflict(&xas)) {
-			xas_set_err(&xas, -EEXIST);
-			goto unlock;
+		xas_for_each_conflict(&xas, entry) {
+			/*
+			 * The range must either be empty, or filled with
+			 * expected swap entries. Shmem swap entries are never
+			 * partially freed without split of both entry and
+			 * folio, so there shouldn't be any holes.
+			 */
+			if (!expected || entry != swp_to_radix_entry(iter)) {
+				xas_set_err(&xas, -EEXIST);
+				goto unlock;
+			}
+			iter.val += 1 << xas_get_order(&xas);
 		}
-		if (expected && xas_find_conflict(&xas)) {
+		if (expected && iter.val - nr != swap.val) {
 			xas_set_err(&xas, -EEXIST);
 			goto unlock;
 		}
@@ -2323,7 +2335,7 @@ static int shmem_swapin_folio(struct ino
 			error = -ENOMEM;
 			goto failed;
 		}
-	} else if (order != folio_order(folio)) {
+	} else if (order > folio_order(folio)) {
 		/*
 		 * Swap readahead may swap in order 0 folios into swapcache
 		 * asynchronously, while the shmem mapping can still stores
@@ -2348,15 +2360,15 @@ static int shmem_swapin_folio(struct ino
 
 			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
 		}
+	} else if (order < folio_order(folio)) {
+		swap.val = round_down(swap.val, 1 << folio_order(folio));
 	}
 
 alloced:
 	/* We have to do this with folio locked to prevent races */
 	folio_lock(folio);
 	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
-	    folio->swap.val != swap.val ||
-	    !shmem_confirm_swap(mapping, index, swap) ||
-	    xa_get_order(&mapping->i_pages, index) != folio_order(folio)) {
+	    folio->swap.val != swap.val) {
 		error = -EEXIST;
 		goto unlock;
 	}
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-tidy-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin.patch
mm-shmem-swap-fix-major-fault-counting.patch

