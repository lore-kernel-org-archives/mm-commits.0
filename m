Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C760C54E94
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 00:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbjAZATj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjAZATi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 19:19:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECE15142D
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 16:19:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23B00B81C64
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 00:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2FDC433D2;
        Thu, 26 Jan 2023 00:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674692374;
        bh=PYewhYLlzalsV2CiXrG0qnJC5fo46kbESFpfMCQ+H+I=;
        h=Date:To:From:Subject:From;
        b=YeltfxOsS3hIpojeWaKVjRO2TYO2VkgHcDY8+aDB0cXjKhdsT0kIEyD+hVdq/SiYn
         4OWHxtA3JRP6XfX7Dif8d5+2eDzglCAgKYHIooeqzAACtf5si8URec6eAq5oxJgc52
         XVfozn6R8KcKxVoluSh+riGvTHcxIfnOnf/2VxXo=
Date:   Wed, 25 Jan 2023 16:19:34 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch added to mm-unstable branch
Message-Id: <20230126001934.BA2FDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: convert migrate_page_add() to migrate_folio_add()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch

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
Subject: mm/mempolicy: convert migrate_page_add() to migrate_folio_add()
Date: Wed, 25 Jan 2023 15:41:34 -0800

Replace migrate_page_add() with migrate_folio_add().  migrate_folio_add()
does the same a migrate_page_add() but takes in a folio instead of a page.
This removes a couple of calls to compound_head().

Link: https://lkml.kernel.org/r/20230125234134.227244-7-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mempolicy.c~mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add
+++ a/mm/mempolicy.c
@@ -414,7 +414,7 @@ static const struct mempolicy_operations
 	},
 };
 
-static int migrate_page_add(struct page *page, struct list_head *pagelist,
+static int migrate_folio_add(struct folio *folio, struct list_head *foliolist,
 				unsigned long flags);
 
 struct queue_pages {
@@ -476,7 +476,7 @@ static int queue_folios_pmd(pmd_t *pmd,
 	/* go to folio migration */
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
 		if (!vma_migratable(walk->vma) ||
-		    migrate_page_add(&folio->page, qp->pagelist, flags)) {
+		    migrate_folio_add(folio, qp->pagelist, flags)) {
 			ret = 1;
 			goto unlock;
 		}
@@ -544,7 +544,7 @@ static int queue_folios_pte_range(pmd_t
 			 * temporary off LRU pages in the range.  Still
 			 * need migrate other LRU pages.
 			 */
-			if (migrate_page_add(&folio->page, qp->pagelist, flags))
+			if (migrate_folio_add(folio, qp->pagelist, flags))
 				has_unmovable = true;
 		} else
 			break;
@@ -1020,27 +1020,28 @@ static long do_get_mempolicy(int *policy
 }
 
 #ifdef CONFIG_MIGRATION
-/*
- * page migration, thp tail pages can be passed.
- */
-static int migrate_page_add(struct page *page, struct list_head *pagelist,
+static int migrate_folio_add(struct folio *folio, struct list_head *foliolist,
 				unsigned long flags)
 {
-	struct page *head = compound_head(page);
 	/*
-	 * Avoid migrating a page that is shared with others.
+	 * We try to migrate only unshared folios. If it is shared it
+	 * is likely not worth migrating.
+	 *
+	 * To check if the folio is shared, ideally we want to make sure
+	 * every page is mapped to the same process. Doing that is very
+	 * expensive, so check the estimated mapcount of the folio instead.
 	 */
-	if ((flags & MPOL_MF_MOVE_ALL) || page_mapcount(head) == 1) {
-		if (!isolate_lru_page(head)) {
-			list_add_tail(&head->lru, pagelist);
-			mod_node_page_state(page_pgdat(head),
-				NR_ISOLATED_ANON + page_is_file_lru(head),
-				thp_nr_pages(head));
+	if ((flags & MPOL_MF_MOVE_ALL) || folio_estimated_mapcount(folio) == 1) {
+		if (!folio_isolate_lru(folio)) {
+			list_add_tail(&folio->lru, foliolist);
+			node_stat_mod_folio(folio,
+				NR_ISOLATED_ANON + folio_is_file_lru(folio),
+				folio_nr_pages(folio));
 		} else if (flags & MPOL_MF_STRICT) {
 			/*
-			 * Non-movable page may reach here.  And, there may be
-			 * temporary off LRU pages or non-LRU movable pages.
-			 * Treat them as unmovable pages since they can't be
+			 * Non-movable folio may reach here.  And, there may be
+			 * temporary off LRU folios or non-LRU movable folios.
+			 * Treat them as unmovable folios since they can't be
 			 * isolated, so they can't be moved at the moment.  It
 			 * should return -EIO for this case too.
 			 */
@@ -1232,7 +1233,7 @@ static struct page *new_page(struct page
 }
 #else
 
-static int migrate_page_add(struct page *page, struct list_head *pagelist,
+static int migrate_folio_add(struct folio *folio, struct list_head *foliolist,
 				unsigned long flags)
 {
 	return -EIO;
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
mm-add-folio_estimated_mapcount.patch
mm-mempolicy-convert-queue_pages_pmd-to-queue_folios_pmd.patch
mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch
mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch

