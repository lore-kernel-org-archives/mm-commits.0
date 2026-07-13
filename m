Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA78347505
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 20:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783973820; cv=none; b=bpe+X+HlQvEe/dBnifF7xoIouUGPC7SmGhOdfeHS7Mrawyg9adfkzzwWGaRq5d9OEEXlpMLCJNSlZwhUFsoXyhgdmqyc6nIR9o5L/nroIP4xa749ARB951ffG+x9C1VhxIdPcNxZpxo284JBaFmnn6IOGSuen3Q4I1BlneyBkkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783973820; c=relaxed/simple;
	bh=80bpyRYtgp+5cP+SYrzd52YicqnwtXvz1rOp+EINcwE=;
	h=Date:To:From:Subject:Message-Id; b=IEB6OukOehSrMFlEIGVelIxXELGPi7OXDu64vPitEDA8i3cZfYLNRM3RzXUPMb3hatRZBYXKmJHpD+vxb8ZTo9+Sov4hXhXANWs4Y3HaW0JAoB464yIEus7qFEQGsncELjwxHhEgeOl7rivwRQ5pYLkVz+0pxVi6NlQGPaCCRJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DtGA/VdM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DtGA/VdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C3D1F000E9;
	Mon, 13 Jul 2026 20:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783973817;
	bh=1bGuWYynWE7G1iCm2uFkqSV/SwOt7NkhKrwzvuCdXAU=;
	h=Date:To:From:Subject;
	b=DtGA/VdMyZ4GnmZaDC0V9xCcs/8AZlaEBIVtvevb1IKFYNFQsjZ9Qh5aVJCDDV+H6
	 NloWdpPD0NNyAWTDxE2w6zuhNBfn57zs38EPSFxzrXVIFLGmo5uHQNC+x+44TwqDbs
	 spXxwryd2NlUC7b2CfIg+Que1PrzntMgnT2s+iuI=
Date: Mon, 13 Jul 2026 13:16:57 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-swp_fs_ops.patch added to mm-new branch
Message-Id: <20260713201657.D3C3D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: remove SWP_FS_OPS
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-remove-swp_fs_ops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-swp_fs_ops.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -3387,9 +3387,7 @@ static int cifs_swap_activate(struct swa
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
@@ -335,6 +334,7 @@ extern void __meminit kswapd_stop(int ni
 
 #ifdef CONFIG_SWAP
 
+int swap_fs_activate(struct swap_info_struct *sis);
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
 int generic_swapfile_activate(struct swap_info_struct *, struct file *,
@@ -460,6 +460,10 @@ static inline bool folio_free_swap(struc
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
@@ -2962,8 +2962,6 @@ static int setup_swap_extents(struct swa
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
@@ -82,7 +82,17 @@ struct swap_io_ctx {
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
@@ -333,11 +343,6 @@ struct folio *swapin_sync(swp_entry_t en
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
@@ -468,16 +473,9 @@ static inline void __swap_cache_replace_
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
@@ -1033,16 +1033,15 @@ static bool may_enter_fs(struct folio *f
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

mm-remove-wb_writeout_inc.patch
shmem-provide-a-shmem_write_folio-wrapper.patch
mm-swap-introduce-struct-swap_io_ctx.patch
mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch
mm-swap-remove-count_swpout_vm_event.patch
mm-swap-use-swap_ops-to-register-swap-devices-methods.patch
mm-swap-remove-swp_fs_ops.patch
mm-vmstat-add-nrswpinout-counters.patch

