Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FE1349CC4
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622895; cv=none; b=BKy8vvDXxmSer81NcNktqdddEPpk/9VOb9F4R8PAAQeflNDkQMG5f8uUFwY+vt6p969OZrcJHTHT8zYUr8gNaYeaTPYLi7qexG70ApPEnI+Sqk/asBLNBkXHvv/reavMGB+b7cLNnFQ4jVV3ntPz5F6m9ghVBWMd8nm0A9YLCNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622895; c=relaxed/simple;
	bh=wy/xPrEXUJgIF/uNSXHnxtjmJVMlY4gd2iz/36TgWSY=;
	h=Date:To:From:Subject:Message-Id; b=O2/u5R2Abp2E3vdXZ1Uo+J1kQM44pT1FEmcdRJ6YcN2RgPT7PRPsk3Fr5jbdTwLYrl3id2gicQraveG3ki/n6QExVO8opv7Q6oFoyrIr3gyuz2B0sVcukMLRJQB/S+P0wwfkS1jaI/yXzYzSBxWAw5n1sN5eonYRwhrLmL9PUW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q39tNUWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q39tNUWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E3E1F00A3A;
	Tue, 25 Aug 2026 01:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622894;
	bh=pixrjIVpqm8VTJzSsHiEDtsg79qzld4wiMGR0bVCalw=;
	h=Date:To:From:Subject;
	b=q39tNUWxXIKSFZqRjmByRaFjsvFyu45ix4989ciHnfFLXtTTTUN5u7kWh72w/iykX
	 RtGY3Q4SnLgO9Oo72RLW4jBHoYzjksnRe3hPgJOtDPyCM6+tooJl67o+q4fWJdLHoE
	 P9xXVcsglWXZIDb6ViFflHNsPJWPLU9A7qMbjMa4=
Date: Mon, 24 Aug 2026 18:54:53 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-swp_fs_ops.patch removed from -mm tree
Message-Id: <20260825015454.28E3E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: remove SWP_FS_OPS
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-swp_fs_ops.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm/swap: remove SWP_FS_OPS
Date: Mon, 13 Jul 2026 11:33:43 +0200

Provide a swap_fs_activate helper that directly sets up swap_fs_ops, and a
flag in struct swap_ops to indicate of NOFS swapping is allowed.

Link: https://lore.kernel.org/20260713093350.2154226-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/locking.rst |    5 +++--
 Documentation/filesystems/vfs.rst     |    4 ++--
 fs/nfs/file.c                         |    4 +---
 fs/smb/client/file.c                  |    4 +---
 include/linux/swap.h                  |    6 +++++-
 mm/page_io.c                          |   10 +++++++++-
 mm/swap.h                             |   22 ++++++++++------------
 mm/swapfile.c                         |    2 --
 mm/vmscan.c                           |   15 +++++++--------
 9 files changed, 38 insertions(+), 34 deletions(-)

--- a/Documentation/filesystems/locking.rst~mm-swap-remove-swp_fs_ops
+++ a/Documentation/filesystems/locking.rst
@@ -355,13 +355,14 @@ should perform any validation and prepar
 writes can be performed with minimal memory allocation.  It should call
 add_swap_extent(), or the helper iomap_swapfile_activate(), and return
 the number of extents added.  If IO should be submitted through
-->swap_rw(), it should set SWP_FS_OPS, otherwise IO will be submitted
+->swap_rw(), it should call swap_fs_activate, otherwise IO will be submitted
 directly to the block device ``sis->bdev``.
 
 ->swap_deactivate() will be called in the sys_swapoff()
 path after ->swap_activate() returned success.
 
-->swap_rw will be called for swap IO if SWP_FS_OPS was set by ->swap_activate().
+->swap_rw will be called for swap IO if swap_fs_activate was called by
+->swap_activate().
 
 file_lock_operations
 ====================
