Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D65EC19F2C
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbiG3BJQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239710AbiG3BIz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE36C8735C
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6C31B82929
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B87C433C1;
        Sat, 30 Jul 2022 01:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143317;
        bh=rxVeu9u6JmRcDIUQuGCxozBX2eiJqO31BPLirjEEOF0=;
        h=Date:To:From:Subject:From;
        b=fuTCU54//xnV8Q+L38jPqa6XaMliG86BRpTIpqO0hVO00Z6uT3ylyB2prp9mHMvGK
         P6DCm9hMAt26JdeAXnLs+HNvNqJOkaAFs3tDsxsS+ulpaoBQNoM0zsHIFLVzqN48o6
         ZimRahnjyoPimhbqz1LQIKHADFgQ3/h+mJ7gi1Zw=
Date:   Fri, 29 Jul 2022 18:08:36 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        tim.c.chen@linux.intel.com, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, amadeuszx.slawinski@linux.intel.com,
        jiebin.sun@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-the-redundant-updating-of-stats_flush_threshold.patch removed from -mm tree
Message-Id: <20220730010837.65B87C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcontrol.c: remove the redundant updating of stats_flush_threshold
has been removed from the -mm tree.  Its filename was
     mm-remove-the-redundant-updating-of-stats_flush_threshold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


