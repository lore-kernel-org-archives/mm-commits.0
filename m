Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A61C4321A
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC98464EC0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346405AbhCDA7N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355428AbhCDA2W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:28:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C41DF64E56;
        Thu,  4 Mar 2021 00:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614817686;
        bh=0H/7nMea4W7EWmmtWgkzenDOlLGgAGWce/roSwIdwZE=;
        h=Date:From:To:Subject:From;
        b=HUkIGnyrjGh4nC+pCWV7eLaYC6ha5nKczzYM129SNNzeYcT8FSrCUCxQj5tMfPJUB
         Ax/Xz6IhPKYeeIn8Q5NZPLxhHIu6KvZGBp3fEY4/sb4JpDaPdOvcUlzwkXC7NNeR6v
         QLovNljJcTc4gufzgiwU/teZiQVv+zpkCXgr4Nns=
Date:   Wed, 03 Mar 2021 16:28:05 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        rientjes@google.com, shakeelb@google.com
Subject:  + memcg-enable-memcg-oom-kill-for-__gfp_nofail.patch
 added to -mm tree
Message-ID: <20210304002805.i8rqma3e0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable memcg oom-kill for __GFP_NOFAIL
has been added to the -mm tree.  Its filename is
     memcg-enable-memcg-oom-kill-for-__gfp_nofail.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-enable-memcg-oom-kill-for-__gfp_nofail.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-enable-memcg-oom-kill-for-__gfp_nofail.patch

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
@@ -2793,9 +2793,6 @@ retry:
 	if (gfp_mask & __GFP_RETRY_MAYFAIL)
 		goto nomem;
 
-	if (gfp_mask & __GFP_NOFAIL)
-		goto force;
-
 	if (fatal_signal_pending(current))
 		goto force;
 
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-cleanup-root-memcg-checks.patch
memcg-enable-memcg-oom-kill-for-__gfp_nofail.patch

