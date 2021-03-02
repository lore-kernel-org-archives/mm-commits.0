Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8525C433E6
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 598BE64E38
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240499AbhCCN0K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:26:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233704AbhCBXzA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 18:55:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AE8664F1A;
        Tue,  2 Mar 2021 23:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614728628;
        bh=964BaP0KbsN3CcsKmeJLKSWZqea21BpoVuwxnZpyaOE=;
        h=Date:From:To:Subject:From;
        b=cT3kK63AejjCwuBvKIrdHuoID0WFvWoPBLIYi84yTF/jHeaDnMC5RvdTdGGS8fWbW
         48oDoGHiyhjURM+5K7QvpOri1iTETVDUPz/Vrp2RTYz8pZu7q6ft5nPKtpeMtqoivD
         n5eOhFpb3nLfG3YR7krdiYn8naciEG/JGtAXjQXc=
Date:   Tue, 02 Mar 2021 15:43:47 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, jack@suse.cz, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  + mm-provide-filemap_range_needs_writeback-helper.patch
 added to -mm tree
Message-ID: <20210302234347.N9evDxn__%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: provide filemap_range_needs_writeback() helper
has been added to the -mm tree.  Its filename is
     mm-provide-filemap_range_needs_writeback-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-provide-filemap_range_needs_writeback-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-provide-filemap_range_needs_writeback-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: mm: provide filemap_range_needs_writeback() helper

For O_DIRECT reads/writes, we check if we need to issue a call to
filemap_write_and_wait_range() to issue and/or wait for writeback for any
page in the given range.  The existing mechanism just checks for a page in
the range, which is suboptimal for IOCB_NOWAIT as we'll fallback to the
slow path (and needing retry) if there's just a clean page cache page in
the range.

Provide filemap_range_needs_writeback() which tries a little harder to
check if we actually need to issue and/or wait for writeback in the range.

Link: https://lkml.kernel.org/r/20210224164455.1096727-2-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 ++
 mm/filemap.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

--- a/include/linux/fs.h~mm-provide-filemap_range_needs_writeback-helper
+++ a/include/linux/fs.h
@@ -2739,6 +2739,8 @@ static inline int filemap_fdatawait(stru
 
 extern bool filemap_range_has_page(struct address_space *, loff_t lstart,
 				  loff_t lend);
+extern bool filemap_range_needs_writeback(struct address_space *,
+					  loff_t lstart, loff_t lend);
 extern int filemap_write_and_wait_range(struct address_space *mapping,
 				        loff_t lstart, loff_t lend);
 extern int __filemap_fdatawrite_range(struct address_space *mapping,
--- a/mm/filemap.c~mm-provide-filemap_range_needs_writeback-helper
+++ a/mm/filemap.c
@@ -636,6 +636,49 @@ static bool mapping_needs_writeback(stru
 }
 
 /**
+ * filemap_range_needs_writeback - check if range potentially needs writeback
+ * @mapping:           address space within which to check
+ * @start_byte:        offset in bytes where the range starts
+ * @end_byte:          offset in bytes where the range ends (inclusive)
+ *
+ * Find at least one page in the range supplied, usually used to check if
+ * direct writing in this range will trigger a writeback. Used by O_DIRECT
+ * read/write with IOCB_NOWAIT, to see if the caller needs to do
+ * filemap_write_and_wait_range() before proceeding.
+ *
+ * Return: %true if the caller should do filemap_write_and_wait_range() before
+ * doing O_DIRECT to a page in this range, %false otherwise.
+ */
+bool filemap_range_needs_writeback(struct address_space *mapping,
+				   loff_t start_byte, loff_t end_byte)
+{
+	XA_STATE(xas, &mapping->i_pages, start_byte >> PAGE_SHIFT);
+	pgoff_t max = end_byte >> PAGE_SHIFT;
+	struct page *page;
+
+	if (!mapping_needs_writeback(mapping))
+		return false;
+	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
+	    !mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
+		return false;
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
+}
+EXPORT_SYMBOL_GPL(filemap_range_needs_writeback);
+
+/**
  * filemap_write_and_wait_range - write out & wait on a file range
  * @mapping:	the address_space for the pages
  * @lstart:	offset in bytes where the range starts
_

Patches currently in -mm which might be from axboe@kernel.dk are

swap-fix-swapfile-read-write-offset.patch
mm-provide-filemap_range_needs_writeback-helper.patch
mm-use-filemap_range_needs_writeback-for-o_direct-reads.patch
iomap-use-filemap_range_needs_writeback-for-o_direct-reads.patch

