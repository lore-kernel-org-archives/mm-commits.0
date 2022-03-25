Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8B6C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357353AbiCYBcK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357335AbiCYBbu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B8F2FFD5
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03FDD61941
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFEDC340EC;
        Fri, 25 Mar 2022 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171816;
        bh=OrU90eKJp4Z7oUX2fQPyVphHbOaqPgfPAX5zUCZnfwo=;
        h=Date:To:From:Subject:From;
        b=tB/VzC+pG36zPkFxuUKPJlFZaaI3WGlvRaQh30OJ8QqP7mK5++8+1wW8IzfR5AH7W
         I+i6BU5sVXx3itET5uWw3u/0Mdec/JlbiahxiznvHjnro4Y2A9QaMD3ip6eDMVCzvz
         kMq33lppNawAhMnIhMEuEFMFRFz2LXYJHZMq477k=
Date:   Thu, 24 Mar 2022 18:30:15 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        mhocko@suse.com, hannes@cmpxchg.org, guro@fb.com,
        chris@chrisdown.name, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] memcg-unify-force-charging-conditions.patch removed from -mm tree
Message-Id: <20220325013016.5FFEDC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: unify force charging conditions
has been removed from the -mm tree.  Its filename was
     memcg-unify-force-charging-conditions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: unify force charging conditions

Currently the kernel force charges the allocations which have __GFP_HIGH
flag without triggering the memory reclaim.  __GFP_HIGH indicates that the
caller is high priority and since commit 869712fd3de5 ("mm: memcontrol:
fix network errors from failing __GFP_ATOMIC charges") the kernel lets
such allocations do force charging.  Please note that __GFP_ATOMIC has
been replaced by __GFP_HIGH.

__GFP_HIGH does not tell if the caller can block or can trigger reclaim. 
There are separate checks to determine that.  So, there is no need to skip
reclaiming for __GFP_HIGH allocations.  So, handle __GFP_HIGH together
with __GFP_NOFAIL which also does force charging.

Please note that this is a noop change as there are no __GFP_HIGH
allocators in the kernel which also have __GFP_ACCOUNT (or SLAB_ACCOUNT)
and does not allow reclaim for now.

Link: https://lkml.kernel.org/r/20220211064917.2028469-3-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~memcg-unify-force-charging-conditions
+++ a/mm/memcontrol.c
@@ -2566,15 +2566,6 @@ retry:
 	}
 
 	/*
-	 * Memcg doesn't have a dedicated reserve for atomic
-	 * allocations. But like the global atomic pool, we need to
-	 * put the burden of reclaim on regular allocation requests
-	 * and let these go through as privileged allocations.
-	 */
-	if (gfp_mask & __GFP_ATOMIC)
-		goto force;
-
-	/*
 	 * Prevent unbounded recursion when reclaim operations need to
 	 * allocate memory. This might exceed the limits temporarily,
 	 * but we prefer facilitating memory reclaim and getting back
@@ -2647,7 +2638,13 @@ retry:
 		goto retry;
 	}
 nomem:
-	if (!(gfp_mask & __GFP_NOFAIL))
+	/*
+	 * Memcg doesn't have a dedicated reserve for atomic
+	 * allocations. But like the global atomic pool, we need to
+	 * put the burden of reclaim on regular allocation requests
+	 * and let these go through as privileged allocations.
+	 */
+	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
 		return -ENOMEM;
 force:
 	/*
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-sync-flush-only-if-periodic-flush-is-delayed.patch

