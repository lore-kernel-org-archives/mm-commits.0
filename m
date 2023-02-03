Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D65AC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjBCGu4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjBCGux (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:50:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61716193FD
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:50:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CC2BB82986
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D52C433EF;
        Fri,  3 Feb 2023 06:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407049;
        bh=T4yicMS6HX0KEMV7OYaRDP6Irl5Kl5RGZbq+9Nj/YCE=;
        h=Date:To:From:Subject:From;
        b=DDdDANAIUb3+cEmuav5ea06MEyvFSVdXa/agRmE8v0bkcyfWFhwObwrH5gNHhPjrN
         tLTKxhngW9pCk3pocOEXSxFd6SEdsw0jarh02r+MzXHZR/zoLbKgg8yfo2E2s8dZn6
         9eco9eZXLcbYqzoQevA2CTqRHaElZoWyry2exRbw=
Date:   Thu, 02 Feb 2023 22:50:49 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        jiebin.sun@intel.com, alexander.sverdlin@siemens.com,
        1vier1@web.de, manfred@colorfullife.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-percpu_counter-percpu_counter_add_batch-overflow-underflow.patch removed from -mm tree
Message-Id: <20230203065049.B9D52C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/percpu_counter: percpu_counter_add_batch() overflow/underflow
has been removed from the -mm tree.  Its filename was
     lib-percpu_counter-percpu_counter_add_batch-overflow-underflow.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


