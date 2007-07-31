From: akpm@linux-foundation.org
Subject: - videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch removed from -mm tree
Date: Tue, 31 Jul 2007 13:23:27 -0700
Message-ID: <200707312023.l6VKNR2m020519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54648 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760140AbXGaUYF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 16:24:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Videopix Frame Grabber: Fix unreleased lock in vfc_debug()
has been removed from the -mm tree.  Its filename was
     videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Videopix Frame Grabber: Fix unreleased lock in vfc_debug()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Videopix Frame Grabber: vfc_debug() doesn't release the device lock
when copy_from_user() fails

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sbus/char/vfc_dev.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/sbus/char/vfc_dev.c~videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug drivers/sbus/char/vfc_dev.c
--- a/drivers/sbus/char/vfc_dev.c~videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug
+++ a/drivers/sbus/char/vfc_dev.c
@@ -248,6 +248,7 @@ static int vfc_debug(struct vfc_dev *dev
 					buffer,inout.len);
 
 		if (copy_to_user(argp,&inout,sizeof(inout))) {
+			vfc_unlock_device(dev);
 			kfree(buffer);
 			return -EFAULT;
 		}
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-dvb.patch
git-mtd.patch
git-scsi-misc.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
git-sparc64.patch
use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch
use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
