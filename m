Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7CCC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjDRXez (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjDRXe0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D8A7ABA
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2F7062F18
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4544DC433D2;
        Tue, 18 Apr 2023 23:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860849;
        bh=GGpnVtjXosi4YCTE9wL6dKdTu8mYqNJnyK8wZFJuR8U=;
        h=Date:To:From:Subject:From;
        b=gaAVLEBhwLNfSulwV3vWfwB/ZEMi2JfP+Dm3iTZwgq2BX8UCYtYUcHM00IdYykNLl
         jl3WhHY2AoG/Zm8sRKqm95jSDqoEeWPuyj3vZxxiANMBjVLHVXVi8sKei1/3hmOdRV
         cuEjoe+qbJlUsP2PVhOGbF3VAiElxgFlH6YWz6i0=
Date:   Tue, 18 Apr 2023 16:34:08 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tj@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        mhocko@kernel.org, lizefan.x@bytedance.com, josef@toxicpanda.com,
        hannes@cmpxchg.org, axboe@kernel.dk, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-do-not-modify-rstat-tree-for-zero-updates.patch removed from -mm tree
Message-Id: <20230418233409.4544DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: do not modify rstat tree for zero updates
has been removed from the -mm tree.  Its filename was
     memcg-do-not-modify-rstat-tree-for-zero-updates.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: memcg: do not modify rstat tree for zero updates
Date: Thu, 30 Mar 2023 19:18:01 +0000

In some situations, we may end up calling memcg_rstat_updated() with a
value of 0, which means the stat was not actually updated.  An example is
if we fail to reclaim any pages in shrink_folio_list().

Do not add the cgroup to the rstat updated tree in this case, to avoid
unnecessarily flushing it.

Link: https://lkml.kernel.org/r/20230330191801.1967435-9-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasily Averin <vasily.averin@linux.dev>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memcontrol.c~memcg-do-not-modify-rstat-tree-for-zero-updates
+++ a/mm/memcontrol.c
@@ -619,6 +619,9 @@ static inline void memcg_rstat_updated(s
 {
 	unsigned int x;
 
+	if (!val)
+		return;
+
 	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
 
 	x = __this_cpu_add_return(stats_updates, abs(val));
_

Patches currently in -mm which might be from yosryahmed@google.com are

memcg-page_cgroup_ino-get-memcg-from-the-pages-folio.patch
mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim.patch
mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state.patch
mm-vmscan-refactor-updating-current-reclaim_state.patch

