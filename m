Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4758C11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86D0C61476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238460AbhGAB4C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238426AbhGAB4C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:56:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DA646105A;
        Thu,  1 Jul 2021 01:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104412;
        bh=fuMkmBU7yPyKzy8r5TqtczMmTrAuGmdg+ZdJKBaeL9k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kvwO2WjwX4rRYPUkahrJXxx80rd2ZTrw2D5iIOIRUw63ZEyey6ReEy7nLZUoEMd7W
         M1wTBroDVmNun+cQf/yrIPvZ1ycivmV0j1vrBRK3fIIxM5pv0hgqjbdW4nlQF41mZB
         o+duBxWVQKlCdqaf1xpJ2NAUYJDPvM+2CNUPiPg0=
Date:   Wed, 30 Jun 2021 18:53:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, david@redhat.com,
        ddstreet@ieee.org, linux-mm@kvack.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 119/192] mm/memcontrol.c: fix kerneldoc comment
 for mem_cgroup_calculate_protection
Message-ID: <20210701015332.GbAUI-EaM%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/memcontrol.c: fix kerneldoc comment for mem_cgroup_calculate_protection

make W=1 generates the following warning for mem_cgroup_calculate_protection

  mm/memcontrol.c:6468: warning: expecting prototype for mem_cgroup_protected(). Prototype was for mem_cgroup_calculate_protection() instead

Commit 45c7f7e1ef17 ("mm, memcg: decouple e{low,min} state mutations from
protection checks") changed the function definition but not the associated
kerneldoc comment.

Link: https://lkml.kernel.org/r/20210520084809.8576-7-mgorman@techsingularity.net
Fixes: 45c7f7e1ef17 ("mm, memcg: decouple e{low,min} state mutations from protection checks")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrolc-fix-kerneldoc-comment-for-mem_cgroup_calculate_protection
+++ a/mm/memcontrol.c
@@ -6639,7 +6639,7 @@ static unsigned long effective_protectio
 }
 
 /**
- * mem_cgroup_protected - check if memory consumption is in the normal range
+ * mem_cgroup_calculate_protection - check if memory consumption is in the normal range
  * @root: the top ancestor of the sub-tree being checked
  * @memcg: the memory cgroup to check
  *
_
