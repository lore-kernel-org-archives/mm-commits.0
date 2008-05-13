From: akpm@linux-foundation.org
Subject: - uml-style-fixes-in-the-random-driver.patch removed from -mm tree
Date: Tue, 13 May 2008 14:32:53 -0700
Message-ID: <200805132132.m4DLWr6F000759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761124AbYEMVc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:32:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: style fixes in the random driver
has been removed from the -mm tree.  Its filename was
     uml-style-fixes-in-the-random-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: style fixes in the random driver
From: Jeff Dike <jdike@addtoit.com>

Give random.c a style workover while I'm changing it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/random.c |   77 +++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 37 deletions(-)

diff -puN arch/um/drivers/random.c~uml-style-fixes-in-the-random-driver arch/um/drivers/random.c
--- a/arch/um/drivers/random.c~uml-style-fixes-in-the-random-driver
+++ a/arch/um/drivers/random.c
@@ -1,4 +1,5 @@
-/* Copyright (C) 2005 Jeff Dike <jdike@addtoit.com> */
+/* Copyright (C) 2005 - 2008 Jeff Dike <jdike@{linux.intel,addtoit}.com> */
+
 /* Much of this ripped from drivers/char/hw_random.c, see there for other
  * copyright.
  *
@@ -35,7 +36,7 @@ static int rng_dev_open (struct inode *i
 	/* enforce read-only access to this chrdev */
 	if ((filp->f_mode & FMODE_READ) == 0)
 		return -EINVAL;
-	if (filp->f_mode & FMODE_WRITE)
+	if ((filp->f_mode & FMODE_WRITE) != 0)
 		return -EINVAL;
 
 	return 0;
@@ -44,31 +45,31 @@ static int rng_dev_open (struct inode *i
 static atomic_t host_sleep_count = ATOMIC_INIT(0);
 
 static ssize_t rng_dev_read (struct file *filp, char __user *buf, size_t size,
-                             loff_t * offp)
+			     loff_t *offp)
 {
-        u32 data;
-        int n, ret = 0, have_data;
+	u32 data;
+	int n, ret = 0, have_data;
 
-        while(size){
-                n = os_read_file(random_fd, &data, sizeof(data));
-                if(n > 0){
-                        have_data = n;
-                        while (have_data && size) {
-                                if (put_user((u8)data, buf++)) {
-                                        ret = ret ? : -EFAULT;
-                                        break;
-                                }
-                                size--;
-                                ret++;
-                                have_data--;
-                                data>>=8;
-                        }
-                }
-                else if(n == -EAGAIN){
+	while (size) {
+		n = os_read_file(random_fd, &data, sizeof(data));
+		if (n > 0) {
+			have_data = n;
+			while (have_data && size) {
+				if (put_user((u8) data, buf++)) {
+					ret = ret ? : -EFAULT;
+					break;
+				}
+				size--;
+				ret++;
+				have_data--;
+				data >>= 8;
+			}
+		}
+		else if (n == -EAGAIN) {
 			DECLARE_WAITQUEUE(wait, current);
 
-                        if (filp->f_flags & O_NONBLOCK)
-                                return ret ? : -EAGAIN;
+			if (filp->f_flags & O_NONBLOCK)
+				return ret ? : -EAGAIN;
 
 			atomic_inc(&host_sleep_count);
 			reactivate_fd(random_fd, RANDOM_IRQ);
@@ -85,8 +86,10 @@ static ssize_t rng_dev_read (struct file
 				ignore_sigio_fd(random_fd);
 				deactivate_fd(random_fd, RANDOM_IRQ);
 			}
-                }
-                else return n;
+		}
+		else
+			return n;
+
 		if (signal_pending (current))
 			return ret ? : -ERESTARTSYS;
 	}
@@ -120,33 +123,33 @@ static int __init rng_init (void)
 {
 	int err;
 
-        err = os_open_file("/dev/random", of_read(OPENFLAGS()), 0);
-        if(err < 0)
-                goto out;
+	err = os_open_file("/dev/random", of_read(OPENFLAGS()), 0);
+	if (err < 0)
+		goto out;
 
-        random_fd = err;
+	random_fd = err;
 
 	err = um_request_irq(RANDOM_IRQ, random_fd, IRQ_READ, random_interrupt,
 			     IRQF_DISABLED | IRQF_SAMPLE_RANDOM, "random",
 			     NULL);
-        if(err)
+	if (err)
 		goto err_out_cleanup_hw;
 
 	sigio_broken(random_fd, 1);
 
 	err = misc_register (&rng_miscdev);
 	if (err) {
-		printk (KERN_ERR RNG_MODULE_NAME ": misc device register failed\n");
+		printk (KERN_ERR RNG_MODULE_NAME ": misc device register "
+			"failed\n");
 		goto err_out_cleanup_hw;
 	}
+out:
+	return err;
 
- out:
-        return err;
