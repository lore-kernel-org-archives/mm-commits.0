Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD3617E4
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 00:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757118419; cv=none; b=Kwggyspmfo0lAhC0YTISslUh0Fk1kb7/SCDDbd904Tz8aTzTkPLOEbEzoIalzOXkPJlA4DFdFblI4o2hpNKaSlpOAU8Mj9Rstpc38YZBsy85o3ZXb6sVqlLU1VbUCBQWlQCkGRFXFK9eI/pocmHRBgyM0O6xCqxM+mnYemHsvXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757118419; c=relaxed/simple;
	bh=ITFpYIiZDVIX5puWxEDHynzUdVhPpguk43GCNGvcVGM=;
	h=Date:To:From:Subject:Message-Id; b=hXrwjmagBAQ7zEZb2w9MzKkCOxykmAEH7LMgx5PIq9TmE0tvN8InEQ0+KdzZ2yi+o8MDyQoOFLIqM6H2EbMS/7cxg6vFAFe5Yd4V5bSl9JOD0uMX9Cir5fZnmHCprtho/gT+2FzEaaI1QGe+tKUfFU1/5Nygdv/WpXwsUMXOCvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YSLHVEdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YSLHVEdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E5BC4CEF1;
	Sat,  6 Sep 2025 00:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757118419;
	bh=ITFpYIiZDVIX5puWxEDHynzUdVhPpguk43GCNGvcVGM=;
	h=Date:To:From:Subject:From;
	b=YSLHVEdQCY2iGPDibXTgkT4PumUTOT0GZZdDeOY/e6xoWBknDASwK2Lsdp7XW/Wim
	 OtfjBdMMaSnP5E/G4U+q6nHPw7pW1E3dHbw4TieGRvVlWBF7pXZeNKnBuCUKj3rV53
	 c/kz8KWV6zICAaT9ZyHYSxpO1doawj94S99/Ev8U=
Date: Fri, 05 Sep 2025 17:26:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch added to mm-new branch
Message-Id: <20250906002659.A9E5BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: always lock and check the swap cache folio before use
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch

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
Subject: mm, swap: always lock and check the swap cache folio before use
Date: Sat, 6 Sep 2025 03:13:47 +0800

Swap cache lookup only increases the reference count of the returned
folio.  That's not enough to ensure a folio is stable in the swap cache,
so the folio could be removed from the swap cache at any time.  The caller
should always lock and check the folio before using it.

We have just documented this in kerneldoc, now introduce a helper for swap
cache folio verification with proper sanity checks.

Also, sanitize a few current users to use this convention and the new
helper for easier debugging.  They were not having observable problems
yet, only trivial issues like wasted CPU cycles on swapoff or reclaiming. 
They would fail in some other way, but it is still better to always follow
this convention to make things robust and make later commits easier to do.

Link: https://lkml.kernel.org/r/20250905191357.78298-6-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
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

 mm/memory.c     |    3 +--
 mm/swap.h       |   24 ++++++++++++++++++++++++
 mm/swap_state.c |    7 +++++--
 mm/swapfile.c   |   10 +++++++---
 4 files changed, 37 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-swap-always-lock-and-check-the-swap-cache-folio-before-use
+++ a/mm/memory.c
@@ -4748,8 +4748,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		 * swapcache, we need to check that the page's swap has not
 		 * changed.
 		 */
