Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A783C6FD1D
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 19:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbjDDTcb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 15:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbjDDTc0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 15:32:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA307358B
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 12:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33A6F633E3
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 19:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABC2C433EF;
        Tue,  4 Apr 2023 19:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680636744;
        bh=1/cxtvNdECa+ycMS8QSGRAOKWHZcm+I7AVf1Z5OXWXs=;
        h=Date:To:From:Subject:From;
        b=oHJtru8n9R4ZCY4i4KCjVamLKMs122gzzhH0fiCjksMAXWIVw67VpnDcMbOQg/OMy
         QIzKc5ewBRxV+w430f7pVRm8DXXb4CjxOYi/wy/uRbcJ0RdXXttw2JZiaqhwBgHa3b
         /TQSLDiw+ctSdXE0tQaPqqsyaeMnpKv8IU5L80ZY=
Date:   Tue, 04 Apr 2023 12:32:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, senozhatsky@chromium.org,
        minchan@kernel.org, mcgrof@kernel.org, martin@omnibond.com,
        hubcap@omnibond.com, hch@lst.de, brauner@kernel.org,
        axboe@kernel.dk, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] filemap-remove-page_endio.patch removed from -mm tree
Message-Id: <20230404193224.8ABC2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: remove page_endio()
has been removed from the -mm tree.  Its filename was
     filemap-remove-page_endio.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: filemap: remove page_endio()
Date: Mon, 3 Apr 2023 15:22:21 +0200

page_endio() is not used anymore. Remove it.

Link: https://lkml.kernel.org/r/20230403132221.94921-6-p.raghav@samsung.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Martin Brandenburg <martin@omnibond.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 --
 mm/filemap.c            |   30 ------------------------------
 2 files changed, 32 deletions(-)

--- a/include/linux/pagemap.h~filemap-remove-page_endio
+++ a/include/linux/pagemap.h
@@ -1076,8 +1076,6 @@ int filemap_migrate_folio(struct address
 #else
 #define filemap_migrate_folio NULL
 #endif
-void page_endio(struct page *page, bool is_write, int err);
-
 void folio_end_private_2(struct folio *folio);
 void folio_wait_private_2(struct folio *folio);
 int folio_wait_private_2_killable(struct folio *folio);
--- a/mm/filemap.c~filemap-remove-page_endio
+++ a/mm/filemap.c
@@ -1625,36 +1625,6 @@ void folio_end_writeback(struct folio *f
 }
 EXPORT_SYMBOL(folio_end_writeback);
 
-/*
- * After completing I/O on a page, call this routine to update the page
- * flags appropriately
- */
-void page_endio(struct page *page, bool is_write, int err)
-{
-	struct folio *folio = page_folio(page);
-
-	if (!is_write) {
-		if (!err) {
-			folio_mark_uptodate(folio);
-		} else {
-			folio_clear_uptodate(folio);
-			folio_set_error(folio);
-		}
-		folio_unlock(folio);
-	} else {
-		if (err) {
-			struct address_space *mapping;
-
-			folio_set_error(folio);
-			mapping = folio_mapping(folio);
-			if (mapping)
-				mapping_set_error(mapping, err);
-		}
-		folio_end_writeback(folio);
-	}
-}
-EXPORT_SYMBOL_GPL(page_endio);
-
 /**
  * __folio_lock - Get a lock on the folio, assuming we need to sleep to get it.
  * @folio: The folio to lock
_

Patches currently in -mm which might be from p.raghav@samsung.com are


