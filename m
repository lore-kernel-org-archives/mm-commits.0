Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786B01E8326
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 20:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751660407; cv=none; b=fgne4/eM6CzZL8MmizQA5r50PpTL24G2EHS33jb1Yi0i8MzSvUkK8+zhf/J2iujVHXpp4VxnltGYHm6uSk3amtex6803E9HvePVdVsjTB8OzRZQU3ec70h3MM4sM5UY+J3MfAYGKwz5xWyn2Y+JutxNIT0yTfFlgfDkh6xn6Sow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751660407; c=relaxed/simple;
	bh=mxTNxe+8YsHOFC/xbEGGDoNZm6WCOTo64uoc+UfeE6M=;
	h=Date:To:From:Subject:Message-Id; b=l1DXIXVtLk5ZW7MhtGsR8pvnJu8d/F3n6nvQ4OBXYGAvEbl9i807OUegeyKt8utGSPkz5BjYrCLQe7P/i3rjZrGdgoXOSS9PS8+wRoY6WL80P0XE2O/7NQXvfSRcDEsEHsjBB9OCRDL/N4FRmqhvhKsy+57Oqz0yRbnHv11fPOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=khKN4wUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="khKN4wUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED60FC4CEE3;
	Fri,  4 Jul 2025 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751660407;
	bh=mxTNxe+8YsHOFC/xbEGGDoNZm6WCOTo64uoc+UfeE6M=;
	h=Date:To:From:Subject:From;
	b=khKN4wUFW6Lbkh/10x4v0TddJSNipZRLAeXZhsA49FpydXngWAHdPx+4Z9ge1sQVX
	 SdDQnxjK7pgIZiN8tX+RuluH6hGPOSPy6jQBzNcwJXgeQF+kuRrCrdbjbjB6/mXuKw
	 LntC4ks5B/4/6n9a6LG8IV5G6+rLTk9BRGNUXnSo=
Date: Fri, 04 Jul 2025 13:20:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch added to mm-unstable branch
Message-Id: <20250704202006.ED60FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: avoid false positive swap cache lookup
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch

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
Subject: mm/shmem, swap: avoid false positive swap cache lookup
Date: Sat, 5 Jul 2025 02:17:44 +0800

If a shmem read request's index points to the middle of a large swap
entry, shmem swap in will try the swap cache lookup using the large swap
entry's starting value (which is the first sub swap entry of this large
entry).  This will lead to false positive lookup results, if only the
first few swap entries are cached but the actual requested swap entry
pointed by index is uncached.  This is not a rare event as swap readahead
always try to cache order 0 folios when possible.

Currently, shmem will do a large entry split when it occurs, aborts due to
a mismatching folio swap value, then retry the swapin from the beginning,
which is a waste of CPU and adds wrong info to the readahead statistics.

This can be optimized easily by doing the lookup using the right swap
entry value.

Link: https://lkml.kernel.org/r/20250704181748.63181-6-ryncsn@gmail.com
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

 mm/shmem.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-avoid-false-positive-swap-cache-lookup
+++ a/mm/shmem.c
@@ -2274,14 +2274,15 @@ static int shmem_swapin_folio(struct ino
 	pgoff_t offset;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
-	swap = index_entry = radix_to_swp_entry(*foliop);
+	index_entry = radix_to_swp_entry(*foliop);
+	swap = index_entry;
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
@@ -2293,6 +2294,12 @@ static int shmem_swapin_folio(struct ino
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
@@ -2305,8 +2312,10 @@ static int shmem_swapin_folio(struct ino
 
 		/* Skip swapcache for synchronous device. */
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
-			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
+			folio = shmem_swap_alloc_folio(inode, vma, index,
+						       index_entry, order, gfp);
 			if (!IS_ERR(folio)) {
+				swap = index_entry;
 				skip_swapcache = true;
 				goto alloced;
 			}
@@ -2320,17 +2329,7 @@ static int shmem_swapin_folio(struct ino
 			if (error == -EEXIST)
 				goto failed;
 		}
-
-		/*
-		 * Now swap device can only swap in order 0 folio, it is
-		 * necessary to recalculate the new swap entry based on
-		 * the offset, as the swapin index might be unalgined.
-		 */
-		if (order) {
-			offset = index - round_down(index, 1 << order);
-			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
-		}
-
+		/* Cached swapin with readahead, only supports order 0 */
 		folio = shmem_swapin_cluster(swap, gfp, info, index);
 		if (!folio) {
 			error = -ENOMEM;
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

