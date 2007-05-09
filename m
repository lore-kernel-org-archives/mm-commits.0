From: akpm@linux-foundation.org
Subject: - use-mutex-instead-of-semaphore-in-tpm-driver.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:47 -0700
Message-ID: <200705090252.l492qlMn009613@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032221AbXEICw5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, kjhall@us.ibm.com, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     use mutex instead of semaphore in TPM driver
has been removed from the -mm tree.  Its filename was
     use-mutex-instead-of-semaphore-in-tpm-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use mutex instead of semaphore in TPM driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The TPM driver uses two semaphores as mutexes.  Use the mutex API instead of
the (binary) semaphores.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |   24 +++++++++++++-----------
 drivers/char/tpm/tpm.h |    5 +++--
 2 files changed, 16 insertions(+), 13 deletions(-)

diff -puN drivers/char/tpm/tpm.c~use-mutex-instead-of-semaphore-in-tpm-driver drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~use-mutex-instead-of-semaphore-in-tpm-driver
+++ a/drivers/char/tpm/tpm.c
@@ -24,7 +24,9 @@
  */
 
 #include <linux/poll.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
+
 #include "tpm.h"
 
 enum tpm_const {
@@ -328,10 +330,10 @@ static void timeout_work(struct work_str
 {
 	struct tpm_chip *chip = container_of(work, struct tpm_chip, work);
 
-	down(&chip->buffer_mutex);
+	mutex_lock(&chip->buffer_mutex);
 	atomic_set(&chip->data_pending, 0);
 	memset(chip->data_buffer, 0, TPM_BUFSIZE);
-	up(&chip->buffer_mutex);
+	mutex_unlock(&chip->buffer_mutex);
 }
 
 /*
@@ -380,7 +382,7 @@ static ssize_t tpm_transmit(struct tpm_c
 		return -E2BIG;
 	}
 
-	down(&chip->tpm_mutex);
+	mutex_lock(&chip->tpm_mutex);
 
 	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {
 		dev_err(chip->dev,
@@ -419,7 +421,7 @@ out_recv:
 		dev_err(chip->dev,
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
-	up(&chip->tpm_mutex);
+	mutex_unlock(&chip->tpm_mutex);
 	return rc;
 }
 
@@ -966,14 +968,14 @@ ssize_t tpm_write(struct file *file, con
 	while (atomic_read(&chip->data_pending) != 0)
 		msleep(TPM_TIMEOUT);
 
-	down(&chip->buffer_mutex);
+	mutex_lock(&chip->buffer_mutex);
 
 	if (in_size > TPM_BUFSIZE)
 		in_size = TPM_BUFSIZE;
 
 	if (copy_from_user
 	    (chip->data_buffer, (void __user *) buf, in_size)) {
-		up(&chip->buffer_mutex);
+		mutex_unlock(&chip->buffer_mutex);
 		return -EFAULT;
 	}
 
@@ -981,7 +983,7 @@ ssize_t tpm_write(struct file *file, con
 	out_size = tpm_transmit(chip, chip->data_buffer, TPM_BUFSIZE);
 
 	atomic_set(&chip->data_pending, out_size);
-	up(&chip->buffer_mutex);
+	mutex_unlock(&chip->buffer_mutex);
 
 	/* Set a timeout by which the reader must come claim the result */
 	mod_timer(&chip->user_read_timer, jiffies + (60 * HZ));
@@ -1004,10 +1006,10 @@ ssize_t tpm_read(struct file *file, char
 		if (size < ret_size)
 			ret_size = size;
 
-		down(&chip->buffer_mutex);
+		mutex_lock(&chip->buffer_mutex);
 		if (copy_to_user(buf, chip->data_buffer, ret_size))
 			ret_size = -EFAULT;
-		up(&chip->buffer_mutex);
+		mutex_unlock(&chip->buffer_mutex);
 	}
 
 	return ret_size;
@@ -1105,8 +1107,8 @@ struct tpm_chip *tpm_register_hardware(s
 		return NULL;
 	}
 
-	init_MUTEX(&chip->buffer_mutex);
-	init_MUTEX(&chip->tpm_mutex);
+	mutex_init(&chip->buffer_mutex);
+	mutex_init(&chip->tpm_mutex);
 	INIT_LIST_HEAD(&chip->list);
 
 	INIT_WORK(&chip->work, timeout_work);
diff -puN drivers/char/tpm/tpm.h~use-mutex-instead-of-semaphore-in-tpm-driver drivers/char/tpm/tpm.h
--- a/drivers/char/tpm/tpm.h~use-mutex-instead-of-semaphore-in-tpm-driver
+++ a/drivers/char/tpm/tpm.h
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
+#include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/miscdevice.h>
 #include <linux/platform_device.h>
@@ -94,11 +95,11 @@ struct tpm_chip {
 	/* Data passed to and from the tpm via the read/write calls */
 	u8 *data_buffer;
 	atomic_t data_pending;
-	struct semaphore buffer_mutex;
+	struct mutex buffer_mutex;
 
 	struct timer_list user_read_timer;	/* user needs to claim result */
 	struct work_struct work;
-	struct semaphore tpm_mutex;	/* tpm is processing */
+	struct mutex tpm_mutex;	/* tpm is processing */
 
 	struct tpm_vendor_specific vendor;
 
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
power-management-use-mutexes-instead-of-semaphores.patch
sysdev-use-mutex-instead-of-semaphore.patch
git-dvb.patch
scx200-use-mutex-instead-of-semaphore.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
git-scsi-misc.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
git-watchdog.patch
