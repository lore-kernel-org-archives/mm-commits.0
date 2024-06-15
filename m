Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E6119D8A6
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 02:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718419202; cv=none; b=EvVX0z6Yb75IdIXnerTWaoU7nrjGFKq+zVMyW2iqr0jOBaLgeWPq8MNXjaZgqlmsWfePACu0rOVRpxdw3hVg5Fr0DF2ndVMFO5X111GYRKdc53QZkvb4uGBUqgxU6ffB3LW3IqAiSF0paz0FGkO2mJ+/PPInLXiuHhgnA29zS10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718419202; c=relaxed/simple;
	bh=YH8EEOF6MuMxq7HMTg3uUr9xZEVIgw8omOrKHCf3+1U=;
	h=Date:To:From:Subject:Message-Id; b=djXnsxovI8JcejQfx+Gv0rlZxB84KEgWdj8eHsQ4gPg7paPMo8ClGimacDK0qQf59kT0BXrdzxtL5jDSHk0k/Ux8X5jk8iNeV6TbV3Ivu422KspDLvle3bP8LQkjnAeUl9E0CXUCRuetD/Vha9VBOPjXF6/wXoI7inpCM2hkBok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qj1Qv92E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qj1Qv92E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883D4C2BD10;
	Sat, 15 Jun 2024 02:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718419201;
	bh=YH8EEOF6MuMxq7HMTg3uUr9xZEVIgw8omOrKHCf3+1U=;
	h=Date:To:From:Subject:From;
	b=qj1Qv92Eo/HNiyvoznvRr+ySMmhK7JluBnmKrrPAJV+zHSqKHtkkGbua91pdvaVLR
	 VBm8biKSk2ob52/9NTgxpLc4XdLv4T5OPCCGfZbqJ15Em77nTnIXAnZyTzDxUJXECu
	 EuLlS0lB8oCfNphap/w4wocrCSHKkEq6DQzoRSZs=
Date: Fri, 14 Jun 2024 19:40:00 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,shakeel.butt@linux.dev,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chengming.zhou@linux.dev,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch added to mm-unstable branch
Message-Id: <20240615024001.883D4C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: store zero pages to be swapped out in a bitmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm: store zero pages to be swapped out in a bitmap
Date: Fri, 14 Jun 2024 11:07:05 +0100

Patch series "mm: store zero pages to be swapped out in a bitmap", v5.

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

Link: https://lkml.kernel.org/r/20240614100902.3469724-1-usamaarif642@gmail.com
Link: https://lkml.kernel.org/r/20240614100902.3469724-2-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
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

 include/linux/swap.h |    1 
 mm/page_io.c         |  113 ++++++++++++++++++++++++++++++++++++++++-
 mm/swapfile.c        |   15 +++++
 3 files changed, 128 insertions(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-store-zero-pages-to-be-swapped-out-in-a-bitmap
+++ a/include/linux/swap.h
@@ -296,6 +296,7 @@ struct swap_info_struct {
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* extent of the swap_map */
 	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
+	unsigned long *zeromap;		/* vmalloc'ed bitmap to track zero pages */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
--- a/mm/page_io.c~mm-store-zero-pages-to-be-swapped-out-in-a-bitmap
+++ a/mm/page_io.c
@@ -172,6 +172,88 @@ bad_bmap:
 	goto out;
 }
 
+static bool is_folio_page_zero_filled(struct folio *folio, int i)
+{
+	unsigned long *data;
+	unsigned int pos, last_pos = PAGE_SIZE / sizeof(*data) - 1;
+	bool ret = false;
+
+	data = kmap_local_folio(folio, i * PAGE_SIZE);
+	if (data[last_pos])
+		goto out;
+	for (pos = 0; pos < PAGE_SIZE / sizeof(*data); pos++) {
+		if (data[pos])
+			goto out;
+	}
+	ret = true;
+out:
+	kunmap_local(data);
+	return ret;
+}
+
+static bool is_folio_zero_filled(struct folio *folio)
+{
+	unsigned int i;
+
+	for (i = 0; i < folio_nr_pages(folio); i++) {
+		if (!is_folio_page_zero_filled(folio, i))
+			return false;
+	}
+	return true;
+}
+
+static void folio_zero_fill(struct folio *folio)
+{
+	unsigned int i;
+
+	for (i = 0; i < folio_nr_pages(folio); i++)
+		clear_highpage(folio_page(folio, i));
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
@@ -195,6 +277,13 @@ int swap_writepage(struct page *page, st
 		folio_unlock(folio);
 		return ret;
 	}
+
+	if (is_folio_zero_filled(folio)) {
+		swap_zeromap_folio_set(folio);
+		folio_unlock(folio);
+		return 0;
+	}
+	swap_zeromap_folio_clear(folio);
 	if (zswap_store(folio)) {
 		folio_unlock(folio);
 		return 0;
@@ -424,6 +513,26 @@ static void sio_read_complete(struct kio
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
+	folio_zero_fill(folio);
+	folio_mark_uptodate(folio);
+	return true;
+}
+
 static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
@@ -514,7 +623,9 @@ void swap_read_folio(struct folio *folio
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
@@ -657,6 +657,14 @@ static void swap_range_free(struct swap_
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
@@ -2545,6 +2553,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	free_percpu(p->cluster_next_cpu);
 	p->cluster_next_cpu = NULL;
 	vfree(swap_map);
+	bitmap_free(p->zeromap);
 	kvfree(cluster_info);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
@@ -3074,6 +3083,12 @@ SYSCALL_DEFINE2(swapon, const char __use
 		error = -ENOMEM;
 		goto bad_swap_unlock_inode;
 	}
+
+	p->zeromap = bitmap_zalloc(maxpages, GFP_KERNEL);
+	if (!p->zeromap) {
+		error = -ENOMEM;
+		goto bad_swap_unlock_inode;
+	}
 
 	if (p->bdev && bdev_stable_writes(p->bdev))
 		p->flags |= SWP_STABLE_WRITES;
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-do-not-start-end-writeback-for-pages-stored-in-zswap.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch
mm-remove-code-to-handle-same-filled-pages.patch

