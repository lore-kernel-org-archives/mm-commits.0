From: akpm@linux-foundation.org
Subject: - saa7134-tvaudio-kthread-conversion.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:34:48 -0700
Message-ID: <200706081734.l58HYmEp006315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47391 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030523AbXFHRfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     saa7134-tvaudio: kthread conversion
has been removed from the -mm tree.  Its filename was
     saa7134-tvaudio-kthread-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: saa7134-tvaudio: kthread conversion
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7134/saa7134-tvaudio.c |   42 ++++++----------
 drivers/media/video/saa7134/saa7134.h         |    5 -
 2 files changed, 17 insertions(+), 30 deletions(-)

diff -puN drivers/media/video/saa7134/saa7134-tvaudio.c~saa7134-tvaudio-kthread-conversion drivers/media/video/saa7134/saa7134-tvaudio.c
--- a/drivers/media/video/saa7134/saa7134-tvaudio.c~saa7134-tvaudio-kthread-conversion
+++ a/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
+#include <linux/kthread.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <asm/div64.h>
@@ -341,10 +342,8 @@ static void tvaudio_setmode(struct saa71
 
 static int tvaudio_sleep(struct saa7134_dev *dev, int timeout)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
-	add_wait_queue(&dev->thread.wq, &wait);
-	if (dev->thread.scan1 == dev->thread.scan2 && !dev->thread.shutdown) {
+	if (dev->thread.scan1 == dev->thread.scan2 &&
+	    !kthread_should_stop()) {
 		if (timeout < 0) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
@@ -353,7 +352,6 @@ static int tvaudio_sleep(struct saa7134_
 						(msecs_to_jiffies(timeout));
 		}
 	}
-	remove_wait_queue(&dev->thread.wq, &wait);
 	return dev->thread.scan1 != dev->thread.scan2;
 }
 
@@ -505,11 +503,10 @@ static int tvaudio_thread(void *data)
 	unsigned int i, audio, nscan;
 	int max1,max2,carrier,rx,mode,lastmode,default_carrier;
 
-	daemonize("%s", dev->name);
 	allow_signal(SIGTERM);
 	for (;;) {
 		tvaudio_sleep(dev,-1);
-		if (dev->thread.shutdown || signal_pending(current))
+		if (kthread_should_stop() || signal_pending(current))
 			goto done;
 
 	restart:
@@ -618,7 +615,7 @@ static int tvaudio_thread(void *data)
 		for (;;) {
 			if (tvaudio_sleep(dev,5000))
 				goto restart;
-			if (dev->thread.shutdown || signal_pending(current))
+			if (kthread_should_stop() || signal_pending(current))
 				break;
 			if (UNSET == dev->thread.mode) {
 				rx = tvaudio_getstereo(dev,&tvaudio[i]);
@@ -634,7 +631,6 @@ static int tvaudio_thread(void *data)
 	}
 
  done:
-	complete_and_exit(&dev->thread.exit, 0);
 	return 0;
 }
 
@@ -782,7 +778,6 @@ static int tvaudio_thread_ddep(void *dat
 	struct saa7134_dev *dev = data;
 	u32 value, norms, clock;
 
-	daemonize("%s", dev->name);
 	allow_signal(SIGTERM);
 
 	clock = saa7134_boards[dev->board].audio_clock;
@@ -796,7 +791,7 @@ static int tvaudio_thread_ddep(void *dat
 
 	for (;;) {
 		tvaudio_sleep(dev,-1);
-		if (dev->thread.shutdown || signal_pending(current))
+		if (kthread_should_stop() || signal_pending(current))
 			goto done;
 
 	restart:
@@ -876,7 +871,6 @@ static int tvaudio_thread_ddep(void *dat
 	}
 
  done:
-	complete_and_exit(&dev->thread.exit, 0);
 	return 0;
 }
 
@@ -973,7 +967,6 @@ int saa7134_tvaudio_getstereo(struct saa
 
 int saa7134_tvaudio_init2(struct saa7134_dev *dev)
 {
-	DECLARE_MUTEX_LOCKED(sem);
 	int (*my_thread)(void *data) = NULL;
 
 	switch (dev->pci->device) {
@@ -986,15 +979,15 @@ int saa7134_tvaudio_init2(struct saa7134
 		break;
 	}
 
-	dev->thread.pid = -1;
+	dev->thread.thread = NULL;
 	if (my_thread) {
 		/* start tvaudio thread */
-		init_waitqueue_head(&dev->thread.wq);
-		init_completion(&dev->thread.exit);
-		dev->thread.pid = kernel_thread(my_thread,dev,0);
-		if (dev->thread.pid < 0)
+		dev->thread.thread = kthread_run(my_thread, dev, "%s", dev->name);
+		if (IS_ERR(dev->thread.thread)) {
 			printk(KERN_WARNING "%s: kernel_thread() failed\n",
 			       dev->name);
+			/* XXX: missing error handling here */
+		}
 		saa7134_tvaudio_do_scan(dev);
 	}
 
@@ -1004,12 +997,9 @@ int saa7134_tvaudio_init2(struct saa7134
 
 int saa7134_tvaudio_fini(struct saa7134_dev *dev)
 {
-	/* shutdown tvaudio thread */
-	if (dev->thread.pid >= 0) {
-		dev->thread.shutdown = 1;
-		wake_up_interruptible(&dev->thread.wq);
-		wait_for_completion(&dev->thread.exit);
-	}
+	if (dev->thread.thread)
+		kthread_stop(dev->thread.thread);
+
 	saa_andorb(SAA7134_ANALOG_IO_SELECT, 0x07, 0x00); /* LINE1 */
 	return 0;
 }
@@ -1020,10 +1010,10 @@ int saa7134_tvaudio_do_scan(struct saa71
 		dprintk("sound IF not in use, skipping scan\n");
 		dev->automute = 0;
 		saa7134_tvaudio_setmute(dev);
-	} else if (dev->thread.pid >= 0) {
+	} else if (dev->thread.thread) {
 		dev->thread.mode = UNSET;
 		dev->thread.scan2++;
-		wake_up_interruptible(&dev->thread.wq);
+		wake_up_process(dev->thread.thread);
 	} else {
 		dev->automute = 0;
 		saa7134_tvaudio_setmute(dev);
diff -puN drivers/media/video/saa7134/saa7134.h~saa7134-tvaudio-kthread-conversion drivers/media/video/saa7134/saa7134.h
--- a/drivers/media/video/saa7134/saa7134.h~saa7134-tvaudio-kthread-conversion
+++ a/drivers/media/video/saa7134/saa7134.h
@@ -328,10 +328,7 @@ struct saa7134_pgtable {
 
 /* tvaudio thread status */
 struct saa7134_thread {
-	pid_t                      pid;
-	struct completion          exit;
-	wait_queue_head_t          wq;
-	unsigned int               shutdown;
+	struct task_struct	   *thread;
 	unsigned int               scan1;
 	unsigned int               scan2;
 	unsigned int               mode;
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-dvb.patch
git-ubi.patch
git-ocfs2.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
git-scsi-misc.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
git-xfs.patch
sysv-convert-to-new-aops.patch
udf-check-for-allocated-memory-for-data-of-new-inodes.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
vxfs-warning-fixes.patch
remove-odd-and-misleading-comments-from-uioh.patch
init-wait-for-asynchronously-scanned-block-devices.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
knfsd-exportfs-add-procedural-interface-for-nfsd.patch
knfsd-exportfs-remove-call-macro.patch
knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
knfsd-exportfs-add-find_disconnected_root-helper.patch
knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
