From: akpm@linux-foundation.org
Subject: - use-helpers-to-obtain-task-pid-in-printks.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:12 -0700
Message-ID: <200710192253.l9JMrCAj024409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47204 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764673AbXJSXGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Use helpers to obtain task pid in printks
has been removed from the -mm tree.  Its filename was
     use-helpers-to-obtain-task-pid-in-printks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use helpers to obtain task pid in printks
From: Pavel Emelyanov <xemul@openvz.org>

The task_struct->pid member is going to be deprecated, so start
using the helpers (task_pid_nr/task_pid_vnr/task_pid_nr_ns) in
the kernel.

The first thing to start with is the pid, printed to dmesg - in
this case we may safely use task_pid_nr(). Besides, printks produce
more (much more) than a half of all the explicit pid usage.

[akpm@linux-foundation.org: git-drm went and changed lots of stuff]
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c                          |    2 -
 drivers/block/nbd.c                        |    2 -
 drivers/cdrom/cdrom.c                      |    2 -
 drivers/char/drm/drm_bufs.c                |    2 -
 drivers/char/drm/drm_drv.c                 |    2 -
 drivers/char/drm/drm_fops.c                |    7 +++---
 drivers/char/drm/drm_lock.c                |    6 ++---
 drivers/char/drm/drm_os_linux.h            |    2 -
 drivers/char/drm/i810_dma.c                |    2 -
 drivers/char/drm/i830_dma.c                |    2 -
 drivers/char/sx.c                          |    2 -
 drivers/char/tty_io.c                      |    6 ++---
 drivers/hid/hidraw.c                       |    4 +--
 drivers/md/md.c                            |    2 -
 drivers/media/video/zoran_driver.c         |    4 +--
 drivers/mtd/ubi/wl.c                       |    2 -
 drivers/net/wireless/hostap/hostap_ioctl.c |    2 -
 drivers/scsi/libsas/sas_discover.c         |    8 +++---
 drivers/usb/core/devio.c                   |    2 -
 drivers/usb/gadget/file_storage.c          |    2 -
 fs/cifs/connect.c                          |    2 -
 fs/dlm/user.c                              |    2 -
 fs/fs-writeback.c                          |    2 -
 fs/jffs2/debug.h                           |    8 +++---
 fs/nfsd/vfs.c                              |    6 ++---
 fs/ocfs2/cluster/heartbeat.c               |    2 -
 fs/ocfs2/cluster/masklog.h                 |    2 -
 fs/ocfs2/dlm/dlmrecovery.c                 |   10 ++++----
 include/linux/reiserfs_fs.h                |    2 -
 include/net/9p/9p.h                        |    4 +--
 kernel/cpu.c                               |    3 +-
 kernel/exit.c                              |    2 -
 kernel/lockdep.c                           |   22 +++++++++----------
 kernel/rtmutex-debug.c                     |   15 +++++++-----
 kernel/rtmutex.c                           |    2 -
 kernel/sched.c                             |    7 +++---
 kernel/signal.c                            |    2 -
 kernel/softlockup.c                        |    2 -
 kernel/workqueue.c                         |    2 -
 lib/spinlock_debug.c                       |    8 +++---
 mm/oom_kill.c                              |    5 ++--
 net/core/pktgen.c                          |    2 -
 net/core/sock.c                            |    2 -
 net/ipv4/ipvs/ip_vs_sync.c                 |    4 +--
 net/ipv4/tcp.c                             |    2 -
 net/llc/af_llc.c                           |    2 -
 net/sunrpc/sched.c                         |    2 -
 47 files changed, 97 insertions(+), 90 deletions(-)

diff -puN block/ll_rw_blk.c~use-helpers-to-obtain-task-pid-in-printks block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/block/ll_rw_blk.c
@@ -3367,7 +3367,7 @@ void submit_bio(int rw, struct bio *bio)
 		if (unlikely(block_dump)) {
 			char b[BDEVNAME_SIZE];
 			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s\n",
-				current->comm, current->pid,
+			current->comm, task_pid_nr(current),
 				(rw & WRITE) ? "WRITE" : "READ",
 				(unsigned long long)bio->bi_sector,
 				bdevname(bio->bi_bdev,b));
