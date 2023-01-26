Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E743DC27C76
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 00:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjAZAT3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjAZAT2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 19:19:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272F651C74
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 16:19:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B32AE616B6
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 00:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D06C433D2;
        Thu, 26 Jan 2023 00:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674692366;
        bh=63o9qU+B1TwZfjgWWzoPwO7TeLgRYWC0MTp4Q1tQHLY=;
        h=Date:To:From:Subject:From;
        b=x8Ry3kmbJ1wxxWcsns4vKFwHaT2alo/wrS50NFeEGk25yz45e+V9ZiJ029oiuFiUF
         Q0ImaVc3pTmjNlYsGW5pSdVvS3EUDAQjNyXoMz3KFTAsIgUXnUqmUCdxHSBQ3ughq3
         yKX9UAwN6sT8i8lZXa6GlB2MyHyJa9F6uPQQvYSw=
Date:   Wed, 25 Jan 2023 16:19:25 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_estimated_mapcount.patch added to mm-unstable branch
Message-Id: <20230126001926.13D06C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add folio_estimated_mapcount()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-folio_estimated_mapcount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_estimated_mapcount.patch

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
Subject: mm: add folio_estimated_mapcount()
Date: Wed, 25 Jan 2023 15:41:29 -0800

Patch series "Convert various mempolicy.c functions to use folios", v3.

This patch series converts migrate_page_add() and queue_pages_required()
to migrate_folio_add() and queue_page_required().  It also converts the
callers of the functions to use folios as well, and introduces a helper
function to estimate a folio's mapcount.


This patch (of 6):

folio_estimated_mapcount() takes in a folio and returns the precise
number of times the first subpage of the folio is mapped.

This function aims to provide an estimate for the mapcount of a subpage
within a folio. This is necessary for folio conversions where we care
about the mapcount of a subpage, but not necessarily the whole folio.

This is in contrast to folio_mapcount() which calculates the total
number of the times a folio and all its subpages are mapped.

Link: https://lkml.kernel.org/r/20230125234134.227244-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20230125234134.227244-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-add-folio_estimated_mapcount
+++ a/include/linux/mm.h
@@ -1855,6 +1855,23 @@ static inline size_t folio_size(struct f
 	return PAGE_SIZE << folio_order(folio);
 }
 
+/**
+ * folio_estimated_mapcount - Estimate a folio's per-page mapcount.
+ * @folio: The folio.
+ *
+ * folio_estimated_mapcount() aims to serve as a function to efficiently
+ * estimate the number of times each page in a folio is mapped.
+ * This may not be accurate for large folios. If you want exact mapcounts,
+ * look at page_mapcount() or folio_total_mapcount().
+ *
+ * Return: The precise mapcount of the first subpage, meant to estimate
+ * the precise mapcount of any subpage.
+ */
+static inline int folio_estimated_mapcount(struct folio *folio)
+{
+	return page_mapcount(folio_page(folio, 0));
+}
+
 #ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
 static inline int arch_make_page_accessible(struct page *page)
 {
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

