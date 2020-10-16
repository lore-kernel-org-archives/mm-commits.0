Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC74BC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 775B5208E4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816180;
	bh=FK/702/Zw/GISOhgq99jXTc9WNmoZRrk7IOPVmcv2K4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=IB08pxJYx2+URc4cmFiaJ6Wqz4blKyC0SWo/6goNm2+QBNEct9Wu2zEfHKyC6d0vg
	 mVH22yk3mIT1n+HhztVfwjQ5wL0f5cF/u6TYyW7/yf3pmlBqeR4sVb2q5fAE8769sO
	 T6Q+k2cguMbOJm9441jBEsNpv99lxURcIKd37CGc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393816AbgJPCnA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730617AbgJPCm7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:42:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E6CB2087D;
        Fri, 16 Oct 2020 02:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816179;
        bh=FK/702/Zw/GISOhgq99jXTc9WNmoZRrk7IOPVmcv2K4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2CAVdVMIWCXJOEX+MMLfubfhgqA0y+eXKNFjyeHbdmXMqulnJ4g75po8QhurkPT6+
         x10RrM4hI8Xl3XPX+zAhZgXG7InUoNqgBb3tGb/YNRnlaivDbzW5NbT61Ug8jIsjmu
         vww5KmOih3+4nk7fVXudFecmlo/diAU/s0nS9weM=
Date:   Thu, 15 Oct 2020 19:42:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com,
        ebiggers@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 034/156] mm/readahead: make
 page_cache_ra_unbounded take a readahead_control
Message-ID: <20201016024258.KBoYFW8ow%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/readahead: make page_cache_ra_unbounded take a readahead_control

Define it in the callers instead of in page_cache_ra_unbounded().

Link: https://lkml.kernel.org/r/20200903140844.14194-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/verity.c        |    4 ++--
 fs/f2fs/verity.c        |    4 ++--
 include/linux/pagemap.h |    5 ++---
 mm/readahead.c          |   30 ++++++++++++++----------------
 4 files changed, 20 insertions(+), 23 deletions(-)

--- a/fs/ext4/verity.c~mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control
+++ a/fs/ext4/verity.c
@@ -349,6 +349,7 @@ static struct page *ext4_read_merkle_tre
 					       pgoff_t index,
 					       unsigned long num_ra_pages)
 {
+	DEFINE_READAHEAD(ractl, NULL, inode->i_mapping, index);
 	struct page *page;
 
 	index += ext4_verity_metadata_pos(inode) >> PAGE_SHIFT;
@@ -358,8 +359,7 @@ static struct page *ext4_read_merkle_tre
 		if (page)
 			put_page(page);
 		else if (num_ra_pages > 1)
-			page_cache_readahead_unbounded(inode->i_mapping, NULL,
-					index, num_ra_pages, 0);
+			page_cache_ra_unbounded(&ractl, num_ra_pages, 0);
 		page = read_mapping_page(inode->i_mapping, index, NULL);
 	}
 	return page;
--- a/fs/f2fs/verity.c~mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control
+++ a/fs/f2fs/verity.c
@@ -228,6 +228,7 @@ static struct page *f2fs_read_merkle_tre
 					       pgoff_t index,
 					       unsigned long num_ra_pages)
 {
+	DEFINE_READAHEAD(ractl, NULL, inode->i_mapping, index);
 	struct page *page;
 
 	index += f2fs_verity_metadata_pos(inode) >> PAGE_SHIFT;
@@ -237,8 +238,7 @@ static struct page *f2fs_read_merkle_tre
 		if (page)
 			put_page(page);
 		else if (num_ra_pages > 1)
-			page_cache_readahead_unbounded(inode->i_mapping, NULL,
-					index, num_ra_pages, 0);
+			page_cache_ra_unbounded(&ractl, num_ra_pages, 0);
 		page = read_mapping_page(inode->i_mapping, index, NULL);
 	}
 	return page;
