Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73C64C3D0
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292036; cv=none; b=QbzorWI7frEof3QcSzv93EEkAybWUwVlZ0HXtfMwLciCgx8EMB5kb8XxfRknySnY9pUTnTxCDdO6HhV0+xzEI6L0d9CCENUmT/+Cv12exC4CBYX2OhhpRLiITU+MvgAyZTasN46Ow/fCs+/mBMouUW1aSS2MVoJ5bAXHVJAcCh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292036; c=relaxed/simple;
	bh=2rduXjZXoPIaL838fyOA1YZ/oePt1JarCHeRvUZxJlE=;
	h=Date:To:From:Subject:Message-Id; b=FMi5jicmNGdwLBfDE/rPVGO1HYW9qrqnuFd8Dw2i3aCF9UAdnIgiy8TKUb9acFFFIOQZoMdsTK/pZoemyO0QzL/WALO9QRRwPaRcd1kp4rpZde+OAwt/aj+bda6Nom+DrqDFzGo7G3Dk1DO9YFMs1/t9WqWRSxGmZzsFTcA/6xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JYCVpSx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JYCVpSx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F3CC2BD10;
	Sat,  6 Jul 2024 18:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292035;
	bh=2rduXjZXoPIaL838fyOA1YZ/oePt1JarCHeRvUZxJlE=;
	h=Date:To:From:Subject:From;
	b=JYCVpSx0LaRZi4YFTUG+R1dKJ4ZV3dNBFu20rVZqGXzUXC373pcd/xTsdxhYs2cEy
	 wCfkSYlXmfQO3QHPYfXQExJZC9Cr/1CxoMzcxXhohi5Qi9HhaC79k2wdnTAYrTfW3X
	 pLopD3NzLsn4y1oO0hpddK1Soc//CNdw00x7MmNE=
Date: Sat, 06 Jul 2024 11:53:54 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,shakeel.butt@linux.dev,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chengming.zhou@linux.dev,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch removed from -mm tree
Message-Id: <20240706185355.63F3CC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: store zero pages to be swapped out in a bitmap
has been removed from the -mm tree.  Its filename was
     mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm: store zero pages to be swapped out in a bitmap
Date: Fri, 14 Jun 2024 11:07:05 +0100

Patch series "mm: store zero pages to be swapped out in a bitmap", v6.

As shown in the patch series that introduced the zswap same-filled
optimization [1], 10-20% of the pages stored in zswap are same-filled. 
This is also observed across Meta's server fleet.  By using VM counters in
swap_writepage (not included in this patchseries) it was found that less
than 1% of the same-filled pages to be swapped out are non-zero pages.

For conventional swap setup (without zswap), rather than reading/writing
these pages to flash resulting in increased I/O and flash wear, a bitmap
can be used to mark these pages as zero at write time, and the pages can
be filled at read time if the bit corresponding to the page is set.

When using zswap with swap, this also means that a zswap_entry does not
need to be allocated for zero filled pages resulting in memory savings
which would offset the memory used for the bitmap.

A similar attempt was made earlier in [2] where zswap would only track
zero-filled pages instead of same-filled.  This patch series adds
zero-filled pages optimization to swap (hence it can be used even if zswap
is disabled) and removes the same-filled code from zswap (as only 1% of
the same-filled pages are non-zero), simplifying code.

[1] https://lore.kernel.org/all/20171018104832epcms5p1b2232e2236258de3d03d1344dde9fce0@epcms5p1/
[2] https://lore.kernel.org/lkml/20240325235018.2028408-1-yosryahmed@google.com/


This patch (of 2):

Approximately 10-20% of pages to be swapped out are zero pages [1]. 
Rather than reading/writing these pages to flash resulting in increased
I/O and flash wear, a bitmap can be used to mark these pages as zero at
write time, and the pages can be filled at read time if the bit
corresponding to the page is set.  With this patch, NVMe writes in Meta
server fleet decreased by almost 10% with conventional swap setup (zswap
disabled).

