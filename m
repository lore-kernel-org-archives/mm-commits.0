Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DEA27F73A
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754958272; cv=none; b=REB2Q2ZV93iJJ6WXM/mHK/yrojFhaKsQytlziuqIbo7V5NNBdWsrmTTMHGoOevWP61StC3QcHFR0SdzYg34zBXvJmnT6XHyV5PeWfPm8G9YnBVYbKDXtaTDtlyZtig1MOp4DxKF5brkqEg9xbbi9x773PoaBzFLLII1VKTwHTfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754958272; c=relaxed/simple;
	bh=UHPu3Ef9ALLeW4XQmeTTEcdpc3dTCb49kxbMtg9SbqU=;
	h=Date:To:From:Subject:Message-Id; b=YFpx9ARHhv2/YVEqtQTt6d2+PeLk6k4u7NQxWTc1o/wK1a+EDmZIq07fUyM9jAGVcmkpIJt5ITZ4EfVMyCxyFKC2UYQ++yLxyl7TRRnDuH9f1GRt0AEk8+fNdPzcwq7vS9wPHq8180rsbG+NEKxc52cpHb9nRpMmQVFFGSxto6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LePgzYhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LePgzYhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AC5C4CEED;
	Tue, 12 Aug 2025 00:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754958271;
	bh=UHPu3Ef9ALLeW4XQmeTTEcdpc3dTCb49kxbMtg9SbqU=;
	h=Date:To:From:Subject:From;
	b=LePgzYhHKdU5CPnxsWr76JKzBZqEHYBihiCxo4//LptjzGv0xIBAaKbhw+Ty6iWv9
	 6cDCL9kquS8BmxFXOwyrjiOvOHOS/U3XO20FScS4R72XXPwR18/z0fF3Sly84kMmQ2
	 rTddyDMY18yZtsoUn9yZNTWQWdZmCbl3Jb47IrhE=
Date: Mon, 11 Aug 2025 17:24:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shikemeng@huaweicloud.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-swap-consolidate-swap-cache-checking-for-mincore.patch added to mm-new branch
Message-Id: <20250812002431.36AC5C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mincore, swap: consolidate swap cache checking for mincore
has been added to the -mm mm-new branch.  Its filename is
     mm-mincore-swap-consolidate-swap-cache-checking-for-mincore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-swap-consolidate-swap-cache-checking-for-mincore.patch

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
Subject: mm/mincore, swap: consolidate swap cache checking for mincore
Date: Tue, 12 Aug 2025 01:20:17 +0800

Patch series "mm/mincore: minor clean up for swap cache checking".

This series cleans up a swap cache helper only used by mincore, move it
back into mincore code.  Also separate the swap cache related logics out
of shmem / page cache logics in mincore.

With this series we have less lines of code and better performance.

Before this series:
mincore on a swaped out 16G anon mmap range:
Took 488220 us
mincore on 16G shmem mmap range:
Took 530272 us.

After this series:
mincore on a swaped out 16G anon mmap range:
Took 446763 us
mincore on 16G shmem mmap range:
Took 460496 us.

About ~10% faster.


This patch (of 2):