diff -puN drivers/block/nbd.c~use-helpers-to-obtain-task-pid-in-printks drivers/block/nbd.c
--- a/drivers/block/nbd.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/block/nbd.c
@@ -188,7 +188,7 @@ static int sock_xmit(struct nbd_device *
 		if (signal_pending(current)) {
 			siginfo_t info;
 			printk(KERN_WARNING "nbd (pid %d: %s) got signal %d\n",
-				current->pid, current->comm,
+				task_pid_nr(current), current->comm,
 				dequeue_signal_lock(current, &current->blocked, &info));
 			result = -EINTR;
 			sock_shutdown(lo, !send);
diff -puN drivers/cdrom/cdrom.c~use-helpers-to-obtain-task-pid-in-printks drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/cdrom/cdrom.c
@@ -1107,7 +1107,7 @@ int open_for_data(struct cdrom_device_in
 		       is the default case! */
 		    cdinfo(CD_OPEN, "bummer. wrong media type.\n"); 
 		    cdinfo(CD_WARNING, "pid %d must open device O_NONBLOCK!\n",
-					(unsigned int)current->pid); 
+					(unsigned int)task_pid_nr(current));
 		    ret=-EMEDIUMTYPE;
 		    goto clean_up_and_return;
 		}
diff -puN drivers/char/drm/drm_bufs.c~use-helpers-to-obtain-task-pid-in-printks drivers/char/drm/drm_bufs.c
--- a/drivers/char/drm/drm_bufs.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/char/drm/drm_bufs.c
@@ -1456,7 +1456,7 @@ int drm_freebufs(struct drm_device *dev,
 		buf = dma->buflist[idx];
 		if (buf->file_priv != file_priv) {
 			DRM_ERROR("Process %d freeing buffer not owned\n",
-				  current->pid);
+				  task_pid_nr(current));
 			return -EINVAL;
 		}
 		drm_free_buffer(dev, buf);
diff -puN drivers/char/drm/drm_drv.c~use-helpers-to-obtain-task-pid-in-printks drivers/char/drm/drm_drv.c
--- a/drivers/char/drm/drm_drv.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/char/drm/drm_drv.c
@@ -463,7 +463,7 @@ int drm_ioctl(struct inode *inode, struc
 	++file_priv->ioctl_count;
 
 	DRM_DEBUG("pid=%d, cmd=0x%02x, nr=0x%02x, dev 0x%lx, auth=%d\n",
-		  current->pid, cmd, nr,
+		  task_pid_nr(current), cmd, nr,
 		  (long)old_encode_dev(file_priv->head->device),
 		  file_priv->authenticated);
 
diff -puN drivers/char/drm/drm_fops.c~use-helpers-to-obtain-task-pid-in-printks drivers/char/drm/drm_fops.c
--- a/drivers/char/drm/drm_fops.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/char/drm/drm_fops.c
@@ -234,7 +234,7 @@ static int drm_open_helper(struct inode 
 	if (!drm_cpu_valid())
 		return -EINVAL;
 
-	DRM_DEBUG("pid = %d, minor = %d\n", current->pid, minor);
+	DRM_DEBUG("pid = %d, minor = %d\n", task_pid_nr(current), minor);
 
 	priv = drm_alloc(sizeof(*priv), DRM_MEM_FILES);
 	if (!priv)
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
diff -puN drivers/char/drm/drm_lock.c~use-helpers-to-obtain-task-pid-in-printks drivers/char/drm/drm_lock.c
--- a/drivers/char/drm/drm_lock.c~use-helpers-to-obtain-task-pid-in-printks
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
 
diff -puN drivers/char/drm/drm_os_linux.h~use-helpers-to-obtain-task-pid-in-printks drivers/char/drm/drm_os_linux.h
--- a/drivers/char/drm/drm_os_linux.h~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/char/drm/drm_os_linux.h
@@ -7,7 +7,7 @@
 #include <linux/delay.h>
 
 /** Current process ID */
-#define DRM_CURRENTPID			current->pid
+#define DRM_CURRENTPID			task_pid_nr(current)
 #define DRM_SUSER(p)			capable(CAP_SYS_ADMIN)
 #define DRM_UDELAY(d)			udelay(d)
 /** Read a byte from a MMIO region */
diff -puN drivers/char/drm/i810_dma.c~use-helpers-to-obtain-task-pid-in-printks drivers/char/drm/i810_dma.c
--- a/drivers/char/drm/i810_dma.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/char/drm/i810_dma.c
@@ -1024,7 +1024,7 @@ static int i810_getbuf(struct drm_device
 	retcode = i810_dma_get_buffer(dev, d, file_priv);
 
 	DRM_DEBUG("i810_dma: %d returning %d, granted = %d\n",
-		  current->pid, retcode, d->granted);
+		  task_pid_nr(current), retcode, d->granted);
 
 	sarea_priv->last_dispatch = (int)hw_status[5];
 
diff -puN drivers/char/drm/i830_dma.c~use-helpers-to-obtain-task-pid-in-printks drivers/char/drm/i830_dma.c
--- a/drivers/char/drm/i830_dma.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/char/drm/i830_dma.c
@@ -1409,7 +1409,7 @@ static int i830_getbuf(struct drm_device
 	retcode = i830_dma_get_buffer(dev, d, file_priv);
 
 	DRM_DEBUG("i830_dma: %d returning %d, granted = %d\n",
-		  current->pid, retcode, d->granted);
+		  task_pid_nr(current), retcode, d->granted);
 
 	sarea_priv->last_dispatch = (int)hw_status[5];
 
diff -puN drivers/char/sx.c~use-helpers-to-obtain-task-pid-in-printks drivers/char/sx.c
--- a/drivers/char/sx.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/char/sx.c
@@ -1467,7 +1467,7 @@ static int sx_open(struct tty_struct *tt
 
 	line = tty->index;
 	sx_dprintk(SX_DEBUG_OPEN, "%d: opening line %d. tty=%p ctty=%p, "
-			"np=%d)\n", current->pid, line, tty,
+			"np=%d)\n", task_pid_nr(current), line, tty,
 			current->signal->tty, sx_nports);
 
 	if ((line < 0) || (line >= SX_NPORTS) || (line >= sx_nports))
diff -puN drivers/char/tty_io.c~use-helpers-to-obtain-task-pid-in-printks drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/char/tty_io.c
@@ -3530,7 +3530,7 @@ void __do_SAK(struct tty_struct *tty)
 	do_each_pid_task(session, PIDTYPE_SID, p) {
 		printk(KERN_NOTICE "SAK: killed process %d"
 			" (%s): task_session_nr(p)==tty->session\n",
-			p->pid, p->comm);
+			task_pid_nr(p), p->comm);
 		send_sig(SIGKILL, p, 1);
 	} while_each_pid_task(session, PIDTYPE_SID, p);
 	/* Now kill any processes that happen to have the
@@ -3540,7 +3540,7 @@ void __do_SAK(struct tty_struct *tty)
 		if (p->signal->tty == tty) {
 			printk(KERN_NOTICE "SAK: killed process %d"
 			    " (%s): task_session_nr(p)==tty->session\n",
-			    p->pid, p->comm);
+			    task_pid_nr(p), p->comm);
 			send_sig(SIGKILL, p, 1);
 			continue;
 		}
@@ -3560,7 +3560,7 @@ void __do_SAK(struct tty_struct *tty)
 				    filp->private_data == tty) {
 					printk(KERN_NOTICE "SAK: killed process %d"
 					    " (%s): fd#%d opened to the tty\n",
-					    p->pid, p->comm, i);
+					    task_pid_nr(p), p->comm, i);
 					force_sig(SIGKILL, p);
 					break;
 				}
diff -puN drivers/hid/hidraw.c~use-helpers-to-obtain-task-pid-in-printks drivers/hid/hidraw.c
--- a/drivers/hid/hidraw.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/hid/hidraw.c
@@ -113,13 +113,13 @@ static ssize_t hidraw_write(struct file 
 
 	if (count > HID_MIN_BUFFER_SIZE) {
 		printk(KERN_WARNING "hidraw: pid %d passed too large report\n",
-				current->pid);
+				task_pid_nr(current));
 		return -EINVAL;
 	}
 
 	if (count < 2) {
 		printk(KERN_WARNING "hidraw: pid %d passed too short report\n",
-				current->pid);
+				task_pid_nr(current));
 		return -EINVAL;
 	}
 
diff -puN drivers/md/md.c~use-helpers-to-obtain-task-pid-in-printks drivers/md/md.c
--- a/drivers/md/md.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/md/md.c
@@ -4717,7 +4717,7 @@ mdk_thread_t *md_register_thread(void (*
 
 void md_unregister_thread(mdk_thread_t *thread)
 {
-	dprintk("interrupting MD-thread pid %d\n", thread->tsk->pid);
+	dprintk("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
 
 	kthread_stop(thread->tsk);
 	kfree(thread);
diff -puN drivers/media/video/zoran_driver.c~use-helpers-to-obtain-task-pid-in-printks drivers/media/video/zoran_driver.c
--- a/drivers/media/video/zoran_driver.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/media/video/zoran_driver.c
@@ -1285,7 +1285,7 @@ zoran_open (struct inode *inode,
 	}
 
 	dprintk(1, KERN_INFO "%s: zoran_open(%s, pid=[%d]), users(-)=%d\n",
-		ZR_DEVNAME(zr), current->comm, current->pid, zr->user);
+		ZR_DEVNAME(zr), current->comm, task_pid_nr(current), zr->user);
 
 	/* now, create the open()-specific file_ops struct */
 	fh = kzalloc(sizeof(struct zoran_fh), GFP_KERNEL);
@@ -1358,7 +1358,7 @@ zoran_close (struct inode *inode,
 	struct zoran *zr = fh->zr;
 
 	dprintk(1, KERN_INFO "%s: zoran_close(%s, pid=[%d]), users(+)=%d\n",
-		ZR_DEVNAME(zr), current->comm, current->pid, zr->user);
+		ZR_DEVNAME(zr), current->comm, task_pid_nr(current), zr->user);
 
 	/* kernel locks (fs/device.c), so don't do that ourselves
 	 * (prevents deadlocks) */
diff -puN drivers/mtd/ubi/wl.c~use-helpers-to-obtain-task-pid-in-printks drivers/mtd/ubi/wl.c
--- a/drivers/mtd/ubi/wl.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/mtd/ubi/wl.c
@@ -1309,7 +1309,7 @@ static int ubi_thread(void *u)
 	struct ubi_device *ubi = u;
 
 	ubi_msg("background thread \"%s\" started, PID %d",
-		ubi->bgt_name, current->pid);
+		ubi->bgt_name, task_pid_nr(current));
 
 	set_freezable();
 	for (;;) {
diff -puN drivers/net/wireless/hostap/hostap_ioctl.c~use-helpers-to-obtain-task-pid-in-printks drivers/net/wireless/hostap/hostap_ioctl.c
--- a/drivers/net/wireless/hostap/hostap_ioctl.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -2920,7 +2920,7 @@ static int prism2_ioctl_priv_monitor(str
 
 	printk(KERN_DEBUG "%s: process %d (%s) used deprecated iwpriv monitor "
 	       "- update software to use iwconfig mode monitor\n",
-	       dev->name, current->pid, current->comm);
+	       dev->name, task_pid_nr(current), current->comm);
 
 	/* Backward compatibility code - this can be removed at some point */
 
diff -puN drivers/scsi/libsas/sas_discover.c~use-helpers-to-obtain-task-pid-in-printks drivers/scsi/libsas/sas_discover.c
--- a/drivers/scsi/libsas/sas_discover.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/scsi/libsas/sas_discover.c
@@ -285,7 +285,7 @@ static void sas_discover_domain(struct w
 	dev = port->port_dev;
 
 	SAS_DPRINTK("DOING DISCOVERY on port %d, pid:%d\n", port->id,
-		    current->pid);
+		    task_pid_nr(current));
 
 	switch (dev->dev_type) {
 	case SAS_END_DEV:
@@ -320,7 +320,7 @@ static void sas_discover_domain(struct w
 	}
 
 	SAS_DPRINTK("DONE DISCOVERY on port %d, pid:%d, result:%d\n", port->id,
-		    current->pid, error);
+		    task_pid_nr(current), error);
 }
 
 static void sas_revalidate_domain(struct work_struct *work)
@@ -334,12 +334,12 @@ static void sas_revalidate_domain(struct
 			&port->disc.pending);
 
 	SAS_DPRINTK("REVALIDATING DOMAIN on port %d, pid:%d\n", port->id,
-		    current->pid);
+		    task_pid_nr(current));
 	if (port->port_dev)
 		res = sas_ex_revalidate_domain(port->port_dev);
 
 	SAS_DPRINTK("done REVALIDATING DOMAIN on port %d, pid:%d, res 0x%x\n",
-		    port->id, current->pid, res);
+		    port->id, task_pid_nr(current), res);
 }
 
 /* ---------- Events ---------- */
