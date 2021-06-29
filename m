Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9356C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8B1261D0A
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhF2Cim (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231856AbhF2Cim (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8912161D07;
        Tue, 29 Jun 2021 02:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934175;
        bh=RVCdo9ruPFLtE046xn9Rb+y1kmWvSkeSH5+3cB/bea0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qz6wQrGQSzsM9YdFwbTXjICXvq6dPutU/0/x+Vi1My3NEJhmWTn3kzTENI7Q9VgaS
         k9rh6gOPEZXRQlIBdmlmyK5EqZJIVtzkb8VU/mjBx3LR3cE/Y7AGcWSo0CCDRx6823
         cSnxgwMFoqgJoH0jvsVOBBOBYBfhituBItbOEJg4=
Date:   Mon, 28 Jun 2021 19:36:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        gregkh@linuxfoundation.org, hch@lst.de, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 057/192] mm/writeback: move __set_page_dirty() to
 core mm
Message-ID: <20210629023615.Xcku508It%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/writeback: move __set_page_dirty() to core mm

Patch series "Further set_page_dirty cleanups".

Prompted by Christoph's recent patches, here are some more patches to
improve the state of set_page_dirty().  They're all from the folio tree,
so they've been tested to a certain extent.


This patch (of 6):

Nothing in __set_page_dirty() is specific to buffer_head, so move it to
mm/page-writeback.c.  That removes the only caller of
account_page_dirtied() outside of page-writeback.c, so make it static.

Link: https://lkml.kernel.org/r/20210615162342.1669332-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20210615162342.1669332-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c         |   24 ------------------------
 include/linux/mm.h  |    1 -
 mm/page-writeback.c |   27 ++++++++++++++++++++++++++-
 3 files changed, 26 insertions(+), 26 deletions(-)

--- a/fs/buffer.c~mm-writeback-move-__set_page_dirty-to-core-mm
+++ a/fs/buffer.c
@@ -589,30 +589,6 @@ void mark_buffer_dirty_inode(struct buff
 EXPORT_SYMBOL(mark_buffer_dirty_inode);
 
 /*
- * Mark the page dirty, and set it dirty in the page cache, and mark the inode
- * dirty.
- *
- * If warn is true, then emit a warning if the page is not uptodate and has
- * not been truncated.
- *
- * The caller must hold lock_page_memcg().
- */
-void __set_page_dirty(struct page *page, struct address_space *mapping,
-			     int warn)
-{
-	unsigned long flags;
-
-	xa_lock_irqsave(&mapping->i_pages, flags);
-	if (page->mapping) {	/* Race with truncate? */
-		WARN_ON_ONCE(warn && !PageUptodate(page));
-		account_page_dirtied(page, mapping);
-		__xa_set_mark(&mapping->i_pages, page_index(page),
-				PAGECACHE_TAG_DIRTY);
-	}
-	xa_unlock_irqrestore(&mapping->i_pages, flags);
-}
-
-/*
  * Add a page to the dirty page list.
  *
  * It is a sad fact of life that this function is called from several places
--- a/include/linux/mm.h~mm-writeback-move-__set_page_dirty-to-core-mm
+++ a/include/linux/mm.h
@@ -1855,7 +1855,6 @@ int __set_page_dirty_nobuffers(struct pa
 int __set_page_dirty_no_writeback(struct page *page);
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
-void account_page_dirtied(struct page *page, struct address_space *mapping);
 void account_page_cleaned(struct page *page, struct address_space *mapping,
 			  struct bdi_writeback *wb);
 int set_page_dirty(struct page *page);
--- a/mm/page-writeback.c~mm-writeback-move-__set_page_dirty-to-core-mm
+++ a/mm/page-writeback.c
@@ -2425,7 +2425,8 @@ int __set_page_dirty_no_writeback(struct
  *
  * NOTE: This relies on being atomic wrt interrupts.
  */
-void account_page_dirtied(struct page *page, struct address_space *mapping)
+static void account_page_dirtied(struct page *page,
+		struct address_space *mapping)
 {
 	struct inode *inode = mapping->host;
 
@@ -2467,6 +2468,30 @@ void account_page_cleaned(struct page *p
 }
 
 /*
+ * Mark the page dirty, and set it dirty in the page cache, and mark the inode
+ * dirty.
+ *
+ * If warn is true, then emit a warning if the page is not uptodate and has
+ * not been truncated.
+ *
+ * The caller must hold lock_page_memcg().
+ */
+void __set_page_dirty(struct page *page, struct address_space *mapping,
+			     int warn)
+{
+	unsigned long flags;
+
+	xa_lock_irqsave(&mapping->i_pages, flags);
+	if (page->mapping) {	/* Race with truncate? */
+		WARN_ON_ONCE(warn && !PageUptodate(page));
+		account_page_dirtied(page, mapping);
+		__xa_set_mark(&mapping->i_pages, page_index(page),
+				PAGECACHE_TAG_DIRTY);
+	}
+	xa_unlock_irqrestore(&mapping->i_pages, flags);
+}
+
+/*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
  * the xarray.
  *
_
