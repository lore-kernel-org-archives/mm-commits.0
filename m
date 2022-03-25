Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B584C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357361AbiCYBcW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352982AbiCYBcC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B6A3DA66
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5458B81DEA
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEA1C340EC;
        Fri, 25 Mar 2022 01:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171826;
        bh=CKz6hXjLkP74I9EYNEOIZaNyb5zEmnXDCa386XSqKo4=;
        h=Date:To:From:Subject:From;
        b=f7BWWXza5lpNhXeU+MS1O/fd4dvZWZ/z/ysUSO9wtbOKPtlizy3DEbT+0KoQ1/agc
         coC0sxiJrYVW5qF28mAxCPWzSF7Jh0PtcPzfjGhKxLH5RhX+fN9nkeoNPcTxkc3PXD
         +RtYwspcHIrJoZXeiJ1v+aw7lQkC3GKP3Gi8fuKk=
Date:   Thu, 24 Mar 2022 18:30:25 -0700
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        tglx@linutronix.de, shakeelb@google.com, roman.gushchin@linux.dev,
        peterz@infradead.org, oliver.sang@intel.com, mkoutny@suse.com,
        mhocko@suse.com, mhocko@kernel.org, longman@redhat.com,
        hannes@cmpxchg.org, bigeasy@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock.patch removed from -mm tree
Message-Id: <20220325013026.8BEA1C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: disable migration instead of preemption in drain_all_stock().
has been removed from the -mm tree.  Its filename was
     mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/memcg: disable migration instead of preemption in drain_all_stock().

Before the for-each-CPU loop, preemption is disabled so that so that
drain_local_stock() can be invoked directly instead of scheduling a
worker.  Ensuring that drain_local_stock() completed on the local CPU is
not correctness problem.  It _could_ be that the charging path will be
forced to reclaim memory because cached charges are still waiting for
their draining.

Disabling preemption before invoking drain_local_stock() is problematic on
PREEMPT_RT due to the sleeping locks involved.  To ensure that no CPU
migrations happens across for_each_online_cpu() it is enouhg to use
migrate_disable() which disables migration and keeps context preemptible
to a sleeping lock can be acquired.  A race with CPU hotplug is not a
problem because pcp data is not going away.  In the worst case we just
schedule draining of an empty stock.

Use migrate_disable() instead of get_cpu() around the
for_each_online_cpu() loop.

Link: https://lkml.kernel.org/r/20220226204144.1008339-7-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock
+++ a/mm/memcontrol.c
@@ -2300,7 +2300,8 @@ static void drain_all_stock(struct mem_c
 	 * as well as workers from this path always operate on the local
 	 * per-cpu data. CPU up doesn't touch memcg_stock at all.
 	 */
-	curcpu = get_cpu();
+	migrate_disable();
+	curcpu = smp_processor_id();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *memcg;
@@ -2323,7 +2324,7 @@ static void drain_all_stock(struct mem_c
 				schedule_work_on(cpu, &stock->work);
 		}
 	}
-	put_cpu();
+	migrate_enable();
 	mutex_unlock(&percpu_charge_mutex);
 }
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


