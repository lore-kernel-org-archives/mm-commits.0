Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596DEECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiILDdo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiILDcD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5690B192B6
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 193B7B8085E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C0FC433D7;
        Mon, 12 Sep 2022 03:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953393;
        bh=5PXdVq/nsqIZwobKzVhU8dGFspxZE23LEr/+Tvqe1UM=;
        h=Date:To:From:Subject:From;
        b=UEUCsFvfbrQXoENyvWg2T6bu0Gb2PXHcYb/tL7dvP/UhdKCjpSRSUu2l1YAGil9xc
         8DYtP7nUw3WjolzGCOq5Ovs9Of12Q9A1BxlvQOBlNnfuk0OxCKnrrje5m9cqaP2SPa
         wfK8Jl+NmDeOpr1IQpteLTY5qKjXZWfohta3MQuE=
Date:   Sun, 11 Sep 2022 20:29:53 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        soheil@google.com, roman.gushchin@linux.dev, oliver.sang@intel.com,
        mkoutny@suse.com, mhocko@suse.com, hannes@cmpxchg.org,
        feng.tang@intel.com, edumazet@google.com, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-increase-memcg_charge_batch-to-64.patch removed from -mm tree
Message-Id: <20220912032953.B3C0FC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: increase MEMCG_CHARGE_BATCH to 64
has been removed from the -mm tree.  Its filename was
     memcg-increase-memcg_charge_batch-to-64.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~memcg-increase-memcg_charge_batch-to-64
+++ a/include/linux/memcontrol.h
@@ -354,10 +354,11 @@ struct mem_cgroup {
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

mm-deduplicate-cacheline-padding-code.patch
memcg-extract-memcg_vmstats-from-struct-mem_cgroup.patch
memcg-rearrange-code.patch
memcg-reduce-size-of-memcg-vmstats-structures.patch

