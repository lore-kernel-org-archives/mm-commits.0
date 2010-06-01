From: akpm@linux-foundation.org
Subject: + drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:19:03 -0700
Message-ID: <201006012119.o51LJ304019291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757422Ab0FAVTG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:19:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     drivers/message/i2o/exec-osm.c: add missing mutex_unlock
has been added to the -mm tree.  Its filename is
     drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch

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
Subject: drivers/message/i2o/exec-osm.c: add missing mutex_unlock
From: Julia Lawall <julia@diku.dk>

Add a mutex_unlock missing on the error path.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* mutex_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* mutex_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/exec-osm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/message/i2o/exec-osm.c~drivers-message-i2o-exec-osmc-add-missing-mutex_unlock drivers/message/i2o/exec-osm.c
--- a/drivers/message/i2o/exec-osm.c~drivers-message-i2o-exec-osmc-add-missing-mutex_unlock
+++ a/drivers/message/i2o/exec-osm.c
@@ -389,12 +389,16 @@ static int i2o_exec_lct_notify(struct i2
 	dev = &c->pdev->dev;
 
 	if (i2o_dma_realloc(dev, &c->dlct,
-					le32_to_cpu(sb->expected_lct_size)))
+					le32_to_cpu(sb->expected_lct_size))) {
+		mutex_unlock(&c->lct_lock);
 		return -ENOMEM;
+	}
 
 	msg = i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
-	if (IS_ERR(msg))
+	if (IS_ERR(msg)) {
+		mutex_unlock(&c->lct_lock);
 		return PTR_ERR(msg);
+	}
 
 	msg->u.head[0] = cpu_to_le32(EIGHT_WORD_MSG_SIZE | SGL_OFFSET_6);
 	msg->u.head[1] = cpu_to_le32(I2O_CMD_LCT_NOTIFY << 24 | HOST_TID << 12 |
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-media-use-memdup_user.patch
drivers-i2c-use-memdup_user.patch
drivers-ide-use-memdup_user.patch
fs-ubifs-use-err_cast.patch
drivers-net-wireless-prism54-use-memdup_user.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
drivers-staging-dream-camera-use-memdup_user.patch
drivers-usb-gadget-use-memdup_user.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
arch-x86-kernel-add-missing-spin_unlock.patch
arch-ia64-kvm-add-missing-spin_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch
fs-ocfs2-dlm-add-missing-spin_unlock.patch
drivers-staging-vme-bridges-add-missing-unlocks.patch

