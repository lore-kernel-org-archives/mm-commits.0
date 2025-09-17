Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418D41CAA65
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 01:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758071150; cv=none; b=AXPZPx12IiOEStL+DIV3BOjlwMz/GElpV5q7LAHLyS14fyc22XixbOEScXAlozjN8B7we2sehkmOTrUsefAlzZAum040meG325AOvvvXlVnHlhC0plENCxEvNdNTCaJLnxMlen96BsHoJ60bgSbNlcMBJ4vFe1WDN1blq5O0xrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758071150; c=relaxed/simple;
	bh=RW4R27WWCCRaM7DjNO9wTMdgnbe2cO+MJh0a7yujDgI=;
	h=Date:To:From:Subject:Message-Id; b=WpcNIrwQcL1Zdp4JjadoxXobd7aVKZG3mpHtLgG2Rs+2qxYwPEGQafq+wxp+hjgQ50w2Pyc5zVCzIFcYTtH9DVaZMV24TpJsKlSsidY9chmg7AVmWFCPQSAFT/g7sfzUDSrUJC9et+sseZ8SPXoiUKslzXaOk/dXovH6oX8vDus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0OpKsMSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0OpKsMSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64C6C4CEEB;
	Wed, 17 Sep 2025 01:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758071149;
	bh=RW4R27WWCCRaM7DjNO9wTMdgnbe2cO+MJh0a7yujDgI=;
	h=Date:To:From:Subject:From;
	b=0OpKsMSH6JfL5aHip2HfyDIZ1YG0jzcaA3ZuBJDaJdjkuIGccpTLs8IoRnmK7KoLH
	 F9W0p8ADlkx6L0rhMzUvv3FWwnXGeyA9SrhgcokPmBwN1elsn7ZSqf3kScjY4ZYwhP
	 oa2VnXGzaASF5f8jSvwFefNLlwSovd0KgO02F6Gc=
Date: Tue, 16 Sep 2025 18:05:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch added to mm-unstable branch
Message-Id: <20250917010549.B64C6C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: always lock and check the swap cache folio before use
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch

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
Subject: mm, swap: always lock and check the swap cache folio before use
Date: Wed, 17 Sep 2025 00:00:50 +0800

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

Link: https://lkml.kernel.org/r/20250916160100.31545-6-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
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
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c     |    3 +--
 mm/swap.h       |   27 +++++++++++++++++++++++++++
 mm/swap_state.c |    7 +++++--
 mm/swapfile.c   |   10 ++++++++--
 4 files changed, 41 insertions(+), 6 deletions(-)

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
@@ -240,8 +240,7 @@ again:
 	 * Offset could point to the middle of a large folio, or folio
 	 * may no longer point to the expected offset before it's locked.
 	 */
-	if (offset < swp_offset(folio->swap) ||
-	    offset >= swp_offset(folio->swap) + nr_pages) {
+	if (!folio_matches_swap_entry(folio, entry)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		goto again;
@@ -2004,6 +2003,13 @@ static int unuse_pte(struct vm_area_stru
 	bool hwpoisoned = false;
 	int ret = 1;
 
+	/*
+	 * If the folio is removed from swap cache by others, continue to
+	 * unuse other PTEs. try_to_unuse may try again if we missed this one.
+	 */
+	if (!folio_matches_swap_entry(folio, entry))
+		return 0;
+
 	swapcache = folio;
 	folio = ksm_might_need_to_copy(folio, vma, addr);
 	if (unlikely(!folio))
--- a/mm/swap.h~mm-swap-always-lock-and-check-the-swap-cache-folio-before-use
+++ a/mm/swap.h
@@ -52,6 +52,28 @@ static inline pgoff_t swap_cache_index(s
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
+	swp_entry_t folio_entry = folio->swap;
+	long nr_pages = folio_nr_pages(folio);
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	if (!folio_test_swapcache(folio))
+		return false;
+	VM_WARN_ON_ONCE_FOLIO(!IS_ALIGNED(folio_entry.val, nr_pages), folio);
+	return folio_entry.val == round_down(entry.val, nr_pages);
+}
+
 void show_swap_cache_info(void);
 void *get_shadow_from_swap_cache(swp_entry_t entry);
 int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
@@ -144,6 +166,11 @@ static inline pgoff_t swap_cache_index(s
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

