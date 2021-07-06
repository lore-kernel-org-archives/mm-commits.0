Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4C0C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35C9661C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhGFTNB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231773AbhGFTNB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:13:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FD7B613C9;
        Tue,  6 Jul 2021 19:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598621;
        bh=bcfQQYp7dsFjzgGIgL6QeOZ0gam9mlaX7i71fJd6Rgo=;
        h=Date:From:To:Subject:From;
        b=RMeTy7GavapvvhBBu6Xi5OPTgjDwTBxTyKiGPlbACtpH4Vs918ERkzzuYrzPithH4
         AASfXaJG9mskYAUmrEMh3CzdhVLAXnh0WXpHHf4oi7FEmdl3zgeI+P4cCLZ+QAPQKU
         PwfLU+RxP4Uc+XnaXCICW4vGnjCfLVNcGVg3i33A=
Date:   Tue, 06 Jul 2021 12:10:21 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, gregkh@linuxfoundation.org, hch@lst.de,
        jack@suse.cz, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [merged]
 mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers.patch
 removed from -mm tree
Message-ID: <20210706191021.OXZxksFph%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/writeback: use __set_page_dirty in __set_page_dirty_nobuffers
has been removed from the -mm tree.  Its filename was
     mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/writeback: use __set_page_dirty in __set_page_dirty_nobuffers

This is fundamentally the same code, so just call it instead of
duplicating it.

Link: https://lkml.kernel.org/r/20210615162342.1669332-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/mm/page-writeback.c~mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers
+++ a/mm/page-writeback.c
@@ -2508,20 +2508,12 @@ int __set_page_dirty_nobuffers(struct pa
 	lock_page_memcg(page);
 	if (!TestSetPageDirty(page)) {
 		struct address_space *mapping = page_mapping(page);
-		unsigned long flags;
 
 		if (!mapping) {
 			unlock_page_memcg(page);
 			return 1;
 		}
-
-		xa_lock_irqsave(&mapping->i_pages, flags);
-		BUG_ON(page_mapping(page) != mapping);
-		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
-		account_page_dirtied(page, mapping);
-		__xa_set_mark(&mapping->i_pages, page_index(page),
-				   PAGECACHE_TAG_DIRTY);
-		xa_unlock_irqrestore(&mapping->i_pages, flags);
+		__set_page_dirty(page, mapping, !PagePrivate(page));
 		unlock_page_memcg(page);
 
 		if (mapping->host) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-mark-idle-page-tracking-as-broken.patch

