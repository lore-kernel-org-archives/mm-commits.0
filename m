From: akpm@linux-foundation.org
Subject: - oops-in-pwc-v4l-driver.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:13:49 -0700
Message-ID: <200710010713.l917Dnmv004476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910AbXJAHOJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:14:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oliver@neukum.org, lkml@alex-smith.me.uk, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fix oops in pwc v4l driver
has been removed from the -mm tree.  Its filename was
     oops-in-pwc-v4l-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix oops in pwc v4l driver
From: Oliver Neukum <oliver@neukum.org>

unchangelogged patch.

Tested-by: "Alex Smith" <lkml@alex-smith.me.uk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pwc/pwc-if.c |   96 +++++++++++++++++++++--------
 1 file changed, 72 insertions(+), 24 deletions(-)

diff -puN drivers/media/video/pwc/pwc-if.c~oops-in-pwc-v4l-driver drivers/media/video/pwc/pwc-if.c
--- a/drivers/media/video/pwc/pwc-if.c~oops-in-pwc-v4l-driver
+++ a/drivers/media/video/pwc/pwc-if.c
@@ -907,31 +907,49 @@ int pwc_isoc_init(struct pwc_device *pde
 	return 0;
 }
 
-void pwc_isoc_cleanup(struct pwc_device *pdev)
+static void pwc_iso_stop(struct pwc_device *pdev)
 {
 	int i;
 
-	PWC_DEBUG_OPEN(">> pwc_isoc_cleanup()\n");
-	if (pdev == NULL)
-		return;
-	if (pdev->iso_init == 0)
-		return;
-
 	/* Unlinking ISOC buffers one by one */
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
 		struct urb *urb;
 
 		urb = pdev->sbuf[i].urb;
 		if (urb != 0) {
-			if (pdev->iso_init) {
-				PWC_DEBUG_MEMORY("Unlinking URB %p\n", urb);
-				usb_kill_urb(urb);
-			}
+			PWC_DEBUG_MEMORY("Unlinking URB %p\n", urb);
+			usb_kill_urb(urb);
+		}
+	}
+}
+
+static void pwc_iso_free(struct pwc_device *pdev)
+{
+	int i;
+
+	/* Freeing ISOC buffers one by one */
+	for (i = 0; i < MAX_ISO_BUFS; i++) {
+		struct urb *urb;
+
+		urb = pdev->sbuf[i].urb;
+		if (urb != 0) {
 			PWC_DEBUG_MEMORY("Freeing URB\n");
 			usb_free_urb(urb);
 			pdev->sbuf[i].urb = NULL;
 		}
 	}
+}
+
+void pwc_isoc_cleanup(struct pwc_device *pdev)
+{
+	PWC_DEBUG_OPEN(">> pwc_isoc_cleanup()\n");
+	if (pdev == NULL)
+		return;
+	if (pdev->iso_init == 0)
+		return;
+
+	pwc_iso_stop(pdev);
+	pwc_iso_free(pdev);
 
 	/* Stop camera, but only if we are sure the camera is still there (unplug
 	   is signalled by EPIPE)
@@ -1211,6 +1229,7 @@ static int pwc_video_close(struct inode 
 
 	PWC_DEBUG_OPEN(">> video_close called(vdev = 0x%p).\n", vdev);
 
+	lock_kernel();
 	pdev = (struct pwc_device *)vdev->priv;
 	if (pdev->vopen == 0)
 		PWC_DEBUG_MODULE("video_close() called on closed device?\n");
@@ -1230,7 +1249,6 @@ static int pwc_video_close(struct inode 
 	pwc_isoc_cleanup(pdev);
 	pwc_free_buffers(pdev);
 
-	lock_kernel();
 	/* Turn off LEDS and power down camera, but only when not unplugged */
 	if (!pdev->unplugged) {
 		/* Turn LEDs off */
@@ -1276,7 +1294,7 @@ static ssize_t pwc_video_read(struct fil
 	struct pwc_device *pdev;
 	int noblock = file->f_flags & O_NONBLOCK;
 	DECLARE_WAITQUEUE(wait, current);
-	int bytes_to_read;
+	int bytes_to_read, rv = 0;
 	void *image_buffer_addr;
 
 	PWC_DEBUG_READ("pwc_video_read(vdev=0x%p, buf=%p, count=%zd) called.\n",
@@ -1286,8 +1304,12 @@ static ssize_t pwc_video_read(struct fil
 	pdev = vdev->priv;
 	if (pdev == NULL)
 		return -EFAULT;
-	if (pdev->error_status)
-		return -pdev->error_status; /* Something happened, report what. */
+
+	mutex_lock(&pdev->modlock);
+	if (pdev->error_status) {
+		rv = -pdev->error_status; /* Something happened, report what. */
+		goto err_out;
+	}
 
 	/* In case we're doing partial reads, we don't have to wait for a frame */
 	if (pdev->image_read_pos == 0) {
@@ -1298,17 +1320,20 @@ static ssize_t pwc_video_read(struct fil
 			if (pdev->error_status) {
 				remove_wait_queue(&pdev->frameq, &wait);
 				set_current_state(TASK_RUNNING);
-				return -pdev->error_status ;
+				rv = -pdev->error_status ;
+				goto err_out;
 			}
 			if (noblock) {
 				remove_wait_queue(&pdev->frameq, &wait);
 				set_current_state(TASK_RUNNING);
-				return -EWOULDBLOCK;
+				rv = -EWOULDBLOCK;
+				goto err_out;
 			}
 			if (signal_pending(current)) {
 				remove_wait_queue(&pdev->frameq, &wait);
 				set_current_state(TASK_RUNNING);
-				return -ERESTARTSYS;
+				rv = -ERESTARTSYS;
+				goto err_out;
 			}
 			schedule();
 			set_current_state(TASK_INTERRUPTIBLE);
@@ -1317,8 +1342,10 @@ static ssize_t pwc_video_read(struct fil
 		set_current_state(TASK_RUNNING);
 
 		/* Decompress and release frame */
-		if (pwc_handle_frame(pdev))
-			return -EFAULT;
+		if (pwc_handle_frame(pdev)) {
+			rv = -EFAULT;
+			goto err_out;
+		}
 	}
 
 	PWC_DEBUG_READ("Copying data to user space.\n");
@@ -1333,14 +1360,20 @@ static ssize_t pwc_video_read(struct fil
 	image_buffer_addr = pdev->image_data;
 	image_buffer_addr += pdev->images[pdev->fill_image].offset;
 	image_buffer_addr += pdev->image_read_pos;
-	if (copy_to_user(buf, image_buffer_addr, count))
-		return -EFAULT;
+	if (copy_to_user(buf, image_buffer_addr, count)) {
+		rv = -EFAULT;
+		goto err_out;
+	}
 	pdev->image_read_pos += count;
 	if (pdev->image_read_pos >= bytes_to_read) { /* All data has been read */
 		pdev->image_read_pos = 0;
 		pwc_next_image(pdev);
 	}
+	mutex_unlock(&pdev->modlock);
 	return count;
+err_out:
+	mutex_unlock(&pdev->modlock);
+	return rv;
 }
 
 static unsigned int pwc_video_poll(struct file *file, poll_table *wait)
@@ -1366,7 +1399,20 @@ static unsigned int pwc_video_poll(struc
 static int pwc_video_ioctl(struct inode *inode, struct file *file,
 			   unsigned int cmd, unsigned long arg)
 {
-	return video_usercopy(inode, file, cmd, arg, pwc_video_do_ioctl);
+	struct video_device *vdev = file->private_data;
+	struct pwc_device *pdev;
+	int r = -ENODEV;
+
+	if (!vdev)
+		goto out;
+	pdev = vdev->priv;
+
+	mutex_lock(&pdev->modlock);
+	if (!pdev->unplugged)
+		r = video_usercopy(inode, file, cmd, arg, pwc_video_do_ioctl);
+	mutex_unlock(&pdev->modlock);
+out:
+	return r;
 }
 
 static int pwc_video_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1809,7 +1855,10 @@ static void usb_pwc_disconnect(struct us
 	wake_up_interruptible(&pdev->frameq);
 	/* Wait until device is closed */
 	if(pdev->vopen) {
+		mutex_lock(&pdev->modlock);
 		pdev->unplugged = 1;
+		mutex_unlock(&pdev->modlock);
+		pwc_iso_stop(pdev);
 	} else {
 		/* Device is closed, so we can safely unregister it */
 		PWC_DEBUG_PROBE("Unregistering video device in disconnect().\n");
@@ -1827,7 +1876,6 @@ disconnect_out:
 	unlock_kernel();
 }
 
-
 /* *grunt* We have to do atoi ourselves :-( */
 static int pwc_atoi(const char *s)
 {
_

Patches currently in -mm which might be from oliver@neukum.org are

git-dvb.patch
git-hid.patch
