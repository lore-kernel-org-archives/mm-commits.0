Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D86C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD2D361D04
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhF2Ciq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231809AbhF2Cip (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9373061A2B;
        Tue, 29 Jun 2021 02:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934178;
        bh=mBuwruSjr2KFaw512Byq8XNlrhPSijRNprEPJGjxkyY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Xs4P7/J1odnUghJgrKXKZ4bmO5ISVeCE0xEFTliJPQ4tENzMpqNAvdzZts/tLtVbA
         WtdRAyIG+31CCG605zJAqGSuoeRaUFWQoV1RDNOEAf1td+CcONAij2lqBVpVjjtD9F
         rbNxkJnG4wlAe0sbsxcrAGyMrv4ww+1en/0tZcOo=
Date:   Mon, 28 Jun 2021 19:36:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        gregkh@linuxfoundation.org, hch@lst.de, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 058/192] mm/writeback: use __set_page_dirty in
 __set_page_dirty_nobuffers
Message-ID: <20210629023618.4PMEonG6h%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
