From: akpm@linux-foundation.org
Subject: + time-delete-comments-that-refer-to-noexistent-symbols.patch added to -mm tree
Date: Thu, 29 Nov 2007 15:50:09 -0800
Message-ID: <200711292350.lATNo9OQ013593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763005AbXK2XvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 18:51:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     time: delete comments that refer to noexistent symbols
has been added to the -mm tree.  Its filename is
     time-delete-comments-that-refer-to-noexistent-symbols.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -149,7 +149,6 @@ struct hrtimer_sleeper {
  * @get_time:		function to retrieve the current time of the clock
  * @get_softirq_time:	function to retrieve the current time from the softirq
  * @softirq_time:	the time when running the hrtimer queue in the softirq
- * @cb_pending:		list of timers where the callback is pending
  * @offset:		offset of this clock to the monotonic base
  * @reprogram:		function to reprogram the timer event
  */
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

arm-fix-memset-size-error.patch
git-hid.patch
ia64-efi-make-full-use-of-macro-efi_md_size.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
