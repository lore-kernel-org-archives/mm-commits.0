From: akpm@linux-foundation.org
Subject: + pps-declare-variables-where-they-are-used-in-switch.patch added to -mm tree
Date: Fri, 17 Dec 2010 16:19:50 -0800
Message-ID: <201012180019.oBI0JoF2004855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948Ab0LRAT5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Dec 2010 19:19:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@linux.it


The patch titled
     pps: declare variables where they are used in switch
has been added to the -mm tree.  Its filename is
     pps-declare-variables-where-they-are-used-in-switch.patch

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
-
+	}
 	default:
 		return -ENOTTY;
 		break;
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-do-not-disable-interrupts-for-idr-operations.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
pps-timestamp-is-always-passed-to-dcd_change.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

