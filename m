Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839F0C433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4430B64F22
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBZBQP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:16:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhBZBQO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:16:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9708C64EE3;
        Fri, 26 Feb 2021 01:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302134;
        bh=bqlenhwYJYd99S+BR+XRUZ+lPkPdwVUjkAZBbG0yJiQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=e8GLc65Y4UWuJHSGlr/wDhpSOWWEmjmJPaaINl5wsEVfxDghDohv5kkcBCqagWr4y
         aj8fRjjkiaogIcSCv/hFUMgmz3fMe2M5l07RbvQLb2YQadnax5KJz6nB7GiaU4W50o
         03o4xENefIYHAlKX4PXQpauWLZhOW/N0sCZTuOuw=
Date:   Thu, 25 Feb 2021 17:15:33 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 003/118] mm/swap: optimise
 get_shadow_from_swap_cache
Message-ID: <20210226011533.UmfpU8Cyp%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: optimise get_shadow_from_swap_cache

There's no need to get a reference to the page, just load the entry and
see if it's a shadow entry.

Link: https://lkml.kernel.org/r/20201112212641.27837-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swap_state.c~mm-swap-optimise-get_shadow_from_swap_cache
+++ a/mm/swap_state.c
@@ -87,11 +87,9 @@ void *get_shadow_from_swap_cache(swp_ent
 	pgoff_t idx = swp_offset(entry);
 	struct page *page;
 
-	page = find_get_entry(address_space, idx);
+	page = xa_load(&address_space->i_pages, idx);
 	if (xa_is_value(page))
 		return page;
-	if (page)
-		put_page(page);
 	return NULL;
 }
 
_
