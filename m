Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB86C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343520AbiEYRtG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343516AbiEYRtC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:49:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C9D95DC9
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BB9FB81E92
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB9FC34113;
        Wed, 25 May 2022 17:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653500937;
        bh=CEDAYMh58+l9kMTHV4uYro3UVdgWOhpva9wveqWHfdY=;
        h=Date:To:From:Subject:From;
        b=qHTeVgONilzZQP4SKrs2D1n18tgId48cHsw8/QI/ZN77csrObn1NaAh9m8cdI4qmG
         aYjcYYyqv8lAeHQsHBBGQdI8gU2qY6tQMLYjWjWa18pKacr1Kppk5awXw8jXjVF8DC
         TbYezYx2NtQQ85hWRSc+gtGBJlce5RU/yHmXO6Uk=
Date:   Wed, 25 May 2022 10:48:56 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        tim.c.chen@linux.intel.com, songmuchun@bytedance.com,
        shy828301@gmail.com, shakeelb@google.com, roman.gushchin@linux.dev,
        mhocko@suse.com, dave.hansen@linux.intel.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-mm-vmscan-never-demote-for-memcg-reclaim.patch removed from -mm tree
Message-Id: <20220525174856.EBB9FC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm/vmscan: never demote for memcg reclaim"
has been removed from the -mm tree.  Its filename was
     revert-mm-vmscan-never-demote-for-memcg-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Revert "mm/vmscan: never demote for memcg reclaim"
Date: Wed, 18 May 2022 15:09:11 -0400

This reverts commit 3a235693d3930e1276c8d9cc0ca5807ef292cf0a.

Its premise was that cgroup reclaim cares about freeing memory inside the
cgroup, and demotion just moves them around within the cgroup limit. 
Hence, pages from toptier nodes should be reclaimed directly.

However, with NUMA balancing now doing tier promotions, demotion is part
of the page aging process.  Global reclaim demotes the coldest toptier
pages to secondary memory, where their life continues and from which they
have a chance to get promoted back.  Essentially, tiered memory systems
have an LRU order that spans multiple nodes.

When cgroup reclaims pages coming off the toptier directly, there can be
colder pages on lower tier nodes that were demoted by global reclaim. 
This is an aging inversion, not unlike if cgroups were to reclaim directly
from the active lists while there are inactive pages.

Proactive reclaim is another factor.  The goal of that it is to offload
colder pages from expensive RAM to cheaper storage.  When lower tier
memory is available as an intermediate layer, we want offloading to take
advantage of it instead of bypassing to storage.

Revert the patch so that cgroups respect the LRU order spanning the memory
hierarchy.

Of note is a specific undercommit scenario, where all cgroup limits in the
system add up to <= available toptier memory.  In that case, shuffling
pages out to lower tiers first to reclaim them from there is inefficient. 
This is something could be optimized/short-circuited later on (although
care must be taken not to accidentally recreate the aging inversion). 
Let's ensure correctness first.

Link: https://lkml.kernel.org/r/20220518190911.82400-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~revert-mm-vmscan-never-demote-for-memcg-reclaim
+++ a/mm/vmscan.c
@@ -528,13 +528,8 @@ static bool can_demote(int nid, struct s
 {
 	if (!numa_demotion_enabled)
 		return false;
-	if (sc) {
-		if (sc->no_demotion)
-			return false;
-		/* It is pointless to do demotion in memcg reclaim */
-		if (cgroup_reclaim(sc))
-			return false;
-	}
+	if (sc && sc->no_demotion)
+		return false;
 	if (next_demotion_node(nid) == NUMA_NO_NODE)
 		return false;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


