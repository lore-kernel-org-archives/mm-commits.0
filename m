Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EADFC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 22:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345322AbiCWWqd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 18:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345321AbiCWWqc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 18:46:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E916149FA4
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 15:44:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F48061791
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 22:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE581C340E9;
        Wed, 23 Mar 2022 22:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648075496;
        bh=fSoeMS9w9+ESFYMWD63EOl2mArm5SBBQAPCD+IekJ5Y=;
        h=Date:To:From:Subject:From;
        b=nTFOOmvOJe/n3J5OoUqtQGl/YYv4d+xxmMyduz//spSvoZJL+xway7bOtcl9mkb15
         T89m6CjA+vqrQfZUuGEJtguLZbBiX/c/UQ4QkJqdjTU9BMKRqPkKGO8AbbOLyNbs3T
         k3mNbwfbpS+qHA2h2ER4DN/70uLEU/oaXgF0IEe0=
Date:   Wed, 23 Mar 2022 15:44:56 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, bigeasy@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] cgroup-use-irqsave-in-cgroup_rstat_flush_locked-fix.patch removed from -mm tree
Message-Id: <20220323224456.BE581C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: add a comment to cgroup_rstat_flush_locked().
has been removed from the -mm tree.  Its filename was
     cgroup-use-irqsave-in-cgroup_rstat_flush_locked-fix.patch

This patch was dropped because it was folded into cgroup-use-irqsave-in-cgroup_rstat_flush_locked.patch

------------------------------------------------------
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

 kernel/cgroup/rstat.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/cgroup/rstat.c~cgroup-use-irqsave-in-cgroup_rstat_flush_locked-fix
+++ a/kernel/cgroup/rstat.c
@@ -155,6 +155,14 @@ static void cgroup_rstat_flush_locked(st
 		struct cgroup *pos = NULL;
 		unsigned long flags;
 
+		/*
+		 * The _irqsave() is needed because cgroup_rstat_lock is
+		 * spinlock_t which is a sleeping lock on PREEMPT_RT. Acquiring
+		 * this lock with the _irq() suffix only disables interrupts on
+		 * a non-PREEMPT_RT kernel. The raw_spinlock_t below disables
+		 * interrupts on both configurations. The _irqsave() ensures
+		 * that interrupts are always disabled and later restored.
+		 */
 		raw_spin_lock_irqsave(cpu_lock, flags);
 		while ((pos = cgroup_rstat_cpu_pop_updated(pos, cgrp, cpu))) {
 			struct cgroup_subsys_state *css;
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-memcg-disable-threshold-event-handlers-on-preempt_rt.patch
mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed.patch
mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch
mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock.patch
mm-workingset-replace-irq-off-check-with-a-lockdep-assert.patch
cgroup-use-irqsave-in-cgroup_rstat_flush_locked.patch

