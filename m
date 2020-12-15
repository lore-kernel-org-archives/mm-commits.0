Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA2BC2BBCA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF42122D02
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgLOX7m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:32898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729656AbgLOXZl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:41 -0500
Date:   Tue, 15 Dec 2020 15:23:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074622;
        bh=Kpv9GoFW0kJGkM0TiV/3UCN+PbycfhHX2keyDeLvLU4=;
        h=From:To:Subject:From;
        b=HKPeaMNOTuWjgWrrUD24k2uJdcP7GbJPoRkXLkWHVwL2RzcSTUOvft17C/UR7Ot6O
         Pe2ric5yKIBiJKMmOdJi10d5M6XhmL0yU/NE9LoWmsV0oyTL9MchYAvrSLA9qiE4KH
         Xxl3mNfeV6UEgRNeaHGL1gNuZ4p2QlZGq5gFrvm4=
From:   akpm@linux-foundation.org
To:     charante@codeaurora.org, david@redhat.com, iamjoonsoo.kim@lge.com,
        jrdr.linux@gmail.com, mm-commits@vger.kernel.org, vbabka@suse.cz,
        vinmenon@codeaurora.org
Subject:  [merged] mm-cma-improve-pr_debug-log-in-cma_release.patch
 removed from -mm tree
Message-ID: <20201215232342.MroLXylb-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: improve pr_debug log in cma_release()
has been removed from the -mm tree.  Its filename was
     mm-cma-improve-pr_debug-log-in-cma_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Charan Teja Reddy <charante@codeaurora.org>
Subject: mm: cma: improve pr_debug log in cma_release()

It is required to print 'count' of pages, along with the pages, passed to
cma_release to debug the cases of mismatched count value passed between
cma_alloc() and cma_release() from a code path.

As an example, consider the below scenario:

1) CMA pool size is 4MB and

2) User doing the erroneous step of allocating 2 pages but freeing 1
   page in a loop from this CMA pool.  The step 2 causes cma_alloc() to
   return NULL at one point of time because of -ENOMEM condition.

And the current pr_debug logs is not giving the info about these types of
allocation patterns because of count value not being printed in
cma_release().

We are printing the count value in the trace logs, just extend the same to
pr_debug logs too.

[akpm@linux-foundation.org: fix printk warning]
Link: https://lkml.kernel.org/r/1606318341-29521-1-git-send-email-charante@codeaurora.org
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Reviewed-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-improve-pr_debug-log-in-cma_release
+++ a/mm/cma.c
@@ -510,7 +510,7 @@ bool cma_release(struct cma *cma, const
 	if (!cma || !pages)
 		return false;
 
-	pr_debug("%s(page %p)\n", __func__, (void *)pages);
+	pr_debug("%s(page %p, count %u)\n", __func__, (void *)pages, count);
 
 	pfn = page_to_pfn(pages);
 
_

Patches currently in -mm which might be from charante@codeaurora.org are


