Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CF8134A9
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720291583; cv=none; b=vFG30wwKi4l2AOQIxpZ2WYkewlUW255BrJMgniBOxrD87AFmOY9zJbJwgamJk0R5yPEKFTQwavssT6RKQnDeOFvqzadF18H3UxPeTQM/Wo0aWh01UrBINPyFIFWy+sv8g9lp4wYSZQ29ZP56QQk0M2AeEmw2LhwbQjl6SdQxtEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720291583; c=relaxed/simple;
	bh=zofQ/5VZM3p1wBNdjgRtEsFXX2Tj71Qm9wT3Aplcers=;
	h=Date:To:From:Subject:Message-Id; b=NkNBQ9f92uiSZo1jh6ANOKNr/vASRPKbAuE6aj17Zk8V7Y39t3Sj1HMvempc2azx7yOQm5vQHXmS0spDywgQBErEF7WsvfMdlZenAW1YILad4yOKQHBadxS78NsQScmfLXxPSiEzaRjkSIwoXrerNcrga6ZlOe8ZqthHxwIS+Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l/aLhIj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l/aLhIj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D20FC2BD10;
	Sat,  6 Jul 2024 18:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720291583;
	bh=zofQ/5VZM3p1wBNdjgRtEsFXX2Tj71Qm9wT3Aplcers=;
	h=Date:To:From:Subject:From;
	b=l/aLhIj6bbjvOpvm5THuoUaImhwALlmp3LaclpZ/EXS2hsMb3WdPbKiifm/3lS06/
	 3TmBbNJo8GQ8LJEMkBAAiHrWGeynJdK1L/lAloBI83ys4oP8GhW4y3FGnGYGmgSpbd
	 V/6KF4EGMC+gxtT6cXOrWuCDUc2rPr02ybwzx5G4=
Date: Sat, 06 Jul 2024 11:46:22 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,shakeel.butt@linux.dev,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chengming.zhou@linux.dev,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v8.patch removed from -mm tree
Message-Id: <20240706184623.3D20FC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v8
has been removed from the -mm tree.  Its filename was
     mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v8.patch

This patch was dropped because it was folded into mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v8
Date: Fri, 24 May 2024 14:52:55 +0100

Changes from v7 (Johannes):
- Give overview and explain how locking works in zeromap in comments
- Add comment for why last word is checked first when checking if
  folio is zero-filled
- Merge is_folio_zero_filled and is_folio_page_zero_filled into
  1 function.
- Use folio_zero_range to fill a folio with zero at readtime.
- Put swap_zeromap_folio_clear in an else branch (even if checkpatch
  gives warning) and add comment to make it explicitly clear that it
  needs to happen if folio is not zero filled.
- add missing kvfree for zeromap incase swapon fails.

Link: https://lkml.kernel.org/r/6f8b64f8-b7b0-42f4-a1d4-bf79624cff1e@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 -
 mm/page_io.c         |   64 +++++++++++++++++++++--------------------
 mm/swapfile.c        |    9 +++--
 3 files changed, 40 insertions(+), 35 deletions(-)

--- a/include/linux/swap.h~mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v8
+++ a/include/linux/swap.h
@@ -299,7 +299,7 @@ struct swap_info_struct {
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* extent of the swap_map */
 	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
-	unsigned long *zeromap;		/* vmalloc'ed bitmap to track zero pages */
+	unsigned long *zeromap;		/* kvmalloc'ed bitmap to track zero pages */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct swap_cluster_list free_clusters; /* free clusters list */
 	unsigned int lowest_bit;	/* index of first free in swap_map */
--- a/mm/page_io.c~mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v8
+++ a/mm/page_io.c
@@ -172,42 +172,34 @@ bad_bmap:
 	goto out;
 }
 
