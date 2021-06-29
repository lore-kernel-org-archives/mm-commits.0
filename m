Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB29C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA59161D0A
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhF2Ciw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231398AbhF2Ciw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D16961A2B;
        Tue, 29 Jun 2021 02:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934184;
        bh=BVGSBXG+iIv71EvhAwQT77Vw6G7WU+AsbnzpJ5VHF5Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AdjbQMBI9u39lMUaFjOfyIJ7zeroFeRNA2xtMo+iXjGMY0S2T6GAI+qQ1Hmbw4476
         9mY0gwBN2tfxYbym854n8tsam1B6OgDWAFtL0lefxtIc3TupkR6tUl5OiIdkvqU+KP
         xDZwEOOkT3GpqwUSxf7sPjDDoaXf5vA9dUoSTQMY=
Date:   Mon, 28 Jun 2021 19:36:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        gregkh@linuxfoundation.org, hch@lst.de, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 060/192] fs: remove anon_set_page_dirty()
Message-ID: <20210629023624.v3hqK-B4d%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: remove anon_set_page_dirty()

Use __set_page_dirty_no_writeback() instead.  This will set the dirty bit
on the page, which will be used to avoid calling set_page_dirty() in the
future.  It will have no effect on actually writing the page back, as the
pages are not on any LRU lists.

Link: https://lkml.kernel.org/r/20210615162342.1669332-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/fs/libfs.c~fs-remove-anon_set_page_dirty
+++ a/fs/libfs.c
@@ -1217,19 +1217,10 @@ void kfree_link(void *p)
 }
 EXPORT_SYMBOL(kfree_link);
 
-/*
- * nop .set_page_dirty method so that people can use .page_mkwrite on
- * anon inodes.
- */
-static int anon_set_page_dirty(struct page *page)
-{
-	return 0;
-};
-
 struct inode *alloc_anon_inode(struct super_block *s)
 {
 	static const struct address_space_operations anon_aops = {
-		.set_page_dirty = anon_set_page_dirty,
+		.set_page_dirty = __set_page_dirty_no_writeback,
 	};
 	struct inode *inode = new_inode_pseudo(s);
 
_
