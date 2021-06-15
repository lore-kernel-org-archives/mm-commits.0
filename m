Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC74C48BDF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B87B6610CD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhFOXZW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 19:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230082AbhFOXZW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 19:25:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14BF361245;
        Tue, 15 Jun 2021 23:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623799396;
        bh=WMteMPrI8p1cyUpjDlrXZ+G1ex86EGEfCXEMsIExD8Y=;
        h=Date:From:To:Subject:From;
        b=MUMAE9T4SUPnAWtcBVUJVlDZYbUqa4a9xSjPOFgVGFrXeTm7wHXG5bypr/p5ctyJM
         xsa7ZlejLN6ooV1dXvUvWz7jro6qH0YsDEYMvGa66ls/iwQptAX2jYIoH4Bp87hycx
         jS1DnZOEYh2vVLetFWM1ytE1FVNYheXSSrmpvQmM=
Date:   Tue, 15 Jun 2021 16:23:15 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, gregkh@linuxfoundation.org, hch@lst.de,
        jack@suse.cz, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  + mm-writeback-move-__set_page_dirty-to-core-mm.patch
 added to -mm tree
Message-ID: <20210615232315.aVRx3QznK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/writeback: move __set_page_dirty() to core mm
has been added to the -mm tree.  Its filename is
     mm-writeback-move-__set_page_dirty-to-core-mm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-writeback-move-__set_page_dirty-to-core-mm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-writeback-move-__set_page_dirty-to-core-mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are

mm-mark-idle-page-tracking-as-broken.patch
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-3.patch
mm-writeback-move-__set_page_dirty-to-core-mm.patch
mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers.patch
iomap-use-__set_page_dirty_nobuffers.patch
fs-remove-anon_set_page_dirty.patch
fs-remove-noop_set_page_dirty.patch
mm-move-page-dirtying-prototypes-from-mmh.patch
mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix-2.patch
mm-thp-fix-strncpy-warning.patch

