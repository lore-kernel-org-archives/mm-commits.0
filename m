Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEF7C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0250A60F46
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhKKCqp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234032AbhKKCqp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC1CA6103C;
        Thu, 11 Nov 2021 02:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598636;
        bh=ZG6C4c50/hhmPQeIC5g/dYA2Fr3vAymlJAEUHYiEJYg=;
        h=Date:From:To:Subject:From;
        b=VlVJrFgEeBjUPAbi43bBfpMBoF9u51cAZd9tIOe2Emv2AnptCuvAKP0KJq7FgMjrq
         1z8sU+gSSifPCDoehHrAR22zJE9/6/RXQAHqk7UMLs4bPIngVnNx7b5iuMxXzELs4U
         6oiBrzwqTp495R0XSgHmJo/GvzefuKEeniVxLGhY=
Date:   Wed, 10 Nov 2021 18:43:56 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        peterz@infradead.org, sfr@canb.auug.org.au, vbabka@suse.cz
Subject:  [merged]
 mm-page_allocc-avoid-allocating-highmem-pages-via-alloc_pages_exact.patch
 removed from -mm tree
Message-ID: <20211111024356.Z1qoj3zCP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: avoid allocating highmem pages via alloc_pages_exact[_nid]
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-avoid-allocating-highmem-pages-via-alloc_pages_exact.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are


