From: akpm@linux-foundation.org
Subject: - time-make-sure-sys_gettimeofday-and-sys_time-are-in.patch removed from -mm tree
Date: Thu, 19 Jul 2007 00:50:26 -0700
Message-ID: <200707190750.l6J7oS1U020684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933023AbXGSIYp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 04:24:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, johnstul@us.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     time: make sure sys_gettimeofday() and sys_time() are in sync
has been removed from the -mm tree.  Its filename was
     time-make-sure-sys_gettimeofday-and-sys_time-are-in.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: time: make sure sys_gettimeofday() and sys_time() are in sync
From: Ingo Molnar <mingo@elte.hu>

Make sure sys_gettimeofday() and sys_time() results are coherent.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |   13 +++++++++++++
 1 files changed, 13 insertions(+)

diff -puN kernel/time/timekeeping.c~time-make-sure-sys_gettimeofday-and-sys_time-are-in kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~time-make-sure-sys_gettimeofday-and-sys_time-are-in
+++ a/kernel/time/timekeeping.c
@@ -100,6 +100,19 @@ static inline void __get_realtime_clock_
 	} while (read_seqretry(&xtime_lock, seq));
 
 	timespec_add_ns(ts, nsecs);
+	/*
+	 * Make sure xtime.tv_sec [returned by sys_time()] always
+	 * follows the gettimeofday() result precisely. This
+	 * condition is extremely unlikely, it can hit at most
+	 * once per second:
+	 */
+	if (unlikely(xtime.tv_sec != ts->tv_sec)) {
+		unsigned long flags;
+
+		write_seqlock_irqsave(&xtime_lock, flags);
+		update_wall_time();
+		write_sequnlock_irqrestore(&xtime_lock, flags);
+	}
 }
 
 /**
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
time-make-sure-sys_gettimeofday-and-sys_time-are-in.patch
add-posix-clocks-and-timers-maintainer.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-better-class-name-representation.patch
lockdep-debugging-give-stacktrace-for-init_error.patch
stacktrace-fix-header-file-for-config_stacktrace.patch
