Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6825C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356287AbiCYBfM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353973AbiCYBeh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A6EBF52C
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67972608C1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBD9C340ED;
        Fri, 25 Mar 2022 01:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171946;
        bh=xB0JzElTtfw7F8YCQ1KvQLg6sOnQ5HkwlyxpE3hVU9U=;
        h=Date:To:From:Subject:From;
        b=ePb0ymnprTLiGKIx2sGF2KmaXGBDdIS47A/i5zAWI2sxXsOEncD03WYjYToMonsB0
         hL+i8zVyVChCu3OVr6Pj6IaHh7brvZI9XOVXCmeOrKr7UVwFeHQp3IiVjMGOQMfwcf
         mdCqRBvw33ba5pwz2Njot01TUiwuFjrjuVkBfUgg=
Date:   Thu, 24 Mar 2022 18:32:26 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, minchan@kernel.org,
        iamjoonsoo.kim@lge.com, cgel.zte@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-page_io-fix-psi-memory-pressure-error-on-cold-swapins.patch removed from -mm tree
Message-Id: <20220325013226.BCBD9C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_io: fix psi memory pressure error on cold swapins
has been removed from the -mm tree.  Its filename was
     mm-page_io-fix-psi-memory-pressure-error-on-cold-swapins.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_io: fix psi memory pressure error on cold swapins

Once upon a time, all swapins counted toward memory pressure[1].  Then
Joonsoo introduced workingset detection for anonymous pages and we gained
the ability to distinguish hot from cold swapins[2][3].  But we failed to
update swap_readpage() accordingly, and now we account partial memory
pressure in the swapin path of cold memory.

Not for all situations - which adds more inconsistency: paths using the
conventional submit_bio() and lock_page() route will not see much pressure
- unless storage itself is heavily congested and the bio submissions
stall.  ZRAM and ZSWAP do most of the work directly from swap_readpage()
and will see all swapins reflected as pressure.

IOW, a workload doing cold swapins could see little to no pressure
reported with on-disk swap, but potentially high pressure with a zram or
zswap backend.  That confuses any psi-based health monitoring, load
shedding, proactive reclaim, or userspace OOM killing schemes that might
be in place for the workload.

Restore consistency by making all swapin stall accounting conditional on
the page actually being part of the workingset.

[1] commit 937790699be9 ("mm/page_io.c: annotate refault stalls from swap_readpage")
[2] commit aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")
[3] commit cad8320b4b39 ("mm/swap: don't SetPageWorkingset unconditionally during swapin")

Link: https://lkml.kernel.org/r/20220214214921.419687-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: CGEL <cgel.zte@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/page_io.c~mm-page_io-fix-psi-memory-pressure-error-on-cold-swapins
+++ a/mm/page_io.c
@@ -359,6 +359,7 @@ int swap_readpage(struct page *page, boo
 	struct bio *bio;
 	int ret = 0;
 	struct swap_info_struct *sis = page_swap_info(page);
+	bool workingset = PageWorkingset(page);
 	unsigned long pflags;
 
 	VM_BUG_ON_PAGE(!PageSwapCache(page) && !synchronous, page);
@@ -370,7 +371,8 @@ int swap_readpage(struct page *page, boo
 	 * or the submitting cgroup IO-throttled, submission can be a
 	 * significant part of overall IO time.
 	 */
-	psi_memstall_enter(&pflags);
+	if (workingset)
+		psi_memstall_enter(&pflags);
 	delayacct_swapin_start();
 
 	if (frontswap_load(page) == 0) {
@@ -433,7 +435,8 @@ int swap_readpage(struct page *page, boo
 	bio_put(bio);
 
 out:
-	psi_memstall_leave(&pflags);
+	if (workingset)
+		psi_memstall_leave(&pflags);
 	delayacct_swapin_end();
 	return ret;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-madvise-madv_dontneed_locked.patch

