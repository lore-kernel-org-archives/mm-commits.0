Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7AFC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B554610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347670AbhIBV7V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348003AbhIBV7N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 259616056B;
        Thu,  2 Sep 2021 21:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619894;
        bh=zrzosgC0QO0RitcskmFEX3iKsSKYZnf0lK4qUJbTZOw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dZ70jsvlNsz30uRN7fLAmZ8QTacww7B2aybhl36rXGTpSUsSzlkwctv6zKaKRIukX
         NPVV2JU8VWTrUtAJWPsl3VtQx/4qDvt13jOS88pvMH9eqniDZSeFA5SWY73i26M+jx
         n+iLgpCQYbZ0NM7Fc/5tRMMOuOmEYRMS2zdkTatQ=
Date:   Thu, 02 Sep 2021 14:58:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vvs@virtuozzo.com
Subject:  [patch 156/212] mm/page_alloc.c: use in_task()
Message-ID: <20210902215813.3fTkEAjnl%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>
Subject: mm/page_alloc.c: use in_task()

Obsoleted in_intrrupt() include task context with disabled BH, it's better
to use in_task() instead.

Link: https://lkml.kernel.org/r/877caa99-1994-5545-92d2-d0bb2e394182@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-use-in_task-in-mm-page_allocc
+++ a/mm/page_alloc.c
@@ -4211,7 +4211,7 @@ static void warn_alloc_show_mem(gfp_t gf
 		if (tsk_is_oom_victim(current) ||
 		    (current->flags & (PF_MEMALLOC | PF_EXITING)))
 			filter &= ~SHOW_MEM_FILTER_NODES;
-	if (in_interrupt() || !(gfp_mask & __GFP_DIRECT_RECLAIM))
+	if (!in_task() || !(gfp_mask & __GFP_DIRECT_RECLAIM))
 		filter &= ~SHOW_MEM_FILTER_NODES;
 
 	show_mem(filter, nodemask);
@@ -4697,7 +4697,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 * comment for __cpuset_node_allowed().
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
-	} else if (unlikely(rt_task(current)) && !in_interrupt())
+	} else if (unlikely(rt_task(current)) && in_task())
 		alloc_flags |= ALLOC_HARDER;
 
 	alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, alloc_flags);
@@ -5157,7 +5157,7 @@ static inline bool prepare_alloc_pages(g
 		 * When we are in the interrupt context, it is irrelevant
 		 * to the current task context. It means that any node ok.
 		 */
-		if (!in_interrupt() && !ac->nodemask)
+		if (in_task() && !ac->nodemask)
 			ac->nodemask = &cpuset_current_mems_allowed;
 		else
 			*alloc_flags |= ALLOC_CPUSET;
_
