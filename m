From: akpm@linux-foundation.org
Subject: [failures] restart_syscall-use-freezable-blocking-call.patch
 removed from -mm tree
Date: Thu, 02 Apr 2015 12:58:05 -0700
Message-ID: <551d9f4d.uvGxd+ngYbeyPNUr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbbDBT6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2015 15:58:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maninder1.s@samsung.com, amit.arora@samsung.com, peterz@infradead.org, rjw@rjwysocki.net, sasha.levin@oracle.com, sfr@canb.auug.org.au, tglx@linutronix.de, tj@kernel.org, yn.gaur@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/time/hrtimer.c: restart_syscall: use freezable blocking call
has been removed from the -mm tree.  Its filename was
     restart_syscall-use-freezable-blocking-call.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: kernel/time/hrtimer.c: restart_syscall: use freezable blocking call

Avoid waking up every thread sleeping in a restart_syscall call during
suspend and resume by calling a freezable blocking call.  Previous patches
modified the freezer to avoid sending wakeups to threads that are blocked
in freezable blocking calls.

Ref: https://lkml.org/lkml/2013/5/1/424

Backtrace: 
[<c03e3924>] (__schedule+0x0/0x5d8) from [<c03e3f88>] (schedule+0x8c/0x90)
[<c03e3efc>] (schedule+0x0/0x90) from [<c03e3150>] (schedule_hrtimeout_range_clock+0xdc/0x110)
[<c03e3074>] (schedule_hrtimeout_range_clock+0x0/0x110) from [<c03e31a0>] (schedule_hrtimeout_range+0x1c/0x20)
 r9:d16c9be0 r8:8b7d9c2c r7:00000000 r6:00000000 r5:d16c8028
[<c03e3184>] (schedule_hrtimeout_range+0x0/0x20) from [<c015778c>] (poll_schedule_timeout+0x48/0x6c)
[<c0157744>] (poll_schedule_timeout+0x0/0x6c) from [<c0158994>] (do_sys_poll+0x2c8/0x378) r5:d16c9f78 r4:00000000
[<c01586cc>] (do_sys_poll+0x0/0x378) from [<c0158a84>] (do_restart_poll+0x40/0x5c)
[<c0158a44>] (do_restart_poll+0x0/0x5c) from [<c005710c>] (sys_restart_syscall+0x2c/0x30) r4:fffffe7a
[<c00570e0>] (sys_restart_syscall+0x0/0x30) from [<c001a180>] (ret_fast_syscall+0x0/0x48)

This call was selected to be converted to a freezable call because it
doesn't hold any locks or release any resources when interrupted that
might be needed by another freezing task or a kernel driver during
suspend, and is a common site where idle userspace tasks are blocked.

Signed-off-by: Yogesh Gaur <yn.gaur@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Signed-off-by: Amit Arora <amit.arora@samsung.com>
Reviewed-by : Ajeet Yadav <ajeet.y@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/hrtimer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/time/hrtimer.c~restart_syscall-use-freezable-blocking-call kernel/time/hrtimer.c
--- a/kernel/time/hrtimer.c~restart_syscall-use-freezable-blocking-call
+++ a/kernel/time/hrtimer.c
@@ -1767,7 +1767,7 @@ schedule_hrtimeout_range_clock(ktime_t *
 	 * A NULL parameter means "infinite"
 	 */
 	if (!expires) {
-		schedule();
+		freezable_schedule();
 		return -EINTR;
 	}
 
@@ -1781,7 +1781,7 @@ schedule_hrtimeout_range_clock(ktime_t *
 		t.task = NULL;
 
 	if (likely(t.task))
-		schedule();
+		freezable_schedule();
 
 	hrtimer_cancel(&t.timer);
 	destroy_hrtimer_on_stack(&t.timer);
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

msgrcv-use-freezable-blocking-call.patch

