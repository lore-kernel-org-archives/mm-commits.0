From: akpm@linux-foundation.org
Subject: [merged] kfifo-move-struct-kfifo-in-place.patch removed from -mm tree
Date: Wed, 23 Dec 2009 12:58:30 -0800
Message-ID: <200912232058.nBNKwUIl021173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755907AbZLWU7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Dec 2009 15:59:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, ak@linux.intel.com, arnd@arndb.de, gregkh@suse.de, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kfifo: move struct kfifo in place
has been removed from the -mm tree.  Its filename was
     kfifo-move-struct-kfifo-in-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo: move struct kfifo in place
From: Stefani Seibold <stefani@seibold.net>

This is a new generic kernel FIFO implementation.

The current kernel fifo API is not very widely used, because it has to
many constrains.  Only 17 files in the current 2.6.31-rc5 used it.  FIFO's
are like list's a very basic thing and a kfifo API which handles the most
use case would save a lot of development time and memory resources.

I think this are the reasons why kfifo is not in use:

- The API is to simple, important functions are missing
- A fifo can be only allocated dynamically
- There is a need of a spinlock despite you need it or not
- There is no support for data records inside a fifo

So I decided to extend the kfifo in a more generic way without blowing up
the API to much.  The new API has the following benefits:

- Generic usage: For kernel internal use and/or device driver.
- Provide an API for the most use case.
- Slim API: The whole API provides 25 functions.
- Linux style habit.
- DECLARE_KFIFO, DEFINE_KFIFO and INIT_KFIFO Macros
- Direct copy_to_user from the fifo and copy_from_user into the fifo.
- The kfifo itself is an in place member of the using data structure, this save an 
  indirection access and does not waste the kernel allocator. 
- Lockless access: if only one reader and one writer is active on the fifo,
  which is the common use case, no additional locking is necessary.
- Remove spinlock - give the user the freedom of choice what kind of locking to use if 
  one is required.
- Ability to handle records. Three type of records are supported:
  - Variable length records between 0-255 bytes, with a record size field of 1 bytes.
  - Variable length records between 0-65535 bytes, with a record size field of 2 bytes.
  - Fixed size records, which no record size field.
- Preserve memory resource.
- Performance!
- Easy to use!



This patch:

Since most users want to have the kfifo as part of another object,
reorganize the code to allow including struct kfifo in another data
structure.  This requires changing the kfifo_alloc and kfifo_init
prototypes so that we pass an existing kfifo pointer into them.  This
patch changes the implementation and all existing users.

[akpm@linux-foundation.org: fix warning]
Signed-off-by: Stefani Seibold <stefani@seibold.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c                       |   21 ++---
 drivers/char/sonypi.c                       |   40 +++++------
 drivers/infiniband/hw/cxgb3/cxio_hal.h      |    9 +-
 drivers/infiniband/hw/cxgb3/cxio_resource.c |   60 ++++++++--------
 drivers/media/video/meye.c                  |   48 ++++++-------
 drivers/media/video/meye.h                  |    4 -
 drivers/net/wireless/libertas/cmd.c         |    4 -
 drivers/net/wireless/libertas/dev.h         |    4 -
 drivers/net/wireless/libertas/main.c        |   16 +---
 drivers/platform/x86/fujitsu-laptop.c       |   18 ++--
 drivers/platform/x86/sony-laptop.c          |   46 ++++++------
 drivers/scsi/libiscsi.c                     |   22 ++----
 drivers/scsi/libiscsi_tcp.c                 |   29 +++-----
 drivers/scsi/libsrp.c                       |   13 +--
 drivers/usb/host/fhci-sched.c               |   10 +-
 drivers/usb/host/fhci-tds.c                 |   35 ++++-----
 drivers/usb/host/fhci.h                     |   10 +-
 drivers/usb/serial/usb-serial.c             |    5 -
 include/linux/kfifo.h                       |   11 +--
 include/scsi/libiscsi.h                     |    3 
 include/scsi/libiscsi_tcp.h                 |    2 
 include/scsi/libsrp.h                       |    2 
 kernel/kfifo.c                              |   65 +++++++++---------
 net/dccp/probe.c                            |   20 ++---
 24 files changed, 238 insertions(+), 259 deletions(-)

