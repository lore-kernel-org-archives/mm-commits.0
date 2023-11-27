Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 901B4C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 19:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjK0TvJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 14:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbjK0TvH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 14:51:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2A31B6
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 11:51:12 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68338C433C7;
        Mon, 27 Nov 2023 19:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701114672;
        bh=URQSBqKP8BnOL/9w2pt/xvThUFuxdwzA0EYjE/yjQII=;
        h=Date:To:From:Subject:From;
        b=0somvN2JKkWOzIp1wf6CP78Xr49QYz8zhmQ81AoSDT08c7V4guK6PrDjVmRhtHYFk
         uy9Ek9PBihZMomNIhaE4uyWhs6jETikB+rf9ttdWewNpEoQYCx8/Zg7xOBxb+Tbi5P
         JwZHWsYAaYnlNdi+YwqVFXS7c0sDOpuj6NcuRoK4=
Date:   Mon, 27 Nov 2023 11:51:11 -0800
To:     mm-commits@vger.kernel.org, catalin.marinas@arm.com,
        longman@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-add-cond_resched-to-kmemleak_free_percpu.patch added to mm-unstable branch
Message-Id: <20231127195112.68338C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: add cond_resched() to kmemleak_free_percpu()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-add-cond_resched-to-kmemleak_free_percpu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-add-cond_resched-to-kmemleak_free_percpu.patch

This patch will later appear in the mm-unstable branch at
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
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: add cond_resched() to kmemleak_free_percpu()
Date: Mon, 27 Nov 2023 14:41:53 -0500

It was found that on systems with large number of CPUs, the following soft
lockup splat might sometimes happen:

[ 2656.001617] watchdog: BUG: soft lockup - CPU#364 stuck for 21s! [ksoftirqd/364:2206]
  :
[ 2656.141194] RIP: 0010:_raw_spin_unlock_irqrestore+0x3d/0x70
  :
 2656.241214] Call Trace:
[ 2656.243971]  <IRQ>
[ 2656.246237]  ? show_trace_log_lvl+0x1c4/0x2df
[ 2656.251152]  ? show_trace_log_lvl+0x1c4/0x2df
[ 2656.256066]  ? kmemleak_free_percpu+0x11f/0x1f0
[ 2656.261173]  ? watchdog_timer_fn+0x379/0x470
[ 2656.265984]  ? __pfx_watchdog_timer_fn+0x10/0x10
[ 2656.271179]  ? __hrtimer_run_queues+0x5f3/0xd00
[ 2656.276283]  ? __pfx___hrtimer_run_queues+0x10/0x10
[ 2656.281783]  ? ktime_get_update_offsets_now+0x95/0x2c0
[ 2656.287573]  ? ktime_get_update_offsets_now+0xdd/0x2c0
[ 2656.293380]  ? hrtimer_interrupt+0x2e9/0x780
[ 2656.298221]  ? __sysvec_apic_timer_interrupt+0x184/0x640
[ 2656.304211]  ? sysvec_apic_timer_interrupt+0x8e/0xc0
[ 2656.309807]  </IRQ>
[ 2656.312169]  <TASK>
[ 2656.326110]  kmemleak_free_percpu+0x11f/0x1f0
[ 2656.331015]  free_percpu.part.0+0x1b/0xe70
[ 2656.335635]  free_vfsmnt+0xb9/0x100
[ 2656.339567]  rcu_do_batch+0x3c8/0xe30
[ 2656.363693]  rcu_core+0x3de/0x5a0
[ 2656.367433]  __do_softirq+0x2d0/0x9a8
[ 2656.381119]  run_ksoftirqd+0x36/0x60
[ 2656.385145]  smpboot_thread_fn+0x556/0x910
[ 2656.394971]  kthread+0x2a4/0x350
[ 2656.402826]  ret_from_fork+0x29/0x50
[ 2656.406861]  </TASK>

Fix this by adding a cond_resched() call in the percpu freeing loop
and defer the freeing of percpu kmemleak objects to a workqueue if it
is being called from a non-task context.

Link: https://lkml.kernel.org/r/20231127194153.289626-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   59 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 52 insertions(+), 7 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-add-cond_resched-to-kmemleak_free_percpu
+++ a/mm/kmemleak.c
@@ -168,6 +168,14 @@ struct kmemleak_object {
 	char comm[TASK_COMM_LEN];	/* executable name */
 };
 
+/*
+ * A percpu address to be submitted to a workqueue for being freed.
+ */
+struct kmemleak_percpu_addr {
+	struct work_struct work;
+	const void __percpu *ptr;
+};
+
 /* flag representing the memory block allocation status */
 #define OBJECT_ALLOCATED	(1 << 0)
 /* flag set after the first reporting of an unreference object */
@@ -1120,23 +1128,60 @@ void __ref kmemleak_free_part(const void
 }
 EXPORT_SYMBOL_GPL(kmemleak_free_part);
 
+static void __kmemleak_free_percpu(const void __percpu *ptr)
+{
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu) {
+		delete_object_full((unsigned long)per_cpu_ptr(ptr, cpu));
+		if (in_task())
+			cond_resched();
+	}
+}
+
+/*
+ * Work function for deferred freeing of kmemleak objects associated with
+ * a freed percpu memory block.
+ */
+static void kmemleak_free_percpu_workfn(struct work_struct *work)
+{
+	struct kmemleak_percpu_addr *addr;
+
+	addr = container_of(work, struct kmemleak_percpu_addr, work);
+	__kmemleak_free_percpu(addr->ptr);
+	kfree(addr);
+}
+
 /**
  * kmemleak_free_percpu - unregister a previously registered __percpu object
  * @ptr:	__percpu pointer to beginning of the object
  *
  * This function is called from the kernel percpu allocator when an object
- * (memory block) is freed (free_percpu).
+ * (memory block) is freed (free_percpu). Since this function is inherently
+ * slow especially on systems with a large number of CPUs, defer the actual
+ * removal of kmemleak objects associated with the percpu pointer to a
+ * workqueue if it is not in a task context.
  */
 void __ref kmemleak_free_percpu(const void __percpu *ptr)
 {
-	unsigned int cpu;
-
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_free_enabled && ptr && !IS_ERR(ptr))
-		for_each_possible_cpu(cpu)
-			delete_object_full((unsigned long)per_cpu_ptr(ptr,
-								      cpu));
+	if (!kmemleak_free_enabled || !ptr || IS_ERR(ptr))
+		return;
+
+	if (!in_task()) {
+		struct kmemleak_percpu_addr *addr;
+
+		addr = kzalloc(sizeof(*addr), GFP_ATOMIC);
+		if (addr) {
+			INIT_WORK(&addr->work, kmemleak_free_percpu_workfn);
+			addr->ptr = ptr;
+			queue_work(system_long_wq, &addr->work);
+			return;
+		}
+		/* Fallback to do direct deletion */
+	}
+	__kmemleak_free_percpu(ptr);
 }
 EXPORT_SYMBOL_GPL(kmemleak_free_percpu);
 
_

Patches currently in -mm which might be from longman@redhat.com are

mm-kmemleak-add-cond_resched-to-kmemleak_free_percpu.patch

