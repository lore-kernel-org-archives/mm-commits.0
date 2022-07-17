Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A529EC43334
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 23:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiGQX3o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 19:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiGQX3n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 19:29:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E3412625
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 16:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83B1260EEB
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 23:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2280C341C0;
        Sun, 17 Jul 2022 23:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658100581;
        bh=xW0PHjSeWV+UDJxTSJmf4wPqmbmKakAVSzwtP/Tm+es=;
        h=Date:To:From:Subject:From;
        b=i7rMyC0HRqDQ/nYI8ZaPAEXVNicyQwqoIGVPpAg86dIeH48oLA81ghkF5shcpUEKU
         WbSYOZgAvIMhMlMIjLspjCsz/Yr9PYDLgzO7H4PCeNG6afZ+/tHiqlv7WbRVgk7DJO
         FYYdN6mLHxD6UbIr52x9Ycxu8jrYtHDlbk3y3XeI=
Date:   Sun, 17 Jul 2022 16:29:41 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-replace-local_lock-with-normal-spinlock-fix.patch removed from -mm tree
Message-Id: <20220717232941.D2280C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: replace local_lock with normal spinlock -fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-replace-local_lock-with-normal-spinlock-fix.patch

This patch was dropped because it was folded into mm-page_alloc-replace-local_lock-with-normal-spinlock.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: replace local_lock with normal spinlock -fix
Date: Mon, 27 Jun 2022 09:46:45 +0100

As noted by Yu Zhao, use pcp_spin_trylock_irqsave instead of
pcpu_spin_trylock_irqsave.  This is a fix to the mm-unstable patch
mm-page_alloc-replace-local_lock-with-normal-spinlock.patch

Link: https://lkml.kernel.org/r/20220627084645.GA27531@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Yu Zhao <yuzhao@google.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-replace-local_lock-with-normal-spinlock-fix
+++ a/mm/page_alloc.c
@@ -3497,7 +3497,7 @@ void free_unref_page(struct page *page,
 
 	zone = page_zone(page);
 	pcp_trylock_prepare(UP_flags);
-	pcp = pcpu_spin_trylock_irqsave(struct per_cpu_pages, lock, zone->per_cpu_pageset, flags);
+	pcp = pcp_spin_trylock_irqsave(zone->per_cpu_pageset, flags);
 	if (pcp) {
 		free_unref_page_commit(zone, pcp, page, migratetype, order);
 		pcp_spin_unlock_irqrestore(pcp, flags);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-add-page-buddy_list-and-page-pcp_list.patch
mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations.patch
mm-page_alloc-split-out-buddy-removal-code-from-rmqueue-into-separate-helper.patch
mm-page_alloc-remove-mistaken-page-==-null-check-in-rmqueue.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch
mm-page_alloc-replace-local_lock-with-normal-spinlock.patch

