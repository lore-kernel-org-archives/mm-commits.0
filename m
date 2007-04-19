From: akpm@linux-foundation.org
Subject: + mm-only-dvb_en_50221-convert-to-kthread-api.patch added to -mm tree
Date: Thu, 19 Apr 2007 15:32:46 -0700
Message-ID: <200704192232.l3JMWkhG032709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754210AbXDSWdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 18:33:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adq_dvb@lidskialf.net, mchehab@infradead.org


The patch titled
     dvb_en_50221: Convert to kthread API
has been added to the -mm tree.  Its filename is
     mm-only-dvb_en_50221-convert-to-kthread-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dvb_en_50221: Convert to kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

This patch is a minimal transformation to use the kthread API doing it's
best to preserve the existing logic.

Instead of starting kdvb-ca by calling kernel_thread, daemonize and
sigfillset we kthread_run is used.

Instead of tracking the pid of the running thread we instead simply keep a
flag to indicate that the current thread is running, as that is all the pid
is really used for.

And finally the kill_proc sending signal 0 to the kernel thread to ensure
it is alive before we wait for it to shutdown is removed.  The kthread API
does not provide the pid so we don't have that information readily
available and the test is just silly.  If there is no shutdown race the
test is a useless confirmation of that the thread is running.  If there is
a race the test doesn't fix it and we should fix the race properly.

Cc: Andrew de Quincey <adq_dvb@lidskialf.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |   46 +++++++-----------
 1 files changed, 18 insertions(+), 28 deletions(-)

diff -puN drivers/media/dvb/dvb-core/dvb_ca_en50221.c~mm-only-dvb_en_50221-convert-to-kthread-api drivers/media/dvb/dvb-core/dvb_ca_en50221.c
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c~mm-only-dvb_en_50221-convert-to-kthread-api
+++ a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -37,6 +37,7 @@
 #include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/sched.h>
+#include <linux/kthread.h>
 
 #include "dvb_ca_en50221.h"
 #include "dvb_ringbuffer.h"
@@ -139,8 +140,8 @@ struct dvb_ca_private {
 	/* wait queues for read() and write() operations */
 	wait_queue_head_t wait_queue;
 
-	/* PID of the monitoring thread */
-	pid_t thread_pid;
+	/* Flag indicating the monitoring thread is running */
+	int thread_running;
 
 	/* Wait queue used when shutting thread down */
 	wait_queue_head_t thread_queue;
@@ -982,7 +983,6 @@ static void dvb_ca_en50221_thread_update
 static int dvb_ca_en50221_thread(void *data)
 {
 	struct dvb_ca_private *ca = data;
-	char name[15];
 	int slot;
 	int flags;
 	int status;
@@ -991,14 +991,6 @@ static int dvb_ca_en50221_thread(void *d
 
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
 
@@ -1182,7 +1174,7 @@ static int dvb_ca_en50221_thread(void *d
 	}
 
 	/* completed */
-	ca->thread_pid = 0;
+	ca->thread_running = 0;
 	mb();
 	wake_up_interruptible(&ca->thread_queue);
 	return 0;
@@ -1660,6 +1652,7 @@ static struct dvb_device dvbdev_ca = {
 int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 			struct dvb_ca_en50221 *pubca, int flags, int slot_count)
 {
+	struct task_struct *task;
 	int ret;
 	struct dvb_ca_private *ca = NULL;
 	int i;
@@ -1682,7 +1675,7 @@ int dvb_ca_en50221_init(struct dvb_adapt
 		goto error;
 	}
 	init_waitqueue_head(&ca->wait_queue);
-	ca->thread_pid = 0;
+	ca->thread_running = 0;
 	init_waitqueue_head(&ca->thread_queue);
 	ca->exit = 0;
 	ca->open = 0;
@@ -1711,13 +1704,15 @@ int dvb_ca_en50221_init(struct dvb_adapt
 
 	/* create a kthread for monitoring this CA device */
 
-	ret = kernel_thread(dvb_ca_en50221_thread, ca, 0);
-
-	if (ret < 0) {
-		printk("dvb_ca_init: failed to start kernel_thread (%d)\n", ret);
+	task = kthread_run(dvb_ca_en50221_thread, ca,
+			   "kdvb-ca-%i:%i",
+			   ca->dvbdev->adapter->num, ca->dvbdev->id);
+	if (IS_ERR(task)) {
+		ret = PTR_ERR(task);
+		printk("dvb_ca_init: failed to start kthread (%d)\n", ret);
 		goto error;
 	}
-	ca->thread_pid = ret;
+	ca->thread_running = 1;
 	return 0;
 
 error:
@@ -1748,16 +1743,11 @@ void dvb_ca_en50221_release(struct dvb_c
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
+	if (ca->thread_running) {
+		ca->exit = 1;
+		mb();
+		dvb_ca_en50221_thread_wakeup(ca);
+		wait_event_interruptible(ca->thread_queue, ca->thread_running == 0);
 	}
 
 	for (i = 0; i < ca->slot_count; i++) {
_

Patches currently in -mm which might be from ebiederm@xmission.com are

powerpc-rtas-msi-support.patch
mm-only-dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
i386-irq-kill-irq-compression.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
clean-up-elf-note-generation.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
proc-cleanup-use-seq_release_private-where-appropriate.patch
kthread-dont-depend-on-work-queues-take-2.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
change-reparent_to_init-to-reparent_to_kthreadd.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
worker_thread-dont-play-with-sigchld-and-numa-policy.patch
change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
edac-k8-driver-coding-tidy.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
md-remove-broken-sigkill-support.patch
mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
