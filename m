Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3040BC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1716061208
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhKKCqj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234240AbhKKCqj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 942D061108;
        Thu, 11 Nov 2021 02:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598630;
        bh=cZ//whrsuFwAafsgIO16Vy2hG2uMXXjDJJCHNOgPK+A=;
        h=Date:From:To:Subject:From;
        b=dDpUhfUZ3gXYxdQlXU11N4Wu7sguggnpTFbWxAVq2jx1LlMRVdssoPG/1TgSm2fRp
         oaCvpEdWpI10/Ir1N8CpOHQhblwv2JwL+pl07UTUMSkbfYyfxx3e3xTK3xHFjqo7GK
         m7WQ6XPR3zxgbOV9ERcZm2gsR1jwO3aGLWaikndo=
Date:   Wed, 10 Nov 2021 18:43:50 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        peterz@infradead.org, sfr@canb.auug.org.au, vbabka@suse.cz
Subject:  [merged]
 mm-page_allocc-fix-obsolete-comment-in-free_pcppages_bulk.patch removed
 from -mm tree
Message-ID: <20211111024350.OvAU2QpG9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix obsolete comment in free_pcppages_bulk()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-fix-obsolete-comment-in-free_pcppages_bulk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc.c: fix obsolete comment in free_pcppages_bulk()

The second two paragraphs about "all pages pinned" and pages_scanned is
obsolete.  And There are PAGE_ALLOC_COSTLY_ORDER + 1 + NR_PCP_THP orders
in pcp.  So the same order assumption is not held now.

Link: https://lkml.kernel.org/r/20210902121242.41607-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-fix-obsolete-comment-in-free_pcppages_bulk
+++ a/mm/page_alloc.c
@@ -1428,14 +1428,8 @@ static inline void prefetch_buddy(struct
 
 /*
  * Frees a number of pages from the PCP lists
- * Assumes all pages on list are in same zone, and of same order.
+ * Assumes all pages on list are in same zone.
  * count is the number of pages to free.
- *
- * If the zone was previously in an "all pages pinned" state then look to
- * see if this freeing clears that state.
- *
- * And clear the zone's pages_scanned counter, to hold off the "all pages are
- * pinned" detection logic.
  */
 static void free_pcppages_bulk(struct zone *zone, int count,
 					struct per_cpu_pages *pcp)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


