Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FE5C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 18 May 2022 19:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241901AbiERTZI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 May 2022 15:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241829AbiERTZH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2022 15:25:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D34193CB
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 12:25:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7297A61909
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 19:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD50C385A5;
        Wed, 18 May 2022 19:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652901905;
        bh=I9UIzVGE8V+WJ79SsbEN0KRiwqI+HXMoXtL5nORudJ4=;
        h=Date:To:From:Subject:From;
        b=Szf/HU/ZJR8iu71sC0pBuWQxwydIeiPWt+a8+apfYxkOCMyZ36GHoDPe14PqqVOp3
         CMVb5vOW1W93UqaCUltz9VZuDcm9Bu+qqjoPxkJM9FUArESW42qpLsKuqgtbgyQgsd
         +ZU0PY48bwWoqh+2UPAvkV5duy+VWRX8L1fzPO94=
Date:   Wed, 18 May 2022 12:25:04 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        yang.shi@linux.alibaba.com, songmuchun@bytedance.com,
        shakeelb@google.com, mhocko@suse.com, guro@fb.com,
        dave.hansen@linux.intel.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-vmscan-never-demote-for-memcg-reclaim.patch added to mm-unstable branch
Message-Id: <20220518192505.BFD50C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm/vmscan: never demote for memcg reclaim"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-mm-vmscan-never-demote-for-memcg-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-vmscan-never-demote-for-memcg-reclaim.patch

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
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Muchun Song <songmuchun@bytedance.com>
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

documentation-filesystems-proc-update-meminfo-section.patch
documentation-filesystems-proc-update-meminfo-section-fix.patch
documentation-filesystems-proc-update-meminfo-section-fix-2.patch
mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix.patch
mm-kconfig-simplify-zswap-configuration.patch
mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
zswap-memcg-accounting.patch
zswap-memcg-accounting-fix.patch
zswap-memcg-accounting-fix-2.patch
revert-mm-vmscan-never-demote-for-memcg-reclaim.patch

