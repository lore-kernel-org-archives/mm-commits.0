Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA88DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C52E060F46
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbhKKCqf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234240AbhKKCqf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83DA361247;
        Thu, 11 Nov 2021 02:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598626;
        bh=cuBVSXGV3fMRGhpKb2kcevJ1ofe7AdRchbotickOw4k=;
        h=Date:From:To:Subject:From;
        b=JJFCaWg+HbWE8y0cBcmcI2G1h81w2OCuGSdPq9k+UgRb6wBWVXB2X4V2h8XFZ7gYX
         aKp0Vi03OD1ajhDI8jx4Mp27VX8HjMzyXyGpCLpkg7rXIPYfQ1lsreZbYrmoIYxcPz
         D3vRJjGEjmrVV9RadkERAt/69qa2HnY73n8sal/o=
Date:   Wed, 10 Nov 2021 18:43:46 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        peterz@infradead.org, sfr@canb.auug.org.au, vbabka@suse.cz
Subject:  [merged]
 mm-page_allocc-remove-meaningless-vm_bug_on-in-pindex_to_order.patch
 removed from -mm tree
Message-ID: <20211111024346.1xuVEf62N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove meaningless VM_BUG_ON() in pindex_to_order()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-remove-meaningless-vm_bug_on-in-pindex_to_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are