[1] https://lore.kernel.org/all/20171018104832epcms5p1b2232e2236258de3d03d1344dde9fce0@epcms5p1/

[usamaarif642@gmail.com: v6]
  Link: https://lkml.kernel.org/r/20240624140427.1334871-2-usamaarif642@gmail.com
[usamaarif642@gmail.com: v7]
  Link: https://lkml.kernel.org/r/20240627105730.3110705-2-usamaarif642@gmail.com
[akpm@linux-foundation.org: reflow to 80 cols]
[usamaarif642@gmail.com: v8]
  Link: https://lkml.kernel.org/r/6f8b64f8-b7b0-42f4-a1d4-bf79624cff1e@gmail.com
Link: https://lkml.kernel.org/r/20240624140427.1334871-1-usamaarif642@gmail.com
Link: https://lkml.kernel.org/r/20240614100902.3469724-1-usamaarif642@gmail.com
Link: https://lkml.kernel.org/r/20240614100902.3469724-2-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/page_io.c         |  117 ++++++++++++++++++++++++++++++++++++++++-
 mm/swapfile.c        |   21 +++++++
 3 files changed, 138 insertions(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-store-zero-pages-to-be-swapped-out-in-a-bitmap
+++ a/include/linux/swap.h
@@ -299,6 +299,7 @@ struct swap_info_struct {
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* extent of the swap_map */
 	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
+	unsigned long *zeromap;		/* kvmalloc'ed bitmap to track zero pages */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct swap_cluster_list free_clusters; /* free clusters list */
 	unsigned int lowest_bit;	/* index of first free in swap_map */
--- a/mm/page_io.c~mm-store-zero-pages-to-be-swapped-out-in-a-bitmap
+++ a/mm/page_io.c
@@ -172,6 +172,80 @@ bad_bmap:
 	goto out;
 }
 
+static bool is_folio_zero_filled(struct folio *folio)
+{
+	unsigned int pos, last_pos;
+	unsigned long *data;
+	unsigned int i;
+
+	last_pos = PAGE_SIZE / sizeof(*data) - 1;
+	for (i = 0; i < folio_nr_pages(folio); i++) {
+		data = kmap_local_folio(folio, i * PAGE_SIZE);
+		/*
+		 * Check last word first, incase the page is zero-filled at
+		 * the start and has non-zero data at the end, which is common
+		 * in real-world workloads.
+		 */
+		if (data[last_pos]) {
+			kunmap_local(data);
+			return false;
+		}
+		for (pos = 0; pos < last_pos; pos++) {
+			if (data[pos]) {
+				kunmap_local(data);
+				return false;
+			}
+		}
+		kunmap_local(data);
+	}
+
+	return true;
+}
+
+static void swap_zeromap_folio_set(struct folio *folio)
+{
+	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	swp_entry_t entry;
+	unsigned int i;
+
+	for (i = 0; i < folio_nr_pages(folio); i++) {
+		entry = page_swap_entry(folio_page(folio, i));
+		set_bit(swp_offset(entry), sis->zeromap);
+	}
+}
+
+static void swap_zeromap_folio_clear(struct folio *folio)
+{
+	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	swp_entry_t entry;
+	unsigned int i;
+
+	for (i = 0; i < folio_nr_pages(folio); i++) {
+		entry = page_swap_entry(folio_page(folio, i));
+		clear_bit(swp_offset(entry), sis->zeromap);
+	}
+}
+
+/*
+ * Return the index of the first subpage which is not zero-filled
+ * according to swap_info_struct->zeromap.
+ * If all pages are zero-filled according to zeromap, it will return
+ * folio_nr_pages(folio).
+ */
+static unsigned int swap_zeromap_folio_test(struct folio *folio)
+{
+	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	swp_entry_t entry;
+	unsigned int i;
+
+	for (i = 0; i < folio_nr_pages(folio); i++) {
+		entry = page_swap_entry(folio_page(folio, i));
+		if (!test_bit(swp_offset(entry), sis->zeromap))
+			return i;
+	}
+	return i;
+}
+
 /*
  * We may have stale swap cache pages in memory: notice
  * them here and get rid of the unnecessary final write.
@@ -195,6 +269,25 @@ int swap_writepage(struct page *page, st
 		folio_unlock(folio);
 		return ret;
 	}
+
+	/*
+	 * Use a bitmap (zeromap) to avoid doing IO for zero-filled pages.
+	 * The bits in zeromap are protected by the locked swapcache folio
+	 * and atomic updates are used to protect against read-modify-write
+	 * corruption due to other zero swap entries seeing concurrent updates.
+	 */
+	if (is_folio_zero_filled(folio)) {
+		swap_zeromap_folio_set(folio);
+		folio_unlock(folio);
+		return 0;
+	} else {
+		/*
+		 * Clear bits this folio occupies in the zeromap to prevent
+		 * zero data being read in from any previous zero writes that
+		 * occupied the same swap entries.
+		 */
+		swap_zeromap_folio_clear(folio);
+	}
 	if (zswap_store(folio)) {
 		folio_unlock(folio);
 		return 0;
@@ -424,6 +517,26 @@ static void sio_read_complete(struct kio
 	mempool_free(sio, sio_pool);
 }
 
+static bool swap_read_folio_zeromap(struct folio *folio)
+{
+	unsigned int idx = swap_zeromap_folio_test(folio);
+
+	if (idx == 0)
+		return false;
+
+	/*
+	 * Swapping in a large folio that is partially in the zeromap is not
+	 * currently handled. Return true without marking the folio uptodate so
+	 * that an IO error is emitted (e.g. do_swap_page() will sigbus).
+	 */
+	if (WARN_ON_ONCE(idx < folio_nr_pages(folio)))
+		return true;
+
+	folio_zero_range(folio, 0, folio_size(folio));
+	folio_mark_uptodate(folio);
+	return true;
+}
+
 static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
@@ -514,7 +627,9 @@ void swap_read_folio(struct folio *folio
 	}
 	delayacct_swapin_start();
 
-	if (zswap_load(folio)) {
+	if (swap_read_folio_zeromap(folio)) {
+		folio_unlock(folio);
+	} else if (zswap_load(folio)) {
 		folio_unlock(folio);
 	} else if (data_race(sis->flags & SWP_FS_OPS)) {
 		swap_read_folio_fs(folio, plug);
--- a/mm/swapfile.c~mm-store-zero-pages-to-be-swapped-out-in-a-bitmap
+++ a/mm/swapfile.c
@@ -747,6 +747,14 @@ static void swap_range_free(struct swap_
 	unsigned long begin = offset;
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
+	unsigned int i;
+
+	/*
+	 * Use atomic clear_bit operations only on zeromap instead of non-atomic
+	 * bitmap_clear to prevent adjacent bits corruption due to simultaneous writes.
+	 */
+	for (i = 0; i < nr_entries; i++)
+		clear_bit(offset + i, si->zeromap);
 
 	if (offset < si->lowest_bit)
 		si->lowest_bit = offset;
@@ -2645,6 +2653,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	free_percpu(p->cluster_next_cpu);
 	p->cluster_next_cpu = NULL;
 	vfree(swap_map);
+	kvfree(p->zeromap);
 	kvfree(cluster_info);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
@@ -3171,6 +3180,17 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap_unlock_inode;
 	}
 
+	/*
+	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
+	 * be above MAX_PAGE_ORDER incase of a large swap file.
+	 */
+	p->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
+				    GFP_KERNEL | __GFP_ZERO);
+	if (!p->zeromap) {
+		error = -ENOMEM;
+		goto bad_swap_unlock_inode;
+	}
+
 	if (p->bdev && bdev_stable_writes(p->bdev))
 		p->flags |= SWP_STABLE_WRITES;
 
@@ -3325,6 +3345,7 @@ bad_swap:
 	p->flags = 0;
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
+	kvfree(p->zeromap);
 	kvfree(cluster_info);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
_

Patches currently in -mm which might be from usamaarif642@gmail.com are


