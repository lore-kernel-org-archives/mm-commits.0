From: akpm@linux-foundation.org
Subject: + rt-mutex-fix-chain-walk-early-wakeup-bug.patch added to -mm tree
Date: Thu, 07 Jun 2007 17:27:16 -0700
Message-ID: <200706080027.l580RGDo013567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51635 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933871AbXFHA3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 20:29:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, dada1@cosmosbay.com, drepper@redhat.com, kuznet@ms2.inr.ac.ru, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     rt-mutex: fix chain walk early wakeup bug
has been added to the -mm tree.  Its filename is
     rt-mutex-fix-chain-walk-early-wakeup-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rt-mutex: fix chain walk early wakeup bug
From: Thomas Gleixner <tglx@linutronix.de>

Alexey Kuznetsov found some problems in the pi-futex code.

One of the root causes is:

When a wakeup happens, we do not to stop the chain walk so we follow a not
longer relevant locking chain.

Drop out when this happens.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
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

rt-mutex-fix-stale-return-value.patch
rt-mutex-fix-chain-walk-early-wakeup-bug.patch
pi-futex-fix-exit-races-and-locking-problems.patch
git-acpi-add-exports.patch
git-arm.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
lguest-the-host-code-use-hrtimers.patch
futex-tidy-up-the-code.patch
