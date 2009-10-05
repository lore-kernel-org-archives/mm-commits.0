From: akpm@linux-foundation.org
Subject: [merged] char-vt_ioctl-fix-bkl-imbalance.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:38:08 -0700
Message-ID: <200910051838.n95Ic8BE016302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570AbZJESjS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:39:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@linux.intel.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Char: vt_ioctl, fix BKL imbalance
has been removed from the -mm tree.  Its filename was
     char-vt_ioctl-fix-bkl-imbalance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: vt_ioctl, fix BKL imbalance
From: Jiri Slaby <jirislaby@gmail.com>

Stanse found (again) a BKL imbalance in vt_ioctl.

It's easily triggerable by ioctl(dev_tty_fd, VT_SETACTIVATE, NULL);

Introduced by

commit d3b5cffcf84a8bdc7073dce4745d67c72629af85                                 Author: Alan Cox <alan@linux.intel.com>
Date:   Sat Sep 19 13:13:26 2009 -0700

    vt: add an activate and lock

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt_ioctl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/char/vt_ioctl.c~char-vt_ioctl-fix-bkl-imbalance drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~char-vt_ioctl-fix-bkl-imbalance
+++ a/drivers/char/vt_ioctl.c
@@ -981,8 +981,10 @@ int vt_ioctl(struct tty_struct *tty, str
 			goto eperm;
 
 		if (copy_from_user(&vsa, (struct vt_setactivate __user *)arg,
-						sizeof(struct vt_setactivate)))
-			return -EFAULT;
+					sizeof(struct vt_setactivate))) {
+			ret = -EFAULT;
+			goto out;
+		}
 		if (vsa.console == 0 || vsa.console > MAX_NR_CONSOLES)
 			ret = -ENXIO;
 		else {
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
char-mxser-remove-unnecessary-tty-test.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

