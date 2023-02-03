Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47DA6C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbjBCGlE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbjBCGjs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:39:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B20C8F26F
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7FB5B82980
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FB8C433D2;
        Fri,  3 Feb 2023 06:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406240;
        bh=j37KQW7Eiq4TEo66B0Ce11XHrGKePvVZm2CYnmalCYE=;
        h=Date:To:From:Subject:From;
        b=u5dzmlKNHvu5HauFKhl0XhyoNZGtR8qn0bWacLktkvFkRFSEUzchl8cbBnmUUVyhQ
         z52QOsauH+YyQEYZ/SxMfhKs3PDXEALgldiszEaBQrJ0TjYncq27xdy+jR6bJBwVgf
         5WzJtfsEBHh/kj/VRHgg6n6iT1BHiHvCxLwXzGVs=
Date:   Thu, 02 Feb 2023 22:37:19 -0800
To:     mm-commits@vger.kernel.org, chao@kernel.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] f2fs-convert-f2fs_sync_node_pages-to-use-filemap_get_folios_tag.patch removed from -mm tree
Message-Id: <20230203063720.49FB8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: f2fs: convert f2fs_sync_node_pages() to use filemap_get_folios_tag()
has been removed from the -mm tree.  Its filename was
     f2fs-convert-f2fs_sync_node_pages-to-use-filemap_get_folios_tag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: f2fs: convert f2fs_sync_node_pages() to use filemap_get_folios_tag()
Date: Wed, 4 Jan 2023 13:14:38 -0800

Convert function to use a folio_batch instead of pagevec.  This is in
preparation for the removal of find_get_pages_range_tag().

Link: https://lkml.kernel.org/r/20230104211448.4804-14-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Chao Yu <chao@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/f2fs/node.c~f2fs-convert-f2fs_sync_node_pages-to-use-filemap_get_folios_tag
+++ a/fs/f2fs/node.c
@@ -1938,23 +1938,24 @@ int f2fs_sync_node_pages(struct f2fs_sb_
 				bool do_balance, enum iostat_type io_type)
 {
 	pgoff_t index;
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	int step = 0;
 	int nwritten = 0;
 	int ret = 0;
-	int nr_pages, done = 0;
+	int nr_folios, done = 0;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
 next_step:
 	index = 0;
 
-	while (!done && (nr_pages = pagevec_lookup_tag(&pvec,
-			NODE_MAPPING(sbi), &index, PAGECACHE_TAG_DIRTY))) {
+	while (!done && (nr_folios = filemap_get_folios_tag(NODE_MAPPING(sbi),
+				&index, (pgoff_t)-1, PAGECACHE_TAG_DIRTY,
+				&fbatch))) {
 		int i;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct page *page = &fbatch.folios[i]->page;
 			bool submitted = false;
 
 			/* give a priority to WB_SYNC threads */
@@ -2029,7 +2030,7 @@ write_node:
 			if (--wbc->nr_to_write == 0)
 				break;
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 
 		if (wbc->nr_to_write == 0) {
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

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

