From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-virtual-console-driver.patch added to -mm tree
Date: Thu, 03 May 2007 20:17:01 -0700
Message-ID: <200705040317.l443H1ml027973@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767618AbXEDDRH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 23:17:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, adaplas@pol.net


The patch titled
     use mutex instead of semaphore in virtual console driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-virtual-console-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of semaphore in virtual console driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The virtual console driver uses a semaphore as mutex.  Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vc_screen.c |   16 ++++++++--------
 drivers/char/vt.c        |    4 ++--
 include/linux/vt_kern.h  |    2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/char/vc_screen.c~use-mutex-instead-of-semaphore-in-virtual-console-driver drivers/char/vc_screen.c
--- a/drivers/char/vc_screen.c~use-mutex-instead-of-semaphore-in-virtual-console-driver
+++ a/drivers/char/vc_screen.c
@@ -69,11 +69,11 @@ static loff_t vcs_lseek(struct file *fil
 {
 	int size;
 
-	down(&con_buf_sem);
+	mutex_lock(&con_buf_mtx);
 	size = vcs_size(file->f_path.dentry->d_inode);
 	switch (orig) {
 		default:
-			up(&con_buf_sem);
+			mutex_unlock(&con_buf_mtx);
 			return -EINVAL;
 		case 2:
 			offset += size;
@@ -84,11 +84,11 @@ static loff_t vcs_lseek(struct file *fil
 			break;
 	}
 	if (offset < 0 || offset > size) {
-		up(&con_buf_sem);
+		mutex_unlock(&con_buf_mtx);
 		return -EINVAL;
 	}
 	file->f_pos = offset;
-	up(&con_buf_sem);
+	mutex_unlock(&con_buf_mtx);
 	return file->f_pos;
 }
 
@@ -105,7 +105,7 @@ vcs_read(struct file *file, char __user 
 	unsigned short *org = NULL;
 	ssize_t ret;
 
-	down(&con_buf_sem);
+	mutex_lock(&con_buf_mtx);
 
 	pos = *ppos;
 
@@ -262,7 +262,7 @@ vcs_read(struct file *file, char __user 
 		ret = read;
 unlock_out:
 	release_console_sem();
-	up(&con_buf_sem);
+	mutex_unlock(&con_buf_mtx);
 	return ret;
 }
 
@@ -279,7 +279,7 @@ vcs_write(struct file *file, const char 
 	u16 *org0 = NULL, *org = NULL;
 	size_t ret;
 
-	down(&con_buf_sem);
+	mutex_lock(&con_buf_mtx);
 
 	pos = *ppos;
 
@@ -449,7 +449,7 @@ vcs_write(struct file *file, const char 
 unlock_out:
 	release_console_sem();
 
-	up(&con_buf_sem);
+	mutex_unlock(&con_buf_mtx);
 
 	return ret;
 }
diff -puN drivers/char/vt.c~use-mutex-instead-of-semaphore-in-virtual-console-driver drivers/char/vt.c
--- a/drivers/char/vt.c~use-mutex-instead-of-semaphore-in-virtual-console-driver
+++ a/drivers/char/vt.c
@@ -1952,7 +1952,7 @@ static void do_con_trol(struct tty_struc
  * kernel memory allocation is available.
  */
 char con_buf[CON_BUF_SIZE];
-DECLARE_MUTEX(con_buf_sem);
+DEFINE_MUTEX(con_buf_mtx);
 
 /* is_double_width() is based on the wcwidth() implementation by
  * Markus Kuhn -- 2003-05-20 (Unicode 4.0)
@@ -2049,7 +2049,7 @@ static int do_con_write(struct tty_struc
 
 	/* At this point 'buf' is guaranteed to be a kernel buffer
 	 * and therefore no access to userspace (and therefore sleeping)
-	 * will be needed.  The con_buf_sem serializes all tty based
+	 * will be needed.  The con_buf_mtx serializes all tty based
 	 * console rendering and vcs write/read operations.  We hold
 	 * the console spinlock during the entire write.
 	 */
diff -puN include/linux/vt_kern.h~use-mutex-instead-of-semaphore-in-virtual-console-driver include/linux/vt_kern.h
--- a/include/linux/vt_kern.h~use-mutex-instead-of-semaphore-in-virtual-console-driver
+++ a/include/linux/vt_kern.h
@@ -82,7 +82,7 @@ void reset_vc(struct vc_data *vc);
 
 #define CON_BUF_SIZE (CONFIG_BASE_SMALL ? 256 : PAGE_SIZE)
 extern char con_buf[CON_BUF_SIZE];
-extern struct semaphore con_buf_sem;
+extern struct mutex con_buf_mtx;
 extern char vt_dont_switch;
 
 struct vt_spawn_console {
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
include-kern_-constant-in-printk-calls-in-mm-slabc.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
git-dvb.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
qla1280-use-dma_64bit_mask-instead-of-0ull.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
use-mutex-instead-of-semaphore-in-rocketport-driver.patch
use-mutex-instead-of-semaphore-in-tpm-driver.patch
use-mutex-instead-of-semaphore-in-hdaps-driver.patch
use-mutex-instead-of-semaphore-for-misc-char-devices.patch
fix-spinlock-usage-in-hysdn_log_close.patch
use-mutex-instead-of-semaphore-in-capi-20-interface.patch
use-mutex-instead-of-semaphore-in-virtual-console-driver.patch