-static bool is_folio_page_zero_filled(struct folio *folio, int i)
-{
-	unsigned long *data;
-	unsigned int pos, last_pos = PAGE_SIZE / sizeof(*data) - 1;
-	bool ret = false;
-
-	data = kmap_local_folio(folio, i * PAGE_SIZE);
-	if (data[last_pos])
-		goto out;
-	for (pos = 0; pos < PAGE_SIZE / sizeof(*data); pos++) {
-		if (data[pos])
-			goto out;
-	}
-	ret = true;
-out:
-	kunmap_local(data);
-	return ret;
-}
-
 static bool is_folio_zero_filled(struct folio *folio)
 {
+	unsigned int pos, last_pos;
+	unsigned long *data;
 	unsigned int i;
 
+	last_pos = PAGE_SIZE / sizeof(*data) - 1;
 	for (i = 0; i < folio_nr_pages(folio); i++) {
-		if (!is_folio_page_zero_filled(folio, i))
+		data = kmap_local_folio(folio, i * PAGE_SIZE);
+		/*
+		 * Check last word first, incase the page is zero-filled at
+		 * the start and has non-zero data at the end, which is common
+		 * in real-world workloads.
+		 */
+		if (data[last_pos]) {
+			kunmap_local(data);
 			return false;
+		}
+		for (pos = 0; pos < last_pos; pos++) {
+			if (data[pos]) {
+				kunmap_local(data);
+				return false;
+			}
+		}
+		kunmap_local(data);
 	}
-	return true;
-}
 
-static void folio_zero_fill(struct folio *folio)
-{
-	unsigned int i;
-
-	for (i = 0; i < folio_nr_pages(folio); i++)
-		clear_highpage(folio_page(folio, i));
+	return true;
 }
 
 static void swap_zeromap_folio_set(struct folio *folio)
@@ -278,12 +270,24 @@ int swap_writepage(struct page *page, st
 		return ret;
 	}
 
+	/*
+	 * Use a bitmap (zeromap) to avoid doing IO for zero-filled pages.
+	 * The bits in zeromap are protected by the locked swapcache folio
+	 * and atomic updates are used to protect against read-modify-write
+	 * corruption due to other zero swap entries seeing concurrent updates.
+	 */
 	if (is_folio_zero_filled(folio)) {
 		swap_zeromap_folio_set(folio);
 		folio_unlock(folio);
 		return 0;
+	} else {
+		/*
+		 * Clear bits this folio occupies in the zeromap to prevent
+		 * zero data being read in from any previous zero writes that
+		 * occupied the same swap entries.
+		 */
+		swap_zeromap_folio_clear(folio);
 	}
-	swap_zeromap_folio_clear(folio);
 	if (zswap_store(folio)) {
 		folio_unlock(folio);
 		return 0;
@@ -528,7 +532,7 @@ static bool swap_read_folio_zeromap(stru
 	if (WARN_ON_ONCE(idx < folio_nr_pages(folio)))
 		return true;
 
-	folio_zero_fill(folio);
+	folio_zero_range(folio, 0, folio_size(folio));
 	folio_mark_uptodate(folio);
 	return true;
 }
--- a/mm/swapfile.c~mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v8
+++ a/mm/swapfile.c
@@ -3181,11 +3181,11 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 
 	/*
-	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order
-	 * might be above MAX_PAGE_ORDER incase of a large swap file.
+	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
+	 * be above MAX_PAGE_ORDER incase of a large swap file.
 	 */
-	p->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages),
-				sizeof(unsigned long), GFP_KERNEL | __GFP_ZERO);
+	p->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
+				    GFP_KERNEL | __GFP_ZERO);
 	if (!p->zeromap) {
 		error = -ENOMEM;
 		goto bad_swap_unlock_inode;
@@ -3345,6 +3345,7 @@ bad_swap:
 	p->flags = 0;
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
+	kvfree(p->zeromap);
 	kvfree(cluster_info);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch
mm-remove-code-to-handle-same-filled-pages.patch

