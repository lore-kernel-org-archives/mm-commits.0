From: akpm@linux-foundation.org
Subject: - rt-mutex-fix-chain-walk-early-wakeup-bug.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:57:19 -0700
Message-ID: <200706121857.l5CIvJZO018457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35597 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbXFLTLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:11:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, dada1@cosmosbay.com, drepper@redhat.com, kuznet@ms2.inr.ac.ru, mingo@elte.hu, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     rt-mutex: fix chain walk early wakeup bug
has been removed from the -mm tree.  Its filename was
     rt-mutex-fix-chain-walk-early-wakeup-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rt-mutex: fix chain walk early wakeup bug
From: Thomas Gleixner <tglx@linutronix.de>

Alexey Kuznetsov found some problems in the pi-futex code.

One of the root causes is:

When a wakeup happens, we do not to stop the chain walk so we follow a not
longer relevant locking chain.

Drop out when this happens.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rtmutex.c |   13 +++++++++++++
 1 files changed, 13 insertions(+)

diff -puN kernel/rtmutex.c~rt-mutex-fix-chain-walk-early-wakeup-bug kernel/rtmutex.c
--- a/kernel/rtmutex.c~rt-mutex-fix-chain-walk-early-wakeup-bug
+++ a/kernel/rtmutex.c
@@ -189,6 +189,19 @@ int rt_mutex_adjust_prio_chain(struct ta
 	if (!waiter || !waiter->task)
 		goto out_unlock_pi;
 
+	/*
+	 * Check the orig_waiter state. After we dropped the locks,
+	 * the previous owner of the lock might have released the lock
+	 * and made us the pending owner:
+	 */
+	if (orig_waiter && !orig_waiter->task)
+		goto out_unlock_pi;
+
+	/*
+	 * Drop out, when the task has no waiters. Note,
+	 * top_waiter can be NULL, when we are in the deboosting
+	 * mode!
+	 */
 	if (top_waiter && (!task_has_pi_waiters(task) ||
 			   top_waiter != task_top_pi_waiter(task)))
 		goto out_unlock_pi;
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi-add-exports.patch
git-arm.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
futex-tidy-up-the-code.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
lock-debugging-loop-nicer-in-mark_rt_mutex_waiters.patch
lguest-the-host-code.patch
