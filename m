Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C535112D758
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 21:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749589726; cv=none; b=AVegTAhl4JQeZfaRQsxiPTN6rrl3BsNltW261T2jFIYQ/mKnSz+oXZP+awufzuLWiR90NU6hmJZd1yk+0aq794ZsTtiI3zTwWFXPxhfBwf6CYsgevfVuKCprap29KohJ30GiokEMfw2F5+ghlTl1pom8UxzwX+psOFTib+08u1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749589726; c=relaxed/simple;
	bh=K/a6LGlwbUYH7uF06CVaKCHtfibSmN1v5AzEyzZmJNY=;
	h=Date:To:From:Subject:Message-Id; b=dtM2M0XaAb4oB1So5M8tQZsYJMDG5V2WWdkLge8Awxi8bvDSzLJw25/Z+sAPIXFM4hQfOHq7OQqKcBl0HQjwqRN+WFU5N4SuTg60YzYiJYTZy0q4/VvGAh9wSKiNZpodGe7j71SF4nPP904zoe/6LKR6hc301PUtm4Ew8OR6/7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dQeJPtHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dQeJPtHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5352CC4CEED;
	Tue, 10 Jun 2025 21:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749589726;
	bh=K/a6LGlwbUYH7uF06CVaKCHtfibSmN1v5AzEyzZmJNY=;
	h=Date:To:From:Subject:From;
	b=dQeJPtHPgoDuCIpJMh0tlSaZB1351iEA9MB13oZg3vDlqdVKo7MjRXcYc4+GS5FuK
	 ZwdN8kKzmYkfndSMsD2ytsYZUqnhQql8FPTacpGDyaSEETmIZxqRuGQq7R+ZMuvOCO
	 uwTW5WRBDhn1EZsJ+mmucsE+6vmp24oj4+uqGalw=
Date: Tue, 10 Jun 2025 14:08:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-stop-passing-a-writeback_control-structure-to-shmem_writeout.patch added to mm-unstable branch
Message-Id: <20250610210846.5352CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: stop passing a writeback_control structure to shmem_writeout
has been added to the -mm mm-unstable branch.  Its filename is
     mm-stop-passing-a-writeback_control-structure-to-shmem_writeout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-stop-passing-a-writeback_control-structure-to-shmem_writeout.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: mm: stop passing a writeback_control structure to shmem_writeout
Date: Tue, 10 Jun 2025 07:49:38 +0200

shmem_writeout only needs the swap_iocb cookie and the split folio list. 
Pass those explicitly and remove the now unused list member from struct
writeback_control.

Link: https://lkml.kernel.org/r/20250610054959.2057526-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    2 -
 drivers/gpu/drm/ttm/ttm_backup.c          |    9 ------
 include/linux/shmem_fs.h                  |    5 +++
 include/linux/writeback.h                 |    3 --
 mm/shmem.c                                |   26 +++++++++++---------
 mm/vmscan.c                               |   12 +++------
 6 files changed, 26 insertions(+), 31 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c~mm-stop-passing-a-writeback_control-structure-to-shmem_writeout
+++ a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -317,7 +317,7 @@ void __shmem_writeback(size_t size, stru
 		if (folio_mapped(folio))
 			folio_redirty_for_writepage(&wbc, folio);
 		else
-			error = shmem_writeout(folio, &wbc);
+			error = shmem_writeout(folio, NULL, NULL);
 	}
 }
 
