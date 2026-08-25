Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2445C35E944
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622894; cv=none; b=d/liaittqqb/6FfRYE3TZJ+N8Srl34n1lVIn0yA/DkDOn3ttvaepGEusq12x6V81qTswFOEI+tZJWK3XSbt6ASkLtRgVPTuEkEfxS2ojS/OC1Rh/HoIpMtXfmFaUWj22nPZ/JJ2dZYBk5KS0muuYQVr8ILzRQvyx8G3WYCoaFSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622894; c=relaxed/simple;
	bh=WNhZS5qw2BdItwRYIvJVGIeJOrldi59oJM+Hsny3ZDg=;
	h=Date:To:From:Subject:Message-Id; b=e9vmhEBl+O1SZj3D0SPM2pcoABtwT1J9cC8qoom+RbFcwhVFTGa25b9MEsyrtyuM8WV2BRGpyaOkCLD5RlVC9KrWqrzMXlP4/O+T6wCVss8RL+wONQYRULx+RfSJbG+cfIKOScgl6hyHsTyzMO9HDlfvtzdQGCpiz4mjPrrLfU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tk2uc0MU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tk2uc0MU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8D11F000E9;
	Tue, 25 Aug 2026 01:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622893;
	bh=MlUgUDueSW0JspO1buo1IzJ2VJYE30zzYyoLDWnUNQQ=;
	h=Date:To:From:Subject;
	b=tk2uc0MUZY+vNNNoDswG3WWghtqqJDadl/7DF4DN0UoFwWbWsn7en7TsEH4lsMhbJ
	 wMSTYtlPWM14oqK0Nbt5fjEZdqfR5G0+uwQuYEIKUGurVPeAcCxqKQh9FOW7ZNfX8T
	 tWCbnORc8lhvdEoVIQhZFXdQST8gr6hqy5KZbyNQ=
Date: Mon, 24 Aug 2026 18:54:52 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-use-swap_ops-to-register-swap-devices-methods.patch removed from -mm tree
Message-Id: <20260825015452.EC8D11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: use swap_ops to register swap device's methods
has been removed from the -mm tree.  Its filename was
     mm-swap-use-swap_ops-to-register-swap-devices-methods.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2963,6 +2963,8 @@ static int setup_swap_extents(struct swa
 	if (ret)
 		return ret;
 
+	sis->ops = &swap_bdev_ops;
+
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
@@ -2973,6 +2975,8 @@ static int setup_swap_extents(struct swa
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
@@ -96,6 +96,13 @@ struct swap_io_ctx {
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
@@ -483,6 +490,9 @@ static inline unsigned int folio_swap_fl
 
 #endif /* CONFIG_SWAP */
 
+extern const struct swap_ops swap_bdev_ops;
+extern const struct swap_ops swap_fs_ops;
+
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list);
 
_

Patches currently in -mm which might be from hch@lst.de are


