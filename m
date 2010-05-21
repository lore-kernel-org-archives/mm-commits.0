From: akpm@linux-foundation.org
Subject: + percpu-fix-list_head-init-bug-in-__percpu_counter_init.patch added to -mm tree
Date: Fri, 21 May 2010 11:48:06 -0700
Message-ID: <201005211848.o4LIm7nS028102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905Ab0EUSsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 14:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: itoumsn@nttdata.co.jp, stable@kernel.org, tj@kernel.org


The patch titled
     percpu: fix list_head init bug in __percpu_counter_init()
has been added to the -mm tree.  Its filename is
     percpu-fix-list_head-init-bug-in-__percpu_counter_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: percpu: fix list_head init bug in __percpu_counter_init()
From: Masanori ITOH <itoumsn@nttdata.co.jp>

WARNING: at lib/list_debug.c:26 __list_add+0x3f/0x81()
Hardware name: Express5800/B120a [N8400-085]
list_add corruption. next->prev should be prev (ffffffff81a7ea00), but was dead000000200200. (next=ffff88080b872d58).
Modules linked in: aoe ipt_MASQUERADE iptable_nat nf_nat autofs4 sunrpc bridge 8021q garp stp llc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_round_robin dm_multipath kvm_intel kvm uinput lpfc scsi_transport_fc igb ioatdma scsi_tgt i2c_i801 i2c_core dca iTCO_wdt iTCO_vendor_support pcspkr shpchp megaraid_sas [last unloaded: aoe]
Pid: 54, comm: events/3 Tainted: G        W  2.6.34-vanilla1 #1
Call Trace:
[<ffffffff8104bd77>] warn_slowpath_common+0x7c/0x94
[<ffffffff8104bde6>] warn_slowpath_fmt+0x41/0x43
[<ffffffff8120fd2e>] __list_add+0x3f/0x81
[<ffffffff81212a12>] __percpu_counter_init+0x59/0x6b
[<ffffffff810d8499>] bdi_init+0x118/0x17e
[<ffffffff811f2c50>] blk_alloc_queue_node+0x79/0x143
[<ffffffff811f2d2b>] blk_alloc_queue+0x11/0x13
[<ffffffffa02a931d>] aoeblk_gdalloc+0x8e/0x1c9 [aoe]
[<ffffffffa02aa655>] aoecmd_sleepwork+0x25/0xa8 [aoe]
[<ffffffff8106186c>] worker_thread+0x1a9/0x237
[<ffffffffa02aa630>] ? aoecmd_sleepwork+0x0/0xa8 [aoe]
[<ffffffff81065827>] ? autoremove_wake_function+0x0/0x39
[<ffffffff810616c3>] ? worker_thread+0x0/0x237
[<ffffffff810653ad>] kthread+0x7f/0x87
[<ffffffff8100aa24>] kernel_thread_helper+0x4/0x10
[<ffffffff8106532e>] ? kthread+0x0/0x87
[<ffffffff8100aa20>] ? kernel_thread_helper+0x0/0x10

It's because there is no initialization code for a list_head contained in
the struct backing_dev_info under CONFIG_HOTPLUG_CPU, and the bug comes up
when block device drivers calling blk_alloc_queue() are used.  In case of
me, I got them by using aoe.

Signed-off-by: Masanori Itoh <itoumsn@nttdata.co.jp>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/percpu_counter.c~percpu-fix-list_head-init-bug-in-__percpu_counter_init lib/percpu_counter.c
--- a/lib/percpu_counter.c~percpu-fix-list_head-init-bug-in-__percpu_counter_init
+++ a/lib/percpu_counter.c
@@ -76,6 +76,7 @@ int __percpu_counter_init(struct percpu_
 	if (!fbc->counters)
 		return -ENOMEM;
 #ifdef CONFIG_HOTPLUG_CPU
+	INIT_LIST_HEAD(&fbc->list);
 	mutex_lock(&percpu_counters_lock);
 	list_add(&fbc->list, &percpu_counters);
 	mutex_unlock(&percpu_counters_lock);
_

Patches currently in -mm which might be from itoumsn@nttdata.co.jp are

percpu-fix-list_head-init-bug-in-__percpu_counter_init.patch

