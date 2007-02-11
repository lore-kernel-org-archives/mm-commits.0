From: akpm@linux-foundation.org
Subject: - uml-watchdog-driver-locking.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:27 -0800
Message-ID: <200702112248.l1BMmRhA015627@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59720 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932659AbXBKWs3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: watchdog driver locking
has been removed from the -mm tree.  Its filename was
     uml-watchdog-driver-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: watchdog driver locking
From: Jeff Dike <jdike@addtoit.com>

Replace BKL use with a spinlock.

Also fix the control so that open doesn't return holding a lock.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/harddog_kern.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN arch/um/drivers/harddog_kern.c~uml-watchdog-driver-locking arch/um/drivers/harddog_kern.c
--- a/arch/um/drivers/harddog_kern.c~uml-watchdog-driver-locking
+++ a/arch/um/drivers/harddog_kern.c
@@ -44,12 +44,13 @@
 #include <linux/reboot.h>
 #include <linux/smp_lock.h>
 #include <linux/init.h>
+#include <linux/spinlock.h>
 #include <asm/uaccess.h>
 #include "mconsole.h"
 
 MODULE_LICENSE("GPL");
 
-/* Locked by the BKL in harddog_open and harddog_release */
+static DEFINE_SPINLOCK(lock);
 static int timer_alive;
 static int harddog_in_fd = -1;
 static int harddog_out_fd = -1;
@@ -62,12 +63,12 @@ extern int start_watchdog(int *in_fd_ret
 
 static int harddog_open(struct inode *inode, struct file *file)
 {
-	int err;
+	int err = -EBUSY;
 	char *sock = NULL;
 
-	lock_kernel();
+	spin_lock(&lock);
 	if(timer_alive)
-		return -EBUSY;
+		goto err;
 #ifdef CONFIG_HARDDOG_NOWAYOUT	 
 	__module_get(THIS_MODULE);
 #endif
@@ -76,11 +77,15 @@ static int harddog_open(struct inode *in
 	sock = mconsole_notify_socket();
 #endif
 	err = start_watchdog(&harddog_in_fd, &harddog_out_fd, sock);
-	if(err) return(err);
+	if(err)
+		goto err;
 
 	timer_alive = 1;
-	unlock_kernel();
+	spin_unlock(&lock);
 	return nonseekable_open(inode, file);
+err:
+	spin_unlock(&lock);
+	return err;
 }
 
 extern void stop_watchdog(int in_fd, int out_fd);
@@ -90,14 +95,16 @@ static int harddog_release(struct inode 
 	/*
 	 *	Shut off the timer.
 	 */
-	lock_kernel();
+
+	spin_lock(&lock);
 
 	stop_watchdog(harddog_in_fd, harddog_out_fd);
 	harddog_in_fd = -1;
 	harddog_out_fd = -1;
 
 	timer_alive=0;
-	unlock_kernel();
+	spin_unlock(&lock);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
