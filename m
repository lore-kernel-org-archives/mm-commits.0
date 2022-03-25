Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68A7C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357374AbiCYBfB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357379AbiCYBdr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D367BD8AE
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E1F2B81DEA
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEF4C340EC;
        Fri, 25 Mar 2022 01:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171931;
        bh=G0kv/HuJpSnGDfn0oFyQUY3icTnzjw2z8efY9oZmiuI=;
        h=Date:To:From:Subject:From;
        b=al6eBsCPFskvaoqcBZV12/Uc90KhDf6i3d9H9jvkdxTkMlx/s4IVdJpLPZo1i8y1D
         LjnEvSrI0OhU0yK6YfIuNXUs7PFFaeWnyGoK+GUJ0ImnIhPyA/0JTU4CstItobOcIn
         RU/baXhIVRGrG9V7FcnFJfH/oG8NS3rIGhXArYEM=
Date:   Thu, 24 Mar 2022 18:32:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tglx@linutronix.de, paulmck@kernel.org, nsaenzju@redhat.com,
        minchan@kernel.org, mgorman@techsingularity.net,
        juri.lelli@redhat.com, bigeasy@linutronix.de, mtosatti@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-lru_cache_disable-replace-work-queue-synchronization-with-synchronize_rcu.patch removed from -mm tree
Message-Id: <20220325013211.9FEF4C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: lru_cache_disable: replace work queue synchronization with synchronize_rcu
has been removed from the -mm tree.  Its filename was
     mm-lru_cache_disable-replace-work-queue-synchronization-with-synchronize_rcu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: mm: lru_cache_disable: replace work queue synchronization with synchronize_rcu

On systems that run FIFO:1 applications that busy loop, any SCHED_OTHER
task that attempts to execute on such a CPU (such as work threads) will
not be scheduled, which leads to system hangs.

Commit d479960e44f27e0e5 ("mm: disable LRU pagevec during the migration
temporarily") relies on queueing work items on all online CPUs to ensure
visibility of lru_disable_count.

To fix this, replace the usage of work items with synchronize_rcu,
which provides the same guarantees.

Readers of lru_disable_count are protected by either disabling
preemption or rcu_read_lock:

preempt_disable, local_irq_disable  [bh_lru_lock()]
rcu_read_lock                       [rt_spin_lock CONFIG_PREEMPT_RT]
preempt_disable                     [local_lock !CONFIG_PREEMPT_RT]

Since v5.1 kernel, synchronize_rcu() is guaranteed to wait on
preempt_disable() regions of code.  So any CPU which sees
lru_disable_count = 0 will have exited the critical section when
synchronize_rcu() returns.

Link: https://lkml.kernel.org/r/Yin7hDxdt0s/x+fp@fuller.cnet
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Reviewed-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/mm/swap.c~mm-lru_cache_disable-replace-work-queue-synchronization-with-synchronize_rcu
+++ a/mm/swap.c
@@ -831,8 +831,7 @@ inline void __lru_add_drain_all(bool for
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
 
-		if (force_all_cpus ||
-		    pagevec_count(&per_cpu(lru_pvecs.lru_add, cpu)) ||
+		if (pagevec_count(&per_cpu(lru_pvecs.lru_add, cpu)) ||
 		    data_race(pagevec_count(&per_cpu(lru_rotate.pvec, cpu))) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate_file, cpu)) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate, cpu)) ||
@@ -876,15 +875,21 @@ atomic_t lru_disable_count = ATOMIC_INIT
 void lru_cache_disable(void)
 {
 	atomic_inc(&lru_disable_count);
-#ifdef CONFIG_SMP
 	/*
-	 * lru_add_drain_all in the force mode will schedule draining on
-	 * all online CPUs so any calls of lru_cache_disabled wrapped by
-	 * local_lock or preemption disabled would be ordered by that.
-	 * The atomic operation doesn't need to have stronger ordering
-	 * requirements because that is enforced by the scheduling
-	 * guarantees.
+	 * Readers of lru_disable_count are protected by either disabling
+	 * preemption or rcu_read_lock:
+	 *
+	 * preempt_disable, local_irq_disable  [bh_lru_lock()]
+	 * rcu_read_lock		       [rt_spin_lock CONFIG_PREEMPT_RT]
+	 * preempt_disable		       [local_lock !CONFIG_PREEMPT_RT]
+	 *
+	 * Since v5.1 kernel, synchronize_rcu() is guaranteed to wait on
+	 * preempt_disable() regions of code. So any CPU which sees
+	 * lru_disable_count = 0 will have exited the critical
+	 * section when synchronize_rcu() returns.
 	 */
+	synchronize_rcu();
+#ifdef CONFIG_SMP
 	__lru_add_drain_all(true);
 #else
 	lru_add_and_bh_lrus_drain();
_

Patches currently in -mm which might be from mtosatti@redhat.com are


