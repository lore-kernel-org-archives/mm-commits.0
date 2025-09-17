Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF7D4A06
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 01:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758071145; cv=none; b=Z65ryvDOqG1+8BZNsE2vkU5MbD1hB/gyk7i9hMuePpEiSlvxNZ67wTPPngAJrUkUGk8OPp723q71GxndWmmokMi/i7hLG4gO/FDC37NaNBR5oeA+pb1KcDgrbnAlS5CJAG2stgbmdOm9U/J52JhtMp50FQYs0TIqpac4PDN8mvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758071145; c=relaxed/simple;
	bh=v/3nLnDGSu6/Gx9WzqQ9oAItjY5AyK0bJHRA4LtZWoc=;
	h=Date:To:From:Subject:Message-Id; b=M2f+/igOVHTpQGMXx6W8NqGW4NpkOLP4s7uLO0I0MacGxuSNgDtY3/3R+w4ag6DH4NWhKDpGKWsX8Q6bv58Xob/e6M8FK1k/TlMvAvKUKezFOOstRJE+4zgdysc4kx2oPy1dJWO5sbCSjZ35oFajF55M63+YIknD+R+8YNC+Ktg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L4eCrEUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L4eCrEUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C74DC4CEEB;
	Wed, 17 Sep 2025 01:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758071145;
	bh=v/3nLnDGSu6/Gx9WzqQ9oAItjY5AyK0bJHRA4LtZWoc=;
	h=Date:To:From:Subject:From;
	b=L4eCrEUt+vSx7UJsSfKkMfyIiv2hnvt1xVmV2bTgelzxFnQcAXqf9V9SB4GT4tXov
	 F0k67x0IpXbHO3tpaKW7IdRmIefNX7wOl+6tcofRhkeQ7e5tzx4pe5Y2bWJQaqi9QL
	 VjXQpxW87crZCVRLsAXGQ9UqaAZhfcOkgB6gNW0M=
Date: Tue, 16 Sep 2025 18:05:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-swap-cache-index-error-when-retrying-reclaim.patch added to mm-unstable branch
Message-Id: <20250917010545.5C74DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: fix swap cache index error when retrying reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-fix-swap-cache-index-error-when-retrying-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-swap-cache-index-error-when-retrying-reclaim.patch

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
Subject: mm, swap: fix swap cache index error when retrying reclaim
Date: Wed, 17 Sep 2025 00:00:48 +0800

The allocator will reclaim cached slots while scanning.  Currently, it
will try again if reclaim found a folio that is already removed from the
swap cache due to a race.  But the following lookup will be using the
wrong index.  It won't cause any OOB issue since the swap cache index is
truncated upon lookup, but it may lead to reclaiming of an irrelevant
folio.

This should not cause a measurable issue, but we should fix it.

Link: https://lkml.kernel.org/r/20250916160100.31545-4-ryncsn@gmail.com
Fixes: fae8595505313 ("mm, swap: avoid reclaiming irrelevant swap cache")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swap-fix-swap-cache-index-error-when-retrying-reclaim
+++ a/mm/swapfile.c
@@ -212,7 +212,7 @@ static bool swap_is_last_map(struct swap
 static int __try_to_reclaim_swap(struct swap_info_struct *si,
 				 unsigned long offset, unsigned long flags)
 {
-	swp_entry_t entry = swp_entry(si->type, offset);
+	const swp_entry_t entry = swp_entry(si->type, offset);
 	struct swap_cluster_info *ci;
 	struct folio *folio;
 	int ret, nr_pages;
@@ -240,13 +240,13 @@ again:
 	 * Offset could point to the middle of a large folio, or folio
 	 * may no longer point to the expected offset before it's locked.
 	 */
-	entry = folio->swap;
-	if (offset < swp_offset(entry) || offset >= swp_offset(entry) + nr_pages) {
+	if (offset < swp_offset(folio->swap) ||
+	    offset >= swp_offset(folio->swap) + nr_pages) {
 		folio_unlock(folio);
 		folio_put(folio);
 		goto again;
 	}
-	offset = swp_offset(entry);
+	offset = swp_offset(folio->swap);
 
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-use-unified-helper-for-swap-cache-look-up.patch
mm-swap-fix-swap-cache-index-error-when-retrying-reclaim.patch
mm-swap-check-page-poison-flag-after-locking-it.patch
mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch
mm-swap-rename-and-move-some-swap-cluster-definition-and-helpers.patch
mm-swap-tidy-up-swap-device-and-cluster-info-helpers.patch
mm-swap-cleanup-swap-cache-api-and-add-kerneldoc.patch
mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch
mm-swap-wrap-swap-cache-replacement-with-a-helper.patch
mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api.patch
mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch
mm-swap-remove-contention-workaround-for-swap-cache.patch
mm-swap-implement-dynamic-allocation-of-swap-table.patch
mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch

