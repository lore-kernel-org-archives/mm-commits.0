From: akpm@linux-foundation.org
Subject: - fix-spinlock-usage-in-hysdn_log_close.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:22 -0700
Message-ID: <200705090253.l492rMLN009685@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032062AbXEICx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:53:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     fix spinlock usage in hysdn_log_close()
has been removed from the -mm tree.  Its filename was
     fix-spinlock-usage-in-hysdn_log_close.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix spinlock usage in hysdn_log_close()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Fix incorrect spinlock use in hysdn_log_close().  The function declared a
spinlock on the stack and used it to 'protect' a shared driver structure. 

The patch simply removes the useless code.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hysdn/hysdn_proclog.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/isdn/hysdn/hysdn_proclog.c~fix-spinlock-usage-in-hysdn_log_close drivers/isdn/hysdn/hysdn_proclog.c
--- a/drivers/isdn/hysdn/hysdn_proclog.c~fix-spinlock-usage-in-hysdn_log_close
+++ a/drivers/isdn/hysdn/hysdn_proclog.c
@@ -297,8 +297,6 @@ hysdn_log_close(struct inode *ino, struc
 	struct procdata *pd;
 	hysdn_card *card;
 	int retval = 0;
-	unsigned long flags;
-	spinlock_t hysdn_lock = SPIN_LOCK_UNLOCKED;
 
 	lock_kernel();
 	if ((filep->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_WRITE) {
@@ -308,7 +306,6 @@ hysdn_log_close(struct inode *ino, struc
 		/* read access -> log/debug read, mark one further file as closed */
 
 		pd = NULL;
-		spin_lock_irqsave(&hysdn_lock, flags);
 		inf = *((struct log_data **) filep->private_data);	/* get first log entry */
 		if (inf)
 			pd = (struct procdata *) inf->proc_ctrl;	/* still entries there */
@@ -331,7 +328,6 @@ hysdn_log_close(struct inode *ino, struc
 			inf->usage_cnt--;	/* decrement usage count for buffers */
 			inf = inf->next;
 		}
-		spin_unlock_irqrestore(&hysdn_lock, flags);
 
 		if (pd)
 			if (pd->if_used <= 0)	/* delete buffers if last file closed */
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
