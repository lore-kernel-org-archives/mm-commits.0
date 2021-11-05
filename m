Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78AF3C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61A33611C4
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhKEUm4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhKEUmz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FD3A60FBF;
        Fri,  5 Nov 2021 20:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144815;
        bh=QbO42ExNIn8x+KZzHMuaQWZwZnEUnHV7UNuPArJFLeY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oz491ubQ73HjYa8p2AivjV+uMIxkdLcx/X4ryE+VO+MfF+6S7IcLb9Ny6B1kAgj/k
         b8uCfqhIgGcr7Vfr2jli5nhghr45iXUug743Zs/h94Yy/IEQlghGlIQLfobY8A1xku
         uZrOZRCZuldYfyUk132aRgW7Ucq0MsZ/SnjVNhns=
Date:   Fri, 05 Nov 2021 13:40:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        sfr@canb.auug.org.au, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 107/262] mm/page_alloc.c: avoid allocating highmem
 pages via alloc_pages_exact[_nid]
Message-ID: <20211105204015.RExQsUpA5%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc.c: avoid allocating highmem pages via alloc_pages_exact[_nid]

Don't use with __GFP_HIGHMEM because page_address() cannot represent
highmem pages without kmap().  Newly allocated pages would leak as
page_address() will return NULL for highmem pages here.  But It works now
because the callers do not specify __GFP_HIGHMEM now.

Link: https://lkml.kernel.org/r/20210902121242.41607-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-avoid-allocating-highmem-pages-via-alloc_pages_exact
+++ a/mm/page_alloc.c
@@ -5610,8 +5610,8 @@ void *alloc_pages_exact(size_t size, gfp
 	unsigned int order = get_order(size);
 	unsigned long addr;
 
-	if (WARN_ON_ONCE(gfp_mask & __GFP_COMP))
-		gfp_mask &= ~__GFP_COMP;
+	if (WARN_ON_ONCE(gfp_mask & (__GFP_COMP | __GFP_HIGHMEM)))
+		gfp_mask &= ~(__GFP_COMP | __GFP_HIGHMEM);
 
 	addr = __get_free_pages(gfp_mask, order);
 	return make_alloc_exact(addr, order, size);
@@ -5635,8 +5635,8 @@ void * __meminit alloc_pages_exact_nid(i
 	unsigned int order = get_order(size);
 	struct page *p;
 
-	if (WARN_ON_ONCE(gfp_mask & __GFP_COMP))
-		gfp_mask &= ~__GFP_COMP;
+	if (WARN_ON_ONCE(gfp_mask & (__GFP_COMP | __GFP_HIGHMEM)))
+		gfp_mask &= ~(__GFP_COMP | __GFP_HIGHMEM);
 
 	p = alloc_pages_node(nid, gfp_mask, order);
 	if (!p)
_
