From: akpm@linux-foundation.org
Subject: - use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:26:56 -0700
Message-ID: <200710190426.l9J4QupY014963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36351 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbXJSE1V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:27:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, airlied@linux.ie, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     use-helpers-to-obtain-task-pid-in-printks-drm-fix
has been removed from the -mm tree.  Its filename was
     use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch

This patch was dropped because it was folded into use-helpers-to-obtain-task-pid-in-printks.patch

------------------------------------------------------
Subject: use-helpers-to-obtain-task-pid-in-printks-drm-fix
From: Andrew Morton <akpm@linux-foundation.org>

git-drm went and changed lots of stuff.

I hope those git-drm changes will be going into 2.6.24?

Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/drm_drv.c  |    2 +-
 drivers/char/drm/drm_fops.c |    5 +++--
 drivers/char/drm/drm_lock.c |    6 +++---
 drivers/char/drm/i810_dma.c |    2 +-
 drivers/char/drm/i830_dma.c |    2 +-
 5 files changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/char/drm/drm_drv.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix drivers/char/drm/drm_drv.c
--- a/drivers/char/drm/drm_drv.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix
+++ a/drivers/char/drm/drm_drv.c
@@ -463,7 +463,7 @@ int drm_ioctl(struct inode *inode, struc
 	++file_priv->ioctl_count;
 
 	DRM_DEBUG("pid=%d, cmd=0x%02x, nr=0x%02x, dev 0x%lx, auth=%d\n",
-		  current->pid, cmd, nr,
+		  task_pid_nr(current), cmd, nr,
 		  (long)old_encode_dev(file_priv->head->device),
 		  file_priv->authenticated);
 
diff -puN drivers/char/drm/drm_fops.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix drivers/char/drm/drm_fops.c
--- a/drivers/char/drm/drm_fops.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix
+++ a/drivers/char/drm/drm_fops.c
@@ -244,7 +244,7 @@ static int drm_open_helper(struct inode 
 	filp->private_data = priv;
 	priv->filp = filp;
 	priv->uid = current->euid;
-	priv->pid = current->pid;
+	priv->pid = task_pid_nr(current);
 	priv->minor = minor;
 	priv->head = drm_heads[minor];
 	priv->ioctl_count = 0;
@@ -339,7 +339,8 @@ int drm_release(struct inode *inode, str
 	 */
 
 	DRM_DEBUG("pid = %d, device = 0x%lx, open_count = %d\n",
-		  current->pid, (long)old_encode_dev(file_priv->head->device),
+		  task_pid_nr(current),
+		  (long)old_encode_dev(file_priv->head->device),
 		  dev->open_count);
 
 	if (dev->driver->reclaim_buffers_locked && dev->lock.hw_lock) {
diff -puN drivers/char/drm/drm_lock.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix drivers/char/drm/drm_lock.c
--- a/drivers/char/drm/drm_lock.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix
+++ a/drivers/char/drm/drm_lock.c
@@ -58,12 +58,12 @@ int drm_lock(struct drm_device *dev, voi
 
 	if (lock->context == DRM_KERNEL_CONTEXT) {
 		DRM_ERROR("Process %d using kernel context %d\n",
-			  current->pid, lock->context);
+			  task_pid_nr(current), lock->context);
 		return -EINVAL;
 	}
 
 	DRM_DEBUG("%d (pid %d) requests lock (0x%08x), flags = 0x%08x\n",
-		  lock->context, current->pid,
+		  lock->context, task_pid_nr(current),
 		  dev->lock.hw_lock->lock, lock->flags);
 
 	if (drm_core_check_feature(dev, DRIVER_DMA_QUEUE))
@@ -153,7 +153,7 @@ int drm_unlock(struct drm_device *dev, v
 
 	if (lock->context == DRM_KERNEL_CONTEXT) {
 		DRM_ERROR("Process %d using kernel context %d\n",
-			  current->pid, lock->context);
+			  task_pid_nr(current), lock->context);
 		return -EINVAL;
 	}
 
diff -puN drivers/char/drm/i810_dma.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix drivers/char/drm/i810_dma.c
--- a/drivers/char/drm/i810_dma.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix
+++ a/drivers/char/drm/i810_dma.c
@@ -1024,7 +1024,7 @@ static int i810_getbuf(struct drm_device
 	retcode = i810_dma_get_buffer(dev, d, file_priv);
 
 	DRM_DEBUG("i810_dma: %d returning %d, granted = %d\n",
-		  current->pid, retcode, d->granted);
+		  task_pid_nr(current), retcode, d->granted);
 
 	sarea_priv->last_dispatch = (int)hw_status[5];
 
diff -puN drivers/char/drm/i830_dma.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix drivers/char/drm/i830_dma.c
--- a/drivers/char/drm/i830_dma.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix
+++ a/drivers/char/drm/i830_dma.c
@@ -1409,7 +1409,7 @@ static int i830_getbuf(struct drm_device
 	retcode = i830_dma_get_buffer(dev, d, file_priv);
 
 	DRM_DEBUG("i830_dma: %d returning %d, granted = %d\n",
-		  current->pid, retcode, d->granted);
+		  task_pid_nr(current), retcode, d->granted);
 
 	sarea_priv->last_dispatch = (int)hw_status[5];
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
console-keyboard-events-and-accessibility.patch
add-kernel-notifierc.patch
console-events-and-accessibility.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
add-containerstats-v3.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
cpuset-sched_load_balance-flag.patch
cpusets-decrustify-cpuset-mask-update-code.patch
fix-cpusets-update_cpumask.patch
remove-bits_to_type-macro.patch
use-helpers-to-obtain-task-pid-in-printks.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
