Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAA135BDD5
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 20:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783973817; cv=none; b=hR66OwTyKE8Con6AVrRKjz2F9csB8zPmjU71Mde0F4Kl/mKiSFv9f0lndNYXiWol3eKY3WxNYTfcYVtzhuBcEWfJUQw7HfKu6MxC4IHboB16pC98EoWDR+ze9eCpDjn85csqP+ql1poEpSnTKeOJYeVVn8GMC/9vhVcTrP7py8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783973817; c=relaxed/simple;
	bh=gyNYaITzmSmQ19TJdXEOkMlZ4lK9tlTRXyLYU4EO4Bw=;
	h=Date:To:From:Subject:Message-Id; b=rMri6JpxFKvZlmd+d4UC8xvzZYfRhuZekFJ0GvBJFqAPFlD6k2mYjf8ut+Z8QtVZMwiQToQMrYfItMlaHbTjkSyd/94w+40FvvI48U0CxKmdxgBkzlPj5JZkuLZ+jmElMfQUIpp1uqjK6Mh9ksdRhkPnurR8Y9jJ6ulzUqVhW4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1W8VNhGd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1W8VNhGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE301F000E9;
	Mon, 13 Jul 2026 20:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783973814;
	bh=yoAMDkIrgnoc7KXvPksxyKmVUxbHsRgDQXO3hLxQfFc=;
	h=Date:To:From:Subject;
	b=1W8VNhGdiLHFxYrwWU4SjzJ+PNfzFmVkbjkDlAS6+IDvLmF3EQFstamdAtiVTWUKI
	 AG722wdUiKtvHxw4JqJnssB53rDCpp+dZvPSReMwtuiDZJgreZ/5In1mR20deFe7Wu
	 pk0P8ZB6ACaJWZB5i/jy/FzpICsa3QHqfA75XsRA=
Date: Mon, 13 Jul 2026 13:16:53 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-swap_ops-to-register-swap-devices-methods.patch added to mm-new branch
Message-Id: <20260713201654.5AE301F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: use swap_ops to register swap device's methods
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-use-swap_ops-to-register-swap-devices-methods.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-swap_ops-to-register-swap-devices-methods.patch

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
Subject: mm/swap: use swap_ops to register swap device's methods
Date: Mon, 13 Jul 2026 11:33:42 +0200

This simplifies codes and makes logic clearer.  And also makes later any
new swap device type being added easier to handle.

Currently there are two types of swap devices: fs and bdev.

[hch@lst.de: updated for the new submit and can_merge abstraction]
Link: https://lore.kernel.org/20260713093350.2154226-6-hch@lst.de
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/page_io.c         |   68 +++++++++++++++++++++++++----------------
 mm/swap.h            |   10 ++++++
 mm/swapfile.c        |    4 ++
 4 files changed, 58 insertions(+), 25 deletions(-)

--- a/include/linux/swap.h~mm-swap-use-swap_ops-to-register-swap-devices-methods
+++ a/include/linux/swap.h
@@ -276,6 +276,7 @@ struct swap_info_struct {
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
+	const struct swap_ops *ops;
 };
 
 static inline swp_entry_t page_swap_entry(struct page *page)
--- a/mm/page_io.c~mm-swap-use-swap_ops-to-register-swap-devices-methods
+++ a/mm/page_io.c
@@ -334,21 +334,7 @@ static bool swap_can_merge(struct swap_i
 
 	if (ctx->sis != sis)
 		return false;
-
-	if (sis->flags & SWP_FS_OPS) {
-		if (swap_dev_pos(folio->swap) !=
-		    swap_dev_pos(prev_folio->swap) + prev_folio_size)
-			return false;
-	} else {
-		if (swap_folio_sector(folio) !=
-		    swap_folio_sector(prev_folio) +
-		    (prev_folio_size >> SECTOR_SHIFT))
-			return false;
-		if (rw == WRITE && !folio_blkg_can_merge(folio, prev_folio))
-			return false;
-	}
-
-	return true;
+	return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw);
 }
 
 static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
