From: akpm@linux-foundation.org
Subject: - misc-misc-phantom-move-to-unlocked_ioctl-fix.patch removed from -mm tree
Date: Wed, 23 May 2007 13:43:59 -0700
Message-ID: <200705232043.l4NKhx3l031414@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754268AbXEWUoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 16:44:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     misc-phantom-move-to-unlocked_ioctl-fix
has been removed from the -mm tree.  Its filename was
     misc-misc-phantom-move-to-unlocked_ioctl-fix.patch

This patch was dropped because it was folded into misc-phantom-move-to-unlocked_ioctl.patch

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

origin.patch
char-cyclades-fix-deadlock.patch
misc-phantom-move-to-unlocked_ioctl.patch
misc-misc-phantom-move-to-unlocked_ioctl-fix.patch
misc-phantom-take-care-of-pci-posting.patch
cinergyt2-fix-file-release-handler.patch
rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
shrink_slab-handle-bad-shrinkers.patch
