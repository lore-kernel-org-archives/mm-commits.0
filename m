Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D7DC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjDRXex (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbjDRXeV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470F8A5C6
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA7AB62EE4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB73C433D2;
        Tue, 18 Apr 2023 23:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860848;
        bh=5TYpjypEFWFoxhVsCi6y181J5gbAvtmz4duLVb6V5dU=;
        h=Date:To:From:Subject:From;
        b=12HV/YlnQQjuqFwIrci9JVKbafDUE90wlx/2FWSZck82hccTYFpiYSQSSAyZYX/Jh
         En34zXCoBydWc0lj1caB4m6JbM+mUVFiFsvMOr8g0lPs6tIgMdGiEVMNWh22h1+7pJ
         J3sZIDax/qIG12s60k5PYLYgm3sc5qtL7gc5vMd4=
Date:   Tue, 18 Apr 2023 16:34:07 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tj@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        mhocko@kernel.org, lizefan.x@bytedance.com, josef@toxicpanda.com,
        hannes@cmpxchg.org, axboe@kernel.dk, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmscan-memcg-sleep-when-flushing-stats-during-reclaim.patch removed from -mm tree
Message-Id: <20230418233408.2FB73C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmscan: memcg: sleep when flushing stats during reclaim
has been removed from the -mm tree.  Its filename was
     vmscan-memcg-sleep-when-flushing-stats-during-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: vmscan: memcg: sleep when flushing stats during reclaim
Date: Thu, 30 Mar 2023 19:18:00 +0000

Memory reclaim is a sleepable context.  Flushing is an expensive operaiton
that scales with the number of cpus and the number of cgroups in the
system, so avoid doing it atomically unnecessarily.  This can slow down
reclaim code if flushing stats is taking too long, but there is already
multiple cond_resched()'s in reclaim code.

Link: https://lkml.kernel.org/r/20230330191801.1967435-8-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasily Averin <vasily.averin@linux.dev>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~vmscan-memcg-sleep-when-flushing-stats-during-reclaim
+++ a/mm/vmscan.c
@@ -2861,7 +2861,7 @@ static void prepare_scan_count(pg_data_t
 	 * Flush the memory cgroup stats, so that we read accurate per-memcg
 	 * lruvec stats for heuristics.
 	 */
-	mem_cgroup_flush_stats_atomic();
+	mem_cgroup_flush_stats();
 
 	/*
 	 * Determine the scan balance between anon and file LRUs.
_

Patches currently in -mm which might be from yosryahmed@google.com are

memcg-do-not-modify-rstat-tree-for-zero-updates.patch
memcg-page_cgroup_ino-get-memcg-from-the-pages-folio.patch
mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim.patch
mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state.patch
mm-vmscan-refactor-updating-current-reclaim_state.patch

