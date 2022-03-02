Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17196C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 22:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242058AbiCBWCh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Mar 2022 17:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239438AbiCBWCg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2022 17:02:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEE9CD5E1
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 14:01:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12492B82232
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 22:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC067C004E1;
        Wed,  2 Mar 2022 22:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646258509;
        bh=G6obKniPgeqYG6BOuN+96ILD4KZRUqTcMa3jNhbDk2Q=;
        h=Date:To:From:Subject:From;
        b=TCbc9mn0spDuMnDClPfpuZkFUZvJhIRaFU9yYsfuibrM+IAQB4ryAVQRaDwKPsrZ+
         PN6ldIB0f0qXPvUoGajccI7XzomUVQ3rPrRjMnlapCpC8t67ScICD2/Y6zV62pIBYD
         5K0MZEvWSqQ/E/zurQ28Eo8HZe5QjoyYdcF7vWLE=
Date:   Wed, 02 Mar 2022 14:01:49 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, bigeasy@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-use-irqsave-in-cgroup_rstat_flush_locked-fix.patch added to -mm tree
Message-Id: <20220302220149.BC067C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: add a comment to cgroup_rstat_flush_locked().
has been added to the -mm tree.  Its filename is
     cgroup-use-irqsave-in-cgroup_rstat_flush_locked-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/cgroup-use-irqsave-in-cgroup_rstat_flush_locked-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/cgroup-use-irqsave-in-cgroup_rstat_flush_locked-fix.patch

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
cgroup-use-irqsave-in-cgroup_rstat_flush_locked-fix.patch

