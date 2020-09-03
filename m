Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8079AC433E2
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C8862098B
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599161100;
	bh=GU7pAkvywDCOyMyYbq7RB5iamub1hTPYn/jvpR0djtw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tBtFMJ0qa24qYR9nOogWbzt8XOAM9NdekPft3to5cTtqqphF387wOL+VO6Gdxuhfx
	 S/O77R+wwbENc5ZDwiv3fykBQvdtQmb7jpMukCVIhBd+1464n8miuhCRikczYQ+foF
	 5DnILQacz15oxydbok2SzuDpZBzCFevF2Qide3E8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgICTZA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729115AbgICTY7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:24:59 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B10E620C09;
        Thu,  3 Sep 2020 19:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599161098;
        bh=GU7pAkvywDCOyMyYbq7RB5iamub1hTPYn/jvpR0djtw=;
        h=Date:From:To:Subject:From;
        b=FuCjGtdQlSzA16457V2VGP5QBGgo9+UYLlBHyWcFv6edVwgJMIasjodxrRt0b8t85
         URrqhOn5562LNI5wYA/LyiVaEQdN2GdPf8rxDDlzWddNiQakiVh4XhXl76TjhjNZO3
         I+EzodXKIxdI6SlJhe2C23d1bPCH/y/ine8XTUY8=
Date:   Thu, 03 Sep 2020 12:24:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ebiggers@google.com,
        dhowells@redhat.com, willy@infradead.org
Subject:  +
 mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch added to
 -mm tree
Message-ID: <20200903192458.418IX%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/readahead: add page_cache_sync_ra and page_cache_async_ra
has been added to the -mm tree.  Its filename is
     mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch

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
Subject: mm/readahead: add page_cache_sync_ra and page_cache_async_ra

Reimplement page_cache_sync_readahead() and page_cache_async_readahead()
as wrappers around versions of the function which take a readahead_control
in preparation for making do_sync_mmap_readahead() pass down an RAC
struct.

Link: https://lkml.kernel.org/r/20200903140844.14194-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   64 ++++++++++++++++++++++++++++++++------
 mm/readahead.c          |   58 +++++++---------------------------
 2 files changed, 66 insertions(+), 56 deletions(-)

