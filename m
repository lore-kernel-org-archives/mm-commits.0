Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B15DC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 18:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiLPSEs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 13:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiLPSEr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 13:04:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A17069A8F
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 10:04:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF123621B8
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 18:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4AFC433D2;
        Fri, 16 Dec 2022 18:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671213885;
        bh=2NOMTGXmMTIJ4ukAUzGXrOYdieHEgKBdnmx6mOsPxks=;
        h=Date:To:From:Subject:From;
        b=NjmSS72XSn80NVsLp2ZmBj021UMXJTtodwceipBRdZMiWWzweIpjB/8h75xGk5L0Q
         NeOZa2vb2L3ClNyrwbZvp0BBK1mVUn/zYsrzu//b5BEZkF8LzrpOodUFeiV+MgESqv
         8P9ee3CnIXmR8Y2OoD6USAJTxJ4lIk0l5qfgznpc=
Date:   Fri, 16 Dec 2022 10:04:44 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        jiebin.sun@intel.com, alexander.sverdlin@siemens.com,
        1vier1@web.de, manfred@colorfullife.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-percpu_counter-percpu_counter_add_batch-overflow-underflow.patch added to mm-nonmm-unstable branch
Message-Id: <20221216180445.4C4AFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/percpu_counter: percpu_counter_add_batch() overflow/underflow
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-percpu_counter-percpu_counter_add_batch-overflow-underflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-percpu_counter-percpu_counter_add_batch-overflow-underflow.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Manfred Spraul <manfred@colorfullife.com>
Subject: lib/percpu_counter: percpu_counter_add_batch() overflow/underflow
Date: Fri, 16 Dec 2022 16:04:39 +0100

Patch series "various irq handling fixes/docu updates".

If an interrupt happens between __this_cpu_read(*fbc->counters) and
this_cpu_add(*fbc->counters, amount), and that interrupt modifies the
per_cpu_counter, then the this_cpu_add() after the interrupt returns may
under/overflow.

Link: https://lkml.kernel.org/r/20221216150155.200389-1-manfred@colorfullife.com
Link: https://lkml.kernel.org/r/20221216150441.200533-1-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: "Sun, Jiebin" <jiebin.sun@intel.com>
Cc: <1vier1@web.de>
Cc: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/lib/percpu_counter.c~lib-percpu_counter-percpu_counter_add_batch-overflow-underflow
+++ a/lib/percpu_counter.c
@@ -73,28 +73,33 @@ void percpu_counter_set(struct percpu_co
 EXPORT_SYMBOL(percpu_counter_set);
 
 /*
- * This function is both preempt and irq safe. The former is due to explicit
- * preemption disable. The latter is guaranteed by the fact that the slow path
- * is explicitly protected by an irq-safe spinlock whereas the fast patch uses
- * this_cpu_add which is irq-safe by definition. Hence there is no need muck
- * with irq state before calling this one
+ * local_irq_save() is needed to make the function irq safe:
+ * - The slow path would be ok as protected by an irq-safe spinlock.
+ * - this_cpu_add would be ok as it is irq-safe by definition.
+ * But:
+ * The decision slow path/fast path and the actual update must be atomic, too.
+ * Otherwise a call in process context could check the current values and
+ * decide that the fast path can be used. If now an interrupt occurs before
+ * the this_cpu_add(), and the interrupt updates this_cpu(*fbc->counters),
+ * then the this_cpu_add() that is executed after the interrupt has completed
+ * can produce values larger than "batch" or even overflows.
  */
 void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;
+	unsigned long flags;
 
-	preempt_disable();
+	local_irq_save(flags);
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (abs(count) >= batch) {
-		unsigned long flags;
-		raw_spin_lock_irqsave(&fbc->lock, flags);
+		raw_spin_lock(&fbc->lock);
 		fbc->count += count;
 		__this_cpu_sub(*fbc->counters, count - amount);
-		raw_spin_unlock_irqrestore(&fbc->lock, flags);
+		raw_spin_unlock(&fbc->lock);
 	} else {
 		this_cpu_add(*fbc->counters, amount);
 	}
-	preempt_enable();
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(percpu_counter_add_batch);
 
_

Patches currently in -mm which might be from manfred@colorfullife.com are

lib-percpu_counter-percpu_counter_add_batch-overflow-underflow.patch
include-linux-percpu_counterh-race-in-uniprocessor-percpu_counter_add.patch
kernel-irq-managec-disable_irq-might-sleep.patch