--- a/include/linux/pagemap.h~mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control
+++ a/include/linux/pagemap.h
@@ -768,9 +768,8 @@ void page_cache_sync_readahead(struct ad
 void page_cache_async_readahead(struct address_space *, struct file_ra_state *,
 		struct file *, struct page *, pgoff_t index,
 		unsigned long req_count);
-void page_cache_readahead_unbounded(struct address_space *, struct file *,
-		pgoff_t index, unsigned long nr_to_read,
-		unsigned long lookahead_count);
+void page_cache_ra_unbounded(struct readahead_control *,
+		unsigned long nr_to_read, unsigned long lookahead_count);
 
 /*
  * Like add_to_page_cache_locked, but used to add newly allocated pages:
--- a/mm/readahead.c~mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control
+++ a/mm/readahead.c
@@ -158,10 +158,8 @@ out:
 }
 
 /**
- * page_cache_readahead_unbounded - Start unchecked readahead.
- * @mapping: File address space.
- * @file: This instance of the open file; used for authentication.
- * @index: First page index to read.
+ * page_cache_ra_unbounded - Start unchecked readahead.
+ * @ractl: Readahead control.
  * @nr_to_read: The number of pages to read.
  * @lookahead_size: Where to start the next readahead.
  *
@@ -173,13 +171,13 @@ out:
  * Context: File is referenced by caller.  Mutexes may be held by caller.
  * May sleep, but will not reenter filesystem to reclaim memory.
  */
-void page_cache_readahead_unbounded(struct address_space *mapping,
-		struct file *file, pgoff_t index, unsigned long nr_to_read,
-		unsigned long lookahead_size)
+void page_cache_ra_unbounded(struct readahead_control *ractl,
+		unsigned long nr_to_read, unsigned long lookahead_size)
 {
+	struct address_space *mapping = ractl->mapping;
+	unsigned long index = readahead_index(ractl);
 	LIST_HEAD(page_pool);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
-	DEFINE_READAHEAD(rac, file, mapping, index);
 	unsigned long i;
 
 	/*
@@ -200,7 +198,7 @@ void page_cache_readahead_unbounded(stru
 	for (i = 0; i < nr_to_read; i++) {
 		struct page *page = xa_load(&mapping->i_pages, index + i);
 
-		BUG_ON(index + i != rac._index + rac._nr_pages);
+		BUG_ON(index + i != ractl->_index + ractl->_nr_pages);
 
 		if (page && !xa_is_value(page)) {
 			/*
@@ -211,7 +209,7 @@ void page_cache_readahead_unbounded(stru
 			 * have a stable reference to this page, and it's
 			 * not worth getting one just for that.
 			 */
-			read_pages(&rac, &page_pool, true);
+			read_pages(ractl, &page_pool, true);
 			continue;
 		}
 
@@ -224,12 +222,12 @@ void page_cache_readahead_unbounded(stru
 		} else if (add_to_page_cache_lru(page, mapping, index + i,
 					gfp_mask) < 0) {
 			put_page(page);
-			read_pages(&rac, &page_pool, true);
+			read_pages(ractl, &page_pool, true);
 			continue;
 		}
 		if (i == nr_to_read - lookahead_size)
 			SetPageReadahead(page);
-		rac._nr_pages++;
+		ractl->_nr_pages++;
 	}
 
 	/*
@@ -237,10 +235,10 @@ void page_cache_readahead_unbounded(stru
 	 * uptodate then the caller will launch readpage again, and
 	 * will then handle the error.
 	 */
-	read_pages(&rac, &page_pool, false);
+	read_pages(ractl, &page_pool, false);
 	memalloc_nofs_restore(nofs);
 }
-EXPORT_SYMBOL_GPL(page_cache_readahead_unbounded);
+EXPORT_SYMBOL_GPL(page_cache_ra_unbounded);
 
 /*
  * __do_page_cache_readahead() actually reads a chunk of disk.  It allocates
@@ -252,6 +250,7 @@ void __do_page_cache_readahead(struct ad
 		struct file *file, pgoff_t index, unsigned long nr_to_read,
 		unsigned long lookahead_size)
 {
+	DEFINE_READAHEAD(ractl, file, mapping, index);
 	struct inode *inode = mapping->host;
 	loff_t isize = i_size_read(inode);
 	pgoff_t end_index;	/* The last page we want to read */
@@ -266,8 +265,7 @@ void __do_page_cache_readahead(struct ad
 	if (nr_to_read > end_index - index)
 		nr_to_read = end_index - index + 1;
 
-	page_cache_readahead_unbounded(mapping, file, index, nr_to_read,
-			lookahead_size);
+	page_cache_ra_unbounded(&ractl, nr_to_read, lookahead_size);
 }
 
 /*
_
