Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68112BDC16
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489934; cv=none; b=bWgNbyNOIzOFKtOUP5IejHOU9dmWkeigwROfTFMMKkaBLHgy5aL+MPCIvbXbPFM+pvtwRPVXQga48OYhHy4zn9k6+iBSaq14s6penNxb2RbDQHOz65xRpwWq36OdAaDnEDWgMDGli9RtMR/SLDc+K21iLG+CFyx5hq33Uo81mss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489934; c=relaxed/simple;
	bh=4l/o2sv5iejcQ0xRBzaXZdFiH7bmjX03Yi59YX0nuqc=;
	h=Date:To:From:Subject:Message-Id; b=iTSOxAazC7PNlTwhcOABaC69GTrbYUlVVUWPlVbqCmZlBG6U66yPOCUzSNVIA1wdXNigF5wYMn/xcwE2CzR8sv3mNkQPknhVeNQoX1d5XK+/7mJV4gJVjgCUog5bx2xXcMIMrsj7/JLRkZIysw8x8SG/Vz783r9UKAd1fg2o++Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EAeBsvo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EAeBsvo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B563C4CEE7;
	Sun, 21 Sep 2025 21:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489934;
	bh=4l/o2sv5iejcQ0xRBzaXZdFiH7bmjX03Yi59YX0nuqc=;
	h=Date:To:From:Subject:From;
	b=EAeBsvo6LeRl41MVays+ZCajQNEPirVcUF0AFAEdvp3raOnwx6ruxmjW+513q5shZ
	 RZVwI8s9cY+0wAjqu4vSIzXsRciAhyeR2HoxQG+tqVrc1j1lhIDCD9MzMYPJpsbcQA
	 igMtLbd5ylgDIYVvT+sVThvP/fbnoMwzJ+r2EIMk=
Date: Sun, 21 Sep 2025 14:25:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,sj@kernel.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fix-swap-cache-index-error-when-retrying-reclaim.patch removed from -mm tree
Message-Id: <20250921212534.8B563C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: fix swap cache index error when retrying reclaim
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-swap-cache-index-error-when-retrying-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: fae859550531 ("mm, swap: avoid reclaiming irrelevant swap cache")
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
Cc: SeongJae Park <sj@kernel.org>
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


