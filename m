Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C79C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B05A722D06
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbhAXBte (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:49:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726288AbhAXBte (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:49:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A3C6229F0;
        Sun, 24 Jan 2021 01:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611452927;
        bh=8yQeMyTELSp/p4dlX0KRWmUVmO7khs/mqAd3sVF0WkE=;
        h=Date:From:To:Subject:From;
        b=h1S9L8+Y1XuQFH2dBcD0eupf4Cqxg3ifqM4dRDCPoymEg+VUHb0VVTyO1zRfoMqRZ
         Co3SJtLJHMNze4kXvWJGFuJE0VAp08fYQTTgWI+wQ0BPBZyZda1yC84cmAttSgMXAW
         kCmUHrbKngWb2fJTAOjYKSZnHEuXP9NFzYwZ2+t8=
Date:   Sat, 23 Jan 2021 17:48:46 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  +
 mm-filemap-remove-dynamically-allocated-array-from-filemap_read.patch added
 to -mm tree
Message-ID: <20210124014846.MK-t_RTJ7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: remove dynamically allocated array from filemap_read
has been added to the -mm tree.  Its filename is
     mm-filemap-remove-dynamically-allocated-array-from-filemap_read.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-remove-dynamically-allocated-array-from-filemap_read.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-remove-dynamically-allocated-array-from-filemap_read.patch

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
@@ -2425,8 +2425,8 @@ ssize_t generic_file_buffered_read(struc
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
@@ -2440,14 +2440,6 @@ ssize_t generic_file_buffered_read(struc
 
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
 
@@ -2532,9 +2524,6 @@ put_pages:
 
 	file_accessed(filp);
 
-	if (pages != pages_onstack)
-		kfree(pages);
-
 	return written ? written : error;
 }
 EXPORT_SYMBOL_GPL(generic_file_buffered_read);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-improve-memcg-debugging.patch
mm-filemap-rename-generic_file_buffered_read-subfunctions.patch
mm-filemap-remove-dynamically-allocated-array-from-filemap_read.patch
mm-filemap-convert-filemap_get_pages-to-take-a-pagevec.patch
mm-filemap-use-head-pages-in-generic_file_buffered_read.patch
mm-filemap-pass-a-sleep-state-to-put_and_wait_on_page_locked.patch
mm-filemap-support-readpage-splitting-a-page.patch
mm-filemap-inline-__wait_on_page_locked_async-into-caller.patch
mm-filemap-dont-call-readpage-if-iocb_waitq-is-set.patch
mm-filemap-change-filemap_read_page-calling-conventions.patch
mm-filemap-change-filemap_create_page-calling-conventions.patch
mm-filemap-convert-filemap_update_page-to-return-an-errno.patch
mm-filemap-move-the-iocb-checks-into-filemap_update_page.patch
mm-filemap-add-filemap_range_uptodate.patch
mm-filemap-split-filemap_readahead-out-of-filemap_get_pages.patch
mm-filemap-restructure-filemap_get_pages.patch
mm-filemap-dont-relock-the-page-after-calling-readpage.patch
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

