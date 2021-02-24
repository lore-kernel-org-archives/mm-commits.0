Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0EADC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EEA264F2A
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbhBXUDV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235270AbhBXUC2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DC9264E83;
        Wed, 24 Feb 2021 20:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196913;
        bh=ZJh8e4jsUNE/0SFEbgId4dpUQgEPbalDIanXSj7b92I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Y92M9F8CLjrxrWhIFwnor0e47wk4EE3fgS8zam6yfVbnaV6yDrAWRr0Qu5ALT72MD
         TSM0cPfQf3IgZEJf06ymxQv0T9KJluDWvaUf3WiG/Wyh2mkrsbKNDtT/7rObfRwOAx
         up+IOdv/QPc2ptukQNEgol3FFJx8zTMakcS6zFvU=
Date:   Wed, 24 Feb 2021 12:01:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, kent.overstreet@gmail.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 031/173] mm/filemap: remove dynamically allocated
 array from filemap_read
Message-ID: <20210224200152.sbTamoMyG%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
