Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F28C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E051D60FBF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhKEUmu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhKEUmt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43EC9611C0;
        Fri,  5 Nov 2021 20:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144809;
        bh=1I2QrS70wrVINvLHznWTYvysKnwg3/+DP4wUEERX45E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Kk5Mz/HPSMPdPYscBxZ3BGwBo/TZyWpV7IPt8kRFeYAyR5Qujdeg2lgBU+LlvvUXh
         +vH6ASoL5RjviNZzDlZwCMKDMYj8jxz/n7fYsWxI0X6QSlPBvpizGdkhLmj54AVd8Y
         50PFNfHS0ICsJh80GeqTkrV8788ny0TOPrNlJzbU=
Date:   Fri, 05 Nov 2021 13:40:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        sfr@canb.auug.org.au, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 105/262] mm/page_alloc.c: fix obsolete comment in
 free_pcppages_bulk()
Message-ID: <20211105204008.9CZvnKIC_%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
