Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 094B1C43461
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D71BF2098B
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599161092;
	bh=Jp02t0LEeOe24bL/VZW7b6yKiy+lwjZF4uc0PneJusc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=l/iYpuJchgb47pdsuww4jppEjS9HQonq4RTgH67KeP/Z7ulXJJXxfWDtFYy1PRIzr
	 EE9hoShjMV0HgTgRQIk0XKQM12CQN67Z8omsGxrQSdmLshKzlX2dbUFnyiwOL6vE8J
	 USYN+ZyjhrXKpqTM4v1HL1n91FNXlpuYjqzw3mpc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgICTYv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:24:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729089AbgICTYu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:24:50 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A34E520BED;
        Thu,  3 Sep 2020 19:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599161089;
        bh=Jp02t0LEeOe24bL/VZW7b6yKiy+lwjZF4uc0PneJusc=;
        h=Date:From:To:Subject:From;
        b=ydDZrbiWojqVvFfkzx83gqO8G4ttCgOKgl/AyJU2jM7FyClXUcX5CsbdcLukuNkSl
         jhi+2qe4xG3yMzy/9r3SEM91swTk1wu3vW3ZqHxKKxshTdryTAiIrm0Je+wk5CVWeT
         qpvzHc4ImZT0kFP/YJGfjY05xfnvhnp3v0+f3X3k=
Date:   Thu, 03 Sep 2020 12:24:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ebiggers@google.com,
        dhowells@redhat.com, willy@infradead.org
Subject:  +
 mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
 added to -mm tree
Message-ID: <20200903192449.MAZrS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/readahead: make page_cache_ra_unbounded take a readahead_control
has been added to the -mm tree.  Its filename is
     mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch

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
@@ -705,9 +705,8 @@ void page_cache_sync_readahead(struct ad
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

