From: akpm@linux-foundation.org
Subject: - schedule_on_each_cpu-use-preempt_disable.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:51 -0700
Message-ID: <200705092150.l49Lopme002835@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758396AbXEIVvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:51:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     schedule_on_each_cpu(): use preempt_disable()
has been removed from the -mm tree.  Its filename was
     schedule_on_each_cpu-use-preempt_disable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: schedule_on_each_cpu(): use preempt_disable()
From: Andrew Morton <akpm@osdl.org>

We take workqueue_mutex in there to keep CPU hotplug away.  But
preempt_disable() will suffice for that.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/workqueue.c~schedule_on_each_cpu-use-preempt_disable kernel/workqueue.c
--- a/kernel/workqueue.c~schedule_on_each_cpu-use-preempt_disable
+++ a/kernel/workqueue.c
@@ -638,7 +638,7 @@ int schedule_on_each_cpu(work_func_t fun
 	if (!works)
 		return -ENOMEM;
 
-	mutex_lock(&workqueue_mutex);
+	preempt_disable();		/* CPU hotplug */
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = per_cpu_ptr(works, cpu);
 
@@ -646,7 +646,7 @@ int schedule_on_each_cpu(work_func_t fun
 		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
 		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
 	}
-	mutex_unlock(&workqueue_mutex);
+	preempt_enable();
 	flush_workqueue(keventd_wq);
 	free_percpu(works);
 	return 0;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
git-ieee1394.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
move-page-writeback-acounting-out-of-macros.patch
ext2-reservations.patch
mm-implement-swap-prefetching.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
