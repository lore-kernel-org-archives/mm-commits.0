From: akpm@linux-foundation.org
Subject: - freezer-make-kernel-threads-nonfreezable-by-default.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:42 -0700
Message-ID: <200707172301.l6HN1gC2011428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935116AbXGQXRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:17:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ego@in.ibm.com, nigel@nigel.suspend2.net, oleg@tv-sign.ru, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Freezer: make kernel threads nonfreezable by default
has been removed from the -mm tree.  Its filename was
     freezer-make-kernel-threads-nonfreezable-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Freezer: make kernel threads nonfreezable by default
From: Rafael J. Wysocki <rjw@sisk.pl>

Currently, the freezer treats all tasks as freezable, except for the kernel
threads that explicitly set the PF_NOFREEZE flag for themselves.  This
approach is problematic, since it requires every kernel thread to either
set PF_NOFREEZE explicitly, or call try_to_freeze(), even if it doesn't
care for the freezing of tasks at all.

It seems better to only require the kernel threads that want to or need to
be frozen to use some freezer-related code and to remove any
freezer-related code from the other (nonfreezable) kernel threads, which is
done in this patch.

The patch causes all kernel threads to be nonfreezable by default (ie.  to
have PF_NOFREEZE set by default) and introduces the set_freezable()
function that should be called by the freezable kernel threads in order to
unset PF_NOFREEZE.  It also makes all of the currently freezable kernel
threads call set_freezable(), so it shouldn't cause any (intentional)
change of behaviour to appear.  Additionally, it updates documentation to
describe the freezing of tasks more accurately.

[akpm@linux-foundation.org: build fixes]
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/freezing-of-tasks.txt |  160 ++++++++++++++++++++
 Documentation/power/kernel_threads.txt    |   40 -----
 Documentation/power/swsusp.txt            |   18 --
 arch/i386/kernel/apm.c                    |    2 
 arch/i386/kernel/io_apic.c                |    1 
 drivers/block/loop.c                      |    8 -
 drivers/block/pktcdvd.c                   |    1 
 drivers/char/apm-emulation.c              |   12 -
 drivers/char/hvc_console.c                |    1 
 drivers/edac/edac_mc.c                    |    1 
 drivers/ieee1394/ieee1394_core.c          |    3 
 drivers/ieee1394/nodemgr.c                |    1 
 drivers/input/gameport/gameport.c         |    1 
 drivers/input/serio/serio.c               |    1 
 drivers/input/touchscreen/ucb1400_ts.c    |    1 
 drivers/macintosh/therm_adt746x.c         |    1 
 drivers/macintosh/windfarm_core.c         |    1 
 drivers/md/md.c                           |    1 
 drivers/media/dvb/dvb-core/dvb_frontend.c |    1 
 drivers/media/video/cx88/cx88-tvaudio.c   |    1 
 drivers/media/video/msp3400-kthreads.c    |    6 
 drivers/media/video/tvaudio.c             |    2 
 drivers/media/video/video-buf-dvb.c       |    1 
 drivers/media/video/vivi.c                |    1 
 drivers/mfd/ucb1x00-ts.c                  |    1 
 drivers/mmc/card/queue.c                  |    7 
 drivers/mtd/mtd_blkdevs.c                 |    3 
 drivers/mtd/ubi/wl.c                      |    1 
 drivers/net/wireless/airo.c               |    3 
 drivers/net/wireless/libertas/main.c      |    1 
 drivers/pcmcia/cs.c                       |    1 
 drivers/pnp/pnpbios/core.c                |    1 
 drivers/scsi/libsas/sas_scsi_host.c       |    3 
 drivers/scsi/scsi_error.c                 |    3 
 drivers/usb/atm/ueagle-atm.c              |    1 
 drivers/usb/core/hub.c                    |    1 
 drivers/usb/gadget/file_storage.c         |    3 
 drivers/usb/storage/usb.c                 |    3 
 drivers/video/ps3fb.c                     |    1 
 drivers/w1/w1.c                           |    1 
 fs/cifs/cifsfs.c                          |    1 
 fs/cifs/connect.c                         |    1 
 fs/jffs2/background.c                     |    1 
 fs/lockd/svc.c                            |    2 
 fs/nfs/callback.c                         |    2 
 fs/nfsd/nfssvc.c                          |    2 
 fs/xfs/linux-2.6/xfs_super.c              |    1 
 include/linux/freezer.h                   |   14 +
 init/do_mounts_initrd.c                   |    7 
 kernel/audit.c                            |    1 
 kernel/exit.c                             |    6 
 kernel/fork.c                             |    2 
 kernel/rcutorture.c                       |    4 
 kernel/rtmutex-tester.c                   |    1 
 kernel/sched.c                            |    3 
 kernel/softirq.c                          |    3 
 kernel/softlockup.c                       |    2 
 kernel/workqueue.c                        |    4 
 mm/pdflush.c                              |    1 
 mm/vmscan.c                               |    1 
 net/bluetooth/bnep/core.c                 |    2 
 net/bluetooth/cmtp/core.c                 |    2 
 net/bluetooth/hidp/core.c                 |    2 
 net/bluetooth/rfcomm/core.c               |    2 
 net/core/pktgen.c                         |    2 
 65 files changed, 256 insertions(+), 113 deletions(-)

