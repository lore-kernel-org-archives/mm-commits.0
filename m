Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42DDC43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357472AbiCYBew (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357517AbiCYBdP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3489BF959
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84A2CB8261B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE39C340ED;
        Fri, 25 Mar 2022 01:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171893;
        bh=KD05JJkCfDXGpXza8vdvevWmL9YwNBA0eelXHgvEXdI=;
        h=Date:To:From:Subject:From;
        b=FX0dq49Oax1ILWgQAZ+NDJ0cX1+AorYokI7FR0uoPYg+zPMBxewNbjTjbk8RYpnNx
         IZu6lgSK2QDAfajPK0ALWL14CaPeSTtfSIPvpHT1lmFKOshxDq6KnnO2s2K2ZV4AmY
         hdrmvVHCOhSefcC7U6+jeh5T41SCP4OkOZxFCNQo=
Date:   Thu, 24 Mar 2022 18:31:32 -0700
To:     mm-commits@vger.kernel.org, timmurray@google.com,
        shakeelb@google.com, roman.gushchin@linux.dev, pmladek@suse.com,
        peterz@infradead.org, minchan@kernel.org, mhocko@suse.com,
        hannes@cmpxchg.org, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch removed from -mm tree
Message-Id: <20220325013133.1EE39C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: count time in drain_all_pages during direct reclaim as memory pressure
has been removed from the -mm tree.  Its filename was
     mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: count time in drain_all_pages during direct reclaim as memory pressure

When page allocation in direct reclaim path fails, the system will make
one attempt to shrink per-cpu page lists and free pages from high alloc
reserves.  Draining per-cpu pages into buddy allocator can be a very slow
operation because it's done using workqueues and the task in direct
reclaim waits for all of them to finish before proceeding.  Currently this
time is not accounted as psi memory stall.

While testing mobile devices under extreme memory pressure, when
allocations are failing during direct reclaim, we notices that psi events
which would be expected in such conditions were not triggered.  After
profiling these cases it was determined that the reason for missing psi
events was that a big chunk of time spent in direct reclaim is not
accounted as memory stall, therefore psi would not reach the levels at
which an event is generated.  Further investigation revealed that the bulk
of that unaccounted time was spent inside drain_all_pages call.

A typical captured case when drain_all_pages path gets activated:

__alloc_pages_slowpath  took 44.644.613ns
    __perform_reclaim   took    751.668ns (1.7%)
    drain_all_pages     took 43.887.167ns (98.3%)

PSI in this case records the time spent in __perform_reclaim but ignores
drain_all_pages, IOW it misses 98.3% of the time spent in
__alloc_pages_slowpath.

Annotate __alloc_pages_direct_reclaim in its entirety so that delays from
handling page allocation failure in the direct reclaim path are accounted
as memory stall.

Link: https://lkml.kernel.org/r/20220223194812.1299646-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Tim Murray <timmurray@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure
+++ a/mm/page_alloc.c
@@ -4554,13 +4554,12 @@ __perform_reclaim(gfp_t gfp_mask, unsign
 					const struct alloc_context *ac)
 {
 	unsigned int noreclaim_flag;
-	unsigned long pflags, progress;
+	unsigned long progress;
 
 	cond_resched();
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
-	psi_memstall_enter(&pflags);
 	fs_reclaim_acquire(gfp_mask);
 	noreclaim_flag = memalloc_noreclaim_save();
 
@@ -4569,7 +4568,6 @@ __perform_reclaim(gfp_t gfp_mask, unsign
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(gfp_mask);
-	psi_memstall_leave(&pflags);
 
 	cond_resched();
 
@@ -4583,11 +4581,13 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 		unsigned long *did_some_progress)
 {
 	struct page *page = NULL;
+	unsigned long pflags;
 	bool drained = false;
 
+	psi_memstall_enter(&pflags);
 	*did_some_progress = __perform_reclaim(gfp_mask, order, ac);
 	if (unlikely(!(*did_some_progress)))
-		return NULL;
+		goto out;
 
 retry:
 	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
@@ -4603,6 +4603,8 @@ retry:
 		drained = true;
 		goto retry;
 	}
+out:
+	psi_memstall_leave(&pflags);
 
 	return page;
 }
_

Patches currently in -mm which might be from surenb@google.com are


