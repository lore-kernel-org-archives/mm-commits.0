From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-rocketport-driver.patch added to -mm tree
Date: Thu, 03 May 2007 20:15:50 -0700
Message-ID: <200705040315.l443Fo16027951@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754259AbXEDDPx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 23:15:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     use mutex instead of semaphore in RocketPort driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-rocketport-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of semaphore in RocketPort driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The RocketPort driver uses a semaphore as mutex.  Use the mutex API instead of
the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c     |   10 +++++-----
 drivers/char/rocket_int.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/rocket.c~use-mutex-instead-of-semaphore-in-rocketport-driver drivers/char/rocket.c
--- a/drivers/char/rocket.c~use-mutex-instead-of-semaphore-in-rocketport-driver
+++ a/drivers/char/rocket.c
@@ -698,7 +698,7 @@ static void init_r_port(int board, int a
 		}
 	}
 	spin_lock_init(&info->slock);
-	sema_init(&info->write_sem, 1);
+	mutex_init(&info->write_mtx);
 	rp_table[line] = info;
 	if (pci_dev)
 		tty_register_device(rocket_driver, line, &pci_dev->dev);
@@ -1658,7 +1658,7 @@ static void rp_put_char(struct tty_struc
 		return;
 
 	/*  Grab the port write semaphore, locking out other processes that try to write to this port */
-	down(&info->write_sem);
+	mutex_lock(&info->write_mtx);
 
 #ifdef ROCKET_DEBUG_WRITE
 	printk(KERN_INFO "rp_put_char %c...", ch);
@@ -1680,7 +1680,7 @@ static void rp_put_char(struct tty_struc
 		info->xmit_fifo_room--;
 	}
 	spin_unlock_irqrestore(&info->slock, flags);
-	up(&info->write_sem);
+	mutex_unlock(&info->write_mtx);
 }
 
 /*
@@ -1702,7 +1702,7 @@ static int rp_write(struct tty_struct *t
 	if (count <= 0 || rocket_paranoia_check(info, "rp_write"))
 		return 0;
 
-	down_interruptible(&info->write_sem);
+	mutex_lock_interruptible(&info->write_mtx);
 
 #ifdef ROCKET_DEBUG_WRITE
 	printk(KERN_INFO "rp_write %d chars...", count);
@@ -1773,7 +1773,7 @@ end:
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
@@ -1171,7 +1171,7 @@ struct r_port {
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
