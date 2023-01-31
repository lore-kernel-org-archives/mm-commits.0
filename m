Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60494C636D3
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjAaA2T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjAaA2R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:28:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAC916ACC
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:28:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28CB86133A
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D772C433EF;
        Tue, 31 Jan 2023 00:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124895;
        bh=XFGxxqpkLsqcL/vtvSC/Sp/WtGIfEu3DO2cMjVxe9tM=;
        h=Date:To:From:Subject:From;
        b=zJRam9bzBcC4YxnjnDaWI7FFfUdW+tazXo4zDVtgpZRhxD2KFd37fj0X7nU4O25/D
         kMeDogfxgdYiQAX6w1vNnETP+PSBm3uccaeQmF78qON1pX4lyTq26cTS2kACqngu/D
         ypjWrlV/LRC+GWWkswZuXIxw3VJWHtRCSRMw1DAc=
Date:   Mon, 30 Jan 2023 16:28:14 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-convert-putback_movable_pages-to-use-folios.patch added to mm-unstable branch
Message-Id: <20230131002815.7D772C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: convert putback_movable_pages() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-convert-putback_movable_pages-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-convert-putback_movable_pages-to-use-folios.patch

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
Subject: mm/migrate: convert putback_movable_pages() to use folios
Date: Mon, 30 Jan 2023 13:43:52 -0800

Removes 6 calls to compound_head(), and replaces putback_movable_page()
with putback_movable_folio() as well.

Link: https://lkml.kernel.org/r/20230130214352.40538-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~mm-migrate-convert-putback_movable_pages-to-use-folios
+++ a/mm/migrate.c
@@ -129,12 +129,12 @@ out:
 	return -EBUSY;
 }
 
-static void putback_movable_page(struct page *page)
+static void putback_movable_folio(struct folio *folio)
 {
-	const struct movable_operations *mops = page_movable_ops(page);
+	const struct movable_operations *mops = folio_movable_ops(folio);
 
-	mops->putback_page(page);
-	ClearPageIsolated(page);
+	mops->putback_page(&folio->page);
+	folio_clear_isolated(folio);
 }
 
 /*
@@ -147,33 +147,33 @@ static void putback_movable_page(struct
  */
 void putback_movable_pages(struct list_head *l)
 {
-	struct page *page;
-	struct page *page2;
+	struct folio *folio;
+	struct folio *folio2;
 
-	list_for_each_entry_safe(page, page2, l, lru) {
-		if (unlikely(PageHuge(page))) {
-			folio_putback_active_hugetlb(page_folio(page));
+	list_for_each_entry_safe(folio, folio2, l, lru) {
+		if (unlikely(folio_test_hugetlb(folio))) {
+			folio_putback_active_hugetlb(folio);
 			continue;
 		}
-		list_del(&page->lru);
+		list_del(&folio->lru);
 		/*
-		 * We isolated non-lru movable page so here we can use
-		 * __PageMovable because LRU page's mapping cannot have
+		 * We isolated non-lru movable folio so here we can use
+		 * __PageMovable because LRU folio's mapping cannot have
 		 * PAGE_MAPPING_MOVABLE.
 		 */
-		if (unlikely(__PageMovable(page))) {
-			VM_BUG_ON_PAGE(!PageIsolated(page), page);
-			lock_page(page);
-			if (PageMovable(page))
-				putback_movable_page(page);
+		if (unlikely(__folio_test_movable(folio))) {
+			VM_BUG_ON_FOLIO(!folio_test_isolated(folio), folio);
+			folio_lock(folio);
+			if (folio_test_movable(folio))
+				putback_movable_folio(folio);
 			else
-				ClearPageIsolated(page);
-			unlock_page(page);
-			put_page(page);
+				folio_clear_isolated(folio);
+			folio_unlock(folio);
+			folio_put(folio);
 		} else {
-			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
-					page_is_file_lru(page), -thp_nr_pages(page));
-			putback_lru_page(page);
+			node_stat_mod_folio(folio, NR_ISOLATED_ANON +
+					folio_is_file_lru(folio), -folio_nr_pages(folio));
+			folio_putback_lru(folio);
 		}
 	}
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

