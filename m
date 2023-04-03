Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535A9C76188
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 21:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbjDCVY6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 17:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbjDCVY1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 17:24:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E80525E
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 14:23:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1E3B62C2A
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 21:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A86C433EF;
        Mon,  3 Apr 2023 21:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680557006;
        bh=8O/PNpHZRh3RijfN54t1NCrJfavciFaUiGvEhRw6tsQ=;
        h=Date:To:From:Subject:From;
        b=H9hLAfxM0P7d+rB1/rU0vRl4VbPhvgs4RWFkw9UpcG9ay0mmJ7yiP420UxmTZbcqJ
         q07qvgCfgb1Mg+NcQVmVrCHFO1BRBROuT9yfG6u8cfMaa3i/xBtJTB7NeHwsMnhlyq
         z0gUFCr8FIlme6uQt0/4mzRXFJTXRdKOktrrYXYE=
Date:   Mon, 03 Apr 2023 14:23:25 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tj@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        mhocko@kernel.org, lizefan.x@bytedance.com, josef@toxicpanda.com,
        hannes@cmpxchg.org, axboe@kernel.dk, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-memcg-sleep-when-flushing-stats-during-reclaim.patch added to mm-unstable branch
Message-Id: <20230403212326.26A86C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: memcg: sleep when flushing stats during reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     vmscan-memcg-sleep-when-flushing-stats-during-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmscan-memcg-sleep-when-flushing-stats-during-reclaim.patch

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

cgroup-rename-cgroup_rstat_flush_irqsafe-to-atomic.patch
memcg-rename-mem_cgroup_flush_stats_delayed-to-ratelimited.patch
memcg-do-not-flush-stats-in-irq-context.patch
memcg-replace-stats_flush_lock-with-an-atomic.patch
memcg-sleep-during-flushing-stats-in-safe-contexts.patch
workingset-memcg-sleep-when-flushing-stats-in-workingset_refault.patch
vmscan-memcg-sleep-when-flushing-stats-during-reclaim.patch
memcg-do-not-modify-rstat-tree-for-zero-updates.patch

