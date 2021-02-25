Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DAA1C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E6D064F42
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhBYTWb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:22:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234747AbhBYTUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CD6A64F44;
        Thu, 25 Feb 2021 19:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280388;
        bh=i1zkPwpl9Wye2uoDhnlFkHV1t/q9kezf9Z3lA7+ndxA=;
        h=Date:From:To:Subject:From;
        b=1ATJ/Gjl46HPSI4dUexMvuE8c0RHNhID2hprdjdTYtxfG+/rpv57fVUAdRluzj0vT
         A1wxBbAXsM1f3M72dPDLG7wYko2u3yJxZQuepCCs1WnJZV1gT6T7i4tHBCfj+M82xH
         Mjmt1Fjev1FuMgrd0S1L0afvWWTQPKorYCbyxf24=
Date:   Thu, 25 Feb 2021 11:13:08 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-filemap-move-the-iocb-checks-into-filemap_update_page.patch removed from
 -mm tree
Message-ID: <20210225191308.bToEiepyr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: move the iocb checks into filemap_update_page
has been removed from the -mm tree.  Its filename was
     mm-filemap-move-the-iocb-checks-into-filemap_update_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: move the iocb checks into filemap_update_page

We don't need to give up when a non-blocking request sees a !Uptodate
page.  We may be able to satisfy the read from a partially-uptodate page.

Link: https://lkml.kernel.org/r/20210122160140.223228-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/mm/filemap.c~mm-filemap-move-the-iocb-checks-into-filemap_update_page
+++ a/mm/filemap.c
@@ -2240,15 +2240,16 @@ static int filemap_update_page(struct ki
 	struct inode *inode = mapping->host;
 	int error;
 
-	if (iocb->ki_flags & IOCB_WAITQ) {
-		error = lock_page_async(page, iocb->ki_waitq);
-		if (error)
-			return error;
-	} else {
-		if (!trylock_page(page)) {
+	if (!trylock_page(page)) {
+		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_NOIO))
+			return -EAGAIN;
+		if (!(iocb->ki_flags & IOCB_WAITQ)) {
 			put_and_wait_on_page_locked(page, TASK_KILLABLE);
 			return AOP_TRUNCATED_PAGE;
 		}
+		error = __lock_page_async(page, iocb->ki_waitq);
+		if (error)
+			return error;
 	}
 
 	if (!page->mapping)
@@ -2366,14 +2367,9 @@ got_pages:
 		}
 
 		if (!PageUptodate(page)) {
-			if ((iocb->ki_flags & IOCB_NOWAIT) ||
-			    ((iocb->ki_flags & IOCB_WAITQ) && pvec->nr > 1)) {
-				put_page(page);
-				pvec->nr--;
-				err = -EAGAIN;
-				goto err;
-			}
-
+			if ((iocb->ki_flags & IOCB_WAITQ) &&
+			    pagevec_count(pvec) > 1)
+				iocb->ki_flags |= IOCB_NOWAIT;
 			err = filemap_update_page(iocb, mapping, iter, page,
 					pg_pos, pg_count);
 			if (err) {
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

