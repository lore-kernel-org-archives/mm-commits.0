Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B98217F2E
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 20:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751055407; cv=none; b=WWAfMBC1Ec/cziOhNBQlwIQBUWxUlg5+tDT6BtXFUvb/e17vQS1SS9UtkTxmXoMrXDtmBow6FzZbt3ctpYNFV3B4XnLZCsmQRUdfxFlzKqNvOzet1jEq2IK6LuB9DSnb2jHEKdt0JYsI48ztZHSJ6e6Lr4brll99n6gGbJE7clc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751055407; c=relaxed/simple;
	bh=qoTesDHBNcTZ2z4igS/DbwAz9nEx/Aol5VK5S2TGq/8=;
	h=Date:To:From:Subject:Message-Id; b=As4MuMCCG/FvqxXbbESzeKWuIxM560m2RuzcztjSIB3WbKGmG87VgHQ4zNB6/sJOJDKRgCivzfi7scKEuAeSi+GD+5nHqCs/AM7+4ATIgNVkSufXwVhbQxyqjY6Plxj9m+QJSM8UOi+Qkbwy6w1GobFJnCAtNxgx9qQU7sFuIqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FkCjiJmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FkCjiJmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537C3C4CEEB;
	Fri, 27 Jun 2025 20:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751055407;
	bh=qoTesDHBNcTZ2z4igS/DbwAz9nEx/Aol5VK5S2TGq/8=;
	h=Date:To:From:Subject:From;
	b=FkCjiJmtgY7Ji03VdiQ4HfZGvK74SalVi4H7tWFHAo3+pxEyBzxMCqXbods6huCyQ
	 vfIkaFssepEUCC8dGSqpj3Pv1e5ote/cBQL5ZnM8dULeIGGIpr0vPiDb5Bg21hrAmY
	 kPeCPO3Hl03MdQfsunH+Cr2/E+uqk5OvMauj6REo=
Date: Fri, 27 Jun 2025 13:16:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-clean-up-swap-entry-splitting.patch added to mm-new branch
Message-Id: <20250627201647.537C3C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: clean up swap entry splitting
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-swap-clean-up-swap-entry-splitting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-clean-up-swap-entry-splitting.patch

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
Subject: mm/shmem, swap: clean up swap entry splitting
Date: Fri, 27 Jun 2025 14:20:17 +0800

Instead of keeping different paths of splitting the entry and
recalculating the swap entry and index, do it in one place.

Whenever swapin brought in a folio smaller than the entry, split the
entry.  And always recalculate the entry and index, in case it might read
in a folio that's larger than the entry order.  This removes duplicated
code and function calls, and makes the code more robust.

Link: https://lkml.kernel.org/r/20250627062020.534-5-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 mm/shmem.c |  103 ++++++++++++++++++++-------------------------------
 1 file changed, 41 insertions(+), 62 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-clean-up-swap-entry-splitting
+++ a/mm/shmem.c
@@ -2178,8 +2178,12 @@ static void shmem_set_folio_swapin_error
 	swap_free_nr(swap, nr_pages);
 }
 
-static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
-				   swp_entry_t swap, gfp_t gfp)
+/*
+ * Split an existing large swap entry. @index should point to one sub mapping
+ * slot within the entry @swap, this sub slot will be split into order 0.
+ */
+static int shmem_split_swap_entry(struct inode *inode, pgoff_t index,
+				  swp_entry_t swap, gfp_t gfp)
 {
 	struct address_space *mapping = inode->i_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
@@ -2250,7 +2254,7 @@ unlock:
 	if (xas_error(&xas))
 		return xas_error(&xas);
 
-	return entry_order;
+	return 0;
 }
 
 /*
@@ -2267,11 +2271,11 @@ static int shmem_swapin_folio(struct ino
 	struct address_space *mapping = inode->i_mapping;
 	struct mm_struct *fault_mm = vma ? vma->vm_mm : NULL;
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	int error, nr_pages, order, swap_order;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	bool skip_swapcache = false;
 	swp_entry_t swap;
-	int error, nr_pages, order, split_order;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
 	swap = radix_to_swp_entry(*foliop);
@@ -2321,70 +2325,43 @@ static int shmem_swapin_folio(struct ino
 				goto failed;
 		}
 
-		/*
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
-		 * necessary to recalculate the new swap entry based on
-		 * the old order alignment.
-		 */
-		if (split_order > 0) {
-			pgoff_t offset = index - round_down(index, 1 << split_order);
-
-			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
-		}
-
 		/* Here we actually start the io */
 		folio = shmem_swapin_cluster(swap, gfp, info, index);
 		if (!folio) {
 			error = -ENOMEM;
 			goto failed;
 		}
