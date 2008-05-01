From: akpm@linux-foundation.org
Subject: - devpts-factor-out-pty-index-allocation.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:09 -0700
Message-ID: <200805010931.m419V9sJ030845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755538AbYEAJb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, hpa@zytor.com, matthltc@us.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devpts: factor out PTY index allocation
has been removed from the -mm tree.  Its filename was
     devpts-factor-out-pty-index-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devpts: factor out PTY index allocation
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Factor out the code used to allocate/free a pts index into new interfaces,
devpts_new_index() and devpts_kill_index().  This localizes the external data
structures used in managing the pts indices.

[akpm@linux-foundation.org: undo accidental mutex2sem conversion]
Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c     |   40 +++++----------------------------
 fs/devpts/inode.c         |   43 +++++++++++++++++++++++++++++++++++-
 include/linux/devpts_fs.h |    4 +++
 3 files changed, 52 insertions(+), 35 deletions(-)

diff -puN drivers/char/tty_io.c~devpts-factor-out-pty-index-allocation drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~devpts-factor-out-pty-index-allocation
+++ a/drivers/char/tty_io.c
@@ -91,7 +91,6 @@
 #include <linux/module.h>
 #include <linux/smp_lock.h>
 #include <linux/device.h>
-#include <linux/idr.h>
 #include <linux/wait.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
@@ -137,9 +136,6 @@ EXPORT_SYMBOL(tty_mutex);
 
 #ifdef CONFIG_UNIX98_PTYS
 extern struct tty_driver *ptm_driver;	/* Unix98 pty masters; for /dev/ptmx */
-extern int pty_limit;			/* Config limit on Unix98 ptys */
-static DEFINE_IDR(allocated_ptys);
-static DEFINE_MUTEX(allocated_ptys_lock);
 static int ptmx_open(struct inode *, struct file *);
 #endif
 
@@ -2639,15 +2635,9 @@ static void release_dev(struct file *fil
 	 */
 	release_tty(tty, idx);
 
-#ifdef CONFIG_UNIX98_PTYS
 	/* Make this pty number available for reallocation */
-	if (devpts) {
-		mutex_lock(&allocated_ptys_lock);
-		idr_remove(&allocated_ptys, idx);
-		mutex_unlock(&allocated_ptys_lock);
-	}
-#endif
-
+	if (devpts)
+		devpts_kill_index(idx);
 }
 
 /**
@@ -2803,29 +2793,13 @@ static int ptmx_open(struct inode *inode
 	struct tty_struct *tty;
 	int retval;
 	int index;
-	int idr_ret;
 
 	nonseekable_open(inode, filp);
 
 	/* find a device that is not in use. */
-	mutex_lock(&allocated_ptys_lock);
-	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL)) {
-		mutex_unlock(&allocated_ptys_lock);
-		return -ENOMEM;
-	}
-	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
-	if (idr_ret < 0) {
-		mutex_unlock(&allocated_ptys_lock);
-		if (idr_ret == -EAGAIN)
-			return -ENOMEM;
-		return -EIO;
-	}
-	if (index >= pty_limit) {
-		idr_remove(&allocated_ptys, index);
-		mutex_unlock(&allocated_ptys_lock);
-		return -EIO;
-	}
-	mutex_unlock(&allocated_ptys_lock);
+	index = devpts_new_index();
+	if (index < 0)
+		return index;
 
 	mutex_lock(&tty_mutex);
 	retval = init_dev(ptm_driver, index, &tty);
@@ -2850,9 +2824,7 @@ out1:
 	release_dev(filp);
 	return retval;
 out:
-	mutex_lock(&allocated_ptys_lock);
-	idr_remove(&allocated_ptys, index);
-	mutex_unlock(&allocated_ptys_lock);
+	devpts_kill_index(index);
 	return retval;
 }
 #endif
diff -puN fs/devpts/inode.c~devpts-factor-out-pty-index-allocation fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-factor-out-pty-index-allocation
+++ a/fs/devpts/inode.c
@@ -17,6 +17,8 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/tty.h>
+#include <linux/mutex.h>
+#include <linux/idr.h>
 #include <linux/devpts_fs.h>
 #include <linux/parser.h>
 #include <linux/fsnotify.h>
@@ -26,6 +28,10 @@
 
 #define DEVPTS_DEFAULT_MODE 0600
 
+extern int pty_limit;			/* Config limit on Unix98 ptys */
+static DEFINE_IDR(allocated_ptys);
+static DEFINE_MUTEX(allocated_ptys_lock);
+
 static struct vfsmount *devpts_mnt;
 static struct dentry *devpts_root;
 
@@ -171,9 +177,44 @@ static struct dentry *get_node(int num)
 	return lookup_one_len(s, root, sprintf(s, "%d", num));
 }
 
+int devpts_new_index(void)
+{
+	int index;
+	int idr_ret;
+
+retry:
+	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL)) {
+		return -ENOMEM;
+	}
+
+	mutex_lock(&allocated_ptys_lock);
+	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
+	if (idr_ret < 0) {
+		mutex_unlock(&allocated_ptys_lock);
+		if (idr_ret == -EAGAIN)
+			goto retry;
+		return -EIO;
+	}
+
+	if (index >= pty_limit) {
+		idr_remove(&allocated_ptys, index);
+		mutex_unlock(&allocated_ptys_lock);
+		return -EIO;
+	}
+	mutex_unlock(&allocated_ptys_lock);
+	return index;
+}
+
+void devpts_kill_index(int idx)
+{
+	mutex_lock(&allocated_ptys_lock);
+	idr_remove(&allocated_ptys, idx);
+	mutex_unlock(&allocated_ptys_lock);
+}
+
 int devpts_pty_new(struct tty_struct *tty)
 {
-	int number = tty->index;
+	int number = tty->index; /* tty layer puts index from devpts_new_index() in here */
 	struct tty_driver *driver = tty->driver;
 	dev_t device = MKDEV(driver->major, driver->minor_start+number);
 	struct dentry *dentry;
diff -puN include/linux/devpts_fs.h~devpts-factor-out-pty-index-allocation include/linux/devpts_fs.h
--- a/include/linux/devpts_fs.h~devpts-factor-out-pty-index-allocation
+++ a/include/linux/devpts_fs.h
@@ -17,6 +17,8 @@
 
 #ifdef CONFIG_UNIX98_PTYS
 
+int devpts_new_index(void);
+void devpts_kill_index(int idx);
 int devpts_pty_new(struct tty_struct *tty);      /* mknod in devpts */
 struct tty_struct *devpts_get_tty(int number);	 /* get tty structure */
 void devpts_pty_kill(int number);		 /* unlink */
@@ -24,6 +26,8 @@ void devpts_pty_kill(int number);		 /* u
 #else
 
 /* Dummy stubs in the no-pty case */
+static inline int devpts_new_index(void) { return -EINVAL; }
+static inline void devpts_kill_index(int idx) { }
 static inline int devpts_pty_new(struct tty_struct *tty) { return -EINVAL; }
 static inline struct tty_struct *devpts_get_tty(int number) { return NULL; }
 static inline void devpts_pty_kill(int number) { }
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

origin.patch

