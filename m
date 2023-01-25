Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50977C54EED
	for <mm-commits@archiver.kernel.org>; Wed, 25 Jan 2023 21:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235756AbjAYVy1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 16:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236034AbjAYVyZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 16:54:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7E7D524
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 13:54:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6482A61637
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 21:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB863C4339E;
        Wed, 25 Jan 2023 21:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674683660;
        bh=U/noXfss+tUMRGVp/NzPCPtmTCxq4TJOGn8W2kw+7FE=;
        h=Date:To:From:Subject:From;
        b=pdxKrKlfylgUWotyTVVmADjl0kYPVCKCs/Sa8udWSOHD2WhXpCtK075gIJUKyqKBL
         QfN6Ny7U6ahnB4Dq3ECrIPkr+ZPxsT3qCjh5hsrGemlh0JVwFqkvuz5fa/C/EAaxN5
         r1T7jobzaaLqzlSS1jpTqMqF4hPbrkunnd3hWqHA=
Date:   Wed, 25 Jan 2023 13:54:20 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch removed from -mm tree
Message-Id: <20230125215420.BB863C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: convert queue_pages_hugetlb() to queue_folios_hugetlb()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/mempolicy: convert queue_pages_hugetlb() to queue_folios_hugetlb()
Date: Mon, 23 Jan 2023 17:22:08 -0800

This change is in preparation for the conversion of queue_pages_required()
to queue_folio_required() and migrate_page_add() to migrate_folio_add().

Link: https://lkml.kernel.org/r/20230124012210.13963-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mempolicy.c~mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb
+++ a/mm/mempolicy.c
@@ -558,7 +558,7 @@ static int queue_folios_pte_range(pmd_t
 	return addr != end ? -EIO : 0;
 }
 
-static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
+static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
 			       unsigned long addr, unsigned long end,
 			       struct mm_walk *walk)
 {
@@ -566,7 +566,7 @@ static int queue_pages_hugetlb(pte_t *pt
 #ifdef CONFIG_HUGETLB_PAGE
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = (qp->flags & MPOL_MF_VALID);
-	struct page *page;
+	struct folio *folio;
 	spinlock_t *ptl;
 	pte_t entry;
 
@@ -574,13 +574,13 @@ static int queue_pages_hugetlb(pte_t *pt
 	entry = huge_ptep_get(pte);
 	if (!pte_present(entry))
 		goto unlock;
-	page = pte_page(entry);
-	if (!queue_pages_required(page, qp))
+	folio = pfn_folio(pte_pfn(entry));
+	if (!queue_pages_required(&folio->page, qp))
 		goto unlock;
 
 	if (flags == MPOL_MF_STRICT) {
 		/*
-		 * STRICT alone means only detecting misplaced page and no
+		 * STRICT alone means only detecting misplaced folio and no
 		 * need to further check other vma.
 		 */
 		ret = -EIO;
@@ -591,20 +591,27 @@ static int queue_pages_hugetlb(pte_t *pt
 		/*
 		 * Must be STRICT with MOVE*, otherwise .test_walk() have
 		 * stopped walking current vma.
-		 * Detecting misplaced page but allow migrating pages which
+		 * Detecting misplaced folio but allow migrating folios which
 		 * have been queued.
 		 */
 		ret = 1;
 		goto unlock;
 	}
 
-	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
+	/*
+	 * With MPOL_MF_MOVE, we try to migrate only unshared folios. If it
+	 * is shared it is likely not worth migrating.
+	 *
+	 * To check if the folio is shared, ideally we want to make sure
+	 * every page is mapped to the same process. Doing that is very
+	 * expensive, so check the estimated mapcount of the folio instead.
+	 */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
-	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
-		if (isolate_hugetlb(page_folio(page), qp->pagelist) &&
+	    (flags & MPOL_MF_MOVE && folio_estimated_mapcount(folio) == 1)) {
+		if (isolate_hugetlb(folio, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
-			 * Failed to isolate page but allow migrating pages
+			 * Failed to isolate folio but allow migrating folios
 			 * which have been queued.
 			 */
 			ret = 1;
@@ -702,7 +709,7 @@ static int queue_pages_test_walk(unsigne
 }
 
 static const struct mm_walk_ops queue_pages_walk_ops = {
-	.hugetlb_entry		= queue_pages_hugetlb,
+	.hugetlb_entry		= queue_folios_hugetlb,
 	.pmd_entry		= queue_folios_pte_range,
 	.test_walk		= queue_pages_test_walk,
 };
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
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch

