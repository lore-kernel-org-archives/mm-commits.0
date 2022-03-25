Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251A8C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357336AbiCYBb4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357322AbiCYBbs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D998333A14
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AE60B8272A
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545E5C340F1;
        Fri, 25 Mar 2022 01:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171798;
        bh=rdXS1epKpBkMoIjs6ZLJy+JFN6w62NqY3J8hgHKNH6s=;
        h=Date:To:From:Subject:From;
        b=MJr0oq3fRB0PsZaBVXhlmMOIjv7Hab+GPQuSQ/Q6FP8gnD/jSdOA8tPyvSO6Y6SPu
         7ctgUD1kIxY7qv7XsGOCOcTicmOOyJHzvYzewf2wA6uRnNOgXkaoaRnB15A+LhJPOr
         F5b2cCcPKOM3lEUHwHhGhLjjJkAzIMtvL9y3EA1g=
Date:   Thu, 24 Mar 2022 18:29:57 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-writeback-minor-clean-up-for-highmem_dirtyable_memory.patch removed from -mm tree
Message-Id: <20220325012958.545E5C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/writeback: minor clean up for highmem_dirtyable_memory
has been removed from the -mm tree.  Its filename was
     mm-writeback-minor-clean-up-for-highmem_dirtyable_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/writeback: minor clean up for highmem_dirtyable_memory

Since commit a804552b9a15 ("mm/page-writeback.c: fix dirty_balance_reserve
subtraction from dirtyable memory"), local variable x can not be negative.
And it can not overflow when it is the total number of dirtyable highmem
pages.  Thus remove the unneeded comment and overflow check.

Link: https://lkml.kernel.org/r/20220224115416.46089-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/mm/page-writeback.c~mm-writeback-minor-clean-up-for-highmem_dirtyable_memory
+++ a/mm/page-writeback.c
@@ -324,18 +324,6 @@ static unsigned long highmem_dirtyable_m
 	}
 
 	/*
-	 * Unreclaimable memory (kernel memory or anonymous memory
-	 * without swap) can bring down the dirtyable pages below
-	 * the zone's dirty balance reserve and the above calculation
-	 * will underflow.  However we still want to add in nodes
-	 * which are below threshold (negative values) to get a more
-	 * accurate calculation but make sure that the total never
-	 * underflows.
-	 */
-	if ((long)x < 0)
-		x = 0;
-
-	/*
 	 * Make sure that the number of highmem pages is never larger
 	 * than the number of the total dirtyable memory. This can only
 	 * occur in very strange VM situations but we want to make sure
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

