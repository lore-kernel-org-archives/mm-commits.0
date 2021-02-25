Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77ECC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E18B64F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhBYTUK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:20:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234385AbhBYTRg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:17:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0182464F48;
        Thu, 25 Feb 2021 19:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280359;
        bh=w7NU/Bd8f4lPRjywXfXh3MlchYA/Uu2bBNzlXQ8gcgw=;
        h=Date:From:To:Subject:From;
        b=dlY4rRFOb5XrABjYeZYUiJtZP2OqmOIrVzTFFlAM8/bPPb0c71PWjP4RBjMBSnOC3
         ZGmf7sNWSeD2oUxH3AUpIWYZX5woixRmZru2gV7zcDhYocB/Ssq1MjCi/dVYpBF9q4
         SbCJqsk1BOAwILSoFnU1AyTsQBoafRwUXTV9xIi4=
Date:   Thu, 25 Feb 2021 11:12:38 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-filemap-remove-dynamically-allocated-array-from-filemap_read.patch
 removed from -mm tree
Message-ID: <20210225191238.gbsz-tI-I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: remove dynamically allocated array from filemap_read
has been removed from the -mm tree.  Its filename was
     mm-filemap-remove-dynamically-allocated-array-from-filemap_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: remove dynamically allocated array from filemap_read

Increasing the batch size runs into diminishing returns.  It's probably
better to make, eg, three calls to filemap_get_pages() than it is to call
into kmalloc().

Link: https://lkml.kernel.org/r/20210122160140.223228-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/mm/filemap.c~mm-filemap-remove-dynamically-allocated-array-from-filemap_read
+++ a/mm/filemap.c
@@ -2431,8 +2431,8 @@ ssize_t generic_file_buffered_read(struc
 	struct file_ra_state *ra = &filp->f_ra;
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
-	struct page *pages_onstack[PAGEVEC_SIZE], **pages = NULL;
-	unsigned int nr_pages = min_t(unsigned int, 512,
+	struct page *pages[PAGEVEC_SIZE];
+	unsigned int nr_pages = min_t(unsigned int, PAGEVEC_SIZE,
 			((iocb->ki_pos + iter->count + PAGE_SIZE - 1) >> PAGE_SHIFT) -
 			(iocb->ki_pos >> PAGE_SHIFT));
 	int i, pg_nr, error = 0;
@@ -2446,14 +2446,6 @@ ssize_t generic_file_buffered_read(struc
 
 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes);
 
-	if (nr_pages > ARRAY_SIZE(pages_onstack))
-		pages = kmalloc_array(nr_pages, sizeof(void *), GFP_KERNEL);
-
-	if (!pages) {
-		pages = pages_onstack;
-		nr_pages = min_t(unsigned int, nr_pages, ARRAY_SIZE(pages_onstack));
-	}
-
 	do {
 		cond_resched();
 
@@ -2538,9 +2530,6 @@ put_pages:
 
 	file_accessed(filp);
 
-	if (pages != pages_onstack)
-		kfree(pages);
-
 	return written ? written : error;
 }
 EXPORT_SYMBOL_GPL(generic_file_buffered_read);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
mm-filemap-add-mapping_seek_hole_data-fix.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch

