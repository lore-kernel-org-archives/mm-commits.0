Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C66C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 20:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240994AbiC1UWW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 16:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344468AbiC1UWV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 16:22:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507C4427EF
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 13:20:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2BF661488
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 20:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43581C340ED;
        Mon, 28 Mar 2022 20:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648498833;
        bh=ivk9csgNuLxGhmpwR4H+pm0t0lJhScKjSOJQy3F5BBY=;
        h=Date:To:From:Subject:From;
        b=fz8K9YxEFPuhvRuSkjL5+s0oqw2LHOUaX1B+Gu7yGuwFWuIT6farhQZqwmUx5lvs3
         YanS0F2eoTo7jVrzPEmZLW8hb1iSrA3Kwwq9WcXqHIUFXmNYlwdo7prqISxC9WnT0V
         mAAWpRbPejo4vA7VX3a4pVr1DUuHf8d+7sFvjTKY=
Date:   Mon, 28 Mar 2022 13:20:32 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        mhocko@suse.com, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-remove-unneeded-nr_scanned.patch added to -mm tree
Message-Id: <20220328202033.43581C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: remove unneeded nr_scanned
has been added to the -mm tree.  Its filename is
     mm-memcg-remove-unneeded-nr_scanned.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-remove-unneeded-nr_scanned.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-remove-unneeded-nr_scanned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memcg: remove unneeded nr_scanned

The local variable nr_scanned is unneeded as mem_cgroup_soft_reclaim
always does *total_scanned += nr_scanned.  So we can pass total_scanned
directly to the mem_cgroup_soft_reclaim to simplify the code and save some
cpu cycles of adding nr_scanned to total_scanned.

Link: https://lkml.kernel.org/r/20220328114144.53389-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-remove-unneeded-nr_scanned
+++ a/mm/memcontrol.c
@@ -3387,7 +3387,6 @@ unsigned long mem_cgroup_soft_limit_recl
 	int loop = 0;
 	struct mem_cgroup_tree_per_node *mctz;
 	unsigned long excess;
-	unsigned long nr_scanned;
 
 	if (order > 0)
 		return 0;
@@ -3415,11 +3414,9 @@ unsigned long mem_cgroup_soft_limit_recl
 		if (!mz)
 			break;
 
-		nr_scanned = 0;
 		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, pgdat,
-						    gfp_mask, &nr_scanned);
+						    gfp_mask, total_scanned);
 		nr_reclaimed += reclaimed;
-		*total_scanned += nr_scanned;
 		spin_lock_irq(&mctz->lock);
 		__mem_cgroup_remove_exceeded(mz, mctz);
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memcg-remove-unneeded-nr_scanned.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mlock-fix-two-bugs-in-user_shm_lock.patch
mm-compaction-use-helper-isolation_suitable.patch

