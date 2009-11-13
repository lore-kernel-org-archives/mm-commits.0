From: akpm@linux-foundation.org
Subject: [merged] pps-locking-scheme-fix-up-for-pps_getparams.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:27:25 -0800
Message-ID: <200911131927.nADJRPjt030631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757186AbZKMT16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, clemens@dwf.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pps: locking scheme fix up for PPS_GETPARAMS
has been removed from the -mm tree.  Its filename was
     pps-locking-scheme-fix-up-for-pps_getparams.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: locking scheme fix up for PPS_GETPARAMS
From: Rodolfo Giometti <giometti@linux.it>

Userland programs may read/write PPS parameters at same time and these
operations may corrupt PPS data.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Tested-by: Reg Clemens <clemens@dwf.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pps/pps.c~pps-locking-scheme-fix-up-for-pps_getparams drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-locking-scheme-fix-up-for-pps_getparams
+++ a/drivers/pps/pps.c
@@ -71,9 +71,14 @@ static long pps_cdev_ioctl(struct file *
 	case PPS_GETPARAMS:
 		pr_debug("PPS_GETPARAMS: source %d\n", pps->id);
 
-		/* Return current parameters */
-		err = copy_to_user(uarg, &pps->params,
-						sizeof(struct pps_kparams));
+		spin_lock_irq(&pps->lock);
+
+		/* Get the current parameters */
+		params = pps->params;
+
+		spin_unlock_irq(&pps->lock);
+
+		err = copy_to_user(uarg, &params, sizeof(struct pps_kparams));
 		if (err)
 			return -EFAULT;
 
_

Patches currently in -mm which might be from giometti@linux.it are

linux-next.patch