diff -puN drivers/char/nozomi.c~kfifo-move-struct-kfifo-in-place drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/char/nozomi.c
@@ -358,7 +358,7 @@ struct port {
 	u8 update_flow_control;
 	struct ctrl_ul ctrl_ul;
 	struct ctrl_dl ctrl_dl;
-	struct kfifo *fifo_ul;
+	struct kfifo fifo_ul;
 	void __iomem *dl_addr[2];
 	u32 dl_size[2];
 	u8 toggle_dl;
@@ -685,8 +685,8 @@ static int nozomi_read_config_table(stru
 		dump_table(dc);
 
 		for (i = PORT_MDM; i < MAX_PORT; i++) {
-			dc->port[i].fifo_ul =
-			    kfifo_alloc(FIFO_BUFFER_SIZE_UL, GFP_ATOMIC, NULL);
+			kfifo_alloc(&dc->port[i].fifo_ul,
+				FIFO_BUFFER_SIZE_UL, GFP_ATOMIC, NULL);
 			memset(&dc->port[i].ctrl_dl, 0, sizeof(struct ctrl_dl));
 			memset(&dc->port[i].ctrl_ul, 0, sizeof(struct ctrl_ul));
 		}
@@ -798,7 +798,7 @@ static int send_data(enum port_type inde
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
 
 	/* Get data from tty and place in buf for now */
-	size = __kfifo_get(port->fifo_ul, dc->send_buf,
+	size = __kfifo_get(&port->fifo_ul, dc->send_buf,
 			   ul_size < SEND_BUF_MAX ? ul_size : SEND_BUF_MAX);
 
 	if (size == 0) {
@@ -988,11 +988,11 @@ static int receive_flow_control(struct n
 
 	} else if (old_ctrl.CTS == 0 && ctrl_dl.CTS == 1) {
 
-		if (__kfifo_len(dc->port[port].fifo_ul)) {
+		if (__kfifo_len(&dc->port[port].fifo_ul)) {
 			DBG1("Enable interrupt (0x%04X) on port: %d",
 				enable_ier, port);
 			DBG1("Data in buffer [%d], enable transmit! ",
-				__kfifo_len(dc->port[port].fifo_ul));
+				__kfifo_len(&dc->port[port].fifo_ul));
 			enable_transmit_ul(port, dc);
 		} else {
 			DBG1("No data in buffer...");
@@ -1536,8 +1536,7 @@ static void __devexit nozomi_card_exit(s
 	free_irq(pdev->irq, dc);
 
 	for (i = 0; i < MAX_PORT; i++)
-		if (dc->port[i].fifo_ul)
-			kfifo_free(dc->port[i].fifo_ul);
+		kfifo_free(&dc->port[i].fifo_ul);
 
 	kfree(dc->send_buf);
 
@@ -1673,7 +1672,7 @@ static int ntty_write(struct tty_struct 
 		goto exit;
 	}
 
-	rval = __kfifo_put(port->fifo_ul, (unsigned char *)buffer, count);
+	rval = __kfifo_put(&port->fifo_ul, (unsigned char *)buffer, count);
 
 	/* notify card */
 	if (unlikely(dc == NULL)) {
@@ -1721,7 +1720,7 @@ static int ntty_write_room(struct tty_st
 	if (!port->port.count)
 		goto exit;
 
-	room = port->fifo_ul->size - __kfifo_len(port->fifo_ul);
+	room = port->fifo_ul.size - __kfifo_len(&port->fifo_ul);
 
 exit:
 	mutex_unlock(&port->tty_sem);
@@ -1878,7 +1877,7 @@ static s32 ntty_chars_in_buffer(struct t
 		goto exit_in_buffer;
 	}
 
-	rval = __kfifo_len(port->fifo_ul);
+	rval = __kfifo_len(&port->fifo_ul);
 
 exit_in_buffer:
 	return rval;
diff -puN drivers/char/sonypi.c~kfifo-move-struct-kfifo-in-place drivers/char/sonypi.c
--- a/drivers/char/sonypi.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/char/sonypi.c
@@ -487,7 +487,7 @@ static struct sonypi_device {
 	int camera_power;
 	int bluetooth_power;
 	struct mutex lock;
-	struct kfifo *fifo;
+	struct kfifo fifo;
 	spinlock_t fifo_lock;
 	wait_queue_head_t fifo_proc_list;
 	struct fasync_struct *fifo_async;
@@ -496,7 +496,7 @@ static struct sonypi_device {
 	struct input_dev *input_jog_dev;
 	struct input_dev *input_key_dev;
 	struct work_struct input_work;
-	struct kfifo *input_fifo;
+	struct kfifo input_fifo;
 	spinlock_t input_fifo_lock;
 } sonypi_device;
 
@@ -777,7 +777,7 @@ static void input_keyrelease(struct work
 {
 	struct sonypi_keypress kp;
 
-	while (kfifo_get(sonypi_device.input_fifo, (unsigned char *)&kp,
+	while (kfifo_get(&sonypi_device.input_fifo, (unsigned char *)&kp,
 			 sizeof(kp)) == sizeof(kp)) {
 		msleep(10);
 		input_report_key(kp.dev, kp.key, 0);
@@ -827,7 +827,7 @@ static void sonypi_report_input_event(u8
 	if (kp.dev) {
 		input_report_key(kp.dev, kp.key, 1);
 		input_sync(kp.dev);
-		kfifo_put(sonypi_device.input_fifo,
+		kfifo_put(&sonypi_device.input_fifo,
 			  (unsigned char *)&kp, sizeof(kp));
 		schedule_work(&sonypi_device.input_work);
 	}
@@ -880,7 +880,7 @@ found:
 		acpi_bus_generate_proc_event(sonypi_acpi_device, 1, event);
 #endif
 
-	kfifo_put(sonypi_device.fifo, (unsigned char *)&event, sizeof(event));
+	kfifo_put(&sonypi_device.fifo, (unsigned char *)&event, sizeof(event));
 	kill_fasync(&sonypi_device.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_device.fifo_proc_list);
 
@@ -906,7 +906,7 @@ static int sonypi_misc_open(struct inode
 	mutex_lock(&sonypi_device.lock);
 	/* Flush input queue on first open */
 	if (!sonypi_device.open_count)
-		kfifo_reset(sonypi_device.fifo);
+		kfifo_reset(&sonypi_device.fifo);
 	sonypi_device.open_count++;
 	mutex_unlock(&sonypi_device.lock);
 	unlock_kernel();
@@ -919,17 +919,17 @@ static ssize_t sonypi_misc_read(struct f
 	ssize_t ret;
 	unsigned char c;
 
-	if ((kfifo_len(sonypi_device.fifo) == 0) &&
+	if ((kfifo_len(&sonypi_device.fifo) == 0) &&
 	    (file->f_flags & O_NONBLOCK))
 		return -EAGAIN;
 
 	ret = wait_event_interruptible(sonypi_device.fifo_proc_list,
-				       kfifo_len(sonypi_device.fifo) != 0);
+				       kfifo_len(&sonypi_device.fifo) != 0);
 	if (ret)
 		return ret;
 
 	while (ret < count &&
-	       (kfifo_get(sonypi_device.fifo, &c, sizeof(c)) == sizeof(c))) {
+	       (kfifo_get(&sonypi_device.fifo, &c, sizeof(c)) == sizeof(c))) {
 		if (put_user(c, buf++))
 			return -EFAULT;
 		ret++;
@@ -946,7 +946,7 @@ static ssize_t sonypi_misc_read(struct f
 static unsigned int sonypi_misc_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &sonypi_device.fifo_proc_list, wait);
-	if (kfifo_len(sonypi_device.fifo))
+	if (kfifo_len(&sonypi_device.fifo))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
@@ -1313,11 +1313,11 @@ static int __devinit sonypi_probe(struct
 			"http://www.linux.it/~malattia/wiki/index.php/Sony_drivers\n");
 
 	spin_lock_init(&sonypi_device.fifo_lock);
-	sonypi_device.fifo = kfifo_alloc(SONYPI_BUF_SIZE, GFP_KERNEL,
+	error = kfifo_alloc(&sonypi_device.fifo, SONYPI_BUF_SIZE, GFP_KERNEL,
 					 &sonypi_device.fifo_lock);
-	if (IS_ERR(sonypi_device.fifo)) {
+	if (error) {
 		printk(KERN_ERR "sonypi: kfifo_alloc failed\n");
-		return PTR_ERR(sonypi_device.fifo);
+		return error;
 	}
 
 	init_waitqueue_head(&sonypi_device.fifo_proc_list);
@@ -1393,12 +1393,10 @@ static int __devinit sonypi_probe(struct
 		}
 
 		spin_lock_init(&sonypi_device.input_fifo_lock);
-		sonypi_device.input_fifo =
-			kfifo_alloc(SONYPI_BUF_SIZE, GFP_KERNEL,
-				    &sonypi_device.input_fifo_lock);
-		if (IS_ERR(sonypi_device.input_fifo)) {
+		error = kfifo_alloc(&sonypi_device.input_fifo, SONYPI_BUF_SIZE,
+				GFP_KERNEL, &sonypi_device.input_fifo_lock);
+		if (error) {
 			printk(KERN_ERR "sonypi: kfifo_alloc failed\n");
-			error = PTR_ERR(sonypi_device.input_fifo);
 			goto err_inpdev_unregister;
 		}
 
@@ -1423,7 +1421,7 @@ static int __devinit sonypi_probe(struct
 		pci_disable_device(pcidev);
  err_put_pcidev:
 	pci_dev_put(pcidev);
-	kfifo_free(sonypi_device.fifo);
+	kfifo_free(&sonypi_device.fifo);
 
 	return error;
 }
@@ -1438,7 +1436,7 @@ static int __devexit sonypi_remove(struc
 	if (useinput) {
 		input_unregister_device(sonypi_device.input_key_dev);
 		input_unregister_device(sonypi_device.input_jog_dev);
-		kfifo_free(sonypi_device.input_fifo);
+		kfifo_free(&sonypi_device.input_fifo);
 	}
 
 	misc_deregister(&sonypi_misc_device);
@@ -1451,7 +1449,7 @@ static int __devexit sonypi_remove(struc
 		pci_dev_put(sonypi_device.dev);
 	}
 
-	kfifo_free(sonypi_device.fifo);
+	kfifo_free(&sonypi_device.fifo);
 
 	return 0;
 }
diff -puN drivers/infiniband/hw/cxgb3/cxio_hal.h~kfifo-move-struct-kfifo-in-place drivers/infiniband/hw/cxgb3/cxio_hal.h
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.h~kfifo-move-struct-kfifo-in-place
+++ a/drivers/infiniband/hw/cxgb3/cxio_hal.h
@@ -34,6 +34,7 @@
 
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/kfifo.h>
 
 #include "t3_cpl.h"
 #include "t3cdev.h"
@@ -75,13 +76,13 @@ struct cxio_hal_ctrl_qp {
 };
 
 struct cxio_hal_resource {
-	struct kfifo *tpt_fifo;
+	struct kfifo tpt_fifo;
 	spinlock_t tpt_fifo_lock;
-	struct kfifo *qpid_fifo;
+	struct kfifo qpid_fifo;
 	spinlock_t qpid_fifo_lock;
-	struct kfifo *cqid_fifo;
+	struct kfifo cqid_fifo;
 	spinlock_t cqid_fifo_lock;
-	struct kfifo *pdid_fifo;
+	struct kfifo pdid_fifo;
 	spinlock_t pdid_fifo_lock;
 };
 
diff -puN drivers/infiniband/hw/cxgb3/cxio_resource.c~kfifo-move-struct-kfifo-in-place drivers/infiniband/hw/cxgb3/cxio_resource.c
--- a/drivers/infiniband/hw/cxgb3/cxio_resource.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/infiniband/hw/cxgb3/cxio_resource.c
@@ -39,12 +39,12 @@
 #include "cxio_resource.h"
 #include "cxio_hal.h"
 
-static struct kfifo *rhdl_fifo;
+static struct kfifo rhdl_fifo;
 static spinlock_t rhdl_fifo_lock;
 
 #define RANDOM_SIZE 16
 
-static int __cxio_init_resource_fifo(struct kfifo **fifo,
+static int __cxio_init_resource_fifo(struct kfifo *fifo,
 				   spinlock_t *fifo_lock,
 				   u32 nr, u32 skip_low,
 				   u32 skip_high,
@@ -55,12 +55,11 @@ static int __cxio_init_resource_fifo(str
 	u32 rarray[16];
 	spin_lock_init(fifo_lock);
 
-	*fifo = kfifo_alloc(nr * sizeof(u32), GFP_KERNEL, fifo_lock);
-	if (IS_ERR(*fifo))
+	if (kfifo_alloc(fifo, nr * sizeof(u32), GFP_KERNEL, fifo_lock))
 		return -ENOMEM;
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		__kfifo_put(*fifo, (unsigned char *) &entry, sizeof(u32));
+		__kfifo_put(fifo, (unsigned char *) &entry, sizeof(u32));
 	if (random) {
 		j = 0;
 		random_bytes = random32();
@@ -72,33 +71,33 @@ static int __cxio_init_resource_fifo(str
 				random_bytes = random32();
 			}
 			idx = (random_bytes >> (j * 2)) & 0xF;
-			__kfifo_put(*fifo,
+			__kfifo_put(fifo,
 				(unsigned char *) &rarray[idx],
 				sizeof(u32));
 			rarray[idx] = i;
 			j++;
 		}
 		for (i = 0; i < RANDOM_SIZE; i++)
-			__kfifo_put(*fifo,
+			__kfifo_put(fifo,
 				(unsigned char *) &rarray[i],
 				sizeof(u32));
 	} else
 		for (i = skip_low; i < nr - skip_high; i++)
-			__kfifo_put(*fifo, (unsigned char *) &i, sizeof(u32));
+			__kfifo_put(fifo, (unsigned char *) &i, sizeof(u32));
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		kfifo_get(*fifo, (unsigned char *) &entry, sizeof(u32));
+		kfifo_get(fifo, (unsigned char *) &entry, sizeof(u32));
 	return 0;
 }
 
-static int cxio_init_resource_fifo(struct kfifo **fifo, spinlock_t * fifo_lock,
+static int cxio_init_resource_fifo(struct kfifo *fifo, spinlock_t * fifo_lock,
 				   u32 nr, u32 skip_low, u32 skip_high)
 {
 	return (__cxio_init_resource_fifo(fifo, fifo_lock, nr, skip_low,
 					  skip_high, 0));
 }
 
-static int cxio_init_resource_fifo_random(struct kfifo **fifo,
+static int cxio_init_resource_fifo_random(struct kfifo *fifo,
 				   spinlock_t * fifo_lock,
 				   u32 nr, u32 skip_low, u32 skip_high)
 {
@@ -113,15 +112,14 @@ static int cxio_init_qpid_fifo(struct cx
 
 	spin_lock_init(&rdev_p->rscp->qpid_fifo_lock);
 
-	rdev_p->rscp->qpid_fifo = kfifo_alloc(T3_MAX_NUM_QP * sizeof(u32),
+	if (kfifo_alloc(&rdev_p->rscp->qpid_fifo, T3_MAX_NUM_QP * sizeof(u32),
 					      GFP_KERNEL,
-					      &rdev_p->rscp->qpid_fifo_lock);
-	if (IS_ERR(rdev_p->rscp->qpid_fifo))
+					      &rdev_p->rscp->qpid_fifo_lock))
 		return -ENOMEM;
 
 	for (i = 16; i < T3_MAX_NUM_QP; i++)
 		if (!(i & rdev_p->qpmask))
-			__kfifo_put(rdev_p->rscp->qpid_fifo,
+			__kfifo_put(&rdev_p->rscp->qpid_fifo,
 				    (unsigned char *) &i, sizeof(u32));
 	return 0;
 }
@@ -134,7 +132,7 @@ int cxio_hal_init_rhdl_resource(u32 nr_r
 
 void cxio_hal_destroy_rhdl_resource(void)
 {
-	kfifo_free(rhdl_fifo);
+	kfifo_free(&rhdl_fifo);
 }
 
 /* nr_* must be power of 2 */
@@ -167,11 +165,11 @@ int cxio_hal_init_resource(struct cxio_r
 		goto pdid_err;
 	return 0;
 pdid_err:
-	kfifo_free(rscp->cqid_fifo);
+	kfifo_free(&rscp->cqid_fifo);
 cqid_err:
-	kfifo_free(rscp->qpid_fifo);
+	kfifo_free(&rscp->qpid_fifo);
 qpid_err:
-	kfifo_free(rscp->tpt_fifo);
+	kfifo_free(&rscp->tpt_fifo);
 tpt_err:
 	return -ENOMEM;
 }
@@ -195,17 +193,17 @@ static void cxio_hal_put_resource(struct
 
 u32 cxio_hal_get_stag(struct cxio_hal_resource *rscp)
 {
-	return cxio_hal_get_resource(rscp->tpt_fifo);
+	return cxio_hal_get_resource(&rscp->tpt_fifo);
 }
 
 void cxio_hal_put_stag(struct cxio_hal_resource *rscp, u32 stag)
 {
-	cxio_hal_put_resource(rscp->tpt_fifo, stag);
+	cxio_hal_put_resource(&rscp->tpt_fifo, stag);
 }
 
 u32 cxio_hal_get_qpid(struct cxio_hal_resource *rscp)
 {
-	u32 qpid = cxio_hal_get_resource(rscp->qpid_fifo);
+	u32 qpid = cxio_hal_get_resource(&rscp->qpid_fifo);
 	PDBG("%s qpid 0x%x\n", __func__, qpid);
 	return qpid;
 }
@@ -213,35 +211,35 @@ u32 cxio_hal_get_qpid(struct cxio_hal_re
 void cxio_hal_put_qpid(struct cxio_hal_resource *rscp, u32 qpid)
 {
 	PDBG("%s qpid 0x%x\n", __func__, qpid);
-	cxio_hal_put_resource(rscp->qpid_fifo, qpid);
+	cxio_hal_put_resource(&rscp->qpid_fifo, qpid);
 }
 
 u32 cxio_hal_get_cqid(struct cxio_hal_resource *rscp)
 {
-	return cxio_hal_get_resource(rscp->cqid_fifo);
+	return cxio_hal_get_resource(&rscp->cqid_fifo);
 }
 
 void cxio_hal_put_cqid(struct cxio_hal_resource *rscp, u32 cqid)
 {
-	cxio_hal_put_resource(rscp->cqid_fifo, cqid);
+	cxio_hal_put_resource(&rscp->cqid_fifo, cqid);
 }
 
 u32 cxio_hal_get_pdid(struct cxio_hal_resource *rscp)
 {
-	return cxio_hal_get_resource(rscp->pdid_fifo);
+	return cxio_hal_get_resource(&rscp->pdid_fifo);
 }
 
 void cxio_hal_put_pdid(struct cxio_hal_resource *rscp, u32 pdid)
 {
-	cxio_hal_put_resource(rscp->pdid_fifo, pdid);
+	cxio_hal_put_resource(&rscp->pdid_fifo, pdid);
 }
 
 void cxio_hal_destroy_resource(struct cxio_hal_resource *rscp)
 {
-	kfifo_free(rscp->tpt_fifo);
-	kfifo_free(rscp->cqid_fifo);
-	kfifo_free(rscp->qpid_fifo);
-	kfifo_free(rscp->pdid_fifo);
+	kfifo_free(&rscp->tpt_fifo);
+	kfifo_free(&rscp->cqid_fifo);
+	kfifo_free(&rscp->qpid_fifo);
+	kfifo_free(&rscp->pdid_fifo);
 	kfree(rscp);
 }
 
diff -puN drivers/media/video/meye.c~kfifo-move-struct-kfifo-in-place drivers/media/video/meye.c
--- a/drivers/media/video/meye.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/media/video/meye.c
@@ -800,7 +800,7 @@ again:
 		return IRQ_HANDLED;
 
 	if (meye.mchip_mode == MCHIP_HIC_MODE_CONT_OUT) {
-		if (kfifo_get(meye.grabq, (unsigned char *)&reqnr,
+		if (kfifo_get(&meye.grabq, (unsigned char *)&reqnr,
 			      sizeof(int)) != sizeof(int)) {
 			mchip_free_frame();
 			return IRQ_HANDLED;
@@ -811,7 +811,7 @@ again:
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_put(meye.doneq, (unsigned char *)&reqnr, sizeof(int));
+		kfifo_put(&meye.doneq, (unsigned char *)&reqnr, sizeof(int));
 		wake_up_interruptible(&meye.proc_list);
 	} else {
 		int size;
@@ -820,7 +820,7 @@ again:
 			mchip_free_frame();
 			goto again;
 		}
-		if (kfifo_get(meye.grabq, (unsigned char *)&reqnr,
+		if (kfifo_get(&meye.grabq, (unsigned char *)&reqnr,
 			      sizeof(int)) != sizeof(int)) {
 			mchip_free_frame();
 			goto again;
@@ -831,7 +831,7 @@ again:
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_put(meye.doneq, (unsigned char *)&reqnr, sizeof(int));
+		kfifo_put(&meye.doneq, (unsigned char *)&reqnr, sizeof(int));
 		wake_up_interruptible(&meye.proc_list);
 	}
 	mchip_free_frame();
@@ -859,8 +859,8 @@ static int meye_open(struct file *file)
 
 	for (i = 0; i < MEYE_MAX_BUFNBRS; i++)
 		meye.grab_buffer[i].state = MEYE_BUF_UNUSED;
-	kfifo_reset(meye.grabq);
-	kfifo_reset(meye.doneq);
+	kfifo_reset(&meye.grabq);
+	kfifo_reset(&meye.doneq);
 	return 0;
 }
 
@@ -933,7 +933,7 @@ static int meyeioc_qbuf_capt(int *nb)
 		mchip_cont_compression_start();
 
 	meye.grab_buffer[*nb].state = MEYE_BUF_USING;
-	kfifo_put(meye.grabq, (unsigned char *)nb, sizeof(int));
+	kfifo_put(&meye.grabq, (unsigned char *)nb, sizeof(int));
 	mutex_unlock(&meye.lock);
 
 	return 0;
@@ -965,7 +965,7 @@ static int meyeioc_sync(struct file *fil
 		/* fall through */
 	case MEYE_BUF_DONE:
 		meye.grab_buffer[*i].state = MEYE_BUF_UNUSED;
-		kfifo_get(meye.doneq, (unsigned char *)&unused, sizeof(int));
+		kfifo_get(&meye.doneq, (unsigned char *)&unused, sizeof(int));
 	}
 	*i = meye.grab_buffer[*i].size;
 	mutex_unlock(&meye.lock);
@@ -1452,7 +1452,7 @@ static int vidioc_qbuf(struct file *file
 	buf->flags |= V4L2_BUF_FLAG_QUEUED;
 	buf->flags &= ~V4L2_BUF_FLAG_DONE;
 	meye.grab_buffer[buf->index].state = MEYE_BUF_USING;
-	kfifo_put(meye.grabq, (unsigned char *)&buf->index, sizeof(int));
+	kfifo_put(&meye.grabq, (unsigned char *)&buf->index, sizeof(int));
 	mutex_unlock(&meye.lock);
 
 	return 0;
@@ -1467,18 +1467,18 @@ static int vidioc_dqbuf(struct file *fil
 
 	mutex_lock(&meye.lock);
 
-	if (kfifo_len(meye.doneq) == 0 && file->f_flags & O_NONBLOCK) {
+	if (kfifo_len(&meye.doneq) == 0 && file->f_flags & O_NONBLOCK) {
 		mutex_unlock(&meye.lock);
 		return -EAGAIN;
 	}
 
 	if (wait_event_interruptible(meye.proc_list,
-				     kfifo_len(meye.doneq) != 0) < 0) {
+				     kfifo_len(&meye.doneq) != 0) < 0) {
 		mutex_unlock(&meye.lock);
 		return -EINTR;
 	}
 
-	if (!kfifo_get(meye.doneq, (unsigned char *)&reqnr,
+	if (!kfifo_get(&meye.doneq, (unsigned char *)&reqnr,
 		       sizeof(int))) {
 		mutex_unlock(&meye.lock);
 		return -EBUSY;
@@ -1529,8 +1529,8 @@ static int vidioc_streamoff(struct file 
 {
 	mutex_lock(&meye.lock);
 	mchip_hic_stop();
-	kfifo_reset(meye.grabq);
-	kfifo_reset(meye.doneq);
+	kfifo_reset(&meye.grabq);
+	kfifo_reset(&meye.doneq);
 
 	for (i = 0; i < MEYE_MAX_BUFNBRS; i++)
 		meye.grab_buffer[i].state = MEYE_BUF_UNUSED;
@@ -1572,7 +1572,7 @@ static unsigned int meye_poll(struct fil
 
 	mutex_lock(&meye.lock);
 	poll_wait(file, &meye.proc_list, wait);
-	if (kfifo_len(meye.doneq))
+	if (kfifo_len(&meye.doneq))
 		res = POLLIN | POLLRDNORM;
 	mutex_unlock(&meye.lock);
 	return res;
@@ -1745,16 +1745,14 @@ static int __devinit meye_probe(struct p
 	}
 
 	spin_lock_init(&meye.grabq_lock);
-	meye.grabq = kfifo_alloc(sizeof(int) * MEYE_MAX_BUFNBRS, GFP_KERNEL,
-				 &meye.grabq_lock);
-	if (IS_ERR(meye.grabq)) {
+	if (kfifo_alloc(&meye.grabq, sizeof(int) * MEYE_MAX_BUFNBRS, GFP_KERNEL,
+				 &meye.grabq_lock)) {
 		printk(KERN_ERR "meye: fifo allocation failed\n");
 		goto outkfifoalloc1;
 	}
 	spin_lock_init(&meye.doneq_lock);
-	meye.doneq = kfifo_alloc(sizeof(int) * MEYE_MAX_BUFNBRS, GFP_KERNEL,
-				 &meye.doneq_lock);
-	if (IS_ERR(meye.doneq)) {
+	if (kfifo_alloc(&meye.doneq, sizeof(int) * MEYE_MAX_BUFNBRS, GFP_KERNEL,
+				 &meye.doneq_lock)) {
 		printk(KERN_ERR "meye: fifo allocation failed\n");
 		goto outkfifoalloc2;
 	}
@@ -1868,9 +1866,9 @@ outregions:
 outenabledev:
 	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 0);
 outsonypienable:
-	kfifo_free(meye.doneq);
+	kfifo_free(&meye.doneq);
 outkfifoalloc2:
-	kfifo_free(meye.grabq);
+	kfifo_free(&meye.grabq);
 outkfifoalloc1:
 	vfree(meye.grab_temp);
 outvmalloc:
@@ -1901,8 +1899,8 @@ static void __devexit meye_remove(struct
 
 	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 0);
 
-	kfifo_free(meye.doneq);
-	kfifo_free(meye.grabq);
+	kfifo_free(&meye.doneq);
+	kfifo_free(&meye.grabq);
 
 	vfree(meye.grab_temp);
 
diff -puN drivers/media/video/meye.h~kfifo-move-struct-kfifo-in-place drivers/media/video/meye.h
--- a/drivers/media/video/meye.h~kfifo-move-struct-kfifo-in-place
+++ a/drivers/media/video/meye.h
@@ -303,9 +303,9 @@ struct meye {
 	struct meye_grab_buffer grab_buffer[MEYE_MAX_BUFNBRS];
 	int vma_use_count[MEYE_MAX_BUFNBRS]; /* mmap count */
 	struct mutex lock;		/* mutex for open/mmap... */
-	struct kfifo *grabq;		/* queue for buffers to be grabbed */
+	struct kfifo grabq;		/* queue for buffers to be grabbed */
 	spinlock_t grabq_lock;		/* lock protecting the queue */
-	struct kfifo *doneq;		/* queue for grabbed buffers */
+	struct kfifo doneq;		/* queue for grabbed buffers */
 	spinlock_t doneq_lock;		/* lock protecting the queue */
 	wait_queue_head_t proc_list;	/* wait queue */
 	struct video_device *video_dev;	/* video device parameters */
diff -puN drivers/net/wireless/libertas/cmd.c~kfifo-move-struct-kfifo-in-place drivers/net/wireless/libertas/cmd.c
--- a/drivers/net/wireless/libertas/cmd.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/net/wireless/libertas/cmd.c
@@ -1365,7 +1365,7 @@ static void lbs_send_confirmsleep(struct
 	priv->dnld_sent = DNLD_RES_RECEIVED;
 
 	/* If nothing to do, go back to sleep (?) */
-	if (!__kfifo_len(priv->event_fifo) && !priv->resp_len[priv->resp_idx])
+	if (!__kfifo_len(&priv->event_fifo) && !priv->resp_len[priv->resp_idx])
 		priv->psstate = PS_STATE_SLEEP;
 
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
@@ -1439,7 +1439,7 @@ void lbs_ps_confirm_sleep(struct lbs_pri
 	}
 
 	/* Pending events or command responses? */
-	if (__kfifo_len(priv->event_fifo) || priv->resp_len[priv->resp_idx]) {
+	if (__kfifo_len(&priv->event_fifo) || priv->resp_len[priv->resp_idx]) {
 		allowed = 0;
 		lbs_deb_host("pending events or command responses\n");
 	}
diff -puN drivers/net/wireless/libertas/dev.h~kfifo-move-struct-kfifo-in-place drivers/net/wireless/libertas/dev.h
--- a/drivers/net/wireless/libertas/dev.h~kfifo-move-struct-kfifo-in-place
+++ a/drivers/net/wireless/libertas/dev.h
@@ -10,7 +10,7 @@
 #include "scan.h"
 #include "assoc.h"
 
-
+#include <linux/kfifo.h>
 
 /** sleep_params */
 struct sleep_params {
@@ -120,7 +120,7 @@ struct lbs_private {
 	u32 resp_len[2];
 
 	/* Events sent from hardware to driver */
-	struct kfifo *event_fifo;
+	struct kfifo event_fifo;
 
 	/** thread to service interrupts */
 	struct task_struct *main_thread;
diff -puN drivers/net/wireless/libertas/main.c~kfifo-move-struct-kfifo-in-place drivers/net/wireless/libertas/main.c
--- a/drivers/net/wireless/libertas/main.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/net/wireless/libertas/main.c
@@ -459,7 +459,7 @@ static int lbs_thread(void *data)
 		else if (!list_empty(&priv->cmdpendingq) &&
 					!(priv->wakeup_dev_required))
 			shouldsleep = 0;	/* We have a command to send */
-		else if (__kfifo_len(priv->event_fifo))
+		else if (__kfifo_len(&priv->event_fifo))
 			shouldsleep = 0;	/* We have an event to process */
 		else
 			shouldsleep = 1;	/* No command */
@@ -511,9 +511,9 @@ static int lbs_thread(void *data)
 
 		/* Process hardware events, e.g. card removed, link lost */
 		spin_lock_irq(&priv->driver_lock);
-		while (__kfifo_len(priv->event_fifo)) {
+		while (__kfifo_len(&priv->event_fifo)) {
 			u32 event;
-			__kfifo_get(priv->event_fifo, (unsigned char *) &event,
+			__kfifo_get(&priv->event_fifo, (unsigned char *) &event,
 				sizeof(event));
 			spin_unlock_irq(&priv->driver_lock);
 			lbs_process_event(priv, event);
@@ -883,10 +883,9 @@ static int lbs_init_adapter(struct lbs_p
 	priv->resp_len[0] = priv->resp_len[1] = 0;
 
 	/* Create the event FIFO */
-	priv->event_fifo = kfifo_alloc(sizeof(u32) * 16, GFP_KERNEL, NULL);
-	if (IS_ERR(priv->event_fifo)) {
+	ret = kfifo_alloc(&priv->event_fifo, sizeof(u32) * 16, GFP_KERNEL, NULL);
+	if (ret) {
 		lbs_pr_err("Out of memory allocating event FIFO buffer\n");
-		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -901,8 +900,7 @@ static void lbs_free_adapter(struct lbs_
 	lbs_deb_enter(LBS_DEB_MAIN);
 
 	lbs_free_cmd_buffer(priv);
-	if (priv->event_fifo)
-		kfifo_free(priv->event_fifo);
+	kfifo_free(&priv->event_fifo);
 	del_timer(&priv->command_timer);
 	del_timer(&priv->auto_deepsleep_timer);
 	kfree(priv->networks);
@@ -1177,7 +1175,7 @@ void lbs_queue_event(struct lbs_private 
 	if (priv->psstate == PS_STATE_SLEEP)
 		priv->psstate = PS_STATE_AWAKE;
 
-	__kfifo_put(priv->event_fifo, (unsigned char *) &event, sizeof(u32));
+	__kfifo_put(&priv->event_fifo, (unsigned char *) &event, sizeof(u32));
 
 	wake_up_interruptible(&priv->waitq);
 
diff -puN drivers/platform/x86/fujitsu-laptop.c~kfifo-move-struct-kfifo-in-place drivers/platform/x86/fujitsu-laptop.c
--- a/drivers/platform/x86/fujitsu-laptop.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/platform/x86/fujitsu-laptop.c
@@ -164,7 +164,7 @@ struct fujitsu_hotkey_t {
 	struct input_dev *input;
 	char phys[32];
 	struct platform_device *pf_device;
-	struct kfifo *fifo;
+	struct kfifo fifo;
 	spinlock_t fifo_lock;
 	int rfkill_supported;
 	int rfkill_state;
@@ -824,12 +824,10 @@ static int acpi_fujitsu_hotkey_add(struc
 
 	/* kfifo */
 	spin_lock_init(&fujitsu_hotkey->fifo_lock);
-	fujitsu_hotkey->fifo =
-	    kfifo_alloc(RINGBUFFERSIZE * sizeof(int), GFP_KERNEL,
-			&fujitsu_hotkey->fifo_lock);
-	if (IS_ERR(fujitsu_hotkey->fifo)) {
+	error = kfifo_alloc(&fujitsu_hotkey->fifo, RINGBUFFERSIZE * sizeof(int),
+			GFP_KERNEL, &fujitsu_hotkey->fifo_lock);
+	if (error) {
 		printk(KERN_ERR "kfifo_alloc failed\n");
-		error = PTR_ERR(fujitsu_hotkey->fifo);
 		goto err_stop;
 	}
 
@@ -934,7 +932,7 @@ err_unregister_input_dev:
 err_free_input_dev:
 	input_free_device(input);
 err_free_fifo:
-	kfifo_free(fujitsu_hotkey->fifo);
+	kfifo_free(&fujitsu_hotkey->fifo);
 err_stop:
 	return result;
 }
@@ -956,7 +954,7 @@ static int acpi_fujitsu_hotkey_remove(st
 
 	input_free_device(input);
 
-	kfifo_free(fujitsu_hotkey->fifo);
+	kfifo_free(&fujitsu_hotkey->fifo);
 
 	fujitsu_hotkey->acpi_handle = NULL;
 
@@ -1008,7 +1006,7 @@ static void acpi_fujitsu_hotkey_notify(s
 				vdbg_printk(FUJLAPTOP_DBG_TRACE,
 					"Push keycode into ringbuffer [%d]\n",
 					keycode);
-				status = kfifo_put(fujitsu_hotkey->fifo,
+				status = kfifo_put(&fujitsu_hotkey->fifo,
 						   (unsigned char *)&keycode,
 						   sizeof(keycode));
 				if (status != sizeof(keycode)) {
@@ -1022,7 +1020,7 @@ static void acpi_fujitsu_hotkey_notify(s
 			} else if (keycode == 0) {
 				while ((status =
 					kfifo_get
-					(fujitsu_hotkey->fifo, (unsigned char *)
+					(&fujitsu_hotkey->fifo, (unsigned char *)
 					 &keycode_r,
 					 sizeof
 					 (keycode_r))) == sizeof(keycode_r)) {
diff -puN drivers/platform/x86/sony-laptop.c~kfifo-move-struct-kfifo-in-place drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/platform/x86/sony-laptop.c
@@ -142,7 +142,7 @@ struct sony_laptop_input_s {
 	atomic_t		users;
 	struct input_dev	*jog_dev;
 	struct input_dev	*key_dev;
-	struct kfifo		*fifo;
+	struct kfifo		fifo;
 	spinlock_t		fifo_lock;
 	struct workqueue_struct	*wq;
 };
@@ -300,7 +300,7 @@ static void do_sony_laptop_release_key(s
 {
 	struct sony_laptop_keypress kp;
 
-	while (kfifo_get(sony_laptop_input.fifo, (unsigned char *)&kp,
+	while (kfifo_get(&sony_laptop_input.fifo, (unsigned char *)&kp,
 			 sizeof(kp)) == sizeof(kp)) {
 		msleep(10);
 		input_report_key(kp.dev, kp.key, 0);
@@ -362,7 +362,7 @@ static void sony_laptop_report_input_eve
 		/* we emit the scancode so we can always remap the key */
 		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
 		input_sync(kp.dev);
-		kfifo_put(sony_laptop_input.fifo,
+		kfifo_put(&sony_laptop_input.fifo,
 			  (unsigned char *)&kp, sizeof(kp));
 
 		if (!work_pending(&sony_laptop_release_key_work))
@@ -385,12 +385,11 @@ static int sony_laptop_setup_input(struc
 
 	/* kfifo */
 	spin_lock_init(&sony_laptop_input.fifo_lock);
-	sony_laptop_input.fifo =
-		kfifo_alloc(SONY_LAPTOP_BUF_SIZE, GFP_KERNEL,
+	error =
+	 kfifo_alloc(&sony_laptop_input.fifo, SONY_LAPTOP_BUF_SIZE, GFP_KERNEL,
 			    &sony_laptop_input.fifo_lock);
-	if (IS_ERR(sony_laptop_input.fifo)) {
+	if (error) {
 		printk(KERN_ERR DRV_PFX "kfifo_alloc failed\n");
-		error = PTR_ERR(sony_laptop_input.fifo);
 		goto err_dec_users;
 	}
 
@@ -474,7 +473,7 @@ err_destroy_wq:
 	destroy_workqueue(sony_laptop_input.wq);
 
 err_free_kfifo:
-	kfifo_free(sony_laptop_input.fifo);
+	kfifo_free(&sony_laptop_input.fifo);
 
 err_dec_users:
 	atomic_dec(&sony_laptop_input.users);
@@ -500,7 +499,7 @@ static void sony_laptop_remove_input(voi
 	}
 
 	destroy_workqueue(sony_laptop_input.wq);
-	kfifo_free(sony_laptop_input.fifo);
+	kfifo_free(&sony_laptop_input.fifo);
 }
 
 /*********** Platform Device ***********/
@@ -2079,7 +2078,7 @@ static struct attribute_group spic_attri
 
 struct sonypi_compat_s {
 	struct fasync_struct	*fifo_async;
-	struct kfifo		*fifo;
+	struct kfifo		fifo;
 	spinlock_t		fifo_lock;
 	wait_queue_head_t	fifo_proc_list;
 	atomic_t		open_count;
@@ -2104,12 +2103,12 @@ static int sonypi_misc_open(struct inode
 	/* Flush input queue on first open */
 	unsigned long flags;
 
-	spin_lock_irqsave(sonypi_compat.fifo->lock, flags);
+	spin_lock_irqsave(&sonypi_compat.fifo_lock, flags);
 
 	if (atomic_inc_return(&sonypi_compat.open_count) == 1)
-		__kfifo_reset(sonypi_compat.fifo);
+		__kfifo_reset(&sonypi_compat.fifo);
 
-	spin_unlock_irqrestore(sonypi_compat.fifo->lock, flags);
+	spin_unlock_irqrestore(&sonypi_compat.fifo_lock, flags);
 
 	return 0;
 }
@@ -2120,17 +2119,17 @@ static ssize_t sonypi_misc_read(struct f
 	ssize_t ret;
 	unsigned char c;
 
-	if ((kfifo_len(sonypi_compat.fifo) == 0) &&
+	if ((kfifo_len(&sonypi_compat.fifo) == 0) &&
 	    (file->f_flags & O_NONBLOCK))
 		return -EAGAIN;
 
 	ret = wait_event_interruptible(sonypi_compat.fifo_proc_list,
-				       kfifo_len(sonypi_compat.fifo) != 0);
+				       kfifo_len(&sonypi_compat.fifo) != 0);
 	if (ret)
 		return ret;
 
 	while (ret < count &&
-	       (kfifo_get(sonypi_compat.fifo, &c, sizeof(c)) == sizeof(c))) {
+	       (kfifo_get(&sonypi_compat.fifo, &c, sizeof(c)) == sizeof(c))) {
 		if (put_user(c, buf++))
 			return -EFAULT;
 		ret++;
@@ -2147,7 +2146,7 @@ static ssize_t sonypi_misc_read(struct f
 static unsigned int sonypi_misc_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &sonypi_compat.fifo_proc_list, wait);
-	if (kfifo_len(sonypi_compat.fifo))
+	if (kfifo_len(&sonypi_compat.fifo))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
@@ -2309,7 +2308,7 @@ static struct miscdevice sonypi_misc_dev
 
 static void sonypi_compat_report_event(u8 event)
 {
-	kfifo_put(sonypi_compat.fifo, (unsigned char *)&event, sizeof(event));
+	kfifo_put(&sonypi_compat.fifo, (unsigned char *)&event, sizeof(event));
 	kill_fasync(&sonypi_compat.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_compat.fifo_proc_list);
 }
@@ -2319,11 +2318,12 @@ static int sonypi_compat_init(void)
 	int error;
 
 	spin_lock_init(&sonypi_compat.fifo_lock);
-	sonypi_compat.fifo = kfifo_alloc(SONY_LAPTOP_BUF_SIZE, GFP_KERNEL,
+	error =
+	 kfifo_alloc(&sonypi_compat.fifo, SONY_LAPTOP_BUF_SIZE, GFP_KERNEL,
 					 &sonypi_compat.fifo_lock);
-	if (IS_ERR(sonypi_compat.fifo)) {
+	if (error) {
 		printk(KERN_ERR DRV_PFX "kfifo_alloc failed\n");
-		return PTR_ERR(sonypi_compat.fifo);
+		return error;
 	}
 
 	init_waitqueue_head(&sonypi_compat.fifo_proc_list);
@@ -2342,14 +2342,14 @@ static int sonypi_compat_init(void)
 	return 0;
 
 err_free_kfifo:
-	kfifo_free(sonypi_compat.fifo);
+	kfifo_free(&sonypi_compat.fifo);
 	return error;
 }
 
 static void sonypi_compat_exit(void)
 {
 	misc_deregister(&sonypi_misc_device);
-	kfifo_free(sonypi_compat.fifo);
+	kfifo_free(&sonypi_compat.fifo);
 }
 #else
 static int sonypi_compat_init(void) { return 0; }
diff -puN drivers/scsi/libiscsi.c~kfifo-move-struct-kfifo-in-place drivers/scsi/libiscsi.c
--- a/drivers/scsi/libiscsi.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/scsi/libiscsi.c
@@ -517,7 +517,7 @@ static void iscsi_free_task(struct iscsi
 	if (conn->login_task == task)
 		return;
 
-	__kfifo_put(session->cmdpool.queue, (void*)&task, sizeof(void*));
+	__kfifo_put(&session->cmdpool.queue, (void*)&task, sizeof(void*));
 
 	if (sc) {
 		task->sc = NULL;
@@ -737,7 +737,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn 
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-		if (!__kfifo_get(session->cmdpool.queue,
+		if (!__kfifo_get(&session->cmdpool.queue,
 				 (void*)&task, sizeof(void*)))
 			return NULL;
 	}
@@ -1567,7 +1567,7 @@ static inline struct iscsi_task *iscsi_a
 {
 	struct iscsi_task *task;
 
-	if (!__kfifo_get(conn->session->cmdpool.queue,
+	if (!__kfifo_get(&conn->session->cmdpool.queue,
 			 (void *) &task, sizeof(void *)))
 		return NULL;
 
@@ -2461,12 +2461,7 @@ iscsi_pool_init(struct iscsi_pool *q, in
 	if (q->pool == NULL)
 		return -ENOMEM;
 
-	q->queue = kfifo_init((void*)q->pool, max * sizeof(void*),
-			      GFP_KERNEL, NULL);
-	if (IS_ERR(q->queue)) {
-		q->queue = NULL;
-		goto enomem;
-	}
+	kfifo_init(&q->queue, (void*)q->pool, max * sizeof(void*), NULL);
 
 	for (i = 0; i < max; i++) {
 		q->pool[i] = kzalloc(item_size, GFP_KERNEL);
@@ -2474,7 +2469,7 @@ iscsi_pool_init(struct iscsi_pool *q, in
 			q->max = i;
 			goto enomem;
 		}
-		__kfifo_put(q->queue, (void*)&q->pool[i], sizeof(void*));
+		__kfifo_put(&q->queue, (void*)&q->pool[i], sizeof(void*));
 	}
 
 	if (items) {
@@ -2497,7 +2492,6 @@ void iscsi_pool_free(struct iscsi_pool *
 	for (i = 0; i < q->max; i++)
 		kfree(q->pool[i]);
 	kfree(q->pool);
-	kfree(q->queue);
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
@@ -2825,7 +2819,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 
 	/* allocate login_task used for the login/text sequences */
 	spin_lock_bh(&session->lock);
-	if (!__kfifo_get(session->cmdpool.queue,
+	if (!__kfifo_get(&session->cmdpool.queue,
                          (void*)&conn->login_task,
 			 sizeof(void*))) {
 		spin_unlock_bh(&session->lock);
@@ -2845,7 +2839,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 	return cls_conn;
 
 login_task_data_alloc_fail:
-	__kfifo_put(session->cmdpool.queue, (void*)&conn->login_task,
+	__kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
@@ -2908,7 +2902,7 @@ void iscsi_conn_teardown(struct iscsi_cl
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
-	__kfifo_put(session->cmdpool.queue, (void*)&conn->login_task,
+	__kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
diff -puN drivers/scsi/libiscsi_tcp.c~kfifo-move-struct-kfifo-in-place drivers/scsi/libiscsi_tcp.c
--- a/drivers/scsi/libiscsi_tcp.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/scsi/libiscsi_tcp.c
@@ -445,15 +445,15 @@ void iscsi_tcp_cleanup_task(struct iscsi
 		return;
 
 	/* flush task's r2t queues */
-	while (__kfifo_get(tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
-		__kfifo_put(tcp_task->r2tpool.queue, (void*)&r2t,
+	while (__kfifo_get(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
+		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		ISCSI_DBG_TCP(task->conn, "pending r2t dropped\n");
 	}
 
 	r2t = tcp_task->r2t;
 	if (r2t != NULL) {
-		__kfifo_put(tcp_task->r2tpool.queue, (void*)&r2t,
+		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		tcp_task->r2t = NULL;
 	}
@@ -541,7 +541,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 		return 0;
 	}
 
-	rc = __kfifo_get(tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
+	rc = __kfifo_get(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
 	if (!rc) {
 		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
 				  "Target has sent more R2Ts than it "
@@ -554,7 +554,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 	if (r2t->data_length == 0) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with zero data len\n");
-		__kfifo_put(tcp_task->r2tpool.queue, (void*)&r2t,
+		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -570,7 +570,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", r2t->data_length,
 				  r2t->data_offset, scsi_out(task->sc)->length);
-		__kfifo_put(tcp_task->r2tpool.queue, (void*)&r2t,
+		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -580,7 +580,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 	r2t->sent = 0;
 
 	tcp_task->exp_datasn = r2tsn + 1;
-	__kfifo_put(tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
+	__kfifo_put(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
 	conn->r2t_pdus_cnt++;
 
 	iscsi_requeue_task(task);
@@ -951,7 +951,7 @@ int iscsi_tcp_task_init(struct iscsi_tas
 		return conn->session->tt->init_pdu(task, 0, task->data_count);
 	}
 
-	BUG_ON(__kfifo_len(tcp_task->r2tqueue));
+	BUG_ON(__kfifo_len(&tcp_task->r2tqueue));
 	tcp_task->exp_datasn = 0;
 
 	/* Prepare PDU, optionally w/ immediate data */
@@ -982,7 +982,7 @@ static struct iscsi_r2t_info *iscsi_tcp_
 			if (r2t->data_length <= r2t->sent) {
 				ISCSI_DBG_TCP(task->conn,
 					      "  done with r2t %p\n", r2t);
-				__kfifo_put(tcp_task->r2tpool.queue,
+				__kfifo_put(&tcp_task->r2tpool.queue,
 					    (void *)&tcp_task->r2t,
 					    sizeof(void *));
 				tcp_task->r2t = r2t = NULL;
@@ -990,7 +990,7 @@ static struct iscsi_r2t_info *iscsi_tcp_
 		}
 
 		if (r2t == NULL) {
-			__kfifo_get(tcp_task->r2tqueue,
+			__kfifo_get(&tcp_task->r2tqueue,
 				    (void *)&tcp_task->r2t, sizeof(void *));
 			r2t = tcp_task->r2t;
 		}
@@ -1127,9 +1127,8 @@ int iscsi_tcp_r2tpool_alloc(struct iscsi
 		}
 
 		/* R2T xmit queue */
-		tcp_task->r2tqueue = kfifo_alloc(
-		      session->max_r2t * 4 * sizeof(void*), GFP_KERNEL, NULL);
-		if (tcp_task->r2tqueue == ERR_PTR(-ENOMEM)) {
+		if (kfifo_alloc(&tcp_task->r2tqueue,
+		      session->max_r2t * 4 * sizeof(void*), GFP_KERNEL, NULL)) {
 			iscsi_pool_free(&tcp_task->r2tpool);
 			goto r2t_alloc_fail;
 		}
@@ -1142,7 +1141,7 @@ r2t_alloc_fail:
 		struct iscsi_task *task = session->cmds[i];
 		struct iscsi_tcp_task *tcp_task = task->dd_data;
 
-		kfifo_free(tcp_task->r2tqueue);
+		kfifo_free(&tcp_task->r2tqueue);
 		iscsi_pool_free(&tcp_task->r2tpool);
 	}
 	return -ENOMEM;
@@ -1157,7 +1156,7 @@ void iscsi_tcp_r2tpool_free(struct iscsi
 		struct iscsi_task *task = session->cmds[i];
 		struct iscsi_tcp_task *tcp_task = task->dd_data;
 
-		kfifo_free(tcp_task->r2tqueue);
+		kfifo_free(&tcp_task->r2tqueue);
 		iscsi_pool_free(&tcp_task->r2tpool);
 	}
 }
diff -puN drivers/scsi/libsrp.c~kfifo-move-struct-kfifo-in-place drivers/scsi/libsrp.c
--- a/drivers/scsi/libsrp.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/scsi/libsrp.c
@@ -58,19 +58,16 @@ static int srp_iu_pool_alloc(struct srp_
 		goto free_pool;
 
 	spin_lock_init(&q->lock);
-	q->queue = kfifo_init((void *) q->pool, max * sizeof(void *),
-			      GFP_KERNEL, &q->lock);
-	if (IS_ERR(q->queue))
-		goto free_item;
+	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *),
+			      &q->lock);
 
 	for (i = 0, iue = q->items; i < max; i++) {
-		__kfifo_put(q->queue, (void *) &iue, sizeof(void *));
+		__kfifo_put(&q->queue, (void *) &iue, sizeof(void *));
 		iue->sbuf = ring[i];
 		iue++;
 	}
 	return 0;
 
-free_item:
 	kfree(q->items);
 free_pool:
 	kfree(q->pool);
@@ -167,7 +164,7 @@ struct iu_entry *srp_iu_get(struct srp_t
 {
 	struct iu_entry *iue = NULL;
 
-	kfifo_get(target->iu_queue.queue, (void *) &iue, sizeof(void *));
+	kfifo_get(&target->iu_queue.queue, (void *) &iue, sizeof(void *));
 	if (!iue)
 		return iue;
 	iue->target = target;
@@ -179,7 +176,7 @@ EXPORT_SYMBOL_GPL(srp_iu_get);
 
 void srp_iu_put(struct iu_entry *iue)
 {
-	kfifo_put(iue->target->iu_queue.queue, (void *) &iue, sizeof(void *));
+	kfifo_put(&iue->target->iu_queue.queue, (void *) &iue, sizeof(void *));
 }
 EXPORT_SYMBOL_GPL(srp_iu_put);
 
diff -puN drivers/usb/host/fhci-sched.c~kfifo-move-struct-kfifo-in-place drivers/usb/host/fhci-sched.c
--- a/drivers/usb/host/fhci-sched.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/usb/host/fhci-sched.c
@@ -37,7 +37,7 @@ static void recycle_frame(struct fhci_us
 	pkt->info = 0;
 	pkt->priv_data = NULL;
 
-	cq_put(usb->ep0->empty_frame_Q, pkt);
+	cq_put(&usb->ep0->empty_frame_Q, pkt);
 }
 
 /* confirm submitted packet */
@@ -57,7 +57,7 @@ void fhci_transaction_confirm(struct fhc
 		if ((td->data + td->actual_len) && trans_len)
 			memcpy(td->data + td->actual_len, pkt->data,
 			       trans_len);
-		cq_put(usb->ep0->dummy_packets_Q, pkt->data);
+		cq_put(&usb->ep0->dummy_packets_Q, pkt->data);
 	}
 
 	recycle_frame(usb, pkt);
@@ -213,7 +213,7 @@ static int add_packet(struct fhci_usb *u
 	}
 
 	/* update frame object fields before transmitting */
-	pkt = cq_get(usb->ep0->empty_frame_Q);
+	pkt = cq_get(&usb->ep0->empty_frame_Q);
 	if (!pkt) {
 		fhci_dbg(usb->fhci, "there is no empty frame\n");
 		return -1;
@@ -222,7 +222,7 @@ static int add_packet(struct fhci_usb *u
 
 	pkt->info = 0;
 	if (data == NULL) {
-		data = cq_get(usb->ep0->dummy_packets_Q);
+		data = cq_get(&usb->ep0->dummy_packets_Q);
 		BUG_ON(!data);
 		pkt->info = PKT_DUMMY_PACKET;
 	}
@@ -246,7 +246,7 @@ static int add_packet(struct fhci_usb *u
 		list_del_init(&td->frame_lh);
 		td->status = USB_TD_OK;
 		if (pkt->info & PKT_DUMMY_PACKET)
-			cq_put(usb->ep0->dummy_packets_Q, pkt->data);
+			cq_put(&usb->ep0->dummy_packets_Q, pkt->data);
 		recycle_frame(usb, pkt);
 		usb->actual_frame->total_bytes -= (len + PROTOCOL_OVERHEAD);
 		fhci_err(usb->fhci, "host transaction failed\n");
diff -puN drivers/usb/host/fhci-tds.c~kfifo-move-struct-kfifo-in-place drivers/usb/host/fhci-tds.c
--- a/drivers/usb/host/fhci-tds.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/usb/host/fhci-tds.c
@@ -106,33 +106,33 @@ void fhci_ep0_free(struct fhci_usb *usb)
 			cpm_muram_free(cpm_muram_offset(ep->td_base));
 
 		if (ep->conf_frame_Q) {
-			size = cq_howmany(ep->conf_frame_Q);
+			size = cq_howmany(&ep->conf_frame_Q);
 			for (; size; size--) {
-				struct packet *pkt = cq_get(ep->conf_frame_Q);
+				struct packet *pkt = cq_get(&ep->conf_frame_Q);
 
 				kfree(pkt);
 			}
-			cq_delete(ep->conf_frame_Q);
+			cq_delete(&ep->conf_frame_Q);
 		}
 
 		if (ep->empty_frame_Q) {
-			size = cq_howmany(ep->empty_frame_Q);
+			size = cq_howmany(&ep->empty_frame_Q);
 			for (; size; size--) {
-				struct packet *pkt = cq_get(ep->empty_frame_Q);
+				struct packet *pkt = cq_get(&ep->empty_frame_Q);
 
 				kfree(pkt);
 			}
-			cq_delete(ep->empty_frame_Q);
+			cq_delete(&ep->empty_frame_Q);
 		}
 
 		if (ep->dummy_packets_Q) {
-			size = cq_howmany(ep->dummy_packets_Q);
+			size = cq_howmany(&ep->dummy_packets_Q);
 			for (; size; size--) {
-				u8 *buff = cq_get(ep->dummy_packets_Q);
+				u8 *buff = cq_get(&ep->dummy_packets_Q);
 
 				kfree(buff);
 			}
-			cq_delete(ep->dummy_packets_Q);
+			cq_delete(&ep->dummy_packets_Q);
 		}
 
 		kfree(ep);
@@ -175,10 +175,9 @@ u32 fhci_create_ep(struct fhci_usb *usb,
 	ep->td_base = cpm_muram_addr(ep_offset);
 
 	/* zero all queue pointers */
-	ep->conf_frame_Q = cq_new(ring_len + 2);
-	ep->empty_frame_Q = cq_new(ring_len + 2);
-	ep->dummy_packets_Q = cq_new(ring_len + 2);
-	if (!ep->conf_frame_Q || !ep->empty_frame_Q || !ep->dummy_packets_Q) {
+	if (cq_new(&ep->conf_frame_Q, ring_len + 2) ||
+	    cq_new(&ep->empty_frame_Q, ring_len + 2) ||
+	    cq_new(&ep->dummy_packets_Q, ring_len + 2)) {
 		err_for = "frame_queues";
 		goto err;
 	}
@@ -199,8 +198,8 @@ u32 fhci_create_ep(struct fhci_usb *usb,
 			err_for = "buffer";
 			goto err;
 		}
-		cq_put(ep->empty_frame_Q, pkt);
-		cq_put(ep->dummy_packets_Q, buff);
+		cq_put(&ep->empty_frame_Q, pkt);
+		cq_put(&ep->dummy_packets_Q, buff);
 	}
 
 	/* we put the endpoint parameter RAM right behind the TD ring */
@@ -319,7 +318,7 @@ static void fhci_td_transaction_confirm(
 		if ((buf == DUMMY2_BD_BUFFER) && !(td_status & ~TD_W))
 			continue;
 
-		pkt = cq_get(ep->conf_frame_Q);
+		pkt = cq_get(&ep->conf_frame_Q);
 		if (!pkt)
 			fhci_err(usb->fhci, "no frame to confirm\n");
 
@@ -460,9 +459,9 @@ u32 fhci_host_transaction(struct fhci_us
 		out_be16(&td->length, pkt->len);
 
 	/* put the frame to the confirmation queue */
-	cq_put(ep->conf_frame_Q, pkt);
+	cq_put(&ep->conf_frame_Q, pkt);
 
-	if (cq_howmany(ep->conf_frame_Q) == 1)
+	if (cq_howmany(&ep->conf_frame_Q) == 1)
 		out_8(&usb->fhci->regs->usb_comm, USB_CMD_STR_FIFO);
 
 	return 0;
diff -puN drivers/usb/host/fhci.h~kfifo-move-struct-kfifo-in-place drivers/usb/host/fhci.h
--- a/drivers/usb/host/fhci.h~kfifo-move-struct-kfifo-in-place
+++ a/drivers/usb/host/fhci.h
@@ -423,9 +423,9 @@ struct endpoint {
 	struct usb_td __iomem *td_base; /* first TD in the ring */
 	struct usb_td __iomem *conf_td; /* next TD for confirm after transac */
 	struct usb_td __iomem *empty_td;/* next TD for new transaction req. */
-	struct kfifo *empty_frame_Q;  /* Empty frames list to use */
-	struct kfifo *conf_frame_Q;   /* frames passed to TDs,waiting for tx */
-	struct kfifo *dummy_packets_Q;/* dummy packets for the CRC overun */
+	struct kfifo empty_frame_Q;  /* Empty frames list to use */
+	struct kfifo conf_frame_Q;   /* frames passed to TDs,waiting for tx */
+	struct kfifo dummy_packets_Q;/* dummy packets for the CRC overun */
 
 	bool already_pushed_dummy_bd;
 };
@@ -493,9 +493,9 @@ static inline struct usb_hcd *fhci_to_hc
 }
 
 /* fifo of pointers */
-static inline struct kfifo *cq_new(int size)
+static inline int cq_new(struct kfifo *fifo, int size)
 {
-	return kfifo_alloc(size * sizeof(void *), GFP_KERNEL, NULL);
+	return kfifo_alloc(fifo, size * sizeof(void *), GFP_KERNEL, NULL);
 }
 
 static inline void cq_delete(struct kfifo *kfifo)
diff -puN drivers/usb/serial/usb-serial.c~kfifo-move-struct-kfifo-in-place drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~kfifo-move-struct-kfifo-in-place
+++ a/drivers/usb/serial/usb-serial.c
@@ -939,9 +939,8 @@ int usb_serial_probe(struct usb_interfac
 			dev_err(&interface->dev, "No free urbs available\n");
 			goto probe_error;
 		}
-		port->write_fifo = kfifo_alloc(PAGE_SIZE, GFP_KERNEL,
-			&port->lock);
-		if (IS_ERR(port->write_fifo))
+		if (kfifo_alloc(&port->write_fifo, PAGE_SIZE, GFP_KERNEL,
+			&port->lock))
 			goto probe_error;
 		buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
 		port->bulk_out_size = buffer_size;
diff -puN include/linux/kfifo.h~kfifo-move-struct-kfifo-in-place include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-move-struct-kfifo-in-place
+++ a/include/linux/kfifo.h
@@ -1,6 +1,7 @@
 /*
- * A simple kernel FIFO implementation.
+ * A generic kernel FIFO implementation.
  *
+ * Copyright (C) 2009 Stefani Seibold <stefani@seibold.net>
  * Copyright (C) 2004 Stelian Pop <stelian@popies.net>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -32,10 +33,10 @@ struct kfifo {
 	spinlock_t *lock;	/* protects concurrent modifications */
 };
 
-extern struct kfifo *kfifo_init(unsigned char *buffer, unsigned int size,
-				gfp_t gfp_mask, spinlock_t *lock);
-extern struct kfifo *kfifo_alloc(unsigned int size, gfp_t gfp_mask,
-				 spinlock_t *lock);
+extern void kfifo_init(struct kfifo *fifo, unsigned char *buffer,
+			unsigned int size, spinlock_t *lock);
+extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
+			gfp_t gfp_mask, spinlock_t *lock);
 extern void kfifo_free(struct kfifo *fifo);
 extern unsigned int __kfifo_put(struct kfifo *fifo,
 				const unsigned char *buffer, unsigned int len);
diff -puN include/scsi/libiscsi.h~kfifo-move-struct-kfifo-in-place include/scsi/libiscsi.h
--- a/include/scsi/libiscsi.h~kfifo-move-struct-kfifo-in-place
+++ a/include/scsi/libiscsi.h
@@ -28,6 +28,7 @@
 #include <linux/mutex.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
+#include <linux/kfifo.h>
 #include <scsi/iscsi_proto.h>
 #include <scsi/iscsi_if.h>
 #include <scsi/scsi_transport_iscsi.h>
@@ -231,7 +232,7 @@ struct iscsi_conn {
 };
 
 struct iscsi_pool {
-	struct kfifo		*queue;		/* FIFO Queue */
+	struct kfifo		queue;		/* FIFO Queue */
 	void			**pool;		/* Pool of elements */
 	int			max;		/* Max number of elements */
 };
diff -puN include/scsi/libiscsi_tcp.h~kfifo-move-struct-kfifo-in-place include/scsi/libiscsi_tcp.h
--- a/include/scsi/libiscsi_tcp.h~kfifo-move-struct-kfifo-in-place
+++ a/include/scsi/libiscsi_tcp.h
@@ -80,7 +80,7 @@ struct iscsi_tcp_task {
 	int			data_offset;
 	struct iscsi_r2t_info	*r2t;		/* in progress solict R2T */
 	struct iscsi_pool	r2tpool;
-	struct kfifo		*r2tqueue;
+	struct kfifo		r2tqueue;
 	void			*dd_data;
 };
 
diff -puN include/scsi/libsrp.h~kfifo-move-struct-kfifo-in-place include/scsi/libsrp.h
--- a/include/scsi/libsrp.h~kfifo-move-struct-kfifo-in-place
+++ a/include/scsi/libsrp.h
@@ -21,7 +21,7 @@ struct srp_buf {
 struct srp_queue {
 	void *pool;
 	void *items;
-	struct kfifo *queue;
+	struct kfifo queue;
 	spinlock_t lock;
 };
 
diff -puN kernel/kfifo.c~kfifo-move-struct-kfifo-in-place kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-move-struct-kfifo-in-place
+++ a/kernel/kfifo.c
@@ -1,6 +1,7 @@
 /*
- * A simple kernel FIFO implementation.
+ * A generic kernel FIFO implementation.
  *
+ * Copyright (C) 2009 Stefani Seibold <stefani@seibold.net>
  * Copyright (C) 2004 Stelian Pop <stelian@popies.net>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -26,49 +27,51 @@
 #include <linux/kfifo.h>
 #include <linux/log2.h>
 
+static void _kfifo_init(struct kfifo *fifo, unsigned char *buffer,
+		unsigned int size, spinlock_t *lock)
+{
+	fifo->buffer = buffer;
+	fifo->size = size;
+	fifo->lock = lock;
+
+	kfifo_reset(fifo);
+}
+
 /**
- * kfifo_init - allocates a new FIFO using a preallocated buffer
+ * kfifo_init - initialize a FIFO using a preallocated buffer
+ * @fifo: the fifo to assign the buffer
  * @buffer: the preallocated buffer to be used.
  * @size: the size of the internal buffer, this have to be a power of 2.
- * @gfp_mask: get_free_pages mask, passed to kmalloc()
  * @lock: the lock to be used to protect the fifo buffer
  *
- * Do NOT pass the kfifo to kfifo_free() after use! Simply free the
- * &struct kfifo with kfree().
  */
-struct kfifo *kfifo_init(unsigned char *buffer, unsigned int size,
-			 gfp_t gfp_mask, spinlock_t *lock)
+void kfifo_init(struct kfifo *fifo, unsigned char *buffer, unsigned int size,
+			spinlock_t *lock)
 {
-	struct kfifo *fifo;
-
 	/* size must be a power of 2 */
 	BUG_ON(!is_power_of_2(size));
 
-	fifo = kmalloc(sizeof(struct kfifo), gfp_mask);
-	if (!fifo)
-		return ERR_PTR(-ENOMEM);
-
-	fifo->buffer = buffer;
-	fifo->size = size;
-	fifo->in = fifo->out = 0;
-	fifo->lock = lock;
-
-	return fifo;
+	_kfifo_init(fifo, buffer, size, lock);
 }
 EXPORT_SYMBOL(kfifo_init);
 
 /**
- * kfifo_alloc - allocates a new FIFO and its internal buffer
- * @size: the size of the internal buffer to be allocated.
+ * kfifo_alloc - allocates a new FIFO internal buffer
+ * @fifo: the fifo to assign then new buffer
+ * @size: the size of the buffer to be allocated, this have to be a power of 2.
  * @gfp_mask: get_free_pages mask, passed to kmalloc()
  * @lock: the lock to be used to protect the fifo buffer
  *
+ * This function dynamically allocates a new fifo internal buffer
+ *
  * The size will be rounded-up to a power of 2.
+ * The buffer will be release with kfifo_free().
+ * Return 0 if no error, otherwise the an error code
  */
-struct kfifo *kfifo_alloc(unsigned int size, gfp_t gfp_mask, spinlock_t *lock)
+int kfifo_alloc(struct kfifo *fifo, unsigned int size, gfp_t gfp_mask,
+			spinlock_t *lock)
 {
 	unsigned char *buffer;
-	struct kfifo *ret;
 
 	/*
 	 * round up to the next power of 2, since our 'let the indices
@@ -80,26 +83,24 @@ struct kfifo *kfifo_alloc(unsigned int s
 	}
 
 	buffer = kmalloc(size, gfp_mask);
-	if (!buffer)
-		return ERR_PTR(-ENOMEM);
-
-	ret = kfifo_init(buffer, size, gfp_mask, lock);
+	if (!buffer) {
+		_kfifo_init(fifo, 0, 0, NULL);
+		return -ENOMEM;
+	}
 
-	if (IS_ERR(ret))
-		kfree(buffer);
+	_kfifo_init(fifo, buffer, size, lock);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(kfifo_alloc);
 
 /**
- * kfifo_free - frees the FIFO
+ * kfifo_free - frees the FIFO internal buffer
  * @fifo: the fifo to be freed.
  */
 void kfifo_free(struct kfifo *fifo)
 {
 	kfree(fifo->buffer);
-	kfree(fifo);
 }
 EXPORT_SYMBOL(kfifo_free);
 
diff -puN net/dccp/probe.c~kfifo-move-struct-kfifo-in-place net/dccp/probe.c
--- a/net/dccp/probe.c~kfifo-move-struct-kfifo-in-place
+++ a/net/dccp/probe.c
@@ -43,7 +43,7 @@ static int bufsize = 64 * 1024;
 static const char procname[] = "dccpprobe";
 
 static struct {
-	struct kfifo	  *fifo;
+	struct kfifo	  fifo;
 	spinlock_t	  lock;
 	wait_queue_head_t wait;
 	struct timespec	  tstart;
@@ -67,7 +67,7 @@ static void printl(const char *fmt, ...)
 	len += vscnprintf(tbuf+len, sizeof(tbuf)-len, fmt, args);
 	va_end(args);
 
-	kfifo_put(dccpw.fifo, tbuf, len);
+	kfifo_put(&dccpw.fifo, tbuf, len);
 	wake_up(&dccpw.wait);
 }
 
@@ -109,7 +109,7 @@ static struct jprobe dccp_send_probe = {
 
 static int dccpprobe_open(struct inode *inode, struct file *file)
 {
-	kfifo_reset(dccpw.fifo);
+	kfifo_reset(&dccpw.fifo);
 	getnstimeofday(&dccpw.tstart);
 	return 0;
 }
@@ -131,11 +131,11 @@ static ssize_t dccpprobe_read(struct fil
 		return -ENOMEM;
 
 	error = wait_event_interruptible(dccpw.wait,
-					 __kfifo_len(dccpw.fifo) != 0);
+					 __kfifo_len(&dccpw.fifo) != 0);
 	if (error)
 		goto out_free;
 
-	cnt = kfifo_get(dccpw.fifo, tbuf, len);
+	cnt = kfifo_get(&dccpw.fifo, tbuf, len);
 	error = copy_to_user(buf, tbuf, cnt) ? -EFAULT : 0;
 
 out_free:
@@ -156,10 +156,8 @@ static __init int dccpprobe_init(void)
 
 	init_waitqueue_head(&dccpw.wait);
 	spin_lock_init(&dccpw.lock);
-	dccpw.fifo = kfifo_alloc(bufsize, GFP_KERNEL, &dccpw.lock);
-	if (IS_ERR(dccpw.fifo))
-		return PTR_ERR(dccpw.fifo);
-
+	if (kfifo_alloc(&dccpw.fifo, bufsize, GFP_KERNEL, &dccpw.lock))
+		return ret;
 	if (!proc_net_fops_create(&init_net, procname, S_IRUSR, &dccpprobe_fops))
 		goto err0;
 
@@ -172,14 +170,14 @@ static __init int dccpprobe_init(void)
 err1:
 	proc_net_remove(&init_net, procname);
 err0:
-	kfifo_free(dccpw.fifo);
+	kfifo_free(&dccpw.fifo);
 	return ret;
 }
 module_init(dccpprobe_init);
 
 static __exit void dccpprobe_exit(void)
 {
-	kfifo_free(dccpw.fifo);
+	kfifo_free(&dccpw.fifo);
 	proc_net_remove(&init_net, procname);
 	unregister_jprobe(&dccp_send_probe);
 
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch

