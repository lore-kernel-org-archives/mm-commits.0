Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F1917E4
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 00:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757118411; cv=none; b=RySve5CIuluTXa8h/wd3yeOCz0bt1wwL1KCzapbn4bHg6fq3rgF0Q0xrWodpc6bTfDwc3gweZVslQjHY7j53Z2lie+vBPIDymYnJLu8a4Mt5iycMJbR1b6K1HqE3oOVe0n/JnCUwyEObOBYdn6qym0PTRsdVGVJFPYQ8807+4/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757118411; c=relaxed/simple;
	bh=NQa65KqhLEVLUGh34bDM7suAoSXN9CANlidKUtB7qFU=;
	h=Date:To:From:Subject:Message-Id; b=oQ5ELy03kUDYZCKffAQOqaK2xM+n9LgaHqdYNJCnOWyD5+sbKzaj30yfUYRwsq/vTKu1Ie7YST0Udc30aIp6Y4ggvikPuUpioT7OiKJ+9giq4YKIOr29sZhdwX271rU438GrN9ID6fRS+yNUrHXkQsAT/mf2Bn+mYkQTLgQspSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h8VoICZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h8VoICZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDAAC4CEF1;
	Sat,  6 Sep 2025 00:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757118410;
	bh=NQa65KqhLEVLUGh34bDM7suAoSXN9CANlidKUtB7qFU=;
	h=Date:To:From:Subject:From;
	b=h8VoICZS/GPi/7wkW/t4aPATVlDNCdy1akGUBLLeUirfD2D6Fh0f/pOme2PVx3OuS
	 d6SwHMQzJFpXGSYT+LPq8rga2aM79M+xpNgLt2jyVDavHftnehyOD2S70e05Y5NGSv
	 p9Bpw9AS6H+f3jJmVRcda5jiQ220lRhaDrCXoVmM=
Date: Fri, 05 Sep 2025 17:26:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-unified-helper-for-swap-cache-look-up.patch added to mm-new branch
Message-Id: <20250906002650.7DDAAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: use unified helper for swap cache look up
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-use-unified-helper-for-swap-cache-look-up.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-unified-helper-for-swap-cache-look-up.patch

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
Subject: mm, swap: use unified helper for swap cache look up
Date: Sat, 6 Sep 2025 03:13:44 +0800

The swap cache lookup helper swap_cache_get_folio currently does readahead
updates as well, so callers that are not doing swapin from any VMA or
mapping are forced to reuse filemap helpers instead, and have to access
the swap cache space directly.

So decouple readahead update with swap cache lookup.  Move the readahead
update part into a standalone helper.  Let the caller call the readahead
update helper if they do readahead.  And convert all swap cache lookups to
use swap_cache_get_folio.

After this commit, there are only three special cases for accessing swap
cache space now: huge memory splitting, migration, and shmem replacing,
because they need to lock the XArray.  The following commits will wrap
their accesses to the swap cache too, with special helpers.

And worth noting, currently dropbehind is not supported for anon folio,
and we will never see a dropbehind folio in swap cache.  The unified
helper can be updated later to handle that.

While at it, add proper kernedoc for touched helpers.

No functional change.

Link: https://lkml.kernel.org/r/20250905191357.78298-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
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

 mm/memory.c      |    6 +-
 mm/mincore.c     |    3 -
 mm/shmem.c       |    4 +
 mm/swap.h        |   13 +++--
 mm/swap_state.c  |  109 +++++++++++++++++++++++----------------------
 mm/swapfile.c    |   11 ++--
 mm/userfaultfd.c |    5 --
 7 files changed, 81 insertions(+), 70 deletions(-)

--- a/mm/memory.c~mm-swap-use-unified-helper-for-swap-cache-look-up
+++ a/mm/memory.c
@@ -4660,9 +4660,11 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (unlikely(!si))
 		goto out;
 
