Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035CD5383;
	Tue, 17 Jun 2025 23:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750201407; cv=none; b=Gp9Vdx5Egoza+JYV86Kz5AuI2ef+M5bCJBORAHEKnEzfy4CbhKnNTu1N5qOuoZisKllR0Z6BrO2phGEyLT+BeXtckEyVL2nTwg7L38Bv/Ge7v6vIeeSVBKbAeCpFVyLFW4qyHXFKAFVfV3lzTXbOAbKsybFGNG1qynB2jlMQItE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750201407; c=relaxed/simple;
	bh=j0FO4SvGUkoQwPrcWOkqTi3awd6OIGtkFLngRcvR/eI=;
	h=Date:To:From:Subject:Message-Id; b=e1XVapGu2DPJbKuBY7h3wWsOZ8IXivEeEcIKWbR65XtrDL+R6UQXBqKvz0FwoJpK1TNqOmF5Jj3frkLiO2A0hRasnkJ5gVImLux4i6QDnQT15RTaMDP4QVlkcH0mXc7keAW5yW1o9RF0Y+tT3/FP1p9eFEwgTWplzMrojGK7iL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ulh68s7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ulh68s7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73829C4CEE3;
	Tue, 17 Jun 2025 23:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750201406;
	bh=j0FO4SvGUkoQwPrcWOkqTi3awd6OIGtkFLngRcvR/eI=;
	h=Date:To:From:Subject:From;
	b=ulh68s7Yz3MbRWzWdH+aCsC7MyzFPutct6UEizUwAmte7zuxQxkCHtEzIDEUoHosv
	 QIyKmyEXOpZePZR//fKUGOhOsSb1Iv70andk+0two9vHfbnjrZYNzVEGQkMfd4Djya
	 jHVPBhDt8KwHJafBf9+5ZXJGMIKZitTCisZAFnmo=
Date: Tue, 17 Jun 2025 16:03:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch added to mm-new branch
Message-Id: <20250617230326.73829C4CEE3@smtp.kernel.org>
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
Date: Wed, 18 Jun 2025 02:35:00 +0800

Patch series "mm/shmem, swap: bugfix and improvement of mTHP swap in".

The current mTHP swapin path have several problems.  It may potentially
hang, may cause redundant faults due to false positive swap cache lookup,
and it will involve at least 4 Xarray tree walks (get order, get order
again, confirm swap, insert folio).  And for !CONFIG_TRANSPARENT_HUGEPAGE
builds, it will performs some mTHP related checks.

This series fixes all of the mentioned issues, and the code should be more
robust and prepared for the swap table series.  Now tree walks is reduced
to twice (get order & confirm, insert folio) and added more sanity checks
and comments.  !CONFIG_TRANSPARENT_HUGEPAGE build overhead is also
minimized, and comes with a sanity check now.

The performance is slightly better after this series, sequential swap in
of 24G data from ZRAM, using transparent_hugepage_tmpfs=always (36 samples
each):

Before:        avg: 11.23s, stddev: 0.06
After patch 1: avg: 10.92s, stddev: 0.05
After patch 2: avg: 10.93s, stddev: 0.15
After patch 3: avg: 10.07s, stddev: 0.09
After patch 4: avg: 10.09s, stddev: 0.08

Each patch improves the performance by a little, which is about ~10%
faster in total.

Build kernel test showed very slightly improvement, testing with make -j24
with defconfig in a 256M memcg also using ZRAM as swap, and
transparent_hugepage_tmpfs=always (6 samples each):

Before:        system time avg: 3945.25s
After patch 1: system time avg: 3903.21s
After patch 2: system time avg: 3914.76s
After patch 3: system time avg: 3907.41s
After patch 4: system time avg: 3876.24s

Slightly better than noise level given the number of samples.

Two of the patches in this series come from the swap table series [1], and
it is worth noting that the performance gain of this series is independent
of the swap table series, we'll see another bigger performance gain and
reduction of memory usage after the swap table series.

I found these issues while trying to split the shmem changes out of the
swap table series for easier reviewing, and found several more issues
while doing stress tests for performance comparision.  Barry also
mentioned that CONFIG_TRANSPARENT_HUGEPAGE may have redundant checks [2]
and I managed to clean them up properly too.

No issue is found with a few days of stress testing.


This patch (of 4):

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

This will actually improve the performance, as it avoided two redundant
Xarray tree walks in the hot path, and the only side effect is that in the
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

Link: https://lkml.kernel.org/r/20250617183503.10527-1-ryncsn@gmail.com
Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/ [1]
Link: https://lore.kernel.org/linux-mm/CAMgjq7AsKFz7UN+seR5atznE_RBTDC9qjDmwN5saMe+KL3b1mQ@mail.gmail.com/ [2]
Link: https://lkml.kernel.org/r/20250617183503.10527-2-ryncsn@gmail.com
Fixes: 058313515d5a ("mm: shmem: fix potential data corruption during shmem swapin")
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
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
+		swap.val = round_down(swp_type(swap), folio_order(folio));
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

mm-shmem-swap-fix-softlockup-with-mthp-swapin.patch
mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3.patch
mm-userfaultfd-fix-race-of-userfaultfd_move-and-swap-cache.patch
mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-improve-mthp-swapin-process.patch
mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch

