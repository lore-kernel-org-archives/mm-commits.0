From: akpm@linux-foundation.org
Subject: + smpboot-make-cleanup-to-mirror-setup.patch added to -mm tree
Date: Mon, 13 Jul 2015 14:55:40 -0700
Message-ID: <55a433dc./FdN+hp0Udb9608S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbbGMVzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cmetcalf@ezchip.com, dzickus@redhat.com, peterz@infradead.org, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smpboot: make cleanup to mirror setup
has been added to the -mm tree.  Its filename is
     smpboot-make-cleanup-to-mirror-setup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smpboot-make-cleanup-to-mirror-setup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smpboot-make-cleanup-to-mirror-setup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: smpboot: make cleanup to mirror setup

The per-cpu kthread cleanup() callback is the mirror of the setup()
callback. When the per-cpu kthread is started, it first calls setup()
to initialize the resources which are then released by cleanup() when
the kthread exits.

Now since the introduction of a per-cpu kthread cpumask, the kthreads
excluded by the cpumask on boot may happen to be parked immediately
after their creation without taking the setup() stage, waiting to be
asked to unpark to do so. Then when smpboot_unregister_percpu_thread()
is later called, the kthread is stopped without having ever called
setup().

But this triggers a bug as the kthread unconditionally calls cleanup()
on exit but this doesn't mirror any setup(). Thus the kernel crashes
because we try to free resources that haven't been initialized, as in
the watchdog case:

	[  112.645556] WATCHDOG disable 0
	[  112.648765] WATCHDOG disable 1
	[  112.651891] WATCHDOG disable 2
	[  112.654953] BUG: unable to handle kernel NULL pointer dereference at           (null)
	[  112.662808] IP: [<ffffffff8111ea16>] hrtimer_active+0x26/0x60
	[...]
	[  112.815078] Call Trace:
	[  112.817523]  [<ffffffff8111fe7c>] hrtimer_try_to_cancel+0x1c/0x280
	[  112.823697]  [<ffffffff811200fd>] hrtimer_cancel+0x1d/0x30
	[  112.829172]  [<ffffffff8115d846>] watchdog_disable+0x56/0x70
	[  112.834818]  [<ffffffff8115d86e>] watchdog_cleanup+0xe/0x10
	[  112.840381]  [<ffffffff810ca05c>] smpboot_thread_fn+0x23c/0x2c0
	[  112.846296]  [<ffffffff810c9e20>] ? sort_range+0x30/0x30
	[  112.851596]  [<ffffffff810c6478>] kthread+0xf8/0x110
	[  112.856550]  [<ffffffff810c6380>] ? kthread_create_on_node+0x210/0x210
	[  112.863065]  [<ffffffff8191501f>] ret_from_fork+0x3f/0x70
	[  112.868460]  [<ffffffff810c6380>] ? kthread_create_on_node+0x210/0x210

This bug is currently masked with explicit kthread unparking before
kthread_stop() on smpboot_destroy_threads(). This forces a call to
setup() and then unpark().

We could fix this by unconditionally calling setup() on kthread entry. 
But setup() isn't always cheap.  In the case of watchdog it launches
hrtimer, perf events, etc...  So we may as well like to skip it if there
are chances the kthread will never be used, as in a reduced cpumask value.

So let's simply do a state machine check before calling cleanup() that
makes sure setup() has been called before mirroring it.

And remove the nasty hack workaround.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Chris Metcalf <cmetcalf@ezchip.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smpboot.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN kernel/smpboot.c~smpboot-make-cleanup-to-mirror-setup kernel/smpboot.c
--- a/kernel/smpboot.c~smpboot-make-cleanup-to-mirror-setup
+++ a/kernel/smpboot.c
@@ -113,7 +113,8 @@ static int smpboot_thread_fn(void *data)
 		if (kthread_should_stop()) {
 			__set_current_state(TASK_RUNNING);
 			preempt_enable();
-			if (ht->cleanup)
+			/* cleanup must mirror setup */
+			if (ht->cleanup && td->status != HP_THREAD_NONE)
 				ht->cleanup(td->cpu, cpu_online(td->cpu));
 			kfree(td);
 			return 0;
@@ -259,15 +260,6 @@ static void smpboot_destroy_threads(stru
 {
 	unsigned int cpu;
 
-	/* Unpark any threads that were voluntarily parked. */
-	for_each_cpu_not(cpu, ht->cpumask) {
-		if (cpu_online(cpu)) {
-			struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
-			if (tsk)
-				kthread_unpark(tsk);
-		}
-	}