diff -puN /dev/null Documentation/power/freezing-of-tasks.txt
--- /dev/null
+++ a/Documentation/power/freezing-of-tasks.txt
@@ -0,0 +1,160 @@
+Freezing of tasks
+	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
+
+I. What is the freezing of tasks?
+
+The freezing of tasks is a mechanism by which user space processes and some
+kernel threads are controlled during hibernation or system-wide suspend (on some
+architectures).
+
+II. How does it work?
+
+There are four per-task flags used for that, PF_NOFREEZE, PF_FROZEN, TIF_FREEZE
+and PF_FREEZER_SKIP (the last one is auxiliary).  The tasks that have
+PF_NOFREEZE unset (all user space processes and some kernel threads) are
+regarded as 'freezable' and treated in a special way before the system enters a
+suspend state as well as before a hibernation image is created (in what follows
+we only consider hibernation, but the description also applies to suspend).
+
+Namely, as the first step of the hibernation procedure the function
+freeze_processes() (defined in kernel/power/process.c) is called.  It executes
+try_to_freeze_tasks() that sets TIF_FREEZE for all of the freezable tasks and
+sends a fake signal to each of them.  A task that receives such a signal and has
+TIF_FREEZE set, should react to it by calling the refrigerator() function
+(defined in kernel/power/process.c), which sets the task's PF_FROZEN flag,
+changes its state to TASK_UNINTERRUPTIBLE and makes it loop until PF_FROZEN is
+cleared for it.  Then, we say that the task is 'frozen' and therefore the set of
+functions handling this mechanism is called 'the freezer' (these functions are
+defined in kernel/power/process.c and include/linux/freezer.h).  User space
+processes are generally frozen before kernel threads.
+
+It is not recommended to call refrigerator() directly.  Instead, it is
+recommended to use the try_to_freeze() function (defined in
+include/linux/freezer.h), that checks the task's TIF_FREEZE flag and makes the
+task enter refrigerator() if the flag is set.
+
+For user space processes try_to_freeze() is called automatically from the
+signal-handling code, but the freezable kernel threads need to call it
+explicitly in suitable places.  The code to do this may look like the following:
+
+	do {
+		hub_events();
+		wait_event_interruptible(khubd_wait,
+					!list_empty(&hub_event_list));
+		try_to_freeze();
+	} while (!signal_pending(current));
+
+(from drivers/usb/core/hub.c::hub_thread()).
+
+If a freezable kernel thread fails to call try_to_freeze() after the freezer has
+set TIF_FREEZE for it, the freezing of tasks will fail and the entire
+hibernation operation will be cancelled.  For this reason, freezable kernel
+threads must call try_to_freeze() somewhere.
+
+After the system memory state has been restored from a hibernation image and
+devices have been reinitialized, the function thaw_processes() is called in
+order to clear the PF_FROZEN flag for each frozen task.  Then, the tasks that
+have been frozen leave refrigerator() and continue running.
+
+III. Which kernel threads are freezable?
+
+Kernel threads are not freezable by default.  However, a kernel thread may clear
+PF_NOFREEZE for itself by calling set_freezable() (the resetting of PF_NOFREEZE
+directly is strongly discouraged).  From this point it is regarded as freezable
+and must call try_to_freeze() in a suitable place.
+
+IV. Why do we do that?
+
+Generally speaking, there is a couple of reasons to use the freezing of tasks:
+
+1. The principal reason is to prevent filesystems from being damaged after
+hibernation.  At the moment we have no simple means of checkpointing
+filesystems, so if there are any modifications made to filesystem data and/or
+metadata on disks, we cannot bring them back to the state from before the
+modifications.  At the same time each hibernation image contains some
+filesystem-related information that must be consistent with the state of the
+on-disk data and metadata after the system memory state has been restored from
+the image (otherwise the filesystems will be damaged in a nasty way, usually
+making them almost impossible to repair).  We therefore freeze tasks that might
+cause the on-disk filesystems' data and metadata to be modified after the
+hibernation image has been created and before the system is finally powered off.
+The majority of these are user space processes, but if any of the kernel threads
+may cause something like this to happen, they have to be freezable.
+
+2. The second reason is to prevent user space processes and some kernel threads
+from interfering with the suspending and resuming of devices.  A user space
+process running on a second CPU while we are suspending devices may, for
+example, be troublesome and without the freezing of tasks we would need some
+safeguards against race conditions that might occur in such a case.
+
+Although Linus Torvalds doesn't like the freezing of tasks, he said this in one
+of the discussions on LKML (http://lkml.org/lkml/2007/4/27/608):
+
+"RJW:> Why we freeze tasks at all or why we freeze kernel threads?
+
+Linus: In many ways, 'at all'.
+
+I _do_ realize the IO request queue issues, and that we cannot actually do
+s2ram with some devices in the middle of a DMA.  So we want to be able to
+avoid *that*, there's no question about that.  And I suspect that stopping
+user threads and then waiting for a sync is practically one of the easier
+ways to do so.
+
+So in practice, the 'at all' may become a 'why freeze kernel threads?' and
+freezing user threads I don't find really objectionable."
+
+Still, there are kernel threads that may want to be freezable.  For example, if
+a kernel that belongs to a device driver accesses the device directly, it in
+principle needs to know when the device is suspended, so that it doesn't try to
+access it at that time.  However, if the kernel thread is freezable, it will be
+frozen before the driver's .suspend() callback is executed and it will be
+thawed after the driver's .resume() callback has run, so it won't be accessing
+the device while it's suspended.
+
+3. Another reason for freezing tasks is to prevent user space processes from
+realizing that hibernation (or suspend) operation takes place.  Ideally, user
+space processes should not notice that such a system-wide operation has occurred
+and should continue running without any problems after the restore (or resume
+from suspend).  Unfortunately, in the most general case this is quite difficult
+to achieve without the freezing of tasks.  Consider, for example, a process
+that depends on all CPUs being online while it's running.  Since we need to
+disable nonboot CPUs during the hibernation, if this process is not frozen, it
+may notice that the number of CPUs has changed and may start to work incorrectly
+because of that.
+
+V. Are there any problems related to the freezing of tasks?
+
+Yes, there are.
+
+First of all, the freezing of kernel threads may be tricky if they depend one
+on another.  For example, if kernel thread A waits for a completion (in the
+TASK_UNINTERRUPTIBLE state) that needs to be done by freezable kernel thread B
+and B is frozen in the meantime, then A will be blocked until B is thawed, which
+may be undesirable.  That's why kernel threads are not freezable by default.
+
+Second, there are the following two problems related to the freezing of user
+space processes:
+1. Putting processes into an uninterruptible sleep distorts the load average.
+2. Now that we have FUSE, plus the framework for doing device drivers in
+userspace, it gets even more complicated because some userspace processes are
+now doing the sorts of things that kernel threads do
+(https://lists.linux-foundation.org/pipermail/linux-pm/2007-May/012309.html).
+
+The problem 1. seems to be fixable, although it hasn't been fixed so far.  The
+other one is more serious, but it seems that we can work around it by using
+hibernation (and suspend) notifiers (in that case, though, we won't be able to
+avoid the realization by the user space processes that the hibernation is taking
+place).
+
+There are also problems that the freezing of tasks tends to expose, although
+they are not directly related to it.  For example, if request_firmware() is
+called from a device driver's .resume() routine, it will timeout and eventually
+fail, because the user land process that should respond to the request is frozen
+at this point.  So, seemingly, the failure is due to the freezing of tasks.
+Suppose, however, that the firmware file is located on a filesystem accessible
+only through another device that hasn't been resumed yet.  In that case,
+request_firmware() will fail regardless of whether or not the freezing of tasks
+is used.  Consequently, the problem is not really related to the freezing of
+tasks, since it generally exists anyway.  [The solution to this particular
+problem is to keep the firmware in memory after it's loaded for the first time
+and upload if from memory to the device whenever necessary.]
diff -puN Documentation/power/kernel_threads.txt~freezer-make-kernel-threads-nonfreezable-by-default /dev/null
--- a/Documentation/power/kernel_threads.txt
+++ /dev/null
@@ -1,40 +0,0 @@
-KERNEL THREADS
-
-
-Freezer
-
-Upon entering a suspended state the system will freeze all
-tasks. This is done by delivering pseudosignals. This affects
-kernel threads, too. To successfully freeze a kernel thread
-the thread has to check for the pseudosignal and enter the
-refrigerator. Code to do this looks like this:
-
-	do {
-		hub_events();
-		wait_event_interruptible(khubd_wait, !list_empty(&hub_event_list));
-		try_to_freeze();
-	} while (!signal_pending(current));
-
-from drivers/usb/core/hub.c::hub_thread()
-
-
-The Unfreezable
-
-Some kernel threads however, must not be frozen. The kernel must
-be able to finish pending IO operations and later on be able to
-write the memory image to disk. Kernel threads needed to do IO
-must stay awake. Such threads must mark themselves unfreezable
-like this:
-
-	/*
-	 * This thread doesn't need any user-level access,
-	 * so get rid of all our resources.
-	 */
-	daemonize("usb-storage");
-
-	current->flags |= PF_NOFREEZE;
-
-from drivers/usb/storage/usb.c::usb_stor_control_thread()
-
-Such drivers are themselves responsible for staying quiet during
-the actual snapshotting.
diff -puN Documentation/power/swsusp.txt~freezer-make-kernel-threads-nonfreezable-by-default Documentation/power/swsusp.txt
--- a/Documentation/power/swsusp.txt~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/Documentation/power/swsusp.txt
@@ -140,21 +140,11 @@ should be sent to the mailing list avail
 website, and not to the Linux Kernel Mailing List. We are working
 toward merging suspend2 into the mainline kernel.
 
-Q: A kernel thread must voluntarily freeze itself (call 'refrigerator').
-I found some kernel threads that don't do it, and they don't freeze
-so the system can't sleep. Is this a known behavior?
-
-A: All such kernel threads need to be fixed, one by one. Select the
-place where the thread is safe to be frozen (no kernel semaphores
-should be held at that point and it must be safe to sleep there), and
-add:
-
-       try_to_freeze();
-
-If the thread is needed for writing the image to storage, you should
-instead set the PF_NOFREEZE process flag when creating the thread (and
-be very careful).
+Q: What is the freezing of tasks and why are we using it?
 
+A: The freezing of tasks is a mechanism by which user space processes and some
+kernel threads are controlled during hibernation or system-wide suspend (on some
+architectures).  See freezing-of-tasks.txt for details.
 
 Q: What is the difference between "platform" and "shutdown"?
 
diff -puN arch/i386/kernel/apm.c~freezer-make-kernel-threads-nonfreezable-by-default arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/arch/i386/kernel/apm.c
@@ -222,6 +222,7 @@
 #include <linux/capability.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/freezer.h>
 #include <linux/smp.h>
 #include <linux/dmi.h>
 #include <linux/suspend.h>
@@ -2311,7 +2312,6 @@ static int __init apm_init(void)
 		remove_proc_entry("apm", NULL);
 		return err;
 	}
-	kapmd_task->flags |= PF_NOFREEZE;
 	wake_up_process(kapmd_task);
 
 	if (num_online_cpus() > 1 && !smp ) {
diff -puN arch/i386/kernel/io_apic.c~freezer-make-kernel-threads-nonfreezable-by-default arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/arch/i386/kernel/io_apic.c
@@ -667,6 +667,7 @@ static int balanced_irq(void *unused)
 		set_pending_irq(i, cpumask_of_cpu(0));
 	}
 
+	set_freezable();
 	for ( ; ; ) {
 		time_remaining = schedule_timeout_interruptible(time_remaining);
 		try_to_freeze();
diff -puN drivers/block/loop.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/block/loop.c
--- a/drivers/block/loop.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/block/loop.c
@@ -68,6 +68,7 @@
 #include <linux/loop.h>
 #include <linux/compat.h>
 #include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>		/* for invalidate_bdev() */
 #include <linux/completion.h>
@@ -600,13 +601,6 @@ static int loop_thread(void *data)
 	struct loop_device *lo = data;
 	struct bio *bio;
 
-	/*
-	 * loop can be used in an encrypted device,
-	 * hence, it mustn't be stopped at all
-	 * because it could be indirectly used during suspension
-	 */
-	current->flags |= PF_NOFREEZE;
-
 	set_user_nice(current, -20);
 
 	while (!kthread_should_stop() || lo->lo_bio) {
diff -puN drivers/block/pktcdvd.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/block/pktcdvd.c
@@ -1593,6 +1593,7 @@ static int kcdrwd(void *foobar)
 	long min_sleep_time, residue;
 
 	set_user_nice(current, -20);
+	set_freezable();
 
 	for (;;) {
 		DECLARE_WAITQUEUE(wait, current);
diff -puN drivers/char/apm-emulation.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/char/apm-emulation.c
--- a/drivers/char/apm-emulation.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/char/apm-emulation.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>
 #include <linux/pm.h>
 #include <linux/apm-emulation.h>
+#include <linux/freezer.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -329,13 +330,8 @@ apm_ioctl(struct inode * inode, struct f
 			/*
 			 * Wait for the suspend/resume to complete.  If there
 			 * are pending acknowledges, we wait here for them.
-			 *
-			 * Note: we need to ensure that the PM subsystem does
-			 * not kick us out of the wait when it suspends the
-			 * threads.
 			 */
 			flags = current->flags;
-			current->flags |= PF_NOFREEZE;
 
 			wait_event(apm_suspend_waitqueue,
 				   as->suspend_state == SUSPEND_DONE);
@@ -365,13 +361,8 @@ apm_ioctl(struct inode * inode, struct f
 			/*
 			 * Wait for the suspend/resume to complete.  If there
 			 * are pending acknowledges, we wait here for them.
-			 *
-			 * Note: we need to ensure that the PM subsystem does
-			 * not kick us out of the wait when it suspends the
-			 * threads.
 			 */
 			flags = current->flags;
-			current->flags |= PF_NOFREEZE;
 
 			wait_event_interruptible(apm_suspend_waitqueue,
 					 as->suspend_state == SUSPEND_DONE);
@@ -598,7 +589,6 @@ static int __init apm_init(void)
 		kapmd_tsk = NULL;
 		return ret;
 	}
-	kapmd_tsk->flags |= PF_NOFREEZE;
 	wake_up_process(kapmd_tsk);
 
 #ifdef CONFIG_PROC_FS
diff -puN drivers/char/hvc_console.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/char/hvc_console.c
--- a/drivers/char/hvc_console.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/char/hvc_console.c
@@ -679,6 +679,7 @@ static int khvcd(void *unused)
 	int poll_mask;
 	struct hvc_struct *hp;
 
+	set_freezable();
 	__set_current_state(TASK_RUNNING);
 	do {
 		poll_mask = 0;
diff -puN drivers/edac/edac_mc.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/edac/edac_mc.c
@@ -1906,6 +1906,7 @@ static void do_edac_check(void)
 
 static int edac_kernel_thread(void *arg)
 {
+	set_freezable();
 	while (!kthread_should_stop()) {
 		do_edac_check();
 
diff -puN drivers/ieee1394/ieee1394_core.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/ieee1394/ieee1394_core.c
--- a/drivers/ieee1394/ieee1394_core.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/ieee1394/ieee1394_core.c
@@ -30,6 +30,7 @@
 #include <linux/moduleparam.h>
 #include <linux/bitops.h>
 #include <linux/kdev_t.h>
+#include <linux/freezer.h>
 #include <linux/suspend.h>
 #include <linux/kthread.h>
 #include <linux/preempt.h>
@@ -1128,8 +1129,6 @@ static int hpsbpkt_thread(void *__hi)
 	struct list_head tmp;
 	int may_schedule;
 
-	current->flags |= PF_NOFREEZE;
-
 	while (!kthread_should_stop()) {
 
 		INIT_LIST_HEAD(&tmp);
diff -puN drivers/ieee1394/nodemgr.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/ieee1394/nodemgr.c
--- a/drivers/ieee1394/nodemgr.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/ieee1394/nodemgr.c
@@ -1699,6 +1699,7 @@ static int nodemgr_host_thread(void *__h
 	unsigned int g, generation = 0;
 	int i, reset_cycles = 0;
 
+	set_freezable();
 	/* Setup our device-model entries */
 	nodemgr_create_host_dev_files(host);
 
diff -puN drivers/input/gameport/gameport.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/input/gameport/gameport.c
--- a/drivers/input/gameport/gameport.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/input/gameport/gameport.c
@@ -445,6 +445,7 @@ static struct gameport *gameport_get_pen
 
 static int gameport_thread(void *nothing)
 {
+	set_freezable();
 	do {
 		gameport_handle_event();
 		wait_event_interruptible(gameport_wait,
diff -puN drivers/input/serio/serio.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/input/serio/serio.c
--- a/drivers/input/serio/serio.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/input/serio/serio.c
@@ -384,6 +384,7 @@ static struct serio *serio_get_pending_c
 
 static int serio_thread(void *nothing)
 {
+	set_freezable();
 	do {
 		serio_handle_event();
 		wait_event_interruptible(serio_wait,
diff -puN drivers/input/touchscreen/ucb1400_ts.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/input/touchscreen/ucb1400_ts.c
--- a/drivers/input/touchscreen/ucb1400_ts.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/input/touchscreen/ucb1400_ts.c
@@ -292,6 +292,7 @@ static int ucb1400_ts_thread(void *_ucb)
 
 	sched_setscheduler(tsk, SCHED_FIFO, &param);
 
+	set_freezable();
 	while (!kthread_should_stop()) {
 		unsigned int x, y, p;
 		long timeout;
diff -puN drivers/macintosh/therm_adt746x.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/macintosh/therm_adt746x.c
--- a/drivers/macintosh/therm_adt746x.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/macintosh/therm_adt746x.c
@@ -335,6 +335,7 @@ static int monitor_task(void *arg)
 {
 	struct thermostat* th = arg;
 
+	set_freezable();
 	while(!kthread_should_stop()) {
 		try_to_freeze();
 		msleep_interruptible(2000);
diff -puN drivers/macintosh/windfarm_core.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/macintosh/windfarm_core.c
--- a/drivers/macintosh/windfarm_core.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/macintosh/windfarm_core.c
@@ -92,6 +92,7 @@ static int wf_thread_func(void *data)
 
 	DBG("wf: thread started\n");
 
+	set_freezable();
 	while(!kthread_should_stop()) {
 		if (time_after_eq(jiffies, next)) {
 			wf_notify(WF_EVENT_TICK, NULL);
diff -puN drivers/md/md.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/md/md.c
--- a/drivers/md/md.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/md/md.c
@@ -4642,7 +4642,6 @@ static int md_thread(void * arg)
 	 * many dirty RAID5 blocks.
 	 */
 
-	current->flags |= PF_NOFREEZE;
 	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 
diff -puN drivers/media/dvb/dvb-core/dvb_frontend.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -523,6 +523,7 @@ static int dvb_frontend_thread(void *dat
 
 	dvb_frontend_init(fe);
 
+	set_freezable();
 	while (1) {
 		up(&fepriv->sem);	    /* is locked when we enter the thread... */
 restart:
diff -puN drivers/media/video/cx88/cx88-tvaudio.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/media/video/cx88/cx88-tvaudio.c
--- a/drivers/media/video/cx88/cx88-tvaudio.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/media/video/cx88/cx88-tvaudio.c
@@ -906,6 +906,7 @@ int cx88_audio_thread(void *data)
 	u32 mode = 0;
 
 	dprintk("cx88: tvaudio thread started\n");
+	set_freezable();
 	for (;;) {
 		msleep_interruptible(1000);
 		if (kthread_should_stop())
diff -puN drivers/media/video/msp3400-kthreads.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/media/video/msp3400-kthreads.c
--- a/drivers/media/video/msp3400-kthreads.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/media/video/msp3400-kthreads.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/freezer.h>
 #include <linux/videodev.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
@@ -468,6 +469,7 @@ int msp3400c_thread(void *data)
 
 
 	v4l_dbg(1, msp_debug, client, "msp3400 daemon started\n");
+	set_freezable();
 	for (;;) {
 		v4l_dbg(2, msp_debug, client, "msp3400 thread: sleep\n");
 		msp_sleep(state, -1);
@@ -646,7 +648,7 @@ int msp3410d_thread(void *data)
 	int val, i, std, count;
 
 	v4l_dbg(1, msp_debug, client, "msp3410 daemon started\n");
-
+	set_freezable();
 	for (;;) {
 		v4l_dbg(2, msp_debug, client, "msp3410 thread: sleep\n");
 		msp_sleep(state,-1);
@@ -940,7 +942,7 @@ int msp34xxg_thread(void *data)
 	int val, i;
 
 	v4l_dbg(1, msp_debug, client, "msp34xxg daemon started\n");
-
+	set_freezable();
 	for (;;) {
 		v4l_dbg(2, msp_debug, client, "msp34xxg thread: sleep\n");
 		msp_sleep(state, -1);
diff -puN drivers/media/video/tvaudio.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/media/video/tvaudio.c
--- a/drivers/media/video/tvaudio.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/media/video/tvaudio.c
@@ -271,7 +271,7 @@ static int chip_thread(void *data)
 	struct CHIPDESC  *desc = chiplist + chip->type;
 
 	v4l_dbg(1, debug, &chip->c, "%s: thread started\n", chip->c.name);
-
+	set_freezable();
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (!kthread_should_stop())
diff -puN drivers/media/video/video-buf-dvb.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/media/video/video-buf-dvb.c
--- a/drivers/media/video/video-buf-dvb.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/media/video/video-buf-dvb.c
@@ -47,6 +47,7 @@ static int videobuf_dvb_thread(void *dat
 	int err;
 
 	dprintk("dvb thread started\n");
+	set_freezable();
 	videobuf_read_start(&dvb->dvbq);
 
 	for (;;) {
diff -puN drivers/media/video/vivi.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/media/video/vivi.c
--- a/drivers/media/video/vivi.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/media/video/vivi.c
@@ -573,6 +573,7 @@ static int vivi_thread(void *data)
 	dprintk(1,"thread started\n");
 
 	mod_timer(&dma_q->timeout, jiffies+BUFFER_TIMEOUT);
+	set_freezable();
 
 	for (;;) {
 		vivi_sleep(dma_q);
diff -puN drivers/mfd/ucb1x00-ts.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/mfd/ucb1x00-ts.c
--- a/drivers/mfd/ucb1x00-ts.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/mfd/ucb1x00-ts.c
@@ -209,6 +209,7 @@ static int ucb1x00_thread(void *_ts)
 	DECLARE_WAITQUEUE(wait, tsk);
 	int valid = 0;
 
+	set_freezable();
 	add_wait_queue(&ts->irq_wait, &wait);
 	while (!kthread_should_stop()) {
 		unsigned int x, y, p;
diff -puN drivers/mmc/card/queue.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/mmc/card/queue.c
--- a/drivers/mmc/card/queue.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/mmc/card/queue.c
@@ -11,6 +11,7 @@
  */
 #include <linux/module.h>
 #include <linux/blkdev.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 
 #include <linux/mmc/card.h>
@@ -44,11 +45,7 @@ static int mmc_queue_thread(void *d)
 	struct mmc_queue *mq = d;
 	struct request_queue *q = mq->queue;
 
-	/*
-	 * Set iothread to ensure that we aren't put to sleep by
-	 * the process freezing.  We handle suspension ourselves.
-	 */
-	current->flags |= PF_MEMALLOC|PF_NOFREEZE;
+	current->flags |= PF_MEMALLOC;
 
 	down(&mq->thread_sem);
 	do {
diff -puN drivers/mtd/mtd_blkdevs.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/mtd/mtd_blkdevs.c
--- a/drivers/mtd/mtd_blkdevs.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/mtd/mtd_blkdevs.c
@@ -16,6 +16,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
+#include <linux/freezer.h>
 #include <linux/spinlock.h>
 #include <linux/hdreg.h>
 #include <linux/init.h>
@@ -80,7 +81,7 @@ static int mtd_blktrans_thread(void *arg
 	struct request_queue *rq = tr->blkcore_priv->rq;
 
 	/* we might get involved when memory gets low, so use PF_MEMALLOC */
-	current->flags |= PF_MEMALLOC | PF_NOFREEZE;
+	current->flags |= PF_MEMALLOC;
 
 	spin_lock_irq(rq->queue_lock);
 	while (!kthread_should_stop()) {
diff -puN drivers/mtd/ubi/wl.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/mtd/ubi/wl.c
--- a/drivers/mtd/ubi/wl.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/mtd/ubi/wl.c
@@ -1346,6 +1346,7 @@ static int ubi_thread(void *u)
 	ubi_msg("background thread \"%s\" started, PID %d",
 		ubi->bgt_name, current->pid);
 
+	set_freezable();
 	for (;;) {
 		int err;
 
diff -puN drivers/net/wireless/airo.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/net/wireless/airo.c
@@ -3086,7 +3086,8 @@ static int airo_thread(void *data) {
 	struct net_device *dev = data;
 	struct airo_info *ai = dev->priv;
 	int locked;
-	
+
+	set_freezable();
 	while(1) {
 		/* make swsusp happy with our thread */
 		try_to_freeze();
diff -puN drivers/net/wireless/libertas/main.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/net/wireless/libertas/main.c
--- a/drivers/net/wireless/libertas/main.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/net/wireless/libertas/main.c
@@ -613,6 +613,7 @@ static int wlan_service_main_thread(void
 
 	init_waitqueue_entry(&wait, current);
 
+	set_freezable();
 	for (;;) {
 		lbs_deb_thread( "main-thread 111: intcounter=%d "
 		       "currenttxskb=%p dnld_sent=%d\n",
diff -puN drivers/pcmcia/cs.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/pcmcia/cs.c
--- a/drivers/pcmcia/cs.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/pcmcia/cs.c
@@ -651,6 +651,7 @@ static int pccardd(void *__skt)
 	add_wait_queue(&skt->thread_wait, &wait);
 	complete(&skt->thread_done);
 
+	set_freezable();
 	for (;;) {
 		unsigned long flags;
 		unsigned int events;
diff -puN drivers/pnp/pnpbios/core.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/pnp/pnpbios/core.c
@@ -160,6 +160,7 @@ static int pnp_dock_thread(void * unused
 {
 	static struct pnp_docking_station_info now;
 	int docked = -1, d = 0;
+	set_freezable();
 	while (!unloading)
 	{
 		int status;
diff -puN drivers/scsi/libsas/sas_scsi_host.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/scsi/libsas/sas_scsi_host.c
@@ -40,6 +40,7 @@
 
 #include <linux/err.h>
 #include <linux/blkdev.h>
+#include <linux/freezer.h>
 #include <linux/scatterlist.h>
 
 /* ---------- SCSI Host glue ---------- */
@@ -868,8 +869,6 @@ static int sas_queue_thread(void *_sas_h
 {
 	struct sas_ha_struct *sas_ha = _sas_ha;
 
-	current->flags |= PF_NOFREEZE;
-
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
diff -puN drivers/scsi/scsi_error.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/scsi/scsi_error.c
@@ -19,6 +19,7 @@
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
@@ -1516,8 +1517,6 @@ int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
 
-	current->flags |= PF_NOFREEZE;
-
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
 	 * counted against the load average as a running process.
diff -puN drivers/usb/atm/ueagle-atm.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/usb/atm/ueagle-atm.c
--- a/drivers/usb/atm/ueagle-atm.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/usb/atm/ueagle-atm.c
@@ -1168,6 +1168,7 @@ static int uea_kthread(void *data)
 	struct uea_softc *sc = data;
 	int ret = -EAGAIN;
 
+	set_freezable();
 	uea_enters(INS_TO_USBDEV(sc));
 	while (!kthread_should_stop()) {
 		if (ret < 0 || sc->reset)
diff -puN drivers/usb/core/hub.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/usb/core/hub.c
@@ -2728,6 +2728,7 @@ loop:
 
 static int hub_thread(void *__unused)
 {
+	set_freezable();
 	do {
 		hub_events();
 		wait_event_interruptible(khubd_wait,
diff -puN drivers/usb/gadget/file_storage.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/usb/gadget/file_storage.c
@@ -3434,6 +3434,9 @@ static int fsg_main_thread(void *fsg_)
 	allow_signal(SIGKILL);
 	allow_signal(SIGUSR1);
 
+	/* Allow the thread to be frozen */
+	set_freezable();
+
 	/* Arrange for userspace references to be interpreted as kernel
 	 * pointers.  That way we can pass a kernel pointer to a routine
 	 * that expects a __user pointer and it will work okay. */
diff -puN drivers/usb/storage/usb.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/usb/storage/usb.c
--- a/drivers/usb/storage/usb.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/usb/storage/usb.c
@@ -311,8 +311,6 @@ static int usb_stor_control_thread(void 
 	struct Scsi_Host *host = us_to_host(us);
 	int autopm_rc;
 
-	current->flags |= PF_NOFREEZE;
-
 	for(;;) {
 		US_DEBUGP("*** thread sleeping.\n");
 		if(down_interruptible(&us->sema))
@@ -920,6 +918,7 @@ static int usb_stor_scan_thread(void * _
 	printk(KERN_DEBUG
 		"usb-storage: device found at %d\n", us->pusb_dev->devnum);
 
+	set_freezable();
 	/* Wait for the timeout to expire or for a disconnect */
 	if (delay_use > 0) {
 		printk(KERN_DEBUG "usb-storage: waiting for device "
diff -puN drivers/video/ps3fb.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/video/ps3fb.c
@@ -812,6 +812,7 @@ static int ps3fb_ioctl(struct fb_info *i
 
 static int ps3fbd(void *arg)
 {
+	set_freezable();
 	while (!kthread_should_stop()) {
 		try_to_freeze();
 		set_current_state(TASK_INTERRUPTIBLE);
diff -puN drivers/w1/w1.c~freezer-make-kernel-threads-nonfreezable-by-default drivers/w1/w1.c
--- a/drivers/w1/w1.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/drivers/w1/w1.c
@@ -805,6 +805,7 @@ static int w1_control(void *data)
 	struct w1_master *dev, *n;
 	int have_to_wait = 0;
 
+	set_freezable();
 	while (!kthread_should_stop() || have_to_wait) {
 		have_to_wait = 0;
 
diff -puN fs/cifs/cifsfs.c~freezer-make-kernel-threads-nonfreezable-by-default fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/fs/cifs/cifsfs.c
@@ -849,6 +849,7 @@ static int cifs_oplock_thread(void * dum
 	__u16  netfid;
 	int rc;
 
+	set_freezable();
 	do {
 		if (try_to_freeze()) 
 			continue;
diff -puN fs/cifs/connect.c~freezer-make-kernel-threads-nonfreezable-by-default fs/cifs/connect.c
--- a/fs/cifs/connect.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/fs/cifs/connect.c
@@ -363,6 +363,7 @@ cifs_demultiplex_thread(struct TCP_Serve
 			GFP_KERNEL);
 	}
 
+	set_freezable();
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
 			continue;
diff -puN fs/jffs2/background.c~freezer-make-kernel-threads-nonfreezable-by-default fs/jffs2/background.c
--- a/fs/jffs2/background.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/fs/jffs2/background.c
@@ -81,6 +81,7 @@ static int jffs2_garbage_collect_thread(
 
 	set_user_nice(current, 10);
 
+	set_freezable();
 	for (;;) {
 		allow_signal(SIGHUP);
 
diff -puN fs/lockd/svc.c~freezer-make-kernel-threads-nonfreezable-by-default fs/lockd/svc.c
--- a/fs/lockd/svc.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/fs/lockd/svc.c
@@ -25,6 +25,7 @@
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 #include <linux/sunrpc/types.h>
 #include <linux/sunrpc/stats.h>
@@ -119,6 +120,7 @@ lockd(struct svc_rqst *rqstp)
 	complete(&lockd_start_done);
 
 	daemonize("lockd");
+	set_freezable();
 
 	/* Process request with signals blocked, but allow SIGKILL.  */
 	allow_signal(SIGKILL);
diff -puN fs/nfs/callback.c~freezer-make-kernel-threads-nonfreezable-by-default fs/nfs/callback.c
--- a/fs/nfs/callback.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/fs/nfs/callback.c
@@ -14,6 +14,7 @@
 #include <linux/sunrpc/svcsock.h>
 #include <linux/nfs_fs.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 #include <net/inet_sock.h>
 
@@ -67,6 +68,7 @@ static void nfs_callback_svc(struct svc_
 	daemonize("nfsv4-svc");
 	/* Process request with signals blocked, but allow SIGKILL.  */
 	allow_signal(SIGKILL);
+	set_freezable();
 
 	complete(&nfs_callback_info.started);
 
diff -puN fs/nfsd/nfssvc.c~freezer-make-kernel-threads-nonfreezable-by-default fs/nfsd/nfssvc.c
--- a/fs/nfsd/nfssvc.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/fs/nfsd/nfssvc.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
+#include <linux/freezer.h>
 #include <linux/fs_struct.h>
 
 #include <linux/sunrpc/types.h>
@@ -432,6 +433,7 @@ nfsd(struct svc_rqst *rqstp)
 	 * dirty pages.
 	 */
 	current->flags |= PF_LESS_THROTTLE;
+	set_freezable();
 
 	/*
 	 * The main request loop
diff -puN fs/xfs/linux-2.6/xfs_super.c~freezer-make-kernel-threads-nonfreezable-by-default fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -562,6 +562,7 @@ xfssyncd(
 	bhv_vfs_sync_work_t	*work, *n;
 	LIST_HEAD		(tmp);
 
+	set_freezable();
 	timeleft = xfs_syncd_centisecs * msecs_to_jiffies(10);
 	for (;;) {
 		timeleft = schedule_timeout_interruptible(timeleft);
diff -puN include/linux/freezer.h~freezer-make-kernel-threads-nonfreezable-by-default include/linux/freezer.h
--- a/include/linux/freezer.h~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/include/linux/freezer.h
@@ -1,5 +1,8 @@
 /* Freezer declarations */
 
+#ifndef FREEZER_H_INCLUDED
+#define FREEZER_H_INCLUDED
+
 #include <linux/sched.h>
 
 #ifdef CONFIG_PM
@@ -115,6 +118,14 @@ static inline int freezer_should_skip(st
 	return !!(p->flags & PF_FREEZER_SKIP);
 }
 
+/*
+ * Tell the freezer that the current task should be frozen by it
+ */
+static inline void set_freezable(void)
+{
+	current->flags &= ~PF_NOFREEZE;
+}
+
 #else
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
@@ -130,4 +141,7 @@ static inline int try_to_freeze(void) { 
 static inline void freezer_do_not_count(void) {}
 static inline void freezer_count(void) {}
 static inline int freezer_should_skip(struct task_struct *p) { return 0; }
+static inline void set_freezable(void) {}
 #endif
+
+#endif	/* FREEZER_H_INCLUDED */
diff -puN init/do_mounts_initrd.c~freezer-make-kernel-threads-nonfreezable-by-default init/do_mounts_initrd.c
--- a/init/do_mounts_initrd.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/init/do_mounts_initrd.c
@@ -56,12 +56,9 @@ static void __init handle_initrd(void)
 	sys_chroot(".");
 
 	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
-	if (pid > 0) {
-		while (pid != sys_wait4(-1, NULL, 0, NULL)) {
-			try_to_freeze();
+	if (pid > 0)
+		while (pid != sys_wait4(-1, NULL, 0, NULL))
 			yield();
-		}
-	}
 
 	/* move initrd to rootfs' /old */
 	sys_fchdir(old_fd);
diff -puN kernel/audit.c~freezer-make-kernel-threads-nonfreezable-by-default kernel/audit.c
--- a/kernel/audit.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/kernel/audit.c
@@ -392,6 +392,7 @@ static int kauditd_thread(void *dummy)
 {
 	struct sk_buff *skb;
 
+	set_freezable();
 	while (!kthread_should_stop()) {
 		skb = skb_dequeue(&audit_skb_queue);
 		wake_up(&audit_backlog_wait);
diff -puN kernel/exit.c~freezer-make-kernel-threads-nonfreezable-by-default kernel/exit.c
--- a/kernel/exit.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/kernel/exit.c
@@ -31,6 +31,7 @@
 #include <linux/mempolicy.h>
 #include <linux/taskstats_kern.h>
 #include <linux/delayacct.h>
+#include <linux/freezer.h>
 #include <linux/cpuset.h>
 #include <linux/syscalls.h>
 #include <linux/signal.h>
@@ -387,6 +388,11 @@ void daemonize(const char *name, ...)
 	 * they would be locked into memory.
 	 */
 	exit_mm(current);
+	/*
+	 * We don't want to have TIF_FREEZE set if the system-wide hibernation
+	 * or suspend transition begins right now.
+	 */
+	current->flags |= PF_NOFREEZE;
 
 	set_special_pids(1, 1);
 	proc_clear_tty(current);
diff -puN kernel/fork.c~freezer-make-kernel-threads-nonfreezable-by-default kernel/fork.c
--- a/kernel/fork.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/kernel/fork.c
@@ -923,7 +923,7 @@ static inline void copy_flags(unsigned l
 {
 	unsigned long new_flags = p->flags;
 
-	new_flags &= ~(PF_SUPERPRIV | PF_NOFREEZE);
+	new_flags &= ~PF_SUPERPRIV;
 	new_flags |= PF_FORKNOEXEC;
 	if (!(clone_flags & CLONE_PTRACE))
 		p->ptrace = 0;
diff -puN kernel/rcutorture.c~freezer-make-kernel-threads-nonfreezable-by-default kernel/rcutorture.c
--- a/kernel/rcutorture.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/kernel/rcutorture.c
@@ -40,6 +40,7 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
+#include <linux/freezer.h>
 #include <linux/cpu.h>
 #include <linux/random.h>
 #include <linux/delay.h>
@@ -518,7 +519,6 @@ rcu_torture_writer(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	do {
 		schedule_timeout_uninterruptible(1);
@@ -558,7 +558,6 @@ rcu_torture_fakewriter(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	do {
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
@@ -589,7 +588,6 @@ rcu_torture_reader(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	do {
 		idx = cur_ops->readlock();
diff -puN kernel/rtmutex-tester.c~freezer-make-kernel-threads-nonfreezable-by-default kernel/rtmutex-tester.c
--- a/kernel/rtmutex-tester.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/kernel/rtmutex-tester.c
@@ -260,6 +260,7 @@ static int test_func(void *data)
 	int ret;
 
 	current->flags |= PF_MUTEX_TESTER;
+	set_freezable();
 	allow_signal(SIGHUP);
 
 	for(;;) {
diff -puN kernel/sched.c~freezer-make-kernel-threads-nonfreezable-by-default kernel/sched.c
--- a/kernel/sched.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/kernel/sched.c
@@ -4912,8 +4912,6 @@ static int migration_thread(void *data)
 		struct migration_req *req;
 		struct list_head *head;
 
-		try_to_freeze();
-
 		spin_lock_irq(&rq->lock);
 
 		if (cpu_is_offline(cpu)) {
@@ -5147,7 +5145,6 @@ migration_call(struct notifier_block *nf
 		p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
-		p->flags |= PF_NOFREEZE;
 		kthread_bind(p, cpu);
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
diff -puN kernel/softirq.c~freezer-make-kernel-threads-nonfreezable-by-default kernel/softirq.c
--- a/kernel/softirq.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/kernel/softirq.c
@@ -14,6 +14,7 @@
 #include <linux/notifier.h>
 #include <linux/percpu.h>
 #include <linux/cpu.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
@@ -488,8 +489,6 @@ void __init softirq_init(void)
 
 static int ksoftirqd(void * __bind_cpu)
 {
-	current->flags |= PF_NOFREEZE;
-
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!kthread_should_stop()) {
diff -puN kernel/softlockup.c~freezer-make-kernel-threads-nonfreezable-by-default kernel/softlockup.c
--- a/kernel/softlockup.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/kernel/softlockup.c
@@ -10,6 +10,7 @@
 #include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
@@ -116,7 +117,6 @@ static int watchdog(void * __bind_cpu)
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
-	current->flags |= PF_NOFREEZE;
 
 	/* initialize timestamp */
 	touch_softlockup_watchdog();
diff -puN kernel/workqueue.c~freezer-make-kernel-threads-nonfreezable-by-default kernel/workqueue.c
--- a/kernel/workqueue.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/kernel/workqueue.c
@@ -282,8 +282,8 @@ static int worker_thread(void *__cwq)
 	struct cpu_workqueue_struct *cwq = __cwq;
 	DEFINE_WAIT(wait);
 
-	if (!cwq->wq->freezeable)
-		current->flags |= PF_NOFREEZE;
+	if (cwq->wq->freezeable)
+		set_freezable();
 
 	set_user_nice(current, -5);
 
diff -puN mm/pdflush.c~freezer-make-kernel-threads-nonfreezable-by-default mm/pdflush.c
--- a/mm/pdflush.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/mm/pdflush.c
@@ -92,6 +92,7 @@ struct pdflush_work {
 static int __pdflush(struct pdflush_work *my_work)
 {
 	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
+	set_freezable();
 	my_work->fn = NULL;
 	my_work->who = current;
 	INIT_LIST_HEAD(&my_work->list);
diff -puN mm/vmscan.c~freezer-make-kernel-threads-nonfreezable-by-default mm/vmscan.c
--- a/mm/vmscan.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/mm/vmscan.c
@@ -1421,6 +1421,7 @@ static int kswapd(void *p)
 	 * trying to free the first piece of memory in the first place).
 	 */
 	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
+	set_freezable();
 
 	order = 0;
 	for ( ; ; ) {
diff -puN net/bluetooth/bnep/core.c~freezer-make-kernel-threads-nonfreezable-by-default net/bluetooth/bnep/core.c
--- a/net/bluetooth/bnep/core.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/net/bluetooth/bnep/core.c
@@ -36,6 +36,7 @@
 #include <linux/signal.h>
 #include <linux/init.h>
 #include <linux/wait.h>
+#include <linux/freezer.h>
 #include <linux/errno.h>
 #include <linux/net.h>
 #include <net/sock.h>
@@ -474,7 +475,6 @@ static int bnep_session(void *arg)
 
 	daemonize("kbnepd %s", dev->name);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(sk->sk_sleep, &wait);
diff -puN net/bluetooth/cmtp/core.c~freezer-make-kernel-threads-nonfreezable-by-default net/bluetooth/cmtp/core.c
--- a/net/bluetooth/cmtp/core.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/net/bluetooth/cmtp/core.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fcntl.h>
+#include <linux/freezer.h>
 #include <linux/skbuff.h>
 #include <linux/socket.h>
 #include <linux/ioctl.h>
@@ -287,7 +288,6 @@ static int cmtp_session(void *arg)
 
 	daemonize("kcmtpd_ctr_%d", session->num);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(sk->sk_sleep, &wait);
diff -puN net/bluetooth/hidp/core.c~freezer-make-kernel-threads-nonfreezable-by-default net/bluetooth/hidp/core.c
--- a/net/bluetooth/hidp/core.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/net/bluetooth/hidp/core.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
+#include <linux/freezer.h>
 #include <linux/fcntl.h>
 #include <linux/skbuff.h>
 #include <linux/socket.h>
@@ -547,7 +548,6 @@ static int hidp_session(void *arg)
 
 	daemonize("khidpd_%04x%04x", vendor, product);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&ctrl_wait, current);
 	init_waitqueue_entry(&intr_wait, current);
diff -puN net/bluetooth/rfcomm/core.c~freezer-make-kernel-threads-nonfreezable-by-default net/bluetooth/rfcomm/core.c
--- a/net/bluetooth/rfcomm/core.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/net/bluetooth/rfcomm/core.c
@@ -33,6 +33,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/init.h>
+#include <linux/freezer.h>
 #include <linux/wait.h>
 #include <linux/device.h>
 #include <linux/net.h>
@@ -1940,7 +1941,6 @@ static int rfcomm_run(void *unused)
 
 	daemonize("krfcommd");
 	set_user_nice(current, -10);
-	current->flags |= PF_NOFREEZE;
 
 	BT_DBG("");
 
diff -puN net/core/pktgen.c~freezer-make-kernel-threads-nonfreezable-by-default net/core/pktgen.c
--- a/net/core/pktgen.c~freezer-make-kernel-threads-nonfreezable-by-default
+++ a/net/core/pktgen.c
@@ -3465,6 +3465,8 @@ static int pktgen_thread_worker(void *ar
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
+	set_freezable();
+
 	while (!kthread_should_stop()) {
 		pkt_dev = next_to_run(t);
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
pm-reduce-code-duplication-between-mainc-and-userc-updated.patch
acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch
pm-introduce-pm_power_off_prepare.patch
pm-optional-beeping-during-resume-from-suspend-to-ram.patch
pm-integrate-beeping-flag-with-existing-acpi_sleep-flags.patch
pm-remove-deprecated-sysfs-files.patch
pm-remove-deprecated-dpm_runtime_-routines.patch
suspend-maintainers-update.patch
shrink_slab-handle-bad-shrinkers.patch
