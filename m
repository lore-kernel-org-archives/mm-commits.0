Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385C94A06
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 01:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758071180; cv=none; b=Hjy8z4UjJ+AWTZecBRMBQhml2ogRVhEAh5T83M/ckdkPszYB/CAMKTDeeZc8NxWLWg2aN7PEBI5lMB4PuwR/j4MBhVTVhAEwO0/m/Jtcjh4V2X/613wnWVbEl2WI93oM4PMr94q9QsVyJWRg7CbZN/tc4d9Q8RPcFiWamSEc+Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758071180; c=relaxed/simple;
	bh=3eSut5mai9KtOVF2vDA0nOjo5ORGpDwAdEU6Rh3aXFA=;
	h=Date:To:From:Subject:Message-Id; b=eimKJKZDjRFNqWt9xCpRN3+kxl1wiTzgmuAl+TNe30lsj9d+Dy+SKxFpJxXb2uidgRUKgAZ5tzgyHEPT0bbNqTST9oNkWtnc/sNmu2ayq3mtIVodNoYGs0lT8Uz4VsRYdIYJdpmcOBJLFyAHuUXkR1e5/AoCFr30Juaw1ymHzSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pHWVzvGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pHWVzvGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DFEC4CEEB;
	Wed, 17 Sep 2025 01:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758071178;
	bh=3eSut5mai9KtOVF2vDA0nOjo5ORGpDwAdEU6Rh3aXFA=;
	h=Date:To:From:Subject:From;
	b=pHWVzvGBGszIKRvOao33vaSNkRG1LHMsqyDs2E2mw9/VTeXCSubOTlbEtzCqITlnA
	 YfbsUZHNjfoxeNO45wzUvzPmm6xIQp63tGS2WVh+oiQWDMuQx0tzvnYYf3qS02ezXf
	 yPuIEort4YOMMu+/p9xz7afeeNay3bvyQUORqhDw=
Date: Tue, 16 Sep 2025 18:06:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch added to mm-unstable branch
Message-Id: <20250917010618.A0DFEC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: mark swap address space ro and add context debug check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch

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
Subject: mm, swap: mark swap address space ro and add context debug check
Date: Wed, 17 Sep 2025 00:00:57 +0800

Swap cache is now backed by swap table, and the address space is not
holding any mutable data anymore.  And swap cache is now protected by the
swap cluster lock, instead of the XArray lock.  All access to swap cache
are wrapped by swap cache helpers.  Locking is mostly handled internally
by swap cache helpers, only a few __swap_cache_* helpers require the
caller to lock the cluster by themselves.

Worth noting that, unlike XArray, the cluster lock is not IRQ safe.  The
swap cache was very different compared to filemap, and now it's completely
separated from filemap.  Nothing wants to mark or change anything or do a
writeback callback in IRQ.

So explicitly document this and add a debug check to avoid further
potential misuse.  And mark the swap cache space as read-only to avoid any
user wrongly mixing unexpected filemap helpers with swap cache.

Link: https://lkml.kernel.org/r/20250916160100.31545-13-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h       |   12 +++++++++++-
 mm/swap_state.c |    3 ++-
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/mm/swap.h~mm-swap-mark-swap-address-space-ro-and-add-context-debug-check
+++ a/mm/swap.h
@@ -99,6 +99,16 @@ static __always_inline struct swap_clust
 {
 	struct swap_cluster_info *ci = __swap_offset_to_cluster(si, offset);
 
+	/*
+	 * Nothing modifies swap cache in an IRQ context. All access to
+	 * swap cache is wrapped by swap_cache_* helpers, and swap cache
+	 * writeback is handled outside of IRQs. Swapin or swapout never
+	 * occurs in IRQ, and neither does in-place split or replace.
+	 *
+	 * Besides, modifying swap cache requires synchronization with
+	 * swap_map, which was never IRQ safe.
+	 */
+	VM_WARN_ON_ONCE(!in_task());
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
 	if (irq)
 		spin_lock_irq(&ci->lock);
@@ -192,7 +202,7 @@ void __swap_writepage(struct folio *foli
 #define SWAP_ADDRESS_SPACE_SHIFT	14
 #define SWAP_ADDRESS_SPACE_PAGES	(1 << SWAP_ADDRESS_SPACE_SHIFT)
 #define SWAP_ADDRESS_SPACE_MASK		(SWAP_ADDRESS_SPACE_PAGES - 1)
-extern struct address_space swap_space;
+extern struct address_space swap_space __ro_after_init;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
 	return &swap_space;
--- a/mm/swap_state.c~mm-swap-mark-swap-address-space-ro-and-add-context-debug-check
+++ a/mm/swap_state.c
@@ -37,7 +37,8 @@ static const struct address_space_operat
 #endif
 };
 
-struct address_space swap_space __read_mostly = {
+/* Set swap_space as read only as swap cache is handled by swap table */
+struct address_space swap_space __ro_after_init = {
 	.a_ops = &swap_aops,
 };
 
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