The filemap_get_incore_folio (previously find_get_incore_page) helper was
introduced by commit 61ef18655704 ("mm: factor find_get_incore_page out of
mincore_page") to be used by later commit f5df8635c5a3 ("mm: use
find_get_incore_page in memcontrol"), so memory cgroup charge move code
can be simplified.

But commit 6b611388b626 ("memcg-v1: remove charge move code") removed that
user completely, it's only used by mincore now.

So this commit basically reverts commit 61ef18655704 ("mm: factor
find_get_incore_page out of mincore_page").  Move it back to mincore side
to simplify the code.

Link: https://lkml.kernel.org/r/20250811172018.48901-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20250811172018.48901-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c    |   29 +++++++++++++++++++++++++++--
 mm/swap.h       |   10 ----------
 mm/swap_state.c |   38 --------------------------------------
 3 files changed, 27 insertions(+), 50 deletions(-)

--- a/mm/mincore.c~mm-mincore-swap-consolidate-swap-cache-checking-for-mincore
+++ a/mm/mincore.c
@@ -64,8 +64,33 @@ static unsigned char mincore_page(struct
 	 * any other file mapping (ie. marked !present and faulted in with
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
-	folio = filemap_get_incore_folio(mapping, index);
-	if (!IS_ERR(folio)) {
+	if (IS_ENABLED(CONFIG_SWAP) && shmem_mapping(mapping)) {
+		folio = filemap_get_entry(mapping, index);
+		/*
+		 * shmem/tmpfs may return swap: account for swapcache
+		 * page too.
+		 */
+		if (xa_is_value(folio)) {
+			struct swap_info_struct *si;
+			swp_entry_t swp = radix_to_swp_entry(folio);
+			/* There might be swapin error entries in shmem mapping. */
+			if (non_swap_entry(swp))
+				return 0;
+			/* Prevent swap device to being swapoff under us */
+			si = get_swap_device(swp);
+			if (si) {
+				folio = filemap_get_folio(swap_address_space(swp),
+							  swap_cache_index(swp));
+				put_swap_device(si);
+			} else {
+				return 0;
+			}
+		}
+	} else {
+		folio = filemap_get_folio(mapping, index);
+	}
+
+	if (!IS_ERR_OR_NULL(folio)) {
 		present = folio_test_uptodate(folio);
 		folio_put(folio);
 	}
--- a/mm/swap.h~mm-mincore-swap-consolidate-swap-cache-checking-for-mincore
+++ a/mm/swap.h
@@ -64,9 +64,6 @@ void clear_shadow_from_swap_cache(int ty
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
 struct folio *swap_cache_get_folio(swp_entry_t entry,
 		struct vm_area_struct *vma, unsigned long addr);
-struct folio *filemap_get_incore_folio(struct address_space *mapping,
-		pgoff_t index);
-
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug);
@@ -178,13 +175,6 @@ static inline struct folio *swap_cache_g
 	return NULL;
 }
 
-static inline
-struct folio *filemap_get_incore_folio(struct address_space *mapping,
-		pgoff_t index)
-{
-	return filemap_get_folio(mapping, index);
-}
-
 static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
 {
 	return NULL;
--- a/mm/swap_state.c~mm-mincore-swap-consolidate-swap-cache-checking-for-mincore
+++ a/mm/swap_state.c
@@ -323,44 +323,6 @@ struct folio *swap_cache_get_folio(swp_e
 	return folio;
 }
 
-/**
- * filemap_get_incore_folio - Find and get a folio from the page or swap caches.
- * @mapping: The address_space to search.
- * @index: The page cache index.
- *
- * This differs from filemap_get_folio() in that it will also look for the
- * folio in the swap cache.
- *
- * Return: The found folio or %NULL.
- */
-struct folio *filemap_get_incore_folio(struct address_space *mapping,
-		pgoff_t index)
-{
-	swp_entry_t swp;
-	struct swap_info_struct *si;
-	struct folio *folio = filemap_get_entry(mapping, index);
-
-	if (!folio)
-		return ERR_PTR(-ENOENT);
-	if (!xa_is_value(folio))
-		return folio;
-	if (!shmem_mapping(mapping))
-		return ERR_PTR(-ENOENT);
-
-	swp = radix_to_swp_entry(folio);
-	/* There might be swapin error entries in shmem mapping. */
-	if (non_swap_entry(swp))
-		return ERR_PTR(-ENOENT);
-	/* Prevent swapoff from happening to us */
-	si = get_swap_device(swp);
-	if (!si)
-		return ERR_PTR(-ENOENT);
-	index = swap_cache_index(swp);
-	folio = filemap_get_folio(swap_address_space(swp), index);
-	put_swap_device(si);
-	return folio;
-}
-
 struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
 		bool skip_if_exists)
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-only-scan-one-cluster-in-fragment-list.patch
mm-swap-remove-fragment-clusters-counter.patch
mm-swap-prefer-nonfull-over-free-clusters.patch
mm-mincore-swap-consolidate-swap-cache-checking-for-mincore.patch
mm-mincore-use-a-helper-for-checking-the-swap-cache.patch

