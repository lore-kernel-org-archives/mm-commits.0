Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36AA5C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjASBSn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjASBQd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:16:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3386B9A3
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E10EB81FB6
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17284C433EF;
        Thu, 19 Jan 2023 01:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090908;
        bh=Eo4EjqsSUcc57h/x0TOXEfj0g0VaGaOxOX65cICxK0I=;
        h=Date:To:From:Subject:From;
        b=GR8JIUFvV7stqXALKcqJuu3L775QaVYhkoSztUkTnDgJcKmISclI+hBop06nIOIIy
         mF6h+vDTn2a1KLjIgdsWvgarMwIYZ+Pj6iShFoF9Y2oJGcuYnXT5c3cw8u/9wya3bF
         l2E4TDq9GSibwlHe6B6xhxsJuS9u+1tux3/GA6cs=
Date:   Wed, 18 Jan 2023 17:15:07 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, sj@kernel.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch removed from -mm tree
Message-Id: <20230119011508.17284C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: convert damon_pa_mark_accessed_or_deactivate() to use folios
has been removed from the -mm tree.  Its filename was
     mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/damon: convert damon_pa_mark_accessed_or_deactivate() to use folios
Date: Wed, 21 Dec 2022 10:08:47 -0800

This change replaces 2 calls to compound_head() from put_page() and 1 call
from mark_page_accessed() with one from page_folio().  This is in
preparation for the conversion of deactivate_page() to folio_deactivate().

Link: https://lkml.kernel.org/r/20221221180848.20774-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios
+++ a/mm/damon/paddr.c
@@ -283,21 +283,23 @@ static inline unsigned long damon_pa_mar
 
 	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
 		struct page *page = damon_get_page(PHYS_PFN(addr));
+		struct folio *folio;
 
 		if (!page)
 			continue;
+		folio = page_folio(page);
 
-		if (damos_pa_filter_out(s, page)) {
-			put_page(page);
+		if (damos_pa_filter_out(s, &folio->page)) {
+			folio_put(folio);
 			continue;
 		}
 
 		if (mark_accessed)
-			mark_page_accessed(page);
+			folio_mark_accessed(folio);
 		else
-			deactivate_page(page);
-		put_page(page);
-		applied++;
+			deactivate_page(&folio->page);
+		folio_put(folio);
+		applied += folio_nr_pages(folio);
 	}
 	return applied * PAGE_SIZE;
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

