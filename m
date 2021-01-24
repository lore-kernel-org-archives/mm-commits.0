Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E688BC43381
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1E36227BF
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbhAXBuT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:50:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbhAXBuR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:50:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52AEA227BF;
        Sun, 24 Jan 2021 01:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611452966;
        bh=d+2YW7ZMXSdHz+om3XKIaf7Nxcz8LymberDO5pf5eYA=;
        h=Date:From:To:Subject:From;
        b=mMIYt4VpMeL4McufvrYZimpMEqukZKJ/zMOwT/RkKb1KO6WhQMH85mM8WrIWp3zBE
         X59U+x7mwYjQz7KNz6/8ex9Kby3azJ0QNuoO2f19jqalnYqw47BPI/jLiB0SloLwmi
         FtMGkV6oenCwOhVI9GkPl0ymgJRk3n2nQrWCysj4=
Date:   Sat, 23 Jan 2021 17:49:24 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  +
 mm-filemap-convert-filemap_update_page-to-return-an-errno.patch added to
 -mm tree
Message-ID: <20210124014924.16p5xR8UR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: convert filemap_update_page to return an errno
has been added to the -mm tree.  Its filename is
     mm-filemap-convert-filemap_update_page-to-return-an-errno.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-convert-filemap_update_page-to-return-an-errno.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-convert-filemap_update_page-to-return-an-errno.patch

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
Subject: mm/filemap: convert filemap_update_page to return an errno

Use AOP_TRUNCATED_PAGE to indicate that no error occurred, but the page we
looked up is no longer valid.  In this case, the reference to the page
will have been removed; if we hit any other error, the caller will release
the reference.

Link: https://lkml.kernel.org/r/20210122160140.223228-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

--- a/mm/filemap.c~mm-filemap-convert-filemap_update_page-to-return-an-errno
+++ a/mm/filemap.c
@@ -2227,24 +2227,21 @@ static int filemap_read_page(struct file
 	return error;
 }
 
-static struct page *filemap_update_page(struct kiocb *iocb, struct file *filp,
-		struct iov_iter *iter, struct page *page, loff_t pos,
-		loff_t count)
+static int filemap_update_page(struct kiocb *iocb,
+		struct address_space *mapping, struct iov_iter *iter,
+		struct page *page, loff_t pos, loff_t count)
 {
-	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
 	int error;
 
 	if (iocb->ki_flags & IOCB_WAITQ) {
 		error = lock_page_async(page, iocb->ki_waitq);
-		if (error) {
-			put_page(page);
-			return ERR_PTR(error);
-		}
+		if (error)
+			return error;
 	} else {
 		if (!trylock_page(page)) {
 			put_and_wait_on_page_locked(page, TASK_KILLABLE);
-			return NULL;
+			return AOP_TRUNCATED_PAGE;
 		}
 	}
 
@@ -2263,25 +2260,21 @@ static struct page *filemap_update_page(
 		goto readpage;
 uptodate:
 	unlock_page(page);
-	return page;
+	return 0;
 
 readpage:
 	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ)) {
 		unlock_page(page);
-		put_page(page);
-		return ERR_PTR(-EAGAIN);
+		return -EAGAIN;
 	}
 	error = filemap_read_page(iocb->ki_filp, mapping, page);
-	if (!error)
-		return page;
-	put_page(page);
 	if (error == AOP_TRUNCATED_PAGE)
-		return NULL;
-	return ERR_PTR(error);
+		put_page(page);
+	return error;
 truncated:
 	unlock_page(page);
 	put_page(page);
-	return NULL;
+	return AOP_TRUNCATED_PAGE;
 }
 
 static int filemap_create_page(struct file *file,
@@ -2375,11 +2368,12 @@ got_pages:
 				goto err;
 			}
 
-			page = filemap_update_page(iocb, filp, iter, page,
+			err = filemap_update_page(iocb, mapping, iter, page,
 					pg_pos, pg_count);
-			if (IS_ERR_OR_NULL(page)) {
+			if (err) {
+				if (err < 0)
+					put_page(page);
 				pvec->nr--;
-				err = PTR_ERR_OR_ZERO(page);
 			}
 		}
 	}
@@ -2387,6 +2381,8 @@ got_pages:
 err:
 	if (likely(pvec->nr))
 		return 0;
+	if (err == AOP_TRUNCATED_PAGE)
+		goto find_page;
 	if (err)
 		return err;
 	/*
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

