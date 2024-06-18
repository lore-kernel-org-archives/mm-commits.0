Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B13C53E24
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 20:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718742737; cv=none; b=D+J+m8D7G3gna4DJO/1wfnGqsd0lSHMxEeWYjOx1kmRS5uJhTcT4yXr5V1osYJ03RJdzBGSxlVJKHZJtCV+fyLGgVznM7c47iS3JNrHznSuCxX3d7xCRDgcFMEJ47B50TMi8mmkHzF+bR9hUZL5gO0jAWxkp5tuRtAGNV2+4Tx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718742737; c=relaxed/simple;
	bh=U5OUS6fYX3O08OVeBi69I+7zlmAosVWJRdDvKRbd2cw=;
	h=Date:To:From:Subject:Message-Id; b=uOhEEvLanSWp9Yueg3H831F5gCa5lsTGOiSHycDBGdB18Vh8GwpMFucf4oyIsDicT+X6mFpnxLhggzAY8+5az+9JRoY6jJZH0IAAGbB27iP372Xn2Fs9CYdWeBMgf4EIKk1kmtFAd8b2GzP8rW0ChsVV1y3Q/7jARO76fjVBdWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=utQja4Tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="utQja4Tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B563C3277B;
	Tue, 18 Jun 2024 20:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718742737;
	bh=U5OUS6fYX3O08OVeBi69I+7zlmAosVWJRdDvKRbd2cw=;
	h=Date:To:From:Subject:From;
	b=utQja4TjiTpmkSIKSoaKapw/ol7+J6l7XgvX2Ju1BcdKAk/c4WJcmeEPcjQyRNW7P
	 2wWomdveJu1tjj4Q/hGcnOfLctdR4sqMriWo7UhdeB8dXZGZenhczl9dYKuJKYc3J7
	 usd4ycScMj9Itn3gjFNkrGQZ4rmhneRJESXxv04I=
Date: Tue, 18 Jun 2024 13:32:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch added to mm-unstable branch
Message-Id: <20240618203217.1B563C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: extend swap_shmem_alloc() to support batch SWAP_MAP_SHMEM flag setting
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: swap: extend swap_shmem_alloc() to support batch SWAP_MAP_SHMEM flag setting
Date: Tue, 18 Jun 2024 14:54:14 +0800

To support shmem large folio swap operations, add a new parameter to
swap_shmem_alloc() that allows batch SWAP_MAP_SHMEM flag setting for shmem
swap entries.

While we are at it, use folio_nr_pages() to get the number of pages of the
folio as preparation.

Link: https://lkml.kernel.org/r/4909c4bf2f28665c6a35cd7e77990c5defc3d7fb.1718690645.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 -
 mm/shmem.c           |    6 +-
 mm/swapfile.c        |   98 +++++++++++++++++++++--------------------
 3 files changed, 57 insertions(+), 51 deletions(-)

--- a/include/linux/swap.h~mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting
+++ a/include/linux/swap.h
@@ -475,7 +475,7 @@ void put_swap_folio(struct folio *folio,
 extern swp_entry_t get_swap_page_of_type(int);
 extern int get_swap_pages(int n, swp_entry_t swp_entries[], int order);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
-extern void swap_shmem_alloc(swp_entry_t);
+extern void swap_shmem_alloc(swp_entry_t, int);
 extern int swap_duplicate(swp_entry_t);
 extern int swapcache_prepare(swp_entry_t);
 extern void swap_free_nr(swp_entry_t entry, int nr_pages);
@@ -542,7 +542,7 @@ static inline int add_swap_count_continu
 	return 0;
 }
 
-static inline void swap_shmem_alloc(swp_entry_t swp)
+static inline void swap_shmem_alloc(swp_entry_t swp, int nr)
 {
 }
 
