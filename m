Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D855CBB
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uinwkYHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D54C433C8;
	Mon, 11 Dec 2023 00:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256125;
	bh=zqRpxhoRe151qSmDuSsOmQNrC4+KJDAE/ofynScqzik=;
	h=Date:To:From:Subject:From;
	b=uinwkYHVEzim80aanjh/xL0gczILio5z3yX1IEvMZRm90NZi+3GP8F9ao9yC0DUhd
	 B8w55h3Er5leoX4D4QT6SiBN6Czneh/xaAodxZ+0B8USL7oyFVkxo4ng/ZPkmnqAa/
	 I3cIneqbikGliMV909lnugX75yph0ERncRea8YXE=
Date: Sun, 10 Dec 2023 16:55:24 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rientjes@google.com,quic_pkondeti@quicinc.com,quic_cgoldswo@quicinc.com,mhocko@suse.com,mgorman@techsingularity.net,hannes@cmpxchg.org,david@redhat.com,quic_charante@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-unreserve-highatomic-page-blocks-before-oom.patch removed from -mm tree
Message-Id: <20231211005525.56D54C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: unreserve highatomic page blocks before oom
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-unreserve-highatomic-page-blocks-before-oom.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

