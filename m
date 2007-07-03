From: akpm@linux-foundation.org
Subject: + dvb-cinergyt2-fix-flush_workqueue-vs-work-func-deadlock.patch added to -mm tree
Date: Tue, 03 Jul 2007 15:56:00 -0700
Message-ID: <200707032256.l63Mu0im021222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389AbXGCW5K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 18:57:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, daniel@qanu.de, dmitry.torokhov@gmail.com, holger@qanu.de, mchehab@infradead.org, mrechberger@gmail.com, tsattler@gmx.de


The patch titled
     dvb/cinergyT2: fix flush_workqueue() vs work->func() deadlock
has been added to the -mm tree.  Its filename is
     dvb-cinergyt2-fix-flush_workqueue-vs-work-func-deadlock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dvb/cinergyT2: fix flush_workqueue() vs work->func() deadlock
From: Oleg Nesterov <oleg@tv-sign.ru>

Spotted and tested by Thomas Sattler <tsattler@gmx.de>.

cinergyT2.c does cancel_delayed_work() + flush_scheduled_work() while
holding cinergyt2->sem.  This leads to deadlock because work->func() needs
the same mutex to complete.  Another bug is that this code in fact can't
reliably stop the re-arming delayed_work.

Convert this code to use cancel_rearming_delayed_work() and move it out of
->sem.  Another mutex, ->wq_sem, was added to protect against the
concurrent open/resume.

This patch is a horrible hack to fix the lockup which happens in practice. 
As Dmitry Torokhov pointed out this driver has other problems and needs
further changes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Markus Rechberger <mrechberger@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Thomas Sattler <tsattler@gmx.de>
Cc: Daniel Mack <daniel@qanu.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Holger Waechtler <holger@qanu.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/cinergyT2/cinergyT2.c |   65 +++++++++++++---------
 1 files changed, 40 insertions(+), 25 deletions(-)

