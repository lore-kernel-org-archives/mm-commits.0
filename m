Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7409C6379F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbjBCGkv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbjBCGjp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:39:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD298F259
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A06F1B82980
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445B8C433EF;
        Fri,  3 Feb 2023 06:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406228;
        bh=nNqM7yyoKmpt6hjIBSkG6lwHw3OD1PsXj0+11g7HyYo=;
        h=Date:To:From:Subject:From;
        b=J1XVGcc0AF3mQ0dYldsB/UU2qCtCiP2FY8WPpY7wpGH9nE78c6wkGWvunsRxTo5t3
         2Zkzet+L9sHK2Gj6Z06LszhxFmQvlVlJX79jQ/hTfzPE5M6BX3WHbPHs3X8BTeWgB6
         Cm2UzSoryUYwAQB5SzEivmvg2rrK2WKvC9Af1O7I=
Date:   Thu, 02 Feb 2023 22:37:07 -0800
To:     mm-commits@vger.kernel.org, dsterba@suse.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] btrfs-convert-btree_write_cache_pages-to-use-filemap_get_folio_tag.patch removed from -mm tree
Message-Id: <20230203063708.445B8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: btrfs: convert btree_write_cache_pages() to use filemap_get_folio_tag()
has been removed from the -mm tree.  Its filename was
     btrfs-convert-btree_write_cache_pages-to-use-filemap_get_folio_tag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: btrfs: convert btree_write_cache_pages() to use filemap_get_folio_tag()
Date: Wed, 4 Jan 2023 13:14:31 -0800

Convert function to use folios throughout.  This is in preparation for the
removal of find_get_pages_range_tag().

Link: https://lkml.kernel.org/r/20230104211448.4804-7-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/btrfs/extent_io.c~btrfs-convert-btree_write_cache_pages-to-use-filemap_get_folio_tag
+++ a/fs/btrfs/extent_io.c
@@ -2865,14 +2865,14 @@ int btree_write_cache_pages(struct addre
 	int ret = 0;
 	int done = 0;
 	int nr_to_write_done = 0;
-	struct pagevec pvec;
-	int nr_pages;
+	struct folio_batch fbatch;
+	unsigned int nr_folios;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
 	xa_mark_t tag;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
@@ -2895,14 +2895,15 @@ retry:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		tag_pages_for_writeback(mapping, index, end);
 	while (!done && !nr_to_write_done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
-			tag))) {
+	       (nr_folios = filemap_get_folios_tag(mapping, &index, end,
+					    tag, &fbatch))) {
 		unsigned i;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct folio *folio = fbatch.folios[i];
 
-			ret = submit_eb_page(page, wbc, &bio_ctrl, &eb_context);
+			ret = submit_eb_page(&folio->page, wbc, &bio_ctrl,
+					&eb_context);
 			if (ret == 0)
 				continue;
 			if (ret < 0) {
@@ -2917,7 +2918,7 @@ retry:
 			 */
 			nr_to_write_done = wbc->nr_to_write <= 0;
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 	if (!scanned && !done) {
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