diff -puN drivers/usb/core/devio.c~use-helpers-to-obtain-task-pid-in-printks drivers/usb/core/devio.c
--- a/drivers/usb/core/devio.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/usb/core/devio.c
@@ -460,7 +460,7 @@ static int checkintf(struct dev_state *p
 		return 0;
 	/* if not yet claimed, claim it for the driver */
 	dev_warn(&ps->dev->dev, "usbfs: process %d (%s) did not claim interface %u before use\n",
-	       current->pid, current->comm, ifnum);
+	       task_pid_nr(current), current->comm, ifnum);
 	return claimintf(ps, ifnum);
 }
 
diff -puN drivers/usb/gadget/file_storage.c~use-helpers-to-obtain-task-pid-in-printks drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/drivers/usb/gadget/file_storage.c
@@ -4006,7 +4006,7 @@ static int __init fsg_bind(struct usb_ga
 	DBG(fsg, "removable=%d, stall=%d, buflen=%u\n",
 			mod_data.removable, mod_data.can_stall,
 			mod_data.buflen);
-	DBG(fsg, "I/O thread pid: %d\n", fsg->thread_task->pid);
+	DBG(fsg, "I/O thread pid: %d\n", task_pid_nr(fsg->thread_task));
 
 	set_bit(REGISTERED, &fsg->atomic_bitflags);
 
diff -puN fs/cifs/connect.c~use-helpers-to-obtain-task-pid-in-printks fs/cifs/connect.c
--- a/fs/cifs/connect.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/fs/cifs/connect.c
@@ -352,7 +352,7 @@ cifs_demultiplex_thread(struct TCP_Serve
 
 	current->flags |= PF_MEMALLOC;
 	server->tsk = current;	/* save process info to wake at shutdown */
-	cFYI(1, ("Demultiplex PID: %d", current->pid));
+	cFYI(1, ("Demultiplex PID: %d", task_pid_nr(current)));
 	write_lock(&GlobalSMBSeslock);
 	atomic_inc(&tcpSesAllocCount);
 	length = tcpSesAllocCount.counter;
diff -puN fs/dlm/user.c~use-helpers-to-obtain-task-pid-in-printks fs/dlm/user.c
--- a/fs/dlm/user.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/fs/dlm/user.c
@@ -456,7 +456,7 @@ static int check_version(struct dlm_writ
 		printk(KERN_DEBUG "dlm: process %s (%d) version mismatch "
 		       "user (%d.%d.%d) kernel (%d.%d.%d)\n",
 		       current->comm,
-		       current->pid,
+		       task_pid_nr(current),
 		       req->version[0],
 		       req->version[1],
 		       req->version[2],
diff -puN fs/fs-writeback.c~use-helpers-to-obtain-task-pid-in-printks fs/fs-writeback.c
--- a/fs/fs-writeback.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/fs/fs-writeback.c
@@ -89,7 +89,7 @@ void __mark_inode_dirty(struct inode *in
 		if (inode->i_ino || strcmp(inode->i_sb->s_id, "bdev"))
 			printk(KERN_DEBUG
 			       "%s(%d): dirtied inode %lu (%s) on %s\n",
-			       current->comm, current->pid, inode->i_ino,
+			       current->comm, task_pid_nr(current), inode->i_ino,
 			       name, inode->i_sb->s_id);
 	}
 
diff -puN fs/jffs2/debug.h~use-helpers-to-obtain-task-pid-in-printks fs/jffs2/debug.h
--- a/fs/jffs2/debug.h~use-helpers-to-obtain-task-pid-in-printks
+++ a/fs/jffs2/debug.h
@@ -80,28 +80,28 @@
 #define JFFS2_ERROR(fmt, ...)						\
 	do {								\
 		printk(JFFS2_ERR_MSG_PREFIX				\
-			" (%d) %s: " fmt, current->pid,			\
+			" (%d) %s: " fmt, task_pid_nr(current),		\
 			__FUNCTION__ , ##__VA_ARGS__);			\
 	} while(0)
 
 #define JFFS2_WARNING(fmt, ...)						\
 	do {								\
 		printk(JFFS2_WARN_MSG_PREFIX				\
-			" (%d) %s: " fmt, current->pid,			\
+			" (%d) %s: " fmt, task_pid_nr(current),		\
 			__FUNCTION__ , ##__VA_ARGS__);			\
 	} while(0)
 
 #define JFFS2_NOTICE(fmt, ...)						\
 	do {								\
 		printk(JFFS2_NOTICE_MSG_PREFIX				\
-			" (%d) %s: " fmt, current->pid,			\
+			" (%d) %s: " fmt, task_pid_nr(current),		\
 			__FUNCTION__ , ##__VA_ARGS__);			\
 	} while(0)
 
 #define JFFS2_DEBUG(fmt, ...)						\
 	do {								\
 		printk(JFFS2_DBG_MSG_PREFIX				\
-			" (%d) %s: " fmt, current->pid,			\
+			" (%d) %s: " fmt, task_pid_nr(current),		\
 			__FUNCTION__ , ##__VA_ARGS__);			\
 	} while(0)
 
diff -puN fs/nfsd/vfs.c~use-helpers-to-obtain-task-pid-in-printks fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/fs/nfsd/vfs.c
@@ -1029,13 +1029,13 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 		if (EX_WGATHER(exp)) {
 			if (atomic_read(&inode->i_writecount) > 1
 			    || (last_ino == inode->i_ino && last_dev == inode->i_sb->s_dev)) {
-				dprintk("nfsd: write defer %d\n", current->pid);
+				dprintk("nfsd: write defer %d\n", task_pid_nr(current));
 				msleep(10);
-				dprintk("nfsd: write resume %d\n", current->pid);
+				dprintk("nfsd: write resume %d\n", task_pid_nr(current));
 			}
 
 			if (inode->i_state & I_DIRTY) {
-				dprintk("nfsd: write sync %d\n", current->pid);
+				dprintk("nfsd: write sync %d\n", task_pid_nr(current));
 				host_err=nfsd_sync(file);
 			}
 #if 0
diff -puN fs/ocfs2/cluster/heartbeat.c~use-helpers-to-obtain-task-pid-in-printks fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1372,7 +1372,7 @@ static ssize_t o2hb_region_pid_read(stru
 
 	spin_lock(&o2hb_live_lock);
 	if (reg->hr_task)
-		pid = reg->hr_task->pid;
+		pid = task_pid_nr(reg->hr_task);
 	spin_unlock(&o2hb_live_lock);
 
 	if (!pid)
diff -puN fs/ocfs2/cluster/masklog.h~use-helpers-to-obtain-task-pid-in-printks fs/ocfs2/cluster/masklog.h
--- a/fs/ocfs2/cluster/masklog.h~use-helpers-to-obtain-task-pid-in-printks
+++ a/fs/ocfs2/cluster/masklog.h
@@ -192,7 +192,7 @@ extern struct mlog_bits mlog_and_bits, m
  * previous token if args expands to nothing.
  */
 #define __mlog_printk(level, fmt, args...)				\
-	printk(level "(%u,%lu):%s:%d " fmt, current->pid,		\
+	printk(level "(%u,%lu):%s:%d " fmt, task_pid_nr(current),	\
 	       __mlog_cpu_guess, __PRETTY_FUNCTION__, __LINE__ ,	\
 	       ##args)
 
diff -puN fs/ocfs2/dlm/dlmrecovery.c~use-helpers-to-obtain-task-pid-in-printks fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -259,7 +259,7 @@ static void dlm_print_reco_node_status(s
 	struct dlm_lock_resource *res;
 
 	mlog(ML_NOTICE, "%s(%d): recovery info, state=%s, dead=%u, master=%u\n",
-	     dlm->name, dlm->dlm_reco_thread_task->pid,
+	     dlm->name, task_pid_nr(dlm->dlm_reco_thread_task),
 	     dlm->reco.state & DLM_RECO_STATE_ACTIVE ? "ACTIVE" : "inactive",
 	     dlm->reco.dead_node, dlm->reco.new_master);
 
@@ -420,7 +420,7 @@ void dlm_wait_for_recovery(struct dlm_ct
 	if (dlm_in_recovery(dlm)) {
 		mlog(0, "%s: reco thread %d in recovery: "
 		     "state=%d, master=%u, dead=%u\n",
-		     dlm->name, dlm->dlm_reco_thread_task->pid,
+		     dlm->name, task_pid_nr(dlm->dlm_reco_thread_task),
 		     dlm->reco.state, dlm->reco.new_master,
 		     dlm->reco.dead_node);
 	}
@@ -483,7 +483,7 @@ static int dlm_do_recovery(struct dlm_ct
 		return 0;
 	}
 	mlog(0, "%s(%d):recovery thread found node %u in the recovery map!\n",
-	     dlm->name, dlm->dlm_reco_thread_task->pid,
+	     dlm->name, task_pid_nr(dlm->dlm_reco_thread_task),
 	     dlm->reco.dead_node);
 	spin_unlock(&dlm->spinlock);
 
@@ -507,7 +507,7 @@ static int dlm_do_recovery(struct dlm_ct
 		mlog(0, "another node will master this recovery session.\n");
 	}
 	mlog(0, "dlm=%s (%d), new_master=%u, this node=%u, dead_node=%u\n",
-	     dlm->name, dlm->dlm_reco_thread_task->pid, dlm->reco.new_master,
+	     dlm->name, task_pid_nr(dlm->dlm_reco_thread_task), dlm->reco.new_master,
 	     dlm->node_num, dlm->reco.dead_node);
 
 	/* it is safe to start everything back up here
@@ -520,7 +520,7 @@ static int dlm_do_recovery(struct dlm_ct
 
 master_here:
 	mlog(0, "(%d) mastering recovery of %s:%u here(this=%u)!\n",
-	     dlm->dlm_reco_thread_task->pid,
+	     task_pid_nr(dlm->dlm_reco_thread_task),
 	     dlm->name, dlm->reco.dead_node, dlm->node_num);
 
 	status = dlm_remaster_locks(dlm, dlm->reco.dead_node);
diff -puN include/linux/reiserfs_fs.h~use-helpers-to-obtain-task-pid-in-printks include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~use-helpers-to-obtain-task-pid-in-printks
+++ a/include/linux/reiserfs_fs.h
@@ -85,7 +85,7 @@ void reiserfs_warning(struct super_block
 if( !( cond ) ) 								\
   reiserfs_panic( NULL, "reiserfs[%i]: assertion " scond " failed at "	\
 		  __FILE__ ":%i:%s: " format "\n",		\
-		  in_interrupt() ? -1 : current -> pid, __LINE__ , __FUNCTION__ , ##args )
+		  in_interrupt() ? -1 : task_pid_nr(current), __LINE__ , __FUNCTION__ , ##args )
 
 #define RASSERT(cond, format, args...) __RASSERT(cond, #cond, format, ##args)
 
diff -puN include/net/9p/9p.h~use-helpers-to-obtain-task-pid-in-printks include/net/9p/9p.h
--- a/include/net/9p/9p.h~use-helpers-to-obtain-task-pid-in-printks
+++ a/include/net/9p/9p.h
@@ -44,7 +44,7 @@ extern unsigned int p9_debug_level;
 do {  \
 	if ((p9_debug_level & level) == level) \
 		printk(KERN_NOTICE "-- %s (%d): " \
-		format , __FUNCTION__, current->pid , ## arg); \
+		format , __FUNCTION__, task_pid_nr(current) , ## arg); \
 } while (0)
 
 #define PRINT_FCALL_ERROR(s, fcall) P9_DPRINTK(P9_DEBUG_ERROR,   \
@@ -59,7 +59,7 @@ do {  \
 #define P9_EPRINTK(level, format, arg...) \
 do { \
 	printk(level "9p: %s (%d): " \
-		format , __FUNCTION__, current->pid , ## arg); \
+		format , __FUNCTION__, task_pid_nr(current), ## arg); \
 } while (0)
 
 
diff -puN kernel/cpu.c~use-helpers-to-obtain-task-pid-in-printks kernel/cpu.c
--- a/kernel/cpu.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/kernel/cpu.c
@@ -98,7 +98,8 @@ static inline void check_for_tasks(int c
 		     !cputime_eq(p->stime, cputime_zero)))
 			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d\
 				(state = %ld, flags = %x) \n",
-				 p->comm, p->pid, cpu, p->state, p->flags);
+				 p->comm, task_pid_nr(p), cpu,
+				 p->state, p->flags);
 	}
 	write_unlock_irq(&tasklist_lock);
 }
diff -puN kernel/exit.c~use-helpers-to-obtain-task-pid-in-printks kernel/exit.c
--- a/kernel/exit.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/kernel/exit.c
@@ -959,7 +959,7 @@ fastcall NORET_TYPE void do_exit(long co
 
 	if (unlikely(in_atomic()))
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
-				current->comm, current->pid,
+				current->comm, task_pid_nr(current),
 				preempt_count());
 
 	acct_update_integrals(tsk);
diff -puN kernel/lockdep.c~use-helpers-to-obtain-task-pid-in-printks kernel/lockdep.c
--- a/kernel/lockdep.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/kernel/lockdep.c
@@ -511,11 +511,11 @@ static void lockdep_print_held_locks(str
 	int i, depth = curr->lockdep_depth;
 
 	if (!depth) {
-		printk("no locks held by %s/%d.\n", curr->comm, curr->pid);
+		printk("no locks held by %s/%d.\n", curr->comm, task_pid_nr(curr));
 		return;
 	}
 	printk("%d lock%s held by %s/%d:\n",
-		depth, depth > 1 ? "s" : "", curr->comm, curr->pid);
+		depth, depth > 1 ? "s" : "", curr->comm, task_pid_nr(curr));
 
 	for (i = 0; i < depth; i++) {
 		printk(" #%d: ", i);
@@ -904,7 +904,7 @@ print_circular_bug_header(struct lock_li
 	print_kernel_version();
 	printk(  "-------------------------------------------------------\n");
 	printk("%s/%d is trying to acquire lock:\n",
-		curr->comm, curr->pid);
+		curr->comm, task_pid_nr(curr));
 	print_lock(check_source);
 	printk("\nbut task is already holding lock:\n");
 	print_lock(check_target);
@@ -1085,7 +1085,7 @@ print_bad_irq_dependency(struct task_str
 	print_kernel_version();
 	printk(  "------------------------------------------------------\n");
 	printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] is trying to acquire:\n",
-		curr->comm, curr->pid,
+		curr->comm, task_pid_nr(curr),
 		curr->hardirq_context, hardirq_count() >> HARDIRQ_SHIFT,
 		curr->softirq_context, softirq_count() >> SOFTIRQ_SHIFT,
 		curr->hardirqs_enabled,
@@ -1237,7 +1237,7 @@ print_deadlock_bug(struct task_struct *c
 	print_kernel_version();
 	printk(  "---------------------------------------------\n");
 	printk("%s/%d is trying to acquire lock:\n",
-		curr->comm, curr->pid);
+		curr->comm, task_pid_nr(curr));
 	print_lock(next);
 	printk("\nbut task is already holding lock:\n");
 	print_lock(prev);
@@ -1641,7 +1641,7 @@ print_usage_bug(struct task_struct *curr
 		usage_str[prev_bit], usage_str[new_bit]);
 
 	printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] takes:\n",
-		curr->comm, curr->pid,
+		curr->comm, task_pid_nr(curr),
 		trace_hardirq_context(curr), hardirq_count() >> HARDIRQ_SHIFT,
 		trace_softirq_context(curr), softirq_count() >> SOFTIRQ_SHIFT,
 		trace_hardirqs_enabled(curr),
@@ -1694,7 +1694,7 @@ print_irq_inversion_bug(struct task_stru
 	print_kernel_version();
 	printk(  "---------------------------------------------------------\n");
 	printk("%s/%d just changed the state of lock:\n",
-		curr->comm, curr->pid);
+		curr->comm, task_pid_nr(curr));
 	print_lock(this);
 	if (forwards)
 		printk("but this lock took another, %s-irq-unsafe lock in the past:\n", irqclass);
@@ -2487,7 +2487,7 @@ print_unlock_inbalance_bug(struct task_s
 	printk(  "[ BUG: bad unlock balance detected! ]\n");
 	printk(  "-------------------------------------\n");
 	printk("%s/%d is trying to release lock (",
-		curr->comm, curr->pid);
+		curr->comm, task_pid_nr(curr));
 	print_lockdep_cache(lock);
 	printk(") at:\n");
 	print_ip_sym(ip);
@@ -2737,7 +2737,7 @@ print_lock_contention_bug(struct task_st
 	printk(  "[ BUG: bad contention detected! ]\n");
 	printk(  "---------------------------------\n");
 	printk("%s/%d is trying to contend lock (",
-		curr->comm, curr->pid);
+		curr->comm, task_pid_nr(curr));
 	print_lockdep_cache(lock);
 	printk(") at:\n");
 	print_ip_sym(ip);
@@ -3072,7 +3072,7 @@ print_freed_lock_bug(struct task_struct 
 	printk(  "[ BUG: held lock freed! ]\n");
 	printk(  "-------------------------\n");
 	printk("%s/%d is freeing memory %p-%p, with a lock still held there!\n",
-		curr->comm, curr->pid, mem_from, mem_to-1);
+		curr->comm, task_pid_nr(curr), mem_from, mem_to-1);
 	print_lock(hlock);
 	lockdep_print_held_locks(curr);
 
@@ -3125,7 +3125,7 @@ static void print_held_locks_bug(struct 
 	printk(  "[ BUG: lock held at task exit time! ]\n");
 	printk(  "-------------------------------------\n");
 	printk("%s/%d is exiting with locks still held!\n",
-		curr->comm, curr->pid);
+		curr->comm, task_pid_nr(curr));
 	lockdep_print_held_locks(curr);
 
 	printk("\nstack backtrace:\n");
diff -puN kernel/rtmutex-debug.c~use-helpers-to-obtain-task-pid-in-printks kernel/rtmutex-debug.c
--- a/kernel/rtmutex-debug.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/kernel/rtmutex-debug.c
@@ -87,7 +87,7 @@ static int rt_trace_on = 1;
 static void printk_task(struct task_struct *p)
 {
 	if (p)
-		printk("%16s:%5d [%p, %3d]", p->comm, p->pid, p, p->prio);
+		printk("%16s:%5d [%p, %3d]", p->comm, task_pid_nr(p), p, p->prio);
 	else
 		printk("<none>");
 }
@@ -152,22 +152,25 @@ void debug_rt_mutex_print_deadlock(struc
 	printk(  "[ BUG: circular locking deadlock detected! ]\n");
 	printk(  "--------------------------------------------\n");
 	printk("%s/%d is deadlocking current task %s/%d\n\n",
-	       task->comm, task->pid, current->comm, current->pid);
+	       task->comm, task_pid_nr(task),
+	       current->comm, task_pid_nr(current));
 
 	printk("\n1) %s/%d is trying to acquire this lock:\n",
-	       current->comm, current->pid);
+	       current->comm, task_pid_nr(current));
 	printk_lock(waiter->lock, 1);
 
-	printk("\n2) %s/%d is blocked on this lock:\n", task->comm, task->pid);
+	printk("\n2) %s/%d is blocked on this lock:\n",
+		task->comm, task_pid_nr(task));
 	printk_lock(waiter->deadlock_lock, 1);
 
 	debug_show_held_locks(current);
 	debug_show_held_locks(task);
 
-	printk("\n%s/%d's [blocked] stackdump:\n\n", task->comm, task->pid);
+	printk("\n%s/%d's [blocked] stackdump:\n\n",
+		task->comm, task_pid_nr(task));
 	show_stack(task, NULL);
 	printk("\n%s/%d's [current] stackdump:\n\n",
-	       current->comm, current->pid);
+		current->comm, task_pid_nr(current));
 	dump_stack();
 	debug_show_all_locks();
 
diff -puN kernel/rtmutex.c~use-helpers-to-obtain-task-pid-in-printks kernel/rtmutex.c
--- a/kernel/rtmutex.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/kernel/rtmutex.c
@@ -185,7 +185,7 @@ static int rt_mutex_adjust_prio_chain(st
 			prev_max = max_lock_depth;
 			printk(KERN_WARNING "Maximum lock depth %d reached "
 			       "task: %s (%d)\n", max_lock_depth,
-			       top_task->comm, top_task->pid);
+			       top_task->comm, task_pid_nr(top_task));
 		}
 		put_task_struct(task);
 
diff -puN kernel/sched.c~use-helpers-to-obtain-task-pid-in-printks kernel/sched.c
--- a/kernel/sched.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/kernel/sched.c
@@ -3502,7 +3502,7 @@ EXPORT_SYMBOL(sub_preempt_count);
 static noinline void __schedule_bug(struct task_struct *prev)
 {
 	printk(KERN_ERR "BUG: scheduling while atomic: %s/0x%08x/%d\n",
-		prev->comm, preempt_count(), prev->pid);
+		prev->comm, preempt_count(), task_pid_nr(prev));
 	debug_show_held_locks(prev);
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
@@ -4865,7 +4865,8 @@ static void show_task(struct task_struct
 		free = (unsigned long)n - (unsigned long)end_of_stack(p);
 	}
 #endif
-	printk(KERN_CONT "%5lu %5d %6d\n", free, p->pid, p->parent->pid);
+	printk(KERN_CONT "%5lu %5d %6d\n", free,
+		task_pid_nr(p), task_pid_nr(p->parent));
 
 	if (state != TASK_RUNNING)
 		show_stack(p, NULL);
@@ -5172,7 +5173,7 @@ static void move_task_off_dead_cpu(int d
 			if (p->mm && printk_ratelimit())
 				printk(KERN_INFO "process %d (%s) no "
 				       "longer affine to cpu%d\n",
-				       p->pid, p->comm, dead_cpu);
+			       task_pid_nr(p), p->comm, dead_cpu);
 		}
 	} while (!__migrate_task_irq(p, dead_cpu, dest_cpu));
 }
diff -puN kernel/signal.c~use-helpers-to-obtain-task-pid-in-printks kernel/signal.c
--- a/kernel/signal.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/kernel/signal.c
@@ -730,7 +730,7 @@ int print_fatal_signals;
 static void print_fatal_signal(struct pt_regs *regs, int signr)
 {
 	printk("%s/%d: potentially unexpected fatal signal %d.\n",
-		current->comm, current->pid, signr);
+		current->comm, task_pid_nr(current), signr);
 
 #ifdef __i386__
 	printk("code at %08lx: ", regs->eip);
diff -puN kernel/softlockup.c~use-helpers-to-obtain-task-pid-in-printks kernel/softlockup.c
--- a/kernel/softlockup.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/kernel/softlockup.c
@@ -113,7 +113,7 @@ void softlockup_tick(void)
 	spin_lock(&print_lock);
 	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
 			this_cpu, now - touch_timestamp,
-				current->comm, current->pid);
+			current->comm, task_pid_nr(current));
 	if (regs)
 		show_regs(regs);
 	else
diff -puN kernel/workqueue.c~use-helpers-to-obtain-task-pid-in-printks kernel/workqueue.c
--- a/kernel/workqueue.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/kernel/workqueue.c
@@ -282,7 +282,7 @@ static void run_workqueue(struct cpu_wor
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
 					"%s/0x%08x/%d\n",
 					current->comm, preempt_count(),
-				       	current->pid);
+				       	task_pid_nr(current));
 			printk(KERN_ERR "    last function: ");
 			print_symbol("%s\n", (unsigned long)f);
 			debug_show_held_locks(current);
diff -puN lib/spinlock_debug.c~use-helpers-to-obtain-task-pid-in-printks lib/spinlock_debug.c
--- a/lib/spinlock_debug.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/lib/spinlock_debug.c
@@ -60,12 +60,12 @@ static void spin_bug(spinlock_t *lock, c
 		owner = lock->owner;
 	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
 		msg, raw_smp_processor_id(),
-		current->comm, current->pid);
+		current->comm, task_pid_nr(current));
 	printk(KERN_EMERG " lock: %p, .magic: %08x, .owner: %s/%d, "
 			".owner_cpu: %d\n",
 		lock, lock->magic,
 		owner ? owner->comm : "<none>",
-		owner ? owner->pid : -1,
+		owner ? task_pid_nr(owner) : -1,
 		lock->owner_cpu);
 	dump_stack();
 }
@@ -116,7 +116,7 @@ static void __spin_lock_debug(spinlock_t
 			printk(KERN_EMERG "BUG: spinlock lockup on CPU#%d, "
 					"%s/%d, %p\n",
 				raw_smp_processor_id(), current->comm,
-				current->pid, lock);
+				task_pid_nr(current), lock);
 			dump_stack();
 #ifdef CONFIG_SMP
 			trigger_all_cpu_backtrace();
@@ -161,7 +161,7 @@ static void rwlock_bug(rwlock_t *lock, c
 
 	printk(KERN_EMERG "BUG: rwlock %s on CPU#%d, %s/%d, %p\n",
 		msg, raw_smp_processor_id(), current->comm,
-		current->pid, lock);
+		task_pid_nr(current), lock);
 	dump_stack();
 }
 
diff -puN mm/oom_kill.c~use-helpers-to-obtain-task-pid-in-printks mm/oom_kill.c
--- a/mm/oom_kill.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/mm/oom_kill.c
@@ -278,7 +278,8 @@ static void __oom_kill_task(struct task_
 	}
 
 	if (verbose)
-		printk(KERN_ERR "Killed process %d (%s)\n", p->pid, p->comm);
+		printk(KERN_ERR "Killed process %d (%s)\n",
+				task_pid_nr(p), p->comm);
 
 	/*
 	 * We give our sacrificial lamb high priority and access to
@@ -356,7 +357,7 @@ static int oom_kill_process(struct task_
 	}
 
 	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
-					message, p->pid, p->comm, points);
+					message, task_pid_nr(p), p->comm, points);
 
 	/* Try to kill a child first */
 	list_for_each_entry(c, &p->children, sibling) {
diff -puN net/core/pktgen.c~use-helpers-to-obtain-task-pid-in-printks net/core/pktgen.c
--- a/net/core/pktgen.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/net/core/pktgen.c
@@ -3514,7 +3514,7 @@ static int pktgen_thread_worker(void *ar
 
 	init_waitqueue_head(&t->queue);
 
-	pr_debug("pktgen: starting pktgen/%d:  pid=%d\n", cpu, current->pid);
+	pr_debug("pktgen: starting pktgen/%d:  pid=%d\n", cpu, task_pid_nr(current));
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
diff -puN net/core/sock.c~use-helpers-to-obtain-task-pid-in-printks net/core/sock.c
--- a/net/core/sock.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/net/core/sock.c
@@ -232,7 +232,7 @@ static int sock_set_timeout(long *timeo_
 			warned++;
 			printk(KERN_INFO "sock_set_timeout: `%s' (pid %d) "
 			       "tries to set negative timeout\n",
-				current->comm, current->pid);
+				current->comm, task_pid_nr(current));
 		return 0;
 	}
 	*timeo_p = MAX_SCHEDULE_TIMEOUT;
diff -puN net/ipv4/ipvs/ip_vs_sync.c~use-helpers-to-obtain-task-pid-in-printks net/ipv4/ipvs/ip_vs_sync.c
--- a/net/ipv4/ipvs/ip_vs_sync.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/net/ipv4/ipvs/ip_vs_sync.c
@@ -877,7 +877,7 @@ int start_sync_thread(int state, char *m
 	if (!tinfo)
 		return -ENOMEM;
 
-	IP_VS_DBG(7, "%s: pid %d\n", __FUNCTION__, current->pid);
+	IP_VS_DBG(7, "%s: pid %d\n", __FUNCTION__, task_pid_nr(current));
 	IP_VS_DBG(7, "Each ip_vs_sync_conn entry need %Zd bytes\n",
 		  sizeof(struct ip_vs_sync_conn));
 
@@ -917,7 +917,7 @@ int stop_sync_thread(int state)
 	    (state == IP_VS_STATE_BACKUP && !sync_backup_pid))
 		return -ESRCH;
 
-	IP_VS_DBG(7, "%s: pid %d\n", __FUNCTION__, current->pid);
+	IP_VS_DBG(7, "%s: pid %d\n", __FUNCTION__, task_pid_nr(current));
 	IP_VS_INFO("stopping sync thread %d ...\n",
 		   (state == IP_VS_STATE_MASTER) ?
 		   sync_master_pid : sync_backup_pid);
diff -puN net/ipv4/tcp.c~use-helpers-to-obtain-task-pid-in-printks net/ipv4/tcp.c
--- a/net/ipv4/tcp.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/net/ipv4/tcp.c
@@ -1334,7 +1334,7 @@ do_prequeue:
 		if ((flags & MSG_PEEK) && peek_seq != tp->copied_seq) {
 			if (net_ratelimit())
 				printk(KERN_DEBUG "TCP(%s:%d): Application bug, race in MSG_PEEK.\n",
-				       current->comm, current->pid);
+				       current->comm, task_pid_nr(current));
 			peek_seq = tp->copied_seq;
 		}
 		continue;
diff -puN net/llc/af_llc.c~use-helpers-to-obtain-task-pid-in-printks net/llc/af_llc.c
--- a/net/llc/af_llc.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/net/llc/af_llc.c
@@ -762,7 +762,7 @@ static int llc_ui_recvmsg(struct kiocb *
 			if (net_ratelimit())
 				printk(KERN_DEBUG "LLC(%s:%d): Application "
 						  "bug, race in MSG_PEEK.\n",
-				       current->comm, current->pid);
+				       current->comm, task_pid_nr(current));
 			peek_seq = llc->copied_seq;
 		}
 		continue;
diff -puN net/sunrpc/sched.c~use-helpers-to-obtain-task-pid-in-printks net/sunrpc/sched.c
--- a/net/sunrpc/sched.c~use-helpers-to-obtain-task-pid-in-printks
+++ a/net/sunrpc/sched.c
@@ -847,7 +847,7 @@ void rpc_init_task(struct rpc_task *task
 	task->tk_start = jiffies;
 
 	dprintk("RPC:       new task initialized, procpid %u\n",
-				current->pid);
+				task_pid_nr(current));
 }
 
 static struct rpc_task *
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
