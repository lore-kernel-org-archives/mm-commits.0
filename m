Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B452130A73
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 22:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753740326; cv=none; b=o9lZW5/Ttya0So/rBn7IjLZO/KvFqHbsQAah8i6LyM3ftSd9zvXt7RdKRQgLWgEWyOq1XnajdYkORJ3sIeW0RAt8w5pZzydjFIXzIf+/ROE5UUgblWbSk/eNaEj/RXgi4jgRrT5tsbi4F1x9p81KXAJsQxloUteU5S/eLr4AOAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753740326; c=relaxed/simple;
	bh=+d9GTmL8dB17VHQykdFKhvoqQZzhM/16IodMAcnBvkw=;
	h=Date:To:From:Subject:Message-Id; b=A2IZVGWx//1Ahjtec8QOAw5g41GeGcBT5TqOP/R4oiMDrjFn4pdxox2JYV5Isaafm9IqnGUXTIPD254Jpm5cSJ97tlQeZ5TyMX6TVdozfac/530xKhRhMTaC2L36Ca3PmaCEdQrASWXbaLHcn84/vykTKQxwjynOII+Gi86YHr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0vDw2yjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0vDw2yjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5D5C4CEE7;
	Mon, 28 Jul 2025 22:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753740326;
	bh=+d9GTmL8dB17VHQykdFKhvoqQZzhM/16IodMAcnBvkw=;
	h=Date:To:From:Subject:From;
	b=0vDw2yjSy3DnpCkVRuDMs390HBTGo+fON0qlOmxilG5UCUGaxVsbHzWOHI9NoiM9T
	 kQcPIo+5X0YnF8bd/h0ycRXCr/y/ebnRT7BRK9HBCZZfew6aLR7NVtZxRPGst1W1NJ
	 3K+QiDk27kSGwVkEJocneS5/cKYi5n/ROr9PGnnM=
Date: Mon, 28 Jul 2025 15:05:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin.patch added to mm-new branch
Message-Id: <20250728220526.1E5D5C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: rework swap entry and index calculation for large swapin
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin.patch

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
Subject: mm/shmem, swap: rework swap entry and index calculation for large swapin
Date: Mon, 28 Jul 2025 15:53:05 +0800

Instead of calculating the swap entry differently in different swapin
paths, calculate it early before the swap cache lookup and use that for
the lookup and later swapin.  And after swapin have brought a folio,
simply round it down against the size of the folio.

This is simple and effective enough to verify the swap value.  A folio's
swap entry is always aligned by its size.  Any kind of parallel split or
race is acceptable because the final shmem_add_to_page_cache ensures that
all entries covered by the folio are correct, and thus there will be no
data corruption.

This also prevents false positive cache lookup.  If a shmem read request's
index points to the middle of a large swap entry, previously, shmem will
try the swap cache lookup using the large swap entry's starting value
(which is the first sub swap entry of this large entry).  This will lead
to false positive lookup results if only the first few swap entries are
cached but the actual requested swap entry pointed by the index is
uncached.  This is not a rare event, as swap readahead always tries to
cache order 0 folios when possible.

And this shouldn't cause any increased repeated faults.  Instead, no
matter how the shmem mapping is split in parallel, as long as the mapping
still contains the right entries, the swapin will succeed.

The final object size and stack usage are also reduced due to simplified
code:

./scripts/bloat-o-meter mm/shmem.o.old mm/shmem.o
add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-145 (-145)
Function                                     old     new   delta
shmem_swapin_folio                          4056    3911    -145
Total: Before=33242, After=33097, chg -0.44%

Stack usage (Before vs After):
mm/shmem.c:2314:12:shmem_swapin_folio   264     static
mm/shmem.c:2314:12:shmem_swapin_folio   256     static

And while at it, round down the index too if swap entry is round down. 
The index is used either for folio reallocation or confirming the mapping
content.  In either case, it should be aligned with the swap folio.

Link: https://lkml.kernel.org/r/20250728075306.12704-8-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   67 +++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin
+++ a/mm/shmem.c
@@ -2302,7 +2302,7 @@ unlock:
 	if (xas_error(&xas))
 		return xas_error(&xas);
 
