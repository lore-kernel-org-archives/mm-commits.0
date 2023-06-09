Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6DA0C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbjFIX1Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbjFIX1B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29BE3584
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50D2465C3D
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A419DC433EF;
        Fri,  9 Jun 2023 23:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353218;
        bh=kSDRPWHELE/IzfKJ6irLd/AeCDr+BHHQZrFmwJR3Qwk=;
        h=Date:To:From:Subject:From;
        b=X9xJdAqC79pHPVusXiabmqELxb0pnawUtcTjsk9XuKYWlF442l7ENwUDKkOzRxikz
         yGBPl7ND+c/VCTP0tMk8iGzFdPlhsy2pjYe/KOTze/9Xscmtb8uz3SvyBb3r7aDMU6
         fxydz2XtLJ0ch6nAUwc4Y8PrGsaVTa8r5r/r0e9c=
Date:   Fri, 09 Jun 2023 16:26:58 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        jack@suse.cz, hannes@cmpxchg.org, brauner@kernel.org,
        axboe@kernel.dk, yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-calculate-root-usage-from-global-state.patch removed from -mm tree
Message-Id: <20230609232658.A419DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: calculate root usage from global state
has been removed from the -mm tree.  Its filename was
     memcg-calculate-root-usage-from-global-state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: memcg: calculate root usage from global state
Date: Fri, 21 Apr 2023 17:40:18 +0000

Currently, we approximate the root usage by adding the memcg stats for
anon, file, and conditionally swap (for memsw).  To read the memcg stats
we need to invoke an rstat flush.  rstat flushes can be expensive, they
scale with the number of cpus and cgroups on the system.

mem_cgroup_usage() is called by memcg_events()->mem_cgroup_threshold()
with irqs disabled, so such an expensive operation with irqs disabled can
cause problems.

Instead, approximate the root usage from global state.  This is not 100%
accurate, but the root usage has always been ill-defined anyway.

Link: https://lkml.kernel.org/r/20230421174020.2994750-4-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

--- a/mm/memcontrol.c~memcg-calculate-root-usage-from-global-state
+++ a/mm/memcontrol.c
@@ -3710,27 +3710,13 @@ static unsigned long mem_cgroup_usage(st
 
 	if (mem_cgroup_is_root(memcg)) {
 		/*
-		 * We can reach here from irq context through:
-		 * uncharge_batch()
-		 * |--memcg_check_events()
-		 *    |--mem_cgroup_threshold()
-		 *       |--__mem_cgroup_threshold()
-		 *          |--mem_cgroup_usage
-		 *
-		 * rstat flushing is an expensive operation that should not be
-		 * done from irq context; use stale stats in this case.
-		 * Arguably, usage threshold events are not reliable on the root
-		 * memcg anyway since its usage is ill-defined.
-		 *
-		 * Additionally, other call paths through memcg_check_events()
-		 * disable irqs, so make sure we are flushing stats atomically.
+		 * Approximate root's usage from global state. This isn't
+		 * perfect, but the root usage was always an approximation.
 		 */
-		if (in_task())
-			mem_cgroup_flush_stats_atomic();
-		val = memcg_page_state(memcg, NR_FILE_PAGES) +
-			memcg_page_state(memcg, NR_ANON_MAPPED);
+		val = global_node_page_state(NR_FILE_PAGES) +
+			global_node_page_state(NR_ANON_MAPPED);
 		if (swap)
-			val += memcg_page_state(memcg, MEMCG_SWAP);
+			val += total_swap_pages - get_nr_swap_pages();
 	} else {
 		if (!swap)
 			val = page_counter_read(&memcg->memory);
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-support-exclusive-loads.patch

