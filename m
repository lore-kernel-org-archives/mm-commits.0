Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 352A6ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 19 Sep 2022 21:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiISVd4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Sep 2022 17:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiISVdz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2022 17:33:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CE04D4E3
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 14:33:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6256AB81BC2
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 21:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283D0C433D6;
        Mon, 19 Sep 2022 21:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663623232;
        bh=elpTJ/5nc4FdxUXgq2Ub2tJRjEkBIznCvyqusWFrtq0=;
        h=Date:To:From:Subject:From;
        b=ahj1QF2ja7+wcYpz2KZNkMOKPtRhC/Fz1GNWZeXwXUEvlT4t2hgiVV6sOHb/r4/pO
         F3wCCkwsN2UzZ5V2tcsccz3lBx95oAZIhuU1I92W6tis61RKSbVMM66Jzsq4pdg6DH
         ehOiNLNd4BrvMu4y2HDY5MrKlTwjw4ODsMNJ1qQ4=
Date:   Mon, 19 Sep 2022 14:33:43 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        ran.xiaokai@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-update-comments-for-rmqueue.patch added to mm-unstable branch
Message-Id: <20220919213351.283D0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: update comments for rmqueue()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-update-comments-for-rmqueue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-update-comments-for-rmqueue.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-page_alloc-update-comments-for-rmqueue.patch

