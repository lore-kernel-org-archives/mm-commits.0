Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00821C2B9F7
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 20:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D357061406
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 20:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhEXUGU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 May 2021 16:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232107AbhEXUGU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 May 2021 16:06:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5D33613E1;
        Mon, 24 May 2021 20:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621886691;
        bh=Gta4eoYkgCXG84tIYX+3AM8WshKuKeUczoXdMYF0mAA=;
        h=Date:From:To:Subject:From;
        b=Ts51vXFnM6SbrIdvftDXwOeQpUmeGWTCeWjXZlAlYfVG8qSMxWNsGElAhtKi4/QP+
         iD4yS6bIb145jfGmwltnqWMOUVGjhzvPJ+zOsPNI0DNLNf54/vcJusrREKmu+S8BLq
         CYnY5KxCME8/J5JwAl3QPE98z6eayndRmfuOnIOM=
Date:   Mon, 24 May 2021 13:04:51 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210524200451.7asKzuqXb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |   13 -----------
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c   |    5 ----
 fs/btrfs/compression.c                  |   25 ----------------------
 3 files changed, 43 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1165,19 +1165,6 @@ static void amdgpu_ttm_tt_unpopulate(str
 	if (gtt && gtt->userptr) {
 		amdgpu_ttm_tt_set_user_pages(ttm, NULL);
 		kfree(ttm->sg);
-<<<<<<< HEAD
-		ttm->sg = NULL;
-		ttm->page_flags &= ~TTM_PAGE_FLAG_SG;
-		return;
-	}
-
-	if (ttm->sg && gtt->gobj->import_attach) {
-		struct dma_buf_attachment *attach;
-
-		attach = gtt->gobj->import_attach;
-		dma_buf_unmap_attachment(attach, ttm->sg, DMA_BIDIRECTIONAL);
-=======
->>>>>>> linux-next/akpm-base
 		ttm->sg = NULL;
 		ttm->page_flags &= ~TTM_PAGE_FLAG_SG;
 		return;
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -386,14 +386,9 @@ done:
 static int vcn_v3_0_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
-<<<<<<< HEAD
-	struct amdgpu_ring *ring;
-	int i;
-=======
 	int i;
 
 	cancel_delayed_work_sync(&adev->vcn.idle_work);
->>>>>>> linux-next/akpm-base
 
 	for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
 		if (adev->vcn.harvest_config & (1 << i))
--- a/fs/btrfs/compression.c~linux-next-git-rejects
+++ a/fs/btrfs/compression.c
@@ -349,14 +349,8 @@ static void end_compressed_bio_write(str
 	 * call back into the FS and do all the end_io operations
 	 */
 	inode = cb->inode;
-<<<<<<< HEAD
-	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
-	btrfs_record_physical_zoned(inode, cb->start, bio);
-	btrfs_writepage_endio_finish_ordered(cb->compressed_pages[0],
-=======
 	btrfs_record_physical_zoned(inode, cb->start, bio);
 	btrfs_writepage_endio_finish_ordered(BTRFS_I(inode), NULL,
->>>>>>> linux-next/akpm-base
 			cb->start, cb->start + cb->len - 1,
 			bio->bi_status == BLK_STS_OK);
 
@@ -431,35 +425,16 @@ blk_status_t btrfs_submit_compressed_wri
 	bio->bi_end_io = end_compressed_bio_write;
 
 	if (use_append) {
-<<<<<<< HEAD
-		struct extent_map *em;
-		struct map_lookup *map;
-		struct block_device *bdev;
-
-		em = btrfs_get_chunk_map(fs_info, disk_start, PAGE_SIZE);
-		if (IS_ERR(em)) {
-=======
 		struct btrfs_device *device;
 
 		device = btrfs_zoned_get_device(fs_info, disk_start, PAGE_SIZE);
 		if (IS_ERR(device)) {
->>>>>>> linux-next/akpm-base
 			kfree(cb);
 			bio_put(bio);
 			return BLK_STS_NOTSUPP;
 		}
 
-<<<<<<< HEAD
-		map = em->map_lookup;
-		/* We only support single profile for now */
-		ASSERT(map->num_stripes == 1);
-		bdev = map->stripes[0].dev->bdev;
-
-		bio_set_dev(bio, bdev);
-		free_extent_map(em);
-=======
 		bio_set_dev(bio, device->bdev);
->>>>>>> linux-next/akpm-base
 	}
 
 	if (blkcg_css) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
linux-next-pre.patch
linux-next-post.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

