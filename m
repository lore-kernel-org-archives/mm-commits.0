From: akpm@linux-foundation.org
Subject: [patch 089/102] kthread/smpboot: do not park in
 kthread_create_on_cpu()
Date: Tue, 11 Oct 2016 13:55:23 -0700
Message-ID: <57fd51bb.izDBKwl2bkJgzF4a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38487 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbcJKU5W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, pmladek@suse.com, bp@suse.de, jkosina@suse.cz, josh@joshtriplett.org, mhocko@suse.cz, mingo@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, vbabka@suse.cz

From: Petr Mladek <pmladek@suse.com>
Subject: kthread/smpboot: do not park in kthread_create_on_cpu()

kthread_create_on_cpu() was added by the commit 2a1d446019f9a5983e
("kthread: Implement park/unpark facility").  It is currently used only
when enabling new CPU.  For this purpose, the newly created kthread has to
be parked.

The CPU binding is a bit tricky.  The kthread is parked when the CPU has
not been allowed yet.  And the CPU is bound when the kthread is unparked.

The function would be useful for more per-CPU kthreads, e.g. 
bnx2fc_thread, fcoethread.  For this purpose, the newly created kthread
should stay in the uninterruptible state.

This patch moves the parking into smpboot.  It binds the thread already
when created.  Then the function might be used universally.  Also the
behavior is consistent with kthread_create() and kthread_create_on_node().

Link: http://lkml.kernel.org/r/1470754545-17632-4-git-send-email-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    8 ++++++--
 kernel/smpboot.c |    5 +++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff -puN kernel/kthread.c~kthread-smpboot-do-not-park-in-kthread_create_on_cpu kernel/kthread.c
--- a/kernel/kthread.c~kthread-smpboot-do-not-park-in-kthread_create_on_cpu
+++ a/kernel/kthread.c
@@ -390,10 +390,10 @@ struct task_struct *kthread_create_on_cp
 				   cpu);
 	if (IS_ERR(p))
 		return p;
+	kthread_bind(p, cpu);
+	/* CPU hotplug need to bind once again when unparking the thread. */
 	set_bit(KTHREAD_IS_PER_CPU, &to_kthread(p)->flags);
 	to_kthread(p)->cpu = cpu;
-	/* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
-	kthread_park(p);
 	return p;
 }
 
@@ -407,6 +407,10 @@ static void __kthread_unpark(struct task
 	 * which might be about to be cleared.
 	 */
 	if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
+		/*
+		 * Newly created kthread was parked when the CPU was offline.
+		 * The binding was lost and we need to set it again.
+		 */
 		if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
 			__kthread_bind(k, kthread->cpu, TASK_PARKED);
 		wake_up_state(k, TASK_PARKED);
diff -puN kernel/smpboot.c~kthread-smpboot-do-not-park-in-kthread_create_on_cpu kernel/smpboot.c
--- a/kernel/smpboot.c~kthread-smpboot-do-not-park-in-kthread_create_on_cpu
+++ a/kernel/smpboot.c
@@ -186,6 +186,11 @@ __smpboot_create_thread(struct smp_hotpl
 		kfree(td);
 		return PTR_ERR(tsk);
 	}
+	/*
+	 * Park the thread so that it could start right on the CPU
+	 * when it is available.
+	 */
+	kthread_park(tsk);
 	get_task_struct(tsk);
 	*per_cpu_ptr(ht->store, cpu) = tsk;
 	if (ht->create) {
_
