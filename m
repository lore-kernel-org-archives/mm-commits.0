From: akpm@linux-foundation.org
Subject: [merged] pps-make-idr-lock-a-mutex-and-protect-idr_pre_get.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:24 -0800
Message-ID: <201101132012.p0DKC5kd030251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933703Ab1AMUMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:12:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     pps: make idr lock a mutex and protect idr_pre_get
has been removed from the -mm tree.  Its filename was
     pps-make-idr-lock-a-mutex-and-protect-idr_pre_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: make idr lock a mutex and protect idr_pre_get
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Now pps_idr_lock is never used in interrupt context so we can replace
spin_lock_irq/spin_unlock_irq with plain spin_lock/spin_unlock. But
there is also a potential race condition when someone can steal an id
which was allocated by idr_pre_get before it is used. So convert spin
lock to mutex and protect the whole id generation process.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/pps.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/pps/pps.c~pps-make-idr-lock-a-mutex-and-protect-idr_pre_get drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-make-idr-lock-a-mutex-and-protect-idr_pre_get
+++ a/drivers/pps/pps.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <linux/idr.h>
+#include <linux/mutex.h>
 #include <linux/cdev.h>
 #include <linux/poll.h>
 #include <linux/pps_kernel.h>
@@ -39,7 +40,7 @@
 static dev_t pps_devt;
 static struct class *pps_class;
 
-static DEFINE_SPINLOCK(pps_idr_lock);
+static DEFINE_MUTEX(pps_idr_lock);
 static DEFINE_IDR(pps_idr);
 
 /*
@@ -239,9 +240,9 @@ static void pps_device_destruct(struct d
 
 	/* release id here to protect others from using it while it's
 	 * still in use */
-	spin_lock_irq(&pps_idr_lock);
+	mutex_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	mutex_unlock(&pps_idr_lock);
 
 	kfree(dev);
 	kfree(pps);
@@ -252,17 +253,19 @@ int pps_register_cdev(struct pps_device 
 	int err;
 	dev_t devt;
 
+	mutex_lock(&pps_idr_lock);
 	/* Get new ID for the new PPS source */
-	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0)
+	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
+		mutex_unlock(&pps_idr_lock);
 		return -ENOMEM;
+	}
 
 	/* Now really allocate the PPS source.
 	 * After idr_get_new() calling the new source will be freely available
 	 * into the kernel.
 	 */
-	spin_lock_irq(&pps_idr_lock);
 	err = idr_get_new(&pps_idr, pps, &pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	mutex_unlock(&pps_idr_lock);
 
 	if (err < 0)
 		return err;
@@ -302,9 +305,9 @@ del_cdev:
 	cdev_del(&pps->cdev);
 
 free_idr:
-	spin_lock_irq(&pps_idr_lock);
+	mutex_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	mutex_unlock(&pps_idr_lock);
 
 	return err;
 }
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

origin.patch

