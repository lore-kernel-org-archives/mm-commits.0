Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FE1C433E9
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A2A420BED
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599161095;
	bh=FT1CS1mTTgrvIyo/ruDveu1yiXUu1ycRCoHGumRxKeg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mqS7f4/8O0Djw2Ryh/ArmbhRM0W4XcC8AmNYxzbClEdQaGepeyBLlniX9iNJqWxMK
	 QfnJ4vYzFWThd7/d2WJk+a+gkyf0XyOiRzSN4+LIwbGW5YdkMgikD9P8uq+H+zRbjY
	 W7W6cbIps4a+TjKP/jVz2WNYRpdXgwoMD1dxYDy4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgICTYz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728719AbgICTYx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:24:53 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A919820C09;
        Thu,  3 Sep 2020 19:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599161092;
        bh=FT1CS1mTTgrvIyo/ruDveu1yiXUu1ycRCoHGumRxKeg=;
        h=Date:From:To:Subject:From;
        b=XD34zTd/6W/bzryjnvObgwFHfBTkaVxh6+fT3/WqpHVHUTfEFpeMXE2NJTCkJWoFZ
         K8dxDlNEr8Z0xFWxiZs9oBQZSc7Vs1mN8f5j/ILVFZUcO0qCMv9x5n/0cIBStJwQhi
         pELz815gK3QYLPEo9G8OcHvnn0scr7VCr8jmcJ00=
Date:   Thu, 03 Sep 2020 12:24:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ebiggers@google.com,
        dhowells@redhat.com, willy@infradead.org
Subject:  +
 mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch added to
 -mm tree
Message-ID: <20200903192452.0qYpI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/readahead: make do_page_cache_ra take a readahead_control
has been added to the -mm tree.  Its filename is
     mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch

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
Subject: mm/readahead: make do_page_cache_ra take a readahead_control

Rename __do_page_cache_readahead() to do_page_cache_ra() and call it
directly from ondemand_readahead() instead of indirecting via ra_submit().

Link: https://lkml.kernel.org/r/20200903140844.14194-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |   11 +++++------
 mm/readahead.c |   28 +++++++++++++++-------------
 2 files changed, 20 insertions(+), 19 deletions(-)

--- a/mm/internal.h~mm-readahead-make-do_page_cache_ra-take-a-readahead_control
+++ a/mm/internal.h
@@ -51,18 +51,17 @@ void unmap_page_range(struct mmu_gather
 
 void force_page_cache_readahead(struct address_space *, struct file *,
 		pgoff_t index, unsigned long nr_to_read);
-void __do_page_cache_readahead(struct address_space *, struct file *,
-		pgoff_t index, unsigned long nr_to_read,
-		unsigned long lookahead_size);
+void do_page_cache_ra(struct readahead_control *,
+		unsigned long nr_to_read, unsigned long lookahead_size);
 
 /*
  * Submit IO for the read-ahead request in file_ra_state.
  */
 static inline void ra_submit(struct file_ra_state *ra,
-		struct address_space *mapping, struct file *filp)
+		struct address_space *mapping, struct file *file)
 {
-	__do_page_cache_readahead(mapping, filp,
-			ra->start, ra->size, ra->async_size);
+	DEFINE_READAHEAD(ractl, file, mapping, ra->start);
+	do_page_cache_ra(&ractl, ra->size, ra->async_size);
 }
 
 /**
--- a/mm/readahead.c~mm-readahead-make-do_page_cache_ra-take-a-readahead_control
+++ a/mm/readahead.c
@@ -241,17 +241,16 @@ void page_cache_ra_unbounded(struct read
 EXPORT_SYMBOL_GPL(page_cache_ra_unbounded);
 
 /*
- * __do_page_cache_readahead() actually reads a chunk of disk.  It allocates
+ * do_page_cache_ra() actually reads a chunk of disk.  It allocates
  * the pages first, then submits them for I/O. This avoids the very bad
  * behaviour which would occur if page allocations are causing VM writeback.
  * We really don't want to intermingle reads and writes like that.
  */
-void __do_page_cache_readahead(struct address_space *mapping,
-		struct file *file, pgoff_t index, unsigned long nr_to_read,
-		unsigned long lookahead_size)
+void do_page_cache_ra(struct readahead_control *ractl,
+		unsigned long nr_to_read, unsigned long lookahead_size)
 {
-	DEFINE_READAHEAD(ractl, file, mapping, index);
-	struct inode *inode = mapping->host;
+	struct inode *inode = ractl->mapping->host;
+	unsigned long index = readahead_index(ractl);
 	loff_t isize = i_size_read(inode);
 	pgoff_t end_index;	/* The last page we want to read */
 
@@ -265,7 +264,7 @@ void __do_page_cache_readahead(struct ad
 	if (nr_to_read > end_index - index)
 		nr_to_read = end_index - index + 1;
 
-	page_cache_ra_unbounded(&ractl, nr_to_read, lookahead_size);
+	page_cache_ra_unbounded(ractl, nr_to_read, lookahead_size);
 }
 
 /*
@@ -273,10 +272,11 @@ void __do_page_cache_readahead(struct ad
  * memory at once.
  */
 void force_page_cache_readahead(struct address_space *mapping,
-		struct file *filp, pgoff_t index, unsigned long nr_to_read)
+		struct file *file, pgoff_t index, unsigned long nr_to_read)
 {
+	DEFINE_READAHEAD(ractl, file, mapping, index);
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
-	struct file_ra_state *ra = &filp->f_ra;
+	struct file_ra_state *ra = &file->f_ra;
 	unsigned long max_pages;
 
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages &&
@@ -294,7 +294,7 @@ void force_page_cache_readahead(struct a
 
 		if (this_chunk > nr_to_read)
 			this_chunk = nr_to_read;
-		__do_page_cache_readahead(mapping, filp, index, this_chunk, 0);
+		do_page_cache_ra(&ractl, this_chunk, 0);
 
 		index += this_chunk;
 		nr_to_read -= this_chunk;
@@ -432,10 +432,11 @@ static int try_context_readahead(struct
  * A minimal readahead algorithm for trivial sequential/random reads.
  */
 static void ondemand_readahead(struct address_space *mapping,
-		struct file_ra_state *ra, struct file *filp,
+		struct file_ra_state *ra, struct file *file,
 		bool hit_readahead_marker, pgoff_t index,
 		unsigned long req_size)
 {
+	DEFINE_READAHEAD(ractl, file, mapping, index);
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
 	unsigned long max_pages = ra->ra_pages;
 	unsigned long add_pages;
@@ -516,7 +517,7 @@ static void ondemand_readahead(struct ad
 	 * standalone, small random read
 	 * Read as is, and do not pollute the readahead state.
 	 */
-	__do_page_cache_readahead(mapping, filp, index, req_size, 0);
+	do_page_cache_ra(&ractl, req_size, 0);
 	return;
 
 initial_readahead:
@@ -542,7 +543,8 @@ readit:
 		}
 	}
 
-	ra_submit(ra, mapping, filp);
+	ractl._index = ra->start;
+	do_page_cache_ra(&ractl, ra->size, ra->async_size);
 }
 
 /**
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

