Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756BEC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  8 Apr 2022 20:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbiDHUL1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 16:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239427AbiDHULW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 16:11:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CF51A777B
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 13:09:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C07E6B82D66
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 20:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6C3C385A3;
        Fri,  8 Apr 2022 20:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649448554;
        bh=CqgdUQ8KtmQ/Yioj4EEH5I++u5nh/s1yL09Oz1Ljgus=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=lurkYQeuelUK9MzaQvPWE59Mc2SYGwBMwF5zstmCGj2AAUTY2zxII0D/2B+TR6M+t
         zGJp1GhQsY6gZYogUUO5cUbUahD0DTXo1pShk8RZSvHH4Wz7RN/Y/QLrLdxRKyBIG8
         Cvy8rjaytF8h3A10SHPnJ1U31nUmg3pN3jOf9ZOw=
Date:   Fri, 08 Apr 2022 13:09:13 -0700
To:     songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, longman@redhat.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220408130819.a89195e527ce58dfbe0700b9@linux-foundation.org>
Subject: [patch 8/9] mm/list_lru.c: revert "mm/list_lru: optimize memcg_reparent_list_lru_node()"
Message-Id: <20220408200914.7C6C3C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/list_lru.c: revert "mm/list_lru: optimize memcg_reparent_list_lru_node()"

405cc51fc1049c73 ("mm/list_lru: optimize memcg_reparent_list_lru_node()")
has subtle races which are proving ugly to fix.  Revert the original
optimization.  If quantitative testing indicates that we have a
significant problem here then other implementations can be looked at.

Fixes: 405cc51fc1049c73 ("mm/list_lru: optimize memcg_reparent_list_lru_node()")
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/list_lru.c~mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node
+++ a/mm/list_lru.c
@@ -395,12 +395,6 @@ static void memcg_reparent_list_lru_node
 	struct list_lru_one *src, *dst;
 
 	/*
-	 * If there is no lru entry in this nlru, we can skip it immediately.
-	 */
-	if (!READ_ONCE(nlru->nr_items))
-		return;
-
-	/*
 	 * Since list_lru_{add,del} may be called under an IRQ-safe lock,
 	 * we have to use IRQ-safe primitives here to avoid deadlock.
 	 */
_
