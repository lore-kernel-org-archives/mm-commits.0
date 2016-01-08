From: akpm@linux-foundation.org
Subject: + vmstat-allocate-vmstat_wq-before-it-is-used.patch added to -mm
 tree
Date: Fri, 08 Jan 2016 12:51:06 -0800
Message-ID: <5690213a.wMF4zA7hypo0DGrp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbcAHUvH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 15:51:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mhocko@suse.com, ying.huang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat: allocate vmstat_wq before it is used
has been added to the -mm tree.  Its filename is
     vmstat-allocate-vmstat_wq-before-it-is-used.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-allocate-vmstat_wq-before-it-is-used.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-allocate-vmstat_wq-before-it-is-used.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: vmstat: allocate vmstat_wq before it is used


kernel test robot has reported the following crash:
[    3.870718] BUG: unable to handle kernel NULL pointer dereferenceNULL pointer dereference at 00000100
 at 00000100
[    3.872615] IP: [<c1074df6>] __queue_work+0x26/0x390 [<c1074df6>] __queue_work+0x26/0x390
[    3.873758] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 *pde = f000ff53f000ff53
[    3.875096] Oops: 0000 [#1] PREEMPT PREEMPT SMP SMP
[    3.876130] CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted 4.4.0-rc4-00139-g373ccbe #1
[    3.878135] Workqueue: events vmstat_shepherd
[    3.879207] task: cb684600 ti: cb7ba000 task.ti: cb7ba000
[    3.880445] EIP: 0060:[<c1074df6>] EFLAGS: 00010046 CPU: 0
[    3.881704] EIP is at __queue_work+0x26/0x390
[    3.882823] EAX: 00000046 EBX: cbb37800 ECX: cbb37800 EDX: 00000000
[    3.884457] ESI: 00000000 EDI: 00000000 EBP: cb7bbe68 ESP: cb7bbe38
[    3.886005]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    3.887229] CR0: 8005003b CR2: 00000100 CR3: 01fd5000 CR4: 000006b0
[    3.888663] Stack:
[    3.895204] Call Trace:
[    3.895854]  [<c1a381dd>] ? mutex_unlock+0xd/0x10
[    3.897120]  [<c1075221>] __queue_delayed_work+0xa1/0x160
[    3.898530]  [<c10764c6>] queue_delayed_work_on+0x36/0x60
[    3.899790]  [<c11494bd>] vmstat_shepherd+0xad/0xf0
[    3.900899]  [<c1075a7a>] process_one_work+0x1aa/0x4c0
[    3.902093]  [<c10759e2>] ? process_one_work+0x112/0x4c0
[    3.903520]  [<c10ac31e>] ? do_raw_spin_lock+0xe/0x150
[    3.904853]  [<c1075dd1>] worker_thread+0x41/0x440
[    3.906023]  [<c1075d90>] ? process_one_work+0x4c0/0x4c0
[    3.907242]  [<c107b7c0>] kthread+0xb0/0xd0
[    3.908188]  [<c1a3c651>] ret_from_kernel_thread+0x21/0x40
[    3.909601]  [<c107b710>] ? __kthread_parkme+0x80/0x80

The reason is that start_shepherd_timer schedules the shepherd work item
which uses vmstat_wq (vmstat_shepherd) before setup_vmstat allocates
that workqueue so if the further initialization takes more than HZ
we might end up scheduling on a NULL vmstat_wq. This is really unlikely
but not impossible.

Fixes: 373ccbe59270 ("mm, vmstat: allow WQ concurrency to discover memory reclaim doesn't make any progress")
Reported-by: kernel test robot <ying.huang@linux.intel.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
Hi Linus,
I am not marking this for stable because I hope we can sneak it into 4.4.
The patch is trivial and obvious. I am sorry about the breakage. If you prefer
to postpone it to 4.5-rc1 because this is not really that critical and shouldn't
happen most of the time then I will repost with stable tag added.

Thanks!

 1 file changed, 1 insertion(+), 1 deletion(-)

index 4ebc17d948cb..c54fd2924f25 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~vmstat-allocate-vmstat_wq-before-it-is-used mm/vmstat.c
--- a/mm/vmstat.c~vmstat-allocate-vmstat_wq-before-it-is-used
+++ a/mm/vmstat.c
@@ -1483,6 +1483,7 @@ static void __init start_shepherd_timer(
 		BUG();
 	cpumask_copy(cpu_stat_off, cpu_online_mask);
 
+	vmstat_wq = alloc_workqueue("vmstat", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
 	schedule_delayed_work(&shepherd,
 		round_jiffies_relative(sysctl_stat_interval));
 }
@@ -1550,7 +1551,6 @@ static int __init setup_vmstat(void)
 
 	start_shepherd_timer();
 	cpu_notifier_register_done();
-	vmstat_wq = alloc_workqueue("vmstat", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
 #endif
 #ifdef CONFIG_PROC_FS
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
_

Patches currently in -mm which might be from mhocko@kernel.org are

vmstat-allocate-vmstat_wq-before-it-is-used.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix.patch
mm-oom-introduce-oom-reaper-fix.patch
mm-oom-introduce-oom-reaper-fix-4.patch
mm-oom-introduce-oom-reaper-fix-5.patch

