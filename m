Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADA7C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 20:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbiBOUtJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 15:49:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbiBOUtI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 15:49:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2B2BC11
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 12:48:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89F0F61871
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 20:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55A7C340EC;
        Tue, 15 Feb 2022 20:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644958137;
        bh=oqGIiGG62ANqcEgGREelMa5HXAcmu3HvPgE6PYim5yc=;
        h=Date:To:From:Subject:From;
        b=MEpoCTOQPZTgetX6WM0LSF3mw13dDbUFBnAoc7VCs9VjBAvXnlBGsAt2PR/vtgHV/
         j782IO6zUtHsSEEYl1/OFa+3LtdGJ+FCscE/nGNDj1izkxrAmwKwc2Xi0xpijyqKus
         jwAjBqk2TB6XQwMTc2AhIIskS/MH1uVsfldLVyN0=
Date:   Tue, 15 Feb 2022 12:48:56 -0800
To:     mm-commits@vger.kernel.org, mhocko@suse.com, hannes@cmpxchg.org,
        guro@fb.com, chris@chrisdown.name, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-unify-force-charging-conditions.patch added to -mm tree
Message-Id: <20220215204856.D55A7C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: unify force charging conditions
has been added to the -mm tree.  Its filename is
     memcg-unify-force-charging-conditions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-unify-force-charging-conditions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-unify-force-charging-conditions.patch

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

memcg-replace-in_interrupt-with-in_task.patch
memcg-refactor-mem_cgroup_oom.patch
memcg-unify-force-charging-conditions.patch
selftests-memcg-test-high-limit-for-single-entry-allocation.patch
memcg-synchronously-enforce-memoryhigh-for-large-overcharges.patch

