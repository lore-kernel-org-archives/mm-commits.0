From: akpm@linux-foundation.org
Subject: + pps-dont-disable-interrupts-when-using-spin-locks.patch added to -mm tree
Date: Wed, 04 Aug 2010 16:38:31 -0700
Message-ID: <201008042338.o74NcVr8017011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752620Ab0HEABl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Aug 2010 20:01:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@enneenne.com, johnstul@us.ibm.com, joonwpark81@gmail.com, tj@kernel.org, yoush@cs.msu.su


The patch titled
     pps: don't disable interrupts when using spin locks
has been added to the -mm tree.  Its filename is
     pps-dont-disable-interrupts-when-using-spin-locks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: don't disable interrupts when using spin locks
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Now all PPS spin locks are never used in interrupt context so we can
safely replace spin_lock_irq*/spin_unlock_irq* with plain
spin_lock/spin_unlock.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: Rodolfo Giometti <giometti@enneenne.com>
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
@@ -172,7 +172,6 @@ EXPORT_SYMBOL(pps_unregister_source);
 void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 		void *data)
 {
-	unsigned long flags;
 	int captured = 0;
 	struct pps_ktime ts_real;
 
@@ -186,7 +185,7 @@ void pps_event(struct pps_device *pps, s
 
 	timespec_to_pps_ktime(&ts_real, ts->ts_real);
 
-	spin_lock_irqsave(&pps->lock, flags);
+	spin_lock(&pps->lock);
 
 	/* Must call the echo function? */
 	if ((pps->params.mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)))
@@ -233,7 +232,7 @@ void pps_event(struct pps_device *pps, s
 		kill_fasync(&pps->async_queue, SIGIO, POLL_IN);
 	}
 
-	spin_unlock_irqrestore(&pps->lock, flags);
+	spin_unlock(&pps->lock);
 }
 EXPORT_SYMBOL(pps_event);
 
diff -puN drivers/pps/pps.c~pps-dont-disable-interrupts-when-using-spin-locks drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-dont-disable-interrupts-when-using-spin-locks
+++ a/drivers/pps/pps.c
@@ -73,12 +73,12 @@ static long pps_cdev_ioctl(struct file *
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
@@ -109,7 +109,7 @@ static long pps_cdev_ioctl(struct file *
 			return -EINVAL;
 		}
 
-		spin_lock_irq(&pps->lock);
+		spin_lock(&pps->lock);
 
 		/* Save the new parameters */
 		pps->params = params;
@@ -125,7 +125,7 @@ static long pps_cdev_ioctl(struct file *
 			pps->params.mode |= PPS_CANWAIT;
 		pps->params.api_version = PPS_API_VERS;
 
-		spin_unlock_irq(&pps->lock);
+		spin_unlock(&pps->lock);
 
 		break;
 
@@ -180,7 +180,7 @@ static long pps_cdev_ioctl(struct file *
 		}
 
 		/* Return the fetched timestamp */
-		spin_lock_irq(&pps->lock);
+		spin_lock(&pps->lock);
 
 		fdata.info.assert_sequence = pps->assert_sequence;
 		fdata.info.clear_sequence = pps->clear_sequence;
@@ -188,7 +188,7 @@ static long pps_cdev_ioctl(struct file *
 		fdata.info.clear_tu = pps->clear_tu;
 		fdata.info.current_mode = pps->current_mode;
 
-		spin_unlock_irq(&pps->lock);
+		spin_unlock(&pps->lock);
 
 		err = copy_to_user(uarg, &fdata, sizeof(struct pps_fdata));
 		if (err)
@@ -238,9 +238,9 @@ static void pps_device_destruct(struct d
 
 	/* release id here to protect others from using it while it's
 	 * still in use */
-	spin_lock_irq(&pps_idr_lock);
+	spin_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	spin_unlock(&pps_idr_lock);
 
 	kfree(dev);
 }
@@ -258,9 +258,9 @@ int pps_register_cdev(struct pps_device 
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
@@ -300,9 +300,9 @@ del_cdev:
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

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-add-async-pps-event-handler.patch
pps-dont-disable-interrupts-when-using-spin-locks.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

