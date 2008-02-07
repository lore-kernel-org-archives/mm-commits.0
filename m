From: akpm@linux-foundation.org
Subject: - parallel-port-convert-port_mutex-to-the-mutex-api.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:07 -0800
Message-ID: <200802070020.m170KmTZ006193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763173AbYBGAoW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Parallel port: convert port_mutex to the mutex API
has been removed from the -mm tree.  Its filename was
     parallel-port-convert-port_mutex-to-the-mutex-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Parallel port: convert port_mutex to the mutex API
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Parallel port: Convert port_mutex to the mutex API

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/lp.c  |   10 +++++-----
 include/linux/lp.h |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/char/lp.c~parallel-port-convert-port_mutex-to-the-mutex-api drivers/char/lp.c
--- a/drivers/char/lp.c~parallel-port-convert-port_mutex-to-the-mutex-api
+++ a/drivers/char/lp.c
@@ -312,7 +312,7 @@ static ssize_t lp_write(struct file * fi
 	if (copy_size > LP_BUFFER_SIZE)
 		copy_size = LP_BUFFER_SIZE;
 
-	if (down_interruptible (&lp_table[minor].port_mutex))
+	if (mutex_lock_interruptible(&lp_table[minor].port_mutex))
 		return -EINTR;
 
 	if (copy_from_user (kbuf, buf, copy_size)) {
@@ -399,7 +399,7 @@ static ssize_t lp_write(struct file * fi
 		lp_release_parport (&lp_table[minor]);
 	}
 out_unlock:
-	up (&lp_table[minor].port_mutex);
+	mutex_unlock(&lp_table[minor].port_mutex);
 
  	return retv;
 }
@@ -421,7 +421,7 @@ static ssize_t lp_read(struct file * fil
 	if (count > LP_BUFFER_SIZE)
 		count = LP_BUFFER_SIZE;
 
-	if (down_interruptible (&lp_table[minor].port_mutex))
+	if (mutex_lock_interruptible(&lp_table[minor].port_mutex))
 		return -EINTR;
 
 	lp_claim_parport_or_block (&lp_table[minor]);
@@ -479,7 +479,7 @@ static ssize_t lp_read(struct file * fil
 	if (retval > 0 && copy_to_user (buf, kbuf, retval))
 		retval = -EFAULT;
 
-	up (&lp_table[minor].port_mutex);
+	mutex_unlock(&lp_table[minor].port_mutex);
 
 	return retval;
 }
@@ -888,7 +888,7 @@ static int __init lp_init (void)
 		lp_table[i].last_error = 0;
 		init_waitqueue_head (&lp_table[i].waitq);
 		init_waitqueue_head (&lp_table[i].dataq);
-		init_MUTEX (&lp_table[i].port_mutex);
+		mutex_init(&lp_table[i].port_mutex);
 		lp_table[i].timeout = 10 * HZ;
 	}
 
diff -puN include/linux/lp.h~parallel-port-convert-port_mutex-to-the-mutex-api include/linux/lp.h
--- a/include/linux/lp.h~parallel-port-convert-port_mutex-to-the-mutex-api
+++ a/include/linux/lp.h
@@ -99,7 +99,7 @@
 #ifdef __KERNEL__
 
 #include <linux/wait.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 /* Magic numbers for defining port-device mappings */
 #define LP_PARPORT_UNSPEC -4
@@ -145,7 +145,7 @@ struct lp_struct {
 #endif
 	wait_queue_head_t waitq;
 	unsigned int last_error;
-	struct semaphore port_mutex;
+	struct mutex port_mutex;
 	wait_queue_head_t dataq;
 	long timeout;
 	unsigned int best_mode;
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
acpi_pci_irq_find_prt_entry-use-list_for_each_entry-instead-of-list_for_each.patch
mbcs-convert-algolock-to-mutex.patch
mbcs-convert-dmawritelock-to-mutex.patch
mbcs-convert-dmareadlock-to-mutex.patch
