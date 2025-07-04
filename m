Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242251E8326
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 20:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751660406; cv=none; b=a91FUkLe9Jkxx4B2BzpXqVHfS7HFGbkdi0MX4+smbWeSitO1ldqNx6BI/dqn1/eqBFzmDEtKp+mKzSt1hELzuPkHK6FIgzkG0L7g1COIO3bLS+/E50jzgPfdQnodgrFHhTGVImoXS+ymw8t5rfn4FlcF3vsSvfPhUf+8GM61nN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751660406; c=relaxed/simple;
	bh=TQ0BhWylWxHCXL5td3O1NB8Z7W/vqWQzTm5IjDVayDo=;
	h=Date:To:From:Subject:Message-Id; b=B8JHreZ8l69R0KgAhL4w+4ydWaX9N3IiEhayvW97juCKZMQi88OR+ND5zVgnEQxWBhQZmZTNx+DKVm89vbe3RfefxplsRGXrCtkIKERlX8t3a9XXd7g7+pz3xCopNom0g16cmDyn7ujoeUnwte/Owh23s8ldAOxk8/IfxR0x6mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S/5UKJAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S/5UKJAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DF2C4CEE3;
	Fri,  4 Jul 2025 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751660404;
	bh=TQ0BhWylWxHCXL5td3O1NB8Z7W/vqWQzTm5IjDVayDo=;
	h=Date:To:From:Subject:From;
	b=S/5UKJAfRNaUau3X7bKq7vi3ec9OIChpY16TvZU3xfmv+ZRAZA8qCJVl8AFYu5Uos
	 Dbm4kx/K0GLt10g+YcgFR3QHfpQn+cv6VdMHR1N+wREsM7sdCIc/ThS39aDdEOJx1J
	 qm05XqpDsTFoZyrtjt8coK+15eu7txWiZ7e6lruk=
Date: Fri, 04 Jul 2025 13:20:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-tidy-up-swap-entry-splitting.patch added to mm-unstable branch
Message-Id: <20250704202004.A8DF2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: tidy up swap entry splitting
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-swap-tidy-up-swap-entry-splitting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-tidy-up-swap-entry-splitting.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: tidy up swap entry splitting
Date: Sat, 5 Jul 2025 02:17:43 +0800

Instead of keeping different paths of splitting the entry before the swap
in start, move the entry splitting after the swapin has put the folio in
swap cache (or set the SWAP_HAS_CACHE bit).  This way we only need one
place and one unified way to split the large entry.  Whenever swapin
brought in a folio smaller than the shmem swap entry, split the entry and
recalculate the entry and index for verification.

This removes duplicated codes and function calls, reduces LOC, and the
split is less racy as it's guarded by swap cache now.  So it will have a
lower chance of repeated faults due to raced split.  The compiler is also
able to optimize the coder further:

bloat-o-meter results with GCC 14:

With DEBUG_SECTION_MISMATCH (-fno-inline-functions-called-once):
./scripts/bloat-o-meter mm/shmem.o.old mm/shmem.o
add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-82 (-82)
Function                                     old     new   delta
shmem_swapin_folio                          2361    2279     -82
Total: Before=33151, After=33069, chg -0.25%

With !DEBUG_SECTION_MISMATCH:
./scripts/bloat-o-meter mm/shmem.o.old mm/shmem.o
add/remove: 0/1 grow/shrink: 1/0 up/down: 949/-750 (199)
Function                                     old     new   delta
shmem_swapin_folio                          2878    3827    +949
shmem_split_large_entry.isra                 750       -    -750
Total: Before=33086, After=33285, chg +0.60%

Since shmem_split_large_entry is only called in one place now. The
compiler will either generate more compact code, or inlined it for
better performance.

