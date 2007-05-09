From: akpm@linux-foundation.org
Subject: - flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:58 -0700
Message-ID: <200705092150.l49LowIE002844@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580AbXEIVvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:51:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ego@in.ibm.com, oleg@tv-sign.ru, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     flush_workqueue(): use preempt_disable to hold off cpu hotplug
has been removed from the -mm tree.  Its filename was
     flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: flush_workqueue(): use preempt_disable to hold off cpu hotplug
From: Andrew Morton <akpm@osdl.org>

Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN kernel/workqueue.c~flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug kernel/workqueue.c
--- a/kernel/workqueue.c~flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug
+++ a/kernel/workqueue.c
@@ -419,18 +419,22 @@ static void flush_cpu_workqueue(struct c
 		 * Probably keventd trying to flush its own queue. So simply run
 		 * it by hand rather than deadlocking.
 		 */
-		mutex_unlock(&workqueue_mutex);
+		preempt_enable();
+		/*
+		 * We can still touch *cwq here because we are keventd, and
+		 * hot-unplug will be waiting us to exit.
+		 */
 		run_workqueue(cwq);
-		mutex_lock(&workqueue_mutex);
+		preempt_disable();
 	} else {
 		struct wq_barrier barr;
 
 		init_wq_barrier(&barr);
 		__queue_work(cwq, &barr.work);
 
-		mutex_unlock(&workqueue_mutex);
+		preempt_enable();	/* Can no longer touch *cwq */
 		wait_for_completion(&barr.done);
-		mutex_lock(&workqueue_mutex);
+		preempt_disable();
 	}
 }
 
@@ -449,7 +453,7 @@ static void flush_cpu_workqueue(struct c
  */
 void fastcall flush_workqueue(struct workqueue_struct *wq)
 {
-	mutex_lock(&workqueue_mutex);
+	preempt_disable();		/* CPU hotplug */
 	if (is_single_threaded(wq)) {
 		/* Always use first cpu's area. */
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, singlethread_cpu));
@@ -459,7 +463,7 @@ void fastcall flush_workqueue(struct wor
 		for_each_online_cpu(cpu)
 			flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 	}
-	mutex_unlock(&workqueue_mutex);
+	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
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
