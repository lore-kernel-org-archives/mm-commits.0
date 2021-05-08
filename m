Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A8BC43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5FDA6141D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhEHWld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhEHWl2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 720CF6140E;
        Sat,  8 May 2021 22:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513624;
        bh=risGR5A+PxuE70jqmcuA+3UwwkkZrA+VU3Hsj0Qaw9E=;
        h=Date:From:To:Subject:From;
        b=blpb8Qj3pHXlfvFXXUOrZ59Nx1Jp0I4a3Eq0Wl5KFmFUAYZJMP4/ik1vCk+JD2Wjh
         CshJjzIGUFBKN4It7N5vOmvRhyGCjFIFbFVyT1u3hhnA9OdOUBnBGJxOGYyoBpUVtO
         ZdsGg7J3HI0udB7JytrqSEiAHv+16Mwmn+aoll7Q=
Date:   Sat, 08 May 2021 15:40:24 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, jack@suse.cz, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 mm-provide-filemap_range_needs_writeback-helper.patch removed from -mm tree
Message-ID: <20210508224024.KZxLbwkGL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: provide filemap_range_needs_writeback() helper
has been removed from the -mm tree.  Its filename was
     mm-provide-filemap_range_needs_writeback-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: mm: provide filemap_range_needs_writeback() helper

Patch series "Improve IOCB_NOWAIT O_DIRECT reads", v3.

An internal workload complained because it was using too much CPU, and
when I took a look, we had a lot of io_uring workers going to town. 
For an async buffered read like workload, I am normally expecting
_zero_ offloads to a worker thread, but this one had tons of them.  I'd
drop caches and things would look good again, but then a minute later
we'd regress back to using workers.  Turns out that every minute
something was reading parts of the device, which would add page cache
for that inode.  I put patches like these in for our kernel, and the
problem was solved.

Don't -EAGAIN IOCB_NOWAIT dio reads just because we have page cache
entries for the given range.  This causes unnecessary work from the
callers side, when the IO could have been issued totally fine without
blocking on writeback when there is none.


This patch (of 3):

For O_DIRECT reads/writes, we check if we need to issue a call to
filemap_write_and_wait_range() to issue and/or wait for writeback for any
page in the given range.  The existing mechanism just checks for a page in
the range, which is suboptimal for IOCB_NOWAIT as we'll fallback to the
slow path (and needing retry) if there's just a clean page cache page in
the range.

Provide filemap_range_needs_writeback() which tries a little harder to
check if we actually need to issue and/or wait for writeback in the range.

Link: https://lkml.kernel.org/r/20210224164455.1096727-1-axboe@kernel.dk
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
@@ -2878,6 +2878,8 @@ static inline int filemap_fdatawait(stru
 
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


