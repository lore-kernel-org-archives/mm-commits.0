Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19028C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06AD56113A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350164AbhICVAr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350144AbhICVAl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 754646112F;
        Fri,  3 Sep 2021 20:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702781;
        bh=xT3aLeDPX2AQbBPLbUjdMos74IyBNX+alaiL62QmzR8=;
        h=Date:From:To:Subject:From;
        b=eXRjuL8VAyN7c0lyvB33flB681AC9TCJnE1VkBb5ypj2NzxKPHOxf2W2D4+Ht1OMD
         aXGVR72U6IauhTAKaZZPMsc3haZqvJCoSMjZDkL2MkdHYtDDvRBGTFvYvdC3BLPS3M
         J2B39xm4g9bXq13029X058i6Wg8y5Y/mg25ULd4U=
Date:   Fri, 03 Sep 2021 13:59:41 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vvs@virtuozzo.com
Subject:  [merged] mm-use-in_task-in-mm-page_allocc.patch removed
 from -mm tree
Message-ID: <20210903205941.1G2hPL4OZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: use in_task()
has been removed from the -mm tree.  Its filename was
     mm-use-in_task-in-mm-page_allocc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from vvs@virtuozzo.com are


