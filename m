Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A30C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81A6921655
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881339;
	bh=v3EdWeI6VNZ05nB5nBIE4qnifDK2xa1j5Fu/0i0S8pE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zlwz88Q079803EPIRnetXaD12Vfe9l/YGCJOTqGC3XvJeRo8HWotkcNkAWer9mKlv
	 ollESShhbKElEws0PAeatAjmIVk/Qz2/WjNcbKK4PV4x2oT48ShpbrQA73O4LkNlOU
	 8eeRziGi9pov4gy27NrJPYucDxiOdTrhqNtBBGro=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392711AbgJPUs7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:48:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUs7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:48:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA0FB20878;
        Fri, 16 Oct 2020 20:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881338;
        bh=v3EdWeI6VNZ05nB5nBIE4qnifDK2xa1j5Fu/0i0S8pE=;
        h=Date:From:To:Subject:From;
        b=JhiYvM6imcySeoYpJRYUForvxu/ZWTD7PQ5Ws6UsTrISBvdYSi1TaFEv0cfXq1J6N
         +Ugq70m8H2zNR0M5S2xkYSjMvVhNU/9WepulhNabImwQRLpjK04y7/UqxYxY7L2ztt
         4waFQY8SGY0YGy37ccWbwRwIrP53mJbofzMwt+gg=
Date:   Fri, 16 Oct 2020 13:48:57 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, ebiggers@google.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch removed
 from -mm tree
Message-ID: <20201016204857.7aF1lzjeS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/readahead: make do_page_cache_ra take a readahead_control
has been removed from the -mm tree.  Its filename was
     mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
 struct page *find_get_entry(struct address_space *mapping, pgoff_t index);
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

mm-update-the-documentation-for-vfree.patch

