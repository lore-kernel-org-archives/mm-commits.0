Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDCCC77B78
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 21:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjEBVPJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 17:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjEBVPH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 17:15:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE141701
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 14:14:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0397B628E2
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 21:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C23C433D2;
        Tue,  2 May 2023 21:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683062098;
        bh=r7rQ/r2CgWoM4zpJ8LrEYM+aH9TJOGoj61Mns5jNpYc=;
        h=Date:To:From:Subject:From;
        b=QqqDI8VBe3qz7egUcWQT0kb5EaYysP7ZZZl2akrY7zxB6EPjQqByQQSdzKNTNIcIW
         0MOjINIH9iWBTdIdzqCVcaWxiPyaSwShtsEPNJ8cToh7Fc3vNGMRpfPm2UYIrltCty
         32cN5YLyuuElwuhx7M63E1w/5QgolmXkFWM3TepY=
Date:   Tue, 02 May 2023 14:14:57 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        jack@suse.cz, hannes@cmpxchg.org, brauner@kernel.org,
        axboe@kernel.dk, yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-calculate-root-usage-from-global-state.patch added to mm-unstable branch
Message-Id: <20230502211458.55C23C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: calculate root usage from global state
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-calculate-root-usage-from-global-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-calculate-root-usage-from-global-state.patch

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

memcg-use-seq_buf_do_printk-with-mem_cgroup_print_oom_meminfo.patch
memcg-dump-memorystat-during-cgroup-oom-for-v1.patch
writeback-move-wb_over_bg_thresh-call-outside-lock-section.patch
memcg-flush-stats-non-atomically-in-mem_cgroup_wb_stats.patch
memcg-calculate-root-usage-from-global-state.patch
memcg-remove-mem_cgroup_flush_stats_atomic.patch
cgroup-remove-cgroup_rstat_flush_atomic.patch

