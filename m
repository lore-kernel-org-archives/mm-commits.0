Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D0FC433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C152364F34
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhB0C2u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:28:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhB0C2u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:28:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F11364F14;
        Sat, 27 Feb 2021 02:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392889;
        bh=z7DH4nEYOjZh6YRAJ7ccPny0GxzFEKYCzZObvtaB354=;
        h=Date:From:To:Subject:From;
        b=rwRO77FHkYN+UUJogt6w7F/rwgHAzAvzX6m49EgxVGwgGIQDLrYX+HGndmcbDfVyH
         kIC0CzqnFChN/y1YmLG0f1WRr52Q3YL9C94/WxTZkSWbE2ASkUOSwEzsYjiPUpwxeI
         JH/A7/s6AdPcYdyFnPlJjq7On68TpvuD1LlI6WIA=
Date:   Fri, 26 Feb 2021 18:28:09 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [merged]
 mm-swap-optimise-get_shadow_from_swap_cache.patch removed from -mm tree
Message-ID: <20210227022809.P15oLlUsi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: optimise get_shadow_from_swap_cache
has been removed from the -mm tree.  Its filename was
     mm-swap-optimise-get_shadow_from_swap_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are


