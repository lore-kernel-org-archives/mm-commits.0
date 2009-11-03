From: akpm@linux-foundation.org
Subject: + pps-locking-scheme-fix-up-for-pps_getparams.patch added to -mm tree
Date: Mon, 02 Nov 2009 17:54:46 -0800
Message-ID: <200911030154.nA31skZF014178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755830AbZKCBzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 20:55:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it, clemens@dwf.com, stable@kernel.org


The patch titled
     pps: locking scheme fix up for PPS_GETPARAMS
has been added to the -mm tree.  Its filename is
     pps-locking-scheme-fix-up-for-pps_getparams.patch

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
Subject: pps: locking scheme fix up for PPS_GETPARAMS
From: Rodolfo Giometti <giometti@linux.it>

-ENOCHANGELOG

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
pps-locking-scheme-fix-up-for-pps_getparams.patch

