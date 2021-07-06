Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6619AC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4924861C96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhGFTNH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:13:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231784AbhGFTNH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:13:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B60561C87;
        Tue,  6 Jul 2021 19:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598627;
        bh=sgjfr1XA/KJDlhGTV5g25A2j2gA1cvoOk2BpoxJFhlo=;
        h=Date:From:To:Subject:From;
        b=xem5KdJf5BY/CCRkXENW1s6r6qcuChH6HmswILNP3pGu8c61LlAvoaHWayqKsNE/j
         l/jUSWIhhQwP0M3zsitZV9YBWqsswwze4L6bZgfnOvHb2CeRdtZM9zPiEq2xxBmbaj
         ebgBTTBqIh+sLfy3/q3joqlVIxv9FLyTfn27ky9Y=
Date:   Tue, 06 Jul 2021 12:10:27 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, gregkh@linuxfoundation.org, hch@lst.de,
        jack@suse.cz, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [merged] fs-remove-anon_set_page_dirty.patch removed from
 -mm tree
Message-ID: <20210706191027.nd_KT3dyX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: remove anon_set_page_dirty()
has been removed from the -mm tree.  Its filename was
     fs-remove-anon_set_page_dirty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are

mm-mark-idle-page-tracking-as-broken.patch

