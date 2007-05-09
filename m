From: akpm@linux-foundation.org
Subject: - use-mutex-instead-of-semaphore-in-rocketport-driver.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:45 -0700
Message-ID: <200705090252.l492qj2X009607@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030323AbXEICws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     use mutex instead of semaphore in RocketPort driver
has been removed from the -mm tree.  Its filename was
     use-mutex-instead-of-semaphore-in-rocketport-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use mutex instead of semaphore in RocketPort driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The RocketPort driver uses a semaphore as mutex.  Use the mutex API instead of
the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c     |   19 +++++++++++--------
 drivers/char/rocket_int.h |    4 +++-
 2 files changed, 14 insertions(+), 9 deletions(-)

diff -puN drivers/char/rocket.c~use-mutex-instead-of-semaphore-in-rocketport-driver drivers/char/rocket.c
--- a/drivers/char/rocket.c~use-mutex-instead-of-semaphore-in-rocketport-driver
+++ a/drivers/char/rocket.c
@@ -81,6 +81,7 @@
 #include <linux/string.h>
 #include <linux/fcntl.h>
 #include <linux/ptrace.h>
+#include <linux/mutex.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
@@ -89,7 +90,6 @@
 #include <asm/atomic.h>
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
-#include <asm/semaphore.h>
 #include <linux/init.h>
 
 /****** RocketPort includes ******/
@@ -698,7 +698,7 @@ static void init_r_port(int board, int a
 		}
 	}
 	spin_lock_init(&info->slock);
-	sema_init(&info->write_sem, 1);
+	mutex_init(&info->write_mtx);
 	rp_table[line] = info;
 	if (pci_dev)
 		tty_register_device(rocket_driver, line, &pci_dev->dev);
@@ -1657,8 +1657,11 @@ static void rp_put_char(struct tty_struc
 	if (rocket_paranoia_check(info, "rp_put_char"))
 		return;
 
-	/*  Grab the port write semaphore, locking out other processes that try to write to this port */
-	down(&info->write_sem);
+	/*
+	 * Grab the port write mutex, locking out other processes that try to
+	 * write to this port
+	 */
+	mutex_lock(&info->write_mtx);
 
 #ifdef ROCKET_DEBUG_WRITE
 	printk(KERN_INFO "rp_put_char %c...", ch);
@@ -1680,12 +1683,12 @@ static void rp_put_char(struct tty_struc
 		info->xmit_fifo_room--;
 	}
 	spin_unlock_irqrestore(&info->slock, flags);
-	up(&info->write_sem);
+	mutex_unlock(&info->write_mtx);
 }
 
 /*
  *  Exception handler - write routine, called when user app writes to the device.
- *  A per port write semaphore is used to protect from another process writing to
+ *  A per port write mutex is used to protect from another process writing to
  *  this port at the same time.  This other process could be running on the other CPU
  *  or get control of the CPU if the copy_from_user() blocks due to a page fault (swapped out). 
  *  Spinlocks protect the info xmit members.
@@ -1702,7 +1705,7 @@ static int rp_write(struct tty_struct *t
 	if (count <= 0 || rocket_paranoia_check(info, "rp_write"))
 		return 0;
 
-	down_interruptible(&info->write_sem);
+	mutex_lock_interruptible(&info->write_mtx);
 
 #ifdef ROCKET_DEBUG_WRITE
 	printk(KERN_INFO "rp_write %d chars...", count);
@@ -1773,7 +1776,7 @@ end:
 		wake_up_interruptible(&tty->poll_wait);
 #endif
 	}
-	up(&info->write_sem);
+	mutex_unlock(&info->write_mtx);
 	return retval;
 }
 
diff -puN drivers/char/rocket_int.h~use-mutex-instead-of-semaphore-in-rocketport-driver drivers/char/rocket_int.h
--- a/drivers/char/rocket_int.h~use-mutex-instead-of-semaphore-in-rocketport-driver
+++ a/drivers/char/rocket_int.h
@@ -15,6 +15,8 @@
 #define ROCKET_TYPE_MODEMIII	3
 #define ROCKET_TYPE_PC104       4
 
+#include <linux/mutex.h>
+
 #include <asm/io.h>
 #include <asm/byteorder.h>
 
@@ -1171,7 +1173,7 @@ struct r_port {
 	struct wait_queue *close_wait;
 #endif
 	spinlock_t slock;
-	struct semaphore write_sem;
+	struct mutex write_mtx;
 };
 
 #define RPORT_MAGIC 0x525001
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
