Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7F0C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B845E2223F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633413;
	bh=z5J91t5FC9FcStAWHyI5DzrSoiGme3mVZCR9CrkvMLA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=zJ/9FJvl8Zh7cWJd2T1nMS3lKzn5kAnyKzE8Cw044dGhRg6Nx9W+6XxlX/sP80Vbi
	 0g57X6XpS4LrRVMj8BP622Rrg2MPthO4dBKZyV9Zab/4Y6XI6jPuspmfagu5pm4+Yz
	 rEXW7qa3tpb/a0PPvoRHCLcqopAduT2A+oK5ULAY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbgJMX4x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgJMX4x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEA8E2222F;
        Tue, 13 Oct 2020 23:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633413;
        bh=z5J91t5FC9FcStAWHyI5DzrSoiGme3mVZCR9CrkvMLA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mciLY0p8fMv4q7Bjo5ULIprku7Hpyd76GT9aMG7VwvN8J6oaIYOqoedT44waRHcib
         ZV25cKYD7Sm73WspB/0M+sbAv62Punke9EdXBBpq71VgIpWnJmp12oRSs6Am5fuixJ
         9lMmuvQv9dq+je0M3mFnU+voWGdGuzTBRIsCwg1U=
Date:   Tue, 13 Oct 2020 16:56:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sh_def@163.com,
        torvalds@linux-foundation.org
Subject:  [patch 154/181] mm/z3fold.c: use xx_zalloc instead
 xx_alloc and memset
Message-ID: <20201013235652.hOUXk_sFI%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hui Su <sh_def@163.com>
Subject: mm/z3fold.c: use xx_zalloc instead xx_alloc and memset

alloc_slots() allocates memory for slots using kmem_cache_alloc(), then
memsets it.  We can just use kmem_cache_zalloc().

Link: https://lkml.kernel.org/r/20200926100834.GA184671@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/z3fold.c~mmz3fold-use-xx_zalloc-instead-xx_alloc-and-memset
+++ a/mm/z3fold.c
@@ -212,13 +212,12 @@ static inline struct z3fold_buddy_slots
 {
 	struct z3fold_buddy_slots *slots;
 
-	slots = kmem_cache_alloc(pool->c_handle,
+	slots = kmem_cache_zalloc(pool->c_handle,
 				 (gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE)));
 
 	if (slots) {
 		/* It will be freed separately in free_handle(). */
 		kmemleak_not_leak(slots);
-		memset(slots->slot, 0, sizeof(slots->slot));
 		slots->pool = (unsigned long)pool;
 		rwlock_init(&slots->lock);
 	}
_