-	return entry_order;
+	return 0;
 }
 
 /*
@@ -2323,7 +2323,7 @@ static int shmem_swapin_folio(struct ino
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	bool skip_swapcache = false;
-	int error, nr_pages, order, split_order;
+	int error, nr_pages, order;
 	pgoff_t offset;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
@@ -2331,11 +2331,11 @@ static int shmem_swapin_folio(struct ino
 	swap = index_entry;
 	*foliop = NULL;
 
-	if (is_poisoned_swp_entry(swap))
+	if (is_poisoned_swp_entry(index_entry))
 		return -EIO;
 
-	si = get_swap_device(swap);
-	order = shmem_confirm_swap(mapping, index, swap);
+	si = get_swap_device(index_entry);
+	order = shmem_confirm_swap(mapping, index, index_entry);
 	if (unlikely(!si)) {
 		if (order < 0)
 			return -EEXIST;
@@ -2347,6 +2347,12 @@ static int shmem_swapin_folio(struct ino
 		return -EEXIST;
 	}
 
+	/* index may point to the middle of a large entry, get the sub entry */
+	if (order) {
+		offset = index - round_down(index, 1 << order);
+		swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
+	}
+
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
@@ -2359,7 +2365,8 @@ static int shmem_swapin_folio(struct ino
 
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct swapin skipping swap cache & readahead */
-			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
+			folio = shmem_swap_alloc_folio(inode, vma, index,
+						       index_entry, order, gfp);
 			if (IS_ERR(folio)) {
 				error = PTR_ERR(folio);
 				folio = NULL;
@@ -2367,16 +2374,7 @@ static int shmem_swapin_folio(struct ino
 			}
 			skip_swapcache = true;
 		} else {
-			/*
-			 * Cached swapin only supports order 0 folio, it is
-			 * necessary to recalculate the new swap entry based on
-			 * the offset, as the swapin index might be unalgined.
-			 */
-			if (order) {
-				offset = index - round_down(index, 1 << order);
-				swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
-			}
-
+			/* Cached swapin only supports order 0 folio */
 			folio = shmem_swapin_cluster(swap, gfp, info, index);
 			if (!folio) {
 				error = -ENOMEM;
@@ -2384,6 +2382,7 @@ static int shmem_swapin_folio(struct ino
 			}
 		}
 	}
+
 	if (order > folio_order(folio)) {
 		/*
 		 * Swapin may get smaller folios due to various reasons:
@@ -2393,24 +2392,25 @@ static int shmem_swapin_folio(struct ino
 		 * large swap entries. In such cases, we should split the
 		 * large swap entry to prevent possible data corruption.
 		 */
-		split_order = shmem_split_large_entry(inode, index, index_entry, gfp);
-		if (split_order < 0) {
-			error = split_order;
+		error = shmem_split_large_entry(inode, index, index_entry, gfp);
+		if (error)
 			goto failed_nolock;
-		}
+	}
 
-		/*
-		 * If the large swap entry has already been split, it is
-		 * necessary to recalculate the new swap entry based on
-		 * the old order alignment.
-		 */
-		if (split_order > 0) {
-			offset = index - round_down(index, 1 << split_order);
-			swap = swp_entry(swp_type(swap), swp_offset(index_entry) + offset);
-		}
-	} else if (order < folio_order(folio)) {
-		swap.val = round_down(swap.val, 1 << folio_order(folio));
-		index = round_down(index, 1 << folio_order(folio));
+	/*
+	 * If the folio is large, round down swap and index by folio size.
+	 * No matter what race occurs, the swap layer ensures we either get
+	 * a valid folio that has its swap entry aligned by size, or a
+	 * temporarily invalid one which we'll abort very soon and retry.
+	 *
+	 * shmem_add_to_page_cache ensures the whole range contains expected
+	 * entries and prevents any corruption, so any race split is fine
+	 * too, it will succeed as long as the entries are still there.
+	 */
+	nr_pages = folio_nr_pages(folio);
+	if (nr_pages > 1) {
+		swap.val = round_down(swap.val, nr_pages);
+		index = round_down(index, nr_pages);
 	}
 
 	/*
@@ -2446,8 +2446,7 @@ static int shmem_swapin_folio(struct ino
 			goto failed;
 	}
 
-	error = shmem_add_to_page_cache(folio, mapping,
-					round_down(index, nr_pages),
+	error = shmem_add_to_page_cache(folio, mapping, index,
 					swp_to_radix_entry(swap), gfp);
 	if (error)
 		goto failed;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hang.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-tidy-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin.patch
mm-shmem-swap-fix-major-fault-counting.patch