--- a/drivers/gpu/drm/ttm/ttm_backup.c~mm-stop-passing-a-writeback_control-structure-to-shmem_writeout
+++ a/drivers/gpu/drm/ttm/ttm_backup.c
@@ -112,15 +112,8 @@ ttm_backup_backup_page(struct file *back
 
 	if (writeback && !folio_mapped(to_folio) &&
 	    folio_clear_dirty_for_io(to_folio)) {
-		struct writeback_control wbc = {
-			.sync_mode = WB_SYNC_NONE,
-			.nr_to_write = SWAP_CLUSTER_MAX,
-			.range_start = 0,
-			.range_end = LLONG_MAX,
-			.for_reclaim = 1,
-		};
 		folio_set_reclaim(to_folio);
-		ret = shmem_writeout(to_folio, &wbc);
+		ret = shmem_writeout(to_folio, NULL, NULL);
 		if (!folio_test_writeback(to_folio))
 			folio_clear_reclaim(to_folio);
 		/*
--- a/include/linux/shmem_fs.h~mm-stop-passing-a-writeback_control-structure-to-shmem_writeout
+++ a/include/linux/shmem_fs.h
@@ -11,6 +11,8 @@
 #include <linux/fs_parser.h>
 #include <linux/userfaultfd_k.h>
 
+struct swap_iocb;
+
 /* inode in-kernel data */
 
 #ifdef CONFIG_TMPFS_QUOTA
@@ -107,7 +109,8 @@ static inline bool shmem_mapping(struct
 void shmem_unlock_mapping(struct address_space *mapping);
 struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					pgoff_t index, gfp_t gfp_mask);
-int shmem_writeout(struct folio *folio, struct writeback_control *wbc);
+int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
+		struct list_head *folio_list);
 void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
 int shmem_unuse(unsigned int type);
 
--- a/include/linux/writeback.h~mm-stop-passing-a-writeback_control-structure-to-shmem_writeout
+++ a/include/linux/writeback.h
@@ -79,9 +79,6 @@ struct writeback_control {
 	 */
 	struct swap_iocb **swap_plug;
 
-	/* Target list for splitting a large folio */
-	struct list_head *list;
-
 	/* internal fields used by the ->writepages implementation: */
 	struct folio_batch fbatch;
 	pgoff_t index;
--- a/mm/shmem.c~mm-stop-passing-a-writeback_control-structure-to-shmem_writeout
+++ a/mm/shmem.c
@@ -1540,11 +1540,13 @@ start_over:
 /**
  * shmem_writeout - Write the folio to swap
  * @folio: The folio to write
- * @wbc: How writeback is to be done
+ * @plug: swap plug
+ * @folio_list: list to put back folios on split
  *
  * Move the folio from the page cache to the swap cache.
  */
-int shmem_writeout(struct folio *folio, struct writeback_control *wbc)
+int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
+		struct list_head *folio_list)
 {
 	struct address_space *mapping = folio->mapping;
 	struct inode *inode = mapping->host;
@@ -1554,9 +1556,6 @@ int shmem_writeout(struct folio *folio,
 	int nr_pages;
 	bool split = false;
 
-	if (WARN_ON_ONCE(!wbc->for_reclaim))
-		goto redirty;
-
 	if ((info->flags & VM_LOCKED) || sbinfo->noswap)
 		goto redirty;
 
@@ -1583,7 +1582,7 @@ int shmem_writeout(struct folio *folio,
 try_split:
 		/* Ensure the subpages are still dirty */
 		folio_test_set_dirty(folio);
-		if (split_folio_to_list(folio, wbc->list))
+		if (split_folio_to_list(folio, folio_list))
 			goto redirty;
 		folio_clear_dirty(folio);
 	}
@@ -1636,13 +1635,21 @@ try_split:
 		list_add(&info->swaplist, &shmem_swaplist);
 
 	if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
+		struct writeback_control wbc = {
+			.sync_mode	= WB_SYNC_NONE,
+			.nr_to_write	= SWAP_CLUSTER_MAX,
+			.range_start	= 0,
+			.range_end	= LLONG_MAX,
+			.for_reclaim	= 1,
+			.swap_plug	= plug,
+		};
 		shmem_recalc_inode(inode, 0, nr_pages);
 		swap_shmem_alloc(folio->swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		mutex_unlock(&shmem_swaplist_mutex);
 		BUG_ON(folio_mapped(folio));
-		return swap_writeout(folio, wbc);
+		return swap_writeout(folio, &wbc);
 	}
 	if (!info->swapped)
 		list_del_init(&info->swaplist);
@@ -1651,10 +1658,7 @@ try_split:
 		goto try_split;
 redirty:
 	folio_mark_dirty(folio);
-	if (wbc->for_reclaim)
-		return AOP_WRITEPAGE_ACTIVATE;	/* Return with folio locked */
-	folio_unlock(folio);
-	return 0;
+	return AOP_WRITEPAGE_ACTIVATE;	/* Return with folio locked */
 }
 EXPORT_SYMBOL_GPL(shmem_writeout);
 
--- a/mm/vmscan.c~mm-stop-passing-a-writeback_control-structure-to-shmem_writeout
+++ a/mm/vmscan.c
@@ -669,15 +669,13 @@ static pageout_t writeout(struct folio *
 
 	/*
 	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
-	 * or we failed to allocate contiguous swap entries.
+	 * or we failed to allocate contiguous swap entries, in which case
+	 * the split out folios get added back to folio_list.
 	 */
-	if (shmem_mapping(mapping)) {
-		if (folio_test_large(folio))
-			wbc.list = folio_list;
-		res = shmem_writeout(folio, &wbc);
-	} else {
+	if (shmem_mapping(mapping))
+		res = shmem_writeout(folio, plug, folio_list);
+	else
 		res = swap_writeout(folio, &wbc);
-	}
 
 	if (res < 0)
 		handle_write_error(mapping, folio, res);
_

Patches currently in -mm which might be from hch@lst.de are

mm-split-out-a-writeout-helper-from-pageout.patch
mm-stop-passing-a-writeback_control-structure-to-shmem_writeout.patch
mm-tidy-up-swap_writeout.patch
mm-stop-passing-a-writeback_control-structure-to-__swap_writepage.patch
mm-stop-passing-a-writeback_control-structure-to-swap_writeout.patch
mm-remove-the-for_reclaim-field-from-struct-writeback_control.patch

