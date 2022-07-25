Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47388C43334
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 19:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbiGYTRJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 15:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiGYTRJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 15:17:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CA5BF42
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 12:17:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5933560B15
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 19:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA56C341C6;
        Mon, 25 Jul 2022 19:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658776626;
        bh=OYtHzJB8XnGHUpTfmVsr+NCihWN/kIQWibgB/BUu8n8=;
        h=Date:To:From:Subject:From;
        b=v4HcF76g03/fPRwCq/sbvDDIbkh4As6Te8RkpTHrfvjML+zsD6u6zH8Ir1WAuuruX
         eS2BkyQRzYW/pDKgfliKMxcSvuym0TljW+/U7qWqHih7ZZ56S/zn6UdgH+zMcJa1L4
         nA/Y38p6nd9keKTfnpOW1J/z3TsAZiLtJD8HmCZ4=
Date:   Mon, 25 Jul 2022 12:17:05 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        tim.c.chen@linux.intel.com, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, amadeuszx.slawinski@linux.intel.com,
        jiebin.sun@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-redundant-updating-of-stats_flush_threshold.patch added to mm-unstable branch
Message-Id: <20220725191706.9CA56C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: remove the redundant updating of stats_flush_threshold
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-redundant-updating-of-stats_flush_threshold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-redundant-updating-of-stats_flush_threshold.patch

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
From: Jiebin Sun <jiebin.sun@intel.com>
Subject: mm/memcontrol.c: remove the redundant updating of stats_flush_threshold
Date: Sat, 23 Jul 2022 00:49:49 +0800

Remove the redundant updating of stats_flush_threshold.  If the global var
stats_flush_threshold has exceeded the trigger value for
__mem_cgroup_flush_stats, further increment is unnecessary.

Apply the patch and test the pts/hackbench-1.0.0 Count:4 (160 threads).

Score gain: 1.95x
Reduce CPU cycles in __mod_memcg_lruvec_state (44.88% -> 0.12%)

CPU: ICX 8380 x 2 sockets
Core number: 40 x 2 physical cores
Benchmark: pts/hackbench-1.0.0 Count:4 (160 threads)

Link: https://lkml.kernel.org/r/20220722164949.47760-1-jiebin.sun@intel.com
Signed-off-by: Jiebin Sun <jiebin.sun@intel.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Amadeusz Sawiski <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-remove-the-redundant-updating-of-stats_flush_threshold
+++ a/mm/memcontrol.c
@@ -626,7 +626,14 @@ static inline void memcg_rstat_updated(s
 
 	x = __this_cpu_add_return(stats_updates, abs(val));
 	if (x > MEMCG_CHARGE_BATCH) {
-		atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
+		/*
+		 * If stats_flush_threshold exceeds the threshold
+		 * (>num_online_cpus()), cgroup stats update will be triggered
+		 * in __mem_cgroup_flush_stats(). Increasing this var further
+		 * is redundant and simply adds overhead in atomic update.
+		 */
+		if (atomic_read(&stats_flush_threshold) <= num_online_cpus())
+			atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
 		__this_cpu_write(stats_updates, 0);
 	}
 }
_

Patches currently in -mm which might be from jiebin.sun@intel.com are

mm-remove-the-redundant-updating-of-stats_flush_threshold.patch