--- a/Documentation/filesystems/vfs.rst~mm-swap-remove-swp_fs_ops
+++ a/Documentation/filesystems/vfs.rst
@@ -977,7 +977,7 @@ cache in your filesystem.  The following
 	can be performed with minimal memory allocation.  It should call
 	add_swap_extent(), or the helper iomap_swapfile_activate(), and
 	return the number of extents added.  If IO should be submitted
-	through ->swap_rw(), it should set SWP_FS_OPS, otherwise IO will
+	through ->swap_rw(), it should call swap_fs_activate, otherwise IO will
 	be submitted directly to the block device ``sis->bdev``.
 
 ``swap_deactivate``
@@ -985,7 +985,7 @@ cache in your filesystem.  The following
 	successful.
 
 ``swap_rw``
-	Called to read or write swap pages when SWP_FS_OPS is set.
+	Called to read or write swap pages when swap_fs_activate was called.
 
 The File Object
 ===============
--- a/fs/nfs/file.c~mm-swap-remove-swp_fs_ops
+++ a/fs/nfs/file.c
@@ -597,7 +597,7 @@ static int nfs_swap_activate(struct swap
 	ret = rpc_clnt_swap_activate(clnt);
 	if (ret)
 		return ret;
-	ret = add_swap_extent(sis, 0, sis->max, 0);
+	ret = swap_fs_activate(sis);
 	if (ret < 0) {
 		rpc_clnt_swap_deactivate(clnt);
 		return ret;
@@ -607,8 +607,6 @@ static int nfs_swap_activate(struct swap
 
 	if (cl->rpc_ops->enable_swap)
 		cl->rpc_ops->enable_swap(inode);
-
-	sis->flags |= SWP_FS_OPS;
 	return ret;
 }
 
--- a/fs/smb/client/file.c~mm-swap-remove-swp_fs_ops
+++ a/fs/smb/client/file.c
@@ -3451,9 +3451,7 @@ static int cifs_swap_activate(struct swa
 	 * but we could add call to grab a byte range lock to prevent others
 	 * from reading or writing the file
 	 */
-
-	sis->flags |= SWP_FS_OPS;
-	return add_swap_extent(sis, 0, sis->max, 0);
+	return swap_fs_activate(sis);
 }
 
 static void cifs_swap_deactivate(struct file *file)
--- a/include/linux/swap.h~mm-swap-remove-swp_fs_ops
+++ a/include/linux/swap.h
@@ -202,7 +202,6 @@ enum {
 	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
 	SWP_BLKDEV	= (1 << 6),	/* its a block device */
 	SWP_ACTIVATED	= (1 << 7),	/* set after swap_activate success */
-	SWP_FS_OPS	= (1 << 8),	/* swapfile operations go through fs */
 	SWP_AREA_DISCARD = (1 << 9),	/* single-time swap area discards */
 	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
@@ -343,6 +342,7 @@ extern void __meminit kswapd_stop(int ni
 
 #ifdef CONFIG_SWAP
 
+int swap_fs_activate(struct swap_info_struct *sis);
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
 int generic_swapfile_activate(struct swap_info_struct *, struct file *,
@@ -468,6 +468,10 @@ static inline bool folio_free_swap(struc
 	return false;
 }
 
+static inline int swap_fs_activate(struct swap_info_struct *sis)
+{
+	return -EINVAL;
+}
 static inline int add_swap_extent(struct swap_info_struct *sis,
 				  unsigned long start_page,
 				  unsigned long nr_pages, sector_t start_block)
--- a/mm/page_io.c~mm-swap-remove-swp_fs_ops
+++ a/mm/page_io.c
@@ -686,12 +686,20 @@ static bool swap_fs_can_merge(struct fol
 		swap_dev_pos(prev_folio->swap) + prev_folio_size;
 }
 
-const struct swap_ops swap_fs_ops = {
+static const struct swap_ops swap_fs_ops = {
+	.flags			= SWAP_OPS_F_REQUIRE_NOFS,
 	.submit_write		= swap_fs_submit_write,
 	.submit_read		= swap_fs_submit_read,
 	.can_merge		= swap_fs_can_merge,
 };
 
+int swap_fs_activate(struct swap_info_struct *sis)
+{
+	sis->ops = &swap_fs_ops;
+	return add_swap_extent(sis, 0, sis->max, 0);
+}
+EXPORT_SYMBOL_GPL(swap_fs_activate);
+
 void swap_write_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
--- a/mm/swapfile.c~mm-swap-remove-swp_fs_ops
+++ a/mm/swapfile.c
@@ -2975,8 +2975,6 @@ static int setup_swap_extents(struct swa
 		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
 		if (ret < 0)
 			return ret;
-		if (sis->flags & SWP_FS_OPS)
-			sis->ops = &swap_fs_ops;
 		sis->flags |= SWP_ACTIVATED;
 		return ret;
 	}
--- a/mm/swap.h~mm-swap-remove-swp_fs_ops
+++ a/mm/swap.h
@@ -96,7 +96,17 @@ struct swap_io_ctx {
 	struct swap_info_struct	*sis;
 };
 
+/*
+ * SWAP_OPS_F_REQUIRE_NOFS:
+ *	When set, all reclaim operations must operated as GFS_NOFS and not
+ *	just GFP_NOIO, as GFP_NOIO allocations could recourse into the
+ *	file system backing this swap file.
+ */
+#define SWAP_OPS_F_REQUIRE_NOFS		(1U << 0)
+
 struct swap_ops {
+	unsigned int		flags;
+
 	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
 			size_t prev_folio_size, int rw);
 	void (*submit_write)(struct swap_io_ctx *ctx);
@@ -347,11 +357,6 @@ struct folio *swapin_sync(swp_entry_t en
 void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 			   unsigned long addr);
 
-static inline unsigned int folio_swap_flags(struct folio *folio)
-{
-	return __swap_entry_to_info(folio->swap)->flags;
-}
-
 #else /* CONFIG_SWAP */
 static inline struct swap_cluster_info *swap_cluster_lock(
 	struct swap_info_struct *si, pgoff_t offset, bool irq)
@@ -482,16 +487,9 @@ static inline void __swap_cache_replace_
 		struct folio *old, struct folio *new)
 {
 }
-
-static inline unsigned int folio_swap_flags(struct folio *folio)
-{
-	return 0;
-}
-
 #endif /* CONFIG_SWAP */
 
 extern const struct swap_ops swap_bdev_ops;
-extern const struct swap_ops swap_fs_ops;
 
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list);
--- a/mm/vmscan.c~mm-swap-remove-swp_fs_ops
+++ a/mm/vmscan.c
@@ -1040,16 +1040,15 @@ static bool may_enter_fs(struct folio *f
 {
 	if (gfp_mask & __GFP_FS)
 		return true;
-	if (!folio_test_swapcache(folio) || !(gfp_mask & __GFP_IO))
-		return false;
 	/*
-	 * We can "enter_fs" for swap-cache with only __GFP_IO
-	 * providing this isn't SWP_FS_OPS.
-	 * ->flags can be updated non-atomically,
-	 * but that will never affect SWP_FS_OPS, so the data_race
-	 * is safe.
+	 * We can "enter_fs" for swap-cache with only __GFP_IO unless backed by
+	 * a swapfile that requires GFP_NOFS I/O.
 	 */
-	return !data_race(folio_swap_flags(folio) & SWP_FS_OPS);
+	if (folio_test_swapcache(folio) && (gfp_mask & __GFP_IO) &&
+	    !(__swap_entry_to_info(folio->swap)->ops->flags &
+			SWAP_OPS_F_REQUIRE_NOFS))
+		return true;
+	return false;
 }
 
 /*
_

Patches currently in -mm which might be from hch@lst.de are


