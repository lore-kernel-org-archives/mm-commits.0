From: akpm@linux-foundation.org
Subject: [merged] pps-declare-variables-where-they-are-used-in-switch.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:18 -0800
Message-ID: <201101132011.p0DKBxOi030219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933742Ab1AMUUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     pps: declare variables where they are used in switch
has been removed from the -mm tree.  Its filename was
     pps-declare-variables-where-they-are-used-in-switch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: declare variables where they are used in switch
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Move variable declarations where they are used in pps_cdev_ioctl.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/pps.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/pps/pps.c~pps-declare-variables-where-they-are-used-in-switch drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-declare-variables-where-they-are-used-in-switch
+++ a/drivers/pps/pps.c
@@ -61,8 +61,6 @@ static long pps_cdev_ioctl(struct file *
 {
 	struct pps_device *pps = file->private_data;
 	struct pps_kparams params;
-	struct pps_fdata fdata;
-	unsigned long ticks;
 	void __user *uarg = (void __user *) arg;
 	int __user *iuarg = (int __user *) arg;
 	int err;
@@ -136,7 +134,9 @@ static long pps_cdev_ioctl(struct file *
 
 		break;
 
-	case PPS_FETCH:
+	case PPS_FETCH: {
+		struct pps_fdata fdata;
+
 		pr_debug("PPS_FETCH: source %d\n", pps->id);
 
 		err = copy_from_user(&fdata, uarg, sizeof(struct pps_fdata));
@@ -149,6 +149,8 @@ static long pps_cdev_ioctl(struct file *
 		if (fdata.timeout.flags & PPS_TIME_INVALID)
 			err = wait_event_interruptible(pps->queue, pps->go);
 		else {
+			unsigned long ticks;
+
 			pr_debug("timeout %lld.%09d\n",
 					(long long) fdata.timeout.sec,
 					fdata.timeout.nsec);
@@ -185,7 +187,7 @@ static long pps_cdev_ioctl(struct file *
 			return -EFAULT;
 
 		break;
