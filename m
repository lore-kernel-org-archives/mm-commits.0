From: akpm@linux-foundation.org
Subject: + videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch added to -mm tree
Date: Tue, 03 Jul 2007 13:56:43 -0700
Message-ID: <200707032056.l63KuhwM015099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729AbXGCU5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 16:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     Videopix Frame Grabber: Fix unreleased lock in vfc_debug()
has been added to the -mm tree.  Its filename is
     videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Videopix Frame Grabber: Fix unreleased lock in vfc_debug()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Videopix Frame Grabber: vfc_debug() doesn't release the device lock
when copy_from_user() fails

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sbus/char/vfc_dev.c |    1 +
 1 files changed, 1 insertion(+)

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

kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
git-netdev-all.patch
block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
