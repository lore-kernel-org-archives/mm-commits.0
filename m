Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F27EDC48BE4
	for <mm-commits@archiver.kernel.org>; Thu, 25 Aug 2022 00:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiHYAeG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 20:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiHYAeF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 20:34:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7AB8E45C
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 17:34:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B94461A7E
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 00:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC412C433D6;
        Thu, 25 Aug 2022 00:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661387642;
        bh=uED8i/rV/Rvqa0hSvb05uWdKJpQb2aQJS0EaiZvKpuc=;
        h=Date:To:From:Subject:From;
        b=sT3jjK93rP9T3C6QT1+gPuncz9LaLRWSNsBzawiuwkA7Y7CVYsSoKNysnm57i7yCB
         vW8W4xM+CSjYwmR3/KqDhkNTo9yN0YI3JqFwlUUjCdgJ5UWR1Yl1esaB+fBIRbTPM8
         y8DSQQZJtqweQzXbnqiIPd46Js5bYitl9coe6kDc=
Date:   Wed, 24 Aug 2022 17:34:01 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        soheil@google.com, roman.gushchin@linux.dev, oliver.sang@intel.com,
        mkoutny@suse.com, mhocko@kernel.org, hannes@cmpxchg.org,
        feng.tang@intel.com, edumazet@google.com, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-increase-memcg_charge_batch-to-64.patch added to mm-unstable branch
Message-Id: <20220825003402.AC412C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: increase MEMCG_CHARGE_BATCH to 64
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-increase-memcg_charge_batch-to-64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-increase-memcg_charge_batch-to-64.patch

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
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: increase MEMCG_CHARGE_BATCH to 64
Date: Thu, 25 Aug 2022 00:05:06 +0000

For several years, MEMCG_CHARGE_BATCH was kept at 32 but with bigger
machines and the network intensive workloads requiring througput in Gbps,
32 is too small and makes the memcg charging path a bottleneck.  For now,
increase it to 64 for easy acceptance to 6.0.  We will need to revisit
this in future for ever increasing demand of higher performance.

Please note that the memcg charge path drain the per-cpu memcg charge
stock, so there should not be any oom behavior change.  Though it does
have impact on rstat flushing and high limit reclaim backoff.

To evaluate the impact of this optimization, on a 72 CPUs machine, we
ran the following workload in a three level of cgroup hierarchy.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
Without (6.0-rc1)       10482.7 Mbps
With patch              17064.7 Mbps (62.7% improvement)

With the patch, the throughput improved by 62.7%.

Link: https://lkml.kernel.org/r/20220825000506.239406-4-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~memcg-increase-memcg_charge_batch-to-64
+++ a/include/linux/memcontrol.h
@@ -359,10 +359,11 @@ struct mem_cgroup {
 };
 
 /*
- * size of first charge trial. "32" comes from vmscan.c's magic value.
- * TODO: maybe necessary to use big numbers in big irons.
+ * size of first charge trial.
+ * TODO: maybe necessary to use big numbers in big irons or dynamic based of the
+ * workload.
  */
-#define MEMCG_CHARGE_BATCH 32U
+#define MEMCG_CHARGE_BATCH 64U
 
 extern struct mem_cgroup *root_mem_cgroup;
 
_

Patches currently in -mm which might be from shakeelb@google.com are

revert-memcg-cleanup-racy-sum-avoidance-code.patch
mm-page_counter-remove-unneeded-atomic-ops-for-low-min.patch
mm-page_counter-rearrange-struct-page_counter-fields.patch
memcg-increase-memcg_charge_batch-to-64.patch

