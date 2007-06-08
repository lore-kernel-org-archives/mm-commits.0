From: akpm@linux-foundation.org
Subject: + rt-mutex-fix-stale-return-value.patch added to -mm tree
Date: Thu, 07 Jun 2007 17:27:14 -0700
Message-ID: <200706080027.l580REc9013564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933216AbXFHA3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 20:29:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, dada1@cosmosbay.com, drepper@redhat.com, kuznet@ms2.inr.ac.ru, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     rt-mutex: fix stale return value
has been added to the -mm tree.  Its filename is
     rt-mutex-fix-stale-return-value.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rt-mutex: fix stale return value
From: Thomas Gleixner <tglx@linutronix.de>

Alexey Kuznetsov found some problems in the pi-futex code.

The major problem is a stale return value in rt_mutex_slowlock():

When the pi chain walk returns -EDEADLK, but the waiter was woken up during
the phases where the locks were dropped, the rtmutex could be acquired, but
due to the stale return value -EDEADLK returned to the caller.

Reset the return value in the retry path.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rtmutex.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff -puN kernel/rtmutex.c~rt-mutex-fix-stale-return-value kernel/rtmutex.c
--- a/kernel/rtmutex.c~rt-mutex-fix-stale-return-value
+++ a/kernel/rtmutex.c
@@ -636,9 +636,16 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 			 * all over without going into schedule to try
 			 * to get the lock now:
 			 */
-			if (unlikely(!waiter.task))
+			if (unlikely(!waiter.task)) {
+				/*
+				 * Reset the return value. We might
+				 * have returned with -EDEADLK and the
+				 * owner released the lock while we
+				 * were walking the pi chain.
+				 */
+				ret = 0;
 				continue;
-
+			}
 			if (unlikely(ret))
 				break;
 		}
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
