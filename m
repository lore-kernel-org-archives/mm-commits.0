Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68DCC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 21:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 830136117A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 21:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhJMVLS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 17:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229945AbhJMVLR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 17:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0EF561154;
        Wed, 13 Oct 2021 21:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634159354;
        bh=u+9VFmVwqx1H1/9BjyfI3pKx+TRrxy/LpGdNyrjJYe4=;
        h=Date:From:To:Subject:From;
        b=C8omvEvacJqVTIclH2tQ+ux3/awwkk/CiwQ4iae/kBrj+m9ZnkFpk7aiJXkBBZM2i
         WMey3ol3yLgHDNad8hOa9DVUf3GSOsUkSraduRF7IQSS0NLoDbxLcnuVX81v1XCGTJ
         dzlvfVVPePk6hWgftrmcgsViHwR1F0oDkN7cah40=
Date:   Wed, 13 Oct 2021 14:09:13 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        urezki@gmail.com, vvs@virtuozzo.com
Subject:  +
 memcg-page_alloc-skip-bulk-allocator-for-__gfp_account.patch added to -mm
 tree
Message-ID: <20211013210913.3EW1QcKmI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
has been added to the -mm tree.  Its filename is
     memcg-page_alloc-skip-bulk-allocator-for-__gfp_account.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-page_alloc-skip-bulk-allocator-for-__gfp_account.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-page_alloc-skip-bulk-allocator-for-__gfp_account.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT

The commit 5c1f4e690eec ("mm/vmalloc: switch to bulk allocator in
__vmalloc_area_node()") switched to bulk page allocator for order 0
allocation backing vmalloc.  However bulk page allocator does not support
__GFP_ACCOUNT allocations and there are several users of
kvmalloc(__GFP_ACCOUNT).

For now make __GFP_ACCOUNT allocations bypass bulk page allocator.  In
future if there is workload that can be significantly improved with the
bulk page allocator with __GFP_ACCCOUNT support, we can revisit the
decision.

Link: https://lkml.kernel.org/r/20211013194338.1804247-1-shakeelb@google.com
Fixes: 5c1f4e690eec ("mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c~memcg-page_alloc-skip-bulk-allocator-for-__gfp_account
+++ a/mm/page_alloc.c
@@ -5208,6 +5208,10 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
 
+	/* Bulk allocator does not support memcg accounting. */
+	if (unlikely(gfp & __GFP_ACCOUNT))
+		goto out;
+
 	/*
 	 * Skip populated array elements to determine if any pages need
 	 * to be allocated before disabling IRQs.
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-flush-stats-only-if-updated.patch
memcg-unify-memcg-stat-flushing.patch
memcg-page_alloc-skip-bulk-allocator-for-__gfp_account.patch

