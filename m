From: akpm@linux-foundation.org
Subject: + char-vt_ioctl-fix-bkl-imbalance.patch added to -mm tree
Date: Wed, 30 Sep 2009 12:58:07 -0700
Message-ID: <200909301958.n8UJw7La024829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697AbZI3T6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 15:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@linux.intel.com, greg@kroah.com


The patch titled
     Char: vt_ioctl, fix BKL imbalance
has been added to the -mm tree.  Its filename is
     char-vt_ioctl-fix-bkl-imbalance.patch

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

char-vt_ioctl-fix-bkl-imbalance.patch
linux-next.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
qla2xxx-fix-null-ptr-dereference-in-fail-path-in-queue-create-code.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch
char-mxser-remove-unnecessary-tty-test.patch