@@ -646,6 +632,23 @@ static void swap_bdev_submit_read(struct
 	}
 }
 
+static bool swap_bdev_can_merge(struct folio *folio, struct folio *prev_folio,
+		size_t prev_folio_size, int rw)
+{
+	if (swap_folio_sector(folio) !=
+	    swap_folio_sector(prev_folio) + (prev_folio_size >> SECTOR_SHIFT))
+		return false;
+	if (rw == WRITE && !folio_blkg_can_merge(folio, prev_folio))
+		return false;
+	return true;
+}
+
+const struct swap_ops swap_bdev_ops = {
+	.submit_write		= swap_bdev_submit_write,
+	.submit_read		= swap_bdev_submit_read,
+	.can_merge		= swap_bdev_can_merge,
+};
+
 static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
 {
 	struct swap_iocb *sio = ctx->sio;
@@ -666,15 +669,34 @@ static void swap_fs_submit(struct swap_i
 		sio->iocb.ki_complete(&sio->iocb, ret);
 }
 
+static void swap_fs_submit_write(struct swap_io_ctx *ctx)
+{
+	swap_fs_submit(ctx, WRITE);
+}
+
+static void swap_fs_submit_read(struct swap_io_ctx *ctx)
+{
+	swap_fs_submit(ctx, READ);
+}
+
+static bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
+		size_t prev_folio_size, int rw)
+{
+	return swap_dev_pos(folio->swap) ==
+		swap_dev_pos(prev_folio->swap) + prev_folio_size;
+}
+
+const struct swap_ops swap_fs_ops = {
+	.submit_write		= swap_fs_submit_write,
+	.submit_read		= swap_fs_submit_read,
+	.can_merge		= swap_fs_can_merge,
+};
+
 void swap_write_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
 		return;
-
-	if (ctx->sis->flags & SWP_FS_OPS)
-		swap_fs_submit(ctx, WRITE);
-	else
-		swap_bdev_submit_write(ctx);
+	ctx->sis->ops->submit_write(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
 }
@@ -683,11 +705,7 @@ void swap_read_submit(struct swap_io_ctx
 {
 	if (!ctx->sio)
 		return;
-
-	if (ctx->sis->flags & SWP_FS_OPS)
-		swap_fs_submit(ctx, READ);
-	else
-		swap_bdev_submit_read(ctx);
+	ctx->sis->ops->submit_read(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
 }
--- a/mm/swapfile.c~mm-swap-use-swap_ops-to-register-swap-devices-methods
+++ a/mm/swapfile.c
@@ -2950,6 +2950,8 @@ static int setup_swap_extents(struct swa
 	if (ret)
 		return ret;
 
+	sis->ops = &swap_bdev_ops;
+
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
@@ -2960,6 +2962,8 @@ static int setup_swap_extents(struct swa
 		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
 		if (ret < 0)
 			return ret;
+		if (sis->flags & SWP_FS_OPS)
+			sis->ops = &swap_fs_ops;
 		sis->flags |= SWP_ACTIVATED;
 		return ret;
 	}
--- a/mm/swap.h~mm-swap-use-swap_ops-to-register-swap-devices-methods
+++ a/mm/swap.h
@@ -82,6 +82,13 @@ struct swap_io_ctx {
 	struct swap_info_struct	*sis;
 };
 
+struct swap_ops {
+	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
+			size_t prev_folio_size, int rw);
+	void (*submit_write)(struct swap_io_ctx *ctx);
+	void (*submit_read)(struct swap_io_ctx *ctx);
+};
+
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
@@ -469,6 +476,9 @@ static inline unsigned int folio_swap_fl
 
 #endif /* CONFIG_SWAP */
 
+extern const struct swap_ops swap_bdev_ops;
+extern const struct swap_ops swap_fs_ops;
+
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list);
 
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

