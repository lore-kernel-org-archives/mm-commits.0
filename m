From: akpm@linux-foundation.org
Subject: [merged] pps-convert-printk-pr_-to-dev_.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:22 -0800
Message-ID: <201101132012.p0DKC3Oe030240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933765Ab1AMUUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     pps: convert printk/pr_* to dev_*
has been removed from the -mm tree.  Its filename was
     pps-convert-printk-pr_-to-dev_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: convert printk/pr_* to dev_*
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Since we now have direct pointers to struct pps_device everywhere it's
easy to use dev_* functions to print messages instead of plain printks. 
Where dev_* cannot be used printks are converted to pr_*.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-ktimer.c |    5 +++--
 drivers/pps/clients/pps-ldisc.c  |    2 ++
 drivers/pps/kapi.c               |   15 ++++++++-------
 drivers/pps/pps.c                |   25 +++++++++++++------------
 4 files changed, 26 insertions(+), 21 deletions(-)

diff -puN drivers/pps/clients/pps-ktimer.c~pps-convert-printk-pr_-to-dev_ drivers/pps/clients/pps-ktimer.c
--- a/drivers/pps/clients/pps-ktimer.c~pps-convert-printk-pr_-to-dev_
+++ a/drivers/pps/clients/pps-ktimer.c
@@ -19,6 +19,7 @@
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -45,7 +46,7 @@ static void pps_ktimer_event(unsigned lo
 	/* First of all we get the time stamp... */
 	pps_get_ts(&ts);
 
-	pr_info("PPS event at %lu\n", jiffies);
+	dev_info(pps->dev, "PPS event at %lu\n", jiffies);
 
 	pps_event(pps, &ts, PPS_CAPTUREASSERT, NULL);
 
@@ -94,7 +95,7 @@ static int __init pps_ktimer_init(void)
 	pps = pps_register_source(&pps_ktimer_info,
 				PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
 	if (pps == NULL) {
-		printk(KERN_ERR "cannot register ktimer source\n");
+		pr_err("cannot register PPS source\n");
 		return -ENOMEM;
 	}
 
diff -puN drivers/pps/clients/pps-ldisc.c~pps-convert-printk-pr_-to-dev_ drivers/pps/clients/pps-ldisc.c
--- a/drivers/pps/clients/pps-ldisc.c~pps-convert-printk-pr_-to-dev_
+++ a/drivers/pps/clients/pps-ldisc.c
@@ -19,6 +19,8 @@
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/serial_core.h>
 #include <linux/tty.h>
diff -puN drivers/pps/kapi.c~pps-convert-printk-pr_-to-dev_ drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-convert-printk-pr_-to-dev_
+++ a/drivers/pps/kapi.c
@@ -19,6 +19,7 @@
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -80,20 +81,20 @@ struct pps_device *pps_register_source(s
 
 	/* Sanity checks */
 	if ((info->mode & default_params) != default_params) {
-		printk(KERN_ERR "pps: %s: unsupported default parameters\n",
+		pr_err("%s: unsupported default parameters\n",
 					info->name);
 		err = -EINVAL;
 		goto pps_register_source_exit;
 	}
 	if ((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) != 0 &&
 			info->echo == NULL) {
-		printk(KERN_ERR "pps: %s: echo function is not defined\n",
+		pr_err("%s: echo function is not defined\n",
 					info->name);
 		err = -EINVAL;
 		goto pps_register_source_exit;
 	}
 	if ((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
-		printk(KERN_ERR "pps: %s: unspecified time format\n",
+		pr_err("%s: unspecified time format\n",
 					info->name);
 		err = -EINVAL;
 		goto pps_register_source_exit;
@@ -138,7 +139,7 @@ struct pps_device *pps_register_source(s
 	if (id >= PPS_MAX_SOURCES) {
 		spin_unlock_irq(&pps_idr_lock);
 
-		printk(KERN_ERR "pps: %s: too many PPS sources in the system\n",
+		pr_err("%s: too many PPS sources in the system\n",
 					info->name);
 		err = -EBUSY;
 		goto free_idr;
@@ -150,12 +151,12 @@ struct pps_device *pps_register_source(s
 	/* Create the char device */
 	err = pps_register_cdev(pps);
 	if (err < 0) {
-		printk(KERN_ERR "pps: %s: unable to create char device\n",
+		pr_err("%s: unable to create char device\n",
 					info->name);
 		goto free_idr;
 	}
 
-	pr_info("new PPS source %s at ID %d\n", info->name, id);
+	dev_info(pps->dev, "new PPS source %s\n", info->name);
 
 	return pps;
 
@@ -168,7 +169,7 @@ kfree_pps:
 	kfree(pps);
 
 pps_register_source_exit:
-	printk(KERN_ERR "pps: %s: unable to register source\n", info->name);
+	pr_err("%s: unable to register source\n", info->name);
 
 	return NULL;
 }
diff -puN drivers/pps/pps.c~pps-convert-printk-pr_-to-dev_ drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-convert-printk-pr_-to-dev_
+++ a/drivers/pps/pps.c
@@ -19,6 +19,7 @@
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -67,7 +68,7 @@ static long pps_cdev_ioctl(struct file *
 
 	switch (cmd) {
 	case PPS_GETPARAMS:
-		pr_debug("PPS_GETPARAMS: source %d\n", pps->id);
+		dev_dbg(pps->dev, "PPS_GETPARAMS\n");
 
 		spin_lock_irq(&pps->lock);
 
@@ -83,7 +84,7 @@ static long pps_cdev_ioctl(struct file *
 		break;
 
 	case PPS_SETPARAMS:
-		pr_debug("PPS_SETPARAMS: source %d\n", pps->id);
+		dev_dbg(pps->dev, "PPS_SETPARAMS\n");
 
 		/* Check the capabilities */
 		if (!capable(CAP_SYS_TIME))
@@ -93,14 +94,14 @@ static long pps_cdev_ioctl(struct file *
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
@@ -113,7 +114,7 @@ static long pps_cdev_ioctl(struct file *
 		/* Restore the read only parameters */
 		if ((params.mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
 			/* section 3.3 of RFC 2783 interpreted */
-			pr_debug("time format unspecified (%x)\n",
+			dev_dbg(pps->dev, "time format unspecified (%x)\n",
 								params.mode);
 			pps->params.mode |= PPS_TSFMT_TSPEC;
 		}
@@ -126,7 +127,7 @@ static long pps_cdev_ioctl(struct file *
 		break;
 
 	case PPS_GETCAP:
-		pr_debug("PPS_GETCAP: source %d\n", pps->id);
+		dev_dbg(pps->dev, "PPS_GETCAP\n");
 
 		err = put_user(pps->info.mode, iuarg);
 		if (err)
@@ -138,7 +139,7 @@ static long pps_cdev_ioctl(struct file *
 		struct pps_fdata fdata;
 		unsigned int ev;
 
-		pr_debug("PPS_FETCH: source %d\n", pps->id);
+		dev_dbg(pps->dev, "PPS_FETCH\n");
 
 		err = copy_from_user(&fdata, uarg, sizeof(struct pps_fdata));
 		if (err)
@@ -153,7 +154,7 @@ static long pps_cdev_ioctl(struct file *
 		else {
 			unsigned long ticks;
 
-			pr_debug("timeout %lld.%09d\n",
+			dev_dbg(pps->dev, "timeout %lld.%09d\n",
 					(long long) fdata.timeout.sec,
 					fdata.timeout.nsec);
 			ticks = fdata.timeout.sec * HZ;
@@ -171,7 +172,7 @@ static long pps_cdev_ioctl(struct file *
 
 		/* Check for pending signals */
 		if (err == -ERESTARTSYS) {
-			pr_debug("pending signal caught\n");
+			dev_dbg(pps->dev, "pending signal caught\n");
 			return -EINTR;
 		}
 
@@ -240,7 +241,7 @@ int pps_register_cdev(struct pps_device 
 
 	err = cdev_add(&pps->cdev, devt, 1);
 	if (err) {
-		printk(KERN_ERR "pps: %s: failed to add char device %d:%d\n",
+		pr_err("%s: failed to add char device %d:%d\n",
 				pps->info.name, MAJOR(pps_devt), pps->id);
 		return err;
 	}
@@ -282,14 +283,14 @@ static int __init pps_init(void)
 
 	pps_class = class_create(THIS_MODULE, "pps");
 	if (!pps_class) {
-		printk(KERN_ERR "pps: failed to allocate class\n");
+		pr_err("failed to allocate class\n");
 		return -ENOMEM;
 	}
 	pps_class->dev_attrs = pps_attrs;
 
 	err = alloc_chrdev_region(&pps_devt, 0, PPS_MAX_SOURCES, "pps");
 	if (err < 0) {
-		printk(KERN_ERR "pps: failed to allocate char device region\n");
+		pr_err("failed to allocate char device region\n");
 		goto remove_class;
 	}
 
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

origin.patch