--- a/mm/shmem.c~mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting
+++ a/mm/shmem.c
@@ -1432,6 +1432,7 @@ static int shmem_writepage(struct page *
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	swp_entry_t swap;
 	pgoff_t index;
+	int nr_pages;
 
 	/*
 	 * Our capabilities prevent regular writeback or sync from ever calling
@@ -1464,6 +1465,7 @@ static int shmem_writepage(struct page *
 	}
 
 	index = folio->index;
+	nr_pages = folio_nr_pages(folio);
 
 	/*
 	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC
@@ -1516,8 +1518,8 @@ static int shmem_writepage(struct page *
 	if (add_to_swap_cache(folio, swap,
 			__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN,
 			NULL) == 0) {
-		shmem_recalc_inode(inode, 0, 1);
-		swap_shmem_alloc(swap);
+		shmem_recalc_inode(inode, 0, nr_pages);
+		swap_shmem_alloc(swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(swap));
 
 		mutex_unlock(&shmem_swaplist_mutex);
--- a/mm/swapfile.c~mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting
+++ a/mm/swapfile.c
@@ -3377,62 +3377,58 @@ void si_swapinfo(struct sysinfo *val)
  * - swap-cache reference is requested but the entry is not used. -> ENOENT
  * - swap-mapped reference requested but needs continued swap count. -> ENOMEM
  */
-static int __swap_duplicate(swp_entry_t entry, unsigned char usage)
+static int __swap_duplicate(struct swap_info_struct *p, unsigned long offset,
+			    int nr, unsigned char usage)
 {
-	struct swap_info_struct *p;
 	struct swap_cluster_info *ci;
-	unsigned long offset;
 	unsigned char count;
 	unsigned char has_cache;
-	int err;
+	int err, i;
 
-	p = swp_swap_info(entry);
-
-	offset = swp_offset(entry);
 	ci = lock_cluster_or_swap_info(p, offset);
 
-	count = p->swap_map[offset];
-
-	/*
-	 * swapin_readahead() doesn't check if a swap entry is valid, so the
-	 * swap entry could be SWAP_MAP_BAD. Check here with lock held.
-	 */
-	if (unlikely(swap_count(count) == SWAP_MAP_BAD)) {
-		err = -ENOENT;
-		goto unlock_out;
-	}
+	for (i = 0; i < nr; i++) {
+		count = p->swap_map[offset + i];
 
-	has_cache = count & SWAP_HAS_CACHE;
-	count &= ~SWAP_HAS_CACHE;
-	err = 0;
-
-	if (usage == SWAP_HAS_CACHE) {
-
-		/* set SWAP_HAS_CACHE if there is no cache and entry is used */
-		if (!has_cache && count)
-			has_cache = SWAP_HAS_CACHE;
-		else if (has_cache)		/* someone else added cache */
-			err = -EEXIST;
-		else				/* no users remaining */
+		/*
+		 * swapin_readahead() doesn't check if a swap entry is valid, so the
+		 * swap entry could be SWAP_MAP_BAD. Check here with lock held.
+		 */
+		if (unlikely(swap_count(count) == SWAP_MAP_BAD)) {
 			err = -ENOENT;
+			break;
+		}
 
-	} else if (count || has_cache) {
+		has_cache = count & SWAP_HAS_CACHE;
+		count &= ~SWAP_HAS_CACHE;
+		err = 0;
+
+		if (usage == SWAP_HAS_CACHE) {
+			/* set SWAP_HAS_CACHE if there is no cache and entry is used */
+			if (!has_cache && count)
+				has_cache = SWAP_HAS_CACHE;
+			else if (has_cache)		/* someone else added cache */
+				err = -EEXIST;
+			else				/* no users remaining */
+				err = -ENOENT;
+		} else if (count || has_cache) {
+			if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
+				count += usage;
+			else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX)
+				err = -EINVAL;
+			else if (swap_count_continued(p, offset + i, count))
+				count = COUNT_CONTINUED;
+			else
+				err = -ENOMEM;
+		} else
+			err = -ENOENT;			/* unused swap entry */
 
-		if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
-			count += usage;
-		else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX)
-			err = -EINVAL;
-		else if (swap_count_continued(p, offset, count))
-			count = COUNT_CONTINUED;
-		else
-			err = -ENOMEM;
-	} else
-		err = -ENOENT;			/* unused swap entry */
+		if (err)
+			break;
 
-	if (!err)
-		WRITE_ONCE(p->swap_map[offset], count | has_cache);
+		WRITE_ONCE(p->swap_map[offset + i], count | has_cache);
+	}
 
-unlock_out:
 	unlock_cluster_or_swap_info(p, ci);
 	return err;
 }
@@ -3441,9 +3437,12 @@ unlock_out:
  * Help swapoff by noting that swap entry belongs to shmem/tmpfs
  * (in which case its reference count is never incremented).
  */
-void swap_shmem_alloc(swp_entry_t entry)
+void swap_shmem_alloc(swp_entry_t entry, int nr)
 {
-	__swap_duplicate(entry, SWAP_MAP_SHMEM);
+	struct swap_info_struct *p = swp_swap_info(entry);
+	unsigned long offset = swp_offset(entry);
+
+	__swap_duplicate(p, offset, nr, SWAP_MAP_SHMEM);
 }
 
 /*
@@ -3455,9 +3454,11 @@ void swap_shmem_alloc(swp_entry_t entry)
  */
 int swap_duplicate(swp_entry_t entry)
 {
+	struct swap_info_struct *p = swp_swap_info(entry);
+	unsigned long offset = swp_offset(entry);
 	int err = 0;
 
-	while (!err && __swap_duplicate(entry, 1) == -ENOMEM)
+	while (!err && __swap_duplicate(p, offset, 1, 1) == -ENOMEM)
 		err = add_swap_count_continuation(entry, GFP_ATOMIC);
 	return err;
 }
@@ -3472,7 +3473,10 @@ int swap_duplicate(swp_entry_t entry)
  */
 int swapcache_prepare(swp_entry_t entry)
 {
-	return __swap_duplicate(entry, SWAP_HAS_CACHE);
+	struct swap_info_struct *p = swp_swap_info(entry);
+	unsigned long offset = swp_offset(entry);
+
+	return __swap_duplicate(p, offset, 1, SWAP_HAS_CACHE);
 }
 
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch
mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch
mm-vmscan-add-validation-before-spliting-shmem-large-folio.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-support-large-folio-swap-out.patch

