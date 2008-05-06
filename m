From: akpm@linux-foundation.org
Subject: + uml-random-driver-style-fixes.patch added to -mm tree
Date: Tue, 06 May 2008 13:49:10 -0700
Message-ID: <200805062049.m46KnAtX026547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761396AbYEFUtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, xiyou.wangcong@gmail.com


The patch titled
     uml: random driver style fixes
has been added to the -mm tree.  Its filename is
     uml-random-driver-style-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: random driver style fixes
From: Jeff Dike <jdike@addtoit.com>

Give random.c a style workover while I'm changing it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/random.c |   77 +++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 37 deletions(-)

diff -puN arch/um/drivers/random.c~uml-random-driver-style-fixes arch/um/drivers/random.c
--- a/arch/um/drivers/random.c~uml-random-driver-style-fixes
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
-
- err_out_cleanup_hw:
+err_out_cleanup_hw:
 	os_close_file(random_fd);
-        random_fd = -1;
-        goto out;
+	random_fd = -1;
+	goto out;
 }
 
 /*
_

Patches currently in -mm which might be from jdike@addtoit.com are

linux-next.patch
uml-fix-inconsistence-due-to-tty_operation-change.patch
uml-redo-host-capability-detection-and-disabling.patch
uml-tidy-stub-management-code.patch
uml-style-fixes.patch
uml-random-driver-fixes.patch
uml-random-driver-style-fixes.patch
uml-hppfs-fixes.patch
uml-move-hppfs_kernc-to-hppfsc.patch
uml-tidy-ptrace-interface.patch
uml-fix-errno-return.patch
uml-track-and-make-up-lost-ticks.patch
uml-fix-build-when-slob-is-enabled.patch
uml-remove-unused-header.patch
uml-fix-bad-ntp-interaction-with-clock.patch
uml-use-__spin_lock_unlocked.patch
uml-physical-memory-shouldnt-include-initial-stack.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

