Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13DB10A1E
	for <mm-commits@vger.kernel.org>; Sun, 17 Aug 2025 19:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755457263; cv=none; b=W6icKBZBkPEJRXEQFN5SAgp25MlS/RPEicdsO8SBS8UdLAMH73la0jhDMovpKpYWc26Dx2GikT0Md/LRWMcKU3EDuHJd8Ncyf5l3312EAPwInDkjknV2IN0I9NGfcRFvnGVDug/+XoZ1RlsV0HyZtINdilqa8H5IU5+ymG/BK/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755457263; c=relaxed/simple;
	bh=KikIJe0uwZvO+p85+B+V4ek9i+kUFsL/KBDOew3sbhM=;
	h=Date:To:From:Subject:Message-Id; b=QX0MUwPirBamu3ggF0DSkwTaONBeswlREbag/ZCZHUtbDaQRFSi/g4pfmRhdmg8XLiyuLx5/m1qbMouIpLq1ctpk9Y4ft/wHqnsP6+lxDg8AnWzMImh7NFwH5R4DrgVKwkUt4bg7Td7YOTrTw1d8uQ0uHSNpnmR5G3pD3QE5x8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uawEGNwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uawEGNwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D28C4CEEB;
	Sun, 17 Aug 2025 19:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755457262;
	bh=KikIJe0uwZvO+p85+B+V4ek9i+kUFsL/KBDOew3sbhM=;
	h=Date:To:From:Subject:From;
	b=uawEGNwX1Qo2+zMmUNCE9yoOytc5R3L4p/3VWXV/i8NLYw0VdJrbqmGHsIUdeHQ/c
	 CYVMmCflY0psFnnsEcTjTHOquN6ihSc+5wYl3sQ4D/Pls7UGbpZbOkGtljNoT931iJ
	 pEMtmam+dY4lBlaxFJEEILRfD0GPSwHObES1bXcM=
Date: Sun, 17 Aug 2025 12:01:01 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,liuqiqi@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-duplicate-accounting-of-free-pages-in-should_reclaim_retry.patch added to mm-new branch
Message-Id: <20250817190102.61D28C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix duplicate accounting of free pages in should_reclaim_retry()
has been added to the -mm mm-new branch.  Its filename is
     mm-fix-duplicate-accounting-of-free-pages-in-should_reclaim_retry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-duplicate-accounting-of-free-pages-in-should_reclaim_retry.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: liuqiqi <liuqiqi@kylinos.cn>
Subject: mm: fix duplicate accounting of free pages in should_reclaim_retry()
Date: Tue, 12 Aug 2025 15:02:10 +0800

In the zone_reclaimable_pages() function, if the page counts for
NR_ZONE_INACTIVE_FILE, NR_ZONE_ACTIVE_FILE, NR_ZONE_INACTIVE_ANON, and
NR_ZONE_ACTIVE_ANON are all zero, the function returns the number of free
pages as the result.

In this case, when should_reclaim_retry() calculates reclaimable pages, it
will inadvertently double-count the free pages in its accounting.

static inline bool
should_reclaim_retry(gfp_t gfp_mask, unsigned order,
                     struct alloc_context *ac, int alloc_flags,
                     bool did_some_progress, int *no_progress_loops)
{
        ...
                available = reclaimable = zone_reclaimable_pages(zone);
                available += zone_page_state_snapshot(zone, NR_FREE_PAGES);

Link: https://lkml.kernel.org/r/20250812070210.1624218-1-liuqiqi@kylinos.cn
Signed-off-by: liuqiqi <liuqiqi@kylinos.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-fix-duplicate-accounting-of-free-pages-in-should_reclaim_retry
+++ a/mm/vmscan.c
@@ -398,14 +398,7 @@ unsigned long zone_reclaimable_pages(str
 	if (can_reclaim_anon_pages(NULL, zone_to_nid(zone), NULL))
 		nr += zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_ANON) +
 			zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_ANON);
-	/*
-	 * If there are no reclaimable file-backed or anonymous pages,
-	 * ensure zones with sufficient free pages are not skipped.
-	 * This prevents zones like DMA32 from being ignored in reclaim
-	 * scenarios where they can still help alleviate memory pressure.
-	 */
-	if (nr == 0)
-		nr = zone_page_state_snapshot(zone, NR_FREE_PAGES);
+
 	return nr;
 }
 
@@ -6495,7 +6488,7 @@ static bool allow_direct_reclaim(pg_data
 		return true;
 
 	for_each_managed_zone_pgdat(zone, pgdat, i, ZONE_NORMAL) {
-		if (!zone_reclaimable_pages(zone))
+		if (!zone_reclaimable_pages(zone) && zone_page_state_snapshot(zone, NR_FREE_PAGES))
 			continue;
 
 		pfmemalloc_reserve += min_wmark_pages(zone);
_

Patches currently in -mm which might be from liuqiqi@kylinos.cn are

mm-fix-duplicate-accounting-of-free-pages-in-should_reclaim_retry.patch

