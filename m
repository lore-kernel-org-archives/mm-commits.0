Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F14C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E111A61252
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhKEUmo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhKEUmn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13E6560FBF;
        Fri,  5 Nov 2021 20:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144803;
        bh=37V5lx+8mlbtRPyzBZJsOo4FXS3OHt9/vxbe9Xl0xUA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ENhJSmT4YdfWQlHYQkksuavHKbSb3L3bE0pVqJGt53Tij8HBUmXcH1AWHolu1lwrc
         KwXChZtCcUrOwXR06fE2INorb9CSwwLiiS893aawl6vRhapMNSxou05RaW5QpcXES/
         IvKpioZMLlF6uEs+8m2e+mGt49emQOHxuyvwqKYQ=
Date:   Fri, 05 Nov 2021 13:40:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        sfr@canb.auug.org.au, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 103/262] mm/page_alloc.c: remove meaningless
 VM_BUG_ON() in pindex_to_order()
Message-ID: <20211105204002.Dy-gv70Y4%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc.c: remove meaningless VM_BUG_ON() in pindex_to_order()

Patch series "Cleanups and fixup for page_alloc", v2.

This series contains cleanups to remove meaningless VM_BUG_ON(), use
helpers to simplify the code and remove obsolete comment.  Also we avoid
allocating highmem pages via alloc_pages_exact[_nid].  More details can be
found in the respective changelogs.  


This patch (of 5):

It's meaningless to VM_BUG_ON() order != pageblock_order just after
setting order to pageblock_order.  Remove it.

Link: https://lkml.kernel.org/r/20210902121242.41607-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210902121242.41607-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-remove-meaningless-vm_bug_on-in-pindex_to_order
+++ a/mm/page_alloc.c
@@ -677,10 +677,8 @@ static inline int pindex_to_order(unsign
 	int order = pindex / MIGRATE_PCPTYPES;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (order > PAGE_ALLOC_COSTLY_ORDER) {
+	if (order > PAGE_ALLOC_COSTLY_ORDER)
 		order = pageblock_order;
-		VM_BUG_ON(order != pageblock_order);
-	}
 #else
 	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 #endif
_
