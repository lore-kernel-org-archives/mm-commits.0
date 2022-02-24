Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E1AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 04:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiBXEQ6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 23:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBXEQ6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 23:16:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39E723BF28
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 20:16:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72005B8235F
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 04:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0980BC340E9;
        Thu, 24 Feb 2022 04:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645676186;
        bh=Ek38hl5i3/Ah5pCUgKclcs4P92IXq9WiubzYrwXZakg=;
        h=Date:To:From:Subject:From;
        b=10lBX/buLLh/JsiLg5z2BuLrAka9zf6Qo0h8rCIb1YBLQdnYBnCs8/vlRozH3ZtAw
         13Mn7t3wMGIVgzQNgsx9IkugX1W03nIPFJPR2DGkLxneoiH5nE0TCJYbR+C82zmik7
         DslI6QIxC/AXMUfpk2iZJ4TQFLAtSj24LTyo1A4M=
Date:   Wed, 23 Feb 2022 20:16:25 -0800
To:     mm-commits@vger.kernel.org, timmurray@google.com,
        shakeelb@google.com, pmladek@suse.com, peterz@infradead.org,
        minchan@kernel.org, mhocko@suse.com, hannes@cmpxchg.org,
        guro@fb.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch added to -mm tree
Message-Id: <20220224041626.0980BC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: count time in drain_all_pages during direct reclaim as memory pressure
has been added to the -mm tree.  Its filename is
     mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Michal Hocko <mhocko@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure
+++ a/mm/page_alloc.c
@@ -4610,13 +4610,12 @@ __perform_reclaim(gfp_t gfp_mask, unsign
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
 
@@ -4625,7 +4624,6 @@ __perform_reclaim(gfp_t gfp_mask, unsign
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(gfp_mask);
-	psi_memstall_leave(&pflags);
 
 	cond_resched();
 
@@ -4639,11 +4637,13 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
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
@@ -4659,6 +4659,8 @@ retry:
 		drained = true;
 		goto retry;
 	}
+out:
+	psi_memstall_leave(&pflags);
 
 	return page;
 }
_

Patches currently in -mm which might be from surenb@google.com are

mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch
mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed.patch
mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch

