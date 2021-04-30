Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24783C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B04961476
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhD3F47 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhD3F44 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:56:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 982F16147D;
        Fri, 30 Apr 2021 05:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762168;
        bh=2wdpLD/7baU5QCKAblvh4FJGmneaVlwqakTcxUNPo9k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=C4On8VvEFpYw7+G1mD/5zkmArjZMBP4eS5oQzP+xAihKKL+GOoBkvgfxneRgPhZ9W
         lsRaP7DHG0i4yAkoKZfk8eNIvZFUuFkvz7gfjzA/eqzrZ61+Z4LMr6t5VQzKqYB6XH
         6jqds4JUIloKUIacc3BhmJNIixHuLztYXtmlvzEw=
Date:   Thu, 29 Apr 2021 22:56:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, torvalds@linux-foundation.org
Subject:  [patch 058/178] memcg: enable memcg oom-kill for
 __GFP_NOFAIL
Message-ID: <20210430055608.7KyQIVQxl%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: enable memcg oom-kill for __GFP_NOFAIL

In the era of async memcg oom-killer, the commit a0d8b00a3381 ("mm: memcg:
do not declare OOM from __GFP_NOFAIL allocations") added the code to skip
memcg oom-killer for __GFP_NOFAIL allocations.  The reason was that the
__GFP_NOFAIL callers will not enter aync oom synchronization path and will
keep the task marked as in memcg oom.  At that time the tasks marked in
memcg oom can bypass the memcg limits and the oom synchronization would
have happened later in the later userspace triggered page fault.  Thus
letting the task marked as under memcg oom bypass the memcg limit for
arbitrary time.

With the synchronous memcg oom-killer (commit 29ef680ae7c21 ("memcg, oom:
move out_of_memory back to the charge path")) and not letting the task
marked under memcg oom to bypass the memcg limits (commit 1f14c1ac19aa4
("mm: memcg: do not allow task about to OOM kill to bypass the limit")),
we can again allow __GFP_NOFAIL allocations to trigger memcg oom-kill. 
This will make memcg oom behavior closer to page allocator oom behavior.

Link: https://lkml.kernel.org/r/20210223204337.2785120-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memcontrol.c~memcg-enable-memcg-oom-kill-for-__gfp_nofail
+++ a/mm/memcontrol.c
@@ -2779,9 +2779,6 @@ retry:
 	if (gfp_mask & __GFP_RETRY_MAYFAIL)
 		goto nomem;
 
-	if (gfp_mask & __GFP_NOFAIL)
-		goto force;
-
 	if (fatal_signal_pending(current))
 		goto force;
 
_
