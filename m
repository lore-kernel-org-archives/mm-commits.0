From: akpm@linux-foundation.org
Subject: - time-delete-comments-that-refer-to-noexistent-symbols.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:54:29 -0800
Message-ID: <200802050254.m152sAdb031571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37198 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121AbYBEDAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 22:00:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: delete comments that refer to noexistent symbols
has been removed from the -mm tree.  Its filename was
     time-delete-comments-that-refer-to-noexistent-symbols.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time: delete comments that refer to noexistent symbols
From: Li Zefan <lizf@cn.fujitsu.com>

Function do_timer_interrupt_hook() don't take argument regs, and structure
hrtimer_sleeper don't have member cb_pending.  So delete comments refering to
these symbols.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/mach-voyager/do_timer.h |    1 -
 include/linux/hrtimer.h                 |    1 -
 2 files changed, 2 deletions(-)

diff -puN include/asm-x86/mach-voyager/do_timer.h~time-delete-comments-that-refer-to-noexistent-symbols include/asm-x86/mach-voyager/do_timer.h
--- a/include/asm-x86/mach-voyager/do_timer.h~time-delete-comments-that-refer-to-noexistent-symbols
+++ a/include/asm-x86/mach-voyager/do_timer.h
@@ -6,7 +6,6 @@
 
 /**
  * do_timer_interrupt_hook - hook into timer tick
- * @regs:     standard registers from interrupt
  *
  * Call the pit clock event handler. see asm/i8253.h
  **/
diff -puN include/linux/hrtimer.h~time-delete-comments-that-refer-to-noexistent-symbols include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~time-delete-comments-that-refer-to-noexistent-symbols
+++ a/include/linux/hrtimer.h
@@ -147,7 +147,6 @@ struct hrtimer_sleeper {
  * @get_time:		function to retrieve the current time of the clock
  * @get_softirq_time:	function to retrieve the current time from the softirq
  * @softirq_time:	the time when running the hrtimer queue in the softirq
- * @cb_pending:		list of timers where the callback is pending
  * @offset:		offset of this clock to the monotonic base
  * @reprogram:		function to reprogram the timer event
  */
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
git-drm.patch
git-mtd.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
workqueue-make-delayed_work_timer_fn-static.patch
