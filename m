From: akpm@linux-foundation.org
Subject: + dvb_en_50221-convert-to-kthread-api.patch added to -mm tree
Date: Thu, 19 Apr 2007 23:48:14 -0700
Message-ID: <200704200648.l3K6mElF008941@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247AbXDTGsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 02:48:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@infradead.org, adq_dvb@lidskialf.net, ebiederm@xmission.com, mchehab@infradead.org


The patch titled
     dvb_en_50221: convert to kthread API
has been added to the -mm tree.  Its filename is
     dvb_en_50221-convert-to-kthread-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -37,6 +37,7 @@
 #include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/sched.h>
+#include <linux/kthread.h>
 
 #include "dvb_ca_en50221.h"
 #include "dvb_ringbuffer.h"
@@ -140,13 +141,7 @@ struct dvb_ca_private {
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
@@ -902,28 +897,10 @@ static void dvb_ca_en50221_thread_wakeup
 
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
@@ -982,7 +959,6 @@ static void dvb_ca_en50221_thread_update
 static int dvb_ca_en50221_thread(void *data)
 {
 	struct dvb_ca_private *ca = data;
-	char name[15];
 	int slot;
 	int flags;
 	int status;
@@ -991,28 +967,17 @@ static int dvb_ca_en50221_thread(void *d
 
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
 
@@ -1181,10 +1146,6 @@ static int dvb_ca_en50221_thread(void *d
 		}
 	}
 
-	/* completed */
-	ca->thread_pid = 0;
-	mb();
-	wake_up_interruptible(&ca->thread_queue);
 	return 0;
 }
 
@@ -1682,9 +1643,6 @@ int dvb_ca_en50221_init(struct dvb_adapt
 		goto error;
 	}
 	init_waitqueue_head(&ca->wait_queue);
-	ca->thread_pid = 0;
-	init_waitqueue_head(&ca->thread_queue);
-	ca->exit = 0;
 	ca->open = 0;
 	ca->wakeup = 0;
 	ca->next_read_slot = 0;
@@ -1710,14 +1668,14 @@ int dvb_ca_en50221_init(struct dvb_adapt
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
@@ -1748,17 +1706,7 @@ void dvb_ca_en50221_release(struct dvb_c
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

dvb_en_50221-convert-to-kthread-api.patch
git-nfs-server-cluster-locking-api.patch
remove-pci_dac_dma_-apis.patch
vfs-delay-the-dentry-name-generation-on-sockets-and.patch
udf-use-sector_t-and-loff_t-for-file-offsets.patch
udf-introduce-struct-extent_position.patch
udf-use-get_bh.patch
udf-add-assertions.patch
udf-support-files-larger-than-1g.patch
udf-fix-link-counts.patch
