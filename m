Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B1AC433B4
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E73146142B
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhDVEPg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 00:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhDVEPf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 00:15:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57FDB61424;
        Thu, 22 Apr 2021 04:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619064901;
        bh=BlguzaXJOoHZOpj9N3oBHScTU5Sam/+XrSX650JQ9Qk=;
        h=Date:From:To:Subject:From;
        b=DKwgH5GhyvEgrPUzHd35e61H7soj7tBb6Gi5Q0Tn2c7yZUyeBVNQ4YD4Kyl9SOQW0
         Lr+KZ7t3CYKc0pokUoGd3uuiIhFRPzK7OREX8jQm428DfOpxKZV5EGdadyciJRjwiy
         GWu4RFenpR/ND7Hi3lN9Bi9De575+UmyW4nIO114=
Date:   Wed, 21 Apr 2021 21:15:00 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        hdanton@sina.com, jannh@google.com, mark.rutland@arm.com,
        mm-commits@vger.kernel.org
Subject:  [to-be-updated]
 kfence-await-for-allocation-using-wait_event.patch removed from -mm tree
Message-ID: <20210422041500.Tz4bRCVNo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: await for allocation using wait_event
has been removed from the -mm tree.  Its filename was
     kfence-await-for-allocation-using-wait_event.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: await for allocation using wait_event

Patch series "kfence: optimize timer scheduling", v2.

We have observed that mostly-idle systems with KFENCE enabled wake up
otherwise idle CPUs, preventing such to enter a lower power state. 
Debugging revealed that KFENCE spends too much active time in
toggle_allocation_gate().

While the first version of KFENCE was using all the right bits to be
scheduling optimal, and thus power efficient, by simply using wait_event()
+ wake_up(), that code was unfortunately removed.

As KFENCE was exposed to various different configs and tests, the
scheduling optimal code slowly disappeared.  First because of hung task
warnings, and finally because of deadlocks when an allocation is made by
timer code with debug objects enabled.  Clearly, the "fixes" were not too
friendly for devices that want to be power efficient.

Therefore, let's try a little harder to fix the hung task and deadlock
problems that we have with wait_event() + wake_up(), while remaining as
scheduling friendly and power efficient as possible.

Crucially, we need to defer the wake_up() to an irq_work, avoiding any
potential for deadlock.

The result with this series is that on the devices where we observed a
power regression, power usage returns back to baseline levels.


This patch (of 3):

On mostly-idle systems, we have observed that toggle_allocation_gate() is
a cause of frequent wake-ups, preventing an otherwise idle CPU to go into
a lower power state.

A late change in KFENCE's development, due to a potential deadlock [1],
required changing the scheduling-friendly wait_event_timeout() and
wake_up() to an open-coded wait-loop using schedule_timeout().  [1]
https://lkml.kernel.org/r/000000000000c0645805b7f982e4@google.com

To avoid unnecessary wake-ups, switch to using wait_event_timeout().

Unfortunately, we still cannot use a version with direct wake_up() in
__kfence_alloc() due to the same potential for deadlock as in [1]. 
Instead, add a level of indirection via an irq_work that is scheduled if
we determine that the kfence_timer requires a wake_up().


Link: https://lkml.kernel.org/r/20210419085027.761150-1-elver@google.com
Link: https://lkml.kernel.org/r/20210419085027.761150-2-elver@google.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jann Horn <jannh@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kfence |    1 
 mm/kfence/core.c   |   56 +++++++++++++++++++++++++++++++------------
 2 files changed, 42 insertions(+), 15 deletions(-)

--- a/lib/Kconfig.kfence~kfence-await-for-allocation-using-wait_event
+++ a/lib/Kconfig.kfence
@@ -7,6 +7,7 @@ menuconfig KFENCE
 	bool "KFENCE: low-overhead sampling-based memory safety error detector"
 	depends on HAVE_ARCH_KFENCE && (SLAB || SLUB)
 	select STACKTRACE
+	select IRQ_WORK
 	help
 	  KFENCE is a low-overhead sampling-based detector of heap out-of-bounds
 	  access, use-after-free, and invalid-free errors. KFENCE is designed