-		if (unlikely(!folio_test_swapcache(folio) ||
-			     page_swap_entry(page).val != entry.val))
+		if (unlikely(!folio_matches_swap_entry(folio, entry)))
 			goto out_page;
 
 		if (unlikely(PageHWPoison(page))) {
--- a/mm/swapfile.c~mm-swap-always-lock-and-check-the-swap-cache-folio-before-use
+++ a/mm/swapfile.c
@@ -240,14 +240,12 @@ again:
 	 * Offset could point to the middle of a large folio, or folio
 	 * may no longer point to the expected offset before it's locked.
 	 */
-	if (offset < swp_offset(folio->swap) ||
-	    offset >= swp_offset(folio->swap) + nr_pages) {
+	if (!folio_matches_swap_entry(folio, entry)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		goto again;
 	}
 	offset = swp_offset(folio->swap);
-
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
 			((flags & TTRS_FULL) && mem_cgroup_swap_full(folio)));
@@ -2150,6 +2148,12 @@ static int unuse_pte_range(struct vm_are
 		}
 
 		folio_lock(folio);
+		if (!folio_matches_swap_entry(folio, entry)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			continue;
+		}
+
 		folio_wait_writeback(folio);
 		ret = unuse_pte(vma, pmd, addr, entry, folio);
 		if (ret < 0) {
--- a/mm/swap.h~mm-swap-always-lock-and-check-the-swap-cache-folio-before-use
+++ a/mm/swap.h
@@ -52,6 +52,25 @@ static inline pgoff_t swap_cache_index(s
 	return swp_offset(entry) & SWAP_ADDRESS_SPACE_MASK;
 }
 
+/**
+ * folio_matches_swap_entry - Check if a folio matches a given swap entry.
+ * @folio: The folio.
+ * @entry: The swap entry to check against.
+ *
+ * Context: The caller should have the folio locked to ensure it's stable
+ * and nothing will move it in or out of the swap cache.
+ * Return: true or false.
+ */
+static inline bool folio_matches_swap_entry(const struct folio *folio,
+					    swp_entry_t entry)
+{
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	if (!folio_test_swapcache(folio))
+		return false;
+	VM_WARN_ON_ONCE_FOLIO(!IS_ALIGNED(folio->swap.val, folio_nr_pages(folio)), folio);
+	return folio->swap.val == round_down(entry.val, folio_nr_pages(folio));
+}
+
 void show_swap_cache_info(void);
 void *get_shadow_from_swap_cache(swp_entry_t entry);
 int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
@@ -144,6 +163,11 @@ static inline pgoff_t swap_cache_index(s
 	return 0;
 }
 
+static inline bool folio_matches_swap_entry(const struct folio *folio, swp_entry_t entry)
+{
+	return false;
+}
+
 static inline void show_swap_cache_info(void)
 {
 }
--- a/mm/swap_state.c~mm-swap-always-lock-and-check-the-swap-cache-folio-before-use
+++ a/mm/swap_state.c
@@ -79,7 +79,7 @@ void show_swap_cache_info(void)
  * with reference count or locks.
  * Return: Returns the found folio on success, NULL otherwise. The caller
  * must lock and check if the folio still matches the swap entry before
- * use.
+ * use (e.g. with folio_matches_swap_entry).
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
@@ -346,7 +346,10 @@ struct folio *__read_swap_cache_async(sw
 	for (;;) {
 		int err;
 
-		/* Check the swap cache in case the folio is already there */
+		/*
+		 * Check the swap cache first, if a cached folio is found,
+		 * return it unlocked. The caller will lock and check it.
+		 */
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			goto got_folio;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-only-scan-one-cluster-in-fragment-list.patch
mm-swap-remove-fragment-clusters-counter.patch
mm-swap-prefer-nonfull-over-free-clusters.patch
mm-mincore-swap-consolidate-swap-cache-checking-for-mincore.patch
mm-mincore-use-a-helper-for-checking-the-swap-cache.patch
mm-page-writeback-drop-usage-of-folio_index.patch
mm-swap-use-unified-helper-for-swap-cache-look-up.patch
mm-swap-fix-swap-cahe-index-error-when-retrying-reclaim.patch
mm-swap-check-page-poison-flag-after-locking-it.patch
mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch
mm-swap-rename-and-move-some-swap-cluster-definition-and-helpers.patch
mm-swap-tidy-up-swap-device-and-cluster-info-helpers.patch
mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch
mm-swap-cleanup-swap-cache-api-and-add-kerneldoc.patch
mm-swap-wrap-swap-cache-replacement-with-a-helper.patch
mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api.patch
mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch
mm-swap-remove-contention-workaround-for-swap-cache.patch
mm-swap-implement-dynamic-allocation-of-swap-table.patch
mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch

