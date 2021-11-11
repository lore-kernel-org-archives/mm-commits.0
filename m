Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E95A7C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D117361884
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbhKKCo3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234041AbhKKCo3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FD5D6187A;
        Thu, 11 Nov 2021 02:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598500;
        bh=ybSu9bZibmt5K8WLO5kcvITIZ2FFOWGIc9bTw0HQRJY=;
        h=Date:From:To:Subject:From;
        b=Vl8/RetlaZwyh1Bl7tAqpU2suarHAWbywd6zHqRXYx7kC41FQHfQRhHj9mYnAcXPY
         LV74NQGMFoOuqNRlLa4gspxoQ7Xw2kfG+DROatY4Ov5UzUFYAzHGdjbDrTu4swzPR6
         YqUNwPrShuAaOXzUuX+OY9s4JWgb2zl0kMotZT4c=
Date:   Wed, 10 Nov 2021 18:41:40 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-move-more-expensive-part-of-xa-setup-out-of-mapping-check.patch removed
 from -mm tree
Message-ID: <20211111024140.nPZLaKmc6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move more expensive part of XA setup out of mapping check
has been removed from the -mm tree.  Its filename was
     mm-move-more-expensive-part-of-xa-setup-out-of-mapping-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: mm: move more expensive part of XA setup out of mapping check

The fast path here is not needing any writeback, yet we spend time setting
up the xarray lookup data upfront.  Move the part that actually needs to
iterate the address space mapping into a separate helper, saving ~30% of
the time here.

Link: https://lkml.kernel.org/r/49f67983-b802-8929-edab-d807f745c9ca@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

--- a/mm/filemap.c~mm-move-more-expensive-part-of-xa-setup-out-of-mapping-check
+++ a/mm/filemap.c
@@ -639,6 +639,30 @@ static bool mapping_needs_writeback(stru
 	return mapping->nrpages;
 }
 
+static bool filemap_range_has_writeback(struct address_space *mapping,
+					loff_t start_byte, loff_t end_byte)
+{
+	XA_STATE(xas, &mapping->i_pages, start_byte >> PAGE_SHIFT);
+	pgoff_t max = end_byte >> PAGE_SHIFT;
+	struct page *page;
+
+	if (end_byte < start_byte)
+		return false;
+
+	rcu_read_lock();
+	xas_for_each(&xas, page, max) {
+		if (xas_retry(&xas, page))
+			continue;
+		if (xa_is_value(page))
+			continue;
+		if (PageDirty(page) || PageLocked(page) || PageWriteback(page))
+			break;
+	}
+	rcu_read_unlock();
+	return page != NULL;
+
+}
+
 /**
  * filemap_range_needs_writeback - check if range potentially needs writeback
  * @mapping:           address space within which to check
@@ -656,29 +680,12 @@ static bool mapping_needs_writeback(stru
 bool filemap_range_needs_writeback(struct address_space *mapping,
 				   loff_t start_byte, loff_t end_byte)
 {
-	XA_STATE(xas, &mapping->i_pages, start_byte >> PAGE_SHIFT);
-	pgoff_t max = end_byte >> PAGE_SHIFT;
-	struct page *page;
-
 	if (!mapping_needs_writeback(mapping))
 		return false;
 	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
 	    !mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
 		return false;
-	if (end_byte < start_byte)
-		return false;
-
-	rcu_read_lock();
-	xas_for_each(&xas, page, max) {
-		if (xas_retry(&xas, page))
-			continue;
-		if (xa_is_value(page))
-			continue;
-		if (PageDirty(page) || PageLocked(page) || PageWriteback(page))
-			break;
-	}
-	rcu_read_unlock();
-	return page != NULL;
+	return filemap_range_has_writeback(mapping, start_byte, end_byte);
 }
 EXPORT_SYMBOL_GPL(filemap_range_needs_writeback);
 
_

Patches currently in -mm which might be from axboe@kernel.dk are


