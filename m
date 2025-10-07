Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6412F2080C8
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 22:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875657; cv=none; b=D3UbFDMLObpJqIZCuQzdvgLZW9IkG2pRZwuPg3IBtRZ8/52sLw414vkbEU87jCh9l+4Yk85MlMTTQ/fx0ytYMbfONHs8mIV6ECCKmYAih8/LBG5P21fyr1Q2L8WMtCcLsAZWYyaLJjvFFNVWahDaUK4aKRTVqD6VCCwVNuXTWME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875657; c=relaxed/simple;
	bh=K2hOmB1kNMWkGIklPdhgjM7nXgfmuvFPGz163pG2v+4=;
	h=Date:To:From:Subject:Message-Id; b=YcaPkyANkWH/zVKcPEkOuyIiK5/5+VATbMOD0ZaulowM87r+GuQheG90Z/Lyph/kVpu7HDs3JGMQ2j4Qza4LzFGS+UJ+xhy75AjI+caMw+RffLi3Uy0Pyn08K2+wfSZQKOmA3Lfdx0BjxB831C19Cb2FPtaSoBNCSgJPa1sd3fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VZD7LbkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VZD7LbkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEA3C4CEF1;
	Tue,  7 Oct 2025 22:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759875656;
	bh=K2hOmB1kNMWkGIklPdhgjM7nXgfmuvFPGz163pG2v+4=;
	h=Date:To:From:Subject:From;
	b=VZD7LbkVVvz6+TuvfmjY4CuIn5juf0WHLTMXWUBiagc4i/XXpgtzEk9pm8+D59g5q
	 EOrFcfSkzHpB51xaMAqDrfTdmEC1oGP9zc15UlBXI+M2MIm7CX5TDof3GzyHIc95Lo
	 yA0NCq+DBYRj9Lz4VxgOm9tr9RrYfyE+TRwMxaus=
Date: Tue, 07 Oct 2025 15:20:56 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-cleanup-swap-entry-allocation-parameter.patch added to mm-new branch
Message-Id: <20251007222056.CFEA3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: cleanup swap entry allocation parameter
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-cleanup-swap-entry-allocation-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-cleanup-swap-entry-allocation-parameter.patch

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
Subject: mm, swap: cleanup swap entry allocation parameter
Date: Tue, 07 Oct 2025 04:02:35 +0800

We no longer need this GFP parameter after commit 8578e0c00dcf ("mm, swap:
use the swap table for the swap cache and switch API").  Before that
commit the GFP parameter is already almost identical for all callers, so
nothing changed by that commit.  Swap table just moved the GFP to lower
layer and make it more defined and changes depend on atomic or sleep
allocation.

Now this parameter is no longer used, just remove it.  No behavior change.

Link: https://lkml.kernel.org/r/20251007-swap-clean-after-swap-table-p1-v1-3-74860ef8ba74@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++--
 mm/shmem.c           |    2 +-
 mm/swapfile.c        |    2 +-
 mm/vmscan.c          |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/swap.h~mm-swap-cleanup-swap-entry-allocation-parameter
+++ a/include/linux/swap.h
@@ -462,7 +462,7 @@ static inline long get_nr_swap_pages(voi
 }
 
 extern void si_swapinfo(struct sysinfo *);
-int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask);
+int folio_alloc_swap(struct folio *folio);
 bool folio_free_swap(struct folio *folio);
 void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
@@ -560,7 +560,7 @@ static inline int swp_swapcount(swp_entr
 	return 0;
 }
 
-static inline int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask)
+static inline int folio_alloc_swap(struct folio *folio)
 {
 	return -EINVAL;
 }
--- a/mm/shmem.c~mm-swap-cleanup-swap-entry-allocation-parameter
+++ a/mm/shmem.c
@@ -1617,7 +1617,7 @@ try_split:
 		folio_mark_uptodate(folio);
 	}
 
-	if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
+	if (!folio_alloc_swap(folio)) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
 
--- a/mm/swapfile.c~mm-swap-cleanup-swap-entry-allocation-parameter
+++ a/mm/swapfile.c
@@ -1425,7 +1425,7 @@ static bool swap_sync_discard(void)
  * Context: Caller needs to hold the folio lock.
  * Return: Whether the folio was added to the swap cache.
  */
-int folio_alloc_swap(struct folio *folio, gfp_t gfp)
+int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
--- a/mm/vmscan.c~mm-swap-cleanup-swap-entry-allocation-parameter
+++ a/mm/vmscan.c
@@ -1296,7 +1296,7 @@ retry:
 					    split_folio_to_list(folio, folio_list))
 						goto activate_locked;
 				}
-				if (folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOWARN)) {
+				if (folio_alloc_swap(folio)) {
 					int __maybe_unused order = folio_order(folio);
 
 					if (!folio_test_large(folio))
@@ -1312,7 +1312,7 @@ retry:
 					}
 #endif
 					count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
-					if (folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOWARN))
+					if (folio_alloc_swap(folio))
 						goto activate_locked_split;
 				}
 				/*
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-do-not-perform-synchronous-discard-during-allocation.patch
mm-swap-rename-helper-for-setup-bad-slots.patch
mm-swap-cleanup-swap-entry-allocation-parameter.patch
mm-migrate-swap-drop-usage-of-folio_index.patch

