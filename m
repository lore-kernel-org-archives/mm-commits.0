Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95603C54EAA
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjAaA2S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjAaA2Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:28:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE4417CE0
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:28:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7928561326
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DC4C433EF;
        Tue, 31 Jan 2023 00:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124893;
        bh=kQ1VPOp4ZI2ACk/yg/7N/6fMgB4Vn1YBi/KI/9LIOFw=;
        h=Date:To:From:Subject:From;
        b=rfsPHw1wSY20mxGMf54EC4d9m3UaH72N+THDsCDYvXPQkx1iY0MLAnJaPWF+yLGSK
         +6Lro+YgvLLtwPxDltRn/cp+gnXIOPcPM0/vlC96Ezoo7bMwu8LwTBdfu4+6D8fY58
         8zybYvlqksG9813eRe9B72JA+xFXFiLImFy8Tch0=
Date:   Mon, 30 Jan 2023 16:28:13 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-convert-isolate_movable_page-to-use-folios.patch added to mm-unstable branch
Message-Id: <20230131002813.D1DC4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: convert isolate_movable_page() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-convert-isolate_movable_page-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-convert-isolate_movable_page-to-use-folios.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/migrate: convert isolate_movable_page() to use folios
Date: Mon, 30 Jan 2023 13:43:51 -0800

Removes 6 calls to compound_head() and prepares the function to take in a
folio instead of page argument.

Link: https://lkml.kernel.org/r/20230130214352.40538-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~mm-migrate-convert-isolate_movable_page-to-use-folios
+++ a/mm/migrate.c
@@ -60,6 +60,7 @@
 
 int isolate_movable_page(struct page *page, isolate_mode_t mode)
 {
+	struct folio *folio = folio_get_nontail_page(page);
 	const struct movable_operations *mops;
 
 	/*
@@ -71,11 +72,11 @@ int isolate_movable_page(struct page *pa
 	 * the put_page() at the end of this block will take care of
 	 * release this page, thus avoiding a nasty leakage.
 	 */
-	if (unlikely(!get_page_unless_zero(page)))
+	if (!folio)
 		goto out;
 
-	if (unlikely(PageSlab(page)))
-		goto out_putpage;
+	if (unlikely(folio_test_slab(folio)))
+		goto out_putfolio;
 	/* Pairs with smp_wmb() in slab freeing, e.g. SLUB's __free_slab() */
 	smp_rmb();
 	/*
@@ -83,12 +84,12 @@ int isolate_movable_page(struct page *pa
 	 * we use non-atomic bitops on newly allocated page flags so
 	 * unconditionally grabbing the lock ruins page's owner side.
 	 */
-	if (unlikely(!__PageMovable(page)))
-		goto out_putpage;
+	if (unlikely(!__folio_test_movable(folio)))
+		goto out_putfolio;
 	/* Pairs with smp_wmb() in slab allocation, e.g. SLUB's alloc_slab_page() */
 	smp_rmb();
-	if (unlikely(PageSlab(page)))
-		goto out_putpage;
+	if (unlikely(folio_test_slab(folio)))
+		goto out_putfolio;
 
 	/*
 	 * As movable pages are not isolated from LRU lists, concurrent
@@ -101,29 +102,29 @@ int isolate_movable_page(struct page *pa
 	 * lets be sure we have the page lock
 	 * before proceeding with the movable page isolation steps.
 	 */
-	if (unlikely(!trylock_page(page)))
-		goto out_putpage;
+	if (unlikely(!folio_trylock(folio)))
+		goto out_putfolio;
 
-	if (!PageMovable(page) || PageIsolated(page))
+	if (!folio_test_movable(folio) || folio_test_isolated(folio))
 		goto out_no_isolated;
 
-	mops = page_movable_ops(page);
-	VM_BUG_ON_PAGE(!mops, page);
+	mops = folio_movable_ops(folio);
+	VM_BUG_ON_FOLIO(!mops, folio);
 
-	if (!mops->isolate_page(page, mode))
+	if (!mops->isolate_page(&folio->page, mode))
 		goto out_no_isolated;
 
 	/* Driver shouldn't use PG_isolated bit of page->flags */
-	WARN_ON_ONCE(PageIsolated(page));
-	SetPageIsolated(page);
-	unlock_page(page);
+	WARN_ON_ONCE(folio_test_isolated(folio));
+	folio_set_isolated(folio);
+	folio_unlock(folio);
 
 	return 0;
 
 out_no_isolated:
-	unlock_page(page);
-out_putpage:
-	put_page(page);
+	folio_unlock(folio);
+out_putfolio:
+	folio_put(folio);
 out:
 	return -EBUSY;
 }
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-khugepaged-introduce-release_pte_folio-to-replace-release_pte_page.patch
mm-khugepaged-convert-release_pte_pages-to-use-folios.patch
pagemap-add-filemap_grab_folio.patch
filemap-added-filemap_get_folios_tag.patch
filemap-convert-__filemap_fdatawait_range-to-use-filemap_get_folios_tag.patch
page-writeback-convert-write_cache_pages-to-use-filemap_get_folios_tag.patch
afs-convert-afs_writepages_region-to-use-filemap_get_folios_tag.patch
btrfs-convert-btree_write_cache_pages-to-use-filemap_get_folio_tag.patch
btrfs-convert-extent_write_cache_pages-to-use-filemap_get_folios_tag.patch
ceph-convert-ceph_writepages_start-to-use-filemap_get_folios_tag.patch
cifs-convert-wdata_alloc_and_fillpages-to-use-filemap_get_folios_tag.patch
ext4-convert-mpage_prepare_extent_to_map-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_fsync_node_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_flush_inline_data-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_sync_node_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_write_cache_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-last_fsync_dnode-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_sync_meta_pages-to-use-filemap_get_folios_tag.patch
gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_lookup_dirty_node_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_btree_lookup_dirty_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_copy_dirty_pages-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_clear_dirty_pages-to-use-filemap_get_folios_tag.patch
filemap-remove-find_get_pages_range_tag.patch
mm-add-folio_estimated_sharers.patch
mm-mempolicy-convert-queue_pages_pmd-to-queue_folios_pmd.patch
mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch
mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch
mm-add-folio_get_nontail_page.patch
mm-migrate-add-folio_movable_ops.patch
mm-migrate-convert-isolate_movable_page-to-use-folios.patch
mm-migrate-convert-putback_movable_pages-to-use-folios.patch

