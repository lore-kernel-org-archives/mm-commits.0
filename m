Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F99C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 867346141B
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhEEBhS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhEEBhS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:37:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 030AD61413;
        Wed,  5 May 2021 01:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178581;
        bh=tuEb6KKu0GXFg0zPBMOcQPe+tIjKgNBW/uXG52nBCQ8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xnc3E2ctXOs716jNjmCpcG3C3KAU2YIlv5xXU4GSqyaW2RceFWL8nFnQ8OTjs/pGf
         9Ow7lA20DrnSKuA3V/hIP1bE5wDeyxvLMyuHcfvLMOt6GLqC7Vwvit9mPBV8EZFvyv
         gdUEEdMR1j1gpqmdA++YqRzW6Gg5aHUbyl8K+TT8=
Date:   Tue, 04 May 2021 18:36:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@fromorbit.com, guro@fb.com,
        hannes@cmpxchg.org, ktkhai@virtuozzo.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 066/143] mm: vmscan: use kvfree_rcu instead of
 call_rcu
Message-ID: <20210505013620.KY48HgUq5%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: vmscan: use kvfree_rcu instead of call_rcu

Using kvfree_rcu() to free the old shrinker_maps instead of call_rcu(). 
We don't have to define a dedicated callback for call_rcu() anymore.

Link: https://lkml.kernel.org/r/20210311190845.9708-6-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-use-kvfree_rcu-instead-of-call_rcu
+++ a/mm/vmscan.c
@@ -192,11 +192,6 @@ static inline int shrinker_map_size(int
 	return (DIV_ROUND_UP(nr_items, BITS_PER_LONG) * sizeof(unsigned long));
 }
 
-static void free_shrinker_map_rcu(struct rcu_head *head)
-{
-	kvfree(container_of(head, struct memcg_shrinker_map, rcu));
-}
-
 static int expand_one_shrinker_map(struct mem_cgroup *memcg,
 				   int size, int old_size)
 {
@@ -220,7 +215,7 @@ static int expand_one_shrinker_map(struc
 		memset((void *)new->map + old_size, 0, size - old_size);
 
 		rcu_assign_pointer(pn->shrinker_map, new);
-		call_rcu(&old->rcu, free_shrinker_map_rcu);
+		kvfree_rcu(old, rcu);
 	}
 
 	return 0;
_
