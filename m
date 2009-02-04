From: akpm@linux-foundation.org
Subject: + sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl.patch added to -mm tree
Date: Tue, 03 Feb 2009 20:59:32 -0800
Message-ID: <200902040459.n144xWJj013028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbZBDFFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2009 00:05:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, R.E.Wolff@BitWizard.nl


The patch titled
     sx.c: fix missed unlock_kernel() on error path in sx_fw_ioctl()
has been added to the -mm tree.  Its filename is
     sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl.patch

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
Subject: sx.c: fix missed unlock_kernel() on error path in sx_fw_ioctl()
From: Dan Carpenter <error27@gmail.com>

If we return directly with -EPERM then lock_kernel() is still held.

This was found with a code checker (http://repo.or.cz/w/smatch.git/).

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: <R.E.Wolff@BitWizard.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/sx.c~sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl drivers/char/sx.c
--- a/drivers/char/sx.c~sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl
+++ a/drivers/char/sx.c
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
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl.patch
sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl-fix.patch
linux-next.patch