diff -puN drivers/media/dvb/cinergyT2/cinergyT2.c~dvb-cinergyt2-fix-flush_workqueue-vs-work-func-deadlock drivers/media/dvb/cinergyT2/cinergyT2.c
--- a/drivers/media/dvb/cinergyT2/cinergyT2.c~dvb-cinergyt2-fix-flush_workqueue-vs-work-func-deadlock
+++ a/drivers/media/dvb/cinergyT2/cinergyT2.c
@@ -118,6 +118,7 @@ struct cinergyt2 {
 	struct dvb_demux demux;
 	struct usb_device *udev;
 	struct mutex sem;
+	struct mutex wq_sem;
 	struct dvb_adapter adapter;
 	struct dvb_device *fedev;
 	struct dmxdev dmxdev;
@@ -482,14 +483,14 @@ static int cinergyt2_open (struct inode 
 	struct cinergyt2 *cinergyt2 = dvbdev->priv;
 	int err = -ERESTARTSYS;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
-		return -ERESTARTSYS;
+	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
+		goto out;
 
-	if ((err = dvb_generic_open(inode, file))) {
-		mutex_unlock(&cinergyt2->sem);
-		return err;
-	}
+	if (mutex_lock_interruptible(&cinergyt2->sem))
+		goto out_unlock1;
 
+	if ((err = dvb_generic_open(inode, file)))
+		goto out_unlock2;
 
 	if ((file->f_flags & O_ACCMODE) != O_RDONLY) {
 		cinergyt2_sleep(cinergyt2, 0);
@@ -498,8 +499,12 @@ static int cinergyt2_open (struct inode 
 
 	atomic_inc(&cinergyt2->inuse);
 
+out_unlock2:
 	mutex_unlock(&cinergyt2->sem);
-	return 0;
+out_unlock1:
+	mutex_unlock(&cinergyt2->wq_sem);
+out:
+	return err;
 }
 
 static void cinergyt2_unregister(struct cinergyt2 *cinergyt2)
@@ -519,15 +524,17 @@ static int cinergyt2_release (struct ino
 	struct dvb_device *dvbdev = file->private_data;
 	struct cinergyt2 *cinergyt2 = dvbdev->priv;
 
-	mutex_lock(&cinergyt2->sem);
+	mutex_lock(&cinergyt2->wq_sem);
 
 	if (!cinergyt2->disconnect_pending && (file->f_flags & O_ACCMODE) != O_RDONLY) {
-		cancel_delayed_work(&cinergyt2->query_work);
-		flush_scheduled_work();
+		cancel_rearming_delayed_work(&cinergyt2->query_work);
+
+		mutex_lock(&cinergyt2->sem);
 		cinergyt2_sleep(cinergyt2, 1);
+		mutex_unlock(&cinergyt2->sem);
 	}
 
-	mutex_unlock(&cinergyt2->sem);
+	mutex_unlock(&cinergyt2->wq_sem);
 
 	if (atomic_dec_and_test(&cinergyt2->inuse) && cinergyt2->disconnect_pending) {
 		warn("delayed unregister in release");
@@ -838,13 +845,13 @@ static int cinergyt2_register_rc(struct 
 
 static void cinergyt2_unregister_rc(struct cinergyt2 *cinergyt2)
 {
-	cancel_delayed_work(&cinergyt2->rc_query_work);
+	cancel_rearming_delayed_work(&cinergyt2->rc_query_work);
 	input_unregister_device(cinergyt2->rc_input_dev);
 }
 
 static inline void cinergyt2_suspend_rc(struct cinergyt2 *cinergyt2)
 {
-	cancel_delayed_work(&cinergyt2->rc_query_work);
+	cancel_rearming_delayed_work(&cinergyt2->rc_query_work);
 }
 
 static inline void cinergyt2_resume_rc(struct cinergyt2 *cinergyt2)
@@ -907,6 +914,7 @@ static int cinergyt2_probe (struct usb_i
 	usb_set_intfdata (intf, (void *) cinergyt2);
 
 	mutex_init(&cinergyt2->sem);
+	mutex_init(&cinergyt2->wq_sem);
 	init_waitqueue_head (&cinergyt2->poll_wq);
 	INIT_DELAYED_WORK(&cinergyt2->query_work, cinergyt2_query);
 
@@ -974,11 +982,8 @@ static void cinergyt2_disconnect (struct
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 
-	flush_scheduled_work();
-
 	cinergyt2_unregister_rc(cinergyt2);
-
-	cancel_delayed_work(&cinergyt2->query_work);
+	cancel_rearming_delayed_work(&cinergyt2->query_work);
 	wake_up_interruptible(&cinergyt2->poll_wq);
 
 	cinergyt2->demux.dmx.close(&cinergyt2->demux.dmx);
@@ -992,21 +997,22 @@ static int cinergyt2_suspend (struct usb
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
+	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
 		return -ERESTARTSYS;
 
 	if (1) {
-		struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 
 		cinergyt2_suspend_rc(cinergyt2);
-		cancel_delayed_work(&cinergyt2->query_work);
+		cancel_rearming_delayed_work(&cinergyt2->query_work);
+
+		mutex_lock(&cinergyt2->sem);
 		if (cinergyt2->streaming)
 			cinergyt2_stop_stream_xfer(cinergyt2);
-		flush_scheduled_work();
 		cinergyt2_sleep(cinergyt2, 1);
+		mutex_unlock(&cinergyt2->sem);
 	}
 
-	mutex_unlock(&cinergyt2->sem);
+	mutex_unlock(&cinergyt2->wq_sem);
 	return 0;
 }
 
@@ -1014,9 +1020,15 @@ static int cinergyt2_resume (struct usb_
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 	struct dvbt_set_parameters_msg *param = &cinergyt2->param;
+	int err = -ERESTARTSYS;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
-		return -ERESTARTSYS;
+	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
+		goto out;
+
+	if (mutex_lock_interruptible(&cinergyt2->sem))
+		goto out_unlock1;
+
+	err = 0;
 
 	if (!cinergyt2->sleeping) {
 		cinergyt2_sleep(cinergyt2, 0);
@@ -1029,7 +1041,10 @@ static int cinergyt2_resume (struct usb_
 	cinergyt2_resume_rc(cinergyt2);
 
 	mutex_unlock(&cinergyt2->sem);
-	return 0;
+out_unlock1:
+	mutex_unlock(&cinergyt2->wq_sem);
+out:
+	return err;
 }
 
 static const struct usb_device_id cinergyt2_table [] __devinitdata = {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

dvb-cinergyt2-fix-flush_workqueue-vs-work-func-deadlock.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mm-fix-create_new_namespaces-return-value.patch
adb_probe_task-remove-unneeded-flush_signals-call.patch
kcdrwd-remove-unneeded-flush_signals-call.patch
nbdcsock_xmit-cleanup-signal-related-code.patch
rename-cancel_rearming_delayed_work-to-cancel_delayed_work_sync.patch
make-cancel_xxx_work_sync-return-a-boolean.patch
