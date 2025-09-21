Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79D22BDC16
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489938; cv=none; b=AvzY+iEHO+KTEUIj66ux4wRzlQ409TUNeKPl63jC6o17eoR8tFxK6FI+w12vCDVsvqIIRMZov8kOD/e8IIHkfsYT91/d28h4Xl84rwufpgJiml89OyKXYlP0QAn4PtCi0OiS6I7Kh0EkJ4A2wwx57Y+VJBLkL3XXSDJSVC8d0Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489938; c=relaxed/simple;
	bh=RNFax1KkpRSGCir+DSDCae+m02txLxoowmWWKQlH08Q=;
	h=Date:To:From:Subject:Message-Id; b=dKIZ/uPTlRPp8+PuId5kCfgCkNVQeLss5iRL6Fq6HKFPgjGguoXdquORHo8Yt9K64l6N2DR8DNRzSKY4GV/ZtA5plvbfO9998wSbTeNfTP6NJilMYszYeYUkDobiz3+ePx0eyfYC36KKvF9Oy1P8hSBAdjq/H0t1afweJ+l64/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Md5HPAzq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Md5HPAzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8873C4CEE7;
	Sun, 21 Sep 2025 21:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489937;
	bh=RNFax1KkpRSGCir+DSDCae+m02txLxoowmWWKQlH08Q=;
	h=Date:To:From:Subject:From;
	b=Md5HPAzqtgOQQs1xb2zofxXl/4mNKpfDnSfPY+rNqZwCHPJG0DxqjNliYYi9uC6jn
	 8BLUAIAEOoqlaI79K4vGwCnCNjC7PcGQ8uRpLvGGDbGrIbiIVMi58RRrx2tibjNYKq
	 K6qjSLhrq93+PJAkqS7Z3adhrOPP2pKPo04i4W8s=
Date: Sun, 21 Sep 2025 14:25:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,sj@kernel.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch removed from -mm tree
Message-Id: <20250921212537.B8873C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: always lock and check the swap cache folio before use
has been removed from the -mm tree.  Its filename was
     mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
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


