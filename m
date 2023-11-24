Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D803BC61DF4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 18:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjKXSqV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 13:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbjKXSqV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 13:46:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8508B270F
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 10:46:27 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19661C433C7;
        Fri, 24 Nov 2023 18:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700851587;
        bh=QDWwxU8hy8KkgUU7UAYPqwvyBrpzNGT+s1cFz3/umEs=;
        h=Date:To:From:Subject:From;
        b=iMMrOQq+RA/W1hfjDlr3Kz2s1vS3bu36oWQLMyroi41LVE1gJZG6/zTOagKH0sSAU
         8aAeYlzKm4kE8XPJyVBqy5bhnqtygLCY8M7aZshJsVUQ6JV/DK2pheAPyx9u6hBD5S
         8S9nb9w6DVJzNtTTXOE3yN1MeS6pNpEy5Kx8MQN0=
Date:   Fri, 24 Nov 2023 10:46:26 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rientjes@google.com,
        quic_pkondeti@quicinc.com, quic_cgoldswo@quicinc.com,
        mhocko@suse.com, mgorman@techsingularity.net, hannes@cmpxchg.org,
        david@redhat.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-unreserve-highatomic-page-blocks-before-oom.patch added to mm-unstable branch
Message-Id: <20231124184627.19661C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: unreserve highatomic page blocks before oom
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-unreserve-highatomic-page-blocks-before-oom.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-unreserve-highatomic-page-blocks-before-oom.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: page_alloc: unreserve highatomic page blocks before oom
Date: Fri, 24 Nov 2023 16:27:25 +0530

__alloc_pages_direct_reclaim() is called from slowpath allocation where
high atomic reserves can be unreserved after there is a progress in
reclaim and yet no suitable page is found.  Later should_reclaim_retry()
gets called from slow path allocation to decide if the reclaim needs to be
retried before OOM kill path is taken.

should_reclaim_retry() checks the available(reclaimable + free pages)
memory against the min wmark levels of a zone and returns:

a) true, if it is above the min wmark so that slow path allocation will
   do the reclaim retries.

b) false, thus slowpath allocation takes oom kill path.

should_reclaim_retry() can also unreserves the high atomic reserves **but
only after all the reclaim retries are exhausted.**

In a case where there are almost none reclaimable memory and free pages
contains mostly the high atomic reserves but allocation context can't use
these high atomic reserves, makes the available memory below min wmark
levels hence false is returned from should_reclaim_retry() leading the
allocation request to take OOM kill path.  This can turn into a early oom
kill if high atomic reserves are holding lot of free memory and
unreserving of them is not attempted.

(early)OOM is encountered on a VM with the below state:
[  295.998653] Normal free:7728kB boost:0kB min:804kB low:1004kB
high:1204kB reserved_highatomic:8192KB active_anon:4kB inactive_anon:0kB
active_file:24kB inactive_file:24kB unevictable:1220kB writepending:0kB
present:70732kB managed:49224kB mlocked:0kB bounce:0kB free_pcp:688kB
local_pcp:492kB free_cma:0kB
[  295.998656] lowmem_reserve[]: 0 32
[  295.998659] Normal: 508*4kB (UMEH) 241*8kB (UMEH) 143*16kB (UMEH)
33*32kB (UH) 7*64kB (UH) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB
0*4096kB = 7752kB

Per above log, the free memory of ~7MB exist in the high atomic reserves
is not freed up before falling back to oom kill path.

Fix it by trying to unreserve the high atomic reserves in
should_reclaim_retry() before __alloc_pages_direct_reclaim() can fallback
to oom kill path.

Link: https://lkml.kernel.org/r/1700823445-27531-1-git-send-email-quic_charante@quicinc.com
Fixes: 0aaa29a56e4f ("mm, page_alloc: reserve pageblocks for high-order atomic allocations on demand")
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Reported-by: Chris Goldsworthy <quic_cgoldswo@quicinc.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Chris Goldsworthy <quic_cgoldswo@quicinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-unreserve-highatomic-page-blocks-before-oom
+++ a/mm/page_alloc.c
@@ -3951,14 +3951,9 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	else
 		(*no_progress_loops)++;
 
-	/*
-	 * Make sure we converge to OOM if we cannot make any progress
-	 * several times in the row.
-	 */
-	if (*no_progress_loops > MAX_RECLAIM_RETRIES) {
-		/* Before OOM, exhaust highatomic_reserve */
-		return unreserve_highatomic_pageblock(ac, true);
-	}
+	if (*no_progress_loops > MAX_RECLAIM_RETRIES)
+		goto out;
+
 
 	/*
 	 * Keep reclaiming pages while there is a chance this will lead
@@ -4001,6 +3996,11 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		schedule_timeout_uninterruptible(1);
 	else
 		cond_resched();
+out:
+	/* Before OOM, exhaust highatomic_reserve */
+	if (!ret)
+		return unreserve_highatomic_pageblock(ac, true);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-sparsemem-fix-race-in-accessing-memory_section-usage.patch
mm-sparsemem-fix-race-in-accessing-memory_section-usage-v2.patch
mm-page_alloc-correct-high-atomic-reserve-calculations.patch
mm-page_alloc-enforce-minimum-zone-size-to-do-high-atomic-reserves.patch
mm-page_alloc-unreserve-highatomic-page-blocks-before-oom.patch

