From: akpm@linux-foundation.org
Subject: [nacked]
 watchdog-fix-possible-soft-lockup-warning-at-bootup.patch removed from -mm
 tree
Date: Thu, 16 Jan 2020 15:53:27 -0800
Message-ID: <20200116235327.wKIGz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgAPXx3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jan 2020 18:53:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rppt@linux.ibm.com, mingo@kernel.org, keescook@chromium.org, longman@redhat.com


The patch titled
     Subject: kernel/watchdog.c: fix possible soft lockup warning at bootup
has been removed from the -mm tree.  Its filename was
     watchdog-fix-possible-soft-lockup-warning-at-bootup.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: kernel/watchdog.c: fix possible soft lockup warning at bootup

It was found that watchdog soft lockup warning was displayed on a Cavium
ThunderX2 Sabre arm64 system at bootup time:

 [   25.496379] watchdog: BUG: soft lockup - CPU#14 stuck for 22s!  [swapper/14:0]
 [   25.496381] Modules linked in:
 [   25.496386] CPU: 14 PID: 0 Comm: swapper/14 Tainted: G        W    L --------- -  - 4.18.0-rhel8.1+ #9
 [   25.496388] pstate: 60000009 (nZCv daif -PAN -UAO)
 [   25.496393] pc : arch_cpu_idle+0x34/0x140
 [   25.496395] lr : arch_cpu_idle+0x30/0x140
 [   25.496397] sp : ffff000021f4ff10
 [   25.496398] x29: ffff000021f4ff10 x28: 0000000000000000
 [   25.496401] x27: 0000000000000000 x26: ffff809f483c0000
 [   25.496404] x25: 0000000000000000 x24: ffff00001145c03c
 [   25.496407] x23: ffff00001110c9f8 x22: ffff000011453708
 [   25.496410] x21: ffff00001145bffc x20: 0000000000004000
 [   25.496413] x19: ffff0000110f0018 x18: 0000000000000010
 [   25.496416] x17: 0000000000000cc8 x16: 0000000000000000
 [   25.496419] x15: ffffffffffffffff x14: ffff000011453708
 [   25.496422] x13: ffff000091cc5caf x12: ffff000011cc5cb7
 [   25.496424] x11: 6572203030642072 x10: 0000000000000d10
 [   25.496427] x9 : ffff000021f4fe80 x8 : ffff809f483c0d70
 [   25.496430] x7 : 00000000b123f581 x6 : 00000000ffff8ae1
 [   25.496433] x5 : 00000000ffffffff x4 : 0000809f6ac90000
 [   25.496436] x3 : 4000000000000000 x2 : ffff809f7bd9e9c0
 [   25.496439] x1 : ffff0000110f0018 x0 : ffff000021f4ff10
 [   25.496441] Call trace:
 [   25.496444]  arch_cpu_idle+0x34/0x140
 [   25.496447]  do_idle+0x210/0x288
 [   25.496449]  cpu_startup_entry+0x2c/0x30
 [   25.496452]  secondary_start_kernel+0x124/0x138

Further analysis of the situation revealed that the smp_init() call itself
took more than 20s for that 2-socket 56-core and 224-thread server.

 [    0.115632] CPU1: Booted secondary processor 0x0000000100 [0x431f0af1]
   :
 [   27.177282] CPU223: Booted secondary processor 0x0000011b03 [0x431f0af1]

By adding some instrumentation code, it was found that for cpu 14,
watchdog_enable() was called early with a timestamp of 1.  That activates
the watchdog time checking logic.  It was also found that the monotonic
time measured during the smp_init() phase runs much slower than the real
elapsed time as shown by the below debug printf output:

  [    1.138522] run_queues, watchdog_timer_fn: now = 170000000
  [   25.519391] run_queues, watchdog_timer_fn: now = 4170000000

In this particular case, it took about 24.4s of elapsed time for the clock
to advance 4s which is the soft expiration time that is required to
trigger the calling of watchdog_timer_fn().  That clock slowdown stopped
once the smp_init() call was done and the clock time ran at the same rate
as the elapsed time afterward.

On a comparable CN9980 system from HPE, there was also a bit of clock
slowdown but not as much as the Cavium system:

  [    1.177068] run_queues, watchdog_timer_fn: now = 1010000000
  [    5.577925] run_queues, watchdog_timer_fn: now = 5010000000

Similar clock slowdown was not observed on x86-64 systems.

The clock slowdown in arm64 systems seems to be hardware specific.

Given the fact that the clock is less reliable during the smp_init() call
and that call can take a rather long time, one simple workaround to avoid
this soft lockup problem is to move lockup_detector_init() call after
smp_init() when the clock is reliable.  This does fix the soft lockup
problem for that Cavium system and does not seem to affect the operation
of the watchdog.  This is much easier than trying to fix the clock
slowdown problem in smp_init() as the watchdog timer is the only timer
function that can be active at such early boot stage anyway.

[longman@redhat.com: v2]
  Link: http://lkml.kernel.org/r/20200103151032.19590-1-longman@redhat.com
Link: http://lkml.kernel.org/r/20200102154149.7564-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~watchdog-fix-possible-soft-lockup-warning-at-bootup
+++ a/init/main.c
@@ -1191,9 +1191,9 @@ static noinline void __init kernel_init_
 	init_mm_internals();
 
 	do_pre_smp_initcalls();
-	lockup_detector_init();
 
 	smp_init();
+	lockup_detector_init();
 	sched_init_smp();
 
 	page_alloc_init_late();
_

Patches currently in -mm which might be from longman@redhat.com are
