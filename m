Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114DAC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiJCVQh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJCVOg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37AD1C40C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49415611E0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1155C433D7;
        Mon,  3 Oct 2022 21:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831387;
        bh=juXrtMnY5L6MDdVuC84CrXRTGZb5X/dVZv4LpyHrz60=;
        h=Date:To:From:Subject:From;
        b=DkrEWawFvhYuUKAHC6xJIcJNxhw4XW9A7Nq3xiXmaLmvaEmhReXKgxCwi9D7mxrQv
         nVkuMTiBC/BejsKBCnTHae71aUYWxIpc9r5Dwr5sFQ5s0R3571qrxRyIYtCus2xpm1
         cpfNW5vbm+EmJqTf/ZCsEj4x6rWeNlYBZ7JvftsU=
Date:   Mon, 03 Oct 2022 14:09:46 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        ran.xiaokai@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-update-comments-for-rmqueue.patch removed from -mm tree
Message-Id: <20221003210947.A1155C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: update comments for rmqueue()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-update-comments-for-rmqueue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: mm/page_alloc: update comments for rmqueue()
Date: Sun, 18 Sep 2022 02:56:40 +0000

Since commit 44042b449872 ("mm/page_alloc: allow high-order pages to be
stored on the per-cpu lists"), the per-cpu page allocators (PCP) is not
only for order-0 pages.  Update the comments.

Link: https://lkml.kernel.org/r/20220918025640.208586-1-ran.xiaokai@zte.com.cn
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-update-comments-for-rmqueue
+++ a/mm/page_alloc.c
@@ -3810,7 +3810,8 @@ static struct page *rmqueue_pcplist(stru
 }
 
 /*
- * Allocate a page from the given zone. Use pcplists for order-0 allocations.
+ * Allocate a page from the given zone.
+ * Use pcplists for THP or "cheap" high-order allocations.
  */
 
 /*
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are