--- a/include/linux/pagemap.h~mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra
+++ a/include/linux/pagemap.h
@@ -698,16 +698,6 @@ int replace_page_cache_page(struct page
 void delete_from_page_cache_batch(struct address_space *mapping,
 				  struct pagevec *pvec);
 
-#define VM_READAHEAD_PAGES	(SZ_128K / PAGE_SIZE)
-
-void page_cache_sync_readahead(struct address_space *, struct file_ra_state *,
-		struct file *, pgoff_t index, unsigned long req_count);
-void page_cache_async_readahead(struct address_space *, struct file_ra_state *,
-		struct file *, struct page *, pgoff_t index,
-		unsigned long req_count);
-void page_cache_ra_unbounded(struct readahead_control *,
-		unsigned long nr_to_read, unsigned long lookahead_count);
-
 /*
  * Like add_to_page_cache_locked, but used to add newly allocated pages:
  * the page is new, so we can just run __SetPageLocked() against it.
@@ -755,6 +745,60 @@ struct readahead_control {
 		._index = i,						\
 	}
 
+#define VM_READAHEAD_PAGES	(SZ_128K / PAGE_SIZE)
+
+void page_cache_ra_unbounded(struct readahead_control *,
+		unsigned long nr_to_read, unsigned long lookahead_count);
+void page_cache_sync_ra(struct readahead_control *, struct file_ra_state *,
+		unsigned long req_count);
+void page_cache_async_ra(struct readahead_control *, struct file_ra_state *,
+		struct page *, unsigned long req_count);
+
+/**
+ * page_cache_sync_readahead - generic file readahead
+ * @mapping: address_space which holds the pagecache and I/O vectors
+ * @ra: file_ra_state which holds the readahead state
+ * @file: Used by the filesystem for authentication.
+ * @index: Index of first page to be read.
+ * @req_count: Total number of pages being read by the caller.
+ *
+ * page_cache_sync_readahead() should be called when a cache miss happened:
+ * it will submit the read.  The readahead logic may decide to piggyback more
+ * pages onto the read request if access patterns suggest it will improve
+ * performance.
+ */
+static inline
+void page_cache_sync_readahead(struct address_space *mapping,
+		struct file_ra_state *ra, struct file *file, pgoff_t index,
+		unsigned long req_count)
+{
+	DEFINE_READAHEAD(ractl, file, mapping, index);
+	page_cache_sync_ra(&ractl, ra, req_count);
+}
+
+/**
+ * page_cache_async_readahead - file readahead for marked pages
+ * @mapping: address_space which holds the pagecache and I/O vectors
+ * @ra: file_ra_state which holds the readahead state
+ * @file: Used by the filesystem for authentication.
+ * @page: The page at @index which triggered the readahead call.
+ * @index: Index of first page to be read.
+ * @req_count: Total number of pages being read by the caller.
+ *
+ * page_cache_async_readahead() should be called when a page is used which
+ * is marked as PageReadahead; this is a marker to suggest that the application
+ * has used up enough of the readahead window that we should start pulling in
+ * more pages.
+ */
+static inline
+void page_cache_async_readahead(struct address_space *mapping,
+		struct file_ra_state *ra, struct file *file,
+		struct page *page, pgoff_t index, unsigned long req_count)
+{
+	DEFINE_READAHEAD(ractl, file, mapping, index);
+	page_cache_async_ra(&ractl, ra, page, req_count);
+}
+
 /**
  * readahead_page - Get the next page to read.
  * @rac: The current readahead request.
--- a/mm/readahead.c~mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra
+++ a/mm/readahead.c
@@ -550,25 +550,9 @@ readit:
 	do_page_cache_ra(ractl, ra->size, ra->async_size);
 }
 
-/**
- * page_cache_sync_readahead - generic file readahead
- * @mapping: address_space which holds the pagecache and I/O vectors
- * @ra: file_ra_state which holds the readahead state
- * @filp: passed on to ->readpage() and ->readpages()
- * @index: Index of first page to be read.
- * @req_count: Total number of pages being read by the caller.
- *
- * page_cache_sync_readahead() should be called when a cache miss happened:
- * it will submit the read.  The readahead logic may decide to piggyback more
- * pages onto the read request if access patterns suggest it will improve
- * performance.
- */
-void page_cache_sync_readahead(struct address_space *mapping,
-			       struct file_ra_state *ra, struct file *filp,
-			       pgoff_t index, unsigned long req_count)
+void page_cache_sync_ra(struct readahead_control *ractl,
+		struct file_ra_state *ra, unsigned long req_count)
 {
-	DEFINE_READAHEAD(ractl, filp, mapping, index);
-
 	/* no read-ahead */
 	if (!ra->ra_pages)
 		return;
@@ -577,38 +561,20 @@ void page_cache_sync_readahead(struct ad
 		return;
 
 	/* be dumb */
-	if (filp && (filp->f_mode & FMODE_RANDOM)) {
-		force_page_cache_ra(&ractl, req_count);
+	if (ractl->file && (ractl->file->f_mode & FMODE_RANDOM)) {
+		force_page_cache_ra(ractl, req_count);
 		return;
 	}
 
 	/* do read-ahead */
-	ondemand_readahead(&ractl, ra, false, req_count);
+	ondemand_readahead(ractl, ra, false, req_count);
 }
-EXPORT_SYMBOL_GPL(page_cache_sync_readahead);
+EXPORT_SYMBOL_GPL(page_cache_sync_ra);
 
-/**
- * page_cache_async_readahead - file readahead for marked pages
- * @mapping: address_space which holds the pagecache and I/O vectors
- * @ra: file_ra_state which holds the readahead state
- * @filp: passed on to ->readpage() and ->readpages()
- * @page: The page at @index which triggered the readahead call.
- * @index: Index of first page to be read.
- * @req_count: Total number of pages being read by the caller.
- *
- * page_cache_async_readahead() should be called when a page is used which
- * is marked as PageReadahead; this is a marker to suggest that the application
- * has used up enough of the readahead window that we should start pulling in
- * more pages.
- */
-void
-page_cache_async_readahead(struct address_space *mapping,
-			   struct file_ra_state *ra, struct file *filp,
-			   struct page *page, pgoff_t index,
-			   unsigned long req_count)
+void page_cache_async_ra(struct readahead_control *ractl,
+		struct file_ra_state *ra, struct page *page,
+		unsigned long req_count)
 {
-	DEFINE_READAHEAD(ractl, filp, mapping, index);
-
 	/* no read-ahead */
 	if (!ra->ra_pages)
 		return;
@@ -624,16 +590,16 @@ page_cache_async_readahead(struct addres
 	/*
 	 * Defer asynchronous read-ahead on IO congestion.
 	 */
-	if (inode_read_congested(mapping->host))
+	if (inode_read_congested(ractl->mapping->host))
 		return;
 
 	if (blk_cgroup_congested())
 		return;
 
 	/* do read-ahead */
-	ondemand_readahead(&ractl, ra, true, req_count);
+	ondemand_readahead(ractl, ra, true, req_count);
 }
-EXPORT_SYMBOL_GPL(page_cache_async_readahead);
+EXPORT_SYMBOL_GPL(page_cache_async_ra);
 
 ssize_t ksys_readahead(int fd, loff_t offset, size_t count)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
harden-autofs-ioctl-table.patch

