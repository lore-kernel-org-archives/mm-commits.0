From: akpm@linux-foundation.org
Subject: [to-be-updated] pps-dont-disable-interrupts-when-using-spin-locks.patch removed from -mm tree
Date: Fri, 17 Dec 2010 16:04:48 -0800
Message-ID: <201012180004.oBI04mOf004210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756542Ab0LRAFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Dec 2010 19:05:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, johnstul@us.ibm.com, joonwpark81@gmail.com, tj@kernel.org, yoush@cs.msu.su, mm-commits@vger.kernel.org


The patch titled
     pps: don't disable interrupts when using spin locks
has been removed from the -mm tree.  Its filename was
     pps-dont-disable-interrupts-when-using-spin-locks.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: don't disable interrupts when using spin locks
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Now all PPS spin locks are never used in interrupt context so we can
safely replace spin_lock_irq*/spin_unlock_irq* with plain
spin_lock/spin_unlock.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: Rodolfo Giometti <giometti@linux.it>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kapi.c |    5 ++---
 drivers/pps/pps.c  |   24 ++++++++++++------------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff -puN drivers/pps/kapi.c~pps-dont-disable-interrupts-when-using-spin-locks drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-dont-disable-interrupts-when-using-spin-locks
+++ a/drivers/pps/kapi.c
@@ -162,7 +162,6 @@ EXPORT_SYMBOL(pps_unregister_source);
 void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 		void *data)
 {
-	unsigned long flags;
 	int captured = 0;
 	struct pps_ktime ts_real;
 
@@ -176,7 +175,7 @@ void pps_event(struct pps_device *pps, s
 
 	timespec_to_pps_ktime(&ts_real, ts->ts_real);
 
-	spin_lock_irqsave(&pps->lock, flags);
+	spin_lock(&pps->lock);
 
 	/* Must call the echo function? */
 	if ((pps->params.mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)))
@@ -223,6 +222,6 @@ void pps_event(struct pps_device *pps, s
 		kill_fasync(&pps->async_queue, SIGIO, POLL_IN);
 	}
 
-	spin_unlock_irqrestore(&pps->lock, flags);
+	spin_unlock(&pps->lock);
 }
 EXPORT_SYMBOL(pps_event);
diff -puN drivers/pps/pps.c~pps-dont-disable-interrupts-when-using-spin-locks drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-dont-disable-interrupts-when-using-spin-locks
+++ a/drivers/pps/pps.c
@@ -74,12 +74,12 @@ static long pps_cdev_ioctl(struct file *
 	case PPS_GETPARAMS:
 		dev_dbg(pps->dev, "PPS_GETPARAMS\n");
 
-		spin_lock_irq(&pps->lock);
+		spin_lock(&pps->lock);
 
 		/* Get the current parameters */
 		params = pps->params;
 
-		spin_unlock_irq(&pps->lock);
+		spin_unlock(&pps->lock);
 
 		err = copy_to_user(uarg, &params, sizeof(struct pps_kparams));
 		if (err)
@@ -110,7 +110,7 @@ static long pps_cdev_ioctl(struct file *
 			return -EINVAL;
 		}
 
-		spin_lock_irq(&pps->lock);
+		spin_lock(&pps->lock);
 
 		/* Save the new parameters */
 		pps->params = params;
@@ -126,7 +126,7 @@ static long pps_cdev_ioctl(struct file *
 			pps->params.mode |= PPS_CANWAIT;
 		pps->params.api_version = PPS_API_VERS;
 
-		spin_unlock_irq(&pps->lock);
+		spin_unlock(&pps->lock);
 
 		break;
 
@@ -181,7 +181,7 @@ static long pps_cdev_ioctl(struct file *
 		}
 
 		/* Return the fetched timestamp */
-		spin_lock_irq(&pps->lock);
+		spin_lock(&pps->lock);
 
 		fdata.info.assert_sequence = pps->assert_sequence;
 		fdata.info.clear_sequence = pps->clear_sequence;
@@ -189,7 +189,7 @@ static long pps_cdev_ioctl(struct file *
 		fdata.info.clear_tu = pps->clear_tu;
 		fdata.info.current_mode = pps->current_mode;
 
-		spin_unlock_irq(&pps->lock);
+		spin_unlock(&pps->lock);
 
 		err = copy_to_user(uarg, &fdata, sizeof(struct pps_fdata));
 		if (err)
@@ -239,9 +239,9 @@ static void pps_device_destruct(struct d
 
 	/* release id here to protect others from using it while it's
 	 * still in use */
-	spin_lock_irq(&pps_idr_lock);
+	spin_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	spin_unlock(&pps_idr_lock);
 
 	kfree(dev);
 	kfree(pps);
@@ -260,9 +260,9 @@ int pps_register_cdev(struct pps_device 
 	 * After idr_get_new() calling the new source will be freely available
 	 * into the kernel.
 	 */
-	spin_lock_irq(&pps_idr_lock);
+	spin_lock(&pps_idr_lock);
 	err = idr_get_new(&pps_idr, pps, &pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	spin_unlock(&pps_idr_lock);
 
 	if (err < 0)
 		return err;
@@ -302,9 +302,9 @@ del_cdev:
 	cdev_del(&pps->cdev);
 
 free_idr:
-	spin_lock_irq(&pps_idr_lock);
+	spin_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	spin_unlock(&pps_idr_lock);
 
 	return err;
 }
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

