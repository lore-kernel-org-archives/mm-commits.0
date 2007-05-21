From: akpm@linux-foundation.org
Subject: + misc-misc-phantom-move-to-unlocked_ioctl-fix.patch added to -mm tree
Date: Sun, 20 May 2007 20:28:31 -0700
Message-ID: <200705210328.l4L3SUnV001525@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854AbXEUD3n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 23:29:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     misc-phantom-move-to-unlocked_ioctl-fix
has been added to the -mm tree.  Its filename is
     misc-misc-phantom-move-to-unlocked_ioctl-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: misc-phantom-move-to-unlocked_ioctl-fix
From: Jiri Slaby <jirislaby@gmail.com>

misc-phantom-move-to-unlocked_ioctl-fix

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/phantom.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/misc/phantom.c~misc-misc-phantom-move-to-unlocked_ioctl-fix drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~misc-misc-phantom-move-to-unlocked_ioctl-fix
+++ a/drivers/misc/phantom.c
@@ -125,9 +125,7 @@ static long phantom_ioctl(struct file *f
 		if (r.reg > 7)
 			return -EINVAL;
 
-		spin_lock(&dev->ioctl_lock);
 		r.value = ioread32(dev->iaddr + r.reg);
-		spin_unlock(&dev->ioctl_lock);
 
 		if (copy_to_user(argp, &r, sizeof(r)))
 			return -EFAULT;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
char-cyclades-fix-deadlock.patch
misc-phantom-move-to-unlocked_ioctl.patch
misc-misc-phantom-move-to-unlocked_ioctl-fix.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
shrink_slab-handle-bad-shrinkers.patch
