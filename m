Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A79C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Feb 2022 23:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238035AbiBYX4r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 18:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiBYX4r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 18:56:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1961A2118D6
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 15:56:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6189661D51
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 23:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA46BC340E7;
        Fri, 25 Feb 2022 23:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645833372;
        bh=NG2pM+z9ZIN4VK8eBEHbyUuW3+9eA/A0/RlpLoVbTjc=;
        h=Date:To:From:Subject:From;
        b=bb+pm5NoEskOxoiVaP+UVmOgrw2wPkfdBNqNI53O8esGnwJ9s7JAk8Ga7IhPf4BQZ
         Lz5QBAWuEyiQwht5nOr38rN1FiFjidVohouL1UkxHV/nOa/ejToGgWgVr1cSMe3LEj
         Q3zhkVutUnjHdjzXocB6PnIHPdrPvGBWmHvZHqDI=
Date:   Fri, 25 Feb 2022 15:56:12 -0800
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        tglx@linutronix.de, shakeelb@google.com, peterz@infradead.org,
        oliver.sang@intel.com, mkoutny@suse.com, mhocko@suse.com,
        longman@redhat.com, hannes@cmpxchg.org, guro@fb.com,
        bigeasy@linutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock.patch added to -mm tree
Message-Id: <20220225235612.BA46BC340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: disable migration instead of preemption in drain_all_stock()
has been added to the -mm tree.  Its filename is
     mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/memcg: disable migration instead of preemption in drain_all_stock()

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
to a sleeping lock can be acquired.

A race with CPU hotplug is not a problem because pcp data is not going
away.  In the worst case we just schedule draining of an empty stock.

Use migrate_disable() instead of get_cpu() around the
for_each_online_cpu() loop.

Link: https://lkml.kernel.org/r/Yhk4UzA++ucRDwNk@linutronix.de
Link: https://lkml.kernel.org/r/20220221182540.380526-7-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
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
@@ -2293,7 +2293,8 @@ static void drain_all_stock(struct mem_c
 	 * as well as workers from this path always operate on the local
 	 * per-cpu data. CPU up doesn't touch memcg_stock at all.
 	 */
-	curcpu = get_cpu();
+	migrate_disable();
+	curcpu = smp_processor_id();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *memcg;
@@ -2316,7 +2317,7 @@ static void drain_all_stock(struct mem_c
 				schedule_work_on(cpu, &stock->work);
 		}
 	}
-	put_cpu();
+	migrate_enable();
 	mutex_unlock(&percpu_charge_mutex);
 }
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-memcg-disable-threshold-event-handlers-on-preempt_rt.patch
mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed.patch
mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch
mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock.patch

