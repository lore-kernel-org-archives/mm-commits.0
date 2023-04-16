Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E9CC77B73
	for <mm-commits@archiver.kernel.org>; Sun, 16 Apr 2023 17:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjDPRl7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Apr 2023 13:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjDPRl6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Apr 2023 13:41:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A1410CB
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 10:41:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 461856102A
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 17:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AD4C433D2;
        Sun, 16 Apr 2023 17:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681666915;
        bh=sq652LKawINa7GeIdHpsSYcLqAsPMn5zTWEbbtDBC40=;
        h=Date:To:From:Subject:From;
        b=0S5xmLln0ZMlObsuFhmpJcDD/2wGq2IPp383sc1nZHG3v/HjC6ly4Xw5mjCNSur1L
         wCyTtT6J1rx5Fn/mn7LwLzai8KQFwNUQ119xVabKLVTm3kBIrrA4rqLAUV4EB4eZiX
         yf33o67+JHflbHhrrCzfuUJru3ht0Axw4CsQ90/U=
Date:   Sun, 16 Apr 2023 10:41:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        mgorman@suse.de, lstoakes@gmail.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-fix-performance-regression-on-sparsetruncate-tiny.patch removed from -mm tree
Message-Id: <20230416174155.98AD4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: swap: fix performance regression on sparsetruncate-tiny
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-performance-regression-on-sparsetruncate-tiny.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: swap: fix performance regression on sparsetruncate-tiny
Date: Thu, 6 Apr 2023 00:18:53 +0800

The ->percpu_pvec_drained was originally introduced by commit d9ed0d08b6c6
("mm: only drain per-cpu pagevecs once per pagevec usage") to drain
per-cpu pagevecs only once per pagevec usage.  But after converting the
swap code to be more folio-based, the commit c2bc16817aa0 ("mm/swap: add
folio_batch_move_lru()") breaks this logic, which would cause
->percpu_pvec_drained to be reset to false, that means per-cpu pagevecs
will be drained multiple times per pagevec usage.

In theory, there should be no functional changes when converting code to
be more folio-based.  We should call folio_batch_reinit() in
folio_batch_move_lru() instead of folio_batch_init().  And to verify that
we still need ->percpu_pvec_drained, I ran mmtests/sparsetruncate-tiny and
got the following data:

                             baseline                   with
                            baseline/                 patch/
Min       Time      326.00 (   0.00%)      328.00 (  -0.61%)
1st-qrtle Time      334.00 (   0.00%)      336.00 (  -0.60%)
2nd-qrtle Time      338.00 (   0.00%)      341.00 (  -0.89%)
3rd-qrtle Time      343.00 (   0.00%)      347.00 (  -1.17%)
Max-1     Time      326.00 (   0.00%)      328.00 (  -0.61%)
Max-5     Time      327.00 (   0.00%)      330.00 (  -0.92%)
Max-10    Time      328.00 (   0.00%)      331.00 (  -0.91%)
Max-90    Time      350.00 (   0.00%)      357.00 (  -2.00%)
Max-95    Time      395.00 (   0.00%)      390.00 (   1.27%)
Max-99    Time      508.00 (   0.00%)      434.00 (  14.57%)
Max       Time      547.00 (   0.00%)      476.00 (  12.98%)
Amean     Time      344.61 (   0.00%)      345.56 *  -0.28%*
Stddev    Time       30.34 (   0.00%)       19.51 (  35.69%)
CoeffVar  Time        8.81 (   0.00%)        5.65 (  35.87%)
BAmean-99 Time      342.38 (   0.00%)      344.27 (  -0.55%)
BAmean-95 Time      338.58 (   0.00%)      341.87 (  -0.97%)
BAmean-90 Time      336.89 (   0.00%)      340.26 (  -1.00%)
BAmean-75 Time      335.18 (   0.00%)      338.40 (  -0.96%)
BAmean-50 Time      332.54 (   0.00%)      335.42 (  -0.87%)
BAmean-25 Time      329.30 (   0.00%)      332.00 (  -0.82%)

From the above it can be seen that we get similar data to when
->percpu_pvec_drained was introduced, so we still need it.  Let's call
folio_batch_reinit() in folio_batch_move_lru() to restore the original
logic.

Link: https://lkml.kernel.org/r/20230405161854.6931-1-zhengqi.arch@bytedance.com
Fixes: c2bc16817aa0 ("mm/swap: add folio_batch_move_lru()")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-swap-fix-performance-regression-on-sparsetruncate-tiny
+++ a/mm/swap.c
@@ -222,7 +222,7 @@ static void folio_batch_move_lru(struct
 	if (lruvec)
 		unlock_page_lruvec_irqrestore(lruvec, flags);
 	folios_put(fbatch->folios, folio_batch_count(fbatch));
-	folio_batch_init(fbatch);
+	folio_batch_reinit(fbatch);
 }
 
 static void folio_batch_add_and_move(struct folio_batch *fbatch,
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-mlock-use-folios_put-in-mlock_folio_batch.patch

