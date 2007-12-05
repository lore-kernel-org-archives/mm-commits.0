From: akpm@linux-foundation.org
Subject: + unix98-allocated_ptys_lock-semaphore-to-mutex.patch added to -mm tree
Date: Tue, 04 Dec 2007 19:05:15 -0800
Message-ID: <200712050305.lB535FCn018270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36102 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbXLEDFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 22:05:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, hpa@zytor.com, mingo@elte.hu


The patch titled
     unix98 allocated_ptys_lock semaphore to mutex
has been added to the -mm tree.  Its filename is
     unix98-allocated_ptys_lock-semaphore-to-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unix98 allocated_ptys_lock semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>

Convert the unix98 allocated_ptys_lock to a mutex.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/char/tty_io.c~unix98-allocated_ptys_lock-semaphore-to-mutex drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~unix98-allocated_ptys_lock-semaphore-to-mutex
+++ a/drivers/char/tty_io.c
@@ -138,7 +138,7 @@ EXPORT_SYMBOL(tty_mutex);
 extern struct tty_driver *ptm_driver;	/* Unix98 pty masters; for /dev/ptmx */
 extern int pty_limit;		/* Config limit on Unix98 ptys */
 static DEFINE_IDR(allocated_ptys);
-static DECLARE_MUTEX(allocated_ptys_lock);
+static DEFINE_MUTEX(allocated_ptys_lock);
 static int ptmx_open(struct inode *, struct file *);
 #endif
 
@@ -2571,9 +2571,9 @@ static void release_dev(struct file * fi
 #ifdef CONFIG_UNIX98_PTYS
 	/* Make this pty number available for reallocation */
 	if (devpts) {
-		down(&allocated_ptys_lock);
+		mutex_lock(&allocated_ptys_lock);
 		idr_remove(&allocated_ptys, idx);
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 	}
 #endif
 
@@ -2737,24 +2737,24 @@ static int ptmx_open(struct inode * inod
 	nonseekable_open(inode, filp);
 
 	/* find a device that is not in use. */
-	down(&allocated_ptys_lock);
+	mutex_lock(&allocated_ptys_lock);
 	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL)) {
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 		return -ENOMEM;
 	}
 	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
 	if (idr_ret < 0) {
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 		if (idr_ret == -EAGAIN)
 			return -ENOMEM;
 		return -EIO;
 	}
 	if (index >= pty_limit) {
 		idr_remove(&allocated_ptys, index);
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 		return -EIO;
 	}
-	up(&allocated_ptys_lock);
+	mutex_unlock(&allocated_ptys_lock);
 
 	mutex_lock(&tty_mutex);
 	retval = init_dev(ptm_driver, index, &tty);
@@ -2781,9 +2781,9 @@ out1:
 	release_dev(filp);
 	return retval;
 out:
-	down(&allocated_ptys_lock);
+	mutex_lock(&allocated_ptys_lock);
 	idr_remove(&allocated_ptys, index);
-	up(&allocated_ptys_lock);
+	mutex_unlock(&allocated_ptys_lock);
 	return retval;
 }
 #endif
_

Patches currently in -mm which might be from dwalker@mvista.com are

drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
