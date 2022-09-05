Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D848ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiIEW1I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiIEW1H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:27:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8B62BB2D
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:27:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9CBAB81598
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E86C433C1;
        Mon,  5 Sep 2022 22:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662416823;
        bh=AT7GQXmIchxV94CZiaq51dL3b2QnDTAIvc3idRXXs+Q=;
        h=Date:To:From:Subject:From;
        b=omr9mSLzyxoWrrLSR648s7qe+oCA1JWb2hOrLQq+JuCsodHwjMGq2rr7dzq2qT2Qd
         p9p4WWK0stoQO2NCUNeN8K2gkRa8yAmyClQPH+yMbz5HC6XlF3sCoValR7jfqLu6fV
         95myR/W4d/8JYBkkIERnL4N/O3lRUDDx4oy2nZO0=
Date:   Mon, 05 Sep 2022 15:27:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-convert-filemap_range_has_writeback-to-use-folios.patch added to mm-unstable branch
Message-Id: <20220905222703.83E86C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: convert filemap_range_has_writeback() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-convert-filemap_range_has_writeback-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-convert-filemap_range_has_writeback-to-use-folios.patch

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
Subject: filemap: convert filemap_range_has_writeback() to use folios
Date: Mon, 5 Sep 2022 14:45:57 -0700

Removes 3 calls to compound_head().

Link: https://lkml.kernel.org/r/20220905214557.868606-1-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~filemap-convert-filemap_range_has_writeback-to-use-folios
+++ a/mm/filemap.c
@@ -632,22 +632,23 @@ bool filemap_range_has_writeback(struct
 {
 	XA_STATE(xas, &mapping->i_pages, start_byte >> PAGE_SHIFT);
 	pgoff_t max = end_byte >> PAGE_SHIFT;
-	struct page *page;
+	struct folio *folio;
 
 	if (end_byte < start_byte)
 		return false;
 
 	rcu_read_lock();
-	xas_for_each(&xas, page, max) {
-		if (xas_retry(&xas, page))
+	xas_for_each(&xas, folio, max) {
+		if (xas_retry(&xas, folio))
 			continue;
-		if (xa_is_value(page))
+		if (xa_is_value(folio))
 			continue;
-		if (PageDirty(page) || PageLocked(page) || PageWriteback(page))
+		if (folio_test_dirty(folio) || folio_test_locked(folio) ||
+				folio_test_writeback(folio))
 			break;
 	}
 	rcu_read_unlock();
-	return page != NULL;
+	return folio != NULL;
 }
 EXPORT_SYMBOL_GPL(filemap_range_has_writeback);
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

filemap-add-filemap_get_folios_contig.patch
btrfs-convert-__process_pages_contig-to-use-filemap_get_folios_contig.patch
btrfs-convert-end_compressed_writeback-to-use-filemap_get_folios.patch
btrfs-convert-process_page_range-to-use-filemap_get_folios_contig.patch
nilfs2-convert-nilfs_find_uncommited_extent-to-use-filemap_get_folios_contig.patch
ramfs-convert-ramfs_nommu_get_unmapped_area-to-use-filemap_get_folios_contig.patch
filemap-remove-find_get_pages_contig.patch
filemap-convert-filemap_range_has_writeback-to-use-folios.patch

