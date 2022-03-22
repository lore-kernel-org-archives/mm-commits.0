Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE5FC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiCVVls (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235914AbiCVVlL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:41:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F18E5EBEC
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:39:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E075B61741
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4678EC340EC;
        Tue, 22 Mar 2022 21:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985172;
        bh=6k287UQLQFkel2wGvwxTb471aMwsHRQGu+R6HZZy33U=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=N9r8hMac9Rm9vw8tl1BkW4XBLtrMwjqV+mqGkeRigQQlM6kwNmby0mFzRX9D0jrN4
         1ZxvNNGXah6BaLfFRon1rZ+yIi+JwWxd8MpgG7f1MfYfBV8lJSwKRrIOW2FutD3JXr
         G4U7bK+oIjRL72Jdegh+XBJzIMohqGoHMS21MMqc=
Date:   Tue, 22 Mar 2022 14:39:31 -0700
To:     hannes@cmpxchg.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 020/227] mm/writeback: minor clean up for highmem_dirtyable_memory
Message-Id: <20220322213932.4678EC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
