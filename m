Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F2AC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 190976140E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhEHWmD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWmD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 882A761402;
        Sat,  8 May 2021 22:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513660;
        bh=iKRC68l5rkcwYwL39NxnFe8sfSvBRpFqwnY/o8KqkBw=;
        h=Date:From:To:Subject:From;
        b=roFUHd6a38y0ZW3AJy38qopeMyfc3bRl2wsPJ//VFMvfRv5dF9wWOSJ3SU5ModgJz
         Egwi4tf9BFl0q4/YE60OjGHFVBWutcC66bA79V7YD8+SVnP3y9l24PHHKZJDCQ7End
         g/5rk6wwbUydvo+05nj0U56Yhoh0T/sb3168lxlY=
Date:   Sat, 08 May 2021 15:41:00 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        rientjes@google.com, shakeelb@google.com
Subject:  [merged]
 memcg-enable-memcg-oom-kill-for-__gfp_nofail.patch removed from -mm tree
Message-ID: <20210508224100.KTWKyJ6Hq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable memcg oom-kill for __GFP_NOFAIL
has been removed from the -mm tree.  Its filename was
     memcg-enable-memcg-oom-kill-for-__gfp_nofail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from shakeelb@google.com are