-	} else if (order > folio_order(folio)) {
-		/*
-		 * Swap readahead may swap in order 0 folios into swapcache
-		 * asynchronously, while the shmem mapping can still stores
-		 * large swap entries. In such cases, we should split the
-		 * large swap entry to prevent possible data corruption.
-		 */
-		split_order = shmem_split_large_entry(inode, index, swap, gfp);
-		if (split_order < 0) {
-			folio_put(folio);
-			folio = NULL;
-			error = split_order;
-			goto failed;
-		}
-
-		/*
-		 * If the large swap entry has already been split, it is
-		 * necessary to recalculate the new swap entry based on
-		 * the old order alignment.
-		 */
-		if (split_order > 0) {
-			pgoff_t offset = index - round_down(index, 1 << split_order);
-
-			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
-		}
-	} else if (order < folio_order(folio)) {
-		swap.val = round_down(swap.val, 1 << folio_order(folio));
 	}
 
 alloced:
+	/*
+	 * We need to split an existing large entry if swapin brought in a
+	 * smaller folio due to various of reasons.
+	 *
+	 * And worth noting there is a special case: if there is a smaller
+	 * cached folio that covers @swap, but not @index (it only covers
+	 * first few sub entries of the large entry, but @index points to
+	 * later parts), the swap cache lookup will still see this folio,
+	 * And we need to split the large entry here. Later checks will fail,
+	 * as it can't satisfy the swap requirement, and we will retry
+	 * the swapin from beginning.
+	 */
+	swap_order = folio_order(folio);
+	if (order > swap_order) {
+		error = shmem_split_swap_entry(inode, index, swap, gfp);
+		if (error)
+			goto failed_nolock;
+	}
+
+	index = round_down(index, 1 << swap_order);
+	swap.val = round_down(swap.val, 1 << swap_order);
+
 	/* We have to do this with folio locked to prevent races */
 	folio_lock(folio);
 	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
 	    folio->swap.val != swap.val) {
 		error = -EEXIST;
-		goto unlock;
+		goto failed_unlock;
 	}
 	if (!folio_test_uptodate(folio)) {
 		error = -EIO;
@@ -2405,8 +2382,7 @@ alloced:
 			goto failed;
 	}
 
-	error = shmem_add_to_page_cache(folio, mapping,
-					round_down(index, nr_pages),
+	error = shmem_add_to_page_cache(folio, mapping, index,
 					swp_to_radix_entry(swap), gfp);
 	if (error)
 		goto failed;
@@ -2417,8 +2393,8 @@ alloced:
 		folio_mark_accessed(folio);
 
 	if (skip_swapcache) {
+		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
 		folio->swap.val = 0;
-		swapcache_clear(si, swap, nr_pages);
 	} else {
 		delete_from_swap_cache(folio);
 	}
@@ -2434,13 +2410,16 @@ failed:
 	if (error == -EIO)
 		shmem_set_folio_swapin_error(inode, index, folio, swap,
 					     skip_swapcache);
-unlock:
-	if (skip_swapcache)
-		swapcache_clear(si, swap, folio_nr_pages(folio));
-	if (folio) {
+failed_unlock:
+	if (folio)
 		folio_unlock(folio);
-		folio_put(folio);
+failed_nolock:
+	if (skip_swapcache) {
+		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
+		folio->swap.val = 0;
 	}
+	if (folio)
+		folio_put(folio);
 	put_swap_device(si);
 	return error;
 }
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-clean-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-fix-major-fault-counting.patch
mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch

