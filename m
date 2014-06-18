From: akpm@linux-foundation.org
Subject: +
 watchdog-remove-preemption-restrictions-when-restarting-lockup-detector.patch added to -mm tree
Date: Wed, 18 Jun 2014 13:16:53 -0700
Message-ID: <53a1f3b5.hDtMR+vi5toDLRm/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaFRUQy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 16:16:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rientjes@google.com, peter@lekensteyn.nl, mhocko@suse.cz, dzickus@redhat.com


The patch titled
     Subject: kernel/watchdog.c: remove preemption restrictions when restarting lockup detector
has been added to the -mm tree.  Its filename is
     watchdog-remove-preemption-restrictions-when-restarting-lockup-detector.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-remove-preemption-restrictions-when-restarting-lockup-detector.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-remove-preemption-restrictions-when-restarting-lockup-detector.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Don Zickus <dzickus@redhat.com>
Subject: kernel/watchdog.c: remove preemption restrictions when restarting lockup detector

Peter Wu noticed the following splat on his machine when updating
/proc/sys/kernel/watchdog_thresh:

[    0.676701] BUG: sleeping function called from invalid context at mm/slub.c:965
[    0.679396] in_atomic(): 1, irqs_disabled(): 0, pid: 1, name: init
[    0.681204] 3 locks held by init/1:
[    0.682371]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff8117b663>] vfs_write+0x143/0x180
[    0.685887]  #1:  (watchdog_proc_mutex){+.+.+.}, at: [<ffffffff810e02d3>] proc_dowatchdog+0x33/0x110
[    0.689631]  #2:  (cpu_hotplug.lock){.+.+.+}, at: [<ffffffff810589c2>] get_online_cpus+0x32/0x80
[    0.693117] Preemption disabled at:[<ffffffff810e0384>] proc_dowatchdog+0xe4/0x110
[    0.695753]
[    0.696588] CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-rc1-testing #34
[    0.698404] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    0.704622]  ffff88003f250000 ffff88003f1ffd10 ffffffff81624c59 0000000000000000
[    0.707749]  ffff88003f1ffd30 ffffffff8108df1d 0000000000000010 ffffffff81c56360
[    0.711010]  ffff88003f1ffd78 ffffffff8116a5de ffffffff811159a5 ffffffff810a5f4a
[    0.714053] Call Trace:
[    0.715015]  [<ffffffff81624c59>] dump_stack+0x4e/0x7a
[    0.716619]  [<ffffffff8108df1d>] __might_sleep+0x11d/0x190
[    0.718232]  [<ffffffff8116a5de>] kmem_cache_alloc_trace+0x4e/0x1e0
[    0.720214]  [<ffffffff811159a5>] ? perf_event_alloc+0x55/0x440
[    0.721910]  [<ffffffff810a5f4a>] ? mark_held_locks+0x6a/0x90
[    0.723558]  [<ffffffff811159a5>] perf_event_alloc+0x55/0x440
[    0.725304]  [<ffffffff810e0050>] ? restart_watchdog_hrtimer+0x50/0x50
[    0.727279]  [<ffffffff81116d16>] perf_event_create_kernel_counter+0x26/0xe0
[    0.729269]  [<ffffffff810dfe05>] watchdog_nmi_enable+0x75/0x140
[    0.730965]  [<ffffffff810dffb3>] update_timers_all_cpus+0x53/0xa0
[    0.732953]  [<ffffffff810e0384>] proc_dowatchdog+0xe4/0x110
[    0.738408]  [<ffffffff811d8c93>] proc_sys_call_handler+0xb3/0xc0
[    0.740266]  [<ffffffff811d8cb4>] proc_sys_write+0x14/0x20
[    0.742086]  [<ffffffff8117b5cd>] vfs_write+0xad/0x180
[    0.743669]  [<ffffffff810a606d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[    0.745593]  [<ffffffff8117b799>] SyS_write+0x49/0xb0
[    0.747101]  [<ffffffff8162fe92>] system_call_fastpath+0x16/0x1b
[    0.749069] NMI watchdog: disabled (cpu0): hardware events not enabled

What happened is after updating the watchdog_thresh, the lockup detector
is restarted to utilize the new value.  Part of this process involved
disabling preemption.  Once preemption was disabled, perf tried to
allocate a new event (as part of the restart).  This caused the above
BUG_ON as you can't sleep with preemption disabled.

The preemption restriction seemed agressive as we are not doing anything
on that particular cpu, but with all the online cpus (which are protected
by the get_online_cpus lock).  Remove the restriction and the BUG_ON goes
away.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Peter Wu <peter@lekensteyn.nl>
Tested-by: Peter Wu <peter@lekensteyn.nl>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>		[3.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/watchdog.c~watchdog-remove-preemption-restrictions-when-restarting-lockup-detector kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-remove-preemption-restrictions-when-restarting-lockup-detector
+++ a/kernel/watchdog.c
@@ -527,10 +527,8 @@ static void update_timers_all_cpus(void)
 	int cpu;
 
 	get_online_cpus();
-	preempt_disable();
 	for_each_online_cpu(cpu)
 		update_timers(cpu);
-	preempt_enable();
 	put_online_cpus();
 }
 
_

Patches currently in -mm which might be from dzickus@redhat.com are

watchdog-remove-preemption-restrictions-when-restarting-lockup-detector.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
linux-next.patch

