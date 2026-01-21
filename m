Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0737434677A
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966101; cv=none; b=iHlw3FMPUgC1QYIqRo74nNt/6p3+KnSIC76sqerjmssbQkCkhaQ9DakE3wUJum/v3hwV4KA8c4teh9HRRMBqQYgaoPUs7z/47AUfTBKwcTLuvZzOv21w4Ccn4wwcUOuA97//XgNzhcXNQf333F/MgeVNbcgcZfzaDK+qIgJ7rZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966101; c=relaxed/simple;
	bh=3HfACSxdRZzzdww39yMbIHFMbNllurPBHvDmZPHLVSA=;
	h=Date:To:From:Subject:Message-Id; b=CUJbGn6ly9qKmWO+uyJsqfP87n/25wb7mjUqJlEIgKHmoY7f+Wdo69rQWjIyP3TDPtZMGkk6rUDs3aMPU+0NGJFiEG3EDNnRVGF0SNiUyZ7tvPfihh+cGKVdbq7i+ixrvp14YdjEy4bW3W66uvK0D7WigtEyBKledA24lCcXPDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kIYFMOdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kIYFMOdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C748DC16AAE;
	Wed, 21 Jan 2026 03:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966100;
	bh=3HfACSxdRZzzdww39yMbIHFMbNllurPBHvDmZPHLVSA=;
	h=Date:To:From:Subject:From;
	b=kIYFMOdFkpLKF+lgf9wfP20tMkCk2n7+KgzPzyt3r226B8MbZyr0imxH6atfNqzS4
	 Xp+TJMTO6C9dvhr0rnHh/vO1RZJGMK6CApua9Sn55Fs50kecKmzuIcS8YKX/hl4H1Y
	 CCvKWrSGX2jVmdjZPRiZN7GyRwMu6VnA0kT9AQ34=
Date: Tue, 20 Jan 2026 19:28:20 -0800
To: mm-commits@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,apopple@nvidia.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-no-longer-used-gup_fast_undo_dev_pagemap.patch removed from -mm tree
Message-Id: <20260121032820.C748DC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: remove no longer used gup_fast_undo_dev_pagemap
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-no-longer-used-gup_fast_undo_dev_pagemap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/gup: remove no longer used gup_fast_undo_dev_pagemap
Date: Fri, 19 Dec 2025 19:46:00 +0800

This helper is no longer used after commit fd2825b0760a ("mm/gup: remove
pXX_devmap usage from get_user_pages()").

Link: https://lkml.kernel.org/r/20251219-gup-cleanup-v1-1-348a70d9eecb@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/gup.c~mm-gup-remove-no-longer-used-gup_fast_undo_dev_pagemap
+++ a/mm/gup.c
@@ -2806,17 +2806,6 @@ static bool gup_fast_folio_allowed(struc
 	return !reject_file_backed || shmem_mapping(mapping);
 }
 
-static void __maybe_unused gup_fast_undo_dev_pagemap(int *nr, int nr_start,
-		unsigned int flags, struct page **pages)
-{
-	while ((*nr) - nr_start) {
-		struct folio *folio = page_folio(pages[--(*nr)]);
-
-		folio_clear_referenced(folio);
-		gup_put_folio(folio, 1, flags);
-	}
-}
-
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
 /*
  * GUP-fast relies on pte change detection to avoid concurrent pgtable
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch
mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio.patch
mm-swap-split-swap-cache-preparation-loop-into-a-standalone-helper.patch
mm-swap-never-bypass-the-swap-cache-even-for-swp_synchronous_io.patch
mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch
mm-swap-simplify-the-code-and-reduce-indention.patch
mm-swap-free-the-swap-cache-after-folio-is-mapped.patch
mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch
mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch
mm-swap-consolidate-cluster-reclaim-and-usability-check.patch
mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch
mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch
mm-swap-cleanup-swap-entry-management-workflow.patch
mm-swap-cleanup-swap-entry-management-workflow-fix.patch
mm-swap-add-folio-to-swap-cache-directly-on-allocation.patch
mm-swap-check-swap-table-directly-for-checking-cache.patch
mm-swap-clean-up-and-improve-swap-entries-freeing.patch
mm-swap-drop-the-swap_has_cache-flag.patch
mm-swap-remove-no-longer-needed-_swap_info_get.patch

