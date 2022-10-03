Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A695C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJCVIc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJCVG2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D1511A09
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59FF9B811C4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08996C433C1;
        Mon,  3 Oct 2022 21:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831146;
        bh=AdlVLtKYxxI9fuVhPhC7T+uzm2y9PO8UyhcTK1b8tEA=;
        h=Date:To:From:Subject:From;
        b=MezbtFxHNvH4N2S85/1++xJcvsngeZQe1nj8dzHdAUyituBzT8E7P9XRrhIVvaX7I
         JKpzu6K0AnJEotLh2wW21LYPkcAN3adX+8YfVPFzy0st6k7D8/NcvUASp8Ma/hv5W0
         HTbNFfXna35jmWm69UuxL0x6yaDbwJ3LFvr1WukM=
Date:   Mon, 03 Oct 2022 14:05:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-convert-filemap_range_has_writeback-to-use-folios.patch removed from -mm tree
Message-Id: <20221003210546.08996C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: convert filemap_range_has_writeback() to use folios
has been removed from the -mm tree.  Its filename was
     filemap-convert-filemap_range_has_writeback-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


