From: akpm@linux-foundation.org
Subject: + pps-convert-printk-pr_-to-dev_.patch added to -mm tree
Date: Wed, 04 Aug 2010 16:38:25 -0700
Message-ID: <201008042338.o74NcPY5017002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752620Ab0HEACm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Aug 2010 20:02:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@enneenne.com, johnstul@us.ibm.com, joonwpark81@gmail.com, tj@kernel.org, yoush@cs.msu.su


The patch titled
     pps: convert printk/pr_* to dev_*
has been added to the -mm tree.  Its filename is
     pps-convert-printk-pr_-to-dev_.patch

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
Subject: pps: convert printk/pr_* to dev_*
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Since we now have direct pointers to struct pps_device everywhere it's
easy to use dev_* functions to print messages instead of plain printks. 
Where dev_* cannot be used printks are converted to pr_*.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-ktimer.c |    4 ++--
 drivers/pps/kapi.c               |   14 +++++++-------
 drivers/pps/pps.c                |   24 ++++++++++++------------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff -puN drivers/pps/clients/pps-ktimer.c~pps-convert-printk-pr_-to-dev_ drivers/pps/clients/pps-ktimer.c
--- a/drivers/pps/clients/pps-ktimer.c~pps-convert-printk-pr_-to-dev_
+++ a/drivers/pps/clients/pps-ktimer.c
@@ -45,7 +45,7 @@ static void pps_ktimer_event(unsigned lo
 	/* First of all we get the time stamp... */
 	pps_get_ts(&ts);
 
-	pr_info("PPS event at %lu\n", jiffies);
+	dev_info(pps->dev, "PPS event at %lu\n", jiffies);
 
 	pps_event(pps, &ts, PPS_CAPTUREASSERT, NULL);
 
@@ -94,7 +94,7 @@ static int __init pps_ktimer_init(void)
 	pps = pps_register_source(&pps_ktimer_info,
 				PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
 	if (pps == NULL) {
-		printk(KERN_ERR "cannot register ktimer source\n");
+		pr_err("cannot register ktimer source\n");
 		return -ENOMEM;
 	}
 
diff -puN drivers/pps/kapi.c~pps-convert-printk-pr_-to-dev_ drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-convert-printk-pr_-to-dev_
+++ a/drivers/pps/kapi.c
@@ -80,20 +80,20 @@ struct pps_device *pps_register_source(s
 
 	/* Sanity checks */
 	if ((info->mode & default_params) != default_params) {
-		printk(KERN_ERR "pps: %s: unsupported default parameters\n",
+		pr_err("pps: %s: unsupported default parameters\n",
 					info->name);
 		err = -EINVAL;
 		goto pps_register_source_exit;
 	}
 	if ((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) != 0 &&
 			info->echo == NULL) {
-		printk(KERN_ERR "pps: %s: echo function is not defined\n",
+		pr_err("pps: %s: echo function is not defined\n",
 					info->name);
 		err = -EINVAL;
 		goto pps_register_source_exit;
 	}
 	if ((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
-		printk(KERN_ERR "pps: %s: unspecified time format\n",
+		pr_err("pps: %s: unspecified time format\n",
 					info->name);
 		err = -EINVAL;
 		goto pps_register_source_exit;
@@ -138,7 +138,7 @@ struct pps_device *pps_register_source(s
 	if (id >= PPS_MAX_SOURCES) {
 		spin_unlock_irq(&pps_idr_lock);
 
-		printk(KERN_ERR "pps: %s: too many PPS sources in the system\n",
+		pr_err("pps: %s: too many PPS sources in the system\n",
 					info->name);
 		err = -EBUSY;
 		goto free_idr;
@@ -150,12 +150,12 @@ struct pps_device *pps_register_source(s
 	/* Create the char device */
 	err = pps_register_cdev(pps);
 	if (err < 0) {
-		printk(KERN_ERR "pps: %s: unable to create char device\n",
+		pr_err("pps: %s: unable to create char device\n",
 					info->name);
 		goto free_idr;
 	}
 
-	pr_info("new PPS source %s at ID %d\n", info->name, id);
+	dev_info(pps->dev, "new PPS source %s\n", info->name);
 
 	return pps;
 
@@ -168,7 +168,7 @@ kfree_pps:
 	kfree(pps);
 
 pps_register_source_exit:
-	printk(KERN_ERR "pps: %s: unable to register source\n", info->name);
+	pr_err("pps: %s: unable to register source\n", info->name);
 
 	return NULL;
 }
diff -puN drivers/pps/pps.c~pps-convert-printk-pr_-to-dev_ drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-convert-printk-pr_-to-dev_
+++ a/drivers/pps/pps.c
@@ -67,7 +67,7 @@ static long pps_cdev_ioctl(struct file *
 
 	switch (cmd) {
 	case PPS_GETPARAMS:
-		pr_debug("PPS_GETPARAMS: source %d\n", pps->id);
+		dev_dbg(pps->dev, "PPS_GETPARAMS\n");
 
 		spin_lock_irq(&pps->lock);
 
@@ -83,7 +83,7 @@ static long pps_cdev_ioctl(struct file *
 		break;
 
 	case PPS_SETPARAMS:
-		pr_debug("PPS_SETPARAMS: source %d\n", pps->id);
+		dev_dbg(pps->dev, "PPS_SETPARAMS\n");
 
 		/* Check the capabilities */
 		if (!capable(CAP_SYS_TIME))
@@ -93,14 +93,14 @@ static long pps_cdev_ioctl(struct file *
 		if (err)
 			return -EFAULT;
 		if (!(params.mode & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR))) {
-			pr_debug("capture mode unspecified (%x)\n",
+			dev_dbg(pps->dev, "capture mode unspecified (%x)\n",
 								params.mode);
 			return -EINVAL;
 		}
 
 		/* Check for supported capabilities */
 		if ((params.mode & ~pps->info.mode) != 0) {
-			pr_debug("unsupported capabilities (%x)\n",
+			dev_dbg(pps->dev, "unsupported capabilities (%x)\n",
 								params.mode);
 			return -EINVAL;
 		}
@@ -113,7 +113,7 @@ static long pps_cdev_ioctl(struct file *
 		/* Restore the read only parameters */
 		if ((params.mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
 			/* section 3.3 of RFC 2783 interpreted */
-			pr_debug("time format unspecified (%x)\n",
+			dev_dbg(pps->dev, "time format unspecified (%x)\n",
 								params.mode);
 			pps->params.mode |= PPS_TSFMT_TSPEC;
 		}
@@ -126,7 +126,7 @@ static long pps_cdev_ioctl(struct file *
 		break;
 
 	case PPS_GETCAP:
-		pr_debug("PPS_GETCAP: source %d\n", pps->id);
+		dev_dbg(pps->dev, "PPS_GETCAP\n");
 
 		err = put_user(pps->info.mode, iuarg);
 		if (err)
@@ -138,7 +138,7 @@ static long pps_cdev_ioctl(struct file *
 		struct pps_fdata fdata;
 		unsigned int ev;
 
-		pr_debug("PPS_FETCH: source %d\n", pps->id);
+		dev_dbg(pps->dev, "PPS_FETCH\n");
 
 		err = copy_from_user(&fdata, uarg, sizeof(struct pps_fdata));
 		if (err)
@@ -153,7 +153,7 @@ static long pps_cdev_ioctl(struct file *
 		else {
 			unsigned long ticks;
 
-			pr_debug("timeout %lld.%09d\n",
+			dev_dbg(pps->dev, "timeout %lld.%09d\n",
 					(long long) fdata.timeout.sec,
 					fdata.timeout.nsec);
 			ticks = fdata.timeout.sec * HZ;
@@ -171,7 +171,7 @@ static long pps_cdev_ioctl(struct file *
 
 		/* Check for pending signals */
 		if (err == -ERESTARTSYS) {
-			pr_debug("pending signal caught\n");
+			dev_dbg(pps->dev, "pending signal caught\n");
 			return -EINTR;
 		}
 
@@ -240,7 +240,7 @@ int pps_register_cdev(struct pps_device 
 
 	err = cdev_add(&pps->cdev, devt, 1);
 	if (err) {
-		printk(KERN_ERR "pps: %s: failed to add char device %d:%d\n",
+		pr_err("pps: %s: failed to add char device %d:%d\n",
 				pps->info.name, MAJOR(pps_devt), pps->id);
 		return err;
 	}
@@ -282,14 +282,14 @@ static int __init pps_init(void)
 
 	pps_class = class_create(THIS_MODULE, "pps");
 	if (!pps_class) {
-		printk(KERN_ERR "pps: failed to allocate class\n");
+		pr_err("pps: failed to allocate class\n");
 		return -ENOMEM;
 	}
 	pps_class->dev_attrs = pps_attrs;
 
 	err = alloc_chrdev_region(&pps_devt, 0, PPS_MAX_SOURCES, "pps");
 	if (err < 0) {
-		printk(KERN_ERR "pps: failed to allocate char device region\n");
+		pr_err("pps: failed to allocate char device region\n");
 		goto remove_class;
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

