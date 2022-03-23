Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F428C4321E
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345399AbiCWXIL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345494AbiCWXIC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:08:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2FA9027D
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33232617E8
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C004C340E8;
        Wed, 23 Mar 2022 23:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076790;
        bh=mF7cqnLLCton8JUDogwJIiL0I5aHocH5B/iOBqPbVuA=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=1m8W4SCBPBK7xtMlnBo+CwOHJey2ms9ynUyWoE/wdE6bY3RxGFGWeAusqMEwFyia+
         4xzjVIqG8FGlCD6POMR3zMgvcXLoQ0jPPIiC4MEHVC8NDiJ51sNTEVmP31Kt7rxcR8
         3BZseB19aldfxSY4noV9ve6TBXPAQr6DWDhN9ue0=
Date:   Wed, 23 Mar 2022 16:06:29 -0700
To:     tj@kernel.org, tglx@linutronix.de, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, bigeasy@linutronix.de,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 24/41] cgroup: use irqsave in cgroup_rstat_flush_locked().
Message-Id: <20220323230630.8C004C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: cgroup: use irqsave in cgroup_rstat_flush_locked().

All callers of cgroup_rstat_flush_locked() acquire cgroup_rstat_lock
either with spin_lock_irq() or spin_lock_irqsave(). 
cgroup_rstat_flush_locked() itself acquires cgroup_rstat_cpu_lock which is
a raw_spin_lock.  This lock is also acquired in cgroup_rstat_updated() in
IRQ context and therefore requires _irqsave() locking suffix in
cgroup_rstat_flush_locked().

Since there is no difference between spin_lock_t and raw_spin_lock_t on
!RT lockdep does not complain here.  On RT lockdep complains because the
interrupts were not disabled here and a deadlock is possible.

Acquire the raw_spin_lock_t with disabled interrupts.

Link: https://lkml.kernel.org/r/20220301122143.1521823-2-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zefan Li <lizefan.x@bytedance.com>
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: cgroup: add a comment to cgroup_rstat_flush_locked().

Add a comment why spin_lock_irq() -> raw_spin_lock_irqsave() is needed.

Link: https://lkml.kernel.org/r/Yh+DOK73hfVV5ThX@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/rstat.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/kernel/cgroup/rstat.c~cgroup-use-irqsave-in-cgroup_rstat_flush_locked
+++ a/kernel/cgroup/rstat.c
@@ -153,8 +153,17 @@ static void cgroup_rstat_flush_locked(st
 		raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock,
 						       cpu);
 		struct cgroup *pos = NULL;
+		unsigned long flags;
 
-		raw_spin_lock(cpu_lock);
+		/*
+		 * The _irqsave() is needed because cgroup_rstat_lock is
+		 * spinlock_t which is a sleeping lock on PREEMPT_RT. Acquiring
+		 * this lock with the _irq() suffix only disables interrupts on
+		 * a non-PREEMPT_RT kernel. The raw_spinlock_t below disables
+		 * interrupts on both configurations. The _irqsave() ensures
+		 * that interrupts are always disabled and later restored.
+		 */
+		raw_spin_lock_irqsave(cpu_lock, flags);
 		while ((pos = cgroup_rstat_cpu_pop_updated(pos, cgrp, cpu))) {
 			struct cgroup_subsys_state *css;
 
@@ -166,7 +175,7 @@ static void cgroup_rstat_flush_locked(st
 				css->ss->css_rstat_flush(css, cpu);
 			rcu_read_unlock();
 		}
-		raw_spin_unlock(cpu_lock);
+		raw_spin_unlock_irqrestore(cpu_lock, flags);
 
 		/* if @may_sleep, play nice and yield if necessary */
 		if (may_sleep && (need_resched() ||
_