Link: https://lkml.kernel.org/r/20250704181748.63181-5-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   53 ++++++++++++++++++++-------------------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-tidy-up-swap-entry-splitting
+++ a/mm/shmem.c
@@ -2266,14 +2266,15 @@ static int shmem_swapin_folio(struct ino
 	struct address_space *mapping = inode->i_mapping;
 	struct mm_struct *fault_mm = vma ? vma->vm_mm : NULL;
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	swp_entry_t swap, index_entry;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	bool skip_swapcache = false;
-	swp_entry_t swap;
 	int error, nr_pages, order, split_order;
+	pgoff_t offset;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
-	swap = radix_to_swp_entry(*foliop);
+	swap = index_entry = radix_to_swp_entry(*foliop);
 	*foliop = NULL;
 
 	if (is_poisoned_swp_entry(swap))
@@ -2321,46 +2322,35 @@ static int shmem_swapin_folio(struct ino
 		}
 
 		/*
-		 * Now swap device can only swap in order 0 folio, then we
-		 * should split the large swap entry stored in the pagecache
-		 * if necessary.
-		 */
-		split_order = shmem_split_large_entry(inode, index, swap, gfp);
-		if (split_order < 0) {
-			error = split_order;
-			goto failed;
-		}
-
-		/*
-		 * If the large swap entry has already been split, it is
+		 * Now swap device can only swap in order 0 folio, it is
 		 * necessary to recalculate the new swap entry based on
-		 * the old order alignment.
+		 * the offset, as the swapin index might be unalgined.
 		 */
-		if (split_order > 0) {
-			pgoff_t offset = index - round_down(index, 1 << split_order);
-
+		if (order) {
+			offset = index - round_down(index, 1 << order);
 			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
 		}
 
-		/* Here we actually start the io */
 		folio = shmem_swapin_cluster(swap, gfp, info, index);
 		if (!folio) {
 			error = -ENOMEM;
 			goto failed;
 		}
-	} else if (order > folio_order(folio)) {
+	}
+alloced:
+	if (order > folio_order(folio)) {
 		/*
-		 * Swap readahead may swap in order 0 folios into swapcache
+		 * Swapin may get smaller folios due to various reasons:
+		 * It may fallback to order 0 due to memory pressure or race,
+		 * swap readahead may swap in order 0 folios into swapcache
 		 * asynchronously, while the shmem mapping can still stores
 		 * large swap entries. In such cases, we should split the
 		 * large swap entry to prevent possible data corruption.
 		 */
-		split_order = shmem_split_large_entry(inode, index, swap, gfp);
+		split_order = shmem_split_large_entry(inode, index, index_entry, gfp);
 		if (split_order < 0) {
-			folio_put(folio);
-			folio = NULL;
 			error = split_order;
-			goto failed;
+			goto failed_nolock;
 		}
 
 		/*
@@ -2369,15 +2359,13 @@ static int shmem_swapin_folio(struct ino
 		 * the old order alignment.
 		 */
 		if (split_order > 0) {
-			pgoff_t offset = index - round_down(index, 1 << split_order);
-
+			offset = index - round_down(index, 1 << split_order);
 			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
 		}
 	} else if (order < folio_order(folio)) {
 		swap.val = round_down(swap.val, 1 << folio_order(folio));
 	}
 
-alloced:
 	/* We have to do this with folio locked to prevent races */
 	folio_lock(folio);
 	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
@@ -2434,12 +2422,13 @@ failed:
 		shmem_set_folio_swapin_error(inode, index, folio, swap,
 					     skip_swapcache);
 unlock:
-	if (skip_swapcache)
-		swapcache_clear(si, swap, folio_nr_pages(folio));
-	if (folio) {
+	if (folio)
 		folio_unlock(folio);
+failed_nolock:
+	if (skip_swapcache)
+		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
+	if (folio)
 		folio_put(folio);
-	}
 	put_swap_device(si);
 	return error;
 }
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-tidy-up-swap-entry-splitting.patch
mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling.patch
mm-shmem-swap-simplify-swap-entry-and-index-calculation-of-large-swapin.patch
mm-shmem-swap-fix-major-fault-counting.patch

