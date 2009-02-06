From: akpm@linux-foundation.org
Subject: [merged] sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:38:22 -0800
Message-ID: <200902061938.n16JcMRd012315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754610AbZBFTi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:38:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, R.E.Wolff@BitWizard.nl, mm-commits@vger.kernel.org


The patch titled
     sx.c: fix missed unlock_kernel() on error path in sx_fw_ioctl()
has been removed from the -mm tree.  Its filename was
     sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sx.c: fix missed unlock_kernel() on error path in sx_fw_ioctl()
From: Dan Carpenter <error27@gmail.com>

If we return directly with -EPERM then lock_kernel() is still held.

This was found with a code checker (http://repo.or.cz/w/smatch.git/).

[akpm@linux-foundation.org: fix another such path - missed func_exit()]
Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: <R.E.Wolff@BitWizard.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sx.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/char/sx.c~sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl drivers/char/sx.c
--- a/drivers/char/sx.c~sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl
+++ a/drivers/char/sx.c
@@ -1713,8 +1713,8 @@ static long sx_fw_ioctl(struct file *fil
 		for (i = 0; i < SX_NBOARDS; i++)
 			sx_dprintk(SX_DEBUG_FIRMWARE, "<%x> ", boards[i].flags);
 		sx_dprintk(SX_DEBUG_FIRMWARE, "\n");
-		unlock_kernel();
-		return -EIO;
+		rc = -EIO;
+		goto out;
 	}
 
 	switch (cmd) {
@@ -1747,7 +1747,8 @@ static long sx_fw_ioctl(struct file *fil
 		break;
 	case SXIO_DO_RAMTEST:
 		if (sx_initialized)	/* Already initialized: better not ramtest the board.  */
-			return -EPERM;
+			rc = -EPERM;
+			break;
 		if (IS_SX_BOARD(board)) {
 			rc = do_memtest(board, 0, 0x7000);
 			if (!rc)
@@ -1844,6 +1845,7 @@ static long sx_fw_ioctl(struct file *fil
 		rc = -ENOTTY;
 		break;
 	}
+out:
 	unlock_kernel();
 	func_exit();
 	return rc;
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch

