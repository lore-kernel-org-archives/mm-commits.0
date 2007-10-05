From: akpm@linux-foundation.org
Subject: - dvb_en_50221-convert-to-kthread-api.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:51 -0700
Message-ID: <200710051956.l95JupKN022407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763547AbXJEUBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@infradead.org, adq_dvb@lidskialf.net, ebiederm@xmission.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     dvb_en_50221: convert to kthread API
has been removed from the -mm tree.  Its filename was
     dvb_en_50221-convert-to-kthread-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dvb_en_50221: convert to kthread API
From: Christoph Hellwig <hch@infradead.org>

Here's an attempted update to the full kthread API + wake_up_process:

Cc: Andrew de Quincey <adq_dvb@lidskialf.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |   84 +++---------------
 1 file changed, 16 insertions(+), 68 deletions(-)

diff -puN drivers/media/dvb/dvb-core/dvb_ca_en50221.c~dvb_en_50221-convert-to-kthread-api drivers/media/dvb/dvb-core/dvb_ca_en50221.c
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c~dvb_en_50221-convert-to-kthread-api
+++ a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -36,6 +36,7 @@
 #include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/sched.h>
+#include <linux/kthread.h>
 
 #include "dvb_ca_en50221.h"
 #include "dvb_ringbuffer.h"
@@ -139,13 +140,7 @@ struct dvb_ca_private {
 	wait_queue_head_t wait_queue;
 
 	/* PID of the monitoring thread */
-	pid_t thread_pid;
-
-	/* Wait queue used when shutting thread down */
-	wait_queue_head_t thread_queue;
-
-	/* Flag indicating when thread should exit */
-	unsigned int exit:1;
+	struct task_struct *thread;
 
 	/* Flag indicating if the CA device is open */
 	unsigned int open:1;
@@ -901,28 +896,10 @@ static void dvb_ca_en50221_thread_wakeup
 
 	ca->wakeup = 1;
 	mb();
-	wake_up_interruptible(&ca->thread_queue);
+	wake_up_process(ca->thread);
 }
 
 /**
- * Used by the CA thread to determine if an early wakeup is necessary
- *
- * @param ca CA instance.
- */
-static int dvb_ca_en50221_thread_should_wakeup(struct dvb_ca_private *ca)
-{
-	if (ca->wakeup) {
-		ca->wakeup = 0;
-		return 1;
-	}
-	if (ca->exit)
-		return 1;
-
-	return 0;
-}
-
-
-/**
  * Update the delay used by the thread.
  *
  * @param ca CA instance.
@@ -981,7 +958,6 @@ static void dvb_ca_en50221_thread_update
 static int dvb_ca_en50221_thread(void *data)
 {
 	struct dvb_ca_private *ca = data;
-	char name[15];
 	int slot;
 	int flags;
 	int status;
@@ -990,28 +966,17 @@ static int dvb_ca_en50221_thread(void *d
 
 	dprintk("%s\n", __FUNCTION__);
 
-	/* setup kernel thread */
-	snprintf(name, sizeof(name), "kdvb-ca-%i:%i", ca->dvbdev->adapter->num, ca->dvbdev->id);
-
-	lock_kernel();
-	daemonize(name);
-	sigfillset(&current->blocked);
-	unlock_kernel();
-
 	/* choose the correct initial delay */
 	dvb_ca_en50221_thread_update_delay(ca);
 
 	/* main loop */
-	while (!ca->exit) {
+	while (!kthread_should_stop()) {
 		/* sleep for a bit */
-		if (!ca->wakeup) {
-			flags = wait_event_interruptible_timeout(ca->thread_queue,
-								 dvb_ca_en50221_thread_should_wakeup(ca),
-								 ca->delay);
-			if ((flags == -ERESTARTSYS) || ca->exit) {
-				/* got signal or quitting */
-				break;
-			}
+		while (!ca->wakeup) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(ca->delay);
+			if (kthread_should_stop())
+				return 0;
 		}
 		ca->wakeup = 0;
 
@@ -1180,10 +1145,6 @@ static int dvb_ca_en50221_thread(void *d
 		}
 	}
 
-	/* completed */
-	ca->thread_pid = 0;
-	mb();
-	wake_up_interruptible(&ca->thread_queue);
 	return 0;
 }
 
@@ -1683,9 +1644,6 @@ int dvb_ca_en50221_init(struct dvb_adapt
 		goto error;
 	}
 	init_waitqueue_head(&ca->wait_queue);
-	ca->thread_pid = 0;
-	init_waitqueue_head(&ca->thread_queue);
-	ca->exit = 0;
 	ca->open = 0;
 	ca->wakeup = 0;
 	ca->next_read_slot = 0;
@@ -1711,14 +1669,14 @@ int dvb_ca_en50221_init(struct dvb_adapt
 	mb();
 
 	/* create a kthread for monitoring this CA device */
-
-	ret = kernel_thread(dvb_ca_en50221_thread, ca, 0);
-
-	if (ret < 0) {
-		printk("dvb_ca_init: failed to start kernel_thread (%d)\n", ret);
+	ca->thread = kthread_run(dvb_ca_en50221_thread, ca, "kdvb-ca-%i:%i",
+				 ca->dvbdev->adapter->num, ca->dvbdev->id);
+	if (IS_ERR(ca->thread)) {
+		ret = PTR_ERR(ca->thread);
+		printk("dvb_ca_init: failed to start kernel_thread (%d)\n",
+			ret);
 		goto error;
 	}
-	ca->thread_pid = ret;
 	return 0;
 
 error:
@@ -1749,17 +1707,7 @@ void dvb_ca_en50221_release(struct dvb_c
 	dprintk("%s\n", __FUNCTION__);
 
 	/* shutdown the thread if there was one */
-	if (ca->thread_pid) {
-		if (kill_proc(ca->thread_pid, 0, 1) == -ESRCH) {
-			printk("dvb_ca_release adapter %d: thread PID %d already died\n",
-			       ca->dvbdev->adapter->num, ca->thread_pid);
-		} else {
-			ca->exit = 1;
-			mb();
-			dvb_ca_en50221_thread_wakeup(ca);
-			wait_event_interruptible(ca->thread_queue, ca->thread_pid == 0);
-		}
-	}
+	kthread_stop(ca->thread);
 
 	for (i = 0; i < ca->slot_count; i++) {
 		dvb_ca_en50221_slot_shutdown(ca, i);
_

Patches currently in -mm which might be from hch@infradead.org are

consolidate-ptrace_detach.patch
git-dvb.patch
git-nfsd.patch
git-scsi-misc.patch
git-xfs.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
introduce-i_sync.patch
r-o-bind-mounts-create-cleanup-helper-svc_msnfs.patch
r-o-bind-mounts-elevate-write-count-opend-files.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-alignment-fix.patch
linux-kernel-markers-documentation.patch
