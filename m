Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD4F1DF270
	for <mm-commits@vger.kernel.org>; Sun,  9 Nov 2025 18:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762712843; cv=none; b=C3gApkgb/ZmmXUlqVoL7Zw2a7GSV3IfgYUD5rOAkRFNGDUo9AGtWi1EJDVbrOlJyiKL9a9kAgrwSdT5g9RHrwuS0oC4MctYXfQLSp5AsFDXg7jgyVAdiTXpH+VM2fjNpvEK+s2OeO6w810iHFiUipY13ALjLBNfXwKTOuB4herw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762712843; c=relaxed/simple;
	bh=fvjTF4TzGzu9MowwwyZHu7vQCLI5R9Z+OVrDBGK/Skc=;
	h=Date:To:From:Subject:Message-Id; b=O8UZsfWBW+PFo2SXOuHyC7QDdUjfPDhiToCwv1J1indouttO/bX984s8Wc8kMrItTNzTdrh0BV1Tt8c5QbVj1XRGxSQZzkBigPe8+bcy4MVS2qldyW7yG/lxvfN1he5ECrRxsHVvPYOcWeajzJiojoP/ylXfC4Ckr68E18j76J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2ARUeS2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ARUeS2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72ABC116B1;
	Sun,  9 Nov 2025 18:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762712842;
	bh=fvjTF4TzGzu9MowwwyZHu7vQCLI5R9Z+OVrDBGK/Skc=;
	h=Date:To:From:Subject:From;
	b=2ARUeS2w328sQHX+BDThrTk2/3zlVlWAUHo6xVGCH+vW29BkSMxe1B23Rrq9x0LfM
	 qijtI6nMmcE25zHeK4XZ7TFJXVm8EJWJ2Zj7i2XD6n5nYOcdSgnatsiYx7egS6gRNR
	 JxFbsIgL4Dkv5GHn3vSeOKEq6I/c8Im/JWb5sQVw=
Date: Sun, 09 Nov 2025 10:27:22 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,v-songbaohua@oppo.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-swap-avoid-redundant-swap-device-pinning.patch added to mm-new branch
Message-Id: <20251109182722.C72ABC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "mm, swap: avoid redundant swap device pinning"
has been added to the -mm mm-new branch.  Its filename is
     revert-mm-swap-avoid-redundant-swap-device-pinning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-swap-avoid-redundant-swap-device-pinning.patch

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
Subject: Revert "mm, swap: avoid redundant swap device pinning"
Date: Mon, 10 Nov 2025 02:06:03 +0800

This reverts commit 78524b05f1a3e16a5d00cc9c6259c41a9d6003ce.

While reviewing recent leaf entry changes, I noticed that commit
78524b05f1a3 ("mm, swap: avoid redundant swap device pinning") isn't
correct.  It's true that most all callers of __read_swap_cache_async are
already holding a swap entry reference, so the repeated swap device
pinning isn't needed on the same swap device, but it is possible that VMA
readahead (swap_vma_readahead()) may encounter swap entries from a
different swap device when there are multiple swap devices, and call
__read_swap_cache_async without holding a reference to that swap device.

So it is possible to cause a UAF if swapoff of device A raced with swapin
on device B, and VMA readahead tries to read swap entries from device A. 
It's not easy to trigger but in theory possible to cause real issues.  And
besides, that commit made swap more vulnerable to issues like corrupted
page tables.

Just revert it.  __read_swap_cache_async isn't that sensitive to
performance after all, as it's mostly used for SSD/HDD swap devices with
readahead.  SYNCHRONOUS_IO devices may fallback onto it for swap count > 1
entries, but very soon we will have a new helper and routine for such
devices, so they will never touch this helper or have redundant swap
device reference overhead.

Link: https://lkml.kernel.org/r/20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com
Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   14 ++++++--------
 mm/zswap.c      |    8 +-------
 2 files changed, 7 insertions(+), 15 deletions(-)

--- a/mm/swap_state.c~revert-mm-swap-avoid-redundant-swap-device-pinning
+++ a/mm/swap_state.c
@@ -406,13 +406,17 @@ struct folio *__read_swap_cache_async(sw
 		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
 		bool skip_if_exists)
 {
-	struct swap_info_struct *si = __swap_entry_to_info(entry);
+	struct swap_info_struct *si;
 	struct folio *folio;
 	struct folio *new_folio = NULL;
 	struct folio *result = NULL;
 	void *shadow = NULL;
 
 	*new_page_allocated = false;
+	si = get_swap_device(entry);
+	if (!si)
+		return NULL;
+
 	for (;;) {
 		int err;
 
@@ -499,6 +503,7 @@ fail_unlock:
 	put_swap_folio(new_folio, entry);
 	folio_unlock(new_folio);
 put_and_return:
+	put_swap_device(si);
 	if (!(*new_page_allocated) && new_folio)
 		folio_put(new_folio);
 	return result;
@@ -518,16 +523,11 @@ struct folio *read_swap_cache_async(swp_
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug)
 {
-	struct swap_info_struct *si;
 	bool page_allocated;
 	struct mempolicy *mpol;
 	pgoff_t ilx;
 	struct folio *folio;
 
-	si = get_swap_device(entry);
-	if (!si)
-		return NULL;
-
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
 	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
@@ -535,8 +535,6 @@ struct folio *read_swap_cache_async(swp_
 
 	if (page_allocated)
 		swap_read_folio(folio, plug);
-
-	put_swap_device(si);
 	return folio;
 }
 
--- a/mm/zswap.c~revert-mm-swap-avoid-redundant-swap-device-pinning
+++ a/mm/zswap.c
@@ -1005,18 +1005,12 @@ static int zswap_writeback_entry(struct
 	struct folio *folio;
 	struct mempolicy *mpol;
 	bool folio_was_allocated;
-	struct swap_info_struct *si;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
-	si = get_swap_device(swpentry);
-	if (!si)
-		return -EEXIST;
-
 	mpol = get_task_policy(current);
 	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
-			NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
-	put_swap_device(si);
+				NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
 	if (!folio)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-fix-thp-allocation-and-fallback-loop.patch
mm-shmem-fix-thp-allocation-and-fallback-loop-v3.patch
mm-swap-do-not-perform-synchronous-discard-during-allocation.patch
mm-swap-rename-helper-for-setup-bad-slots.patch
mm-swap-cleanup-swap-entry-allocation-parameter.patch
mm-migrate-swap-drop-usage-of-folio_index.patch
mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch
revert-mm-swap-avoid-redundant-swap-device-pinning.patch

