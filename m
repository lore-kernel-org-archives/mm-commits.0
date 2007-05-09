From: akpm@linux-foundation.org
Subject: + cpci_hotplug-convert-to-use-the-kthread-api.patch added to -mm tree
Date: Wed, 09 May 2007 16:24:44 -0700
Message-ID: <200705092324.l49NOiUS005579@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759343AbXEIXY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 19:24:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scottm@somanetworks.com, greg@kroah.com, hch@lst.de, kristen.c.accardi@intel.com


The patch titled
     cpci_hotplug: Convert to use the kthread API
has been added to the -mm tree.  Its filename is
     cpci_hotplug-convert-to-use-the-kthread-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpci_hotplug: Convert to use the kthread API
From: Scott Murray <scottm@somanetworks.com>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Scott Murray <scottm@somanetworks.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/cpci_hotplug_core.c |   66 +++++++---------------
 1 files changed, 21 insertions(+), 45 deletions(-)

diff -puN drivers/pci/hotplug/cpci_hotplug_core.c~cpci_hotplug-convert-to-use-the-kthread-api drivers/pci/hotplug/cpci_hotplug_core.c
--- a/drivers/pci/hotplug/cpci_hotplug_core.c~cpci_hotplug-convert-to-use-the-kthread-api
+++ a/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -35,6 +35,7 @@
 #include <linux/smp_lock.h>
 #include <asm/atomic.h>
 #include <linux/delay.h>
+#include <linux/kthread.h>
 #include "cpci_hotplug.h"
 
 #define DRIVER_AUTHOR	"Scott Murray <scottm@somanetworks.com>"
@@ -59,9 +60,8 @@ static int slots;
 static atomic_t extracting;
 int cpci_debug;
 static struct cpci_hp_controller *controller;
-static struct semaphore event_semaphore;	/* mutex for process loop (up if something to process) */
-static struct semaphore thread_exit;		/* guard ensure thread has exited before calling it quits */
-static int thread_finished = 1;
+static struct task_struct *cpci_thread;
+static int thread_finished;
 
 static int enable_slot(struct hotplug_slot *slot);
 static int disable_slot(struct hotplug_slot *slot);
@@ -357,9 +357,7 @@ cpci_hp_intr(int irq, void *data)
 	controller->ops->disable_irq();
 
 	/* Trigger processing by the event thread */
-	dbg("Signal event_semaphore");
-	up(&event_semaphore);
-	dbg("exited cpci_hp_intr");
+	wake_up_process(cpci_thread);
 	return IRQ_HANDLED;
 }
 
@@ -521,17 +519,12 @@ event_thread(void *data)
 {
 	int rc;
 
-	lock_kernel();
-	daemonize("cpci_hp_eventd");
-	unlock_kernel();
-
 	dbg("%s - event thread started", __FUNCTION__);
 	while (1) {
 		dbg("event thread sleeping");
-		down_interruptible(&event_semaphore);
-		dbg("event thread woken, thread_finished = %d",
-		    thread_finished);
-		if (thread_finished || signal_pending(current))
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+		if (kthread_should_stop())
 			break;
 		do {
 			rc = check_slots();
@@ -541,18 +534,17 @@ event_thread(void *data)
 			} else if (rc < 0) {
 				dbg("%s - error checking slots", __FUNCTION__);
 				thread_finished = 1;
-				break;
+				goto out;
 			}
-		} while (atomic_read(&extracting) && !thread_finished);
-		if (thread_finished)
+		} while (atomic_read(&extracting) && !kthread_should_stop());
+		if (kthread_should_stop())
 			break;
 
 		/* Re-enable ENUM# interrupt */
 		dbg("%s - re-enabling irq", __FUNCTION__);
 		controller->ops->enable_irq();
 	}
-	dbg("%s - event thread signals exit", __FUNCTION__);
-	up(&thread_exit);
+ out:
 	return 0;
 }
 
@@ -562,12 +554,8 @@ poll_thread(void *data)
 {
 	int rc;
 
-	lock_kernel();
-	daemonize("cpci_hp_polld");
-	unlock_kernel();
-
 	while (1) {
-		if (thread_finished || signal_pending(current))
+		if (kthread_should_stop() || signal_pending(current))
 			break;
 		if (controller->ops->query_enum()) {
 			do {
@@ -578,48 +566,36 @@ poll_thread(void *data)
 				} else if (rc < 0) {
 					dbg("%s - error checking slots", __FUNCTION__);
 					thread_finished = 1;
-					break;
+					goto out;
 				}
-			} while (atomic_read(&extracting) && !thread_finished);
+			} while (atomic_read(&extracting) && !kthread_should_stop());
 		}
 		msleep(100);
 	}
-	dbg("poll thread signals exit");
-	up(&thread_exit);
+ out:
 	return 0;
 }
 
 static int
 cpci_start_thread(void)
 {
-	int pid;
-
-	/* initialize our semaphores */
-	init_MUTEX_LOCKED(&event_semaphore);
-	init_MUTEX_LOCKED(&thread_exit);
-	thread_finished = 0;
-
 	if (controller->irq)
-		pid = kernel_thread(event_thread, NULL, 0);
+		cpci_thread = kthread_run(event_thread, NULL, "cpci_hp_eventd");
 	else
-		pid = kernel_thread(poll_thread, NULL, 0);
-	if (pid < 0) {
+		cpci_thread = kthread_run(poll_thread, NULL, "cpci_hp_polld");
+	if (IS_ERR(cpci_thread)) {
 		err("Can't start up our thread");
-		return -1;
+		return PTR_ERR(cpci_thread);
 	}
-	dbg("Our thread pid = %d", pid);
+	thread_finished = 0;
 	return 0;
 }
 
 static void
 cpci_stop_thread(void)
 {
+	kthread_stop(cpci_thread);
 	thread_finished = 1;
-	dbg("thread finish command given");
-	if (controller->irq)
-		up(&event_semaphore);
-	dbg("wait for thread to exit");
-	down(&thread_exit);
 }
 
 int
_

Patches currently in -mm which might be from scottm@somanetworks.com are

origin.patch
round_up-macro-cleanup-in-drivers-pci.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