-	folio = swap_cache_get_folio(entry, vma, vmf->address);
-	if (folio)
+	folio = swap_cache_get_folio(entry);
+	if (folio) {
+		swap_update_readahead(folio, vma, vmf->address);
 		page = folio_file_page(folio, swp_offset(entry));
+	}
 	swapcache = folio;
 
 	if (!folio) {
--- a/mm/mincore.c~mm-swap-use-unified-helper-for-swap-cache-look-up
+++ a/mm/mincore.c
@@ -76,8 +76,7 @@ static unsigned char mincore_swap(swp_en
 		if (!si)
 			return 0;
 	}
-	folio = filemap_get_entry(swap_address_space(entry),
-				  swap_cache_index(entry));
+	folio = swap_cache_get_folio(entry);
 	if (shmem)
 		put_swap_device(si);
 	/* The swap cache space contains either folio, shadow or NULL */
--- a/mm/shmem.c~mm-swap-use-unified-helper-for-swap-cache-look-up
+++ a/mm/shmem.c
@@ -2317,7 +2317,7 @@ static int shmem_swapin_folio(struct ino
 	}
 
 	/* Look it up and read it in.. */
-	folio = swap_cache_get_folio(swap, NULL, 0);
+	folio = swap_cache_get_folio(swap);
 	if (!folio) {
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct swapin skipping swap cache & readahead */
@@ -2342,6 +2342,8 @@ static int shmem_swapin_folio(struct ino
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
+	} else {
+		swap_update_readahead(folio, NULL, 0);
 	}
 
 	if (order > folio_order(folio)) {
--- a/mm/swapfile.c~mm-swap-use-unified-helper-for-swap-cache-look-up
+++ a/mm/swapfile.c
@@ -213,15 +213,14 @@ static int __try_to_reclaim_swap(struct
 				 unsigned long offset, unsigned long flags)
 {
 	swp_entry_t entry = swp_entry(si->type, offset);
-	struct address_space *address_space = swap_address_space(entry);
 	struct swap_cluster_info *ci;
 	struct folio *folio;
 	int ret, nr_pages;
 	bool need_reclaim;
 
 again:
-	folio = filemap_get_folio(address_space, swap_cache_index(entry));
-	if (IS_ERR(folio))
+	folio = swap_cache_get_folio(entry);
+	if (!folio)
 		return 0;
 
 	nr_pages = folio_nr_pages(folio);
@@ -2131,7 +2130,7 @@ static int unuse_pte_range(struct vm_are
 		pte_unmap(pte);
 		pte = NULL;
 
-		folio = swap_cache_get_folio(entry, vma, addr);
+		folio = swap_cache_get_folio(entry);
 		if (!folio) {
 			struct vm_fault vmf = {
 				.vma = vma,
@@ -2357,8 +2356,8 @@ retry:
 	       (i = find_next_to_unuse(si, i)) != 0) {
 
 		entry = swp_entry(type, i);
-		folio = filemap_get_folio(swap_address_space(entry), swap_cache_index(entry));
-		if (IS_ERR(folio))
+		folio = swap_cache_get_folio(entry);
+		if (!folio)
 			continue;
 
 		/*
--- a/mm/swap.h~mm-swap-use-unified-helper-for-swap-cache-look-up
+++ a/mm/swap.h
@@ -62,8 +62,7 @@ void delete_from_swap_cache(struct folio
 void clear_shadow_from_swap_cache(int type, unsigned long begin,
 				  unsigned long end);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
-struct folio *swap_cache_get_folio(swp_entry_t entry,
-		struct vm_area_struct *vma, unsigned long addr);
+struct folio *swap_cache_get_folio(swp_entry_t entry);
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug);
@@ -74,6 +73,8 @@ struct folio *swap_cluster_readahead(swp
 		struct mempolicy *mpol, pgoff_t ilx);
 struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
 		struct vm_fault *vmf);
+void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
+			   unsigned long addr);
 
 static inline unsigned int folio_swap_flags(struct folio *folio)
 {
@@ -159,6 +160,11 @@ static inline struct folio *swapin_reada
 	return NULL;
 }
 
+static inline void swap_update_readahead(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+}
+
 static inline int swap_writeout(struct folio *folio,
 		struct swap_iocb **swap_plug)
 {
@@ -169,8 +175,7 @@ static inline void swapcache_clear(struc
 {
 }
 
-static inline struct folio *swap_cache_get_folio(swp_entry_t entry,
-		struct vm_area_struct *vma, unsigned long addr)
+static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
 	return NULL;
 }
--- a/mm/swap_state.c~mm-swap-use-unified-helper-for-swap-cache-look-up
+++ a/mm/swap_state.c
@@ -69,6 +69,27 @@ void show_swap_cache_info(void)
 	printk("Total swap = %lukB\n", K(total_swap_pages));
 }
 
+/**
+ * swap_cache_get_folio - Looks up a folio in the swap cache.
+ * @entry: swap entry used for the lookup.
+ *
+ * A found folio will be returned unlocked and with its refcount increased.
+ *
+ * Context: Caller must ensure @entry is valid and protect the swap device
+ * with reference count or locks.
+ * Return: Returns the found folio on success, NULL otherwise. The caller
+ * must lock and check if the folio still matches the swap entry before
+ * use.
+ */
+struct folio *swap_cache_get_folio(swp_entry_t entry)
+{
+	struct folio *folio = filemap_get_folio(swap_address_space(entry),
+						swap_cache_index(entry));
+	if (IS_ERR(folio))
+		return NULL;
+	return folio;
+}
+
 void *get_shadow_from_swap_cache(swp_entry_t entry)
 {
 	struct address_space *address_space = swap_address_space(entry);
@@ -272,55 +293,43 @@ static inline bool swap_use_vma_readahea
 	return READ_ONCE(enable_vma_readahead) && !atomic_read(&nr_rotate_swap);
 }
 
-/*
- * Lookup a swap entry in the swap cache. A found folio will be returned
- * unlocked and with its refcount incremented - we rely on the kernel
- * lock getting page table operations atomic even if we drop the folio
- * lock before returning.
- *
- * Caller must lock the swap device or hold a reference to keep it valid.
+/**
+ * swap_update_readahead - Update the readahead statistics of VMA or globally.
+ * @folio: the swap cache folio that just got hit.
+ * @vma: the VMA that should be updated, could be NULL for global update.
+ * @addr: the addr that triggered the swapin, ignored if @vma is NULL.
  */
-struct folio *swap_cache_get_folio(swp_entry_t entry,
-		struct vm_area_struct *vma, unsigned long addr)
+void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
+			   unsigned long addr)
 {
-	struct folio *folio;
+	bool readahead, vma_ra = swap_use_vma_readahead();
 
-	folio = filemap_get_folio(swap_address_space(entry), swap_cache_index(entry));
-	if (!IS_ERR(folio)) {
-		bool vma_ra = swap_use_vma_readahead();
-		bool readahead;
-
-		/*
-		 * At the moment, we don't support PG_readahead for anon THP
-		 * so let's bail out rather than confusing the readahead stat.
-		 */
-		if (unlikely(folio_test_large(folio)))
-			return folio;
-
-		readahead = folio_test_clear_readahead(folio);
-		if (vma && vma_ra) {
-			unsigned long ra_val;
-			int win, hits;
-
-			ra_val = GET_SWAP_RA_VAL(vma);
-			win = SWAP_RA_WIN(ra_val);
-			hits = SWAP_RA_HITS(ra_val);
-			if (readahead)
-				hits = min_t(int, hits + 1, SWAP_RA_HITS_MAX);
-			atomic_long_set(&vma->swap_readahead_info,
-					SWAP_RA_VAL(addr, win, hits));
-		}
-
-		if (readahead) {
-			count_vm_event(SWAP_RA_HIT);
-			if (!vma || !vma_ra)
-				atomic_inc(&swapin_readahead_hits);
-		}
-	} else {
-		folio = NULL;
+	/*
+	 * At the moment, we don't support PG_readahead for anon THP
+	 * so let's bail out rather than confusing the readahead stat.
+	 */
+	if (unlikely(folio_test_large(folio)))
+		return;
+
+	readahead = folio_test_clear_readahead(folio);
+	if (vma && vma_ra) {
+		unsigned long ra_val;
+		int win, hits;
+
+		ra_val = GET_SWAP_RA_VAL(vma);
+		win = SWAP_RA_WIN(ra_val);
+		hits = SWAP_RA_HITS(ra_val);
+		if (readahead)
+			hits = min_t(int, hits + 1, SWAP_RA_HITS_MAX);
+		atomic_long_set(&vma->swap_readahead_info,
+				SWAP_RA_VAL(addr, win, hits));
 	}
 
-	return folio;
+	if (readahead) {
+		count_vm_event(SWAP_RA_HIT);
+		if (!vma || !vma_ra)
+			atomic_inc(&swapin_readahead_hits);
+	}
 }
 
 struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
@@ -336,14 +345,10 @@ struct folio *__read_swap_cache_async(sw
 	*new_page_allocated = false;
 	for (;;) {
 		int err;
-		/*
-		 * First check the swap cache.  Since this is normally
-		 * called after swap_cache_get_folio() failed, re-calling
-		 * that would confuse statistics.
-		 */
-		folio = filemap_get_folio(swap_address_space(entry),
-					  swap_cache_index(entry));
-		if (!IS_ERR(folio))
+
+		/* Check the swap cache in case the folio is already there */
+		folio = swap_cache_get_folio(entry);
+		if (folio)
 			goto got_folio;
 
 		/*
--- a/mm/userfaultfd.c~mm-swap-use-unified-helper-for-swap-cache-look-up
+++ a/mm/userfaultfd.c
@@ -1489,9 +1489,8 @@ retry:
 		 * separately to allow proper handling.
 		 */
 		if (!src_folio)
-			folio = filemap_get_folio(swap_address_space(entry),
-					swap_cache_index(entry));
-		if (!IS_ERR_OR_NULL(folio)) {
+			folio = swap_cache_get_folio(entry);
+		if (folio) {
 			if (folio_test_large(folio)) {
 				ret = -EBUSY;
 				folio_put(folio);
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