--- a/mm/kfence/core.c~kfence-await-for-allocation-using-wait_event
+++ a/mm/kfence/core.c
@@ -10,6 +10,7 @@
 #include <linux/atomic.h>
 #include <linux/bug.h>
 #include <linux/debugfs.h>
+#include <linux/irq_work.h>
 #include <linux/kcsan-checks.h>
 #include <linux/kfence.h>
 #include <linux/kmemleak.h>
@@ -587,6 +588,20 @@ late_initcall(kfence_debugfs_init);
 
 /* === Allocation Gate Timer ================================================ */
 
+#ifdef CONFIG_KFENCE_STATIC_KEYS
+/* Wait queue to wake up allocation-gate timer task. */
+static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
+
+static void wake_up_kfence_timer(struct irq_work *work)
+{
+	wake_up(&allocation_wait);
+}
+static DEFINE_IRQ_WORK(wake_up_kfence_timer_work, wake_up_kfence_timer);
+
+/* Indicate if timer task is waiting, to avoid unnecessary irq_work. */
+static bool kfence_timer_waiting;
+#endif
+
 /*
  * Set up delayed work, which will enable and disable the static key. We need to
  * use a work queue (rather than a simple timer), since enabling and disabling a
@@ -604,25 +619,16 @@ static void toggle_allocation_gate(struc
 	if (!READ_ONCE(kfence_enabled))
 		return;
 
-	/* Enable static key, and await allocation to happen. */
 	atomic_set(&kfence_allocation_gate, 0);
 #ifdef CONFIG_KFENCE_STATIC_KEYS
+	/* Enable static key, and await allocation to happen. */
 	static_branch_enable(&kfence_allocation_key);
-	/*
-	 * Await an allocation. Timeout after 1 second, in case the kernel stops
-	 * doing allocations, to avoid stalling this worker task for too long.
-	 */
-	{
-		unsigned long end_wait = jiffies + HZ;
 
-		do {
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			if (atomic_read(&kfence_allocation_gate) != 0)
-				break;
-			schedule_timeout(1);
-		} while (time_before(jiffies, end_wait));
-		__set_current_state(TASK_RUNNING);
-	}
+	WRITE_ONCE(kfence_timer_waiting, true);
+	smp_mb(); /* See comment in __kfence_alloc(). */
+	wait_event_timeout(allocation_wait, atomic_read(&kfence_allocation_gate), HZ);
+	smp_store_release(&kfence_timer_waiting, false); /* Order after wait_event(). */
+
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
 #endif
@@ -729,6 +735,26 @@ void *__kfence_alloc(struct kmem_cache *
 	 */
 	if (atomic_read(&kfence_allocation_gate) || atomic_inc_return(&kfence_allocation_gate) > 1)
 		return NULL;
+#ifdef CONFIG_KFENCE_STATIC_KEYS
+	/*
+	 * Read of kfence_timer_waiting must be ordered after write to
+	 * kfence_allocation_gate (fully ordered per atomic_inc_return()).
+	 *
+	 * Conversely, the write to kfence_timer_waiting must be ordered before
+	 * the check of kfence_allocation_gate in toggle_allocation_gate().
+	 *
+	 * This ensures that toggle_allocation_gate() always sees the updated
+	 * kfence_allocation_gate, or we see that the timer is waiting and will
+	 * queue the work to wake it up.
+	 */
+	if (READ_ONCE(kfence_timer_waiting)) {
+		/*
+		 * Calling wake_up() here may deadlock when allocations happen
+		 * from within timer code. Use an irq_work to defer it.
+		 */
+		irq_work_queue(&wake_up_kfence_timer_work);
+	}
+#endif
 
 	if (!READ_ONCE(kfence_enabled))
 		return NULL;
_

Patches currently in -mm which might be from elver@google.com are

kfence-zero-guard-page-after-out-of-bounds-access.patch
kfence-maximize-allocation-wait-timeout-duration.patch
kfence-use-power-efficient-work-queue-to-run-delayed-work.patch

