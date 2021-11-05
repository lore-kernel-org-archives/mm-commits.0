Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D47C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99F1760720
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhKEUjy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:39:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhKEUjy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:39:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDA4760720;
        Fri,  5 Nov 2021 20:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144634;
        bh=2UkTKQih8idxLVqf2ibokSlG04tvQHz4ZCkdKXtbOhk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XF4YEKexWqtTz+ggQcKLSCB9Q/4DKw0/CfhX3IoK0rWvFLq9qqGbkdRLLXxtbYKel
         +MFizU1uLqkBLRUOjZxFrdNE3dP0IhtYdHvDWJBGO3SakB/WZJdMMb9Ntwi1UN6PdU
         5PtfuJpnrQe/yLIrXGnNIw3o4eAp30BdBX9kWPaI=
Date:   Fri, 05 Nov 2021 13:37:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 049/262] mm: move more expensive part of XA setup
 out of mapping check
Message-ID: <20211105203713.0Ahhj4i8_%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
