Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAEEEC54E94
	for <mm-commits@archiver.kernel.org>; Wed, 25 Jan 2023 21:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235442AbjAYVyU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 16:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjAYVyT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 16:54:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C065986A8
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 13:54:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AD4061630
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 21:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01D0C4339B;
        Wed, 25 Jan 2023 21:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674683657;
        bh=i9pGaRAD3w+aCW4UdbVgREfmDlUXoHXr/J3I9RU6inA=;
        h=Date:To:From:Subject:From;
        b=Qyhbl84LQRFjLThcewBE016Ob0RfSQ8GFOgr4rzA6gN0JqRs0t2PjXzz6NXnmAOhl
         QsIPWaGSAwq57A4r23yGgJyDWAvyGoUHihuN3e/nSpe4y8PKcZpw9ZSknGV55tRsZ+
         OoomUwmc2/kSZlBaYGvwiSfue8xTkJUrmmKU1gHI=
Date:   Wed, 25 Jan 2023 13:54:17 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-add-folio_estimated_mapcount.patch removed from -mm tree
Message-Id: <20230125215417.B01D0C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add folio_estimated_mapcount()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_estimated_mapcount.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm: add folio_estimated_mapcount()
Date: Mon, 23 Jan 2023 17:22:05 -0800

Patch series "Convert various mempolicy.c functions", v2.

This patch series converts migrate_page_add() and queue_pages_required()
to migrate_folio_add() and queue_page_required().  It also converts the
callers of the functions to use folios as well, and introduces a helper
function to estimate a folio's mapcount.


This patch (of 6):

folio_estimated_mapcount() takes in a folio and calls page_mapcount() on
the first page of that folio.

This is necessary for folio conversions where we only care about either the
entire_mapcount of a large folio, or the mapcount of a not large folio.

This is in contrast to folio_mapcount() which calculates the total
number of the times a folio and its subpages are mapped.

Link: https://lkml.kernel.org/r/20230124012210.13963-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20230124012210.13963-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-add-folio_estimated_mapcount
+++ a/include/linux/mm.h
@@ -913,6 +913,11 @@ static inline int page_mapcount(struct p
 	return mapcount;
 }
 
+static inline int folio_estimated_mapcount(struct folio *folio)
+{
+	return page_mapcount(folio_page(folio, 0));
+}
+
 int folio_total_mapcount(struct folio *folio);
 
 /**
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
mm-mempolicy-convert-queue_pages_pmd-to-queue_folios_pmd.patch
mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch
mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch

